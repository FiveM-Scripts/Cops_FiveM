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

--
--Local variables : Please do not touch theses variables
--

if(config.useCopWhitelist == true) then
	isCop = false
else
	isCop = true
end

local isInService = false
local policeHeli = nil
local handCuffed = false
local isAlreadyDead = false
local allServiceCops = {}
local blipsCops = {}
local drag = false
local officerDrag = -1

rank = -1

anyMenuOpen = {
	menuName = "",
	isActive = false
}

SpawnedSpikes = {}

--
--Events handlers
--

AddEventHandler("playerSpawned", function()
	TriggerServerEvent("police:checkIsCop")
		if isInService then
		if StayOnDutyAfterDeath then
			
			RequestModel(modelHash)
			while not HasModelLoaded(modelHash) do
				Wait(0)
			end

			SetPlayerModel(PlayerId(), modelHash)
			SetPedAsCop(PlayerPedId(), true)
			giveBasicKit()
			SetModelAsNoLongerNeeded(modelHash)
			isCop = true
		end
	end
end)


RegisterNetEvent('police:cuffPed')
AddEventHandler('police:cuffPed', function(ped)
	if not IsEntityPlayingAnim(ped, "mp_arresting", "idle", 49) then
		RequestAnimDict('mp_arresting')
		while not HasAnimDictLoaded('mp_arresting') do
			Citizen.Wait(0)
		end

		if IsPedBeingStunned(ped, 0) then
			ClearPedTasksImmediately(ped)
		end

		TaskPlayAnim(ped, "mp_arresting", "idle", 8.0, -8, -1, 49, 0, 0, 0, 0)
		SetPedKeepTask(ped, true)
		SetEnableHandcuffs(ped, true)
		RemoveAnimDict('mp_arresting')
--		CancelEvent()
	end
end)

RegisterNetEvent('police:receiveIsCop')
AddEventHandler('police:receiveIsCop', function(svrank,svdept)
	if(svrank == -1) then
		if(config.useCopWhitelist == true) then
			isCop = false
		else
			isCop = true
			rank = 0
			dept = 0
			load_cloackroom()
			load_armory()
			load_garage()
			load_menu()
		end
	else
		isCop = true
		rank = svrank
		dept = svdept
		if(isInService) then --and config.enableOutfits
			if(GetEntityModel(PlayerPedId()) == GetHashKey("mp_m_freemode_01")) then
				SetPedComponentVariation(PlayerPedId(), 10, 8, config.rank.outfit_badge[rank], 2)
			else
				SetPedComponentVariation(PlayerPedId(), 10, 7, config.rank.outfit_badge[rank], 2)
			end
		end

		load_cloackroom()
		load_armory()
		load_garage()
		load_menu()

		if(rank >= config.rank.min_rank_set_rank) then
			TriggerEvent('chat:addSuggestion', "/copadd", "Add a cop into the whitelist", {{name = "id", help = "The ID of the player"}})
			TriggerEvent('chat:addSuggestion', "/coprem", "Remove a cop from the whitelist", {{name = "id", help = "The ID of the player"}})
			TriggerEvent('chat:addSuggestion', "/coprank", "Set rank of a cop officier", {{name = "id", help = "The ID of the player"}, {name = "rank", help = "The numeric value of the rank"}})
			TriggerEvent('chat:addSuggestion', "/copdept", "Set rank of a cop officier", {{name = "id", help = "The ID of the player"}, {name = "dept", help = "The numeric value of the department"}})
		else
			TriggerEvent('chat:removeSuggestion', "/copadd")
			TriggerEvent('chat:removeSuggestion', "/coprem")
			TriggerEvent('chat:removeSuggestion', "/coprank")
			TriggerEvent('chat:removeSuggestion', "/copdept")
		end
	end
end)

if(config.useCopWhitelist == true) then
	RegisterNetEvent('police:nowCop')
	AddEventHandler('police:nowCop', function()
		isCop = true
	end)
end

