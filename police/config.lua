--Main config file, mmodify it as you want
config = {
	useModifiedEmergency = false, --require modified emergency script // not compatible with couchdb
	useModifiedBanking = false, --require Simple Banking // compatible with couchdb
	useVDKInventory = false, --require VDK Inventory script // not compatible with couchdb
	useGcIdentity = false, --require GCIdentity // not compatible with couchdb
	enableOutfits = false, --require Skin Customization // not compatible with couchdb
	useJobSystem = false, -- require job system // not compatible with couchdb
	useWeashop = false, -- require es_weashop // not compatible with couchdb
	
	useCopWhitelist = false, --require essentialmode + es_admin // compatible with couchdb
	enableCheckPlate = false, --require garages // not compatible with couchdb
	
	enableOtherCopsBlips = true,
	useNativePoliceGarage = true,
	enableNeverWanted = true,
	
	--Available languages : 'en', 'fr'
	lang = 'en',
	
	--Use by job system
	job = {
		officer_on_duty_job_id = 2,
		officer_not_on_duty_job_id = 7,
	}
}

--[[
You can modify the script if you want it to work with a specific gamemode/script
Just share us your modification and maybe could I integrate your changes in the script (manageable with this config file)
Also feel free to send me translation into your own language and notice me if I done some mistakes in transaltions ;)
]]

txt = {
	fr = {
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
		
		menu_id_card_title = "Carte d'identité",
		menu_check_inventory_title = "Fouiller",
		menu_toggle_cuff_title = "(De)Menotter",
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
		menu_custom_amount_fine_title = "Autre montant",
		menu_doing_traffic_notification = "~g~Vous faites la circulation.",
		menu_taking_notes_notification = "~g~Vous prenez des notes.",
		menu_being_stand_by_notification = "~g~Vous êtes en Stand By.",
		menu_veh_opened_notification = "Le véhicule est ~g~ouvert~w~.",
		
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
		force_player_get_in_vehicle_part_1 = " dans le véhicule",
		usage_command_copadd = "Utilisation : /copadd [ID]",
		usage_command_coprem = "Utilisation : /coprem [ID]",
		command_received = "Compris !",
		become_cop_success = "Félicitation, vous êtes désormais policier !~w~.",
		remove_from_cops = "Vous n'êtes plus policier !~w~.",
		no_player_with_this_id = "Aucun joueur avec cet ID !",
		not_enough_permission = "Vous n'avez pas la permission de faire ça !",
	},
	
	en = {
		title_notification = "Government",
		now_cuffed = "You are now cuffed !",
		now_uncuffed = "Freedom !",
		info_fine_request_before_amount = "Press ~g~Y~s~ to accept the $",
		info_fine_request_after_amount = " fine, press ~r~R~s~ to refuse !",
		request_fine_expired = "The fine request has just ~r~expired~s~ !",
		pay_fine_success_before_amount = "You have just paid a $",
		pay_fine_success_after_amount = " fine.",
		help_text_open_cloackroom = "Press ~INPUT_CONTEXT~ to open the ~b~cop's cloackroom",
		help_text_put_car_into_garage = "Press ~INPUT_CONTEXT~ to put the police vehicule into the ~b~garage",
		help_text_get_car_out_garage = "Press ~INPUT_CONTEXT~ to get a police vehicule out of the ~b~garage",
		help_text_put_heli_into_garage = "Press ~INPUT_CONTEXT~ to put the helicopter into the ~b~garage",
		help_text_get_heli_out_garage = "Press ~INPUT_CONTEXT~ to get an helicopter out of the ~b~garage",
		no_player_near_ped = "No player near you",
		no_veh_near_ped = "No vehicule near you",
		
		menu_id_card_title = "ID Card",
		menu_check_inventory_title = "Check Inventory",
		menu_toggle_cuff_title = "Toggle Cuff",
		menu_force_player_get_in_car_title = "Put in the vehicule",
		menu_force_player_get_out_car_title = "Get out of the vehicule",
		menu_drag_player_title = "Drag the player",
		menu_fines_title = "Fines",
		menu_check_plate_title = "Check Plate",
		menu_crochet_veh_title = "Crochet the vehicle",
		menu_global_title = "Police Menu",
		menu_categories_title = "Categories",
		menu_animations_title = "Animations",
		menu_citizens_title = "Citizens",
		menu_vehicles_title = "Véhicles",
		menu_close_menu_title = "Close the menu",
		menu_anim_do_traffic_title = "Do traffic cop",
		menu_anim_take_notes_title = "Take notes",
		menu_anim_standby_title = "Stand By",
		menu_anim_standby_2_title = "Stand By 2",
		menu_custom_amount_fine_title = "Custom amount",
		menu_doing_traffic_notification = "~g~You are doing a traffic cop.",
		menu_taking_notes_notification = "~g~Vous taking notes.",
		menu_being_stand_by_notification = "~g~You are in Stand By.",
		menu_veh_opened_notification = "The vehicle is ~g~open~w~.",
		
		garage_global_title = "Police's garage",
		garage_loading = "~b~Loading...",
		
		cloackroom_global_title = "Police's Cloackroom",
		cloackroom_take_service_normal_title = "Take service (normal)",
		cloackroom_take_service_hidden_title = "Take service (hidden)",
		cloackroom_take_service_swat_title = "Take service (swat)",
		cloackroom_break_service_title = "Break the service",
		cloackroom_add_bulletproof_vest_title = "Add bulletproof vest",
		cloackroom_remove_bulletproof_vest_title = "Remove bulletproof vest",
		cloackroom_add_yellow_vest_title = "Add yellow vest",
		cloackroom_remove_yellow_vest_title = "Remove yellow vest",
		now_in_service_notification = "You are now ~g~in service",
		break_service_notification = "You have ~r~break your service",
		help_open_menu_notification = "Press ~g~F5~w~ to open ~b~the police menu",
		
		vehicle_checking_plate_part_1 = "The vehicle #", -- before number plate
		vehicle_checking_plate_part_2 = " belongs to ", -- between number plate and player name when veh registered
		vehicle_checking_plate_part_3 = "", -- after player name when veh registered
		vehicle_checking_plate_not_registered = " isn't registered !", -- after player name
		unseat_sender_notification_part_1 = "", -- before player name
		unseat_sender_notification_part_2 = " is out !", -- after player name
		drag_sender_notification_part_1 = "Dragging ", -- before player name
		drag_sender_notification_part_2 = "", -- after player name
		checking_inventory_part_1 = "",
		checking_inventory_part_2 = "'s inventory : ",
		checking_weapons_part_1 = "",
		checking_weapons_part_2 = "'s weapons : ",
		send_fine_request_part_1 = "Sens a $",
		send_fine_request_part_2 = " fine request to ",
		already_have_a_pendind_fine_request = " has already a pending fine request",
		request_fine_timeout = " hasn't answer to the fine request",
		request_fine_refused = " has refuse his fine",
		request_fine_accepted = " has paid his fine",
		toggle_cuff_player_part_1 = "Trying to toggle cuff to ",
		toggle_cuff_player_part_2 = "",
		force_player_get_in_vehicle_part_1 = "Trying to force ",
		force_player_get_in_vehicle_part_1 = " to enter in the vehicle",
		usage_command_copadd = "Usage : /copadd [ID]",
		usage_command_coprem = "Usage : /coprem [ID]",
		command_received = "Roger that !",
		become_cop_success = "Congrats, you're now a cop !~w~",
		remove_from_cops = "You are'nt a cop anymore !~w~.",
		no_player_with_this_id = "No player with this ID !",
		not_enough_permission = "You don't have the permission to do that !",
	}
}