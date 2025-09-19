local function same_position(pos1, pos2)
    if pos1.x == pos2.x and pos1.y == pos2.y and pos1.z == pos2.z then
        return true
    end
    return false
end

local function clear_old_log_data(name,now,pos)
    --core.chat_send_all("clearing old data")
	if not afk.placement_data[name] then 
        --core.chat_send_all("For some reason placement had no data on ".. name)
        return 
    end
	local new_data = {}
	for time, old_pos in pairs(afk.placement_data[name]) do
        --core.chat_send_all("old time: " .. time .." vs new time "..now)
		if now - time <= afk.place_period and same_position(pos, old_pos) then
			new_data[time] = old_pos
		end
	end
	afk.placement_data[name] = {}
    afk.placement_data[name] = new_data
end

local function count_array(array)
    local count = 0
    for time, pos in pairs(array) do
        count = count + 1
    end
    return count
end

core.register_on_placenode(function(pos, newnode, placer, oldnode, itemstack, pointed_thing)
	if not afk.is_enabled() then return end
	if not placer:is_player() then return end
    local now = os.time()
	local name = placer:get_player_name()
	if not afk.placement_data[name] then
		afk.placement_data[name] = {}
	end

	clear_old_log_data(name,now,pos)
    afk.placement_data[name][tostring(now)] = pos

    local count = count_array(afk.placement_data[name])
    --core.chat_send_all(count.." Placed within ".. afk.place_period)
	if count >= afk.place_count then
        core.kick_player(name, "AFK macro behavior detected.")
        -- add player to banned list
        local banned_players = core.deserialize(afk.metadata:get_string("banned"))
        banned_players[name] = now
        afk.metadata:set_string("banned",core.serialize(banned_players))
    elseif count >= afk.warning_count then
		-- Warn, then kick and ban
		core.chat_send_player(name, core.colorize("#FF5F0F", "[AFK] Suspicious activity detected. Stop or you will be kicked."))
	end
end)

core.register_on_joinplayer(function(ObjectRef, last_login)
    local player_name = ObjectRef:get_player_name()
    if player_name == "" then return end
    local banned_players = core.deserialize(afk.metadata:get_string("banned"))
    if tonumber(banned_players[player_name]) then
        local now = os.time()
        if now - banned_players[player_name] < afk.ban_period then
            local minutes_remaining = math.floor((afk.ban_period - (now - banned_players[player_name]))/60)
            core.after(1,afk.kick_player,player_name)
        else
            banned_players[player_name] = nil
            afk.metadata:set_string("banned",core.serialize(banned_players))
        end 
    end
end)


afk.set_enabled = function(state)
    if state then
        afk.metadata:set_int("enabled",1)
    else
        afk.metadata:set_int("enabled",0)
    end
	
end

afk.is_enabled = function()
    if afk.metadata:get_int("enabled") == 0 then
        return false
    else
        return true
    end
end

function afk.kick_player(player) 
    core.kick_player(player, "You have been banned for AFK, try connecting in a few minutes")
end
