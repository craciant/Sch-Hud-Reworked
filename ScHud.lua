------------------------------------------------------------------------------
-- SCHud (Scholar Hud)
-- Original: NeonRAGE / Reworked: Tetsouo
-- Modernized/optimized version with commands
------------------------------------------------------------------------------

_addon.name                  = 'schud'
_addon.author                = 'Original NeonRAGE / Reworked Tetsouo / Edited by Cracient'
_addon.version               = '1.2'
_addon.commands              = { 'schud' } -- Type //schud in-game

local config                 = require('config')
local defaults               = { anchor_x = 800, anchor_y = 1040, hud_scale = 1.0 }
local settings               = config.load('data/settings.xml', defaults)

local texts                  = require('texts')

------------------------------------------------------------------------------
-- HUD Texts
------------------------------------------------------------------------------
local timer_text = texts.new("", { name = 'SCHud_timer_text' })
local strat_text = texts.new("", { name = 'SCHud_strat_text' })

------------------------------------------------------------------------------
-- HUD Scale (zoom). 1.0 = normal
------------------------------------------------------------------------------
local hud_scale              = settings.hud_scale

------------------------------------------------------------------------------
-- HUD Anchor (top-left corner)
------------------------------------------------------------------------------
local anchor_x               = settings.anchor_x
local anchor_y               = settings.anchor_y

-- Base size of the HUD images
local base_width             = 200
local base_height            = 129

-- Internal trackers
local time_start             = 0
local recast_temp            = 0
local vGD, vGDA, vGL, vGLA   = 0, 0, 0, 0

------------------------------------------------------------------------------
-- Constants
------------------------------------------------------------------------------
local SCH_JOB_ID             = 20
local SJ_RESTRICTION_BUFF_ID = 157

-- Zones where subjob is restricted
local restricted_zones       = {
	[298] = true, -- Odyssey Sheol Gaol
	[39]  = true, -- Dynamis - Valkurm
	[40]  = true, -- Dynamis - Buburimu
	[41]  = true, -- Dynamis - Qufim
	[42]  = true -- Dynamis - Tavnazia
}

------------------------------------------------------------------------------
-- Utility: Convert (x,y) to scaled coords around the anchor
------------------------------------------------------------------------------
local function scale_position(x, y)
	local offset_x = x - anchor_x
	local offset_y = y - anchor_y
	return anchor_x + offset_x * hud_scale, anchor_y + offset_y * hud_scale
end

------------------------------------------------------------------------------
-- Create a text object with scaling
------------------------------------------------------------------------------
local function create_text_object(text_obj, x, y, visible, alpha)
	local sx, sy = scale_position(x, y)

	texts.visible(text_obj, visible)
	texts.pos(text_obj, sx, sy)
	texts.bg_alpha(text_obj, 0)
	texts.size(text_obj, math.floor(16 * hud_scale))
	texts.font(text_obj, 'Arial')
	texts.color(text_obj, 71, 41, 1)
	texts.bold(text_obj, true)
	texts.stroke_alpha(text_obj, 255)
	texts.stroke_width(text_obj, 1)
	texts.stroke_color(text_obj, 255, 255, 255)
	texts.alpha(text_obj, alpha)
end

------------------------------------------------------------------------------
-- Create a prim (image) with scaling
------------------------------------------------------------------------------
local function create_prim(name, color, texture)
	windower.prim.create(name)
	windower.prim.set_color(name, color, color, color, color)
	windower.prim.set_fit_to_texture(name, false)
	windower.prim.set_texture(name, windower.addon_path .. 'assets/' .. texture)
	windower.prim.set_repeat(name, 1, 1)
	windower.prim.set_visibility(name, false)

	local px, py = scale_position(anchor_x, anchor_y)
	windower.prim.set_position(name, px, py)
	windower.prim.set_size(name, base_width * hud_scale, base_height * hud_scale)
end

------------------------------------------------------------------------------
-- Delete existing HUD graphics
------------------------------------------------------------------------------
local function delete_prims(...)
	for _, prim_name in ipairs({ ... }) do
		windower.prim.delete(prim_name)
	end
end

------------------------------------------------------------------------------
-- Fully rebuild (reload) the HUD elements with current anchor/scale
------------------------------------------------------------------------------
local function reload_hud()
	-- 1) Delete old prims
	delete_prims('grimoire-d', 'grimoire-da', 'grimoire-l', 'grimoire-la')

	-- 2) Recreate prims
	create_prim('grimoire-d', vGD, 'Grimoire-Dark.png')
	create_prim('grimoire-da', vGDA, 'Grimoire-DarkAdd.png')
	create_prim('grimoire-l', vGL, 'Grimoire-Light.png')
	create_prim('grimoire-la', vGLA, 'Grimoire-LightAdd.png')

	-- 3) Recreate text objects
	create_text_object(timer_text, anchor_x + 148, anchor_y + 87, false, nil)
	create_text_object(strat_text, anchor_x + 27, anchor_y + 87, true, 50)
end

