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

local buttons = {}

function load_garage()
	for k in ipairs (buttons) do
		buttons [k] = nil
	end
	
	if dept == 0 then
		buttons[#buttons+1] = {name = "Park Ranger Truck", func = "SpawnerVeh", params = "pranger"}
	elseif dept == 1 then
		buttons[#buttons+1] = {name = "Police Stanier", func = "SpawnerVeh", params = "police"}
		buttons[#buttons+1] = {name = "Police Buffalo", func = "SpawnerVeh", params = "police2"}
		buttons[#buttons+1] = {name = "Police Interceptor", func = "SpawnerVeh", params = "police3"}
		buttons[#buttons+1] = {name = "Police Motorcycle", func = "SpawnerVeh", params = "policeb"}
		buttons[#buttons+1] = {name = "Police Transport Van", func = "SpawnerVeh", params = "policet"}
		buttons[#buttons+1] = {name = "Undercover Police Stanier", func = "SpawnerVeh", params = "police4"}
	elseif dept == 2 then
		buttons[#buttons+1] = {name = "Sheriff Stanier", func = "SpawnerVeh", params = "sheriff"}
		buttons[#buttons+1] = {name = "Sheriff Granger", func = "SpawnerVeh", params = "sheriff2"}
		buttons[#buttons+1] = {name = "Police Motorcycle", func = "SpawnerVeh", params = "policeb"}
	elseif dept == 3 then
		buttons[#buttons+1] = {name = "Police Buffalo", func = "SpawnerVeh", params = "police2"}
		buttons[#buttons+1] = {name = "FIB Buffalo", func = "SpawnerVeh", params = "fbi"}
		buttons[#buttons+1] = {name = "FIB Granger", func = "SpawnerVeh", params = "fbi2"}
	elseif dept == 4 then
		buttons[#buttons+1] = {name = "Police Stanier", func = "SpawnerVeh", params = "police"}		
		buttons[#buttons+1] = {name = "Prison Transport Van", func = "SpawnerVeh", params = "PBus"}
		buttons[#buttons+1] = {name = "Sheriff Stanier", func = "SpawnerVeh", params = "sheriff"}
	else
		buttons[#buttons+1] = {name = "Police Stanier", func = "SpawnerVeh", params = "police"}
		buttons[#buttons+1] = {name = "Police Buffalo", func = "SpawnerVeh", params = "police2"}
		buttons[#buttons+1] = {name = "Police Interceptor", func = "SpawnerVeh", params = "police3"}
		buttons[#buttons+1] = {name = "Police Motorcycle", func = "SpawnerVeh", params = "policeb"}
		buttons[#buttons+1] = {name = "Police Transport Van", func = "SpawnerVeh", params = "policet"}
		buttons[#buttons+1] = {name = "Undercover Police Stanier", func = "SpawnerVeh", params = "police4"}		
	end
end

function SpawnerVeh(hash)
	if IsPedInAnyVehicle(PlayerPedId(), false) then
		currentVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		DeleteEntity(currentVehicle)
	end

	local car = GetHashKey(hash)
	local playerPed = PlayerPedId()

	RequestModel(car)
	while not HasModelLoaded(car) do
		Citizen.Wait(0)
	end

	local playerCoords = GetEntityCoords(playerPed)
	local playerHeading = GetEntityHeading(playerPed)
	
	policevehicle = CreateVehicle(car, playerCoords, 90.0, true, false)
	SetVehicleMod(policevehicle, 11, 2)
	SetVehicleMod(policevehicle, 12, 2)
	SetVehicleMod(policevehicle, 13, 2)

	SetEntityHeading(policevehicle, (playerHeading+160)%360)
	SetVehicleEnginePowerMultiplier(policevehicle, 35.0)
	SetVehicleOnGroundProperly(policevehicle)
	SetVehicleHasBeenOwnedByPlayer(policevehicle,true)

	SetVehRadioStation(policevehicle, "OFF")	

	local netid = NetworkGetNetworkIdFromEntity(policevehicle)
	SetNetworkIdCanMigrate(netid, true)
	NetworkRegisterEntityAsNetworked(VehToNet(policevehicle))
	TaskWarpPedIntoVehicle(playerPed, policevehicle, -1)
	SetEntityInvincible(policevehicle, false)
end

function OpenGarage()
	CloseMenu()
	SendNUIMessage({
		title = i18n.translate("garage_global_title"),
		buttons = buttons,
		action = "setAndOpen"
	})
	
	anyMenuOpen.menuName = "garage"
	anyMenuOpen.isActive = true
end