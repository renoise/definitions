---@meta
---Do not try to execute this file. It's just a type definition file.
---
---This reference describes the built-in socket support for Lua scripts in
---Renoise. Sockets can be used to send/receive data over process boundaries,
---or exchange data across computers in a network (Internet). The socket API
---in Renoise has server support (which can respond to multiple connected clients)
---and client support (send/receive data to/from a server).
---
---Please read the `Introduction.md` in the Renoise scripting Documentation
---folder first to get an overview about the complete API, and scripting for 
---Renoise in general...
---
---For examples on how to use sockets, have across look at the code snippets in
---the Renoise Documentation "Snippets/Socket.lua"

--------------------------------------------------------------------------------
---## renoise.Socket

---Interfaces for built-in socket support for Lua scripts in Renoise.
---
---Right now UDP and TCP protocols are supported. The class interfaces for UDP
---and TCP sockets behave exactly the same. That is, they don't depend on the
---protocol, so both are easily interchangeable when needed.
renoise.Socket = {}

---### error handling

---All socket functions which can fail, will return an error string as an optional
---second return value. They do not call Lua's error() handler, so you can decide
---yourself how to deal with expected errors like connection timeouts,
---connection failures, and so on. This also means you don't have to "pcall"
---socket functions to handle such "expected" errors.
---
---Logic errors (setting invalid addresses, using disconnected sockets, passing
---invalid timeouts, and so on) will fire Lua's runtime error (abort your scripts
---and spit out an error). If you get such an error, then this usually means you
---did something wrong: fed or used the sockets in a way that does not make sense.
---Never "pcall" such errors, fix the problem instead.

---### constants

---@enum renoise.Socket.Protocol
renoise.Socket = {
  PROTOCOL_TCP = 1,
  PROTOCOL_UDP = 2
}

------ Creating Socket Servers

---Creates a connected UPD or TCP server object. Use "localhost" to use your
---system's default network address. Protocol can be `renoise.Socket.PROTOCOL_TCP`
---or `renoise.Socket.PROTOCOL_UDP` (by default TCP).
---When instantiation and connection succeed, a valid server object is
---returned, otherwise "error" is set and the server object is nil.
---Using the create function with no server_address allows you to create a
---server which allows connections to any address (for example localhost
---and some IP)
---@param server_address string
---@param server_port integer
---@param protocol renoise.Socket.Protocol? Default: renoise.Socket.PROTOCOL_TCP
---@overload fun(server_port: integer, protocol: renoise.Socket.Protocol?):renoise.Socket.SocketServer|nil, string?
---@return renoise.Socket.SocketServer|nil, string?
function renoise.Socket.create_server(server_address, server_port, protocol) end

---Create a connected UPD or TCP client.
---`protocol` can be `renoise.Socket.PROTOCOL_TCP` or
---`renoise.Socket.PROTOCOL_UDP` (by default TCP).
---`timeout` is the time in ms to wait until the connection is established
---(1000 ms by default). When instantiation and connection succeed, a valid client
---object is returned, otherwise "error" is set and the client object is nil
---@param server_address string
---@param server_port integer
---@param protocol renoise.Socket.Protocol? Default: renoise.Socket.PROTOCOL_TCP
---@param timeout integer? Default: 1000
---@return renoise.Socket.SocketClient|nil client, string? error
function renoise.Socket.create_client(server_address, server_port, protocol, timeout) end

--------------------------------------------------------------------------------
---## renoise.Socket.SocketBase

---SocketBase is the base class for socket clients and servers. All
---SocketBase properties and functions are available for servers and clients.
---@class renoise.Socket.SocketBase
---
---**READ-ONLY** Returns true when the socket object is valid and connected. 
---Sockets can manually be closed (see socket:close()). Client sockets can also
---actively be closed/refused by the server. In this case the client:receive()
---calls will fail and return an error.
---@field is_open boolean
---
---**READ-ONLY** The socket's resolved local address (for example "127.0.0.1"
---when a socket is bound to "localhost")
---@field local_address string
---
---**READ-ONLY** The socket's local port number, as specified when instantiated.
---@field local_port number
renoise.Socket.SocketBase = {}

---### functions

---Closes the socket connection and releases all resources. This will make
---the socket useless, so any properties, calls to the socket will result in
---errors. Can be useful to explicitly release a connection without waiting for
---the dead object to be garbage collected, or if you want to actively refuse a
---connection.
function renoise.Socket.SocketBase:close() end

--------------------------------------------------------------------------------
---## renoise.Socket.SocketClient

---A SocketClient can connect to other socket servers and send and receive data
---from them on request. Connections to a server can not change, they are
---specified when constructing a client. You can not reconnect a client; create
---a new client instance instead.
---
---Socket clients in Renoise do block with timeouts to receive messages, and
---assume that you only expect a response from a server after having sent
---something to it (i.e.: GET HTTP).
---To constantly poll a connection to a server, for example in idle timers,
---specify a timeout of 0 in "receive(message, 0)". This will only check if there
---are any pending messages from the server and read them. If there are no pending
---messages it will not block or timeout.
---@class renoise.Socket.SocketClient : renoise.Socket.SocketBase
---
---**READ-ONLY** Address of the socket's peer, the socket address this client
---is connected to.
---@field peer_address string
---
---**READ-ONLY** Port of the socket's peer, the socket this client is 
---connected to.
---@field peer_port number
renoise.Socket.SocketClient = {}

