local buttons = {}
buttons[#buttons+1] = {name = "Police's car", func = "Spawnpolice3"}
buttons[#buttons+1] = {name = "Undercover's car", func = "Spawnfbi"}
buttons[#buttons+1] = {name = "Police's Motorcycle", func = "Spawnpoliceb"}

function Spawnpolice3()
	SpawnerVeh("police3")
	CloseMenu()
end

function Spawnfbi()
	SpawnerVeh("fbi")
	CloseMenu()
end

function Spawnpoliceb()
	SpawnerVeh("policeb")
	CloseMenu()
end

function SpawnerVeh(hash)
	local car = GetHashKey(hash)
	local playerPed = GetPlayerPed(-1)
	RequestModel(car)
	while not HasModelLoaded(car) do
			Citizen.Wait(0)
	end
	local playerCoords = GetEntityCoords(playerPed)
	policevehicle = CreateVehicle(car, playerCoords, 90.0, true, false)
	SetVehicleMod(policevehicle, 11, 2)
	SetVehicleMod(policevehicle, 12, 2)
	SetVehicleMod(policevehicle, 13, 2)
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