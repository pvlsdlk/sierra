local _startTime = os.clock()

GM.Name = "Riverfox: Half-Life 2 Roleplay"
GM.Author = "Sturm & Other contributors"
GM.Website = "https://discord.com"
Sierra.GameVersion = "0.1"
Sierra.DeveloperVersion = true

if(SERVER) then
    concommand.Remove("gm_save")
	concommand.Remove("gmod_admin_cleanup")
	RunConsoleCommand("sv_defaultdeployspeed", 1)
end

local function _debuginfo(txt)
	if(Sierra.DeveloperVersion) then
		MsgC(Color(0, 255, 100, 255), "[*] ", color_white, txt.."\n")
	end
end

function widgets.PlayerTick()
end
hook.Remove("PlayerTick", "TickWidgets")

function Sierra.LoadFrameworkFile(fileName)
	if fileName:find("sv_") then
		if (SERVER) then
			_debuginfo("Serverside include: "..fileName)
			include(fileName)
		end
	elseif fileName:find("sh_") then
		if (SERVER) then
			_debuginfo("Shared adding for download: "..fileName)
			AddCSLuaFile(fileName)
		end
		include(fileName)
	elseif fileName:find("cl_") then
		if (SERVER) then
			_debuginfo("Client adding for download: "..fileName)
			AddCSLuaFile(fileName)
		else
			include(fileName)
		end
	elseif fileName:find("rq_") then
		_debuginfo("RQ adding for download: "..fileName)
		if (SERVER) then
			AddCSLuaFile(fileName)
		end

		_G[string.sub(fileName, 26, string.len(fileName) - 4)] = include(fileName)
	end
end

function Sierra.LoadFrameworkFolder(directory)
	for k, v in ipairs(file.Find(directory.."/*.lua", "LUA")) do
		_debuginfo("Checking directory: "..directory)
    	Sierra.LoadFrameworkFile(directory.."/"..v)
	end
end

MsgC(Color(0, 255, 100, 255), "[Sierra] ", color_white, "Loading libraries...\n")
Sierra.LoadFrameworkFile("sierra/lib/sh_netstream.lua")
Sierra.LoadFrameworkFolder("sierra/lib")
MsgC(Color(0, 255, 100, 255), "[Sierra] ", color_white, "Loading SAC...\n")
Sierra.LoadFrameworkFolder("sierra/lib/sac")
MsgC(Color(0, 255, 100, 255), "[Sierra] ", color_white, "Loading game source...\n")
Sierra.LoadFrameworkFolder("sierra/game/hook")
Sierra.LoadFrameworkFolder("sierra/game/interface")
Sierra.LoadFrameworkFolder("sierra/game/faction")

MsgC(Color(0, 255, 100, 255), "[Sierra] Shared initialized in "..math.Round(os.clock() - _startTime, 3).. " second(s)\n")