------------------------------------------------------------------------------
-- Toggle HUD visibility
------------------------------------------------------------------------------
local function set_hud_visibility(is_visible)
	windower.prim.set_visibility('grimoire-d', is_visible)
	windower.prim.set_visibility('grimoire-da', is_visible)
	windower.prim.set_visibility('grimoire-l', is_visible)
	windower.prim.set_visibility('grimoire-la', is_visible)
	texts.visible(timer_text, is_visible)
	texts.visible(strat_text, is_visible)
end

------------------------------------------------------------------------------
-- Checks
------------------------------------------------------------------------------
local function is_zone_restricted(zone_id)
	return restricted_zones[zone_id] or false
end

local function is_sj_restricted()
	local buffs = windower.ffxi.get_player().buffs
	for _, b in ipairs(buffs) do
		if b == SJ_RESTRICTION_BUFF_ID then
			return true
		end
	end
	return false
end

local function is_buff_active(buff_id)
	for _, b in ipairs(windower.ffxi.get_player().buffs) do
		if b == buff_id then
			return true
		end
	end
	return false
end

------------------------------------------------------------------------------
-- Visibility logic (main job SCH or sub job SCH, outside restricted zones)
------------------------------------------------------------------------------
local function update_visibility(main_id, sub_id, sub_lvl, zone_id)
	-- If main job is SCH, always show
	if main_id == SCH_JOB_ID then
		set_hud_visibility(true)
		return
	end

	-- Else check zone restrictions
	if is_zone_restricted(zone_id) then
		if sub_lvl == 0 then
			set_hud_visibility(false)
		else
			set_hud_visibility(sub_id == SCH_JOB_ID)
		end
	else
		set_hud_visibility(sub_id == SCH_JOB_ID)
	end
end

local function update_visibility_with_buff_check()
	local player = windower.ffxi.get_player()
	if not player then
		set_hud_visibility(false)
		return
	end

	local zone_id = windower.ffxi.get_info().zone

	if player.main_job_id == SCH_JOB_ID then
		set_hud_visibility(true)
	elseif is_sj_restricted() then
		set_hud_visibility(false)
	else
		update_visibility(player.main_job_id, player.sub_job_id, player.sub_job_level or 0, zone_id)
	end
end

------------------------------------------------------------------------------
-- SCH recast info based on level and job points
------------------------------------------------------------------------------
local function get_sch_recast_info(level, jp_spent)
	if jp_spent >= 550 then
		return 33, 5
	elseif level >= 90 then
		return 48, 5
	elseif level >= 70 then
		return 60, 4
	elseif level >= 50 then
		return 80, 3
	elseif level >= 30 then
		return 120, 2
	else
		return 240, 1
	end
end

------------------------------------------------------------------------------
-- Main HUD update function (stratagem counts, timer)
------------------------------------------------------------------------------
function ability_hud()
	local player = windower.ffxi.get_player()
	if not player then return end

	local main_job                     = player.main_job
	local sub_job                      = player.sub_job
	local sch_jp_spent                 = (player.job_points and player.job_points.sch and player.job_points.sch.jp_spent) or
		0
	local recast                       = windower.ffxi.get_ability_recasts()[231] or 0
	local recast_interval, max_charges = 240, 0

	if main_job == 'SCH' then
		recast_interval, max_charges = get_sch_recast_info(player.main_job_level, sch_jp_spent)
	elseif sub_job == 'SCH' then
		recast_interval, max_charges = get_sch_recast_info(player.sub_job_level, sch_jp_spent)
		max_charges                  = math.min(max_charges or 3, 3)
		recast_interval              = math.max(recast_interval or 80, 80)
	else
		return
	end

	local function set_visuals(vd, vda, vl, vla, alpha, stroke_a)
		texts.alpha(strat_text, alpha)
		texts.stroke_alpha(strat_text, stroke_a)
		windower.prim.set_color('grimoire-d', vd, vd, vd, vd)
		windower.prim.set_color('grimoire-da', vda, vda, vda, vda)
		windower.prim.set_color('grimoire-l', vl, vl, vl, vl)
		windower.prim.set_color('grimoire-la', vla, vla, vla, vla)
	end

	local function set_strat_count(rec, rec_int, m_charges)
		local count = m_charges
		if rec == 0 then
			count = m_charges
		elseif rec < rec_int then
			count = m_charges - 1
		elseif rec < 2 * rec_int then
			count = m_charges - 2
		elseif rec < 3 * rec_int then
			count = m_charges - 3
		elseif rec < 4 * rec_int then
			count = m_charges - 4
		else
			count = 0
		end
		texts.text(strat_text, tostring(count))
		return (rec % rec_int)
	end

	local arts_visuals = {
		[359]   = { 255, 0, 0, 0, 255, 255 }, -- Dark Arts
		[358]   = { 0, 0, 255, 0, 255, 255 }, -- Light Arts
		[401]   = { 0, 0, 0, 255, 255, 255 }, -- Addendum: White
		[402]   = { 0, 255, 0, 0, 255, 255 }, -- Addendum: Black
		default = { 0, 0, 100, 0, 50, 100 } -- No Arts
	}

	-- Which buff is active?
	local active_visual = arts_visuals.default
	for buff_id, color_set in pairs(arts_visuals) do
		if buff_id ~= 'default' and is_buff_active(buff_id) then
			active_visual = color_set
			break
		end
	end

	set_visuals(unpack(active_visual))

	recast_temp = set_strat_count(recast, recast_interval, max_charges)

	if recast > 0 then
		local seconds = math.floor(recast_temp + 0.5)
		texts.visible(timer_text, true)
		texts.text(timer_text, string.format("%02d", seconds))
	else
		texts.visible(timer_text, false)
	end