---### functions

---Send a message string (or OSC messages or bundles) to the connected server.
---When sending fails, "success" return value will be false and "error_message"
---is set, describing the error in a human readable format.
---NB: when using TCP instead of UDP as protocol for OSC messages, !no! SLIP
---encoding and no size prefixing of the passed OSC data will be done here.
---So, when necessary, do this manually by your own please.
---@param message string
---@return boolean success, string? error
function renoise.Socket.SocketClient:send(message) end

---@alias SocketReceiveMode "*line"|"*all"|integer
---Receive a message string from the the connected server with the given
---timeout in milliseconds. Mode can be one of "*line", "*all" or a number > 0,
---like Lua's io.read. \param timeout can be 0, which is useful for
---receive("*all"). This will only check and read pending data from the
---sockets queue.
---
---+ mode "*line": Will receive new data from the server or flush pending data
---  that makes up a "line": a string that ends with a newline. remaining data
---  is kept buffered for upcoming receive calls and any kind of newlines
---  are supported. The returned line will not contain the newline characters.
---
---+ mode "*all": Reads all pending data from the peer socket and also flushes
---  internal buffers from previous receive line/byte calls (when present).
---  This will NOT read the entire requested content, but only the current
---  buffer that is queued for the local socket from the peer. To read an
---  entire HTTP page or file you may have to call receive("*all") multiple
---  times until you got all you expect to get.
---
---+ mode "number > 0": Tries reading \param NumberOfBytes of data from the
---  peer. Note that the timeout may be applied more than once, if more than
---  one socket read is needed to receive the requested block.
---
---When receiving fails or times-out, the returned message will be nil and
---error_message is set. The error message is "timeout" on timeouts,
---"disconnected" when the server actively refused/disconnected your client.
---Any other errors are system dependent, and should only be used for display
---purposes.
---
---Once you get an error from receive, and this error is not a "timeout", the
---socket will already be closed and thus must be recreated in order to retry
---communication with the server. Any attempt to use a closed socket will
---fire a runtime error.
---@param mode SocketReceiveMode
---@param timeout_ms number
---@return boolean success, string? error
function renoise.Socket.SocketClient:receive(mode, timeout_ms) end

--------------------------------------------------------------------------------
---## renoise.Socket.SocketServer

---A SocketServer handles one or more clients in the background, interacts
---only with callbacks from connected clients. This background polling can be
---start and stop on request.
---
---The socket server interface in Renoise is asynchronous (callback based), which
---means server calls never block or wait, but are served in the background.
---As soon a connection is established or messages arrive, a set of specified
---callbacks are invoked to respond to messages.
---@class renoise.Socket.SocketServer : renoise.Socket.SocketBase
---
---**READ-ONLY** true while the server is running, else false.
---@field is_running boolean
renoise.Socket.SocketServer = {}


---Notifier table for `renoise.Socket.SocketServer:run`.
---
---All callback properties are optional. So you can, for example, skip specifying
---"socket_accepted" if you have no use for this.
---
---### example:
---```lua
---{
---  socket_error = function(error_message)
---    -- do something with the error message
---  end,
---  socket_accepted = function(client)
---    -- FOR TCP CONNECTIONS ONLY: do something with client
---  end,
---  socket_message = function(client, message)
---    -- do something with client and message
---  end
---}
---```
---@class NotifierTable
---
---An error happened in the servers background thread.
---@field socket_error fun(error_message: string)?
---
---FOR TCP CONNECTIONS ONLY: called as soon as a new client
---connected to your server. The passed socket is a ready to use socket
---object, representing a connection to the new socket.
---@field socket_accepted fun(client: renoise.Socket.SocketClient)?
---
---A message was received from a client: The passed socket is a ready
---to use connection for TCP connections. For UDP, a "dummy" socket is
---passed, which can only be used to query the peer address and port
----> socket.port and socket.address
---@field socket_message fun(client: renoise.Socket.SocketClient, message: string)?


---Custom notifier class for `renoise.Socket.SocketServer:run`.
---Note: You must pass an instance of a class, like server_socket:run(MyNotifier())
---
---All callback properties are optional. So you can, for example, skip specifying
---"socket_accepted" if you have no use for this.
---
---### example:
---```lua
---class "MyNotifier"
---function MyNotifier:__init()
---  -- could pass a server ref or something else here, or simply do nothing
---end
---function MyNotifier:socket_error(error_message)
---  -- do something with the error message
---end
---function MyNotifier:socket_accepted(socket)
---  -- FOR TCP CONNECTIONS ONLY: do something with socket
---end
---function MyNotifier:socket_message(socket, message)
---  -- do something with socket and message
---end
---```
---@class NotifierClass
---@field socket_error fun(self, error_message: string)?
---@field socket_accepted fun(self, socket: renoise.Socket.SocketClient)?
---@field socket_message fun(self, socket: renoise.Socket.SocketClient, message: string)?


---## functions

---Start running the server by specifying a class or table which defines the
---callback functions for the server.
---@param notifier_table NotifierTable|NotifierClass
function renoise.Socket.SocketServer:run(notifier_table) end

---Stop a running server.
function renoise.Socket.SocketServer:stop() end

---Suspends the calling thread by the given timeout, and calls the server's
---callback methods as soon as something has happened in the server while
---waiting. Should be avoided whenever possible.
---@param timeout number Timeout in ms
function renoise.Socket.SocketServer:wait(timeout) end
