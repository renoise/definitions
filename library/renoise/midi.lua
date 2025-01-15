---@meta
error("Do not try to execute this file. It's just a type definition file.")
---
---Please read the introduction at https://github.com/renoise/xrnx/
---to get an overview about the complete API, and scripting for
---Renoise in general...
---
---For some simple examples on how to use MIDI IO in Renoise, have a look at the
---"Snippets/Midi.lua" file in the Renoise script Documentation folder.
---

--------------------------------------------------------------------------------
---## renoise.Midi

---Raw MIDI IO support for scripts in Renoise; the ability to send and receive
---MIDI data.
---@class renoise.Midi
renoise.Midi = {}

---### error handling

---When accessing a new device, not used by Renoise nor by your or other scripts,
---Renoise will try to open that device's driver. If something goes wrong an error
---will be shown to the user. Something like ("MIDI Device Foo failed to open
---(error)"). In contrast, none of the MIDI API functions will fail. In other
---words, if a "real" device fails to open this is not your problem, but the user's
---problem. This is also the reason why none of the MIDI API functions return error
---codes.
---
---All other types of logic errors, such as sending MIDI to a manually closed
---device, sending bogus messages and so on, will be fired as typical Lua runtime
---errors.

---### enumeration

---Return a list of strings with currently available MIDI input devices.
---This list can change when devices are hot-plugged.
---See `renoise.Midi.devices_changed_observable`
---@return string[]
function renoise.Midi.available_input_devices() end

---Return a list of strings with currently available MIDI output devices.
---This list can change when devices are hot-plugged.
---See `renoise.Midi.devices_changed_observable`
---@return string[]
function renoise.Midi.available_output_devices() end

---Fire notifications as soon as new devices become active or a previously
---added device gets removed/unplugged.
---This will only happen on Linux and OSX with real devices. On Windows this
---may happen when using ReWire slaves. ReWire adds virtual MIDI devices to
---Renoise.
---Already opened references to devices which are no longer available will
---do nothing: ou can use them as before and they will not fire any errors.
---The messages will simply go into the void...
---@return renoise.Document.Observable
function renoise.Midi.devices_changed_observable() end

---### creation

---@alias MidiMessage integer[]
---@alias MidiMessageFunction fun(message: MidiMessage)
---@alias MidiMessageMemberContext table|userdata
---@alias MidiMessageMemberFunction fun(self: MidiMessageMemberContext, message: MidiMessage)
---@alias MidiMessageMethod1 {[1]:MidiMessageMemberContext, [2]:MidiMessageMemberFunction}
---@alias MidiMessageMethod2 {[1]:MidiMessageMemberFunction, [2]:MidiMessageMemberContext}

---Listen to incoming MIDI data: opens access to a MIDI input device by
---specifying a device name.
---Name must be one of `renoise.Midi.available_input_devices()`.
---
---One or both callbacks should be valid, and should either point to a function
---with one parameter `function (message: number[]) end`, or a table with an object
---and class `{context, function(context, message: number[]) end}` -> a method.
---
---All MIDI messages except active sensing will be forwarded to the callbacks.
---When Renoise is already listening to this device, your callback *and* Renoise
---(or even other scripts) will handle the message.
---
---Messages are received until the device reference is manually closed (see
---renoise.Midi.MidiDevice:close()) or until the MidiInputDevice object gets garbage
---collected.
---@param device_name string
---@param callback (MidiMessageFunction|MidiMessageMethod1|MidiMessageMethod2)?
---@param sysex_callback (MidiMessageFunction|MidiMessageMethod1|MidiMessageMethod2)?
---@return renoise.Midi.MidiInputDevice
function renoise.Midi.create_input_device(device_name, callback, sysex_callback) end

---Open access to a MIDI device by specifying the device name.
---Name must be one of `renoise.Midi.available_input_devices()`.
---All other device names will fire an error.
---
---The real device driver gets automatically closed when the MidiOutputDevice
---object gets garbage collected or when the device is explicitly closed
---via midi_device:close() and nothing else references it.
---@param device_name string
---@return renoise.Midi.MidiOutputDevice
function renoise.Midi.create_output_device(device_name) end

--------------------------------------------------------------------------------

---Baseclass of renoise.Midi.MidiIn/OutDevice with common properties for MIDI
---input and output devices.
---@class renoise.Midi.MidiDevice
---
---Returns true while the device is open (ready to send or receive messages).
---Your device refs will never be auto-closed, "is_open" will only be false if
---you explicitly call "midi_device:close()" to release a device.
---@field is_open boolean
---
---The name of a device. This is the name you create a device with via
---`renoise.Midi.create_input_device` or `renoise.Midi.create_output_device`.
---@field name string
renoise.Midi.MidiDevice = {}

---### functions

---Close a running MIDI device. When no other client is using a device, Renoise
---will also shut off the device driver so that, for example, Windows OS other
---applications can use the device again. This is automatically done when
---scripts are closed or your device objects are garbage collected.
function renoise.Midi.MidiDevice:close() end

--------------------------------------------------------------------------------

---Midi device interface for receiving MIDI messages.
---Instances are created via `renoise.Midi.create_input_device`
---@class renoise.Midi.MidiInputDevice : renoise.Midi.MidiDevice
renoise.Midi.MidiInputDevice = {}

--------------------------------------------------------------------------------

---Midi device interface for sending MIDI messages.
---Instances are created via `renoise.Midi.create_output_device`
---@class renoise.Midi.MidiOutputDevice : renoise.Midi.MidiDevice
renoise.Midi.MidiOutputDevice = {}

---### functions

---Send raw 1-3 byte MIDI messages or sysex messages. Message is expected
---to be an array of numbers. It must not be empty and can only contain
---numbers >= 0 and <= 0xFF (bytes). Sysex messages must be sent in one block,
---and must start with 0xF0, and end with 0xF7.
---@param message integer[]
function renoise.Midi.MidiOutputDevice:send(message) end