end

------------------------------------------------------------------------------
-- Windower Events
------------------------------------------------------------------------------
windower.register_event('gain buff', function(buff_id)
	if buff_id == SJ_RESTRICTION_BUFF_ID then
		update_visibility_with_buff_check()
	end
end)

windower.register_event('lose buff', function(buff_id)
	if buff_id == SJ_RESTRICTION_BUFF_ID then
		update_visibility_with_buff_check()
	end
end)

-- On addon load
windower.register_event('load', function()
	reload_hud()
	update_visibility_with_buff_check()
end)

windower.register_event('job change', function()
	update_visibility_with_buff_check()
end)

windower.register_event('zone change', function()
	update_visibility_with_buff_check()
end)

windower.register_event('login', function()
	update_visibility_with_buff_check()
end)

-- Update HUD periodically
windower.register_event('prerender', function()
	if os.time() > time_start then
		time_start = os.time()
		ability_hud()
	end
end)


windower.register_event('logout', function()
	set_hud_visibility(false)
end)

--------------------------------------------------------------------------------
-- Addon Commands
-- Usage examples:
--   //schud help
--   //schud scale 1.2
--   //schud pos 1000 500
--------------------------------------------------------------------------------
windower.register_event('addon command', function(command, ...)
	command = command and command:lower() or 'help'
	local args = { ... }

	if command == 'help' then
		windower.add_to_chat(207, 'SCHud - Available commands:')
		windower.add_to_chat(207, '//schud help')
		windower.add_to_chat(207, '//schud scale <number>')
		windower.add_to_chat(207, '//schud pos <x> <y>')
		windower.add_to_chat(207, 'Default anchor position: (800, 1040)')
		windower.add_to_chat(207, 'Example: //schud scale 1.25')
		windower.add_to_chat(207, 'Example: //schud pos 900 1050')
	elseif command == 'scale' then
		local new_scale = tonumber(args[1])
		if new_scale then
			hud_scale = new_scale
			settings.hud_scale = new_scale
			config.save(settings) -- Sauvegarde dans settings.xml

			windower.add_to_chat(207, '[SCHud] Scale set to ' .. hud_scale)
			reload_hud()
			update_visibility_with_buff_check()
		else
			windower.add_to_chat(207, '[SCHud] Invalid scale. Use a number, e.g. 0.5 or 1.5.')
		end
	elseif command == 'pos' then
		local x = tonumber(args[1])
		local y = tonumber(args[2])
		if x and y then
			anchor_x = x
			anchor_y = y
			settings.anchor_x = x
			settings.anchor_y = y
			config.save(settings) -- Sauvegarde dans settings.xml

			windower.add_to_chat(207, string.format('[SCHud] Position set to (%d, %d).', anchor_x, anchor_y))
			reload_hud()
			update_visibility_with_buff_check()
		else
			windower.add_to_chat(207, '[SCHud] Invalid position. Usage: //schud pos <x> <y>')
		end
	else
		windower.add_to_chat(207, '[SCHud] Unknown command. Type //schud help for a list of commands.')
	end
end)


------------------------------------------------------------------------------
-- Clean shutdown: hide + destroy texts, hide + delete prims
------------------------------------------------------------------------------
local function cleanup_hud()
 -- 1) Hide HUD (prevents one-frame artifacts)
 pcall(set_hud_visibility, false)

 -- 2) Clear and destroy text objects
 if timer_text then
	 pcall(texts.visible, timer_text, false)
	 pcall(texts.text, timer_text, "")
	 pcall(texts.destroy, timer_text)
 end

 if strat_text then
	 pcall(texts.visible, strat_text, false)
	 pcall(texts.text, strat_text, "")
	 pcall(texts.destroy, strat_text)
 end

 -- 3) Delete all known image prims (authoritative path)
 pcall(delete_prims, 'grimoire-d', 'grimoire-da', 'grimoire-l', 'grimoire-la')

 -- 4) Hard fallback: delete by name again (covers weird partial states)
 for _, p in ipairs({ 'grimoire-d', 'grimoire-da', 'grimoire-l', 'grimoire-la' }) do
	 pcall(windower.prim.set_visibility, p, false)
	 pcall(windower.prim.delete, p)
 end
end

-- Unload / cleanup
windower.register_event('unload', function()
    cleanup_hud()
end)

