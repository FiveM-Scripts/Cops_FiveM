--[[
            Cops_FiveM - A cops script for FiveM RP servers.
              Copyright (C) 2018 FiveM-Scripts
              
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU Affero General Public License for more details.
You should have received a copy of the GNU Affero General Public License
along with Cops_FiveM in the file "LICENSE". If not, see <http://www.gnu.org/licenses/>.
]]

MySQL.ready(function()
	MySQL.Async.execute("CREATE TABLE IF NOT EXISTS `police` (`identifier` varchar(255) COLLATE utf8_unicode_ci NOT NULL,`dept` int(11) NOT NULL DEFAULT '0',`rank` int(11) NOT NULL DEFAULT '0')")
end)

if GetResourceMetadata(GetCurrentResourceName(), 'resource_Isdev', 0) == "yes" then
	RconPrint("/!\\ You are running a dev version of Cops FiveM !\n")
end

if(config.enableVersionNotifier) then
	PerformHttpRequest("https://raw.githubusercontent.com/FiveM-Scripts/Cops_FiveM/master/police/__resource.lua", function(errorCode, result, headers)
		local version = GetResourceMetadata(GetCurrentResourceName(), 'resource_version', 0)

		if string.find(tostring(result), version) == nil then
			print("\n\r[Cops_FiveM Freemode] The version on this server is not up to date. Please update now.\n\r")
		end
	end, "GET", "", "")
end

local inServiceCops = {}

function addCop(identifier)
	local result = MySQL.Async.fetchScalar("SELECT COUNT(1) FROM police WHERE identifier = @identifier", { ['@identifier'] = identifier})
	if(result == nil) then
		MySQL.Async.execute("INSERT INTO police (`identifier`) VALUES ('"..identifier.."')", { ['@identifier'] = identifier})
	end
end

function setRank(source, player, sourceRank, playerRank)
	local identifier = getPlayerID(player)
	if(config.rank.label[playerRank]) then
		if(sourceRank > playerRank) then
			MySQL.Async.fetchAll("SELECT * FROM police WHERE identifier = '"..identifier.."'", { ['@identifier'] = identifier}, function (result)
				if(result[1]) then
					if(result[1].rank < sourceRank) then
						MySQL.Async.execute("UPDATE police SET rank="..playerRank.." WHERE identifier='"..identifier.."'", { ['@identifier'] = identifier})
						TriggerClientEvent('chatMessage', source, i18n.translate("title_notification"), {255, 0, 0}, i18n.translate("command_received"))
						TriggerClientEvent("police:notify", player, "CHAR_ANDREAS", 1, i18n.translate("title_notification"), false, i18n.translate("new_rank")..config.rank.label[playerRank])
						TriggerClientEvent('police:receiveIsCop', source, playerRank, result[1].dept)
					else
						TriggerClientEvent('chatMessage', source, i18n.translate("title_notification"), {255, 0, 0}, i18n.translate("not_enough_permission"))
					end
				else
					TriggerClientEvent('chatMessage', source, i18n.translate("title_notification"), {255, 0, 0}, i18n.translate("player_not_cop"))
				end
			end)
		else
			TriggerClientEvent('chatMessage', source, i18n.translate("title_notification"), {255, 0, 0}, i18n.translate("not_enough_permission"))
		end
	else
		TriggerClientEvent('chatMessage', source, i18n.translate("title_notification"), {255, 0, 0}, i18n.translate("rank_not_exist"))
	end
end

