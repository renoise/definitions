---@meta
---Do not try to execute this file. It's just a type definition file.
---
---Please read the introduction at https://github.com/renoise/xrnx/
---to get an overview about the complete API, and scripting for
---Renoise in general...
---

--------------------------------------------------------------------------------
---## renoise.SampleDeviceChain

---@class renoise.SampleDeviceChain
renoise.SampleDeviceChain = {}

---### properties

---@class renoise.SampleDeviceChain
---
---Name of the audio effect chain.
---@field name string
---@field name_observable renoise.Document.Observable
---
---**READ-ONLY** Allowed, available devices for 'insert_device_at'.
---@field available_devices string[]
---
---**READ-ONLY** Returns a list of tables containing more information about
---the devices.
---@see renoise.Track.available_device_infos
---@field available_device_infos AudioDeviceInfo[]
---
---**READ-ONLY** Device access.
---@field devices renoise.AudioDevice[]
---@field devices_observable renoise.Document.Observable
---
---**READ-ONLY** Output routing.
---@field available_output_routings string[]
---
---One of 'available_output_routings'
---@see renoise.SampleDeviceChain.available_output_routings
---@field output_routing string
---@field output_routing_observable renoise.Document.Observable

---### functions

---Insert a new device at the given position. "device_path" must be one of
---@see renoise.SampleDeviceChain.available_devices
---@param device_path string
---@param index integer
---@return any new_device
function renoise.SampleDeviceChain:insert_device_at(device_path, index) end

---Delete an existing device from a chain. The mixer device at index 1 can not
---be deleted.
---@param index integer
function renoise.SampleDeviceChain:delete_device_at(index) end

---Swap the positions of two devices in the device chain. The mixer device at
---index 1 can not be swapped or moved.
---@param index1 integer
---@param index2 integer
function renoise.SampleDeviceChain:swap_devices_at(index1, index2) end

---Access to a single device in the chain.
---@param index integer
---@return renoise.AudioDevice
function renoise.SampleDeviceChain:device(index) end
