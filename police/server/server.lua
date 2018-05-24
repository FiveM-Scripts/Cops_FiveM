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
	MySQL.Async.execute("ALTER TABLE police ADD dept int(11) NOT NULL DEFAULT '0'")
end)

if GetResourceMetadata(GetCurrentResourceName(), 'resource_Isdev', 0) == "yes" then
	RconPrint("/!\\ You are running a dev version of Cops FiveM !\n")
end

if(config.enableVersionNotifier) then
	PerformHttpRequest('https://kyominii.com/fivem/cops/version.json', function(err, text, headers)
		if text then
			local strToPrint = ""
		
			local decode_text = json.decode(text)
			local versionNumber = tonumber(GetResourceMetadata(GetCurrentResourceName(), 'resource_versionNum', 0))
			local currentVersion  = GetResourceMetadata(GetCurrentResourceName(), 'resource_version', 0)

			if decode_text.num.prod_version > versionNumber then
				strToPrint = "A new version of Cops FiveM is available !\nCurrent version: "..currentVersion.." | Last version : "..decode_text.str.prod_version.."\n"
			elseif decode_text.num.prod_version < versionNumber then
				if decode_text.num.dev_version == versionNumber then
					strToPrint = "You are running the last development version of Cops FiveM!\nCurrent version : "..currentVersion.."\n"
				else
					strToPrint = "Who are you ? I don't know you !\nCurrent version : "..currentVersion.."\n"
				end
			elseif decode_text.num.prod_version == versionNumber then
				if GetResourceMetadata(GetCurrentResourceName(), 'resource_Isdev', 0) == "yes" then
					strToPrint = "You are running a very old development version of Cops FiveM!\nCurrent version : "..currentVersion.." | Last dev version : "..decode_text.str.dev_version.."\n"
				else
					strToPrint = "You have the last version of Cops FiveM !\nCurrent version: "..currentVersion.."\n"
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
						TriggerClientEvent("police:notify", player, "CHAR_ANDREAS", 1, i18n.translate("title_notification"), false, i18n.translate("new_dept").." ~g~" ..config.departments.label[playerDept])
						TriggerClientEvent('police:receiveIsCop', source, result[1].rank, playerDept)
					else
						TriggerClientEvent("police:notify", source, "CHAR_ANDREAS", 6, i18n.translate("title_notification"), false, i18n.translate("same_dept"))

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
	MySQL.Async.fetchAll("SELECT `rank`, `dept` FROM police WHERE identifier = '"..identifier.."'", { ['@identifier'] = identifier}, function (result)
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
	TriggerClientEvent("police:removeWeapons", target)
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

RegisterServerEvent('stolenVehicle')
AddEventHandler('stolenVehicle', function(vehicle, location, ZoneName, VehPlate)
	local target = tostring(GetPlayerName(tonumber(source)))
	local street = tostring(location)
	local zone = tostring(ZoneName)
	local plate = tostring(VehPlate)

	for k,v in pairs(inServiceCops) do
		if not k == tonumber(source) then
			TriggerClientEvent("police:notify", tonumber(k), "CHAR_CALL911", 1, "Dispatch", "Stolen vehicle", "Suspect ~r~".. target .." ~n~~w~Vehicle plate: ~y~"..plate .."~n~~w~Zone: ~y~"..zone)
		end
	end
end)

--Big EventHandler Oo (related to commands copadd coprem and coprank)

AddEventHandler('chatMessage', function(source, name, message)
	local source = source
	if(startswith(message, "/"))then
		local args = stringsplit(message, " ")
		args[1] = string.gsub(args[1], "/", "")
		if(args[1] == "copadd" or args[1] == "coprem" or args[1] == "coprank" or args[1] == "copdept") then
			CancelEvent()
			if(args[1] == "coprank") then
				local identifier = getPlayerID(source)
				MySQL.Async.fetchAll("SELECT * FROM police WHERE identifier = '"..identifier.."'", { ['@identifier'] = identifier}, function (result)
					if(result[1]) then
						if(tonumber(result[1].rank) >= tonumber(config.rank.min_rank_set_rank)) then
							if(not args[3]) then
								TriggerClientEvent('chatMessage', source, i18n.translate("title_notification"), {255, 0, 0}, i18n.translate("usage_command_coprank"))
							else
								if(GetPlayerName(tonumber(args[2])) ~= nil)then
									local player = tonumber(args[2])
									local rank = tonumber(args[3])
									setRank(source, player, result[1].rank, rank)
								else
									TriggerClientEvent('chatMessage', source, i18n.translate("title_notification"), {255, 0, 0}, i18n.translate("no_player_with_this_id"))
								end
							end
						else
							TriggerClientEvent('chatMessage', source, i18n.translate("title_notification"), {255, 0, 0}, i18n.translate("not_enough_permission"))
						end
					else
						TriggerClientEvent('chatMessage', source, i18n.translate("title_notification"), {255, 0, 0}, i18n.translate("not_enough_permission"))
					end
				end)
			end
			if(args[1] == "copdept") then
				local identifier = getPlayerID(source)
				MySQL.Async.fetchAll("SELECT * FROM police WHERE identifier = '"..identifier.."'", { ['@identifier'] = identifier}, function (result)
					if(result[1]) then
						if(tonumber(result[1].rank) >= tonumber(config.rank.min_rank_set_rank)) then
							if(not args[3]) then
								TriggerClientEvent('chatMessage', source, i18n.translate("title_notification"), {255, 0, 0}, i18n.translate("usage_command_copdept"))
							else
								if(GetPlayerName(tonumber(args[2])) ~= nil)then
									local player = tonumber(args[2])
									local dept = tonumber(args[3])
									setDept(source, player, dept)
								else
									TriggerClientEvent('chatMessage', source, i18n.translate("title_notification"), {255, 0, 0}, i18n.translate("no_player_with_this_id"))
								end
							end
						else
							TriggerClientEvent('chatMessage', source, i18n.translate("title_notification"), {255, 0, 0}, i18n.translate("not_enough_permission"))
						end
					else
						TriggerClientEvent('chatMessage', source, i18n.translate("title_notification"), {255, 0, 0}, i18n.translate("not_enough_permission"))
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
									TriggerClientEvent('chatMessage', source, i18n.translate("title_notification"), {255, 0, 0}, i18n.translate("usage_command_copadd"))
								else
									if(GetPlayerName(tonumber(args[2])) ~= nil)then
										local player = tonumber(args[2])
										addCop(getPlayerID(player))
										TriggerClientEvent('chatMessage', source, i18n.translate("title_notification"), {255, 0, 0}, i18n.translate("command_received"))
										TriggerClientEvent("police:notify", player, "CHAR_ANDREAS", 1, i18n.translate("title_notification"), false, i18n.translate("become_cop_success"))
										TriggerClientEvent('police:nowCop', player)
									else
										TriggerClientEvent('chatMessage', source, i18n.translate("title_notification"), {255, 0, 0}, i18n.translate("no_player_with_this_id"))
									end
								end
							else
								TriggerClientEvent('chatMessage', source, i18n.translate("title_notification"), {255, 0, 0}, i18n.translate("not_enough_permission"))
							end
						else
							TriggerClientEvent('chatMessage', source, i18n.translate("title_notification"), {255, 0, 0}, i18n.translate("not_enough_permission"))
						end
					end)
				elseif(args[1] == "coprem") then
					local identifier = getPlayerID(source)
					MySQL.Async.fetchAll("SELECT * FROM police WHERE identifier = '"..identifier.."'", { ['@identifier'] = identifier}, function (result)
						if(result[1]) then
							if(result[1].rank >= config.rank.min_rank_set_rank) then
								if(not args[2]) then
									TriggerClientEvent('chatMessage', source, i18n.translate("title_notification"), {255, 0, 0}, i18n.translate("usage_command_coprem"))
								else
									if(GetPlayerName(tonumber(args[2])) ~= nil)then
										local player = tonumber(args[2])
										remCop(getPlayerID(player))
										TriggerClientEvent("police:notify", player, "CHAR_ANDREAS", 1, i18n.translate("title_notification"), false, i18n.translate("remove_from_cops"))
										TriggerClientEvent('chatMessage', source, i18n.translate("title_notification"), {255, 0, 0}, i18n.translate("command_received"))
										TriggerClientEvent('police:noLongerCop', player)
									else
										TriggerClientEvent('chatMessage', source, i18n.translate("title_notification"), {255, 0, 0}, i18n.translate("no_player_with_this_id"))
									end
								end
							else
								TriggerClientEvent('chatMessage', source, i18n.translate("title_notification"), {255, 0, 0}, i18n.translate("not_enough_permission"))
							end
						else
							TriggerClientEvent('chatMessage', source, i18n.translate("title_notification"), {255, 0, 0}, i18n.translate("not_enough_permission"))
						end
					end)
				end
			elseif(args[1] ~= "coprank") then
				TriggerClientEvent('chatMessage', source, "Cops FiveM", {255, 0, 0}, i18n.translate("cop_whitelist_disabled"))
			end
		end
	else
		if(config.displayRankBeforeNameOnChat) then
			CancelEvent()
			local identifier = getPlayerID(source)
			MySQL.Async.fetchAll("SELECT * FROM police WHERE identifier = '"..identifier.."'", { ['@identifier'] = identifier}, function (result)
				if(result[1]) then
					TriggerClientEvent('chatMessage', -1, "["..config.departments.minified_label[result[1].dept].."][".. config.rank.minified_label[result[1].rank] .."] "..name, {51, 204, 255}, message)
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
			if key > maxi then
				maxi = key
			end
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
					TriggerClientEvent("police:notify", tonumber(args[1]), "CHAR_ANDREAS", 1, i18n.translate("title_notification"), false, i18n.translate("become_cop_success"))
					TriggerClientEvent('police:receiveIsCop', tonumber(args[1]), maxi)
				else
					MySQL.Async.execute("UPDATE police SET rank = @maxi WHERE identifier = @identifier", { ['@identifier'] = identifier, ['@maxi'] = maxi})
					RconPrint(GetPlayerName(tonumber(args[1])) .. " is already in the police database, his rank is now update.\n")
					TriggerClientEvent('police:receiveIsCop', tonumber(args[1]), maxi)
					--setDept(source, player, 0)
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
					RconPrint(args[1] .. " is added in to the police database.\n")
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
					TriggerClientEvent("police:notify", tonumber(args[1]), "CHAR_ANDREAS", 1, i18n.translate("title_notification"), false, i18n.translate("become_cop_success"))
					TriggerClientEvent('police:receiveIsCop', tonumber(args[1]), 0)
					RconPrint(GetPlayerName(tonumber(args[1])) .. " is now added in to the police database.\n")
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
					TriggerClientEvent("police:notify", tonumber(args[1]), "CHAR_ANDREAS", 1, i18n.translate("title_notification"), false, i18n.translate("remove_from_cops"))
					RconPrint(GetPlayerName(tonumber(args[1])) .. " is now removed from the police database.\n")
				end
			end)
		end
		
		CancelEvent()
	end
	
	if commandName == 'CopRank' then
		if #args ~= 2 then
				RconPrint("Usage: CopRank [steam:hex|ingame-id] [rank]\n")
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
					RconPrint(args[1] .. " information has been updated.\n")
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
					RconPrint(GetPlayerName(tonumber(args[1])) .. " information has been updated.\n")
				end
			end)
		end
		
		CancelEvent()
	end
end)

RegisterServerEvent('police:notifyCops')
AddEventHandler('police:notifyCops', function(text)
	message = tostring(text)
	name = GetPlayerName(source)
	for k,v in pairs(inServiceCops) do
		print("Sending notification to cop: " ..GetPlayerName(k))
		TriggerClientEvent('police:notify-sm', k, name .." ".. message)
	end
end)


RegisterServerEvent('police:dispatchSend')
AddEventHandler('police:dispatchSend', function(title, text)
	header = tostring(title)
	message = tostring(text)
	name = GetPlayerName(source)

	for k,v in pairs(inServiceCops) do
		TriggerClientEvent("police:notify", k, "CHAR_CALL911", 1, 'Dispatch', header, message)
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

local function paycheck()
	timeInterval = tonumber(config.PayoutInterval * 60000)

	SetTimeout(timeInterval, function()
			for k,v in pairs(inServiceCops) do
				TriggerEvent("es:getPlayerFromId", k, function(user)
					if user then
						cash = math.random(800, 2000)						
						user.addMoney(math.random(800, 2000))
						TriggerClientEvent("police:notify", k, "CHAR_BANK_FLEECA", 9, "Fleeca Bank", i18n.translate("government_deposit_title"), "~g~$".. cash.. " ".. i18n.translate("government_deposit_msg"))
					end
				end)
			end
		paycheck()
	end)
end

if config.IsEssentialModeEnabled then
	paycheck()
end
