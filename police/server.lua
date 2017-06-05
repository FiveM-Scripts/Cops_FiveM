local couchFunctions = {}

if(db.driver == "mysql") then
	require "resources/essentialmode/lib/MySQL"
	MySQL:open(db.sql_host, sql_database, sql_user, sql_password)
elseif(db.driver == "mysql-async") then
	require "resources/mysql-async/lib/MySQL"
elseif(db.driver == "couchdb") then
	TriggerEvent('es:exposeDBFunctions', function(dbExposed)
		couchFunctions = dbExposed
		dbExposed.createDatabase("police", function()end)
	end)
end

local inServiceCops = {}

function addCop(identifier)
	
	if(db.driver == "mysql") then
		local result = "nil"
		local query = MySQL:executeQuery("SELECT * FROM police WHERE identifier = '@identifier'", { ['@identifier'] = identifier})
		local resultq = MySQL:getResults(query, {'rank'}, "identifier")
		
		if(not resultq[1]) then
			result = "nil"
		else
			result = resultq[1].rank
		end
		
		if(result == "nil") then
			MySQL:executeQuery("INSERT INTO police (`identifier`) VALUES ('')", { ['@identifier'] = identifier})
		end
		
	elseif(db.driver == "mysql-async") then
		MySQL.Async.fetchAll("SELECT * FROM police WHERE identifier = '"..identifier.."'", { ['@identifier'] = identifier}, function (result)
			if(result[1] == nil) then
				MySQL.Async.execute("INSERT INTO police (`identifier`) VALUES ('"..identifier.."')", { ['@identifier'] = identifier})
			end
		end)
	elseif(db.driver == "couchdb") then
		couchFunctions.getDocumentByRow("police", "identifier", identifier, function(document)
			if(document == false) then
				couchFunctions.createDocument("police", {
					identifier = identifier,
					rank = "Recruit"
				}, function()end)
			end
		end)
	end
end

function remCop(identifier)
	if(db.driver == "mysql") then
		MySQL:executeQuery("DELETE FROM police WHERE identifier = '@identifier'", { ['@identifier'] = identifier})
	elseif(db.driver == "mysql-async") then
		MySQL.Async.execute("DELETE FROM police WHERE identifier = '"..identifier.."'", { ['@identifier'] = identifier})
	elseif(db.driver == "couchdb") then
		couchFunctions.getDocumentByRow("police", "identifier", identifier, function(document)
			if(document ~= false) then
				couchFunctions.updateDocument("police", document._id, {
					identifier = document.identifier .. "/"
				}, function()end)
			end
		end)
	end
end

function checkIsCop(identifier)
	if(db.driver == "mysql") then
		local query = MySQL:executeQuery("SELECT * FROM police WHERE identifier = '@identifier'", { ['@identifier'] = identifier})
		local result = MySQL:getResults(query, {'rank'}, "identifier")
		
		if(not result[1]) then
			TriggerClientEvent('police:receiveIsCop', source, "unknown")
		else
			TriggerClientEvent('police:receiveIsCop', source, result[1].rank)
		end
	elseif(db.driver == "mysql-async") then
		MySQL.Async.fetchAll("SELECT * FROM police WHERE identifier = '"..identifier.."'", { ['@identifier'] = identifier}, function (result)
			if(result[1] == nil) then
				TriggerClientEvent('police:receiveIsCop', source, "unknown")
			else
				TriggerClientEvent('police:receiveIsCop', source, result[1].rank)
			end
		end)
	elseif(db.driver == "couchdb") then
		couchFunctions.getDocumentByRow("police", "identifier", identifier, function(document)
			if(document == false) then
				TriggerClientEvent('police:receiveIsCop', source, "unknown")
			else
				TriggerClientEvent('police:receiveIsCop', source, document.rank)
			end
		end)
	end
end

AddEventHandler('playerDropped', function()
	if(inServiceCops[source]) then
		inServiceCops[source] = nil
		
		if(config.useJobSystem == true) then
			TriggerEvent("jobssystem:disconnectReset", source, config.job.officer_not_on_duty_job_id)
		end
		
		for i, c in pairs(inServiceCops) do
			TriggerClientEvent("police:resultAllCopsInService", i, inServiceCops)
		end
	end
end)

