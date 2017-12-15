MySQL.ready(function()
    MySQL.Async.execute("CREATE TABLE IF NOT EXISTS police (identifier varchar(255) NOT NULL, rank int(11) NOT NULL DEFAULT 0)") 
end)

if COPS_FIVEM_VERSION.isDev == true then
	RconPrint("/!\\ You are running a dev version of Cops FiveM !\n")
end

if(config.enableVersionNotifier) then
	PerformHttpRequest('https://kyominii.com/fivem/cops/version.json', function(err, text, headers)
		if text then
			local strToPrint = ""
		
			local decode_text = json.decode(text)
			if decode_text.num.prod_version > COPS_FIVEM_VERSION.num then
				strToPrint = "A new version of Cops FiveM is available !\nCurrent version : "..COPS_FIVEM_VERSION.str.." | Last version : "..decode_text.str.prod_version.."\n"
			elseif decode_text.num.prod_version < COPS_FIVEM_VERSION.num then
				if decode_text.num.dev_version == COPS_FIVEM_VERSION.num then
					strToPrint = "You are running the last dev version of Cops FiveM !\nCurrent version : "..COPS_FIVEM_VERSION.str.."\n"
				else
					strToPrint = "Who are you ? I don't know you !\nCurrent version : "..COPS_FIVEM_VERSION.str.."\n"
				end
			elseif decode_text.num.prod_version == COPS_FIVEM_VERSION.num then
				if COPS_FIVEM_VERSION.isDev == true then
					strToPrint = "You are running a very old dev version of Cops FiveM !\nCurrent version : "..COPS_FIVEM_VERSION.str.." | Last dev version : "..decode_text.str.dev_version.."\n"
				else
					strToPrint = "You have the last version of Cops FiveM !\nCurrent version : "..COPS_FIVEM_VERSION.str.."\n"
				end
			end
			
			RconPrint(strToPrint)
		else
			RconPrint("The version provider service is unreachable !\n")
		end
	end, 'GET', '', {})
end

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
	local source = source
	if(startswith(message, "/"))then
		local args = stringsplit(message, " ")
		args[1] = string.gsub(args[1], "/", "")
		if(args[1] == "copadd" or args[1] == "coprem" or args[1] == "coprank") then
			CancelEvent()
			if(args[1] == "coprank") then
				local identifier = getPlayerID(source)
				MySQL.Async.fetchAll("SELECT * FROM police WHERE identifier = '"..identifier.."'", { ['@identifier'] = identifier}, function (result)
					if(result[1]) then
						if(tonumber(result[1].rank) >= tonumber(config.rank.min_rank_set_rank)) then
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
			elseif(args[1] ~= "coprank") then
				TriggerClientEvent('chatMessage', source, "Cops FiveM", {255, 0, 0}, txt[config.lang]["cop_whitelist_disabled"])
			end
		end
	else
		if(config.displayRankBeforeNameOnChat) then
			CancelEvent()
			local identifier = getPlayerID(source)
			MySQL.Async.fetchAll("SELECT * FROM police WHERE identifier = '"..identifier.."'", { ['@identifier'] = identifier}, function (result)
				if(result[1]) then
					TriggerClientEvent('chatMessage', -1, "[".. config.rank.minified_label[result[1].rank] .."] "..name, {51, 204, 255}, message)
				else
					TriggerClientEvent('chatMessage', -1, name, {0, 255, 0}, message)
				end
			end)
		end
	end
end)