function setDept(source, player,playerDept)
	local identifier = getPlayerID(player)
	if(config.departments.label[playerDept]) then
			MySQL.Async.fetchAll("SELECT * FROM police WHERE identifier = '"..identifier.."'", { ['@identifier'] = identifier}, function (result)
				if(result[1]) then
					if(result[1].dept ~= playerDept) then
						MySQL.Async.execute("UPDATE police SET dept="..playerDept.." WHERE identifier='"..identifier.."'", { ['@identifier'] = identifier})
						TriggerClientEvent('chatMessage', source, i18n.translate("title_notification"), {255, 0, 0}, i18n.translate("command_received"))
						TriggerClientEvent("police:notify", player, "CHAR_ANDREAS", 1, i18n.translate("title_notification"), false, i18n.translate("new_dept")..config.departments.label[playerDept])
						TriggerClientEvent('police:receiveIsCop', source, result[1].rank, playerDept)
					else
						TriggerClientEvent('chatMessage', source, i18n.translate("title_notification"), {255, 0, 0}, i18n.translate("same_dept"))
					end
				else
					TriggerClientEvent('chatMessage', source, i18n.translate("title_notification"), {255, 0, 0}, i18n.translate("player_not_cop"))
				end
			end)
	else
		TriggerClientEvent('chatMessage', source, i18n.translate("title_notification"), {255, 0, 0}, i18n.translate("dept_not_exist"))
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
	MySQL.Async.fetchAll("SELECT `rank`, `dept` FROM police WHERE identifier = @identifier", { ['@identifier'] = identifier}, function (result)
		if(result[1] == nil) then
			TriggerClientEvent('police:receiveIsCop', src, -1)
		else
			TriggerClientEvent('police:receiveIsCop', src, result[1].rank, result[1].dept)
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
				TriggerClientEvent("police:notify", source, "CHAR_ANDREAS", 1, i18n.translate("title_notification"), false, i18n.translate("vehicle_checking_plate_part_1")..plate..i18n.translate("vehicle_checking_plate_part_2") .. v.Nom..i18n.translate("vehicle_checking_plate_part_3"))
			end
		else
			TriggerClientEvent("police:notify", source, "CHAR_ANDREAS", 1, i18n.translate("title_notification"), false, i18n.translate("vehicle_checking_plate_part_1")..plate..i18n.translate("vehicle_checking_plate_not_registered"))
		end
	end)
end)

RegisterServerEvent('police:confirmUnseat')
AddEventHandler('police:confirmUnseat', function(t)
	TriggerClientEvent("police:notify", source, "CHAR_ANDREAS", 1, i18n.translate("title_notification"), false, i18n.translate("unseat_sender_notification_part_1") .. GetPlayerName(t) .. i18n.translate("unseat_sender_notification_part_2"))
	TriggerClientEvent('police:unseatme', t)
end)

RegisterServerEvent('police:dragRequest')
AddEventHandler('police:dragRequest', function(t)
	TriggerClientEvent("police:notify", source, "CHAR_ANDREAS", 1, i18n.translate("title_notification"), false, i18n.translate("drag_sender_notification_part_1").. GetPlayerName(t) .. i18n.translate("drag_sender_notification_part_2"))
	TriggerClientEvent('police:toggleDrag', t, source)
end)

RegisterServerEvent('police:targetCheckInventory')
AddEventHandler('police:targetCheckInventory', function(target)

	local identifier = getPlayerID(target)
	
	if(config.useVDKInventory == true) then

		MySQL.Async.fetchAll("SELECT * FROM `user_inventory` JOIN items ON items.id = user_inventory.item_id WHERE user_id = '"..identifier.."'", { ['@username'] = identifier }, function (result)
			local strResult = i18n.translate("checking_inventory_part_1") .. GetPlayerName(target) .. i18n.translate("checking_inventory_part_2")
			
			for _, v in ipairs(result) do
				if(v.quantity ~= 0) then
					strResult = strResult .. v.quantity .. "*" .. v.libelle .. ", "
				end
				
				if(v.isIllegal == "1" or v.isIllegal == "True" or v.isIllegal == 1 or v.isIllegal == true) then
					TriggerClientEvent('police:dropIllegalItem', target, v.item_id)
				end
			end
			
			TriggerClientEvent("police:notify", source, "CHAR_ANDREAS", 1, i18n.translate("title_notification"), false, strResult)
		end)
	end
	
	if(config.useWeashop == true) then
	
		MySQL.Async.fetchAll("SELECT * FROM user_weapons WHERE identifier = '"..identifier.."'", { ['@username'] = identifier }, function (result)
			local strResult = i18n.translate("checking_weapons_part_1") .. GetPlayerName(target) .. i18n.translate("checking_weapons_part_2")
			
			for _, v in ipairs(result) do
				strResult = strResult .. v.weapon_model .. ", "
			end
			
			TriggerClientEvent("police:notify", source, "CHAR_ANDREAS", 1, i18n.translate("title_notification"), false, strResult)
		end)
	end	
end)

