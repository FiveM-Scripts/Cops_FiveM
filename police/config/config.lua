COPS_FIVEM_VERSION = {
	str = "1.4.3",
	num = 143,
	isDev = true}

--Main config file, modify it as you want
config = {
	enableVersionNotifier = true, --notify is a new version is available (server console)

	useModifiedEmergency = false, --require modified emergency script
	useModifiedBanking = false, --require Simple Banking
	useVDKInventory = false, --require VDK Inventory script
	useGcIdentity = false, --require GCIdentity
	enableOutfits = false, --require Skin Customization
	useJobSystem = false, -- require job system
	useWeashop = false, -- require es_weashop
	
	stationBlipsEnabled = true, -- switch between true or false to enable/disable blips for police stations
	useCopWhitelist = true,
	enableCheckPlate = false, --require garages
	
	enableOtherCopsBlips = true,
	useNativePoliceGarage = true,
	enableNeverWanted = true,
	
	propsSpawnLimitByCop = 20,
	
	displayRankBeforeNameOnChat = true,
	
	--Available languages : 'en', 'fr', 'de'
	lang = 'en',
	
	--Use by job system
	job = {
		officer_on_duty_job_id = 2,
		officer_not_on_duty_job_id = 7,
	},
	
	bindings = {
		interact_position = 51, -- E
		use_police_menu = 166, -- F5
		accept_fine = 246, -- Y
		refuse_fine = 45 -- R
	},
	
	--Customizable ranks
	rank = {
		
		--You can add or remove ranks as you want (just make sure to use numeric index, ascending)
		label = {
			[0] = "Trainee",
			[1] = "Trooper",
			[2] = "Master Police Officer",
			[3] = "Sergeant",
			[4] = "Lieutenant",
			[5] = "Captain",
			[6] = "Chief of Police",
			[7] = "Admin Police Rank"
		},
		
		--Used for chat
		minified_label = {
			[0] = "TNE",
			[1] = "TPE",
			[2] = "MPO",
			[3] = "SGT",
			[4] = "LTN",
			[5] = "CPT",
			[6] = "COP",
			[7] = "APR"
		},
		
		--You can set here a badge for each rank you have. You have to enable "enableOutfits" to use this
		--The index is the rank index, the value is the badge index.
		--Here a link where you have the 4 MP Models badges with their index : https://kyominii.com/fivem/index.php/MP_Badges
		outfit_badge = {
			[0] = 0,
			[1] = 0,
			[2] = 1,
			[3] = 1,
			[4] = 2,
			[5] = 2,
			[6] = 3,
			[7] = 0
		},
		
		--Minimum rank require to modify officers rank
		min_rank_set_rank = 6
	}
}

--[[
You can modify the script if you want it to work with a specific gamemode/script
Just share us your modification and maybe could I integrate your changes in the script (manageable with this config file)
Also feel free to send me translation into your own language and notice me if I done some mistakes in transaltions ;)
]]

