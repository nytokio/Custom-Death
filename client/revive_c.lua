RegisterNetEvent("CustomDeath:revive")
RegisterNetEvent("CustomDeath:revivePlayerNotFound")
RegisterNetEvent("CustomDeath:revivePlayerSuccess")
RegisterNetEvent("CustomDeath:revivePlayerAlive")
RegisterNetEvent("CustomDeath:permission")

AddEventHandler("CustomDeath:revive", function(args)
    if args[1] == nil then
        Exports["Noty"].Noty("Revive Failed", "Please enter a valid Player ID.", 5000, "warning")
    else 
        TriggerServerEvent("CustomDeath:revivePlayerCheck", args)
    end
end)

AddEventHandler("CustomDeath:revivePlayerNotFound", function(playerServerId)
    Exports["Noty"].Noty(
        "Invalid Player ID",
        "Unable to find a player with the ID: " .. playerServerId,
        5000,
        "error"
    )
end)

AddEventHandler("CustomDeath:revivePlayerSuccess", function(playerName)
    Exports["Noty"].Noty(
        "Player Revived",
        playerName .. " has been revived successfully.",
        5000,
        "success"
    )
end)

AddEventHandler("CustomDeath:revivePlayerAlive", function(playerName)
    Exports["Noty"].Noty(
        "Revive Failed",
        playerName .. " is already alive.",
        5000,
        "error"
    )
end)

AddEventHandler("CustomDeath:permission", function(source)
    Exports["Noty"].Noty(
        "Access Prohibited",
        "You do not have the required permissions to run this command.",
        7000,
        "error"
    )
end)
