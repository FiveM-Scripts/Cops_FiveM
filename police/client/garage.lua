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

	for k, data in pairs(vehicles) do
		if dept == k then
			for k, v in pairs(data) do
				buttons[#buttons+1] = {name = tostring(v.name), func = "SpawnFakeCar", params = tostring(v.model)}
			end
		end
	end
end

function GoToGarage()
	DoScreenFadeOut(500)
	Citizen.Wait(550)
	DoScreenFadeIn(500)

	if IsEntityInZone(PlayerPedId(), "SKID") then
		if not DoesCamExist(cam) then
			cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 0)

			SetCamActive(cam, true)
			SetCamParams(cam, 434.5799, -1022.2443, 28.7053, 9.7449, 0.0, -20.5193, 53.0748, 0, 1, 1, 2)
			SetCamParams(cam, 434.5799, -1022.2443, 28.7053, 38.2499, 1.0, -20.5193, 53.0748, 7000, 1, 1, 2)
			RenderScriptCams(true, false, 3000, 1, 0, 0)

			Citizen.Wait(8000)
			SetEntityCoords(PlayerPedId(), 396.32305908203, -967.68560791016, -99.3919-1.0001)
			SetEntityHeading(PlayerPedId(), 357.7341)

			RenderScriptCams(false, false, -1, 0, 0)
			DestroyCam(cam, true)
		end
	else
		SetEntityCoords(PlayerPedId(), 396.32305908203, -967.68560791016, -99.3919-1.0001)
	end

    Citizen.Wait(400)

    if not DoesCamExist(garageCam) then
    	garageCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    	SetCamCoord(garageCam, 396.85205078125, -961.65075683594, -99.004150390625)
    	RenderScriptCams(true, false, 3000, 1, 0, 0)
    end

    DisplayHelpTextTimed(i18n.translate("help_text_leave_garage"), 5000)
    FreezeEntityPosition(PlayerPedId(), true)
    SetEntityVisible(PlayerPedId(), false, true)   	
    SetPlayerInvisibleLocally(PlayerId(), true)

    OpenGarage()
end

function SpawnFakeCar(hash)
	if not IsHelpMessageBeingDisplayed() then
		DisplayHelpTextTimed(i18n.translate("help_text_leave_garage"), 10000)
	end

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

	fakePolVehicle = CreateVehicle(car, 396.56185913086, -955.76940917969, -99.392028808594, 166.05145263672, false, false)
	SetVehicleMod(fakePolVehicle, 11, 2)
	SetVehicleMod(fakePolVehicle, 12, 2)
	SetVehicleMod(fakePolVehicle, 13, 2)

	SetEntityHeading(fakePolVehicle, 166.05145263672)
	SetVehicleOnGroundProperly(fakePolVehicle)
	SetVehRadioStation(fakePolVehicle, "OFF")

	TaskWarpPedIntoVehicle(playerPed, fakePolVehicle, -1)
end

function SpawnerVeh()
	RenderScriptCams(false, false, -1, 0, 0)
	DestroyCam(garageCam, true)

	local playerPed = PlayerPedId()

	if IsPedInAnyVehicle(PlayerPedId(), false) then
		currentVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		carmodel = GetEntityModel(currentVehicle)
		DeleteEntity(currentVehicle)
	end

	RequestModel(carmodel)
	while not HasModelLoaded(carmodel) do
		Citizen.Wait(0)
	end

	policevehicle = CreateVehicle(carmodel, oldGarageCoords, 90.0, true, false)
	SetVehicleMod(policevehicle, 11, 2)
	SetVehicleMod(policevehicle, 12, 2)
	SetVehicleMod(policevehicle, 13, 2)

	SetVehicleEnginePowerMultiplier(policevehicle, 35.0)
	SetVehicleOnGroundProperly(policevehicle)
	SetVehicleHasBeenOwnedByPlayer(policevehicle,true)

	SetVehRadioStation(policevehicle, "OFF")	

	local netid = NetworkGetNetworkIdFromEntity(policevehicle)
	SetNetworkIdCanMigrate(netid, true)
	NetworkRegisterEntityAsNetworked(VehToNet(policevehicle))

	TaskWarpPedIntoVehicle(playerPed, policevehicle, -1)
	SetEntityInvincible(policevehicle, false)
	SetEntityVisible(PlayerPedId(), true, 0)

	SetModelAsNoLongerNeeded(carmodel)
	CloseMenu()
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

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if DoesCamExist(cam) then
			HideHudAndRadarThisFrame()
		end

		if DoesCamExist(garageCam) then
			HideHudAndRadarThisFrame()
		end		
	end
end)