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

local buttonsCategories = {}
local buttonsAnimation = {}
local buttonsBackup = {}
local buttonsCitizen = {}
local buttonsFine = {}
local buttonsVehicle = {}
local buttonsProps = {}

function load_menu()
	for k in ipairs (buttonsCategories) do
		buttonsCategories [k] = nil
	end
	
	for k in ipairs (buttonsAnimation) do
		buttonsAnimation [k] = nil
	end

	for k in ipairs (buttonsBackup) do
		buttonsBackup [k] = nil
	end	
	
	for k in ipairs (buttonsCitizen) do
		buttonsCitizen [k] = nil
	end
	
	for k in ipairs (buttonsFine) do
		buttonsFine [k] = nil
	end
	
	for k in ipairs (buttonsVehicle) do
		buttonsVehicle [k] = nil
	end
	
	for k in ipairs (buttonsProps) do
		buttonsProps [k] = nil
	end
	
	--Categories
	buttonsCategories[#buttonsCategories+1] = {name = i18n.translate("menu_animations_title"), func = "OpenAnimMenu", params = ""}
	buttonsCategories[#buttonsCategories+1] = {name = i18n.translate("menu_backup_title"), func = "OpenBackupMenu", params = ""}
	buttonsCategories[#buttonsCategories+1] = {name = i18n.translate("menu_citizens_title"), func = "OpenCitizenMenu", params = ""}
	buttonsCategories[#buttonsCategories+1] = {name = i18n.translate("menu_vehicles_title"), func = "OpenVehMenu", params = ""}
	buttonsCategories[#buttonsCategories+1] = {name = i18n.translate("menu_props_title"), func = "OpenPropsMenu", params = ""}
	
	--Animations
	buttonsAnimation[#buttonsAnimation+1] = {name = i18n.translate("menu_anim_do_traffic_title"), func = 'DoTraffic', params = ""}
	buttonsAnimation[#buttonsAnimation+1] = {name = i18n.translate("menu_anim_take_notes_title"), func = 'Note', params = ""}
	buttonsAnimation[#buttonsAnimation+1] = {name = i18n.translate("menu_anim_standby_title"), func = 'StandBy', params = ""}
	buttonsAnimation[#buttonsAnimation+1] = {name = i18n.translate("menu_anim_standby_2_title"), func = 'StandBy2', params = ""}
	buttonsAnimation[#buttonsAnimation+1] = {name = i18n.translate("menu_anim_Cancel_emote_title"), func = 'CancelEmote', params = ""}

	--Backup options
	buttonsBackup[#buttonsBackup+1] = {name = i18n.translate("menu_backup_panic"), func = 'DoPanic', params = ""}
	buttonsBackup[#buttonsBackup+1] = {name = 'Local Patrol Unit', func = 'SendBackupForPlayer', params = "localPatrol"}
	buttonsBackup[#buttonsBackup+1] = {name = 'State Patrol Unit', func = 'SendBackupForPlayer', params = "localState"}
	buttonsBackup[#buttonsBackup+1] = {name = 'Local SWAT Team', func = 'SendBackupForPlayer', params = "prison"}
	buttonsBackup[#buttonsBackup+1] = {name = 'NOOSE SWAT Team', func = 'SendBackupForPlayer', params = "prison"}
	buttonsBackup[#buttonsBackup+1] = {name = 'Local Air Support Unit', func = 'SendBackupForPlayer', params = "localHeli"}
	buttonsBackup[#buttonsBackup+1] = {name = 'NOOSE Air Support Unit', func = 'SendBackupForPlayer', params = "localHeli"}
	buttonsBackup[#buttonsBackup+1] = {name = 'Prison Transportation', func = 'SendPrisonTransport', params = ""}

	
	--Citizens
	buttonsCitizen[#buttonsCitizen+1] = {name = i18n.translate("menu_weapons_title"), func = 'RemoveWeapons', params = ""}
	buttonsCitizen[#buttonsCitizen+1] = {name = i18n.translate("menu_toggle_cuff_title"), func = 'ToggleCuff', params = ""}
	buttonsCitizen[#buttonsCitizen+1] = {name = i18n.translate("menu_force_player_get_in_car_title"), func = 'PutInVehicle', params = ""}
	buttonsCitizen[#buttonsCitizen+1] = {name = i18n.translate("menu_force_player_get_out_car_title"), func = 'UnseatVehicle', params = ""}
	buttonsCitizen[#buttonsCitizen+1] = {name = i18n.translate("menu_drag_player_title"), func = 'DragPlayer', params = ""}
	buttonsCitizen[#buttonsCitizen+1] = {name = i18n.translate("menu_fines_title"), func = 'OpenMenuFine', params = ""}
	buttonsCitizen[#buttonsCitizen+1] = {name = i18n.translate("menu_cancel_vehicle_title"), func = 'CancelCitizenStop', params = ""}
	
	--Fines
	buttonsFine[#buttonsFine+1] = {name = "$250", func = 'Fines', params = 250}
	buttonsFine[#buttonsFine+1] = {name = "$500", func = 'Fines', params = 500}
	buttonsFine[#buttonsFine+1] = {name = "$1000", func = 'Fines', params = 1000}
	buttonsFine[#buttonsFine+1] = {name = "$1500", func = 'Fines', params = 1500}
	buttonsFine[#buttonsFine+1] = {name = "$2000", func = 'Fines', params = 2000}
	buttonsFine[#buttonsFine+1] = {name = "$4000", func = 'Fines', params = 4000}
	buttonsFine[#buttonsFine+1] = {name = "$6000", func = 'Fines', params = 6000}
	buttonsFine[#buttonsFine+1] = {name = "$8000", func = 'Fines', params = 8000}
	buttonsFine[#buttonsFine+1] = {name = "$10000", func = 'Fines', params = 10000}
	buttonsFine[#buttonsFine+1] = {name = i18n.translate("menu_custom_amount_fine_title"), func = 'Fines', params = -1}
	
	--Vehicles
	buttonsVehicle[#buttonsVehicle+1] = {name = i18n.translate("menu_crochet_veh_title"), func = 'Crochet', params = ""}

	--Props
	for k,v in pairs(SpawnObjects) do
		buttonsProps[#buttonsProps+1] = {name = v.name, func = "SpawnProps", params = tostring(v.hash)}
	end

	buttonsProps[#buttonsProps+1] = {name = i18n.translate("menu_remove_last_props_title"), func = "RemoveLastProps", params = ""}
	buttonsProps[#buttonsProps+1] = {name = i18n.translate("menu_remove_all_props_title"), func = "RemoveAllProps", params = ""}
end

function DoTraffic()
	Citizen.CreateThread(function()
        TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_CAR_PARK_ATTENDANT", 0, false)
        Citizen.Wait(60000)
        ClearPedTasksImmediately(PlayerPedId())
    end)
	drawNotification(i18n.translate("menu_doing_traffic_notification"))
end

function DoPanic()

	RequestAnimDict("random@arrests")
	while not HasAnimDictLoaded("random@arrests") do
		Citizen.Wait(0)
	end

    OpenSequenceTask(radioTask)
    TaskPlayAnim(PlayerPedId(),"random@arrests", "generic_radio_enter", 8.0, -4.0, -1, 0, 0, 0, 0, 0)
    TaskPlayAnim(PlayerPedId(), "random@arrests", "generic_radio_chatter", 8.0, -4.0, -1, 0, 0, 0, 0, 0)
    TaskPlayAnim(PlayerPedId(), "random@arrests","generic_radio_exit", 8.0, -1.5, -1, 0, 0, 0, 0, 0)
    CloseSequenceTask(radioTask)

    TaskPerformSequence(PlayerPedId(), radioTask)
    ClearSequenceTask(radioTask)
    ClearPedTasks(PlayerPedId())

    RemoveAnimDict("random@arrests")

	local name = GetPlayerName(PlayerId())
	local x,y,z = table.unpack(GetEntityCoords(PlayerPedId(), true))
	local StreetHash = GetStreetNameAtCoord(x,y,z)
	local location = GetStreetNameFromHashKey(StreetHash)
	local ZoneName = GetFullZoneName(CurrentZone)

	TriggerServerEvent('police:dispatchSend', i18n.translate("backup_required"), i18n.translate("officer") .. ':~y~' ..name ..' ~n~~w~' .. i18n.translate("street") ..': ~y~'.. location.. '~n~~w~'.. i18n.translate("zone") ..': ~y~'.. ZoneName)
end

function Note()
	Citizen.CreateThread(function()
        TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_CLIPBOARD", 0, false)
        Citizen.Wait(20000)
        ClearPedTasksImmediately(PlayerPedId())
    end) 
	drawNotification(i18n.translate("menu_taking_notes_notification"))
end

function StandBy()
	Citizen.CreateThread(function()
        TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_COP_IDLES", 0, true)
        Citizen.Wait(20000)
        ClearPedTasksImmediately(PlayerPedId())
    end)
	drawNotification(i18n.translate("menu_being_stand_by_notification"))
end

function StandBy2()
	Citizen.CreateThread(function()
        TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_GUARD_STAND", 0, 1)
        Citizen.Wait(20000)
        ClearPedTasksImmediately(PlayerPedId())
    end)
	drawNotification(i18n.translate("menu_being_stand_by_notification"))
end

function CancelEmote()
	Citizen.CreateThread(function()
        ClearPedTasksImmediately(PlayerPedId())
    end)
end

function RemoveWeapons()
    local t, distance = GetClosestPlayer()
    if(distance ~= -1 and distance < 3) then
        TriggerServerEvent("police:removeWeapons", GetPlayerServerId(t))
    else
        TriggerEvent('chatMessage', i18n.translate("title_notification"), {255, 0, 0}, i18n.translate("no_player_near_ped"))
    end
end

function CancelCitizenStop()
	if DoesEntityExist(selectedPed) then
		if DoesBlipExist(PedBlip) then
			RemoveBlip(PedBlip)
		end

		ClearPedTasksImmediately(selectedPed)
		SetEntityAsNoLongerNeeded(selectedPed)
		selectedPed = nil
	end
end

function ToggleCuff()
	local t, distance = GetClosestPlayer()
	if(distance ~= -1 and distance < 3) then
		TriggerServerEvent("police:cuffGranted", GetPlayerServerId(t))
	else
		if DoesEntityExist(selectedPed) then
			TriggerEvent("police:cuffPed", selectedPed)
		else
			TriggerEvent('chatMessage', i18n.translate("title_notification"), {255, 0, 0}, i18n.translate("no_player_near_ped"))
		end
	end
end

function PutInVehicle()
	local t, distance = GetClosestPlayer()
	if(distance ~= -1 and distance < 3) then
		local v = GetVehiclePedIsIn(PlayerPedId(), true)
		TriggerServerEvent("police:forceEnterAsk", GetPlayerServerId(t), v)
	else
		if DoesEntityExist(selectedPed) then
			if IsPedInAnyPoliceVehicle(PlayerPedId()) then
				local currentVeh = GetVehiclePedIsUsing(PlayerPedId())
				if(IsVehicleSeatFree(currentVeh, 1)) then
					SetPedIntoVehicle(selectedPed, currentVeh, 1)
				else 
					if(IsVehicleSeatFree(currentVeh, 2)) then
						SetPedIntoVehicle(selectedPed, currentVeh, 2)
					end
				end
			else
				drawNotification(i18n.translate("not_inside_polveh"))
			end
		else
			TriggerEvent('chatMessage', i18n.translate("title_notification"), {255, 0, 0}, i18n.translate("no_player_near_ped"))
		end
	end
end

function UnseatVehicle()
	local t, distance = GetClosestPlayer()
	if(distance ~= -1 and distance < 3) then
		TriggerServerEvent("police:confirmUnseat", GetPlayerServerId(t))
	else
		if DoesEntityExist(selectedPed) then
			if not IsPedInAnyPoliceVehicle(selectedPed) then
				TaskLeaveVehicle(selectedPed, GetVehiclePedIsIn(selectedPed, false), 1)
			else
				TaskLeaveVehicle(selectedPed, GetVehiclePedIsIn(selectedPed, false),1)
				ClearPedTasks(selectedPed)
				Citizen.Wait(2000)
				ToggleCuff()
			end
		else
			TriggerEvent('chatMessage', i18n.translate("title_notification"), {255, 0, 0}, i18n.translate("no_player_near_ped"))
		end
	end
end

function DragPlayer()
	local t, distance = GetClosestPlayer()
	if(distance ~= -1 and distance < 3) then
		if not IsEntityAttachedToEntity(GetPlayerServerId(t), PlayerPedId()) then
			TriggerServerEvent("police:dragRequest", GetPlayerServerId(t))
			TriggerEvent("police:notify", "CHAR_ANDREAS", 1, i18n.translate("title_notification"), false, i18n.translate("drag_sender_notification_part_1") .. GetPlayerName(serverTargetPlayer) .. i18n.translate("drag_sender_notification_part_2"))
		else
			DetachEntity(GetPlayerServerId(t), PlayerPedId(), false)
		end
	else
		if DoesEntityExist(selectedPed) then
			if not IsEntityAttachedToEntity(selectedPed, PlayerPedId()) then
				AttachEntityToEntity(selectedPed, PlayerPedId(), 4103, 11816, 0.48, 0.00, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
			else
				DetachEntity(selectedPed, PlayerPedId(), false)
			end
		else
			TriggerEvent('chatMessage', i18n.translate("title_notification"), {255, 0, 0}, i18n.translate("no_player_near_ped"))
		end
	end
end

function Fines(amount)
	local t, distance = GetClosestPlayer()
	if(distance ~= -1 and distance < 3) then
		Citizen.Trace("Price : "..tonumber(amount))
		if(tonumber(amount) == -1) then
			DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8S", "", "", "", "", "", 20)
			while (UpdateOnscreenKeyboard() == 0) do
				DisableAllControlActions(0);
				Wait(0);
			end
			if (GetOnscreenKeyboardResult()) then
				local res = tonumber(GetOnscreenKeyboardResult())
				if(res ~= nil and res ~= 0) then
					amount = tonumber(res)
				end
			end
			
			if(tonumber(amount) ~= -1) then
				TriggerServerEvent("police:finesGranted", GetPlayerServerId(t), tonumber(amount))
			end
		else
			TriggerServerEvent("police:finesGranted", GetPlayerServerId(t), tonumber(amount))
		end
	else
		TriggerEvent('chatMessage', i18n.translate("title_notification"), {255, 0, 0}, i18n.translate("no_player_near_ped"))
	end
end

function Crochet()
	Citizen.CreateThread(function()
		local pos = GetEntityCoords(PlayerPedId())
		local entityWorld = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 20.0, 0.0)

		local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, PlayerPedId(), 0)
		local _, _, _, _, vehicleHandle = GetRaycastResult(rayHandle)
		if(DoesEntityExist(vehicleHandle)) then
			local prevObj = GetClosestObjectOfType(pos.x, pos.y, pos.z, 10.0, GetHashKey("prop_weld_torch"), false, true, true)
			if(IsEntityAnObject(prevObj)) then
				SetEntityAsMissionEntity(prevObj)
				DeleteObject(prevObj)
			end
			TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_WELDING", 0, true)
			Citizen.Wait(20000)
			SetVehicleDoorsLocked(vehicleHandle, 1)
			ClearPedTasksImmediately(PlayerPedId())
			drawNotification(i18n.translate("menu_veh_opened_notification"))
		else
			drawNotification(i18n.translate("no_veh_near_ped"))
		end
	end)
end

function CheckPlate()
	local pos = GetEntityCoords(PlayerPedId())
	local entityWorld = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 20.0, 0.0)

	local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, PlayerPedId(), 0)
	local _, _, _, _, vehicleHandle = GetRaycastResult(rayHandle)
	if(DoesEntityExist(vehicleHandle)) then
		TriggerServerEvent("police:checkingPlate", GetVehicleNumberPlateText(vehicleHandle))
	else
		drawNotification(i18n.translate("no_veh_near_ped"))
	end
end

local propslist = {}

function SpawnProps(model)
	if not IsPedInAnyVehicle(PlayerPedId(), false) then
		if(#propslist < config.propsSpawnLimitByCop) then
			local prophash = GetHashKey(tostring(model))

			RequestModel(prophash)
			while not HasModelLoaded(prophash) do
				Citizen.Wait(0)
			end

			local offset = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.75, 0.0)
			local _, worldZ = GetGroundZFor_3dCoord(offset.x, offset.y, offset.z)
			local propsobj = CreateObjectNoOffset(prophash, offset.x, offset.y, worldZ, true, true, true)
			local heading = GetEntityHeading(PlayerPedId())

			SetEntityHeading(propsobj, heading)
			SetEntityAsMissionEntity(propsobj)
			SetModelAsNoLongerNeeded(prophash)

			propslist[#propslist+1] = ObjToNet(propsobj)
			end
		else
			DisplayHelpTextTimed("You can not use this option inside a vehicle", 3000)
		end
	end

function RemoveLastProps()
	DeleteObject(NetToObj(propslist[#propslist]))
	propslist[#propslist] = nil
end

function RemoveAllProps()
	for i, props in pairs(propslist) do
		DeleteObject(NetToObj(props))
		propslist[i] = nil
	end
end

function SendPrisonTransport()
if not DoesEntityExist(TransportVehicle) then
    if not DoesEntityExist(selectedPed) then
    	drawNotification("There is no target to transport.")
    else
    	local vehModel = GetHashKey("PBus")
    	local pedModel = GetHashKey("s_m_m_prisguard_01")

    	RequestModel(vehModel)
    	RequestModel(pedModel)

    	RequestAnimDict("random@arrests")
    	while not HasAnimDictLoaded("random@arrests") do
    		Citizen.Wait(0)
    	end

    	while not HasModelLoaded(vehModel) do
    		Citizen.Wait(0)
    	end

    	while not HasModelLoaded(pedModel) do
    		Citizen.Wait(0)
    	end

    	if not IsPedInAnyVehicle(PlayerPedId(), false) then
    		radioTask = 0

    		OpenSequenceTask(radioTask)
    		TaskPlayAnim(PlayerPedId(),"random@arrests", "generic_radio_enter", 8.0, -4.0, -1, 0, 0, 0, 0, 0)
    		TaskPlayAnim(PlayerPedId(), "random@arrests", "generic_radio_chatter", 8.0, -4.0, -1, 0, 0, 0, 0, 0)
    		TaskPlayAnim(PlayerPedId(), "random@arrests","generic_radio_exit", 8.0, -1.5, -1, 0, 0, 0, 0, 0)
    		CloseSequenceTask(radioTask)
    		TaskPerformSequence(PlayerPedId(), radioTask)
    		ClearSequenceTask(radioTask)
    		ClearPedTasks(PlayerPedId())
    	end

    	local x, y, z = table.unpack(GetEntityCoords(selectedPed))
    	local _, vector = GetNthClosestVehicleNode(x, y, z, math.random(10, 50), 0, 0, 0)    	
    	local dX, dY, dZ = table.unpack(vector) 

    	 TransportVehicle = CreateVehicle(vehModel, dX, dY, dZ, 0.0, true, false)
    	 TransportDriver = CreatePedInsideVehicle(vehicle, 4, pedModel, -1, true, 0)


    	TaskVehicleDriveToCoordLongrange(driver, vehicle, x, y, z, 20.0, 318, 10.0)
    	table.insert(prisonTransport, {vehicle = vehicle, driver = driver})

    	SetModelAsNoLongerNeeded(vehModel)
    	SetModelAsNoLongerNeeded(pedModel)
    end
 end
end

function SendBackupForPlayer(Backuptype)
    if(#bresponders < 3) then
    	if Backuptype == "localPatrol" then
    		vehModel = GetHashKey("police3")
    		pedModel = GetHashKey("s_m_y_cop_01")
    	elseif Backuptype == "localState" then
    		vehModel = GetHashKey("sheriff")
    		pedModel = GetHashKey("s_m_y_cop_01")
    	elseif Backuptype == "statePatrol" then
    		vehModel = GetHashKey("policet")
    		pedModel = GetHashKey("s_m_y_cop_01")
    	elseif Backuptype == "localHeli" then
    		vehModel = GetHashKey("polmav")
    		pedModel = GetHashKey("s_m_y_cop_01")
    	end

    	if IsModelValid(vehModel) then
    		RequestModel(vehModel)
    		while not HasModelLoaded(vehModel) do
    			Citizen.Wait(0)
    		end
    	else
    		drawNotification('Could not load the vehicle model: ~y~' .. vehModel)
    	end

    	if IsModelValid(pedModel) then
    		RequestModel(pedModel)
    		while not HasModelLoaded(pedModel) do
    			Citizen.Wait(0)
    		end
    	else
    		drawNotification('Could not load the ped model: ~y~'.. pedModel)
    	end

    	RequestAnimDict("random@arrests")
    	while not HasAnimDictLoaded("random@arrests") do
    		Citizen.Wait(0)
    	end

    	if not IsPedInAnyVehicle(PlayerPedId(), false) then
    		radioTask = 0
    		OpenSequenceTask(radioTask)
    		TaskPlayAnim(PlayerPedId(),"random@arrests", "generic_radio_enter", 8.0, -4.0, -1, 0, 0, 0, 0, 0)
    		TaskPlayAnim(PlayerPedId(), "random@arrests", "generic_radio_chatter", 8.0, -4.0, -1, 0, 0, 0, 0, 0)
    		TaskPlayAnim(PlayerPedId(), "random@arrests","generic_radio_exit", 8.0, -1.5, -1, 0, 0, 0, 0, 0)
    		CloseSequenceTask(radioTask)
    		TaskPerformSequence(PlayerPedId(), radioTask)
    		ClearSequenceTask(radioTask)
    		ClearPedTasks(PlayerPedId())
    	end

    	if HasModelLoaded(vehModel) and HasModelLoaded(pedModel) then
    		local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
    		local _, vector = GetNthClosestVehicleNode(x, y, z, math.random(10, 30), 0, 0, 0)    	
    		local dX, dY, dZ = table.unpack(vector) 

    		local heading = GetEntityHeading(PlayerPedId())
    		backupCar = CreateVehicle(vehModel,  dX, dY, dZ, heading, true, false)

    		if not DoesEntityExist(backupCar) then
    			if vehModel == GetHashKey("polmav") then
    				backupCar = CreateVehicle(vehModel,  dX, dY, dZ+10.0, heading, true, false)

    				SetHeliBladesFullSpeed(backupCar)
    				SetVehicleLivery(backupCar, 0)
    				SetVehicleSearchlight(backupCar, true, true)
    			else
    				ClearAreaOfVehicles(dX, dY, dZ, 30.0, false, false, false, false, false)
    				backupCar = CreateVehicle(vehModel,  dX, dY, dZ, 0.0, true, false)
    				SetVehicleOnGroundProperly(backupCar)
    				ClearAreaOfVehicles(dX, dY, dZ, 30.0, false, false, false, false, false)
    			end
    		end

    		N_0x48adc8a773564670()

    		backupDriver = CreatePedInsideVehicle(backupCar, 4, pedModel, -1, true, 0)
    		GiveWeaponToPed(backupDriver, GetHashKey("weapon_pistol"), -1, false, true)

    		SetPedCombatAttributes(backupDriver, 0, false)
    		SetPedCombatAttributes(backupDriver, 1, true)
    		SetPedCombatAttributes(backupDriver, 2, true)
    		SetPedCombatAttributes(backupDriver, 3, true)
    		SetPedCombatAttributes(backupDriver, 16, true)
    		SetPedCombatAttributes(backupDriver, 46, true)
    		--SetPedCombatAttributes(driver, 17, 0)
 
    		SetPedRelationshipGroupHash(backupDriver, "COP")
    		SetDriverAggressiveness(driver, 1.0)

    		if not DoesBlipExist(backupBlip) then
    			local backupBlip = AddBlipForEntity(backupCar)
    			SetBlipColour(backupBlip, 12)
    		end

    		carmodel = GetEntityModel(backupCar)

    		if not DoesEntityExist(selectedPed) then
    			if IsPedInAnyHeli(backupDriver) then
    				TaskHeliChase(backupDriver, PlayerPedId(), 0.0, 0.0, 0.0)
    			else
    				TaskVehicleDriveToCoordLongrange(backupDriver, backupCar, x, y, z, 20.0, 411, 10.0)
    			end
    		else
    			if IsPedInAnyHeli(backupDriver) then
    				TaskHeliChase(backupDriver, selectedPed, 0.0, 0.0, 0.0)
    			else
    				TaskArrestPed(backupDriver, selectedPed)   					
   				end

    			SetVehicleSiren(backupCar, true)
    			SetPedKeepTask(backupDriver, true)
    		end

    		SetPedKeepTask(backupDriver, true)

    		table.insert(bresponders, {vehicle = backupCar, driver = backupDriver, blip = backupBlip})
    		RemoveAnimDict("random@arrests")

    		SetModelAsNoLongerNeeded(vehModel)
    		SetModelAsNoLongerNeeded(pedModel)

    		FlashMinimapDisplay()
    	end
    else
    	DrawHelpTextTimed("All officers are occupied.", 3000)
    end
end

function TogglePoliceMenu()
	if not IsPauseMenuActive() then
		if((anyMenuOpen.menuName ~= "policemenu" and anyMenuOpen.menuName ~= "policemenu-anim" and anyMenuOpen.menuName ~="policemenu-backup" and anyMenuOpen.menuName ~= "policemenu-citizens" and anyMenuOpen.menuName ~= "policemenu-veh" and anyMenuOpen.menuName ~= "policemenu-fines" and anyMenuOpen.menuName ~= "policemenu-props") and not anyMenuOpen.isActive) then
			SendNUIMessage({
				title = i18n.translate("menu_global_title"),
				buttons = buttonsCategories,
				action = "setAndOpen"
				})
			anyMenuOpen.menuName = "policemenu"
			anyMenuOpen.isActive = true
		else
			if((anyMenuOpen.menuName ~= "policemenu" and anyMenuOpen.menuName ~= "policemenu-anim" and anyMenuOpen.menuName ~="policemenu-backup" and anyMenuOpen.menuName ~= "policemenu-citizens" and anyMenuOpen.menuName ~= "policemenu-veh" and anyMenuOpen.menuName ~= "policemenu-fines" and anyMenuOpen.menuName ~= "policemenu-props") and anyMenuOpen.isActive) then
				CloseMenu()
				TogglePoliceMenu()
			else
				CloseMenu()
			end
		end
	end
end

function BackMenuPolice()
	if(anyMenuOpen.menuName == "policemenu-anim" or anyMenuOpen.menuName =="policemenu-backup" or anyMenuOpen.menuName == "policemenu-citizens" or anyMenuOpen.menuName == "policemenu-veh" or anyMenuOpen.menuName == "policemenu-props") then
		CloseMenu()
		TogglePoliceMenu()
	else
		CloseMenu()
		OpenCitizenMenu()
	end
end

function OpenAnimMenu()
	CloseMenu()
	SendNUIMessage({
		title = i18n.translate("menu_animations_title"),
		buttons = buttonsAnimation,
		action = "setAndOpen"
	})
	
	anyMenuOpen.menuName = "policemenu-anim"
	anyMenuOpen.isActive = true
end

function OpenBackupMenu()
	CloseMenu()
	SendNUIMessage({
		title = i18n.translate("menu_backup_title"),
		buttons = buttonsBackup,
		action = "setAndOpen"
	})
	
	anyMenuOpen.menuName = "policemenu-backup"
	anyMenuOpen.isActive = true
end

function OpenCitizenMenu()
	CloseMenu()
	SendNUIMessage({
		title = i18n.translate("menu_citizens_title"),
		buttons = buttonsCitizen,
		action = "setAndOpen"
	})
	
	anyMenuOpen.menuName = "policemenu-citizens"
	anyMenuOpen.isActive = true
end

function OpenVehMenu()
	CloseMenu()
	SendNUIMessage({
		title = i18n.translate("menu_vehicles_title"),
		buttons = buttonsVehicle,
		action = "setAndOpen"
	})
	
	anyMenuOpen.menuName = "policemenu-veh"
	anyMenuOpen.isActive = true
end

function OpenMenuFine()
	CloseMenu()
	SendNUIMessage({
		title = i18n.translate("menu_fines_title"),
		buttons = buttonsFine,
		action = "setAndOpen"
	})
	
	anyMenuOpen.menuName = "policemenu-fines"
	anyMenuOpen.isActive = true
end

function OpenPropsMenu()
	CloseMenu()
	SendNUIMessage({
		title = i18n.translate("menu_props_title"),
		buttons = buttonsProps,
		action = "setAndOpen"
	})
	
	anyMenuOpen.menuName = "policemenu-props"
	anyMenuOpen.isActive = true
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		for _, props in pairs(propslist) do
			local ox, oy, oz = table.unpack(GetEntityCoords(NetToObj(props), true))
			local cVeh = GetClosestVehicle(ox, oy, oz, 20.0, 0, 70)
			if(IsEntityAVehicle(cVeh)) then
				if IsEntityAtEntity(cVeh, NetToObj(props), 20.0, 20.0, 2.0, 0, 1, 0) then
					local cDriver = GetPedInVehicleSeat(cVeh, -1)
					TaskVehicleTempAction(cDriver, cVeh, 6, 1000)
					
					SetVehicleHandbrake(cVeh, true)
					SetVehicleIndicatorLights(cVeh, 0, true)
					SetVehicleIndicatorLights(cVeh, 1, true)
				end
			end

		end
	end
end)