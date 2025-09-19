AFK Prevention Mod for Luanti
=============================

This mod prevents players from using macros or automation to place and break items continuously.

Features:
---------
- Monitors item placement frequency per player.
- If a player places more than `place_count` items in `place_period` seconds, they will be:
  1. Warned with a red chat message.
  2. Kicked from the server.
  3. Banned by name for 10 minutes.

Settings:
---------
Set these in `minetest.conf` or via Luanti server config UI:
- afk.place_count = 50
- afk.place_period = 30

Chat Commands:
--------------
- `/afk on` — Enable the mod
- `/afk off` — Disable the mod

Files:
------
- mod.conf
- init.lua
- api.lua
- chatcommands.lua
- settingtypes.txt
- ReadMe.txt