if(config.useCopWhitelist == true) then
	RegisterNetEvent('police:noLongerCop')
	AddEventHandler('police:noLongerCop', function()
		if(config.useCopWhitelist == true) then
			isCop = false
		end

		isInService = false

		if(config.enableOutfits == true) then
			RemoveAllPedWeapons(PlayerPedId())
			TriggerServerEvent("skin_customization:SpawnPlayer")
		else
			local model = GetHashKey("a_m_y_mexthug_01")

			RequestModel(model)
			while not HasModelLoaded(model) do
				Citizen.Wait(0)
			end
		 
			SetPlayerModel(PlayerId(), model)
			SetModelAsNoLongerNeeded(model)
			RemoveAllPedWeapons(PlayerPedId())
		end
		
		if(policeHeli ~= nil) then
			SetEntityAsMissionEntity(policeHeli, true, true)
			Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(policeHeli))
			policeHeli = nil
		end
		
		TriggerEvent('chat:removeSuggestion', "/copadd")
		TriggerEvent('chat:removeSuggestion', "/coprem")
		TriggerEvent('chat:removeSuggestion', "/coprank")
		TriggerEvent('chat:removeSuggestion', "/copdept")

		ServiceOff()
	end)
end

RegisterNetEvent('police:getArrested')
AddEventHandler('police:getArrested', function()
	handCuffed = not handCuffed
	if(handCuffed) then
		TriggerEvent("police:notify",  "CHAR_ANDREAS", 1, i18n.translate("title_notification"), false, i18n.translate("now_cuffed"))
	else
		TriggerEvent("police:notify",  "CHAR_ANDREAS", 1, i18n.translate("title_notification"), false, i18n.translate("now_uncuffed"))
		drag = false
	end
end)

--Inspired from emergency for request system (by Jyben : https://forum.fivem.net/t/release-job-save-people-be-a-hero-paramedic-emergency-coma-ko/19773)
local lockAskingFine = false
RegisterNetEvent('police:payFines')
AddEventHandler('police:payFines', function(amount, sender)
	Citizen.CreateThread(function()
		
		if(lockAskingFine ~= true) then
			lockAskingFine = true
			local notifReceivedAt = GetGameTimer()
			Notification(i18n.translate("info_fine_request_before_amount")..amount..i18n.translate("info_fine_request_after_amount"))
			while(true) do
				Wait(0)
				
				if (GetTimeDifference(GetGameTimer(), notifReceivedAt) > 15000) then
					TriggerServerEvent('police:finesETA', sender, 2)
					Notification(i18n.translate("request_fine_expired"))
					lockAskingFine = false
					break
				end
				
				if IsControlPressed(1, config.bindings.accept_fine) then
					if(config.useModifiedBanking == true) then
						TriggerServerEvent('bank:withdrawAmende', amount)
					else
						TriggerServerEvent('bank:withdraw', amount)
					end
					Notification(i18n.translate("pay_fine_success_before_amount")..amount..i18n.translate("pay_fine_success_after_amount"))
					TriggerServerEvent('police:finesETA', sender, 0)
					lockAskingFine = false
					break
				end
				
				if IsControlPressed(1, config.bindings.refuse_fine) then
					TriggerServerEvent('police:finesETA', sender, 3)
					lockAskingFine = false
					break
				end
			end
		else
			TriggerServerEvent('police:finesETA', sender, 1)
		end
	end)
end)

-- Copy/paste from fs_freemode (by FiveM-Script: https://github.com/FiveM-Scripts/fs_freemode)
RegisterNetEvent("police:notify")
AddEventHandler("police:notify", function(icon, type, sender, title, text)
	SetNotificationTextEntry("STRING");
	AddTextComponentString(text);
	SetNotificationMessage(icon, icon, true, type, sender, title, text);
	DrawNotification(false, true);
end)

if(config.useVDKInventory == true) then
	RegisterNetEvent('police:dropIllegalItem')
	AddEventHandler('police:dropIllegalItem', function(id)
		TriggerEvent("player:looseItem", tonumber(id), exports.vdk_inventory:getQuantity(id))
	end)
end

--Piece of code given by Thefoxeur54
RegisterNetEvent('police:unseatme')
AddEventHandler('police:unseatme', function(t)
	local ped = GetPlayerPed(t)        
	ClearPedTasksImmediately(ped)
	plyPos = GetEntityCoords(PlayerPedId(),  true)
	local xnew = plyPos.x+2
	local ynew = plyPos.y+2
   
	SetEntityCoords(PlayerPedId(), xnew, ynew, plyPos.z)
end)

RegisterNetEvent('police:toggleDrag')
AddEventHandler('police:toggleDrag', function(t)
	if(handCuffed) then
		drag = not drag
		officerDrag = t
	end
end)

RegisterNetEvent('police:forcedEnteringVeh')
AddEventHandler('police:forcedEnteringVeh', function(veh)
	if(handCuffed) then
		local pos = GetEntityCoords(PlayerPedId())
		local entityWorld = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 20.0, 0.0)

		local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, PlayerPedId(), 0)
		local _, _, _, _, vehicleHandle = GetRaycastResult(rayHandle)

		if vehicleHandle ~= nil then
			if(IsVehicleSeatFree(vehicleHandle, 1)) then
				SetPedIntoVehicle(PlayerPedId(), vehicleHandle, 1)
			else 
				if(IsVehicleSeatFree(vehicleHandle, 2)) then
					SetPedIntoVehicle(PlayerPedId(), vehicleHandle, 2)
				end
			end
		end
	end
end)

