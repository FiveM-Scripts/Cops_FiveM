require "resources/essentialmode/lib/MySQL"
MySQL:open("localhost", "gta5_gamemode_essential", "root", "")

local inServiceCops = {}

function addCop(identifier)
	MySQL:executeQuery("INSERT INTO police (`identifier`) VALUES ('@identifier')", { ['@identifier'] = identifier})
end

function remCop(identifier)
	MySQL:executeQuery("DELETE FROM police WHERE identifier = '@identifier'", { ['@identifier'] = identifier})
end

function checkIsCop(identifier)
	local query = MySQL:executeQuery("SELECT * FROM police WHERE identifier = '@identifier'", { ['@identifier'] = identifier})
	local result = MySQL:getResults(query, {'rank'}, "identifier")
	
	if(not result[1]) then
		TriggerClientEvent('police:receiveIsCop', source, "inconnu")
	else
		TriggerClientEvent('police:receiveIsCop', source, result[1].rank)
	end
end

function s_checkIsCop(identifier)
	local query = MySQL:executeQuery("SELECT * FROM police WHERE identifier = '@identifier'", { ['@identifier'] = identifier})
	local result = MySQL:getResults(query, {'rank'}, "identifier")
	
	if(not result[1]) then
		return "nil"
	else
		return result[1].rank
	end
end

function checkInventory(target)
	local strResult = GetPlayerName(target).."Search returned : "
	local identifier = ""
    TriggerEvent("es:getPlayerFromId", target, function(player)
		identifier = player.identifier
		local executed_query = MySQL:executeQuery("SELECT * FROM `user_inventory` JOIN items ON items.id = user_inventory.item_id WHERE user_id = '@username'", { ['@username'] = identifier })
		local result = MySQL:getResults(executed_query, { 'quantity', 'libelle', 'item_id', 'isIllegal' }, "item_id")
		if (result) then
			for _, v in ipairs(result) do
				if(v.quantity ~= 0) then
					strResult = strResult .. v.quantity .. " and " .. v.libelle .. ", "
				end
				if(v.isIllegal == "True") then
					TriggerClientEvent('police:dropIllegalItem', target, v.item_id)
				end
			end
		end
		
		strResult = strResult .. " / "
		
		local executed_query = MySQL:executeQuery("SELECT * FROM user_weapons WHERE identifier = '@username'", { ['@username'] = identifier })
		local result = MySQL:getResults(executed_query, { 'weapon_model' }, 'identifier' )
		if (result) then
			for _, v in ipairs(result) do
					strResult = strResult .. "possession of " .. v.weapon_model .. ", "
			end
		end
	end)
	
    return strResult
end

AddEventHandler('playerDropped', function()
	if(inServiceCops[source]) then
		inServiceCops[source] = nil
		
		for i, c in pairs(inServiceCops) do
			TriggerClientEvent("police:resultAllCopsInService", i, inServiceCops)
		end
	end
end)

AddEventHandler('es:playerDropped', function(player)
		local isCop = s_checkIsCop(player.identifier)
		if(isCop ~= "nil") then
			TriggerEvent("jobssystem:disconnectReset", player, 7)
		end
end)

RegisterServerEvent('police:checkIsCop')
AddEventHandler('police:checkIsCop', function()
	TriggerEvent("es:getPlayerFromId", source, function(user)
		local identifier = user.identifier
		checkIsCop(identifier)
	end)
end)

RegisterServerEvent('police:takeService')
AddEventHandler('police:takeService', function()

	if(not inServiceCops[source]) then
		inServiceCops[source] = GetPlayerName(source)
		
		for i, c in pairs(inServiceCops) do
			TriggerClientEvent("police:resultAllCopsInService", i, inServiceCops)
		end
	end
end)

RegisterServerEvent('police:breakService')
AddEventHandler('police:breakService', function()

	if(inServiceCops[source]) then
		inServiceCops[source] = nil
		
		for i, c in pairs(inServiceCops) do
			TriggerClientEvent("police:resultAllCopsInService", i, inServiceCops)
		end
	end
end)

RegisterServerEvent('police:getAllCopsInService')
AddEventHandler('police:getAllCopsInService', function()
	TriggerClientEvent("police:resultAllCopsInService", source, inServiceCops)
end)

RegisterServerEvent('police:checkingPlate')
AddEventHandler('police:checkingPlate', function(plate)
	local executed_query = MySQL:executeQuery("SELECT Nom FROM user_vehicle JOIN users ON user_vehicle.identifier = users.identifier WHERE vehicle_plate = '@plate'", { ['@plate'] = plate })
	local result = MySQL:getResults(executed_query, { 'Nom' }, "identifier")
	if (result[1]) then
		for _, v in ipairs(result) do
			TriggerClientEvent('chatMessage', source, 'GOVERNMENT', {255, 0, 0}, "The vehicle #"..plate.." is the property of " .. v.Nom)
		end
	else
		TriggerClientEvent('chatMessage', source, 'GOVERNMENT', {255, 0, 0}, "The vehicle #"..plate.." isn't register !")
	end
end)

