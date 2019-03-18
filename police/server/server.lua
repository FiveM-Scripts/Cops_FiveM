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


if config.useCopWhitelist then
	local setupTable = "CREATE TABLE IF NOT EXISTS `police` (`identifier` varchar(255) COLLATE utf8_unicode_ci NOT NULL,`dept` int(11) NOT NULL DEFAULT '0',`rank` int(11) NOT NULL DEFAULT '0')"
	exports.ghmattimysql:execute(setupTable, {}, function()
		IsDatabaseVerified = true
	end)
end

if GetResourceMetadata(GetCurrentResourceName(), 'resource_Isdev', 0) == "yes" then
	RconPrint("/!\\ You are running a dev version of Cops FiveM !\n")
end

if config.enableVersionNotifier then
	PerformHttpRequest("https://raw.githubusercontent.com/FiveM-Scripts/Cops_FiveM/master/police/__resource.lua", function(errorCode, result, headers)
		local version = GetResourceMetadata(GetCurrentResourceName(), 'resource_version', 0)

		if string.find(tostring(result), version) == nil then
			print("\n\r[Cops_FiveM] The version on this server is not up to date. Please update now.\n\r")
		end
	end, "GET", "", "")
end

local inServiceCops = {}

function addCop(identifier)
	exports.ghmattimysql:scalar("SELECT identifier FROM police WHERE identifier = @identifier", { ['identifier'] = tostring(identifier)}, function (result)
		if not result then
			exports.ghmattimysql:execute("INSERT INTO police (`identifier`) VALUES ('"..identifier.."')", {['@identifier'] = identifier})
		end
	end)
end

