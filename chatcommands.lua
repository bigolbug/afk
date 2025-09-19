core.register_chatcommand("afk", {
	params = "<on|off>",
	description = "Enable or disable AFK prevention mod",
	privs = {server = true},
	func = function(name, param)
		if param == "on" then
			afk.set_enabled(true)
			return true, "AFK prevention enabled."
		elseif param == "off" then
			afk.set_enabled(false)
			return true, "AFK prevention disabled."
        elseif param == "stat" then
			if afk.is_enabled() then 
                local message = "Current Settings"
                message = message .. "\nPlace Period: \t".. afk.place_period
                message = message .. "\nPlace Count: \t".. afk.place_count
                message = message .. "\nWarning Count: \t".. afk.warning_count
                message = message .. "\nBan Period (min): \t".. math.floor(afk.ban_period/60)
                core.chat_send_player(name,core.colorize("#1fFFaf", message))
                return true, "AFK prevention is enabled."
            else
                return true, "AFK prevention is disabled."
            end
		else
			return false, "Usage: /afk <on|off>"
		end
	end,
})
