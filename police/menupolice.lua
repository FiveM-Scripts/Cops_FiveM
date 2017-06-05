-----------------------------------------------------------------------------------------------------------------
----------------------------------------------------POLICE MENU--------------------------------------------------
-----------------------------------------------------------------------------------------------------------------

local buttonsCitizen = {}

if(config.useGcIdentity == true) then
	buttonsCitizen[1] = {name = txt[config.lang]["menu_id_card_title"], description = ''}
end

if(config.useVDKInventory == true or config.useWeashop == true) then
	buttonsCitizen[#buttonsCitizen+1] = {name = txt[config.lang]["menu_check_inventory_title"], description = ''}
end

buttonsCitizen[#buttonsCitizen+1] = {name = txt[config.lang]["menu_toggle_cuff_title"], description = ''}
buttonsCitizen[#buttonsCitizen+1] = {name = txt[config.lang]["menu_force_player_get_in_car_title"], description = ''}
buttonsCitizen[#buttonsCitizen+1] = {name = txt[config.lang]["menu_force_player_get_out_car_title"], description = ''}
buttonsCitizen[#buttonsCitizen+1] = {name = txt[config.lang]["menu_drag_player_title"], description = ''}
buttonsCitizen[#buttonsCitizen+1] = {name = txt[config.lang]["menu_fines_title"], description = ''}


local buttonsVehicle = {}

if(config.enableCheckPlate == true) then
	buttonsVehicle[1] = {name = txt[config.lang]["menu_check_plate_title"], description = ''}
end

buttonsVehicle[#buttonsVehicle+1] = {name = txt[config.lang]["menu_crochet_veh_title"], description = ''}

local menupolice = {
	opened = false,
	title = txt[config.lang]["menu_global_title"],
	currentmenu = txt[config.lang]["menu_categories_title"],
	lastmenu = nil,
	currentpos = nil,
	selectedbutton = 0,
	marker = { r = 0, g = 155, b = 255, a = 200, type = 1 },
	menu = {
		x = 0.11,
		y = 0.25,
		width = 0.2,
		height = 0.04,
		buttons = 10,
		from = 1,
		to = 10,
		scale = 0.4,
		font = 0,
		[txt[config.lang]["menu_categories_title"]] = {
			title = txt[config.lang]["menu_categories_title"],
			name = txt[config.lang]["menu_categories_title"],
			buttons = {
				{name = txt[config.lang]["menu_animations_title"], description = ""},
				{name = txt[config.lang]["menu_citizens_title"], description = ""},
				{name = txt[config.lang]["menu_vehicles_title"], description = ""},
				{name = txt[config.lang]["menu_close_menu_title"], description = ""},
			}
		},
		[txt[config.lang]["menu_animations_title"]] = {
			title = txt[config.lang]["menu_animations_title"],
			name = txt[config.lang]["menu_animations_title"],
			buttons = {
				{name = txt[config.lang]["menu_anim_do_traffic_title"], description = ''},
				{name = txt[config.lang]["menu_anim_take_notes_title"], description = ''},
				{name = txt[config.lang]["menu_anim_standby_title"], description = ''},
				{name = txt[config.lang]["menu_anim_standby_2_title"], description = ''},
			}
		},
		[txt[config.lang]["menu_citizens_title"]] = {
			title = txt[config.lang]["menu_citizens_title"],
			name = txt[config.lang]["menu_citizens_title"],
			buttons = buttonsCitizen
		},
		[txt[config.lang]["menu_fines_title"]] = {
			title = txt[config.lang]["menu_fines_title"],
			name = txt[config.lang]["menu_fines_title"],
			buttons = {
				{name = "$250", description = ''},
				{name = "$500", description = ''},
				{name = "$1000", description = ''},
				{name = "$1500", description = ''},
				{name = "$2000", description = ''},
				{name = "$4000", description = ''},
				{name = "$6000", description = ''},
				{name = "$8000", description = ''},
				{name = "$10000", description = ''},
				{name = txt[config.lang]["menu_custom_amount_fine_title"], description = ''},
			}
		},
		[txt[config.lang]["menu_vehicles_title"]] = {
			title = txt[config.lang]["menu_vehicles_title"],
			name = txt[config.lang]["menu_vehicles_title"],
			buttons = buttonsVehicle
		},
	}
}

-------------------------------------------------
----------------BUTTONS FUNCTIONS----------------
-------------------------------------------------

function ButtonSelectedPolice(button)
	local ped = GetPlayerPed(-1)
	local this = menupolice.currentmenu
	local btn = button.name
	if this == txt[config.lang]["menu_categories_title"] then
		if btn == txt[config.lang]["menu_animations_title"] then
			OpenMenuPolice(txt[config.lang]["menu_animations_title"])
		elseif btn == txt[config.lang]["menu_citizens_title"] then
			OpenMenuPolice(txt[config.lang]["menu_citizens_title"])
		elseif btn == txt[config.lang]["menu_vehicles_title"] then
			OpenMenuPolice(txt[config.lang]["menu_vehicles_title"])
		elseif btn == txt[config.lang]["menu_close_menu_title"] then
			CloseMenuPolice()
		end
	elseif this == txt[config.lang]["menu_animations_title"] then
		if btn == txt[config.lang]["menu_anim_do_traffic_title"] then
			DoTraffic()
		elseif btn == txt[config.lang]["menu_anim_take_notes_title"] then
			Note()
		elseif btn == txt[config.lang]["menu_anim_standby_title"] then
			StandBy()
		elseif btn == txt[config.lang]["menu_anim_standby_2_title"] then
			StandBy2()
		end
	elseif this == txt[config.lang]["menu_citizens_title"] then
		if btn == txt[config.lang]["menu_fines_title"] then
			OpenMenuPolice(txt[config.lang]["menu_fines_title"])
		elseif btn == txt[config.lang]["menu_check_inventory_title"] then
			CheckInventory()
		elseif btn == txt[config.lang]["menu_toggle_cuff_title"] then
			ToggleCuff()
		elseif btn == txt[config.lang]["menu_force_player_get_in_car_title"] then
			PutInVehicle()
		elseif btn == txt[config.lang]["menu_force_player_get_out_car_title"] then
			UnseatVehicle()
		elseif btn == txt[config.lang]["menu_drag_player_title"] then
			DragPlayer()
		elseif btn == txt[config.lang]["menu_id_card_title"] then
			CheckId()
		end
	elseif this == txt[config.lang]["menu_vehicles_title"] then
		if btn == txt[config.lang]["menu_crochet_veh_title"] then
			Crochet()
		elseif btn == txt[config.lang]["menu_check_plate_title"] then
			CheckPlate()
		end
	elseif this == txt[config.lang]["menu_fines_title"] then
		if btn == "$250"then
			Fines(250)
		elseif btn == "$500" then
			Fines(500)
		elseif btn == "$1000" then
			Fines(1000)
		elseif btn == "$1500" then
			Fines(1500)
		elseif btn == "$2000" then
			Fines(2000)
		elseif btn == "$4000" then
			Fines(4000)
		elseif btn == "$6000" then
			Fines(6000)
		elseif btn == "$8000" then
			Fines(8000)
		elseif btn == "$10000" then
			Fines(10000)
		elseif btn == txt[config.lang]["menu_custom_amount_fine_title"] then
			Fines(-1)
		end
	end
end

-------------------------------------------------
---------------ANIMATIONS FUNCTIONS--------------
-------------------------------------------------

function DoTraffic()
	Citizen.CreateThread(function()
        TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_CAR_PARK_ATTENDANT", 0, false)
        Citizen.Wait(60000)
        ClearPedTasksImmediately(GetPlayerPed(-1))
    end)
	drawNotification(txt[config.lang]["menu_doing_traffic_notification"])
end

function Note()
	Citizen.CreateThread(function()
        TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_CLIPBOARD", 0, false)
        Citizen.Wait(20000)
        ClearPedTasksImmediately(GetPlayerPed(-1))
    end) 
	drawNotification(txt[config.lang]["menu_taking_notes_notification"])
end

function StandBy()
	Citizen.CreateThread(function()
        TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_COP_IDLES", 0, true)
        Citizen.Wait(20000)
        ClearPedTasksImmediately(GetPlayerPed(-1))
    end)
	drawNotification(txt[config.lang]["menu_being_stand_by_notification"])
end

function StandBy2()
	Citizen.CreateThread(function()
        TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_GUARD_STAND", 0, 1)
        Citizen.Wait(20000)
        ClearPedTasksImmediately(GetPlayerPed(-1))
    end)
	drawNotification(txt[config.lang]["menu_being_stand_by_notification"])
end

-------------------------------------------------
-----------------CITIZENS FUNCTIONS--------------
-------------------------------------------------

function CheckInventory()
	local t, distance = GetClosestPlayer()
	if(distance ~= -1 and distance < 3) then
		TriggerServerEvent("police:targetCheckInventory", GetPlayerServerId(t))
	else
		TriggerEvent('chatMessage', txt[config.lang]["title_notification"], {255, 0, 0}, txt[config.lang]["no_player_near_ped"])
	end
end

function CheckId()
	local t , distance  = GetClosestPlayer()
    if(distance ~= -1 and distance < 3) then
		TriggerServerEvent('gc:copOpenIdentity', GetPlayerServerId(t))
    else
		TriggerEvent('chatMessage', txt[config.lang]["title_notification"], {255, 0, 0}, txt[config.lang]["no_player_near_ped"])
	end
end

function ToggleCuff()
	local t, distance = GetClosestPlayer()
	if(distance ~= -1 and distance < 3) then
		TriggerServerEvent("police:cuffGranted", GetPlayerServerId(t))
	else
		TriggerEvent('chatMessage', txt[config.lang]["title_notification"], {255, 0, 0}, txt[config.lang]["no_player_near_ped"])
	end
end

function PutInVehicle()
	local t, distance = GetClosestPlayer()
	if(distance ~= -1 and distance < 3) then
		local v = GetVehiclePedIsIn(GetPlayerPed(-1), true)
		TriggerServerEvent("police:forceEnterAsk", GetPlayerServerId(t), v)
	else
		TriggerEvent('chatMessage', txt[config.lang]["title_notification"], {255, 0, 0}, txt[config.lang]["no_player_near_ped"])
	end
end

function UnseatVehicle()
	local t, distance = GetClosestPlayer()
	if(distance ~= -1 and distance < 3) then
		TriggerServerEvent("police:confirmUnseat", GetPlayerServerId(t))
	else
		TriggerEvent('chatMessage', txt[config.lang]["title_notification"], {255, 0, 0}, txt[config.lang]["no_player_near_ped"])
	end
end

function DragPlayer()
	local t, distance = GetClosestPlayer()
	if(distance ~= -1 and distance < 3) then
		TriggerServerEvent("police:dragRequest", GetPlayerServerId(t))
	else
		TriggerEvent('chatMessage', txt[config.lang]["title_notification"], {255, 0, 0}, txt[config.lang]["no_player_near_ped"])
	end
end

function Fines(amount)
	local t, distance = GetClosestPlayer()
	if(distance ~= -1 and distance < 3) then
		if(amount == -1) then
			DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8S", "", "", "", "", "", 20)
			while (UpdateOnscreenKeyboard() == 0) do
				DisableAllControlActions(0);
				Wait(0);
			end
			if (GetOnscreenKeyboardResult()) then
				local res = tonumber(GetOnscreenKeyboardResult())
				if(res ~= nil and res ~= 0) then
					amount = res				
				end
			end
		end
		
		if(amount ~= -1) then
			TriggerServerEvent("police:finesGranted", GetPlayerServerId(t), amount)
		end
	else
		TriggerEvent('chatMessage', txt[config.lang]["title_notification"], {255, 0, 0}, txt[config.lang]["no_player_near_ped"])
	end
end

-------------------------------------------------
-----------------VEHICLES FUNCTIONS--------------
-------------------------------------------------

function Crochet()
	Citizen.CreateThread(function()
		local pos = GetEntityCoords(GetPlayerPed(-1))
		local entityWorld = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 20.0, 0.0)

		local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, GetPlayerPed(-1), 0)
		local _, _, _, _, vehicleHandle = GetRaycastResult(rayHandle)
		if(DoesEntityExist(vehicleHandle)) then
			TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_WELDING", 0, true)
			Citizen.Wait(20000)
			SetVehicleDoorsLocked(vehicleHandle, 1)
			ClearPedTasksImmediately(GetPlayerPed(-1))
			drawNotification(txt[config.lang]["menu_veh_opened_notification"])
		else
			drawNotification(txt[config.lang]["no_veh_near_ped"])
		end
	end)
end

function CheckPlate()
	local pos = GetEntityCoords(GetPlayerPed(-1))
	local entityWorld = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 20.0, 0.0)

	local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, GetPlayerPed(-1), 0)
	local _, _, _, _, vehicleHandle = GetRaycastResult(rayHandle)
	if(DoesEntityExist(vehicleHandle)) then
		TriggerServerEvent("police:checkingPlate", GetVehicleNumberPlateText(vehicleHandle))
	else
		drawNotification(txt[config.lang]["no_veh_near_ped"])
	end
end
-------------------------------------------------
----------------CONFIG OPEN MENU-----------------
-------------------------------------------------

function OpenMenuPolice(menu)
	menupolice.lastmenu = menupolice.currentmenu
	if menu == txt[config.lang]["menu_animations_title"] then
		menupolice.lastmenu = txt[config.lang]["menu_categories_title"]
	elseif menu == txt[config.lang]["menu_citizens_title"] then
		menupolice.lastmenu = txt[config.lang]["menu_categories_title"]
	elseif menu == txt[config.lang]["menu_vehicles_title"] then
		menupolice.lastmenu = txt[config.lang]["menu_categories_title"]
	elseif menu == txt[config.lang]["menu_fines_title"] then
		menupolice.lastmenu = txt[config.lang]["menu_categories_title"]
	end
	menupolice.menu.from = 1
	menupolice.menu.to = 10
	menupolice.selectedbutton = 0
	menupolice.currentmenu = menu
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
local menu = menupolice.menu
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
	local menu = menupolice.menu
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
	local menu = menupolice.menu
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
	local menu = menupolice.menu
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

function BackMenuPolice()
	if backlock then
		return
	end
	backlock = true
	if menupolice.currentmenu == txt[config.lang]["menu_categories_title"] then
		CloseMenuPolice()
	elseif menupolice.currentmenu == txt[config.lang]["menu_animations_title"] or menupolice.currentmenu == txt[config.lang]["menu_citizens_title"] or menupolice.currentmenu == txt[config.lang]["menu_vehicles_title"] or menupolice.currentmenu == txt[config.lang]["menu_fines_title"] then
		OpenMenuPolice(menupolice.lastmenu)
	else
		OpenMenuPolice(menupolice.lastmenu)
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
function OpenPoliceMenu()
	menupolice.currentmenu = txt[config.lang]["menu_categories_title"]
	menupolice.opened = true
	menupolice.selectedbutton = 0
end

-------------------------------------------------
----------------FONCTION CLOSE-------------------
-------------------------------------------------

function CloseMenuPolice()
		menupolice.opened = false
		menupolice.menu.from = 1
		menupolice.menu.to = 10
end

-------------------------------------------------
----------------FONCTION OPEN MENU---------------
-------------------------------------------------

local backlock = false
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if (IsControlJustPressed(1,166) and menupolice.opened == true) then
				CloseMenuPolice()
		end
		if menupolice.opened then
			local ped = LocalPed()
			local menu = menupolice.menu[menupolice.currentmenu]
			drawTxt(menupolice.title,1,1,menupolice.menu.x,menupolice.menu.y,1.0, 255,255,255,255)
			drawMenuTitle(menu.title, menupolice.menu.x,menupolice.menu.y + 0.08)
			drawTxt(menupolice.selectedbutton.."/"..tablelength(menu.buttons),0,0,menupolice.menu.x + menupolice.menu.width/2 - 0.0385,menupolice.menu.y + 0.067,0.4, 255,255,255,255)
			local y = menupolice.menu.y + 0.12
			buttoncount = tablelength(menu.buttons)
			local selected = false

			for i,button in pairs(menu.buttons) do
				if i >= menupolice.menu.from and i <= menupolice.menu.to then

					if i == menupolice.selectedbutton then
						selected = true
					else
						selected = false
					end
					drawMenuButton(button,menupolice.menu.x,y,selected)
					if button.distance ~= nil then
						drawMenuRight(button.distance.."m",menupolice.menu.x,y,selected)
					end
					y = y + 0.04
					if selected and IsControlJustPressed(1,201) then
						ButtonSelectedPolice(button)
					end
				end
			end
		end
		if menupolice.opened then
			if IsControlJustPressed(1,202) then
				BackMenuPolice()
			end
			if IsControlJustReleased(1,202) then
				backlock = false
			end
			if IsControlJustPressed(1,188) then
				if menupolice.selectedbutton > 1 then
					menupolice.selectedbutton = menupolice.selectedbutton -1
					if buttoncount > 10 and menupolice.selectedbutton < menupolice.menu.from then
						menupolice.menu.from = menupolice.menu.from -1
						menupolice.menu.to = menupolice.menu.to - 1
					end
				end
			end
			if IsControlJustPressed(1,187)then
				if menupolice.selectedbutton < buttoncount then
					menupolice.selectedbutton = menupolice.selectedbutton +1
					if buttoncount > 10 and menupolice.selectedbutton > menupolice.menu.to then
						menupolice.menu.to = menupolice.menu.to + 1
						menupolice.menu.from = menupolice.menu.from + 1
					end
				end
			end
		end

	end
end)