txt = {
	fr = {
		police_station = "Station de police",
		title_notification = "Gouvernement",
		now_cuffed = "Vous êtes menotté !",
		now_uncuffed = "Liberté !",
		info_fine_request_before_amount = "Appuyez sur ~g~Y~s~ pour accepter l'amende de $",
		info_fine_request_after_amount = ", appuyez sur ~r~R~s~ pour la refuser !",
		request_fine_expired = "La demande de l'amende à ~r~expirée~s~ !",
		pay_fine_success_before_amount = "Vous avez payé l'amende de $",
		pay_fine_success_after_amount = ".",
		help_text_open_cloackroom = "Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le ~b~vestiaire de Police",
		help_text_put_car_into_garage = "Appuyez sur ~INPUT_CONTEXT~ pour rentrer le ~b~véhicule de Police",
		help_text_get_car_out_garage = "Appuyez sur ~INPUT_CONTEXT~ pour sortir un ~b~véhicule de Police",
		help_text_put_heli_into_garage = "Appuyez sur ~INPUT_CONTEXT~ pour rentrer l'~b~hélicoptère de Police",
		help_text_get_heli_out_garage = "Appuyez sur ~INPUT_CONTEXT~ pour sortir un ~b~hélicoptère de Police",
		no_player_near_ped = "Aucun joueur à proximité",
		no_veh_near_ped = "Aucun véhicule à proximté",
		cop_whitelist_disabled = "La whitelist police est désactivée, veuillez l'activer pour utiliser cette commande !",
		
		menu_id_card_title = "Carte d'identité",
		menu_check_inventory_title = "Fouiller",
		menu_toggle_cuff_title = "(De)Menotter",
		menu_weapons_title = "Confisquer les armes",
		menu_force_player_get_in_car_title = "Mettre dans le véhicule",
		menu_force_player_get_out_car_title = "Faire sortir du véhicule",
		menu_drag_player_title = "Escorter le joueur",
		menu_fines_title = "Amendes",
		menu_check_plate_title = "Plaque d'immatriculation",
		menu_crochet_veh_title = "Crocheter le véhicule",
		menu_global_title = "Menu Police",
		menu_categories_title = "Categories",
		menu_animations_title = "Animations",
		menu_citizens_title = "Citoyens",
		menu_vehicles_title = "Véhicules",
		menu_close_menu_title = "Fermer le menu",
		menu_anim_do_traffic_title = "Faire la circulation",
		menu_anim_take_notes_title = "Prendre des notes",
		menu_anim_standby_title = "Repos",
		menu_anim_standby_2_title = "Repos 2",
		menu_anim_Cancel_emote_title = "Annuler emote",
		menu_custom_amount_fine_title = "Autre montant",
		menu_doing_traffic_notification = "~g~Vous faites la circulation.",
		menu_taking_notes_notification = "~g~Vous prenez des notes.",
		menu_being_stand_by_notification = "~g~Vous êtes en Stand By.",
		menu_veh_opened_notification = "Le véhicule est ~g~ouvert~w~.",
		
		menu_put_in_jail_title = "Put in jail",
		menu_arrest_title = "Arrest",
		menu_custom_amount_jail_title = "Custom amount in seconds",
		jail_notification_title = "^4[JAIL]",
		jail_arrest_notification_part_1 = "You got Arrested for ^1", -- send to the client after he got puted into the jail
		jail_arrest_notification_part_2 = " ^0seconds!",
		jail_weapons_removed = "Your Weapons got removed for being Arrested!",
		jail_not_cuffed = "Player need to be cuffed!",
		jail_remove_weapons_notification_part_1 = "All the weapons from ",
		jail_remove_weapons_notification_part_2 = " got removed.",
		menu_delete_vehicle_title = "Delete Vehicle",
		
		garage_global_title = "Garage de police",
		garage_loading = "~b~Chargement...",
		
		cloackroom_global_title = "Vestiaire Police",
		cloackroom_take_service_normal_title = "Prendre le service (uniforme)",
		cloackroom_take_service_hidden_title = "Prendre le service (BAC)",
		cloackroom_take_service_swat_title = "Prendre le service (intervention)",
		cloackroom_break_service_title = "Fin de service",
		cloackroom_add_bulletproof_vest_title = "Gilet par balle",
		cloackroom_remove_bulletproof_vest_title = "Enlever le Gilet par balle",
		cloackroom_add_yellow_vest_title = "Gilet jaune",
		cloackroom_remove_yellow_vest_title = "Enlever le Gilet jaune",
		now_in_service_notification = "Vous êtes maintenant ~g~En service",
		break_service_notification = "Vous avez ~r~terminé votre service",
		help_open_menu_notification = "Appuyer sur ~g~F5~w~ pour ouvrir le ~b~Menu Police",
		
		menu_props_title = "Props",
		menu_spawn_props_title = "Placer un props",
		menu_remove_last_props_title = "Retirer le dernier props",
		menu_remove_all_props_title = "Retirer tous les props",
		
		vehicle_checking_plate_part_1 = "Le véhicule #", -- before number plate
		vehicle_checking_plate_part_2 = " appartient à ", -- between number plate and player name when veh registered
		vehicle_checking_plate_part_3 = "", -- after player name when veh registered
		vehicle_checking_plate_not_registered = " n'est pas enregistré !", -- after player name
		unseat_sender_notification_part_1 = "", -- before player name
		unseat_sender_notification_part_2 = " est sortie !", -- after player name
		drag_sender_notification_part_1 = "Escorte de ", -- before player name
		drag_sender_notification_part_2 = "", -- after player name
		checking_inventory_part_1 = "Items de ",
		checking_inventory_part_2 = " : ",
		checking_weapons_part_1 = "Armes de ",
		checking_weapons_part_2 = " : ",
		send_fine_request_part_1 = "Envoi d'une requête d'amende de $",
		send_fine_request_part_2 = " à ",
		already_have_a_pendind_fine_request = " à déjà une demande d'amende",
		request_fine_timeout = " n'a pas répondu à la demande d'amende",
		request_fine_refused = " à refusé son amende",
		request_fine_accepted = " à payé son amende",
		toggle_cuff_player_part_1 = "Tentative de mettre les menottes à ",
		toggle_cuff_player_part_2 = "",
		force_player_get_in_vehicle_part_1 = "Tentative de faire rentrer ",
		force_player_get_in_vehicle_part_2 = " dans le véhicule",
		usage_command_copadd = "Utilisation : /copadd [ID]",
		usage_command_coprem = "Utilisation : /coprem [ID]",
		usage_command_coprank = "Utilisation : /coprank [ID] [RANG]",
		command_received = "Compris !",
		become_cop_success = "Félicitation, vous êtes désormais policier !~w~.",
		remove_from_cops = "Vous n'êtes plus policier !~w~.",
		no_player_with_this_id = "Aucun joueur avec cet ID !",
		not_enough_permission = "Vous n'avez pas la permission de faire ça !",
		new_rank = "Félicitation, vous êtes désormais : ",
		player_not_cop = "Ce joueur n'est pas un policier",
		rank_not_exist = "Ce grade n'existe pas",
		
		armory_global_title = "Armurerie de Police",
		help_text_open_armory = "Appuyez sur ~INPUT_CONTEXT~ pour ouvrir l'armurerie",
		armory_add_bulletproof_vest_title = "Mettre le gilet par-balle",
        armory_remove_bulletproof_vest_title = "Retirer le gilet par-balle",
		armory_weapons_list = "Choisir les armes",
		armory_basic_kit = "Kit police de base",
		
		WEAPON_COMBATPISTOL = "Pistolet de combat",
		WEAPON_PISTOL50 = "Pistolet 50.",
		WEAPON_PUMPSHOTGUN = "Fusil à pompe",
		WEAPON_ASSAULTSHOTGUN = "Fusil à pompe d'assault",
		WEAPON_ASSAULTSMG = "SMG d'assault",
		WEAPON_HEAVYSNIPER = "Fusil de précision lourd"
	},
	
	en = {
		police_station = "Police Station",
        title_notification = "Government",
        now_cuffed = "You've been hand cuffed!",
        now_uncuffed = "Freedom!",
        info_fine_request_before_amount = "Press ~g~Y~s~ to accept the $",
        info_fine_request_after_amount = " fine, press ~r~R~s~ to refuse !",
        request_fine_expired = "The fine request has just ~r~expired~s~ !",
        pay_fine_success_before_amount = "You have just paid a fine or summons of $",
        pay_fine_success_after_amount = " fine.",
        help_text_open_cloackroom = "Press ~INPUT_CONTEXT~ to open the ~b~cop's cloackroom",
        help_text_put_car_into_garage = "Press ~INPUT_CONTEXT~ to put the police vehicle into the ~b~garage",
        help_text_get_car_out_garage = "Press ~INPUT_CONTEXT~ to get a police vehicle out of the ~b~garage",
        help_text_put_heli_into_garage = "Press ~INPUT_CONTEXT~ to put the helicopter into the ~b~garage",
        help_text_get_heli_out_garage = "Press ~INPUT_CONTEXT~ to get an helicopter out of the ~b~garage",
        no_player_near_ped = "No players near you",
        no_veh_near_ped = "No vehicles near you",
		cop_whitelist_disabled = "Cop whitelist is disable, please enable the whitelist to use this command !",
        
        menu_id_card_title = "ID Card",
        menu_check_inventory_title = "Check Inventory",
        menu_toggle_cuff_title = "Toggle Hand-Cuffs",
        menu_weapons_title = "Confiscate weapons",
        menu_force_player_get_in_car_title = "Put player in vehicle!",
        menu_force_player_get_out_car_title = "Get player out of vehicle!",
        menu_drag_player_title = "Drag the player forcefully",
        menu_fines_title = "Fines and Summons",
        menu_check_plate_title = "Run Plates",
        menu_crochet_veh_title = "Lockpick car",
        menu_global_title = "Police Menu",
        menu_categories_title = "Categories",
        menu_animations_title = "Animations",
        menu_citizens_title = "Citizens",
        menu_vehicles_title = "Vehicles",
        menu_close_menu_title = "Close the menu",
        menu_anim_do_traffic_title = "Do a traffic stop",
        menu_anim_take_notes_title = "Take notes",
        menu_anim_standby_title = "Stand By",
        menu_anim_standby_2_title = "Stand By 2",
        menu_anim_Cancel_emote_title = "Cancel emote",
        menu_custom_amount_fine_title = "Custom amount",
        menu_doing_traffic_notification = "~g~You're now running a traffic stop.",
        menu_taking_notes_notification = "~g~You're taking notes.",
        menu_being_stand_by_notification = "~g~You're awaiting orders.",
        menu_veh_opened_notification = "The vehicle is ~g~open~w~.",
		
		menu_put_in_jail_title = "Put in jail",
		menu_arrest_title = "Arrest",
		menu_custom_amount_jail_title = "Custom amount in seconds",
		jail_notification_title = "^4[JAIL]",
		jail_arrest_notification_part_1 = "You got Arrested for ^1", -- send to the client after he got put into the jail
		jail_arrest_notification_part_2 = " ^0seconds!",
		jail_weapons_removed = "Your Weapons have been removed for being Arrested!",
		jail_not_cuffed = "Player need to be cuffed!",
		jail_remove_weapons_notification_part_1 = "All the weapons from ",
		jail_remove_weapons_notification_part_2 = " got removed.",
		menu_delete_vehicle_title = "Delete Vehicle",
        
        garage_global_title = "Police garage",
        garage_loading = "~b~Loading...",
        
        cloackroom_global_title = "Police's Cloackroom",
        cloackroom_take_service_normal_title = "Clock in as Officer",
        cloackroom_take_service_hidden_title = "Clock in as Detective",
        cloackroom_take_service_swat_title = "Clock in as S.W.A.T",
        cloackroom_break_service_title = "Clock out",
        cloackroom_add_yellow_vest_title = "Put on a yellow vest",
        cloackroom_remove_yellow_vest_title = "Remove your yellow vest",
        now_in_service_notification = "You've just ~g~clocked in",
        break_service_notification = "You've just ~r~clocked out",
        help_open_menu_notification = "Press ~g~F5~w~ to open ~b~the police menu",
		
		menu_props_title = "Props",
		menu_spawn_props_title = "Spawn a props",
		menu_remove_last_props_title = "Remove last props",
		menu_remove_all_props_title = "Remove all props",
        
        vehicle_checking_plate_part_1 = "The vehicle #", -- before number plate
        vehicle_checking_plate_part_2 = " belongs to ", -- between number plate and player name when veh registered
        vehicle_checking_plate_part_3 = "", -- after player name when veh registered
        vehicle_checking_plate_not_registered = " isn't registered!", -- after player name
        unseat_sender_notification_part_1 = "", -- before player name
        unseat_sender_notification_part_2 = " has escaped!", -- after player name
        drag_sender_notification_part_1 = "Dragging ", -- before player name
        drag_sender_notification_part_2 = "", -- after player name
        checking_inventory_part_1 = "",
        checking_inventory_part_2 = "'s inventory : ",
        checking_weapons_part_1 = "",
        checking_weapons_part_2 = "'s weapons : ",
        send_fine_request_part_1 = "Tell the player to pay a $",
        send_fine_request_part_2 = " fine request to ",
        already_have_a_pendind_fine_request = " already has a pending fine request",
        request_fine_timeout = " hasn't answered to the fine request",
        request_fine_refused = " has refused to pay thier fine",
        request_fine_accepted = " has paid the fine",
        toggle_cuff_player_part_1 = "Trying to toggle cuff to ",
        toggle_cuff_player_part_2 = "",
        force_player_get_in_vehicle_part_1 = "Trying to force ",
        force_player_get_in_vehicle_part_2 = " to enter the vehicle",
        usage_command_copadd = "Usage : /copadd [ID]",
        usage_command_coprem = "Usage : /coprem [ID]",
		usage_command_coprank = "Usage : /coprank [ID] [RANK]",
        command_received = "Roger that !",
        become_cop_success = "Welcome to the Force!~w~",
        remove_from_cops = "You've been fired !~w~.",
        no_player_with_this_id = "No player with this ID!",
        not_enough_permission = "That's above your pay grade!",
		new_rank = "Congrats, you are now : ",
		player_not_cop = "This player isn't a cop",
		rank_not_exist = "This rank doesn't exist",
		
		armory_global_title = "Police's Armory",
		help_text_open_armory = "Press ~INPUT_CONTEXT~ to open police's armory",
		armory_add_bulletproof_vest_title = "Put on a bulletproof vest",
        armory_remove_bulletproof_vest_title = "Take off your bulletproof vest",
		armory_weapons_list = "Choose weapons",
		armory_basic_kit = "Basic cop kit",
		
		WEAPON_COMBATPISTOL = "Combat Pistol",
		WEAPON_PISTOL50 = "Pistol 50.",
		WEAPON_PUMPSHOTGUN = "Shotgun",
		WEAPON_ASSAULTSHOTGUN = "Assault Shotgun",
		WEAPON_ASSAULTSMG = "Assault SMG",
		WEAPON_HEAVYSNIPER = "Heavy Sniper"
    },
	
	de = {
		police_station = "Polizeistation",
		title_notification = "Regierung",
		now_cuffed = "Dir wurden die Handschellen angelegt !",
		now_uncuffed = "Freiheit !",
		info_fine_request_before_amount = "Drücke ~g~Y~s~ um das Strafgeld zu akzeptieren $",
		info_fine_request_after_amount = " , drücke ~r~R~s~ um es zu verweigern !",
		request_fine_expired = "Die Strafgeld Anfrage ist ~r~abgelaufen~s~ !",
		pay_fine_success_before_amount = "Du hast gerade $",
		pay_fine_success_after_amount = " Strafgeld gezahlt.",
		help_text_open_cloackroom = "Drücke ~INPUT_CONTEXT~ um die ~b~Polizei Garderobe zu öffnen",
		help_text_put_car_into_garage = "Drücke ~INPUT_CONTEXT~ um das Polizei Auto in die ~b~Garage zu parken",
		help_text_get_car_out_garage = "Drücke ~INPUT_CONTEXT~ um das Polizei Auto aus der ~b~Garage zu nehmen",
		help_text_put_heli_into_garage = "Drücke ~INPUT_CONTEXT~ um den Hubschrauber in die ~b~Garage zu parken",
		help_text_get_heli_out_garage = "Drücke ~INPUT_CONTEXT~ um den Hubschrauber aus der ~b~Garage zu nehmen",
		no_player_near_ped = "Kein Spieler in der Nähe",
		no_veh_near_ped = "Kein Fahrzeug in der Nähe",
		cop_whitelist_disabled = "Cop whitelist is disable, please enable the whitelist to use this command !",

		menu_id_card_title = "ID Karte",
		menu_check_inventory_title = "Kontrolliere das Inventar",
		menu_toggle_cuff_title = "Handschellen anglegen/abnehmen",
		menu_weapons_title = "Waffe beschlagnahmen",
		menu_force_player_get_in_car_title = "Ins Fahrzeug befördern",
		menu_force_player_get_out_car_title = "Aus dem Fahrzeug ziehen",
		menu_drag_player_title = "Den Spieler tragen",
		menu_fines_title = "Strafgeld",
		menu_check_plate_title = "Kennzeichen kontrollieren",
		menu_crochet_veh_title = "Fahrzeug aufbrechen",
		menu_global_title = "Polizei Menu",
		menu_categories_title = "Kategorien",
		menu_animations_title = "Animationen",
		menu_citizens_title = "Bürger",
		menu_vehicles_title = "Fahrzeuge",
		menu_close_menu_title = "Schließe das Menu",
		menu_anim_do_traffic_title = "Mach einen auf Traffik Polizisten",
		menu_anim_take_notes_title = "Nimm Notizen",
		menu_anim_standby_title = "Bereit stehen",
		menu_anim_standby_2_title = "Bereit stehen 2",
		menu_anim_Cancel_emote_title = "Abbrechen emote",

		menu_custom_amount_fine_title = "Benutzerdefinierte anzahl",
		menu_doing_traffic_notification = "~g~Du machst einen auf Traffik Polizisten.",
		menu_taking_notes_notification = "~g~Du bist am Notizen schreiben.",
		menu_being_stand_by_notification = "~g~Du stehst bereit.",
		menu_veh_opened_notification = "Das Fahrzeug ist jetzt ~g~offen~w~.",

		menu_put_in_jail_title = "Ins Gefängis bringen",
		menu_arrest_title = "Verhaften",
		menu_custom_amount_jail_title = "Benutzerdefinierte anzahl an Sekunden",
		jail_notification_title = "^4[JAIL]",
		jail_arrest_notification_part_1 = "Du wurdest verhaftet für ^1", -- send to the client after he got puted into the jail
		jail_arrest_notification_part_2 = " ^0Sekunden!",
		jail_weapons_removed = "Deine Waffen wurden entfernt weil du verhaftet wurdest!",
		jail_not_cuffed = "Der Spieler muss an Handschellen gefässelt sein!",
		jail_remove_weapons_notification_part_1 = "Alle Waffen vom ",
		jail_remove_weapons_notification_part_2 = " wurden entfernt.",
		menu_delete_vehicle_title = "Fahrzeug Löschen",

		garage_global_title = "Polizei Garage",
		garage_loading = "~b~Laden...",

		cloackroom_global_title = "Polizei Garderobe",
		cloackroom_take_service_normal_title = "Dienst beginnen (Uniformed Officer)",
		cloackroom_take_service_hidden_title = "Dienst beginnen (Undercover)",
		cloackroom_take_service_swat_title = "Dienst beginnen (SWAT)",
		cloackroom_break_service_title = "Dienst abbrechen",
		cloackroom_add_bulletproof_vest_title = "Schußsichere Weste anlegen",
		cloackroom_remove_bulletproof_vest_title = "Schußsichere Weste entfernen",
		cloackroom_add_yellow_vest_title = "Gelbe Warnweste anlegen",
		cloackroom_remove_yellow_vest_title = "Gelbe Warnweste entfernen",
		now_in_service_notification = "Du bist nun im ~g~Dienst",
		break_service_notification = "Du hast deinen ~r~Dienst abgebrochen",
		help_open_menu_notification = "Drücke ~g~F5~w~ um das ~b~Polizei Menu ~w~zu öffnen",
		
		menu_props_title = "Props",
		menu_spawn_props_title = "Laichen ein props",
		menu_remove_last_props_title = "Entfernen letzte props",
		menu_remove_all_props_title = "Entfernen alle props",

		vehicle_checking_plate_part_1 = "Das Fahrzeug #", -- before number plate
		vehicle_checking_plate_part_2 = " gehört ", -- between number plate and player name when veh registered
		vehicle_checking_plate_part_3 = "", -- after player name when veh registered
		vehicle_checking_plate_not_registered = " ist nicht Registriert !", -- after player name
		unseat_sender_notification_part_1 = "", -- before player name
		unseat_sender_notification_part_2 = " ist Raus !", -- after player name
		drag_sender_notification_part_1 = "Tragen ", -- before player name
		drag_sender_notification_part_2 = "", -- after player name
		checking_inventory_part_1 = "",
		checking_inventory_part_2 = " sein Inventar : ",
		checking_weapons_part_1 = "",
		checking_weapons_part_2 = " seine Waffen : ",
		send_fine_request_part_1 = "Strafgeld Anfrage von $",
		send_fine_request_part_2 = " wurde an folgenden Spieler gesendet ",
		already_have_a_pendind_fine_request = " hat bereits eine Strafgeld Anfrage ausstehend",
		request_fine_timeout = " hat nicht auf die Strafgeld Anfrage reagiert",
		request_fine_refused = " hat die Strafgeld Anfrage verweigert",
		request_fine_accepted = " hat das Strafgeld bezahlt",
		toggle_cuff_player_part_1 = "Versuche Handschellen anzulegen am Spieler ",
		toggle_cuff_player_part_2 = "",
		force_player_get_in_vehicle_part_1 = "Versuche ",
		force_player_get_in_vehicle_part_2 = " in das Fahrzeug zu befördern",
		usage_command_copadd = "Benutze : /copadd [ID]",
		usage_command_coprem = "Benutze : /coprem [ID]",
		usage_command_coprank = "Benutze : /coprank [ID] [RANK]",
		command_received = "Roger that !",
		become_cop_success = "Herzlichen Glückwunsch, Sie sind nun ein Polizist !~w~",
		remove_from_cops = "Sie sind kein Polizist mehr !~w~.",
		no_player_with_this_id = "Kein Spieler mit folgender ID gefunden !",
		not_enough_permission = "Du hast nicht die benötigten Rechte um diesen Befehl auszuführen !",
		new_rank = "Congrats, you are now : ",
		player_not_cop = "This player isn't a cop",
		rank_not_exist = "This rank doesn't exist",
		
		armory_global_title = "Polizei Waffenkammer",
		help_text_open_armory = "Drücke ~INPUT_CONTEXT~ um die Polizei Waffenkammer zu öffnen",
		armory_add_bulletproof_vest_title = "Schußsichere Weste anlegen",
        armory_remove_bulletproof_vest_title = "Schußsichere Weste entfernen",
		armory_weapons_list = "Waffen auswählen",
		armory_basic_kit = "Standart Polizei Kit",
		
		WEAPON_COMBATPISTOL = "Combat Pistol",
		WEAPON_PISTOL50 = "Pistol 50.",
		WEAPON_PUMPSHOTGUN = "Shotgun",
		WEAPON_ASSAULTSHOTGUN = "Assault Shotgun",
		WEAPON_ASSAULTSMG = "Assault SMG",
		WEAPON_HEAVYSNIPER = "Heavy Sniper"
	}
}
