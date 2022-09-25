

local Keys = {
 ["DELETE"] = 178
}

local idVisable = true
ESX = nil


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	Citizen.Wait(2000)
	ESX.TriggerServerCallback('viperscoreboard:getConnectedPlayers', function(connectedPlayers, maxplayers)
		UpdatePlayerTable(connectedPlayers, maxplayers)
	end)
end)

RegisterNetEvent('viperscoreboard:updateConnectedPlayers')
AddEventHandler('viperscoreboard:updateConnectedPlayers', function(connectedPlayers, maxplayers)
	UpdatePlayerTable(connectedPlayers, maxplayers)
end)


function UpdatePlayerTable(connectedPlayers, maxplayers)
    local formattedPlayerList = {}
    local totalPlayers = 0
    for i,v in pairs(connectedPlayers) do
        table.insert(formattedPlayerList, ('{"id": "%s", "name": "%s"}'):format(v.id, v.name, v.ping))
        totalPlayers = totalPlayers + 1
    end
    SendNUIMessage({
        action  = 'updatePlayerList',
        players = formattedPlayerList,
        maxplayers = maxplayers
    })
end



Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if IsDisabledControlJustReleased(0, Keys['DELETE']) and IsInputDisabled(0) then
			ToggleScoreBoard()
			Citizen.Wait(200)

		elseif IsDisabledControlJustReleased(0, 172) and not IsInputDisabled(0) then
			ToggleScoreBoard()
			Citizen.Wait(200)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(300)

		if IsPauseMenuActive() and not IsPaused then
			IsPaused = true
			SendNUIMessage({
				action  = 'close'
			})
		elseif not IsPauseMenuActive() and IsPaused then
			IsPaused = false
		end
	end
end)

function ToggleScoreBoard()
	SendNUIMessage({
		action = 'toggle'
	})
end

function pageLister(action)
	SendNUIMessage({
		action = action
	})
end

Citizen.CreateThread(function()
	local playMinute, playHour = 0, 0

	while true do
		Citizen.Wait(1000 * 60) 
		playMinute = playMinute + 1

		if playMinute == 60 then
			playMinute = 0
			playHour = playHour + 1
		end

		SendNUIMessage({
			action = 'updateServerInfo',
			playTime = string.format("%02dh %02dm", playHour, playMinute)
		})
	end
end)
