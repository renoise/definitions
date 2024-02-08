--------------------------------------------------------------------------------
-- renoise.SampleDeviceChain
--------------------------------------------------------------------------------

-------- Functions

-- Insert a new device at the given position. "device_path" must be one of
-- renoise.song().instruments[].sample_device_chains[].available_devices.
renoise.song().instruments[].sample_device_chains[]:insert_device_at(
  device_path, index) -> [returns new device]
-- Delete an existing device from a chain. The mixer device at index 1 can not
-- be deleted.
renoise.song().instruments[].sample_device_chains[]:delete_device_at(index)
-- Swap the positions of two devices in the device chain. The mixer device at
-- index 1 can not be swapped or moved.
renoise.song().instruments[].sample_device_chains[]:swap_devices_at(index, index)

-- Access to a single device in the chain.
renoise.song().instruments[].sample_device_chains[]:device(index) 
  -> [renoise.AudioDevice object]


-------- Properties

-- Name of the audio effect chain.
renoise.song().instruments[].sample_device_chains[].name, _observable 
  -> [string]
  
-- Allowed, available devices for 'insert_device_at'.
renoise.song().instruments[].sample_device_chains[].available_devices[]
  -> [read-only, array of strings]
-- Returns a list of tables containing more information about the devices. 
-- see renoise.Track available_device_infos for more info
renoise.song().instruments[].sample_device_chains[].available_device_infos[] 
  -> [read-only, array of device info tables]

-- Device access.
renoise.song().instruments[].sample_device_chains[].devices[], observable 
  -> [read-only, array of renoise.AudioDevice objects]

-- Output routing.
renoise.song().instruments[].sample_device_chains[].available_output_routings[]
  -> [read-only, array of strings]
renoise.song().instruments[].sample_device_chains[].output_routing, _observable
  -> [string, one of 'available_output_routings']