RegisterNetEvent('police:removeWeapons')
AddEventHandler('police:removeWeapons', function()
    RemoveAllPedWeapons(PlayerPedId(), true)
end)

if(config.enableOtherCopsBlips == true) then
	RegisterNetEvent('police:resultAllCopsInService')
	AddEventHandler('police:resultAllCopsInService', function(array)
		allServiceCops = array
		enableCopBlips()
	end)
end

if(config.useModifiedEmergency == true) then
	RegisterNetEvent('es_em:cl_ResPlayer')
	AddEventHandler('es_em:cl_ResPlayer', function()
		if(isCop and isInService) then
			ServiceOff()
		end
		
		if(handCuffed == true) then
			handCuffed = false
		end
	end)
end

--
--Functions
--

function Notification(msg)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(msg)
	DrawNotification(0,1)
end

function drawNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

local function SetJailCoords()
	local JailBlip = AddBlipForCoord(1854.97, 2608.57, 45.2842)
	SetBlipColour(JailBlip, 83)
	SetBlipRoute(JailBlip, true)

	return JailBlip
end

--From Player Blips and Above Head Display (by Scammer : https://forum.fivem.net/t/release-scammers-script-collection-09-03-17/3313)
function enableCopBlips()
	for k, existingBlip in pairs(blipsCops) do
        RemoveBlip(existingBlip)
    end
	blipsCops = {}
	
	local localIdCops = {}
	for id = 0, 64 do
		if(NetworkIsPlayerActive(id) and GetPlayerPed(id) ~= PlayerPedId()) then
			for i,c in pairs(allServiceCops) do
				if(i == GetPlayerServerId(id)) then
					localIdCops[id] = c
					break
				end
			end
		end
	end
	
	for id, c in pairs(localIdCops) do
		local ped = GetPlayerPed(id)
		local blip = GetBlipFromEntity(ped)
		
		if not DoesBlipExist(blip) then

			blip = AddBlipForEntity(ped)
			SetBlipSprite(blip, 1)
			Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, true)
			HideNumberOnBlip( blip)
			SetBlipNameToPlayerName(blip, id)
			
			SetBlipScale(blip,  0.85)
			SetBlipAlpha(blip, 255)
			
			table.insert(blipsCops, blip)
		else			
			blipSprite = GetBlipSprite(blip)
			
			HideNumberOnBlip(blip)
			if blipSprite ~= 1 then
				SetBlipSprite(blip, 1)
				Citizen.InvokeNative(0x5FBCA48327B914DF, blip, true)
			end
			
			SetBlipNameToPlayerName(blip, id)
			SetBlipScale(blip, 0.85)
			SetBlipAlpha(blip, 255)
			
			table.insert(blipsCops, blip)
		end
	end
end

function GetPlayers()
    local players = {}

    for i = 0, 31 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, i)
        end
    end

    return players
end

function GetClosestPlayer()
	local players = GetPlayers()
	local closestDistance = -1
	local closestPlayer = -1
	local ply = PlayerPedId()
	local plyCoords = GetEntityCoords(ply, 0)
	
	for index,value in ipairs(players) do
		local target = GetPlayerPed(value)
		if(target ~= ply) then
			local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
			local distance = Vdist(targetCoords["x"], targetCoords["y"], targetCoords["z"], plyCoords["x"], plyCoords["y"], plyCoords["z"])
			if(closestDistance == -1 or closestDistance > distance) then
				closestPlayer = value
				closestDistance = distance
			end
		end
	end
	
	return closestPlayer, closestDistance
end

function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(centre)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x, y)
end

function isNearTakeService()
	local distance = 10000
	local pos = {}
	for i = 1, #clockInStation do
		local coords = GetEntityCoords(PlayerPedId(), 0)
		local currentDistance = Vdist(clockInStation[i].x, clockInStation[i].y, clockInStation[i].z, coords.x, coords.y, coords.z)
		if(currentDistance < distance) then
			distance = currentDistance
			pos = clockInStation[i]
		end
	end
	
	if anyMenuOpen.menuName == "cloackroom" and anyMenuOpen.isActive and distance > 3 then
		CloseMenu()
	end
	
	if config.EnablePoliceMarkers then
		if(distance < 30) then
			DrawMarker(1, pos.x, pos.y, pos.z-1, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 0, 155, 255, 200, 0, 0, 2, 0, 0, 0, 0)
		end
	end

	if(distance < 2) then
		return true
	end
