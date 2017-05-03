--version 1.0.1

require "resources/essentialmode/lib/MySQL"
MySQL:open("127.0.0.1", "gta5_gamemode_essential", "root", "toor")

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
	local strResult = GetPlayerName(target).." own : "
    TriggerEvent("es:getPlayerFromId", target, function(player)
		local executed_query = MySQL:executeQuery("SELECT * FROM user_inventory JOIN items ON `user_inventory`.`item_id` = `items`.`id` JOIN recolt ON `recolt`.`raw_id` = `user_inventory`.`item_id` WHERE user_id = '@username'", { ['@username'] = player.identifier })
		local result = MySQL:getResults(executed_query, { 'quantity', 'libelle', 'item_id', 'job_id' }, "item_id")
		if (result) then
			for _, v in ipairs(result) do
				if(v.job_id == 6) then
					strResult = strResult .. v.quantity .. " de " .. v.libelle .. ", "
					TriggerClientEvent('police:dropIllegalItem', target, v.item_id)
				end
			end
		end
	end)
	
	return strResult

end

RegisterServerEvent('police:checkIsCop')
AddEventHandler('police:checkIsCop', function()
	TriggerEvent("es:getPlayerFromId", source, function(user)
		local identifier = user.identifier
		checkIsCop(identifier)
	end)
end)

RegisterServerEvent('police:targetCheckInventory')
AddEventHandler('police:targetCheckInventory', function(t)
	TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, checkInventory(t))
end)

RegisterServerEvent('police:finesGranted')
AddEventHandler('police:finesGranted', function(t, amount)
	TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, GetPlayerName(t).. " paid a $"..amount.." fines.")
	TriggerClientEvent('police:payFines', t, amount)
end)

RegisterServerEvent('police:cuffGranted')
AddEventHandler('police:cuffGranted', function(t)
	TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, GetPlayerName(t).. " toggle cuff (except if it's a cop :3 ) !")
	TriggerClientEvent('police:getArrested', t)
end)

RegisterServerEvent('police:forceEnterAsk')
AddEventHandler('police:forceEnterAsk', function(t, v)
	TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, GetPlayerName(t).. " get to the car ! (if he's cuffed :) )")
	TriggerClientEvent('police:forcedEnteringVeh', t, v)
end)

TriggerEvent('es:addCommand', 'check', function(source, args, user) 
	TriggerEvent("es:getPlayerFromId", source, function(player)
		local isCop = s_checkIsCop(player.identifier)
		if(isCop ~= "nil") then
			TriggerClientEvent('police:checkInventory', source)
		else
			TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "You don't have the permission to do this !")
		end
	end)
end)

TriggerEvent('es:addCommand', 'fines', function(source, args, user) 
	TriggerEvent("es:getPlayerFromId", source, function(player)
		local isCop = s_checkIsCop(player.identifier)
		if(isCop ~= "nil") then
			if(#args < 3) then
				TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "Usage : /fines [id] [amount]")
			else
				if(GetPlayerName(tonumber(args[2])) ~= nil)then
					TriggerClientEvent('police:fines', source, args[2], args[3])
				else
					TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "No player with this ID !")
				end
			end
		else
			TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "You don't have the permission to do this !")
		end
	end)
end)

TriggerEvent('es:addCommand', 'cuff', function(source, args, user) 
	TriggerEvent("es:getPlayerFromId", source, function(player)
		local isCop = s_checkIsCop(player.identifier)
		if(isCop ~= "nil") then
			TriggerClientEvent('police:cuff', source)
		else
			TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "You don't have the permission to do this !")
		end
	end)
end)

TriggerEvent('es:addCommand', 'forceEnter', function(source, args, user) 
	TriggerEvent("es:getPlayerFromId", source, function(player)
		local isCop = s_checkIsCop(player.identifier)
		if(isCop ~= "nil") then
			TriggerClientEvent('police:forceEnter', source)
		else
			TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "You don't have the permission to do this !")
		end
	end)
end)

TriggerEvent('es:addAdminCommand', 'copadd', 100000, function(source, args, user) 
     if(not args[2]) then
		TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "Usage : /copadd [ID]")	
	else
		if(GetPlayerName(tonumber(args[2])) ~= nil)then
			local player = tonumber(args[2])
			TriggerEvent("es:getPlayerFromId", player, function(target)
				addCop(target.identifier)
				TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "Roger that !")
				TriggerClientEvent('chatMessage', player, 'SYSTEM', {255, 0, 0}, "Congrats, you're now a cop !")
				TriggerClientEvent('police:nowCop', player)
			end)
		else
			TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "No player with this ID !")
		end
	end
end, function(source, args, user) 
	TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "You don't have the permission to do this !")
end)

TriggerEvent('es:addAdminCommand', 'coprem', 100000, function(source, args, user) 
     if(not args[2]) then
		TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "Usage : /coprem [ID]")	
	else
		if(GetPlayerName(tonumber(args[2])) ~= nil)then
			local player = tonumber(args[2])
			TriggerEvent("es:getPlayerFromId", player, function(target)
				remCop(target.identifier)
				TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "Roger that !")
				TriggerClientEvent('chatMessage', player, 'SYSTEM', {255, 0, 0}, "You're no longer a cop !")
				TriggerClientEvent('police:noLongerCop', player)
			end)
		else
			TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "No player with this ID !")
		end
	end
end, function(source, args, user) 
	TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "You don't have the permission to do this !")
end)