if(config.useCopWhitelist == true) then
	RegisterServerEvent('police:checkIsCop')
	AddEventHandler('police:checkIsCop', function()
		local identifier = getPlayerID(source)
		checkIsCop(identifier)
	end)
end

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

	if(db.driver == "mysql") then
		local executed_query = MySQL:executeQuery("SELECT Nom FROM user_vehicle JOIN users ON user_vehicle.identifier = users.identifier WHERE vehicle_plate = '@plate'", { ['@plate'] = plate })
		local result = MySQL:getResults(executed_query, { 'Nom' }, "identifier")
		if (result[1]) then
			for _, v in ipairs(result) do
				TriggerClientEvent("police:notify", source, "CHAR_ANDREAS", 1, txt[config.lang]["title_notification"], false, txt[config.lang]["vehicle_checking_plate_part_1"]..plate..txt[config.lang]["vehicle_checking_plate_part_2"] .. v.Nom..txt[config.lang]["vehicle_checking_plate_part_3"])
			end
		else
			TriggerClientEvent("police:notify", source, "CHAR_ANDREAS", 1, txt[config.lang]["title_notification"], false, txt[config.lang]["vehicle_checking_plate_part_1"]..plate..txt[config.lang]["vehicle_checking_plate_not_registered"])
		end
	elseif(db.driver == "mysql-async") then
		MySQL.Async.fetchAll("SELECT Nom FROM user_vehicle JOIN users ON user_vehicle.identifier = users.identifier WHERE vehicle_plate = '"..plate.."'", { ['@plate'] = plate }, function (result)
			if(result[1]) then
				for _, v in ipairs(result) do
					TriggerClientEvent("police:notify", source, "CHAR_ANDREAS", 1, txt[config.lang]["title_notification"], false, txt[config.lang]["vehicle_checking_plate_part_1"]..plate..txt[config.lang]["vehicle_checking_plate_part_2"] .. v.Nom..txt[config.lang]["vehicle_checking_plate_part_3"])
				end
			else
				TriggerClientEvent("police:notify", source, "CHAR_ANDREAS", 1, txt[config.lang]["title_notification"], false, txt[config.lang]["vehicle_checking_plate_part_1"]..plate..txt[config.lang]["vehicle_checking_plate_not_registered"])
			end
		end)
	end
end)

RegisterServerEvent('police:confirmUnseat')
AddEventHandler('police:confirmUnseat', function(t)
	TriggerClientEvent("police:notify", source, "CHAR_ANDREAS", 1, txt[config.lang]["title_notification"], false, txt[config.lang]["unseat_sender_notification_part_1"] .. GetPlayerName(t) .. txt[config.lang]["unseat_sender_notification_part_2"])
	TriggerClientEvent('police:unseatme', t)
end)

RegisterServerEvent('police:dragRequest')
AddEventHandler('police:dragRequest', function(t)
	TriggerClientEvent("police:notify", source, "CHAR_ANDREAS", 1, txt[config.lang]["title_notification"], false, txt[config.lang]["drag_sender_notification_part_1"] .. GetPlayerName(t) .. txt[config.lang]["drag_sender_notification_part_2"])
	TriggerClientEvent('police:toggleDrag', t, source)
end)