end

function isNearStationGarage()
	local distance = 10000
	local pos = {}
	for i = 1, #garageStation do
		local coords = GetEntityCoords(PlayerPedId(), 0)
		local currentDistance = Vdist(garageStation[i].x, garageStation[i].y, garageStation[i].z, coords.x, coords.y, coords.z)
		if(currentDistance < distance) then
			distance = currentDistance
			pos = garageStation[i]
		end
	end
	
	if anyMenuOpen.menuName == "garage" and anyMenuOpen.isActive and distance > 5 then
		CloseMenu()
	end

	if config.EnablePoliceMarkers then
		if(distance < 30) then
			DrawMarker(1, pos.x, pos.y, pos.z-1, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 1.0, 0, 155, 255, 200, 0, 0, 2, 0, 0, 0, 0)
		end
	end

	if(distance < 2) then
		return true
	end
end

function isNearHelicopterStation()
	local distance = 10000
	local pos = {}

	for i = 1, #heliStation do
		local coords = GetEntityCoords(PlayerPedId(), 0)
		local currentDistance = Vdist(heliStation[i].x, heliStation[i].y, heliStation[i].z, coords.x, coords.y, coords.z)
		if(currentDistance < distance) then
			distance = currentDistance
			pos = heliStation[i]
		end
	end

	if config.EnablePoliceMarkers then
		if(distance < 30) then
			DrawMarker(1, pos.x, pos.y, pos.z-1, 0, 0, 0, 0, 0, 0, 2.5, 2.5, 1.0, 0, 155, 255, 200, 0, 0, 2, 0, 0, 0, 0)
		end
	end

	if(distance < 2) then
		return true
	end
end

function isNearArmory()
	local distance = 10000
	local pos = {}

	for i = 1, #armoryStation do
		local coords = GetEntityCoords(PlayerPedId(), 0)
		local currentDistance = Vdist(armoryStation[i].x, armoryStation[i].y, armoryStation[i].z, coords.x, coords.y, coords.z)
		if(currentDistance < distance) then
			distance = currentDistance
			pos = armoryStation[i]
		end
	end
	
	if (anyMenuOpen.menuName == "armory" or anyMenuOpen.menuName == "armory-weapon_list") and anyMenuOpen.isActive and distance > 2 then
		CloseMenu()
	end

	if config.EnablePoliceMarkers then
		if(distance < 30) then
			DrawMarker(1, pos.x, pos.y, pos.z-1, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 0, 155, 255, 200, 0, 0, 2, 0, 0, 0, 0)
		end
	end

	if(distance < 2) then
		return true
	end
end

function ServiceOn()
	isInService = true

	if(config.useJobSystem == true) then
		TriggerServerEvent("jobssystem:jobs", config.job.officer_on_duty_job_id)
	end

	TriggerServerEvent("police:takeService")
end

function ServiceOff()
	isInService = false
	if(config.useJobSystem == true) then
		TriggerServerEvent("jobssystem:jobs", config.job.officer_not_on_duty_job_id)
	end
	TriggerServerEvent("police:breakService")
	
	if(config.enableOtherCopsBlips == true) then
		allServiceCops = {}
		
		for k, existingBlip in pairs(blipsCops) do
			RemoveBlip(existingBlip)
		end
		blipsCops = {}
	end
end

function DisplayHelpText(str)
	BeginTextCommandDisplayHelp("STRING")
	AddTextComponentSubstringPlayerName(str)
	EndTextCommandDisplayHelp(0, 0, 1, -1)
end

