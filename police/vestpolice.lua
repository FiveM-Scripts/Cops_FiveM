-----------------------------------------------------------------------------------------------------------------
----------------------------------------------------Cop Locker---------------------------------------------
-----------------------------------------------------------------------------------------------------------------
local vestpolice = {
	opened = false,
	title = "Cop Locker",
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
			title = "CATEGORIES",
			name = "main",
			buttons = {
				{name = "Take your service", description = ""},
				{name = "Break your service", description = ""},
				{name = "Choose model", description = ""},
			}
		},
			["Choosemodel"] = {
			title = "CHOOSEMODEL",
			name = "Choosemodel",
			buttons = {
				{name = "Traffic Cop", description = ''},
				{name = "Highway Cop", description = ''},
				{name = "Ranger", description = ''},
				{name = "Sherrif", description = ''},
				{name = "Swat", description = ''},
			}
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
		if btn == "Take your service" then
			ServiceOn()                                                 
			drawNotification("You're now in ~g~service")
			drawNotification("Press ~g~F5~w~ to open the ~b~cop menu")
		elseif btn == "Break your service" then
			ServiceOff()
			removeUniforme()                                            
			drawNotification("You've ~r~done your service")
			-- THIS is for the model selection
		elseif btn == "Choose model" then
				OpenVestMenu("Choosemodel")			
			end
		elseif this == "Choosemodel" then
		if btn == "Traffic Cop"then
			giveUniforme('s_m_m_prisonguard_1')
		elseif btn == "Highway Cop" then
			giveUniforme('s_m_y_highwaycop_1')
		elseif btn == "Ranger"  then
			giveUniforme('s_m_y_ranger_01')
		elseif btn == "Sherrif" then
			giveUniforme('s_m_y_sheriff_01')
		elseif btn == "Swat" then
			giveUniforme('s_m_y_swat_01')
			end
	end
end
-------------------------------------------------
------------------FONCTION UNIFORME--------------
-------------------------------------------------
function giveUniforme(modelCop)
	Citizen.CreateThread(function()
		TriggerServerEvent("mm:spawnCop", modelCop)
		Wait(1000)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_CombatPistol"), 150, true, true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_STUNGUN"), true, true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_NIGHTSTICK"), true, true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_PUMPSHOTGUN"), 150, true, true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_SpecialCarbine"), 150, true, true)
	end)
end

function removeUniforme()
	Citizen.CreateThread(function()
		TriggerServerEvent("mm:spawn")
		RemoveAllPedWeapons(GetPlayerPed(-1))
	end)
end
-------------------------------------------------
----------------CONFIG OPEN MENU-----------------
-------------------------------------------------
function OpenVestMenu(menu)
		vestpolice.lastmenu = vestpolice.currentmenu
		vestpolice.lastmenu = "main"

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