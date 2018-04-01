--
--Local variables : Please do not touch theses variables
--

i18n.setLang(tostring(config.lang))

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

local clockInStation = {
  {x=850.156677246094, y=-1283.92004394531, z=28.0047378540039}, -- La Mesa
  {x=457.956909179688, y=-992.72314453125, z=30.6895866394043}, -- Mission Row
  {x=1856.91320800781, y=3689.50073242188, z=34.2670783996582}, -- Sandy Shore
  {x=-450.063201904297, y=6016.5751953125, z=31.7163734436035} -- Paleto Bay
}

local garageStation = {
	{x=-470.85266113281, y=6022.9296875, z=31.340530395508},  -- La Mesa
	{x=1873.3372802734, y=3687.3508300781, z=33.616954803467},  -- Mission Row
	{x=452.115966796875, y=-1018.10681152344, z=28.4786586761475}, -- Sandy Shore
	{x=855.24249267578, y=-1279.9300537109, z=26.513223648071 }  --Paleto Bay
}

local heliStation = {
	{x=449.113966796875, y=-981.084966796875, z=43.691966796875} -- Mission Row
}

local armoryStation = {
	{x=452.119966796875, y=-980.061966796875, z=30.690966796875},
	{x=853.157, y=-1267.74, z= 26.6729},	
	{x=1849.63, y=3689.48, z=34.2671},
	{x=-448.219, y= 6008.98, z=31.7164}
}

--
--Events handlers
--

AddEventHandler("playerSpawned", function()
	TriggerServerEvent("police:checkIsCop")
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

-- Copy/paste from fs_freeroam (by FiveM-Script : https://github.com/FiveM-Scripts/fs_freemode)
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
	DrawText(x , y)
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
	if(distance < 30) then
		DrawMarker(1, pos.x, pos.y, pos.z-1, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 0, 155, 255, 200, 0, 0, 2, 0, 0, 0, 0)
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
	if(distance < 30) then
		DrawMarker(1, pos.x, pos.y, pos.z-1, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 1.0, 0, 155, 255, 200, 0, 0, 2, 0, 0, 0, 0)
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
	
	if(distance < 30) then
		DrawMarker(1, pos.x, pos.y, pos.z-1, 0, 0, 0, 0, 0, 0, 2.5, 2.5, 1.0, 0, 155, 255, 200, 0, 0, 2, 0, 0, 0, 0)
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
	if(distance < 30) then
		DrawMarker(1, pos.x, pos.y, pos.z-1, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 0, 155, 255, 200, 0, 0, 2, 0, 0, 0, 0)
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
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
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
        Citizen.Wait(10)
		
		DisablePlayerVehicleRewards(PlayerId())
		
		--Embedded NeverWanted script // Loop part
		if(config.enableNeverWanted == true) then
			SetPlayerWantedLevel(PlayerId(), 0, false)
			SetPlayerWantedLevelNow(PlayerId(), false)
			ClearAreaOfCops()
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
			elseif (IsControlJustPressed(1,173)) then
				SendNUIMessage({
					action = "keydown"
				})
			elseif (IsControlJustPressed(1,176)) then
				SendNUIMessage({
					action = "keyenter"
				})
			elseif (IsControlJustPressed(1,177)) then
				if(anyMenuOpen.menuName == "policemenu" or anyMenuOpen.menuName == "armory" or anyMenuOpen.menuName == "cloackroom" or anyMenuOpen.menuName == "garage") then
					CloseMenu()
				elseif(anyMenuOpen.menuName == "armory-weapon_list") then
					BackArmory()
				else
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

			local myPed = PlayerPedId(-1)
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
		
        if(isCop) then
			if(isNearTakeService()) then
			
				DisplayHelpText(i18n.translate("help_text_open_cloackroom"),0,1,0.5,0.8,0.6,255,255,255,255) -- ~g~E~s~
				if IsControlJustPressed(1,config.bindings.interact_position) then
					OpenCloackroom()
				end
			end
			
			if(isInService) then
			
				--Open Garage menu
				if(isNearStationGarage()) then
					if(policevehicle ~= nil) then
						DisplayHelpText(i18n.translate("help_text_put_car_into_garage"),0,1,0.5,0.8,0.6,255,255,255,255)
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
				
				--Open Garage menu
				if(isNearArmory()) then
					
					DisplayHelpText(i18n.translate("help_text_open_armory"),0,1,0.5,0.8,0.6,255,255,255,255)
					
					if IsControlJustPressed(1,config.bindings.interact_position) then
						OpenArmory()
					end
				end
				
				--Open/Close Menu police
				if (IsControlJustPressed(1,config.bindings.use_police_menu)) then
					TogglePoliceMenu()
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
			plyPos = GetEntityCoords(ped,  true)
			SetEntityCoords(ped, plyPos.x, plyPos.y, plyPos.z)    
		end
		Citizen.Wait(1000)
	end
end)