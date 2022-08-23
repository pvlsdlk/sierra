function GM:PlayerSpawn(ply)
    ply:StripWeapons()
    ply:StripAmmo()
    ply:AllowFlashlight(true)
    ply:GodDisable()
    ply:Freeze(false)
    ply:SetModel("models/player/kleiner.mdl")
    ply:SetWalkSpeed(110)
    ply:SetRunSpeed(210)
    ply:SetCrouchedWalkSpeed(0.5)
    ply:SetSlowWalkSpeed(ply:GetWalkSpeed()/2)

    ply:SetupHands()
    ply:Give("weapon_physgun")
    ply:Give("gmod_tool")
    ply:Give("sierra_hands")
    ply:SelectWeapon("sierra_hands")
end