RegisterServerEvent('police:confirmUnseat')
AddEventHandler('police:confirmUnseat', function(t)
	TriggerClientEvent('chatMessage', source, 'GOVERNMENT', {255, 0, 0}, GetPlayerName(t).. " is out !")
	TriggerClientEvent('police:unseatme', t)
end)

RegisterServerEvent('police:targetCheckInventory')
AddEventHandler('police:targetCheckInventory', function(t)
	TriggerClientEvent('chatMessage', source, 'GOVERNMENT', {255, 0, 0}, checkInventory(t))
end)

RegisterServerEvent('police:finesGranted')
AddEventHandler('police:finesGranted', function(t, amount)
	TriggerClientEvent('chatMessage', source, 'GOVERNMENT', {255, 0, 0}, GetPlayerName(t).. " paid a $"..amount.." fines.")
	TriggerClientEvent('police:payFines', t, amount)
end)
RegisterServerEvent('police:convictionGranted')
AddEventHandler('police:convictionGranted', function(t, amount)
	TriggerClientEvent('chatMessage', source, 'GOVERNMENT', {255, 0, 0}, GetPlayerName(t).. " was sent to prison for "..amount.." years.")
	TriggerClientEvent('police:sendToPrison', t, amount)
end)

RegisterServerEvent('police:cuffGranted')
AddEventHandler('police:cuffGranted', function(t)
	--TriggerClientEvent('chatMessage', source, 'GOVERNMENT', {255, 0, 0}, GetPlayerName(t).. " toggle cuff (except if it's a cop :3 ) !")
	TriggerClientEvent('police:getArrested', t)
end)

RegisterServerEvent('police:forceEnterAsk')
AddEventHandler('police:forceEnterAsk', function(t, v)
	TriggerClientEvent('chatMessage', source, 'GOVERNMENT', {255, 0, 0}, GetPlayerName(t).. " get to the car ! (if he's cuffed :) )")
	TriggerClientEvent('police:forcedEnteringVeh', t, v)
end)


-----------------------------------------------------------------------
-----------------EVENT FINE AND ENTER CRIMINAL RECORD------------------
-----------------------------------------------------------------------
--TO DO
-----------------------------------------------------------------------
----------------------EVENT SPAWN POLICE VEH---------------------------
-----------------------------------------------------------------------
RegisterServerEvent('CheckPoliceVeh')
AddEventHandler('CheckPoliceVeh', function(vehicle)
	TriggerEvent('es:getPlayerFromId', source, function(user)

			TriggerClientEvent('FinishPoliceCheckForVeh',source)
			-- Spawn police vehicle
			TriggerClientEvent('policeveh:spawnVehicle', source, vehicle)
	end)
end)

-----------------------------------------------------------------------
---------------------COMMANDE ADMIN AJOUT / SUPP COP-------------------
-----------------------------------------------------------------------
TriggerEvent('es:addGroupCommand', 'copadd', "admin", function(source, args, user)
     if(not args[2]) then
		TriggerClientEvent('chatMessage', source, 'GOVERNMENT', {255, 0, 0}, "Usage : /copadd [ID]")	
	else
		if(GetPlayerName(tonumber(args[2])) ~= nil)then
			local player = tonumber(args[2])
			TriggerEvent("es:getPlayerFromId", player, function(target)
				addCop(target.identifier)
				TriggerClientEvent('chatMessage', source, 'GOVERNMENT', {255, 0, 0}, "Roger that !")
				TriggerClientEvent("es_freeroam:notify", player, "CHAR_ANDREAS", 1, "Government", false, "Congrats, you're now a cop !~w~.")
				TriggerClientEvent('police:nowCop', player)
			end)
		else
			TriggerClientEvent('chatMessage', source, 'GOVERNMENT', {255, 0, 0}, "No player with this ID !")
		end
	end
end, function(source, args, user) 
	TriggerClientEvent('chatMessage', source, 'GOVERNMENT', {255, 0, 0}, "You haven't the permission to do that !")
end)

TriggerEvent('es:addGroupCommand', 'coprem', "admin", function(source, args, user) 
     if(not args[2]) then
		TriggerClientEvent('chatMessage', source, 'GOVERNMENT', {255, 0, 0}, "Usage : /coprem [ID]")	
	else
		if(GetPlayerName(tonumber(args[2])) ~= nil)then
			local player = tonumber(args[2])
			TriggerEvent("es:getPlayerFromId", player, function(target)
				remCop(target.identifier)
				TriggerClientEvent("es_freeroam:notify", player, "CHAR_ANDREAS", 1, "Government", false, "You're no longer a cop !~w~.")
				TriggerClientEvent('chatMessage', source, 'GOVERNMENT', {255, 0, 0}, "Roger that !")
				--TriggerClientEvent('chatMessage', player, 'GOVERNMENT', {255, 0, 0}, "You're no longer a cop !")
				TriggerClientEvent('police:noLongerCop', player)
			end)
		else
			TriggerClientEvent('chatMessage', source, 'GOVERNMENT', {255, 0, 0}, "No player with this ID !")
		end
	end
end, function(source, args, user) 
	TriggerClientEvent('chatMessage', source, 'GOVERNMENT', {255, 0, 0}, "You haven't the permission to do that !")
end)