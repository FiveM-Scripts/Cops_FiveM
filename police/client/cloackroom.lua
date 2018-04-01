local buttons = {}

function load_cloackroom()
	for k in ipairs (buttons) do
		buttons [k] = nil
	end
if dept == 0 then
	buttons[#buttons+1] = {name = i18n.translate("cloackroom_take_service_ranger_title"), func = "clockIn_Ranger", params = ""}
elseif dept == 1 then
	buttons[#buttons+1] = {name = i18n.translate("cloackroom_take_service_normal_title"), func = "clockIn_Lspd", params = ""}
elseif dept == 2 then
	buttons[#buttons+1] = {name = i18n.translate("cloackroom_take_service_sheriff_title"), func = "clockIn_Sheriff", params = ""}
elseif dept == 3 then
	buttons[#buttons+1] = {name = i18n.translate("cloackroom_take_service_chp_title"), func = "clockIn_Chp", params = ""}
elseif dept == 4 then
	buttons[#buttons+1] = {name = i18n.translate("cloackroom_take_service_prison_title"), func = "clockIn_Prison", params = ""}	
else
	buttons[#buttons+1] = {name = i18n.translate("cloackroom_take_service_normal_title"), func = "clockIn_Uniformed", params = ""}
	buttons[#buttons+1] = {name = i18n.translate("cloackroom_take_service_hidden_title"), func = "clockIn_Undercover", params = ""}
	buttons[#buttons+1] = {name = i18n.translate("cloackroom_take_service_swat_title"), func = "clockIn_SWAT", params = ""}
end
	buttons[#buttons+1] = {name = i18n.translate("cloackroom_break_service_title"), func = "clockOut", params = ""}
	if(config.enableOutfits == true) then
		if(rank <= 0) then
			buttons[#buttons+1] = {name = i18n.translate("cloackroom_add_yellow_vest_title"), func = "cloackroom_add_yellow_vest", params = ""}
			buttons[#buttons+1] = {name = i18n.translate("cloackroom_remove_yellow_vest_title"), func = "cloackroom_rem_yellow_vest", params = ""}
		end
	end
end

local hashSkin = GetHashKey("mp_m_freemode_01")

function clockIn_Uniformed()
	ServiceOn()
	giveUniforme()
	drawNotification(i18n.translate("now_in_service_notification"))
	drawNotification(i18n.translate("help_open_menu_notification"))
end

function clockIn_Ranger()
	ServiceOn()
	giveRangerUniforme()
	drawNotification(i18n.translate("now_in_service_notification"))
	drawNotification(i18n.translate("help_open_menu_notification"))
end

function clockIn_Lspd()
	ServiceOn()
	giveUniforme()
	drawNotification(i18n.translate("now_in_service_notification"))
	drawNotification(i18n.translate("help_open_menu_notification"))
end

function clockIn_Sheriff()
	ServiceOn()
	giveSheriffUniforme()
	drawNotification(i18n.translate("now_in_service_notification"))
	drawNotification(i18n.translate("help_open_menu_notification"))
end

function clockIn_Chp()
	ServiceOn()
	giveChpUniforme()
	drawNotification(i18n.translate("now_in_service_notification"))
	drawNotification(i18n.translate("help_open_menu_notification"))
end

function clockIn_Prison()
	ServiceOn()
	givePrisonGuardModel()
	drawNotification(i18n.translate("now_in_service_notification"))
	drawNotification(i18n.translate("help_open_menu_notification"))
end

function clockIn_Undercover()
	ServiceOn()
	RemoveAllPedWeapons(PlayerPedId(), true)
	drawNotification(i18n.translate("now_in_service_notification"))
	drawNotification(i18n.translate("help_open_menu_notification"))
end

function clockIn_SWAT()
	ServiceOn()
	giveInterventionUniforme()
	drawNotification(i18n.translate("now_in_service_notification"))
	drawNotification(i18n.translate("help_open_menu_notification"))
end

function clockOut()
	ServiceOff()
	removeUniforme()
	drawNotification(i18n.translate("break_service_notification"))
end

function cloackroom_add_yellow_vest()
	Citizen.CreateThread(function()
		if(GetEntityModel(PlayerPedId()) == hashSkin) then
			SetPedComponentVariation(PlayerPedId(), 8, 59, 0, 2)
		else
			SetPedComponentVariation(PlayerPedId(), 8, 36, 0, 2)
		end
	end)
end

function cloackroom_rem_yellow_vest()
	Citizen.CreateThread(function()
		if(GetEntityModel(PlayerPedId()) == hashSkin) then
			SetPedComponentVariation(PlayerPedId(), 8, 58, 0, 2)
		else
			SetPedComponentVariation(PlayerPedId(), 8, 35, 0, 2)
		end
	end)
end

function giveUniforme()
	Citizen.CreateThread(function()
		if(config.enableOutfits == true) then
			if(GetEntityModel(PlayerPedId()) == hashSkin) then

				SetPedPropIndex(PlayerPedId(), 1, 5, 0, 2)             --Sunglasses
				SetPedPropIndex(PlayerPedId(), 2, 0, 0, 2)             --Bluetoothn earphone
				SetPedComponentVariation(PlayerPedId(), 11, 55, 0, 2)  --Shirt
				SetPedComponentVariation(PlayerPedId(), 8, 58, 0, 2)   --Nightstick decoration
				SetPedComponentVariation(PlayerPedId(), 4, 35, 0, 2)   --Pants
				SetPedComponentVariation(PlayerPedId(), 6, 24, 0, 2)   --Shooes
				SetPedComponentVariation(PlayerPedId(), 10, 8, config.rank.outfit_badge[rank], 2)   --rank
				
			else

				SetPedPropIndex(PlayerPedId(), 1, 11, 3, 2)           --Sunglasses
				SetPedPropIndex(PlayerPedId(), 2, 0, 0, 2)            --Bluetoothn earphone
				SetPedComponentVariation(PlayerPedId(), 3, 14, 0, 2)  --Non buggy tshirt
				SetPedComponentVariation(PlayerPedId(), 11, 48, 0, 2) --Shirt
				SetPedComponentVariation(PlayerPedId(), 8, 35, 0, 2)  --Nightstick decoration
				SetPedComponentVariation(PlayerPedId(), 4, 34, 0, 2)  --Pants
				SetPedComponentVariation(PlayerPedId(), 6, 29, 0, 2)  --Shooes
				SetPedComponentVariation(PlayerPedId(), 10, 7, config.rank.outfit_badge[rank], 2)  --rank
			
			end
		else
			local model = GetHashKey("s_m_y_cop_01")

			RequestModel(model)
			while not HasModelLoaded(model) do
				RequestModel(model)
				Citizen.Wait(0)
			end
		 
			SetPlayerModel(PlayerId(), model)
			SetModelAsNoLongerNeeded(model)
		end
		
	end)
end

function giveInterventionUniforme()
	Citizen.CreateThread(function()

		local model = GetHashKey("s_m_y_swat_01")

		RequestModel(model)
		while not HasModelLoaded(model) do
			RequestModel(model)
			Citizen.Wait(0)
		end

		SetPlayerModel(PlayerId(), model)
		SetModelAsNoLongerNeeded(model)

	end)
end

function giveChpUniforme()
	local model = GetHashKey("s_m_y_hwaycop_01")
	RequestModel(model)
	while not HasModelLoaded(model) do
		Citizen.Wait(0)
	end

	SetPlayerModel(PlayerId(), model)
	SetModelAsNoLongerNeeded(model)
	SetPedComponentVariation(PlayerPedId(), 10, 7, config.rank.outfit_badge[rank], 2)
end

function giveSheriffUniforme()
	local model = GetHashKey("s_m_y_sheriff_01")

	RequestModel(model)
	while not HasModelLoaded(model) do
		Citizen.Wait(0)
	end

	SetPlayerModel(PlayerId(), model)
	SetModelAsNoLongerNeeded(model)
	SetPedComponentVariation(PlayerPedId(), 10, 7, config.rank.outfit_badge[rank], 2)
end

function giveRangerUniforme()
	local model = GetHashKey("s_m_y_ranger_01")

	RequestModel(model)
	while not HasModelLoaded(model) do
		Citizen.Wait(0)
	end

	SetPlayerModel(PlayerId(), model)
	SetModelAsNoLongerNeeded(model)
	SetPedComponentVariation(PlayerPedId(), 10, 7, config.rank.outfit_badge[rank], 2)
end

function givePrisonGuardModel()
	local model = GetHashKey("s_m_m_prisguard_01")
	RequestModel(model)
	while not HasModelLoaded(model) do
		Citizen.Wait(0)
	end

	SetPlayerModel(PlayerId(), model)
	giveBasicPrisonKit()
	SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)
	SetModelAsNoLongerNeeded(model)
end

function removeUniforme()
	Citizen.CreateThread(function()
		if(config.enableOutfits == true) then
			RemoveAllPedWeapons(PlayerPedId())
			TriggerServerEvent("skin_customization:SpawnPlayer")
		else
			local model = GetHashKey("a_m_y_mexthug_01")

			RequestModel(model)
			while not HasModelLoaded(model) do
				RequestModel(model)
				Citizen.Wait(0)
			end
		 
			SetPlayerModel(PlayerId(), model)
			SetModelAsNoLongerNeeded(model)
		end
	end)
end

function OpenCloackroom()
	if(anyMenuOpen.menuName ~= "cloackroom" and not anyMenuOpen.isActive) then
		SendNUIMessage({
			title = i18n.translate("cloackroom_global_title"),
			buttons = buttons,
			action = "setAndOpen"
		})
		
		anyMenuOpen.menuName = "cloackroom"
		anyMenuOpen.isActive = true
	end
end