function setDept(source, player,playerDept)
	local identifier = getPlayerID(player)
	if(config.departments.label[playerDept]) then
			exports.ghmattimysql:execute("SELECT * FROM police WHERE identifier = '"..identifier.."'", { ['@identifier'] = identifier}, function (result)
				if(result[1]) then
					if(result[1].dept ~= playerDept) then
						exports.ghmattimysql:execute("UPDATE police SET dept="..playerDept.." WHERE identifier='"..identifier.."'", { ['identifier'] = identifier})
						TriggerClientEvent('chatMessage', source, i18n.translate("title_notification"), {255, 0, 0}, i18n.translate("command_received"))
						TriggerClientEvent("police:notify", player, "CHAR_AGENT14", 1, i18n.translate("title_notification"), false, i18n.translate("new_dept") .. " " .. config.departments.label[playerDept])
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
	exports.ghmattimysql:execute("DELETE FROM police WHERE identifier = '"..identifier.."'", { ['identifier'] = identifier})
end

AddEventHandler('playerDropped', function()
	if(inServiceCops[source]) then	
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
	
	if config.useCopWhitelist then
		exports.ghmattimysql:scalar("SELECT `identifier` FROM police WHERE identifier = @identifier", { ['identifier'] = identifier}, function(result)
			if not result then
				TriggerClientEvent('police:receiveIsCop', src, -1)
			else
				exports.ghmattimysql:execute("SELECT * FROM police WHERE identifier = @identifier", { ['identifier'] = identifier}, function(data)
					if data then
						TriggerClientEvent('police:receiveIsCop', src, data[1].rank, data[1].dept)
					end
				end)
			end
		end)
	else
		TriggerClientEvent('police:receiveIsCop', src, 0, 1)
	end
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
	TriggerClientEvent("police:removeWeapons", target)
end)

RegisterServerEvent('police:confirmUnseat')
AddEventHandler('police:confirmUnseat', function(t)
	TriggerClientEvent("police:notify", source, "CHAR_AGENT14", 1, i18n.translate("title_notification"), false, i18n.translate("unseat_sender_notification_part_1") .. GetPlayerName(t) .. i18n.translate("unseat_sender_notification_part_2"))
	TriggerClientEvent('police:unseatme', t)
end)

RegisterServerEvent('police:dragRequest')
AddEventHandler('police:dragRequest', function(t)
	TriggerClientEvent("police:notify", source, "CHAR_AGENT14", 1, i18n.translate("title_notification"), false, i18n.translate("drag_sender_notification_part_1").. GetPlayerName(t) .. i18n.translate("drag_sender_notification_part_2"))
	TriggerClientEvent('police:toggleDrag', t, source)
end)

RegisterServerEvent('police:finesGranted')
AddEventHandler('police:finesGranted', function(target, amount)
	TriggerClientEvent('police:payFines', target, amount, source)
	TriggerClientEvent("police:notify", source, "CHAR_AGENT14", 1, i18n.translate("title_notification"), false, i18n.translate("send_fine_request_part_1")..amount..i18n.translate("send_fine_request_part_2")..GetPlayerName(target))
end)

RegisterServerEvent('police:finesETA')
AddEventHandler('police:finesETA', function(officer, code)
	if(code==1) then
		TriggerClientEvent("police:notify", officer, "CHAR_AGENT14", 1, i18n.translate("title_notification"), false, GetPlayerName(source)..i18n.translate("already_have_a_pendind_fine_request"))
	elseif(code==2) then
		TriggerClientEvent("police:notify", officer, "CHAR_AGENT14", 1, i18n.translate("title_notification"), false, GetPlayerName(source)..i18n.translate("request_fine_timeout"))
	elseif(code==3) then
		TriggerClientEvent("police:notify", officer, "CHAR_AGENT14", 1, i18n.translate("title_notification"), false, GetPlayerName(source)..i18n.translate("request_fine_refused"))
	elseif(code==0) then
		TriggerClientEvent("police:notify", officer, "CHAR_AGENT14", 1, i18n.translate("title_notification"), false, GetPlayerName(source)..i18n.translate("request_fine_accepted"))
	end
end)

RegisterServerEvent('police:cuffGranted')
AddEventHandler('police:cuffGranted', function(t)
	TriggerClientEvent("police:notify", source, "CHAR_AGENT14", 1, i18n.translate("title_notification"), false, i18n.translate("toggle_cuff_player_part_1")..GetPlayerName(t)..i18n.translate("toggle_cuff_player_part_2"))
	TriggerClientEvent('police:getArrested', t)
end)

RegisterServerEvent('police:forceEnterAsk')
AddEventHandler('police:forceEnterAsk', function(t, v)
	TriggerClientEvent("police:notify", source, "CHAR_AGENT14", 1, i18n.translate("title_notification"), false, i18n.translate("force_player_get_in_vehicle_part_1")..GetPlayerName(t)..i18n.translate("force_player_get_in_vehicle_part_2"))
	TriggerClientEvent('police:forcedEnteringVeh', t, v)
end)

RegisterServerEvent('CheckPoliceVeh')
AddEventHandler('CheckPoliceVeh', function(vehicle)
	TriggerClientEvent('FinishPoliceCheckForVeh',source)
	TriggerClientEvent('policeveh:spawnVehicle', source, vehicle)
end)

RegisterServerEvent('police:UpdateNotifier')
AddEventHandler('police:UpdateNotifier', function()
	local src = source
	PerformHttpRequest("https://raw.githubusercontent.com/FiveM-Scripts/Cops_FiveM/master/police/__resource.lua", function(errorCode, result, headers)
		local version = GetResourceMetadata(GetCurrentResourceName(), 'resource_version', 0)
		if string.find(tostring(result), version) == nil then
			TriggerClientEvent('police:Update', src, true)
		end
	end, "GET", "", "")	
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
		exports.ghmattimysql:scalar("SELECT identifier FROM police WHERE identifier = @identifier", {['identifier'] = identifier}, function(result)
			if not result then
				exports.ghmattimysql:execute("INSERT INTO police (`identifier`, `dept`, `rank`) VALUES (@identifier, @dept, @maxi)", { ['identifier'] = identifier, ['dept'] = 1, ['maxi'] = maxi})
				TriggerClientEvent("police:notify", tonumber(args[1]), "CHAR_AGENT14", 1, i18n.translate("title_notification"), false, i18n.translate("become_cop_success"))					
				
				RconPrint(GetPlayerName(tonumber(args[1])) .. " is now added to the police database.\n")
				TriggerClientEvent('police:receiveIsCop', tonumber(args[1]), maxi, 1)
			else
				RconPrint(GetPlayerName(tonumber(args[1])) .. ' already exists.\n')
			end
		end)
		CancelEvent()
	end
end, true)

RegisterCommand("CopAdd", function(source,args,raw)
	if #args ~= 1 then
		RconPrint("Usage: CopAdd [ingame-id]\n")
		CancelEvent()
		return
	else
		if GetPlayerName(tonumber(args[1])) == nil then
			RconPrint("Player is not ingame\n")
			CancelEvent()
			return
		end
			
		local identifier = getPlayerID(tonumber(args[1]))
		exports.ghmattimysql:scalar("SELECT identifier FROM police WHERE identifier = @identifier", { ['identifier'] = identifier}, function (result)
			if not result then
				print('Adding record for player to the database')
				addCop(identifier)

				TriggerClientEvent("police:notify", tonumber(args[1]), "CHAR_AGENT14", 1, i18n.translate("title_notification"), false, i18n.translate("become_cop_success"))
				TriggerClientEvent('police:receiveIsCop', tonumber(args[1]), 0, 1)

				RconPrint(GetPlayerName(tonumber(args[1])) .. " is now added to the police database.\n")
			else
				RconPrint(GetPlayerName(tonumber(args[1])) .. " is already a police officer.\n")
			end
		end)
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
			
		exports.ghmattimysql:scalar("SELECT identifier FROM police WHERE identifier = @identifier", { ['identifier'] = identifier}, function (result)
			if not result then
				RconPrint(GetPlayerName(tonumber(args[1])) .. "  isn't here.\n")
			else
				exports.ghmattimysql:execute("DELETE FROM police WHERE identifier = @identifier", { ['identifier'] = identifier})
				TriggerClientEvent('police:noLongerCop', tonumber(args[1]))
				TriggerClientEvent("police:notify", tonumber(args[1]), "CHAR_AGENT14", 1, i18n.translate("title_notification"), false, i18n.translate("remove_from_cops"))
				RconPrint(GetPlayerName(tonumber(args[1])) .. " is now removed from the police database.\n")
			end
		end)

		CancelEvent()
	end
end, true)

RegisterCommand("CopRank", function(source,args,raw)
	if #args ~= 2 then
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
		exports.ghmattimysql:scalar("SELECT `identifier` FROM police WHERE identifier = @identifier", { ['identifier'] = identifier}, function (rank)
			if(rank == nil) then
				RconPrint(GetPlayerName(tonumber(args[1])) .. "  isn't here.\n")
			else
				exports.ghmattimysql:execute("UPDATE police SET `rank` = @rank WHERE identifier = @identifier", { ['identifier'] = identifier, ['rank'] = args[2]})
				TriggerClientEvent('police:receiveIsCop', tonumber(args[1]), tonumber(args[2]))
				RconPrint(GetPlayerName(tonumber(args[1])) .. " information has been updated.\n")
			end
		end)

		CancelEvent()
	end
end, true)

RegisterCommand("CopDept", function(source,args,raw)
	if #args ~= 2 then
		RconPrint("Usage: CopDept [ingame-id] [department]\n")
		CancelEvent()
		return	
	else
		if(GetPlayerName(tonumber(args[1])) == nil) then
			RconPrint("Player is not ingame\n")
			CancelEvent()
			return
		end

		local identifier = getPlayerID(tonumber(args[1]))
		exports.ghmattimysql:scalar("SELECT `identifier` FROM police WHERE identifier = @identifier", { ['identifier'] = identifier}, function (result)
			if result then
				if GetPlayerName(tonumber(args[1])) ~= nil then
					local player = tonumber(args[1])
					local dept = tonumber(args[2])

					setDept(args[1], player, dept)
				else
					TriggerClientEvent('chatMessage', args[1], i18n.translate("title_notification"), {255, 0, 0}, i18n.translate("no_player_with_this_id"))
				end
			else
				TriggerClientEvent('chatMessage', args[1], i18n.translate("title_notification"), {255, 0, 0}, i18n.translate("not_enough_permission"))
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