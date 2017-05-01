require "resources/essentialmode/lib/MySQL"
MySQL:open("127.0.0.1", "gta5_gamemode_essential", "root", "space031")

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

function fouille(target)
	local strResult = GetPlayerName(target).." possede : "
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

RegisterServerEvent('police:checkIsCop')
AddEventHandler('police:checkIsCop', function()
	TriggerEvent("es:getPlayerFromId", source, function(user)
		local identifier = user.identifier
		checkIsCop(identifier)
	end)
end)

RegisterServerEvent('police:targetFouilleEmpty')
AddEventHandler('police:targetFouilleEmpty', function()
	TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "Aucun joueur à portée !")
end)

RegisterServerEvent('police:targetFouille')
AddEventHandler('police:targetFouille', function(t)
	TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, fouille(t))
end)

RegisterServerEvent('police:amendeGranted')
AddEventHandler('police:amendeGranted', function(t, amount)
	TriggerEvent("es:getPlayerFromId", t, function(target)
		TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "Amende pour "..GetPlayerName(t).. " de $"..amount..".")
		TriggerClientEvent('police:payAmende', t, amount)
	end)
end)

RegisterServerEvent('police:cuffGranted')
AddEventHandler('police:cuffGranted', function(t)
	TriggerEvent("es:getPlayerFromId", t, function(target)
		TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, GetPlayerName(t).. " toggle menotte (sauf si c'est un policier :3 ) !")
		TriggerClientEvent('police:getArrested', t)
	end)
end)

RegisterServerEvent('police:forceEnterAsk')
AddEventHandler('police:forceEnterAsk', function(t)
	TriggerEvent("es:getPlayerFromId", t, function(target)
		TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, GetPlayerName(t).. " dans ma voiture ! (s'il est menotté :) )")
		TriggerClientEvent('police:forcedEnteringVeh', t)
	end)
end)

TriggerEvent('es:addCommand', 'fouille', function(source, args, user) 
	TriggerEvent("es:getPlayerFromId", source, function(player)
		local isCop = s_checkIsCop(player.identifier)
		if(isCop ~= "nil") then
			TriggerClientEvent('police:fouille', source)
		else
			TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "Vous n'avez pas la permission d'executer cette commande !")
		end
	end)
end)

TriggerEvent('es:addCommand', 'amende', function(source, args, user) 
	TriggerEvent("es:getPlayerFromId", source, function(player)
		local isCop = s_checkIsCop(player.identifier)
		if(isCop ~= "nil") then
			if(#args < 3) then
				TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "Usage : /amende [id] [amount]")
			else
				TriggerClientEvent('police:amende', source, args[2], args[3])
			end
		else
			TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "Vous n'avez pas la permission d'executer cette commande !")
		end
	end)
end)

TriggerEvent('es:addCommand', 'cuff', function(source, args, user) 
	TriggerEvent("es:getPlayerFromId", source, function(player)
		local isCop = s_checkIsCop(player.identifier)
		if(isCop ~= "nil") then
			TriggerClientEvent('police:cuff', source)
		else
			TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "Vous n'avez pas la permission d'executer cette commande !")
		end
	end)
end)

TriggerEvent('es:addCommand', 'forceEnter', function(source, args, user) 
	TriggerEvent("es:getPlayerFromId", source, function(player)
		local isCop = s_checkIsCop(player.identifier)
		if(isCop ~= "nil") then
			TriggerClientEvent('police:forceEnter', source)
		else
			TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "Vous n'avez pas la permission d'executer cette commande !")
		end
	end)
end)

TriggerEvent('es:addCommand', 'cuff', function(source, args, user) 
	TriggerEvent("es:getPlayerFromId", source, function(player)
		local isCop = s_checkIsCop(player.identifier)
		if(isCop ~= "nil") then
			TriggerClientEvent('police:cuff', source)
		else
			TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "Vous n'avez pas la permission d'executer cette commande !")
		end
	end)
end)

TriggerEvent('es:addAdminCommand', 'copadd', 100000, function(source, args, user) 
     if(not args[2]) then
		TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "Utilisation : /copadd <ID du joueur>")	
	else
		if(GetPlayerName(tonumber(args[2])) ~= nil)then
			local player = tonumber(args[2])
			TriggerEvent("es:getPlayerFromId", player, function(target)
				addCop(target.identifier)
				TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "Bien reçu !")
				TriggerClientEvent('chatMessage', player, 'SYSTEM', {255, 0, 0}, "Félicitation, vous êtes désormais policier !")
				TriggerClientEvent('police:nowCop', player)
			end)
		else
			TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "Joueur introuvable !")
		end
	end
end, function(source, args, user) 
	TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "Vous n'avez pas la permission d'executer cette commande !")
end)

TriggerEvent('es:addAdminCommand', 'coprem', 100000, function(source, args, user) 
     if(not args[2]) then
		TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "Utilisation : /coprem <ID du joueur>")	
	else
		if(GetPlayerName(tonumber(args[2])) ~= nil)then
			local player = tonumber(args[2])
			TriggerEvent("es:getPlayerFromId", player, function(target)
				remCop(target.identifier)
				TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "Bien reçu !")
				TriggerClientEvent('chatMessage', player, 'SYSTEM', {255, 0, 0}, "Vous avez été suspendu de vos fonctions de policier !")
				TriggerClientEvent('police:noLongerCop', player)
			end)
		else
			TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "Joueur introuvable !")
		end
	end
end, function(source, args, user) 
	TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "Vous n'avez pas la permission d'executer cette commande !")
end)