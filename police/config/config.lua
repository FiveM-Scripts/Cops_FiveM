config = {
	enableVersionNotifier = true, --notify if a new version is available (server console)

	useModifiedBanking = false, --require Simple Banking
	enableOutfits = false, --require Skin Customization
	
	stationBlipsEnabled = true, -- switch between true or false to enable/disable blips for police stations
	useCopWhitelist = true,
	
	enableOtherCopsBlips = true,
	useNativePoliceGarage = true,
	enableNeverWanted = true,
	
	propsSpawnLimitByCop = 20,
	
	displayRankBeforeNameOnChat = true,
	
	--Available languages : 'en', 'fr', 'de'
	lang = 'en',
		
	bindings = {
		interact_position = 51, -- E
		use_police_menu = 166, -- F5
		accept_fine = 246, -- Y
		refuse_fine = 45 -- R
	},

	--Customizable Departments
	departments = {
		label = {
			[0] = "Park Rangers",
			[1] = "Los Santos Police Department",
			[2] = "Sheriff's Department",
			[3] = "State Highway Patrol",
			[4] = "Prison Department"
		},

		minified_label = {
			[0] = "PR",
			[1] = "LSPD",
			[2] = "SHR",
			[3] = "SHP ",
			[4] = "PRISON"
		}
	},
	
	--Customizable ranks
	rank = {

		--You can add or remove ranks as you want (just make sure to use numeric index, ascending)
		label = {
			[0] = "Trainee", -- Ranger Rank
			[1] = "Trainee", -- LSPD Rank
			[2] = "Trainee", -- Sheriff Rank
			[3] = "Trainee", -- State Highway Patrol Rank

			[4] = "Park Ranger",
			[5] = "Police Officer",
			[6] = "Deputy Sheriff",
			[7] = "State Trooper",

			[8] = "Park Ranger II",
			[9] = "Master Police Officer",
			[10] = "Deputy Sheriff II",
			[11] = "State Trooper II",

			[12] = "Sergeant",
			[13] = "Sergeant",
			[14] = "Sergeant",
			[15] = "Sergeant",

			[16] = "Lieutenant",
			[17] = "Lieutenant",
			[18] = "Lieutenant",
			[19] = "Lieutenant",

			[20] = "Captian",
			[21] = "Captian",
			[22] = "Captian",
			[23] = "Captian",
 
			[24] = "Game Warden ",
			[25] = "Chief of Police",
			[26] = "Sheriff",
			[27] = "Chief of SHP",

			[28] = "Ranger Admin Rank",
			[29] = "Police Admin Rank",
			[30] = "Sheriff Admin Rank",
			[31] = "SHP Admin Rank",
		},

		--Used for chat
		minified_label = {
			[0] = "TNE",
			[1] = "TNE", --1
			[2] = "TNE",
			[3] = "TNE",

			[4] = "PR",
			[5] = "PO", --2
			[6] = "DS",
			[7] = "ST",

			[8] = "PR2",
			[9] = "MPO", --3
			[10] = "DS2",
			[11] = "ST2",

			[12] = "SGT",
			[13] = "SGT", --4
			[14] = "SGT",
			[15] = "SGT",

			[16] = "LT",
			[17] = "LT", --5
			[18] = "LT",
			[19] = "LT",

			[20] = "CPT",
			[21] = "CPT", --6
			[22] = "CPT",
			[23] = "CPT",

			[24] = "GW",
			[25] = "COP", --7
			[26] = "SHF",
			[27] = "COS",

			[28] = "RAR",
			[29] = "APR", --8
			[30] = "ASR",
			[31] = "SSR",
		},

		--You can set here a badge for each rank you have. You have to enable "enableOutfits" to use this
		--The index is the rank index, the value is the badge index.
		--Here a link where you have the 4 MP Models badges with their index : https://kyominii.com/fivem/index.php/MP_Badges
		outfit_badge = {
			[0] = 0,
			[1] = 0,
			[2] = 0,
			[3] = 0,

			[4] = 0,
			[5] = 0,
			[6] = 0,
			[7] = 0,

			[8] = 1,
			[9] = 1,
			[10] = 1,
			[11] = 1,

			[12] = 1,
			[13] = 1,
			[14] = 1,
			[15] = 1,

			[16] = 2,
			[17] = 2,
			[18] = 2,
			[19] = 2,

			[20] = 2,
			[21] = 2,
			[22] = 2,
			[23] = 2,

			[24] = 3,
			[25] = 3,
			[26] = 3,
			[27] = 3,

			[28] = 3,
			[29] = 3,
			[30] = 3,
			[31] = 3,
		},

		--Minimum rank require to modify officers rank
		min_rank_set_rank = 24
	}
}

clockInStation = {
  {x=850.156677246094, y=-1283.92004394531, z=28.0047378540039}, -- La Mesa
  {x=457.956909179688, y=-992.72314453125, z=30.6895866394043}, -- Mission Row
  {x=1856.91320800781, y=3689.50073242188, z=34.2670783996582}, -- Sandy Shore
  {x=-450.063201904297, y=6016.5751953125, z=31.7163734436035}, -- Paleto Bay
  {x=-1093.0604248046875, y=-808.6140747070312, z=19.28019142150879}, -- Vespucci
  {x=360.3169860839844, y=-1583.9188232421875, z=29.291934967041016} -- Davis Sheriff station
}

garageStation = {
   {x=-470.85266113281, y=6022.9296875, z=31.340530395508},  -- La Mesa
   {x=1873.3372802734, y=3687.3508300781, z=33.616954803467},  -- Mission Row
   {x=452.115966796875, y=-1018.10681152344, z=28.4786586761475}, -- Sandy Shore
   {x=855.24249267578, y=-1279.9300537109, z=26.513223648071 },  --Paleto Bay
   {x=-1070.1719970703125, y=-854.4666137695312, z=4.8671650886535645 },  -- Vespucci 
   {x=383.7397766113281, y=-1624.2393798828125, z=29.291946411132812} -- Davis Sheriff station
}

heliStation = {
    {x=449.113966796875, y=-981.084966796875, z=43.691966796875} -- Mission Row
}

armoryStation = {
    {x=452.119966796875, y=-980.061966796875, z=30.690966796875}, -- La Mesa
    {x=853.157, y=-1267.74, z= 26.6729}, -- Mission Row	
    {x=1849.63, y=3689.48, z=34.2671}, -- Sandy Shore
    {x=-448.219, y= 6008.98, z=31.7164}, -- Paleto Bay
    -- still need to add vespucci
    {x=352.9969177246094, y=-1592.7291259765625, z=29.291934967041016}  -- Davis Sheriff station
}

i18n.setLang(tostring(config.lang))
