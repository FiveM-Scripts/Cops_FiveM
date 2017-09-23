local inServiceCops = {}

function addCop(identifier)
	MySQL.Async.fetchAll("SELECT * FROM police WHERE identifier = '"..identifier.."'", { ['@identifier'] = identifier}, function (result)
		if(result[1] == nil) then
			MySQL.Async.execute("INSERT INTO police (`identifier`) VALUES ('"..identifier.."')", { ['@identifier'] = identifier})
		end
	end)
end

function setRank(source, player, sourceRank, playerRank)
	local identifier = getPlayerID(player)
	if(config.rank.label[playerRank]) then
		if(sourceRank > playerRank) then
			MySQL.Async.fetchAll("SELECT * FROM police WHERE identifier = '"..identifier.."'", { ['@identifier'] = identifier}, function (result)
				if(result[1]) then
					if(result[1].rank < sourceRank) then
						MySQL.Async.execute("UPDATE police SET rank="..playerRank.." WHERE identifier='"..identifier.."'", { ['@identifier'] = identifier})
						TriggerClientEvent('chatMessage', source, txt[config.lang]["title_notification"], {255, 0, 0}, txt[config.lang]["command_received"])
						TriggerClientEvent("police:notify", player, "CHAR_ANDREAS", 1, txt[config.lang]["title_notification"], false, txt[config.lang]["new_rank"]..config.rank.label[playerRank])
						TriggerClientEvent('police:receiveIsCop', source, playerRank)
					else
						TriggerClientEvent('chatMessage', source, txt[config.lang]["title_notification"], {255, 0, 0}, txt[config.lang]["not_enough_permission"])
					end
				else
					TriggerClientEvent('chatMessage', source, txt[config.lang]["title_notification"], {255, 0, 0}, txt[config.lang]["player_not_cop"])
				end
			end)
		else
			TriggerClientEvent('chatMessage', source, txt[config.lang]["title_notification"], {255, 0, 0}, txt[config.lang]["not_enough_permission"])
		end
	else
		TriggerClientEvent('chatMessage', source, txt[config.lang]["title_notification"], {255, 0, 0}, txt[config.lang]["rank_not_exist"])
	end
end

function remCop(identifier)
	MySQL.Async.execute("DELETE FROM police WHERE identifier = '"..identifier.."'", { ['@identifier'] = identifier})
end

AddEventHandler('playerDropped', function()
	if(inServiceCops[source]) then
		
		if(config.useJobSystem == true) then
			MySQL.Async.execute("UPDATE users SET job="..config.job.officer_not_on_duty_job_id.." WHERE identifier = '"..inServiceCops[source].."'", { ['@identifier'] = inServiceCops[source]})
		end
		
		inServiceCops[source] = nil
		
		for i, c in pairs(inServiceCops) do
			TriggerClientEvent("police:resultAllCopsInService", i, inServiceCops)
		end
	end
end)

RegisterServerEvent('police:checkIsCop')
AddEventHandler('police:checkIsCop', function()
	local identifier = getPlayerID(source)
	local src = source
	MySQL.Async.fetchAll("SELECT rank FROM police WHERE identifier = '"..identifier.."'", { ['@identifier'] = identifier}, function (result)
		if(result[1] == nil) then
			TriggerClientEvent('police:receiveIsCop', src, -1)
		else
			TriggerClientEvent('police:receiveIsCop', src, result[1].rank)
		end
	end)
end)

