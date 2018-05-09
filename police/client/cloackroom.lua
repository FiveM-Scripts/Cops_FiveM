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

function load_cloackroom()
	for k in ipairs (buttons) do
		buttons [k] = nil
	end

	for k, data in pairs(skins) do
		if(config.useCopWhitelist == true) then
			if dept == k then
				for k, v in pairs(data) do
					buttons[#buttons+1] = {name = tostring(v.name), func = "clockIn", params = tostring(v.model)}
				end
			end
		else
			for k, v in pairs(data) do
				buttons[#buttons+1] = {name = tostring(v.name), func = "clockIn", params = tostring(v.model)}
			end
		end
	end

	if(config.enableOutfits == true) then
			buttons[#buttons+1] = {name = i18n.translate("cloackroom_add_yellow_vest_title"), func = "cloackroom_add_yellow_vest", params = ""}
			buttons[#buttons+1] = {name = i18n.translate("cloackroom_remove_yellow_vest_title"), func = "cloackroom_rem_yellow_vest", params = ""}
	end

	buttons[#buttons+1] = {name = i18n.translate("cloackroom_break_service_title"), func = "clockOut", params = ""}
end

function clockIn(model)
    if model then	    	
    	if IsModelValid(model) and IsModelInCdimage(model) then
    		ServiceOn()
    		SetCopModel(model)

    		TriggerServerEvent("police:notifyCops", i18n.translate("now_in_service_notification"))
    		drawNotification(i18n.translate("help_open_menu_notification"))
    		giveBasicKit()
    	else
    		drawNotification("This model is ~r~invalid~w~.")
    	end

    	SetAudioFlag("LoadMPData", true)
    	SetAudioFlag("DisableFlightMusic", true)
    	SetAudioFlag("PoliceScannerDisabled", false)
    end
end

function clockOut()
	ServiceOff()
	removeUniforme()
	drawNotification(i18n.translate("break_service_notification"))
end

function cloackroom_add_yellow_vest()
	Citizen.CreateThread(function()
		if(GetEntityModel(PlayerPedId()) == GetHashKey("mp_m_freemode_01")) then
			SetPedComponentVariation(PlayerPedId(), 8, 59, 0, 2)
		else
			SetPedComponentVariation(PlayerPedId(), 8, 36, 0, 2)
		end
	end)
end

function cloackroom_rem_yellow_vest()
	Citizen.CreateThread(function()
		if(GetEntityModel(PlayerPedId()) == GetHashKey("mp_m_freemode_01")) then
			SetPedComponentVariation(PlayerPedId(), 8, 58, 0, 2)
		else
			SetPedComponentVariation(PlayerPedId(), 8, 35, 0, 2)
		end
	end)
end

function SetCopModel(model)
	modelHash = GetHashKey(model)

	RequestModel(modelHash)
	while not HasModelLoaded(modelHash) do
		Citizen.Wait(0)
	end

	if model == "s_m_y_cop_01" then
		if (config.enableOutfits == true) then
			if(GetEntityModel(PlayerPedId()) == GetHashKey("mp_m_freemode_01")) then
--				SetPedHeadBlendData(PlayerPedId(), 0, math.random(12), 0,math.random(12), math.random(5), math.random(5),1.0,1.0,1.0,true)
			    
			    SetPedPropIndex(PlayerPedId(), 1, 5, 0, 2)             --Sunglasses
			    SetPedPropIndex(PlayerPedId(), 2, 0, 0, 2)             --Bluetoothn earphone

			    SetPedComponentVariation(PlayerPedId(), 2, math.random(1, 17), 3, 2)
			    SetPedComponentVariation(PlayerPedId(), 11, 55, 0, 2)  --Shirt
			    SetPedComponentVariation(PlayerPedId(), 8, 58, 0, 2)   --Nightstick decoration
			    
			    SetPedComponentVariation(PlayerPedId(), 4, 35, 0, 2)   --Pants
			    SetPedComponentVariation(PlayerPedId(), 6, 24, 0, 2)   --Shooes
			    SetPedComponentVariation(PlayerPedId(), 10, 8, config.rank.outfit_badge[rank], 2) --rank
			else
				RequestModel(GetHashKey("mp_m_freemode_01"))
				while not HasModelLoaded(GetHashKey("mp_m_freemode_01")) do
					Citizen.Wait(0)
				end
				
				SetPlayerModel(PlayerId(), GetHashKey("mp_m_freemode_01"))
				SetPedHeadBlendData(PlayerPedId(), 0, math.random(12), 0,math.random(12), math.random(5), math.random(5),1.0,1.0,1.0,true)

			    SetPedPropIndex(PlayerPedId(), 1, 5, 3, 2)           --Sunglasses
			    SetPedPropIndex(PlayerPedId(), 2, 0, 0, 2)            --Bluetoothn earphone

			    SetPedComponentVariation(PlayerPedId(), 2, math.random(1, 17), 3, 2)
			    SetPedComponentVariation(PlayerPedId(), 11, 55, 0, 2)  --Shirt
			    SetPedComponentVariation(PlayerPedId(), 8, 58, 0, 2)   --Nightstick decoration
			    
			    SetPedComponentVariation(PlayerPedId(), 4, 35, 0, 2)   --Pants
			    SetPedComponentVariation(PlayerPedId(), 6, 24, 0, 2)   --Shooes
			    SetPedComponentVariation(PlayerPedId(), 10, 8, config.rank.outfit_badge[rank], 2) --rank

			    SetModelAsNoLongerNeeded(GetHashKey("mp_m_freemode_01"))
			end
		else
			SetPlayerModel(PlayerId(), modelHash)
		end
	elseif model == "s_m_y_hwaycop_01" then
			SetPlayerModel(PlayerId(), modelHash)
			SetPedComponentVariation(PlayerPedId(), 10, 7, config.rank.outfit_badge[rank], 2)
	elseif model == "s_m_y_sheriff_01" then
		    SetPlayerModel(PlayerId(), modelHash)
		    SetPedComponentVariation(PlayerPedId(), 10, 7, config.rank.outfit_badge[rank], 2)
	elseif model == "s_m_y_ranger_01" then
		SetPlayerModel(PlayerId(), modelHash)
		SetPedComponentVariation(PlayerPedId(), 10, 7, config.rank.outfit_badge[rank], 2)
	else
		SetPlayerModel(PlayerId(), modelHash)
	end

	SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)
	SetModelAsNoLongerNeeded(modelHash)
end

function GenerateRandomMpModel()
	if GetEntityModel(PlayerPedId()) == "mp_m_freemode_01" then
		SetPedHeadBlendData(PlayerPedId(), 0, math.random(12), 0,math.random(12), math.random(5), math.random(5),1.0,1.0,1.0,true)

		SetPedComponentVariation(PlayerPedId(), 0, math.random(0, 5), 0, 2)
		SetPedComponentVariation(PlayerPedId(), 2, math.random(1, 17), 3, 2)
		SetPedComponentVariation(PlayerPedId(), 3, 164, 0, 2)

		SetPedComponentVariation(PlayerPedId(), 4, math.random(0, 10), math.random(5), 2)
		SetPedComponentVariation(PlayerPedId(), 6, math.random(0, 6), 0, 2)
		SetPedComponentVariation(PlayerPedId(), 10, 7, 0, 2)
		
		SetPedComponentVariation(PlayerPedId(), 8, 2, 0, 2)
		SetPedComponentVariation(PlayerPedId(), 11, 0, math.random(0, 9), 2)
		SetPedHairColor(PlayerPedId(), math.random(1, 4), 1)
	else
		RequestModel(GetHashKey("mp_m_freemode_01"))
		while not HasModelLoaded(GetHashKey("mp_m_freemode_01")) do
			Citizen.Wait(0)
		end

		SetPlayerModel(PlayerId(), GetHashKey("mp_m_freemode_01"))

		SetPedHeadBlendData(PlayerPedId(), 0, math.random(12), 0,math.random(12), math.random(5), math.random(5),1.0,1.0,1.0,true)
		SetPedComponentVariation(PlayerPedId(), 0, 0, 0, 2)
		SetPedComponentVariation(PlayerPedId(), 2, math.random(1, 17), 3, 2)

		SetPedComponentVariation(PlayerPedId(), 3, 164, 0, 2)
		SetPedComponentVariation(PlayerPedId(), 4, math.random(0, 10), math.random(5), 2)
		SetPedComponentVariation(PlayerPedId(), 6, math.random(0, 6), 0, 2)

		SetPedComponentVariation(PlayerPedId(), 8, 2, 0, 2)
		SetPedComponentVariation(PlayerPedId(), 10, 7, 0, 2)
		SetPedComponentVariation(PlayerPedId(), 11, 0, math.random(0, 9), 2)

		SetPedHairColor(PlayerPedId(), math.random(1, 4), 1)
		SetModelAsNoLongerNeeded(GetHashKey("mp_m_freemode_01"))			
	end
end

function removeUniforme()
	if(config.enableOutfits == true) then
		RemoveAllPedWeapons(PlayerPedId())
		GenerateRandomMpModel()
	else
		local model = GetHashKey("a_m_y_mexthug_01")
		RequestModel(model)
		while not HasModelLoaded(model) do
			Citizen.Wait(0)
		end
		 
		SetPlayerModel(PlayerId(), model)
		SetModelAsNoLongerNeeded(model)
	end
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
