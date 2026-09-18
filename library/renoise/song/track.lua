---@meta
error("Do not try to execute this file. It's just a type definition file.")
---
---Please read the introduction at https://github.com/renoise/xrnx/
---to get an overview about the complete API, and scripting for
---Renoise in general...
---

--------------------------------------------------------------------------------
---## renoise.Track

---Track component of a Renoise song.
---@class renoise.Track
renoise.Track = {}

---Audio device info
---@class AudioDeviceInfo
---@field path string The device's path used by `renoise.Track:insert_device_at`
---@field name string The device's name
---@field short_name string The device's name as displayed in shortened lists
---@field favorite_name string The device's name as displayed in favorites
---@field is_favorite boolean true if the device is a favorite
---@field is_bridged boolean true if the device is a bridged plugin

---### constants

---@enum renoise.Track.TrackType
---@diagnostic disable-next-line: missing-fields
renoise.Track = {
  TRACK_TYPE_SEQUENCER = 1,
  TRACK_TYPE_MASTER = 2,
  TRACK_TYPE_SEND = 3,
  TRACK_TYPE_GROUP = 4,
}

---@enum renoise.Track.MuteState
---@diagnostic disable-next-line: missing-fields
renoise.Track = {
  MUTE_STATE_ACTIVE = 1,
  MUTE_STATE_OFF = 2,
  MUTE_STATE_MUTED = 3
}

---### properties

---@class renoise.Track
---
---**READ-ONLY**
---@field type renoise.Track.TrackType
---@field name string Name, as visible in track headers
---@field name_observable renoise.Document.Observable **READ-ONLY**
---@field color RGBColor
---@field color_observable renoise.Document.Observable **READ-ONLY**
---Range: (0 - 100) Color blend in percent
---@field color_blend integer
---@field color_blend_observable renoise.Document.Observable **READ-ONLY**
---
---Mute and solo states. Not available for the master track.
---@field mute_state renoise.Track.MuteState
---@field mute_state_observable renoise.Document.Observable **READ-ONLY**
---
---@field solo_state boolean
---@field solo_state_observable renoise.Document.Observable **READ-ONLY**
---
---@field prefx_volume renoise.DeviceParameter **READ-ONLY**
---@field prefx_panning renoise.DeviceParameter **READ-ONLY**
---@field prefx_width renoise.DeviceParameter **READ-ONLY**
---
---@field postfx_volume renoise.DeviceParameter **READ-ONLY**
---@field postfx_panning renoise.DeviceParameter **READ-ONLY**
---
---Collapsed/expanded visual appearance.
---@field collapsed boolean
---@field collapsed_observable renoise.Document.Observable **READ-ONLY**
---
---Returns most immediate group parent or nil if not in a group.
---**READ-ONLY**
---@field group_parent renoise.GroupTrack?
---
---Output routing.
---**READ-ONLY**
---@field available_output_routings string[]
---One of `available_output_routings`
---@field output_routing string
---@field output_routing_observable renoise.Document.Observable **READ-ONLY**
---
---Range: (-100.0-100.0) in ms
---@field output_delay number
---@field output_delay_observable renoise.Document.Observable **READ-ONLY**
---
---8 OR 0 depending on the track type
---**READ-ONLY**
---@field max_effect_columns integer
---1 OR 0 depending on the track type
---**READ-ONLY**
---@field min_effect_columns integer
---12 OR 0 depending on the track type
---**READ-ONLY**
---@field max_note_columns integer
---1 OR 0 depending on the track type
---**READ-ONLY**
---@field min_note_columns integer
---
---1-8 OR 0-8, depending on the track type
---@field visible_effect_columns integer
---@field visible_effect_columns_observable renoise.Document.Observable **READ-ONLY**
---0 OR 1-12, depending on the track type
---@field visible_note_columns integer
---@field visible_note_columns_observable renoise.Document.Observable **READ-ONLY**
---
---@field volume_column_visible boolean
---@field volume_column_visible_observable renoise.Document.Observable **READ-ONLY**
---@field panning_column_visible boolean
---@field panning_column_visible_observable renoise.Document.Observable **READ-ONLY**
---@field delay_column_visible boolean
---@field delay_column_visible_observable renoise.Document.Observable **READ-ONLY**
---@field sample_effects_column_visible boolean
---@field sample_effects_column_visible_observable renoise.Document.Observable **READ-ONLY**
---
---The FX devices this track can handle.
---**READ-ONLY**
---@field available_devices string[]
---Array of tables containing information about the devices.
---**READ-ONLY**
---@field available_device_infos AudioDeviceInfo[]
---
---List of audio DSP FX.
---**READ-ONLY**
---@field devices renoise.AudioDevice[]
---@field devices_observable renoise.Document.ObservableList **READ-ONLY**

---### functions

---Insert a new device at the given position. `device_path` must be one of
---`renoise.Track.available_devices`.
---@param device_path string
---@param device_index integer
---@return renoise.AudioDevice
function renoise.Track:insert_device_at(device_path, device_index) end

---Delete an existing device in a track. The mixer device at index 1 can not
---be deleted from any track.
function renoise.Track:delete_device_at(device_index) end

---Swap the positions of two devices in the device chain. The mixer device at
---index 1 can not be swapped or moved.
---@param device_index1 integer
---@param device_index2 integer
function renoise.Track:swap_devices_at(device_index1, device_index2) end

---Access to a single device by index. Use property `devices` to iterate
---over all devices and to query the device count.
---@param device_index integer
---@return renoise.AudioDevice
function renoise.Track:device(device_index) end

---Uses default mute state from the prefs. Not for the master track.
function renoise.Track:mute() end

function renoise.Track:unmute() end

function renoise.Track:solo() end

---Note column mutes. Only valid within (1-track.max_note_columns)
---@param column_index integer
---@return boolean
function renoise.Track:column_is_muted(column_index) end

---@param column_index integer
---@return renoise.Document.Observable
function renoise.Track:column_is_muted_observable(column_index) end

---@param column_index integer
---@param muted boolean
function renoise.Track:set_column_is_muted(column_index, muted) end

---Note column names. Only valid within (1-track.max_note_columns)
---@param column_index integer
---@return string
function renoise.Track:column_name(column_index) end

---@param column_index integer
---@return renoise.Document.Observable
function renoise.Track:column_name_observable(column_index) end

---@param column_index integer
---@param name string
function renoise.Track:set_column_name(column_index, name) end

---Swap the positions of two note or effect columns within a track.
---@param column_index1 integer
---@param column_index2 integer
function renoise.Track:swap_note_columns_at(column_index1, column_index2) end

---@param column_index1 integer
---@param column_index2 integer
function renoise.Track:swap_effect_columns_at(column_index1, column_index2) end

--------------------------------------------------------------------------------
---## renoise.GroupTrack

---@class renoise.GroupTrack
renoise.GroupTrack = {}

---### properties

---Group track component of a Renoise song.
---All member tracks of this group, including subgroups
---and their tracks.
---@class renoise.GroupTrack
---@field members renoise.Track[] **READ-ONLY**
---Collapsed/expanded visual appearce of whole group.
---@field group_collapsed boolean


--------------------------------------------------------------------------------
---## renoise.TrackDevice

---**Deprecated** Use `renoise.AudioDevice` instead.
---@deprecated
---@alias renoise.TrackDevice renoise.AudioDevice