RegisterServerEvent('police:takeService')
AddEventHandler('police:takeService', function()

	if(not inServiceCops[source]) then
		inServiceCops[source] = getPlayerID(source)
		
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

RegisterServerEvent('police:removeWeapons')
AddEventHandler('police:removeWeapons', function(target)
	local identifier = getPlayerID(target)
	MySQL.Sync.execute("DELETE FROM user_weapons WHERE identifier='"..identifier.."'",{['@user']= identifier})
	TriggerClientEvent("police:removeWeapons", target)
end)

RegisterServerEvent('police:checkingPlate')
AddEventHandler('police:checkingPlate', function(plate)
	MySQL.Async.fetchAll("SELECT Nom FROM user_vehicle JOIN users ON user_vehicle.identifier = users.identifier WHERE vehicle_plate = '"..plate.."'", { ['@plate'] = plate }, function (result)
		if(result[1]) then
			for _, v in ipairs(result) do
				TriggerClientEvent("police:notify", source, "CHAR_ANDREAS", 1, txt[config.lang]["title_notification"], false, txt[config.lang]["vehicle_checking_plate_part_1"]..plate..txt[config.lang]["vehicle_checking_plate_part_2"] .. v.Nom..txt[config.lang]["vehicle_checking_plate_part_3"])
			end
		else
			TriggerClientEvent("police:notify", source, "CHAR_ANDREAS", 1, txt[config.lang]["title_notification"], false, txt[config.lang]["vehicle_checking_plate_part_1"]..plate..txt[config.lang]["vehicle_checking_plate_not_registered"])
		end
	end)
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
	
	if(config.useWeashop == true) then
	
		MySQL.Async.fetchAll("SELECT * FROM user_weapons WHERE identifier = '"..identifier.."'", { ['@username'] = identifier }, function (result)
			local strResult = txt[config.lang]["checking_weapons_part_1"] .. GetPlayerName(target) .. txt[config.lang]["checking_weapons_part_2"]
			
			for _, v in ipairs(result) do
				strResult = strResult .. v.weapon_model .. ", "
			end
			
			TriggerClientEvent("police:notify", source, "CHAR_ANDREAS", 1, txt[config.lang]["title_notification"], false, strResult)
		end)
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

RegisterServerEvent('CheckPoliceVeh')
AddEventHandler('CheckPoliceVeh', function(vehicle)
	TriggerClientEvent('FinishPoliceCheckForVeh',source)
	TriggerClientEvent('policeveh:spawnVehicle', source, vehicle)
end)

--Big EventHandler Oo (related to commands copadd coprem and coprank btw)
--Probably I should add some comments ^^'

AddEventHandler('chatMessage', function(source, name, message)
	CancelEvent()
	if(startswith(message, "/"))then
		local args = stringsplit(message, " ")
		args[1] = string.gsub(args[1], "/", "")
		if(args[1] == "coprank") then
			local identifier = getPlayerID(source)
			MySQL.Async.fetchAll("SELECT * FROM police WHERE identifier = '"..identifier.."'", { ['@identifier'] = identifier}, function (result)
				if(result[1]) then
					if(result[1].rank >= config.rank.min_rank_set_rank) then
						if(not args[3]) then
							TriggerClientEvent('chatMessage', source, txt[config.lang]["title_notification"], {255, 0, 0}, txt[config.lang]["usage_command_coprank"])	
						else
							if(GetPlayerName(tonumber(args[2])) ~= nil)then
								local player = tonumber(args[2])
								local rank = tonumber(args[3])
								setRank(source, player, result[1].rank, rank)
							else
								TriggerClientEvent('chatMessage', source, txt[config.lang]["title_notification"], {255, 0, 0}, txt[config.lang]["no_player_with_this_id"])
							end
						end
					else
						TriggerClientEvent('chatMessage', source, txt[config.lang]["title_notification"], {255, 0, 0}, txt[config.lang]["not_enough_permission"])
					end
				else
					TriggerClientEvent('chatMessage', source, txt[config.lang]["title_notification"], {255, 0, 0}, txt[config.lang]["not_enough_permission"])
				end
			end)
		end
		if(config.useCopWhitelist) then
			if(args[1] == "copadd") then
				local identifier = getPlayerID(source)
				MySQL.Async.fetchAll("SELECT * FROM police WHERE identifier = '"..identifier.."'", { ['@identifier'] = identifier}, function (result)
					if(result[1]) then
						if(result[1].rank >= config.rank.min_rank_set_rank) then
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
						else
							TriggerClientEvent('chatMessage', source, txt[config.lang]["title_notification"], {255, 0, 0}, txt[config.lang]["not_enough_permission"])
						end
					else
						TriggerClientEvent('chatMessage', source, txt[config.lang]["title_notification"], {255, 0, 0}, txt[config.lang]["not_enough_permission"])
					end
				end)
			elseif(args[1] == "coprem") then
				local identifier = getPlayerID(source)
				MySQL.Async.fetchAll("SELECT * FROM police WHERE identifier = '"..identifier.."'", { ['@identifier'] = identifier}, function (result)
					if(result[1]) then
						if(result[1].rank >= config.rank.min_rank_set_rank) then
							if(not args[2]) then
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
						else
							TriggerClientEvent('chatMessage', source, txt[config.lang]["title_notification"], {255, 0, 0}, txt[config.lang]["not_enough_permission"])
						end
					else
						TriggerClientEvent('chatMessage', source, txt[config.lang]["title_notification"], {255, 0, 0}, txt[config.lang]["not_enough_permission"])
					end
				end)
			end
		end
	else
		if(config.displayRankBeforeNameOnChat) then
			local identifier = getPlayerID(source)
			MySQL.Async.fetchAll("SELECT * FROM police WHERE identifier = '"..identifier.."'", { ['@identifier'] = identifier}, function (result)
				if(result[1]) then
					TriggerClientEvent('chatMessage', -1, "[".. config.rank.minified_label[result[1].rank] .."] "..name, {51, 204, 255}, message)
				else
					TriggerClientEvent('chatMessage', -1, name, {0, 255, 0}, message)
				end
			end)
		else
			TriggerClientEvent('chatMessage', -1, name, {0, 255, 0}, message)
		end
	end
end)

function stringsplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t, i = {}, 1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

function startswith(String,Start)
	return string.sub(String,1,string.len(Start))==Start
end

function getPlayerID(source)
    local identifiers = GetPlayerIdentifiers(source)
    local player = getIdentifiant(identifiers)
    return player
end

function getIdentifiant(id)
    for _, v in ipairs(id) do
        return v
    end
end