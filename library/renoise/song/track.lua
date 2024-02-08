--------------------------------------------------------------------------------
-- renoise.Track
--------------------------------------------------------------------------------

-------- Constants

renoise.Track.TRACK_TYPE_SEQUENCER
renoise.Track.TRACK_TYPE_MASTER
renoise.Track.TRACK_TYPE_SEND
renoise.Track.TRACK_TYPE_GROUP

renoise.Track.MUTE_STATE_ACTIVE
renoise.Track.MUTE_STATE_OFF
renoise.Track.MUTE_STATE_MUTED


-------- Functions

-- Insert a new device at the given position. "device_path" must be one of
-- renoise.song().tracks[].available_devices.
renoise.song().tracks[]:insert_device_at(device_path, device_index)
  -> [newly created renoise.AudioDevice object]
-- Delete an existing device in a track. The mixer device at index 1 can not
-- be deleted from a track.
renoise.song().tracks[]:delete_device_at(device_index)
-- Swap the positions of two devices in the device chain. The mixer device at
-- index 1 can not be swapped or moved.
renoise.song().tracks[]:swap_devices_at(device_index1, device_index2)

-- Access to a single device by index. Use properties 'devices' to iterate 
-- over all devices and to query the device count.
renoise.song().tracks:device(index)
  -> [renoise.AudioDevice object]

-- Uses default mute state from the prefs. Not for the master track.
renoise.song().tracks[]:mute()
renoise.song().tracks[]:unmute()
renoise.song().tracks[]:solo()

-- Note column mutes. Only valid within (1-track.max_note_columns)
renoise.song().tracks[]:column_is_muted(column)
  -> [boolean]
renoise.song().tracks[]:column_is_muted_observable(column)
  -> [Observable object]
renoise.song().tracks[]:set_column_is_muted(column, muted)

-- Note column names. Only valid within (1-track.max_note_columns)
renoise.song().tracks[]:column_name(column)
  -> [string]
renoise.song().tracks[]:column_name_observable(column)
  -> [Observable object]
renoise.song().tracks[]:set_column_name(column, name)

-- Swap the positions of two note or effect columns within a track.
renoise.song().tracks[]:swap_note_columns_at(index1, index2)
renoise.song().tracks[]:swap_effect_columns_at(index1, index2)


-------- Properties

-- Type, name, color.
renoise.song().tracks[].type
  -> [read-only, enum = TRACK_TYPE]
renoise.song().tracks[].name, _observable
  -> [string]
renoise.song().tracks[].color[], _observable
  -> [array of 3 numbers (0-0xFF), RGB]

renoise.song().tracks[].color_blend, _observable
  -> [number, 0-100]

-- Mute and solo states. Not available for the master track.
renoise.song().tracks[].mute_state, _observable
  -> [enum = MUTE_STATE]

renoise.song().tracks[].solo_state, _observable
  -> [boolean]

-- Volume, panning, width.
renoise.song().tracks[].prefx_volume
  -> [renoise.DeviceParameter object]
renoise.song().tracks[].prefx_panning
  -> [renoise.DeviceParameter object]
renoise.song().tracks[].prefx_width
  -> [renoise.DeviceParameter object]

renoise.song().tracks[].postfx_volume
  -> [renoise.DeviceParameter object]
renoise.song().tracks[].postfx_panning
  -> [renoise.DeviceParameter object]

-- Collapsed/expanded visual appearance.
renoise.song().tracks[].collapsed, _observable
  -> [boolean]

-- Returns most immediate group parent or nil if not in a group.
renoise.song().tracks[].group_parent
  -> [renoise.GroupTrack object or nil]

-- Output routing.
renoise.song().tracks[].available_output_routings[]
  -> [read-only, array of strings]
renoise.song().tracks[].output_routing, _observable
  -> [string, one of 'available_output_routings']

-- Delay.
renoise.song().tracks[].output_delay, _observable
  -> [number, -100.0-100.0]

-- Pattern editor columns.
renoise.song().tracks[].max_effect_columns
  -> [read-only, number, 8 OR 0 depending on the track type]
renoise.song().tracks[].min_effect_columns
  -> [read-only, number, 1 OR 0 depending on the track type]

renoise.song().tracks[].max_note_columns
  -> [read-only, number, 12 OR 0 depending on the track type]
renoise.song().tracks[].min_note_columns
  -> [read-only, number, 1 OR 0 depending on the track type]

renoise.song().tracks[].visible_effect_columns, _observable
  -> [number, 1-8 OR 0-8, depending on the track type]
renoise.song().tracks[].visible_note_columns, _observable
  -> [number, 0 OR 1-12, depending on the track type]

renoise.song().tracks[].volume_column_visible, _observable
  -> [boolean]
renoise.song().tracks[].panning_column_visible, _observable
  -> [boolean]
renoise.song().tracks[].delay_column_visible, _observable
  -> [boolean]
renoise.song().tracks[].sample_effects_column_visible, _observable
  -> [boolean]

-- Devices.
renoise.song().tracks[].available_devices[]
  -> [read-only, array of strings]

-- Returns a list of tables containing more information about the devices. 
-- Each table has the following fields:
--  {
--    path,           -- The device's path used by insert_device_at()
--    name,           -- The device's name
--    short_name,     -- The device's name as displayed in shortened lists
--    favorite_name,  -- The device's name as displayed in favorites
--    is_favorite,    -- true if the device is a favorite
--    is_bridged      -- true if the device is a bridged plugin
--  }
renoise.song().tracks[].available_device_infos[]
  -> [read-only, array of strings]

renoise.song().tracks[].devices[], _observable
  -> [read-only, array of renoise.AudioDevice objects]


--------------------------------------------------------------------------------
-- renoise.GroupTrack (inherits from renoise.Track)
--------------------------------------------------------------------------------

-------- Functions

-- All member tracks of this group (including subgroups and their tracks).
renoise.song().tracks[].members[]
  -> [read-only, array of member tracks]

-- Collapsed/expanded visual appearance of whole group.
renoise.song().tracks[].group_collapsed
  -> [boolean]


--------------------------------------------------------------------------------
-- renoise.TrackDevice
--------------------------------------------------------------------------------

-- DEPRECATED - alias for renoise.AudioDevice