RegisterServerEvent('police:finesGranted')
AddEventHandler('police:finesGranted', function(target, amount)
	TriggerClientEvent('police:payFines', target, amount, source)
	TriggerClientEvent("police:notify", source, "CHAR_ANDREAS", 1, i18n.translate("title_notification"), false, i18n.translate("send_fine_request_part_1")..amount..i18n.translate("send_fine_request_part_2")..GetPlayerName(target))
end)

RegisterServerEvent('police:finesETA')
AddEventHandler('police:finesETA', function(officer, code)
	if(code==1) then
		TriggerClientEvent("police:notify", officer, "CHAR_ANDREAS", 1, i18n.translate("title_notification"), false, GetPlayerName(source)..i18n.translate("already_have_a_pendind_fine_request"))
	elseif(code==2) then
		TriggerClientEvent("police:notify", officer, "CHAR_ANDREAS", 1, i18n.translate("title_notification"), false, GetPlayerName(source)..i18n.translate("request_fine_timeout"))
	elseif(code==3) then
		TriggerClientEvent("police:notify", officer, "CHAR_ANDREAS", 1, i18n.translate("title_notification"), false, GetPlayerName(source)..i18n.translate("request_fine_refused"))
	elseif(code==0) then
		TriggerClientEvent("police:notify", officer, "CHAR_ANDREAS", 1, i18n.translate("title_notification"), false, GetPlayerName(source)..i18n.translate("request_fine_accepted"))
	end
end)

RegisterServerEvent('police:cuffGranted')
AddEventHandler('police:cuffGranted', function(t)
	TriggerClientEvent("police:notify", source, "CHAR_ANDREAS", 1, i18n.translate("title_notification"), false, i18n.translate("toggle_cuff_player_part_1")..GetPlayerName(t)..i18n.translate("toggle_cuff_player_part_2"))
	TriggerClientEvent('police:getArrested', t)
end)

RegisterServerEvent('police:forceEnterAsk')
AddEventHandler('police:forceEnterAsk', function(t, v)
	TriggerClientEvent("police:notify", source, "CHAR_ANDREAS", 1, i18n.translate("title_notification"), false, i18n.translate("force_player_get_in_vehicle_part_1")..GetPlayerName(t)..i18n.translate("force_player_get_in_vehicle_part_2"))
	TriggerClientEvent('police:forcedEnteringVeh', t, v)
end)

RegisterServerEvent('CheckPoliceVeh')
AddEventHandler('CheckPoliceVeh', function(vehicle)
	TriggerClientEvent('FinishPoliceCheckForVeh',source)
	TriggerClientEvent('policeveh:spawnVehicle', source, vehicle)
end)

RegisterCommand("CopAddAdmin", function(source,args,raw)
	if #args ~= 1 then
		RconPrint("Usage: CopAddAdmin [ingame-id]\n")
		CancelEvent()
		return
	else
		local maxi = -1
		for key, value in pairs(config.rank.label) do
			if key > maxi then
				maxi = key
			end
		end

		if(GetPlayerName(tonumber(args[1])) == nil)then
			RconPrint("Player is not ingame\n")
			CancelEvent()

			return
		end

		local identifier = getPlayerID(tonumber(args[1]))
		local rankData = MySQL.Sync.fetchScalar("SELECT COUNT(1) FROM police WHERE identifier = @identifier", {['@identifier'] = identifier})

		if(rankData < 1) then
			MySQL.Async.execute("INSERT INTO police (`identifier`, `dept`, `rank`) VALUES (@identifier, @dept, @maxi)", { ['@identifier'] = identifier, ['@dept'] = 1, ['@maxi'] = maxi})
			TriggerClientEvent("police:notify", tonumber(args[1]), "CHAR_ANDREAS", 1, i18n.translate("title_notification"), false, i18n.translate("become_cop_success"))					
			RconPrint(GetPlayerName(tonumber(args[1])) .. " is now added to the police database.\n")
			TriggerClientEvent('police:receiveIsCop', tonumber(args[1]), maxi, 1)
		else
			RconPrint(GetPlayerName(tonumber(args[1])) .. ' already exists.\n')
		end
		
		CancelEvent()
	end
end, true)

