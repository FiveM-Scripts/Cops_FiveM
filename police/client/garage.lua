local buttons = {}

function load_garage()
	for k in ipairs (buttons) do
		buttons [k] = nil
	end
	
	buttons[#buttons+1] = {name = "Police's car", func = "SpawnerVeh", params = "police3"}
	buttons[#buttons+1] = {name = "Undercover's car", func = "SpawnerVeh", params = "fbi"}
	buttons[#buttons+1] = {name = "Police's Motorcycle", func = "SpawnerVeh", params = "policeb"}
end

function SpawnerVeh(hash)
	local car = GetHashKey(hash)
	local playerPed = GetPlayerPed(-1)
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
	local netid = NetworkGetNetworkIdFromEntity(policevehicle)
	SetNetworkIdCanMigrate(netid, true)
	NetworkRegisterEntityAsNetworked(VehToNet(policevehicle))
	TaskWarpPedIntoVehicle(playerPed, policevehicle, -1)
	SetEntityInvincible(policevehicle, false)
	SetEntityAsMissionEntity(policevehicle, true, true)
end

function OpenGarage()
	CloseMenu()
	SendNUIMessage({
		title = txt[config.lang]["garage_global_title"],
		buttons = buttons,
		action = "setAndOpen"
	})
	
	anyMenuOpen.menuName = "garage"
	anyMenuOpen.isActive = true
end