function GetFullZoneName(zone)
	local zones = {
	{zone="AIRP", name="Los Santos International Airport"},
	{zone="ALAMO", name="Alamo Sea"},
	{zone="ARMYB", name="Fort Zancudo"},
	{zone="BANHAMC", name="Banham Canyon Dr"},
	{zone="BANNING", name="Banning"},
	{zone="BEACH", name="Vespucci Beach"},
	{zone="BHAMCA", name="Banham Canyon"},
	{zone="BRADP", name="Braddock Pass"},
	{zone="BRADT", name="Braddock Tunnel"},
	{zone="BURTON", name="Burton"},
	{zone="CALAFB", name="Calafia Bridge"},
	{zone="CANNY", name="Raton Canyon"},
	{zone="CHAMH", name="Chamberlain Hills"},
	{zone="CHIL", name="Vinewood Hills"},
	{zone="CHU", name="Chumash"},
	{zone="CMSW", name="Chiliad Mountain State Wilderness"},
	{zone="CYPRE", name="Cypress Flats"},
	{zone="DAVIS", name="Davis"},
	{zone="DELBE", name="Del Perro Beach"},
	{zone="DELPE", name="Del Perro"},
	{zone="DELSOL", name="La Puerta"},
	{zone="DESRT", name="Grand Senora Desert"},
	{zone="DOWNT", name="Downtown"},
	{zone="DTVINE", name="Downtown Vinewood"},
	{zone="EAST_V", name="East Vinewood"},
	{zone="EBURO", name="El Burro Heights"},
	{zone="ELGORL", name="El Gordo Lighthouse"},
	{zone="ELYSIAN", name="Elysian Island"},
	{zone="GALFISH", name="Galilee"},
	{zone="GOLF", name="GWC and Golfing Society"},
	{zone="GRAPES", name="Grapeseed"},
	{zone="GREATC", name="Great Chaparral"},
	{zone="HARMO", name="Harmony"},
	{zone="HAWICK", name="Hawick"},
	{zone="HORS", name="Vinewood Racetrack"},
	{zone="HUMLAB", name="Humane Labs and Research"},
	{zone="JAIL", name="Bolingbroke Penitentiary"},
	{zone="KOREAT", name="Little Seoul"},
	{zone="LACT", name="Land Act Reservoir"},
	{zone="LAGO", name="Lago Zancudo"},
	{zone="LDAM", name="Land Act Dam"},
	{zone="LEGSQU", name="Legion Square"},
	{zone="LMESA", name="La Mesa"},
	{zone="LOSPUER", name="La Puerta"},
	{zone="MIRR", name="Mirror Park"},
	{zone="MORN", name="Morningwood"},
	{zone="MOVIE", name="Richards Majestic"},
	{zone="MTCHIL", name="Mount Chiliad"},
	{zone="MTGORDO", name="Mount Gordo"},
	{zone="MTJOSE", name="Mount Josiah"},
	{zone="MURRI", name="Murrieta Heights"},
	{zone="NCHU", name="North Chumash"},
	{zone="NOOSE", name="N.O.O.S.E"},
	{zone="OCEANA", name="Pacific Ocean"},
	{zone="PALCOV", name="Paleto Cove"},
	{zone="PALETO", name="Paleto Bay"},
	{zone="PALFOR", name="Paleto Forest"},
	{zone="PALHIGH", name="Palomino Highlands"},
	{zone="PALMPOW", name="Palmer-Taylor Power Station"},
	{zone="PBLUFF", name="Pacific Bluffs"},
	{zone="PBOX", name="Pillbox Hill"},
	{zone="PROCOB", name="Procopio Beach"},
	{zone="RANCHO", name="Rancho"},
	{zone="RGLEN", name="Richman Glen"},
	{zone="RICHM", name="Richman"},
	{zone="ROCKF", name="Rockford Hills"},
	{zone="RTRAK", name="Redwood Lights Track"},
	{zone="SANAND", name="San Andreas"},
	{zone="SANCHIA", name="San Chianski Mountain Range"},
	{zone="SANDY", name="Sandy Shores"},
	{zone="SKID", name="Mission Row"},
	{zone="SLAB", name="Stab City"},
	{zone="STAD", name="Maze Bank Arena"},
	{zone="STRAW", name="Strawberry"},
	{zone="TATAMO", name="Tataviam Mountains"},
	{zone="TERMINA", name="Terminal"},
	{zone="TEXTI", name="Textile City"},
	{zone="TONGVAH", name="Tongva Hills"},
	{zone="TONGVAV", name="Tongva Valley"},
	{zone="VCANA", name="Vespucci Canals"},
	{zone="VESP", name="Vespucci"},
	{zone="VINE", name="Vinewood"},
	{zone="WINDF", name="Ron Alternates Wind Farm"},
	{zone="WVINE", name="West Vinewood"},
	{zone="ZANCUDO", name="Zancudo River"},
	{zone="ZP_ORT", name="Port of South Los Santos"},
	{zone="ZQ_UAR", name="Davis Quartz"}
}
	local coords = GetEntityCoords(PlayerPedId(), 0)
	local name = GetNameOfZone(coords.x, coords.y, coords.z)

	for k,v in pairs(zones) do
		if v.zone == zone then
			return v.name
		end
	end
end