RegisterCommand("CopAdd", function(source,args,raw)
	if #args ~= 1 then
		RconPrint("Usage: CopAdd [ingame-id]\n")
		CancelEvent()
		return
	else
		if(GetPlayerName(tonumber(args[1])) == nil)then
			RconPrint("Player is not ingame\n")
			CancelEvent()
			return
		end
			
		local identifier = getPlayerID(tonumber(args[1]))
		local rank = MySQL.Async.fetchAll("SELECT COUNT(1) FROM police WHERE identifier = @identifier", { ['@identifier'] = identifier})

		if(rank == nil) then
			addCop(identifier)

			TriggerClientEvent("police:notify", tonumber(args[1]), "CHAR_ANDREAS", 1, i18n.translate("title_notification"), false, i18n.translate("become_cop_success"))
			TriggerClientEvent('police:receiveIsCop', tonumber(args[1]), 0, 1)
			RconPrint(GetPlayerName(tonumber(args[1])) .. " is now added in to the police database.\n")
		else
			RconPrint(GetPlayerName(tonumber(args[1])) .. " is already a police officer.\n")
		end

		CancelEvent()
	end
end, true)

RegisterCommand("CopRem", function(source,args,raw)
	if #args ~= 1 then
		RconPrint("Usage: CopRem [ingame-id]\n")
		CancelEvent()
		return
	else
		if(GetPlayerName(tonumber(args[1])) == nil)then
			RconPrint("Player is not ingame\n")
			CancelEvent()
			return
		end
			
		local identifier = getPlayerID(tonumber(args[1]))
			
		MySQL.Async.fetchScalar("SELECT COUNT(1) FROM police WHERE identifier = @identifier", { ['@identifier'] = identifier}, function (rank)
			if(rank == nil) then
				RconPrint(GetPlayerName(tonumber(args[1])) .. "  isn't here.\n")
			else
				MySQL.Async.execute("DELETE FROM police WHERE identifier = @identifier", { ['@identifier'] = identifier})
				TriggerClientEvent('police:noLongerCop', tonumber(args[1]))
				TriggerClientEvent("police:notify", tonumber(args[1]), "CHAR_ANDREAS", 1, i18n.translate("title_notification"), false, i18n.translate("remove_from_cops"))
				RconPrint(GetPlayerName(tonumber(args[1])) .. " is now removed from the police database.\n")
			end
		end)

		CancelEvent()
	end
end, true)

RegisterCommand("CopRank", function(source,args,raw)
	if #args ~= 1 and #args ~= 2 then
		RconPrint("Usage: CopRank [ingame-id] [rank]\n")
		CancelEvent()
		return
	elseif(not config.rank.label[tonumber(args[2])]) then
			RconPrint("You have to enter a valid rank !\n")
			CancelEvent()
			return		
	else
		if(GetPlayerName(tonumber(args[1])) == nil)then
			RconPrint("Player is not ingame\n")
			CancelEvent()
			return
		end
			
		local identifier = getPlayerID(tonumber(args[1]))
		MySQL.Async.fetchScalar("SELECT COUNT(1) FROM police WHERE identifier = @identifier", { ['@identifier'] = identifier}, function (rank)
			if(rank == nil) then
				RconPrint(GetPlayerName(tonumber(args[1])) .. "  isn't here.\n")
			else
				MySQL.Async.execute("UPDATE police SET `rank` = @rank WHERE identifier = @identifier", { ['@identifier'] = identifier, ['@rank'] = args[2]})
				TriggerClientEvent('police:receiveIsCop', tonumber(args[1]), tonumber(args[2]))
				RconPrint(GetPlayerName(tonumber(args[1])) .. " information has been updated.\n")
			end
		end)

		CancelEvent()
	end
end, true)

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
