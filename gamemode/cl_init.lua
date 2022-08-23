local _startTime = os.clock()

Sierra = Sierra or {}
Sierra.HUDEnabled = Sierra.HUDEnabled or true

DeriveGamemode("sandbox")

timer.Remove("HintSystem_OpeningMenu")
timer.Remove("HintSystem_Annoy1")
timer.Remove("HintSystem_Annoy2")

hook.Add( "PreDrawHalos", "PropertiesHover", function()
	if ( !IsValid( vgui.GetHoveredPanel() ) || !vgui.GetHoveredPanel():IsWorldClicker() ) then return end

	local ent = properties.GetHovered( EyePos(), LocalPlayer():GetAimVector() )
	if ( !IsValid( ent ) ) then return end

	if ent:GetNoDraw() then
		return
	end

	local c = Color( 255, 255, 255, 255 )
	c.r = 200 + math.sin( RealTime() * 50 ) * 55
	c.g = 200 + math.sin( RealTime() * 20 ) * 55
	c.b = 200 + math.cos( RealTime() * 60 ) * 55

	local t = { ent }
	if ( ent.GetActiveWeapon && IsValid( ent:GetActiveWeapon() ) ) then table.insert( t, ent:GetActiveWeapon() ) end
	halo.Add( t, c, 2, 2, 2, true, false )
end)

RunConsoleCommand("cl_showhints",  "0")
RunConsoleCommand("gmod_mcore_test",  "1")

include("shared.lua")

if(BRANCH != "x86-64") then
	timer.Simple(5, function()
		LocalPlayer():Notify("WARNING!\nYou're playing on default 32-bit Garry's Mod version, consider switching to x86-64-bit. Playing 32-bit may cause framework instability and glitches.")
	end)
	MsgN("You're playing on default 32-bit Garry's Mod version, consider switching to x86-64-bit version for better stability.\nWARNING: Playing on 32-bit may cause framework instability.")
	IsPlayer32 = true 
else
	MsgN("You're playing on x86-64-bit Garry's Mod version.\nBinaries initialized...")
	IsPlayer32 = false
end

MsgC(Color(0, 255, 100, 255), "[Sierra] Client initialized in "..math.Round(os.clock() - _startTime, 3).. " second(s)\n")