RegisterServerEvent('police:targetCheckInventory')
AddEventHandler('police:targetCheckInventory', function(target)

	local identifier = getPlayerID(target)
	
	if(config.useVDKInventory == true) then
		if(db.driver == "mysql") then
			local strResult = txt[config.lang]["checking_inventory_part_1"] .. GetPlayerName(target) .. txt[config.lang]["checking_inventory_part_2"]
			local executed_query = MySQL:executeQuery("SELECT * FROM `user_inventory` JOIN items ON items.id = user_inventory.item_id WHERE user_id = '@username'", { ['@username'] = identifier })
			local result = MySQL:getResults(executed_query, { 'quantity', 'libelle', 'item_id', 'isIllegal' }, "item_id")
			if (result) then
				for _, v in ipairs(result) do
					if(v.quantity ~= 0) then
						strResult = strResult .. v.quantity .. "*" .. v.libelle .. ", "
					end
					if(v.isIllegal == "1" or v.isIllegal == "True" or v.isIllegal == 1 or v.isIllegal == true) then
						TriggerClientEvent('police:dropIllegalItem', target, v.item_id)
					end
				end
			end
			
			TriggerClientEvent("police:notify", source, "CHAR_ANDREAS", 1, txt[config.lang]["title_notification"], false, strResult)
			
		elseif(db.driver == "mysql-async") then
			MySQL.Async.fetchAll("SELECT * FROM `user_inventory` JOIN items ON items.id = user_inventory.item_id WHERE user_id = '"..identifier.."'", { ['@username'] = identifier }, function (result)
				local strResult = txt[config.lang]["checking_inventory_part_1"] .. GetPlayerName(target) .. txt[config.lang]["checking_inventory_part_2"]
				
				for _, v in ipairs(result) do
					if(v.quantity ~= 0) then
						strResult = strResult .. v.quantity .. "*" .. v.libelle .. ", "
					end
					
					if(v.isIllegal == "1" or v.isIllegal == "True" or v.isIllegal == 1 or v.isIllegal == true) then
						TriggerClientEvent('police:dropIllegalItem', target, v.item_id)
					end
				end
				
				TriggerClientEvent("police:notify", source, "CHAR_ANDREAS", 1, txt[config.lang]["title_notification"], false, strResult)
			end)
		end
	end
	
	if(config.useWeashop == true) then
	
		if(db.driver == "mysql") then
			local strResult = txt[config.lang]["checking_weapons_part_1"] .. GetPlayerName(target) .. txt[config.lang]["checking_weapons_part_2"]
		
			local executed_query = MySQL:executeQuery("SELECT * FROM user_weapons WHERE identifier = '@username'", { ['@username'] = identifier })
			local result = MySQL:getResults(executed_query, { 'weapon_model' }, 'identifier' )
			if (result) then
				for _, v in ipairs(result) do
					strResult = strResult .. v.weapon_model .. ", "
				end
			end
			
			TriggerClientEvent("police:notify", source, "CHAR_ANDREAS", 1, txt[config.lang]["title_notification"], false, strResult)
			
		elseif(db.driver == "mysql-async") then
			MySQL.Async.fetchAll("SELECT * FROM user_weapons WHERE identifier = '"..identifier.."'", { ['@username'] = identifier }, function (result)
				local strResult = txt[config.lang]["checking_weapons_part_1"] .. GetPlayerName(target) .. txt[config.lang]["checking_weapons_part_2"]
				
				for _, v in ipairs(result) do
					strResult = strResult .. v.weapon_model .. ", "
				end
				
				TriggerClientEvent("police:notify", source, "CHAR_ANDREAS", 1, txt[config.lang]["title_notification"], false, strResult)
			end)
		end
	end	
end)

RegisterServerEvent('police:finesGranted')
AddEventHandler('police:finesGranted', function(target, amount)
	TriggerClientEvent('police:payFines', target, amount, source)
	TriggerClientEvent("police:notify", source, "CHAR_ANDREAS", 1, txt[config.lang]["title_notification"], false, txt[config.lang]["send_fine_request_part_1"]..amount..txt[config.lang]["send_fine_request_part_2"]..GetPlayerName(target))
end)

RegisterServerEvent('police:finesETA')
AddEventHandler('police:finesETA', function(officer, code)
	if(code==1) then
		TriggerClientEvent("police:notify", officer, "CHAR_ANDREAS", 1, txt[config.lang]["title_notification"], false, GetPlayerName(source)..txt[config.lang]["already_have_a_pendind_fine_request"])
	elseif(code==2) then
		TriggerClientEvent("police:notify", officer, "CHAR_ANDREAS", 1, txt[config.lang]["title_notification"], false, GetPlayerName(source)..txt[config.lang]["request_fine_timeout"])
	elseif(code==3) then
		TriggerClientEvent("police:notify", officer, "CHAR_ANDREAS", 1, txt[config.lang]["title_notification"], false, GetPlayerName(source)..txt[config.lang]["request_fine_refused"])
	elseif(code==0) then
		TriggerClientEvent("police:notify", officer, "CHAR_ANDREAS", 1, txt[config.lang]["title_notification"], false, GetPlayerName(source)..txt[config.lang]["request_fine_accepted"])
	end
end)

