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
local buttonWeaponList = {}

function load_armory()
	for k in ipairs (buttonsCategories) do
		buttonsCategories [k] = nil
	end
	
	for k in ipairs (buttonWeaponList) do
		buttonWeaponList [k] = nil
	end
	
	buttonsCategories[#buttonsCategories+1] = {name = i18n.translate("armory_basic_kit"), func = "giveBasicKit", params = ""}
	buttonsCategories[#buttonsCategories+1] = {name = i18n.translate("armory_add_bulletproof_vest_title"), func = "addBulletproofVest", params = ""}
	buttonsCategories[#buttonsCategories+1] = {name = i18n.translate("armory_remove_bulletproof_vest_title"), func = "removeBulletproofVest", params = ""}
	buttonsCategories[#buttonsCategories+1] = {name = i18n.translate("armory_weapons_list"), func = "openWeaponListMenu", params = ""}
	buttonsCategories[#buttonsCategories+1] = {name = "Close", func = "CloseArmory", params = ""}

	for k,v in pairs(weapons) do
		buttonWeaponList[#buttonWeaponList+1] = {name = tostring(v.name), func = 'GiveCustomWeapon', params = tostring(v.hash)}
	end
end

local hashSkin = GetHashKey("mp_m_freemode_01")

function createArmoryPed()
	if not DoesEntityExist(armoryPed) then
		local model = GetHashKey("s_m_y_cop_01")

		RequestModel(model)
		while not HasModelLoaded(model) do
			Wait(0)
		end

		local armoryPed = CreatePed(26, model, 454.165, -979.999, 30.690, 92.298, false, false)
		SetEntityInvincible(armoryPed, true)
		TaskTurnPedToFaceEntity(armoryPed, PlayerId(), -1)

		return armoryPed
	end
end

function giveBasicKit()
	GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_STUNGUN"), -1, true, true)
	GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_NIGHTSTICK"), -1, true, true)
	GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_FLASHLIGHT"), 200, true, true)

	PlaySoundFrontend(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
end

function giveBasicPrisonKit()
	GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_PISTOL50"), -1, true, true)
	GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_STUNGUN"), -1, true, true)
	GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_NIGHTSTICK"), 200, true, true)
	GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_FLASHLIGHT"), 200, true, true)

	PlaySoundFrontend(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
end

function addBulletproofVest()
	if(config.enableOutfits == true) then
		if(GetEntityModel(PlayerPedId()) == hashSkin) then
			SetPedComponentVariation(PlayerPedId(), 9, 4, 1, 2)
		else
			SetPedComponentVariation(PlayerPedId(), 9, 6, 1, 2)
		end
	end

	SetPedArmour(PlayerPedId(), 100)
	PlaySoundFrontend(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
end

function removeBulletproofVest()
	if(config.enableOutfits == true) then
		SetPedComponentVariation(PlayerPedId(), 9, 0, 1, 2)
	end

	SetPedArmour(PlayerPedId(), 0)
	PlaySoundFrontend(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
end

function GiveCustomWeapon(weaponData)
	GiveWeaponToPed(PlayerPedId(), GetHashKey(weaponData), -1, false, true)
	PlaySoundFrontend(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
end

function CloseArmory()
	CloseMenu()

	RenderScriptCams(false, 1, 1000, 1, 0, 0)
	SetCamActive(ArmoryRoomCam, false)
	DestroyCam(ArmoryRoomCam, true)

	Citizen.Wait(500)
	DoScreenFadeOut(500)
	Citizen.Wait(600)

	if DoesEntityExist(armoryPed) then
		DeleteEntity(armoryPed)
	end

	FreezeEntityPosition(PlayerPedId(), false)
	SetEntityCoords(PlayerPedId(), Lx, Ly, Lz)

	Citizen.Wait(500)
	DoScreenFadeIn(500)
end


function openWeaponListMenu()
	CloseMenu()
	SendNUIMessage({
		title = i18n.translate("armory_weapons_list"),
		buttons = buttonWeaponList,
		action = "setAndOpen"
	})
	
	anyMenuOpen.menuName = "armory-weapon_list"
	anyMenuOpen.isActive = true
end

function OpenArmory()
	if((anyMenuOpen.menuName ~= "armory" and anyMenuOpen.menuName ~= "armory-weapon_list") and not anyMenuOpen.isActive) then
		SendNUIMessage({
			title = i18n.translate("armory_global_title"),
			buttons = buttonsCategories,
			action = "setAndOpen"
		})
		
		anyMenuOpen.menuName = "armory"
		anyMenuOpen.isActive = true
	end
end

function BackArmory()
	CloseMenu()
	OpenArmory()
end