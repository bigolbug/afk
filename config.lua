afk = {}
afk.place_count = tonumber(core.settings:get("afk.place_count")) or 15
afk.place_period = tonumber(core.settings:get("afk.place_period")) or 30
afk.ban_period = 60 --tonumber(core.settings:get("afk.ban_period")) or 600
afk.warning_count = afk.place_count - 5
afk.metadata = core.get_mod_storage()
afk.placement_data = {} -- Store metadata: player name -> {timestamps
afk.banned_players = afk.metadata:get_string("banned")
if afk.banned_players == "" then
    afk.metadata:set_string("banned",core.serialize({}))
end
