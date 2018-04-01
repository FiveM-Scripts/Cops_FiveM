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

	buttonWeaponList[#buttonWeaponList+1] = {name = i18n.translate("WEAPON_COMBATPISTOL"), func = 'giveCombatPistol', params = ""}
	buttonWeaponList[#buttonWeaponList+1] = {name = i18n.translate("WEAPON_PISTOL50"), func = 'givePistol50', params = ""}
	buttonWeaponList[#buttonWeaponList+1] = {name = i18n.translate("WEAPON_PUMPSHOTGUN"), func = 'givePumpShotgun', params = ""}

	buttonWeaponList[#buttonWeaponList+1] = {name = i18n.translate("WEAPON_ASSAULTSMG"), func = 'giveAssaultSmg', params = ""}
	buttonWeaponList[#buttonWeaponList+1] = {name = i18n.translate("WEAPON_ASSAULTSHOTGUN"), func = 'giveAssaultShotgun', params = ""}
	buttonWeaponList[#buttonWeaponList+1] = {name = i18n.translate("WEAPON_HEAVYSNIPER"), func = 'giveHeavySniper', params = ""}
end

local hashSkin = GetHashKey("mp_m_freemode_01")

function giveBasicKit()
	GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_STUNGUN"), -1, true, true)
	GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_NIGHTSTICK"), -1, true, true)
	GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_FLASHLIGHT"), 200, true, true)
end

function giveBasicPrisonKit()
	GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_PISTOL50"), -1, true, true)
	GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_STUNGUN"), -1, true, true)
	GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_NIGHTSTICK"), 200, true, true)
	GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_FLASHLIGHT"), 200, true, true)
end

function addBulletproofVest()
	Citizen.CreateThread(function()
		if(config.enableOutfits == true) then
			if(GetEntityModel(PlayerPedId()) == hashSkin) then
				SetPedComponentVariation(PlayerPedId(), 9, 4, 1, 2)
			else
				SetPedComponentVariation(PlayerPedId(), 9, 6, 1, 2)
			end
		end
		SetPedArmour(PlayerPedId(), 100)
	end)
end

function removeBulletproofVest()
	Citizen.CreateThread(function()
		if(config.enableOutfits == true) then
			SetPedComponentVariation(PlayerPedId(), 9, 0, 1, 2)
		end
		SetPedArmour(PlayerPedId(), 0)
	end)
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

function giveCombatPistol()
	GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_COMBATPISTOL"), -1, true, true)
	GiveWeaponComponentToPed(PlayerPedId(), GetHashKey("WEAPON_COMBATPISTOL"), GetHashKey("COMPONENT_AT_PI_FLSH"))
end

function givePistol50()
	GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_PISTOL50"), -1, true, true)
	GiveWeaponComponentToPed(PlayerPedId(), GetHashKey("WEAPON_PISTOL50"), GetHashKey("COMPONENT_AT_PI_FLSH"))
end

function givePumpShotgun()
	GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_PUMPSHOTGUN"), -1, true, true)
	GiveWeaponComponentToPed(PlayerPedId(), GetHashKey("WEAPON_PUMPSHOTGUN"), GetHashKey("COMPONENT_AT_AR_FLSH"))
end

function giveAssaultSmg()
	GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_ASSAULTSMG"), -1, true, true)
	GiveWeaponComponentToPed(PlayerPedId(), GetHashKey("WEAPON_ASSAULTSMG"), GetHashKey("COMPONENT_AT_AR_FLSH"))
end

function giveAssaultShotgun()
	GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_ASSAULTSHOTGUN"), -1, true, true)
	GiveWeaponComponentToPed(PlayerPedId(), GetHashKey("WEAPON_ASSAULTSHOTGUN"), GetHashKey("COMPONENT_AT_AR_FLSH"))
end

function giveHeavySniper()
	GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_HEAVYSNIPER"), -1, true, true)
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