RegisterServerEvent('police:cuffGranted')
AddEventHandler('police:cuffGranted', function(t)
	TriggerClientEvent("police:notify", source, "CHAR_ANDREAS", 1, txt[config.lang]["title_notification"], false, txt[config.lang]["toggle_cuff_player_part_1"]..GetPlayerName(t)..txt[config.lang]["toggle_cuff_player_part_2"])
	TriggerClientEvent('police:getArrested', t)
end)

RegisterServerEvent('police:forceEnterAsk')
AddEventHandler('police:forceEnterAsk', function(t, v)
	TriggerClientEvent("police:notify", source, "CHAR_ANDREAS", 1, txt[config.lang]["title_notification"], false, txt[config.lang]["force_player_get_in_vehicle_part_1"]..GetPlayerName(t)..txt[config.lang]["force_player_get_in_vehicle_part_2"])
	TriggerClientEvent('police:forcedEnteringVeh', t, v)
end)

-----------------------------------------------------------------------
----------------------EVENT SPAWN POLICE VEH---------------------------
-----------------------------------------------------------------------
RegisterServerEvent('CheckPoliceVeh')
AddEventHandler('CheckPoliceVeh', function(vehicle)
	TriggerClientEvent('FinishPoliceCheckForVeh',source)
	TriggerClientEvent('policeveh:spawnVehicle', source, vehicle)
end)

-----------------------------------------------------------------------
---------------------COMMANDE ADMIN AJOUT / SUPP COP-------------------
-----------------------------------------------------------------------
if(config.useCopWhitelist) then

	TriggerEvent('es:addGroupCommand', 'copadd', "admin", function(source, args, user)
		 if(not args[2]) then
			TriggerClientEvent('chatMessage', source, txt[config.lang]["title_notification"], {255, 0, 0}, txt[config.lang]["usage_command_copadd"])	
		else
			if(GetPlayerName(tonumber(args[2])) ~= nil)then
				local player = tonumber(args[2])
				addCop(getPlayerID(player))
				TriggerClientEvent('chatMessage', source, txt[config.lang]["title_notification"], {255, 0, 0}, txt[config.lang]["command_received"])
				TriggerClientEvent("police:notify", player, "CHAR_ANDREAS", 1, txt[config.lang]["title_notification"], false, txt[config.lang]["become_cop_success"])
				TriggerClientEvent('police:nowCop', player)
			else
				TriggerClientEvent('chatMessage', source, txt[config.lang]["title_notification"], {255, 0, 0}, txt[config.lang]["no_player_with_this_id"])
			end
		end
	end, function(source, args, user) 
		TriggerClientEvent('chatMessage', source, txt[config.lang]["title_notification"], {255, 0, 0}, txt[config.lang]["not_enough_permission"])
	end)

	TriggerEvent('es:addGroupCommand', 'coprem', "admin", function(source, args, user) 
		 if(not args[2]) then
			print("nein")
			TriggerClientEvent('chatMessage', source, txt[config.lang]["title_notification"], {255, 0, 0}, txt[config.lang]["usage_command_coprem"])	
		else
			if(GetPlayerName(tonumber(args[2])) ~= nil)then
				local player = tonumber(args[2])
				remCop(getPlayerID(player))
				TriggerClientEvent("police:notify", player, "CHAR_ANDREAS", 1, txt[config.lang]["title_notification"], false, txt[config.lang]["remove_from_cops"])
				TriggerClientEvent('chatMessage', source, txt[config.lang]["title_notification"], {255, 0, 0}, txt[config.lang]["command_received"])
				TriggerClientEvent('police:noLongerCop', player)
			else
				TriggerClientEvent('chatMessage', source, txt[config.lang]["title_notification"], {255, 0, 0}, txt[config.lang]["no_player_with_this_id"])
			end
		end
	end, function(source, args, user) 
		TriggerClientEvent('chatMessage', source, txt[config.lang]["title_notification"], {255, 0, 0}, txt[config.lang]["not_enough_permission"])
	end)
	
end

-- get's the player id without having to use bugged essentials
function getPlayerID(source)
    local identifiers = GetPlayerIdentifiers(source)
    local player = getIdentifiant(identifiers)
    return player
end

-- gets the actual player id unique to the player,
-- independent of whether the player changes their screen name
function getIdentifiant(id)
    for _, v in ipairs(id) do
        return v
    end
end