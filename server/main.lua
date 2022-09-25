ESX = nil
local connectedPlayers, maxPlayers = {}, GetConvarInt('sv_maxclients', 64)

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('viperscoreboard:getConnectedPlayers', function(source, cb)
	cb(connectedPlayers, maxPlayers)
end)

AddEventHandler('esx:playerLoaded', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
		AddPlayerToScoreboard(xPlayer, true)
end)

AddEventHandler('esx:playerDropped', function(playerId)
	connectedPlayers[playerId] = nil

	TriggerClientEvent('viperscoreboard:updateConnectedPlayers', -1, connectedPlayers, maxPlayers)
end)


AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		Citizen.CreateThread(function()
			Citizen.Wait(1000)
			AddPlayersToScoreboard()
		end)
	end
end)

function AddPlayerToScoreboard(xPlayer, update)
	local playerId = xPlayer.source

	connectedPlayers[playerId] = {}
	connectedPlayers[playerId].id = playerId
	connectedPlayers[playerId].name =  GetPlayerName(xPlayer.source)

	if update then
		TriggerClientEvent('viperscoreboard:updateConnectedPlayers', -1, connectedPlayers, maxPlayers)
	end
end

function AddPlayersToScoreboard()
	local players = ESX.GetPlayers()

	for i=1, #players, 1 do
		local xPlayer = ESX.GetPlayerFromId(players[i])
		AddPlayerToScoreboard(xPlayer, false)
	end

	TriggerClientEvent('viperscoreboard:updateConnectedPlayers', -1, connectedPlayers, maxPlayers)
end