function CloseMenu()
	SendNUIMessage({
		action = "close"
	})
	
	anyMenuOpen.menuName = ""
	anyMenuOpen.isActive = false
end

RegisterNUICallback('sendAction', function(data, cb)
	_G[data.action](data.params)
    cb('ok')
end)

--
--Threads
--

local alreadyDead = false
local playerStillDragged = false

Citizen.CreateThread(function()

	--Embedded NeverWanted script // Non loop part
	if(config.enableNeverWanted == true) then
		SetPoliceIgnorePlayer(PlayerId(), true)
		SetDispatchCopsForPlayer(PlayerId(), false)

		Citizen.InvokeNative(0xDC0F817884CDD856, 1, false)
		Citizen.InvokeNative(0xDC0F817884CDD856, 2, false)
		Citizen.InvokeNative(0xDC0F817884CDD856, 3, false)
		Citizen.InvokeNative(0xDC0F817884CDD856, 5, false)
		Citizen.InvokeNative(0xDC0F817884CDD856, 8, false)
		Citizen.InvokeNative(0xDC0F817884CDD856, 9, false)
		Citizen.InvokeNative(0xDC0F817884CDD856, 10, false)
		Citizen.InvokeNative(0xDC0F817884CDD856, 11, false)
	end

	if config.stationBlipsEnabled then
		for _, item in pairs(clockInStation) do
			item.blip = AddBlipForCoord(item.x, item.y, item.z)
			SetBlipSprite(item.blip, 60)
			SetBlipAsShortRange(item.blip, true)

			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(i18n.translate("police_station"))
			EndTextCommandSetBlipName(item.blip)
		end
	end
	
    while true do
        Citizen.Wait(5)
        CurrentZone = GetNameOfZone(GetEntityCoords(PlayerPedId(), true))
		DisablePlayerVehicleRewards(PlayerId())	

		if(config.enableNeverWanted == true) then
			SetPlayerWantedLevel(PlayerId(), 0, false)
			SetPlayerWantedLevelNow(PlayerId(), false)
			HideHudComponentThisFrame(1)

			Cx, Cy, Cz = table.unpack(GetEntityCoords(PlayerPedId(), true))
			ClearAreaOfCops(Cx, Cy, Cz, 400.0, 0)
		end

		if(isInService) then
			if not selectedPed then
				if not IsPedInAnyVehicle(PlayerPedId(), false) and IsPlayerFreeAiming(PlayerId()) and IsPedAPlayer(PlayerPedId()) then
					local bool, targetPed = GetEntityPlayerIsFreeAimingAt(PlayerId())
					if IsEntityAPed(targetPed) then
						if not IsPedAPlayer(targetPed) then
							if GetEntityHealth(targetPed) > 1.0 then
								ClearPedTasks(targetPed)
								SetBlockingOfNonTemporaryEvents(targetPed, true)
								TaskTurnPedToFaceEntity(targetPed, PlayerPedId(), -1)

								NetworkRegisterEntityAsNetworked(PedToNet(targetPed))
								SetNetworkIdExistsOnAllMachines(PedToNet(targetPed), true)
								Wait(500)
								SetEntityAsMissionEntity(targetPed, true, true)
								selectedPed = targetPed
							end
						end
					end
				end
			else
				if IsEntityDead(selectedPed) then
					if DoesBlipExist(PedBlip) then
						drawNotification(i18n.translate("suspect_died"))

						RemoveBlip(PedBlip)
						SetEntityAsNoLongerNeeded(selectedPed)
						selectedPed = nil
					end
				else
					if not DoesBlipExist(PedBlip) then
						PlayAmbientSpeech1(selectedPed,  "GENERIC_CURSE_MED", "SPEECH_PARAMS_FORCE")
						
						PedBlip = AddBlipForEntity(selectedPed)
						SetBlipSprite(PedBlip, 1)
						SetBlipColour(PedBlip, 1)
					end

					if IsPedInAnyPoliceVehicle(selectedPed) then
						if not DoesBlipExist(JailBlip) then
							drawNotification("Bring the ~y~suspect~w~ to the prison.")
							JailBlip = SetJailCoords()
						end

						DrawMarker(1, 1854.97, 2608.57, 45.2842-1, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 0, 155, 255, 200, 0, 0, 2, 0, 0, 0, 0)
						if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId(), true), 1854.97, 2608.57, 45.2842, true) < 8.0 then
							PlaySoundFrontend(-1, "BASE_JUMP_PASSED", "HUD_AWARDS", true)
							TaskLeaveVehicle(selectedPed, GetVehiclePedIsIn(selectedPed, false), 1)
							Citizen.Wait(5000)
							DeleteEntity(selectedPed)
							RemoveBlip(JailBlip)
							selectedPed = nil
						end
					end		
				end
			end
		end

		if IsPedTryingToEnterALockedVehicle(PlayerPedId()) or IsPedJacking(PlayerPedId()) then
			x,y,z = table.unpack(GetEntityCoords(PlayerPedId(), true))
			StealVeh = GetVehiclePedIsUsing(PlayerPedId())

			if not sendNotify then

			local modelType = GetEntityModel(GetVehiclePedIsUsing(PlayerPedId()))
			local StreetHash = GetStreetNameAtCoord(x,y,z)
			local location = GetStreetNameFromHashKey(StreetHash)
			local ZoneName = GetFullZoneName(CurrentZone)
			   TriggerServerEvent('stolenVehicle', modelType, location, ZoneName)
			   sendNotify = true
			end
		else
			StealVeh = nil
			sendNotify = false
		end

		if(anyMenuOpen.isActive) then
			DisableControlAction(1, 21)
			DisableControlAction(1, 140)
			DisableControlAction(1, 141)
			DisableControlAction(1, 142)

			SetDisableAmbientMeleeMove(PlayerPedId(), true)

			if (IsControlJustPressed(1,172)) then
				SendNUIMessage({
					action = "keyup"
				})
				PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
			elseif (IsControlJustPressed(1,173)) then
				SendNUIMessage({
					action = "keydown"
				})
				PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
			elseif (anyMenuOpen.menuName == "cloackroom") then
				if IsControlJustPressed(1, 176) then
					SendNUIMessage({
						action = "keyenter"
					})

					Citizen.Wait(500)
					CloseMenu()
				end
			elseif (IsControlJustPressed(1,176)) then
				SendNUIMessage({
					action = "keyenter"
				})
				PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
			elseif (IsControlJustPressed(1,177)) then
				if(anyMenuOpen.menuName == "policemenu" or anyMenuOpen.menuName == "cloackroom" or anyMenuOpen.menuName == "garage") then
					CloseMenu()
				elseif(anyMenuOpen.menuName == "armory") then
					CloseArmory()					
				elseif(anyMenuOpen.menuName == "armory-weapon_list") then
					BackArmory()
				else
					EnableControlAction(1, tonumber(use_police_menu), true)
					BackMenuPolice()
				end
			end
		else
			EnableControlAction(1, 21)
			EnableControlAction(1, 140)
			EnableControlAction(1, 141)
			EnableControlAction(1, 142)
		end
		
		--Control death events
		if(config.useModifiedEmergency == false) then
			if(IsPlayerDead(PlayerId())) then
				if(alreadyDead == false) then
					if(isInService) then
						ServiceOff()
					end

					handCuffed = false
					drag = false
					alreadyDead = true
				end
			else
				alreadyDead = false
			end
		end
		
		if (handCuffed == true) then
			RequestAnimDict('mp_arresting')
			while not HasAnimDictLoaded('mp_arresting') do
				Citizen.Wait(0)
			end

			local myPed = PlayerPedId()
			local animation = 'idle'
			local flags = 16
			
			while(IsPedBeingStunned(myPed, 0)) do
				ClearPedTasksImmediately(myPed)
			end
			TaskPlayAnim(myPed, 'mp_arresting', animation, 8.0, -8, -1, flags, 0, 0, 0, 0)
		end
		
		--Piece of code from Drag command (by Frazzle, Valk, Michael_Sanelli, NYKILLA1127 : https://forum.fivem.net/t/release-drag-command/22174)
		if drag then
			local ped = GetPlayerPed(GetPlayerFromServerId(officerDrag))
			local myped = PlayerPedId()
			AttachEntityToEntity(myped, ped, 4103, 11816, 0.48, 0.00, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
			playerStillDragged = true
		else
			if(playerStillDragged) then
				DetachEntity(PlayerPedId(), true, false)
				playerStillDragged = false
			end
		end

		if (anyMenuOpen.menuName == "armory-weapon_list") then
	        HideHudAndRadarThisFrame()
	    end
		
        if(isCop) then
			if(isNearTakeService()) then
				if not (anyMenuOpen.isActive) then
				    DisplayHelpText(i18n.translate("help_text_open_cloackroom"),0,1,0.5,0.8,0.6,255,255,255,255)
				    if IsControlJustPressed(1,config.bindings.interact_position) then
				    	OpenCloackroom()
				    end
				end
			end
			
			if(isInService) then
			
				--Open Garage menu
				if(isNearStationGarage()) then
					if(policevehicle ~= nil) then
						if not (anyMenuOpen.isActive) then
							DisplayHelpText(i18n.translate("help_text_put_car_into_garage"),0,1,0.5,0.8,0.6,255,255,255,255)
						end
					else
						DisplayHelpText(i18n.translate("help_text_get_car_out_garage"),0,1,0.5,0.8,0.6,255,255,255,255)
					end
					
					if IsControlJustPressed(1,config.bindings.interact_position) then
						if(policevehicle ~= nil) then
							--Destroy police vehicle
							Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(policevehicle))
							policevehicle = nil
						else
							OpenGarage()
						end
					end
				end
				
				--Open Armory menu
				if(isNearArmory()) then
					if not (anyMenuOpen.isActive) then					
						DisplayHelpText(i18n.translate("help_text_open_armory"),0,1,0.5,0.8,0.6,255,255,255,255)

						if IsControlJustPressed(1,config.bindings.interact_position) then
							Lx, Ly, Lz = table.unpack(GetEntityCoords(PlayerPedId(), true))
							DoScreenFadeOut(500)
							Wait(600)

							SetEntityCoords(PlayerPedId(), 452.119966796875, -980.061966796875, 30.690966796875)
							armoryPed = createArmoryPed()
							if DoesEntityExist(armoryPed) then
								TaskTurnPedToFaceEntity(PlayerPedId(), armoryPed, -1)
							end

							Wait(900)
							DoScreenFadeIn(500)

							OpenArmory()
						end
					end
				end

				-- Setup the Armory Room
				if (anyMenuOpen.menuName == "armory") then
					TaskTurnPedToFaceEntity(PlayerPedId(), armoryPed, -1)
					if not DoesCamExist(ArmoryRoomCam) then
						ArmoryRoomCam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)
					else
						DoesCamExist(ArmoryRoomCam)
						HideHudAndRadarThisFrame()

						AttachCamToEntity(ArmoryRoomCam, PlayerPedId(), 0.0, 0.0, 1.0, true)
						PointCamAtEntity(ArmoryRoomCam, armoryPed, 0.0, -30.0, 1.0, true)

						SetCamRot(ArmoryRoomCam, 0.0,0.0, GetEntityHeading(PlayerPedId()))
						SetCamFov(ArmoryRoomCam, 70.0)
						RenderScriptCams(true, 1, 1800, 1, 0)
					end
				end


				--Open/Close Menu police
				if (IsControlJustPressed(1,config.bindings.use_police_menu)) then
					if not anyMenuOpen.isActive then 
						TogglePoliceMenu()
					end
				end
				
				--Control helicopter spawning
				if isNearHelicopterStation() then
					if(policeHeli ~= nil) then
						DisplayHelpText(i18n.translate("help_text_put_heli_into_garage"),0,1,0.5,0.8,0.6,255,255,255,255)
					else
						DisplayHelpText(i18n.translate("help_text_get_heli_out_garage"),0,1,0.5,0.8,0.6,255,255,255,255)
					end
					
					if IsControlJustPressed(1,config.bindings.interact_position)  then
						if(policeHeli ~= nil) then
							Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(policeHeli))
							policeHeli = nil
						else
							local heli = GetHashKey("polmav")
							local ply = PlayerPedId()
							local plyCoords = GetEntityCoords(ply, 0)
							
							RequestModel(heli)
							while not HasModelLoaded(heli) do
									Citizen.Wait(0)
							end
							
							policeHeli = CreateVehicle(heli, plyCoords["x"], plyCoords["y"], plyCoords["z"], 90.0, true, false)
							SetVehicleHasBeenOwnedByPlayer(policevehicle,true)

							local netid = NetworkGetNetworkIdFromEntity(policeHeli)
							SetNetworkIdCanMigrate(netid, true)
							NetworkRegisterEntityAsNetworked(VehToNet(policeHeli))
							
							SetVehicleLivery(policeHeli, 0)
							TaskWarpPedIntoVehicle(ply, policeHeli, -1)
							SetEntityAsMissionEntity(policeHeli, true, true)
						end
					end
				end
			end
		end
    end
end)

Citizen.CreateThread(function()
	while true do
		if drag then
			local ped = GetPlayerPed(GetPlayerFromServerId(playerPedDragged))
			plyPos = GetEntityCoords(ped, true)
			SetEntityCoords(ped, plyPos.x, plyPos.y, plyPos.z)    
		end
		Citizen.Wait(1000)
	end
end)
