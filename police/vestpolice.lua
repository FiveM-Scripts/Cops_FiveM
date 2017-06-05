-----------------------------------------------------------------------------------------------------------------
----------------------------------------------------POLICE CLOACKROOM--------------------------------------------
-----------------------------------------------------------------------------------------------------------------
local buttonsVest = {}
buttonsVest[#buttonsVest+1] = {name = txt[config.lang]["cloackroom_take_service_normal_title"], description = ""}
buttonsVest[#buttonsVest+1] = {name = txt[config.lang]["cloackroom_take_service_hidden_title"], description = ""}
buttonsVest[#buttonsVest+1] = {name = txt[config.lang]["cloackroom_take_service_swat_title"], description = ""}
buttonsVest[#buttonsVest+1] = {name = txt[config.lang]["cloackroom_break_service_title"], description = ""}
if(config.enableOutfits == true) then
	buttonsVest[#buttonsVest+1] = {name = txt[config.lang]["cloackroom_add_bulletproof_vest_title"], description = ""}
	buttonsVest[#buttonsVest+1] = {name = txt[config.lang]["cloackroom_remove_bulletproof_vest_title"], description = ""}
	buttonsVest[#buttonsVest+1] = {name = txt[config.lang]["cloackroom_add_yellow_vest_title"], description = ""}
	buttonsVest[#buttonsVest+1] = {name = txt[config.lang]["cloackroom_remove_yellow_vest_title"], description = ""}
end

local vestpolice = {
	opened = false,
	title = txt[config.lang]["cloackroom_global_title"],
	currentmenu = "main",
	lastmenu = nil,
	currentpos = nil,
	selectedbutton = 0,
	marker = { r = 0, g = 155, b = 255, a = 200, type = 1 }, -- ???
	menu = {
		x = 0.11,
		y = 0.25,
		width = 0.2,
		height = 0.04,
		buttons = 10,  --Nombre de bouton
		from = 1,
		to = 10,
		scale = 0.4,
		font = 0,
		["main"] = {
			title = txt[config.lang]["menu_categories_title"],
			name = "main",
			buttons = buttonsVest
		},
	}
}

local hashSkin = GetHashKey("mp_m_freemode_01")

-------------------------------------------------
----------------CONFIG SELECTION----------------
-------------------------------------------------

function ButtonSelectedVest(button)
	local ped = GetPlayerPed(-1)
	local this = vestpolice.currentmenu
	local btn = button.name
	if this == "main" then
		if btn == txt[config.lang]["cloackroom_take_service_normal_title"] then
			ServiceOn()
			giveUniforme()
			drawNotification(txt[config.lang]["now_in_service_notification"])
			drawNotification(txt[config.lang]["help_open_menu_notification"])
		elseif btn == txt[config.lang]["cloackroom_take_service_hidden_title"] then
			ServiceOn()
			
			RemoveAllPedWeapons(GetPlayerPed(-1), true)
			GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_COMBATPISTOL"), 150, true, true)
			GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_STUNGUN"), true, true)
			GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_FLASHLIGHT"), true, true)
			
			drawNotification(txt[config.lang]["now_in_service_notification"])
			drawNotification(txt[config.lang]["help_open_menu_notification"])
		elseif btn == txt[config.lang]["cloackroom_take_service_swat_title"] then
			ServiceOn()
			giveInterventionUniforme()
			drawNotification(txt[config.lang]["now_in_service_notification"])
			drawNotification(txt[config.lang]["help_open_menu_notification"])
		elseif btn == txt[config.lang]["cloackroom_break_service_title"] then
			ServiceOff()
			removeUniforme()                                            --Finir Service + Enleve Uniforme
			drawNotification(txt[config.lang]["break_service_notification"])
		elseif btn == txt[config.lang]["cloackroom_add_bulletproof_vest_title"] then
			Citizen.CreateThread(function()
				if(GetEntityModel(GetPlayerPed(-1)) == hashSkin) then
					SetPedComponentVariation(GetPlayerPed(-1), 9, 4, 1, 2)  --Gilet par balle
				else
					SetPedComponentVariation(GetPlayerPed(-1), 9, 6, 1, 2)
				end
				SetPedArmour(GetPlayerPed(-1), 100)
			end)
		elseif btn == txt[config.lang]["cloackroom_remove_bulletproof_vest_title"] then
			Citizen.CreateThread(function()
				SetPedComponentVariation(GetPlayerPed(-1), 9, 0, 1, 2)  --Remove Gilet par balle
				SetPedArmour(GetPlayerPed(-1), 0)
			end)
		elseif btn == txt[config.lang]["cloackroom_add_yellow_vest_title"] then
			Citizen.CreateThread(function()
				if(GetEntityModel(GetPlayerPed(-1)) == hashSkin) then
					SetPedComponentVariation(GetPlayerPed(-1), 8, 59, 0, 2) --Gilet jaune
				else
					SetPedComponentVariation(GetPlayerPed(-1), 8, 36, 0, 2)
				end
			end)
		elseif btn == txt[config.lang]["cloackroom_remove_yellow_vest_title"] then
			Citizen.CreateThread(function()
				if(GetEntityModel(GetPlayerPed(-1)) == hashSkin) then
					SetPedComponentVariation(GetPlayerPed(-1), 8, 58, 0, 2) --Remove Gilet jaune + Remet la ceinture
				else
					SetPedComponentVariation(GetPlayerPed(-1), 8, 35, 0, 2)
				end
			end)
		end
	end
end

-------------------------------------------------
------------------UNIFORM FUNCTIONS--------------
-------------------------------------------------

function giveUniforme()
	Citizen.CreateThread(function()
		if(config.enableOutfits == true) then
			if(GetEntityModel(GetPlayerPed(-1)) == hashSkin) then

				SetPedPropIndex(GetPlayerPed(-1), 1, 5, 0, 2)             --Sunglasses
				SetPedPropIndex(GetPlayerPed(-1), 2, 0, 0, 2)             --Bluetoothn earphone
				SetPedComponentVariation(GetPlayerPed(-1), 11, 55, 0, 2)  --Shirt
				SetPedComponentVariation(GetPlayerPed(-1), 8, 58, 0, 2)   --Nightstick decoration
				SetPedComponentVariation(GetPlayerPed(-1), 4, 35, 0, 2)   --Pants
				SetPedComponentVariation(GetPlayerPed(-1), 6, 24, 0, 2)   --Shooes
				SetPedComponentVariation(GetPlayerPed(-1), 10, 8, 0, 2)   --rank
				
			else

				SetPedPropIndex(GetPlayerPed(-1), 1, 11, 3, 2)           --Sunglasses
				SetPedPropIndex(GetPlayerPed(-1), 2, 0, 0, 2)            --Bluetoothn earphone
				SetPedComponentVariation(GetPlayerPed(-1), 3, 14, 0, 2)  --Non buggy tshirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 48, 0, 2) --Shirt
				SetPedComponentVariation(GetPlayerPed(-1), 8, 35, 0, 2)  --Nightstick decoration
				SetPedComponentVariation(GetPlayerPed(-1), 4, 34, 0, 2)  --Pants
				SetPedComponentVariation(GetPlayerPed(-1), 6, 29, 0, 2)  --Shooes
				SetPedComponentVariation(GetPlayerPed(-1), 10, 7, 0, 2)  --rank
			
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
		
		RemoveAllPedWeapons(GetPlayerPed(-1), true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_PISTOL50"), 150, true, true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_STUNGUN"), true, true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_NIGHTSTICK"), true, true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_PUMPSHOTGUN"), 150, true, true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_FLASHLIGHT"), true, true)
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
		
		RemoveAllPedWeapons(GetPlayerPed(-1), true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_PISTOL50"), 150, true, true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_STUNGUN"), true, true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_NIGHTSTICK"), true, true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_ASSAULTSHOTGUN"), 150, true, true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_ASSAULTSMG"), 150, true, true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_HEAVYSNIPER"), 150, true, true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_FLASHLIGHT"), true, true)
	end)
end

function removeUniforme()
	Citizen.CreateThread(function()
		if(config.enableOutfits == true) then
			RemoveAllPedWeapons(GetPlayerPed(-1))
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
			RemoveAllPedWeapons(GetPlayerPed(-1))
		end
	end)
end

function removeUniforme()
	Citizen.CreateThread(function()
		if(config.enableOutfits == true) then
			RemoveAllPedWeapons(GetPlayerPed(-1))
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

-------------------------------------------------
----------------CONFIG OPEN MENU-----------------
-------------------------------------------------

function OpenVestMenu(menu)
	vestpolice.menu.from = 1
	vestpolice.menu.to = 10
	vestpolice.selectedbutton = 0
	vestpolice.currentmenu = menu
end

-------------------------------------------------
------------------DRAW NOTIFY--------------------
-------------------------------------------------

function drawNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

--------------------------------------
-------------DISPLAY HELP TEXT--------
--------------------------------------

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

-------------------------------------------------
------------------DRAW TITLE MENU----------------
-------------------------------------------------

function drawMenuTitle(txt,x,y)
local menu = vestpolice.menu
	SetTextFont(2)
	SetTextProportional(0)
	SetTextScale(0.5, 0.5)
	SetTextColour(255, 255, 255, 255)
	SetTextEntry("STRING")
	AddTextComponentString(txt)
	DrawRect(x,y,menu.width,menu.height,0,0,0,150)
	DrawText(x - menu.width/2 + 0.005, y - menu.height/2 + 0.0028)
end

-------------------------------------------------
------------------DRAW MENU BOUTON---------------
-------------------------------------------------

function drawMenuButton(button,x,y,selected)
	local menu = vestpolice.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(menu.scale, menu.scale)
	if selected then
		SetTextColour(0, 0, 0, 255)
	else
		SetTextColour(255, 255, 255, 255)
	end
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(button.name)
	if selected then
		DrawRect(x,y,menu.width,menu.height,255,255,255,255)
	else
		DrawRect(x,y,menu.width,menu.height,0,0,0,150)
	end
	DrawText(x - menu.width/2 + 0.005, y - menu.height/2 + 0.0028)
end

-------------------------------------------------
------------------DRAW MENU INFO-----------------
-------------------------------------------------

function drawMenuInfo(text)
	local menu = vestpolice.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(0.45, 0.45)
	SetTextColour(255, 255, 255, 255)
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawRect(0.675, 0.95,0.65,0.050,0,0,0,150)
	DrawText(0.365, 0.934)
end

-------------------------------------------------
----------------DRAW MENU DROIT------------------
-------------------------------------------------

function drawMenuRight(txt,x,y,selected)
	local menu = vestpolice.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(menu.scale, menu.scale)
	--SetTextRightJustify(1)
	if selected then
		SetTextColour(0, 0, 0, 255)
	else
		SetTextColour(255, 255, 255, 255)
	end
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(txt)
	DrawText(x + menu.width/2 - 0.03, y - menu.height/2 + 0.0028)
end

-------------------------------------------------
-------------------DRAW TEXT---------------------
-------------------------------------------------

function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(centre)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x , y)
end

-------------------------------------------------
----------------CONFIG BACK MENU-----------------
-------------------------------------------------

function BackVest()
	if backlock then
		return
	end
	backlock = true
	if vestpolice.currentmenu == "main" then
		CloseMenuVest()
	end
end

-------------------------------------------------
---------------------FONCTION--------------------
-------------------------------------------------

function f(n)
return n + 0.0001
end

function LocalPed()
return GetPlayerPed(-1)
end

function try(f, catch_f)
local status, exception = pcall(f)
if not status then
catch_f(exception)
end
end
function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function round(num, idp)
  if idp and idp>0 then
    local mult = 10^idp
    return math.floor(num * mult + 0.5) / mult
  end
  return math.floor(num + 0.5)
end

function stringstarts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

-------------------------------------------------
----------------FONCTION OPEN--------------------
-------------------------------------------------

function OpenMenuVest()
	vestpolice.currentmenu = "main"
	vestpolice.opened = true
	vestpolice.selectedbutton = 0
end

-------------------------------------------------
----------------FONCTION CLOSE-------------------
-------------------------------------------------

function CloseMenuVest()
		vestpolice.opened = false
		vestpolice.menu.from = 1
		vestpolice.menu.to = 10
end

-------------------------------------------------
----------------FONCTION OPEN MENU---------------
-------------------------------------------------

local backlock = false
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if GetDistanceBetweenCoords(457.956, -992.723, 30.689,GetEntityCoords(GetPlayerPed(-1))) > 2 then
			if vestpolice.opened then
				CloseMenuVest()
			end
		end
		if vestpolice.opened then
			local ped = LocalPed()
			local menu = vestpolice.menu[vestpolice.currentmenu]
			drawTxt(vestpolice.title,1,1,vestpolice.menu.x,vestpolice.menu.y,1.0, 255,255,255,255)
			drawMenuTitle(menu.title, vestpolice.menu.x,vestpolice.menu.y + 0.08)
			drawTxt(vestpolice.selectedbutton.."/"..tablelength(menu.buttons),0,0,vestpolice.menu.x + vestpolice.menu.width/2 - 0.0385,vestpolice.menu.y + 0.067,0.4, 255,255,255,255)
			local y = vestpolice.menu.y + 0.12
			buttoncount = tablelength(menu.buttons)
			local selected = false

			for i,button in pairs(menu.buttons) do
				if i >= vestpolice.menu.from and i <= vestpolice.menu.to then

					if i == vestpolice.selectedbutton then
						selected = true
					else
						selected = false
					end
					drawMenuButton(button,vestpolice.menu.x,y,selected)
					if button.distance ~= nil then
						drawMenuRight(button.distance.."m",vestpolice.menu.x,y,selected)
					end
					y = y + 0.04
					if selected and IsControlJustPressed(1,201) then
						ButtonSelectedVest(button)
					end
				end
			end
		end
		if vestpolice.opened then
			if IsControlJustPressed(1,202) then
				BackVest()
			end
			if IsControlJustReleased(1,202) then
				backlock = false
			end
			if IsControlJustPressed(1,188) then
				if vestpolice.selectedbutton > 1 then
					vestpolice.selectedbutton = vestpolice.selectedbutton -1
					if buttoncount > 10 and vestpolice.selectedbutton < vestpolice.menu.from then
						vestpolice.menu.from = vestpolice.menu.from -1
						vestpolice.menu.to = vestpolice.menu.to - 1
					end
				end
			end
			if IsControlJustPressed(1,187)then
				if vestpolice.selectedbutton < buttoncount then
					vestpolice.selectedbutton = vestpolice.selectedbutton +1
					if buttoncount > 10 and vestpolice.selectedbutton > vestpolice.menu.to then
						vestpolice.menu.to = vestpolice.menu.to + 1
						vestpolice.menu.from = vestpolice.menu.from + 1
					end
				end
			end
		end
	end
end)