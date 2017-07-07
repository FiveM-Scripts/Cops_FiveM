local buttonsCategories = {}
buttonsCategories[#buttonsCategories+1] = {name = txt[config.lang]["armory_basic_kit"], func = "giveBasicKit"}
buttonsCategories[#buttonsCategories+1] = {name = txt[config.lang]["armory_add_bulletproof_vest_title"], func = "addBulletproofVest"}
buttonsCategories[#buttonsCategories+1] = {name = txt[config.lang]["armory_remove_bulletproof_vest_title"], func = "removeBulletproofVest"}
buttonsCategories[#buttonsCategories+1] = {name = txt[config.lang]["armory_weapons_list"], func = "openWeaponListMenu"}

local buttonWeaponList = {}
buttonWeaponList[#buttonWeaponList+1] = {name = txt[config.lang]["WEAPON_COMBATPISTOL"], func = 'giveCombatPistol'}
buttonWeaponList[#buttonWeaponList+1] = {name = txt[config.lang]["WEAPON_PISTOL50"], func = 'givePistol50'}
buttonWeaponList[#buttonWeaponList+1] = {name = txt[config.lang]["WEAPON_PUMPSHOTGUN"], func = 'givePumpShotgun'}
buttonWeaponList[#buttonWeaponList+1] = {name = txt[config.lang]["WEAPON_ASSAULTSMG"], func = 'giveAssaultSmg'}
buttonWeaponList[#buttonWeaponList+1] = {name = txt[config.lang]["WEAPON_ASSAULTSHOTGUN"], func = 'giveAssaultShotgun'}
buttonWeaponList[#buttonWeaponList+1] = {name = txt[config.lang]["WEAPON_HEAVYSNIPER"], func = 'giveHeavySniper'}

local hashSkin = GetHashKey("mp_m_freemode_01")

function giveBasicKit()
	GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_STUNGUN"), 200, true, true)
	GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_NIGHTSTICK"), 200, true, true)
	GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_FLASHLIGHT"), 200, true, true)
end

function addBulletproofVest()
	Citizen.CreateThread(function()
		if(config.enableOutfits == true) then
			if(GetEntityModel(GetPlayerPed(-1)) == hashSkin) then
				SetPedComponentVariation(GetPlayerPed(-1), 9, 4, 1, 2)
			else
				SetPedComponentVariation(GetPlayerPed(-1), 9, 6, 1, 2)
			end
		end
		SetPedArmour(GetPlayerPed(-1), 100)
	end)
end

function removeBulletproofVest()
	Citizen.CreateThread(function()
		if(config.enableOutfits == true) then
			SetPedComponentVariation(GetPlayerPed(-1), 9, 0, 1, 2)
		end
		SetPedArmour(GetPlayerPed(-1), 0)
	end)
end

function openWeaponListMenu()
	CloseMenu()
	SendNUIMessage({
		title = txt[config.lang]["armory_weapons_list"],
		buttons = buttonWeaponList,
		action = "setAndOpen"
	})
	
	anyMenuOpen.menuName = "armory-weapon_list"
	anyMenuOpen.isActive = true
end

function giveCombatPistol()
	GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_COMBATPISTOL"), 200, true, true)
	GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_COMBATPISTOL"), GetHashKey("COMPONENT_AT_PI_FLSH"))
end

function givePistol50()
	GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_PISTOL50"), 200, true, true)
	GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_PISTOL50"), GetHashKey("COMPONENT_AT_PI_FLSH"))
end

function givePumpShotgun()
	GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_PUMPSHOTGUN"), 200, true, true)
	GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_PUMPSHOTGUN"), GetHashKey("COMPONENT_AT_AR_FLSH"))
end

function giveAssaultSmg()
	GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_ASSAULTSMG"), 200, true, true)
	GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_ASSAULTSMG"), GetHashKey("COMPONENT_AT_AR_FLSH"))
end

function giveAssaultShotgun()
	GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_ASSAULTSHOTGUN"), 200, true, true)
	GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_ASSAULTSHOTGUN"), GetHashKey("COMPONENT_AT_AR_FLSH"))
end

function giveHeavySniper()
	GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_HEAVYSNIPER"), 200, true, true)
end

function OpenArmory()
	if((anyMenuOpen.menuName ~= "armory" and anyMenuOpen.menuName ~= "armory-weapon_list") and not anyMenuOpen.isActive) then
		SendNUIMessage({
			title = txt[config.lang]["armory_global_title"],
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