AddEventHandler('rconCommand', function(commandName, args)
	if commandName == 'CopAddAdmin' then
		if #args ~= 1 then
				RconPrint("Usage: CopAddAdmin [steam:hex|ingame-id]\n")
				CancelEvent()
				return
		end

		local maxi = -1
		for key, value in pairs(config.rank.label) do
			if key > maxi then maxi = key end
		end		
		
		if(startswith(args[1], "steam:")) then
			MySQL.Async.fetchScalar("SELECT rank FROM police WHERE identifier = @identifier", { ['@identifier'] = args[1]}, function (rank)
				if(rank == nil) then
					MySQL.Async.execute("INSERT INTO police (identifier, rank) VALUES (@identifier, @maxi)", { ['@identifier'] = args[1], ['@maxi'] = maxi})
					RconPrint(args[1] .. " is now add in the police database.\n")
				else
					MySQL.Async.execute("UPDATE police SET rank = @maxi WHERE identifier = @identifier", { ['@identifier'] = args[1], ['@maxi'] = maxi})
					RconPrint(args[1] .. " is already in the police database, his rank is now update.\n")
				end
			end)
		else
			if(GetPlayerName(tonumber(args[1])) == nil)then
				RconPrint("Player not ingame\n")
				CancelEvent()
				return
			end
			
			local identifier = getPlayerID(tonumber(args[1]))
			
			MySQL.Async.fetchScalar("SELECT rank FROM police WHERE identifier = @identifier", { ['@identifier'] = identifier}, function (rank)
				if(rank == nil) then
					MySQL.Async.execute("INSERT INTO police (identifier, rank) VALUES (@identifier, @maxi)", { ['@identifier'] = identifier, ['@maxi'] = maxi})
					RconPrint(GetPlayerName(tonumber(args[1])) .. " is now add in the police database.\n")
					TriggerClientEvent("police:notify", tonumber(args[1]), "CHAR_ANDREAS", 1, txt[config.lang]["title_notification"], false, txt[config.lang]["become_cop_success"])
					TriggerClientEvent('police:receiveIsCop', tonumber(args[1]), maxi)
				else
					MySQL.Async.execute("UPDATE police SET rank = @maxi WHERE identifier = @identifier", { ['@identifier'] = identifier, ['@maxi'] = maxi})
					RconPrint(GetPlayerName(tonumber(args[1])) .. " is already in the police database, his rank is now update.\n")
					TriggerClientEvent('police:receiveIsCop', tonumber(args[1]), maxi)
				end
			end)
		end
		
		CancelEvent()
	end
	
	if commandName == 'CopAdd' then
		if #args ~= 1 then
				RconPrint("Usage: CopAdd [steam:hex|ingame-id]\n")
				CancelEvent()
				return
		end	
		
		if(startswith(args[1], "steam:")) then
			MySQL.Async.fetchScalar("SELECT rank FROM police WHERE identifier = @identifier", { ['@identifier'] = args[1]}, function (rank)
				if(rank == nil) then
					addCop(args[1])
					RconPrint(args[1] .. " is now add in the police database.\n")
				else
					RconPrint(args[1] .. " is already a police officer.\n")
				end
			end)
		else
			if(GetPlayerName(tonumber(args[1])) == nil)then
				RconPrint("Player not ingame\n")
				CancelEvent()
				return
			end
			
			local identifier = getPlayerID(tonumber(args[1]))
			
			MySQL.Async.fetchScalar("SELECT rank FROM police WHERE identifier = @identifier", { ['@identifier'] = identifier}, function (rank)
				if(rank == nil) then
					addCop(identifier)
					TriggerClientEvent("police:notify", tonumber(args[1]), "CHAR_ANDREAS", 1, txt[config.lang]["title_notification"], false, txt[config.lang]["become_cop_success"])
					TriggerClientEvent('police:receiveIsCop', tonumber(args[1]), 0)
					RconPrint(GetPlayerName(tonumber(args[1])) .. " is now add in the police database.\n")
				else
					RconPrint(GetPlayerName(tonumber(args[1])) .. " is already a police offcier.\n")
				end
			end)
		end
		
		CancelEvent()
	end
	
	if commandName == 'CopRem' then
		if #args ~= 1 then
				RconPrint("Usage: CopRem [steam:hex|ingame-id]\n")
				CancelEvent()
				return
		end	
		
		if(startswith(args[1], "steam:")) then
			MySQL.Async.fetchScalar("SELECT rank FROM police WHERE identifier = @identifier", { ['@identifier'] = args[1]}, function (rank)
				if(rank == nil) then
					RconPrint(args[1] .. " isn't here.\n")
				else
					MySQL.Async.execute("DELETE FROM police WHERE identifier = @identifier", { ['@identifier'] = args[1]})
					RconPrint(args[1] .. " is now removed from the police database.\n")
				end
			end)
		else
			if(GetPlayerName(tonumber(args[1])) == nil)then
				RconPrint("Player not ingame\n")
				CancelEvent()
				return
			end
			
			local identifier = getPlayerID(tonumber(args[1]))
			
			MySQL.Async.fetchScalar("SELECT rank FROM police WHERE identifier = @identifier", { ['@identifier'] = identifier}, function (rank)
				if(rank == nil) then
					RconPrint(GetPlayerName(tonumber(args[1])) .. "  isn't here.\n")
				else
					MySQL.Async.execute("DELETE FROM police WHERE identifier = @identifier", { ['@identifier'] = identifier})
					TriggerClientEvent('police:noLongerCop', tonumber(args[1]))
					TriggerClientEvent("police:notify", tonumber(args[1]), "CHAR_ANDREAS", 1, txt[config.lang]["title_notification"], false, txt[config.lang]["remove_from_cops"])
					RconPrint(GetPlayerName(tonumber(args[1])) .. " is now removed from the police database.\n")
				end
			end)
		end
		
		CancelEvent()
	end
	
	if commandName == 'CopRank' then
		if #args ~= 2 then
				RconPrint("Usage: CopRem [steam:hex|ingame-id] [rank]\n")
				CancelEvent()
				return
		end	
		
		if(not config.rank.label[tonumber(args[2])]) then
			RconPrint("You have to enter a valid rank !\n")
			CancelEvent()
			return
		end
		
		if(startswith(args[1], "steam:")) then
			MySQL.Async.fetchScalar("SELECT rank FROM police WHERE identifier = @identifier", { ['@identifier'] = args[1]}, function (rank)
				if(rank == nil) then
					RconPrint(args[1] .. " isn't here.\n")
				else
					MySQL.Async.execute("UPDATE police SET rank = @rank WHERE identifier = @identifier", { ['@identifier'] = args[1], ['@rank'] = args[2]})
					RconPrint(args[1] .. " is now update.\n")
				end
			end)
		else
			if(GetPlayerName(tonumber(args[1])) == nil)then
				RconPrint("Player not ingame\n")
				CancelEvent()
				return
			end
			
			local identifier = getPlayerID(tonumber(args[1]))
			
			MySQL.Async.fetchScalar("SELECT rank FROM police WHERE identifier = @identifier", { ['@identifier'] = identifier}, function (rank)
				if(rank == nil) then
					RconPrint(GetPlayerName(tonumber(args[1])) .. "  isn't here.\n")
				else
					MySQL.Async.execute("UPDATE police SET rank = @rank WHERE identifier = @identifier", { ['@identifier'] = identifier, ['@rank'] = args[2]})
					TriggerClientEvent('police:receiveIsCop', tonumber(args[1]), tonumber(args[2]))
					RconPrint(GetPlayerName(tonumber(args[1])) .. " is now update.\n")
				end
			end)
		end
		
		CancelEvent()
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
