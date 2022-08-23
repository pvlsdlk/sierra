hook.Add("PlayerInitialSpawn", "SierraSteamIDSpoof", function(ply)
    timer.Simple(0, function()
        if IsValid(ply) == false or ply:IsBot() or ply:IsListenServerHost() or ply.IsFullyAuthenticated == nil or ply:IsFullyAuthenticated() then return end

        ply:Kick("Your SteamID wasn't fully authenticated, try restarting steam.")
        ply:Kick("SAC - Access Violation\n\nYour SteamID could not be fully authenticated, try restarting steam client.\n ID Token: "..Sierra.SAC.Violations.SteamIDSpoof)
    end)
end)