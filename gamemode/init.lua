local _startTime = os.clock()

Sierra = Sierra or {}
DeriveGamemode("sandbox")

RunConsoleCommand("sv_allowupload", "0")
RunConsoleCommand("sv_allowdownload", "0")
RunConsoleCommand("sv_allowcslua", "0")

AddCSLuaFile("shared.lua")
include("shared.lua")

function GM:GetGameDescription()
    return "Riverfox: Half-Life 2 Roleplay"
end

hook.Add("PlayerSpawnSENT", "SierraDebugHook", function()
    return true
end)

MsgC(Color(0, 255, 100, 255), "[Sierra] Server initialized in "..math.Round(os.clock() - _startTime, 3).. " second(s)\n")