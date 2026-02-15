--Disables autospawn
AddEventHandler('onClientMapStart', function()
	exports.spawnmanager:spawnPlayer()
	Citizen.Wait(3000)
	exports.spawnmanager:setAutoSpawn(false)
end)

--RegisterEvents
RegisterNetEvent("CustomDeath:reviveExecute")
RegisterNetEvent("CustomDeath:respawn")
--RegisterNetEvent("CustomDeath:ShowNotification")

--Vars
if TimerColor == nil then
	TimerColor = blue
	print("TimerColor is invalid, changing to default (blue)")
end

if SpawnColor == nil then
	SpawnColor = blue
	print("SpawnColor is invalid, changing to default (blue)")
end

local respawnMinute = RespawnMinute
local respawnSecond = RespawnSecond

spawnPoints = {}

--Death Loop
Citizen.CreateThread(function()
	function createSpawnPoint(x, y, z, heading)
		local newSpawnPoint = {
			x = x,
			y = y,
			z = z,
			heading = heading
		}
		table.insert(spawnPoints, newSpawnPoint)
	end
	
	createSpawnPoint(317.1631, -547.8097, 29.89872, 0)	--Los Angeles City   [1]
	createSpawnPoint(-247.76, 6331.23, 32.43, 0)		--Los Angeles County [2]
	
	while true do
		Citizen.Wait(1000)
		local ped = PlayerPedId()

		if IsEntityDead(ped) then
			SetPlayerInvincible(ped, true)
			SetEntityHealth(ped, 1)
			
			if respawnMinute >= 0 then
				showOnScreenMessage(TimerColor, "You can respawn in " .. string.format("%02d:%02d", respawnMinute, respawnSecond))
				
				if respawnSecond == 0 then
					respawnMinute = respawnMinute - 1
					respawnSecond = 60
				end
				respawnSecond = respawnSecond - 1
			else
				TriggerEvent("CustomDeath:respawn", ped)
			end
		end
	end
end)

--EventHandlers
AddEventHandler("CustomDeath:reviveExecute", function(playerName, source)
	local ped = PlayerPedId()
	
	if GetEntityHealth(ped) <= 1 then --if player is dead
		revivePed(ped)
		resetTime()
		Exports["Noty"].Noty(
		    "You've Been Revived",
		    playerName .. ", you've been revived. " .. source .. " has revived you — don't die again~!",
		    5000,
		    "success"
        )

		TriggerServerEvent("CustomDeath:revivePlayerSuccessRelay", playerName)
	else
		TriggerServerEvent("CustomDeath:revivePlayerAliveRelay", playerName)
	end
end)

AddEventHandler("CustomDeath:respawn", function()
	local ped = PlayerPedId()
	local loop = true
	
	resetTime()
	
	while loop do
		showOnScreenMessage(SpawnColor, "Select spawn location:\n1 = Los Angeles City, 2 = Los Angeles County")
		
		if IsControlJustPressed(1, 157) then		--1
			respawnPed(ped, spawnPoints[1])			--City
			loop = false
		elseif IsControlJustPressed(1, 158) then	--2
			respawnPed(ped, spawnPoints[2])			--County
			loop = false
		end
	end
end)

--AddEventHandler("CustomDeath:ShowNotification", function(str)
--	ShowNotification(str)
--end)

--Functions
function ShowNotification(color, message)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(color .. message)
	DrawNotification(true, false)
end

function showOnScreenMessage(color, message)
	local scaleform = RequestScaleformMovie("MP_BIG_MESSAGE_FREEMODE")
	
	if HasScaleformMovieLoaded(scaleform) then
		Citizen.Wait(0)
		PushScaleformMovieFunction(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
		BeginTextComponent("STRING")
		AddTextComponentString(color .. message)
		EndTextComponent()
		PopScaleformMovieFunctionVoid()
	end
end

function revivePed(ped)
	NetworkResurrectLocalPlayer(GetEntityCoords(ped, true), true, true, false)
	SetPlayerInvincible(ped, false)
	ClearPedBloodDamage(ped)
end

function respawnPed(ped, coords)
	SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, coords.heading, true, false) 
	
	SetPlayerInvincible(ped, false) 
	
	TriggerEvent("playerSpawned", coords.x, coords.y, coords.z, coords.heading)
	ClearPedBloodDamage(ped)
end

function resetTime()
	respawnMinute = RespawnMinute
	respawnSecond = RespawnSecond
end

