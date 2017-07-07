# Cops_FiveM v1.3.0
Thanks to FiveM Scripts for their help :

<a href="https://discord.gg/eNJraMf"><img alt="Discord Status" src="https://discordapp.com/api/guilds/285462938691567627/widget.png"></a>

# Description

Cops_FiveM is a script for RP server mainly. It let servers to have a cops system with loadout, vehicles, inventory check, ...

# Current Features

* support mysql, mysql-async and couchdb
* configurable (features and language)
* cops whitelist
* take/break service (positions with blips)
* different service mode
* cop garage (vehicle/heli)
* check inventory
* fines
* cuff/uncuff (credits to @Marxy  : https://forum.fivem.net/t/release-simple-cuff-script-and-example-resource/4200)
* check inventory
* illegal items removed
* weapons removed
* force cuffed player to go in the vehicle
* unseat this player (Thanks @Thefoxeur54 )
* GUI menu with some animations
* check vehicle plate
* cops can see each other blips : (thanks @Scammer  -- https://forum.fivem.net/t/release-scammers-script-collection-09-03-17/3313)
* drag players (thanks @Frazzle and others : https://forum.fivem.net/t/release-drag-command/22174)
* so many other features ...

# Changelog
You can find the changelog [here](https://github.com/Kyominii/Cops_FiveM/blob/master/CHANGELOG.md)

# Contribute
If you are a developer and  would like to contribute any help is welcome!   
The contribution guide can be found [here](https://github.com/Kyominii/Cops_FiveM/blob/master/CONTRIBUTING.md).

(Readme, Contributing and Changelog files from by [FiveM Script](https://github.com/FiveM-Scripts/), thanks ^^)

# Support
This script works on few server, so if it doesn't work, please make an effort before posting your issue.
I won't provide support for people asking help without minimal details (logs are appreciated)

# FXServer

## Installation

* Install supported scripts you want
* Download police-fxserver folder from this [git](https://github.com/Kyominii/Cops_FiveM) and rename it police
* Put this folder to resources folder in your server
* Add police.sql in your database and uncomment the import line in __resource.lua if you are using mysql-async
* Edit config.lua as you want and config_db.lua
* Add "start police" in server.cfg (make sure you start this resource after all dependencies)

# Legacy (non FXServer)

 /!\ Higher version supported by legacy version : 1.3 (no more update for legacy version after that version) /!\

## Installation

* Install supported scripts you want
* Download police-legacy folder from this [git](https://github.com/Kyominii/Cops_FiveM) and rename it police
* Put this folder to resources folder in your server
* Add police.sql to your database if you are using mysql or mysql-async
* Edit config.lua as you want and config_db.lua
* Add police to your .yml file in AutoStartResource section

# Supported scripts

* [Essentialmode](https://forum.fivem.net/t/release-essentialmode-base/3665)
* [mysql-async](https://forum.fivem.net/t/beta-mysql-async-library-v0-2-2/21881)
* [fs_freeroam](https://forum.fivem.net/t/alpha-fs-freeroam-0-1-4-fivem-scripts/14097)
* [Vdk_inventory](https://forum.fivem.net/t/release-inventory-system-v1-4/14477)
* [Simple Banking](https://forum.fivem.net/t/release-simple-banking-2-0-now-with-gui/13896)

If you are using this script, add this piece of code in server.lua (banking)

### SQL version

```lua
RegisterServerEvent('bank:withdrawFine')
AddEventHandler('bank:withdrawAmende', function(amount)
  TriggerEvent('es:getPlayerFromId', source, function(user)
      local rounded = round(tonumber(amount), 0)
      if(string.len(rounded) >= 9) then
        TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "^1Input too high^0")
        CancelEvent()
      else
        local player = user.identifier
        local bankbalance = bankBalance(player)
        withdraw(player, rounded)
        local new_balance = bankBalance(player)
        TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Maze Bank", false, "Withdrew: ~g~$".. rounded .." ~n~~s~New Balance: ~g~$" .. new_balance)
        TriggerClientEvent("banking:updateBalance", source, new_balance)
        TriggerClientEvent("banking:removeBalance", source, rounded)
        CancelEvent()
      end
  end)
end)
```

### CouchDB version 

```lua
RegisterServerEvent('bank:withdrawFine')
AddEventHandler('bank:withdrawAmende', function(amount)
  TriggerEvent('es:getPlayerFromId', source, function(user)
      local rounded = round(tonumber(amount), 0)
      if(string.len(rounded) >= 9) then
        TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "^1Input too high^0")
        CancelEvent()
      else
		  withdraw(source, rounded)
		  local new_balance = user.bank
		  TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Maze Bank", false, "Withdrew: ~g~$".. rounded .." ~n~~s~New Balance: ~g~$" .. new_balance)
		  TriggerClientEvent("banking:updateBalance", source, new_balance)
		  TriggerClientEvent("banking:removeBalance", source, rounded)
		  CancelEvent()
	  end
  end)
end)
```

* [JobSystem](https://forum.fivem.net/t/release-jobs-system-v1-0-and-paycheck-v2-0/14054)
* [Skin Customization](https://forum.fivem.net/t/release-skin-customization-v1-0/16491)
* [Player in db](https://forum.fivem.net/t/release-nameofplayers-v-1-get-name-of-players-in-database/17983)
* [es_weashop](https://forum.fivem.net/t/release-es-weapon-store-v1-1/12195)
* [garages](https://forum.fivem.net/t/release-garages-v4-1-fr-en-03-06-17-updated/13066)
* [emergency](https://forum.fivem.net/t/release-job-save-people-be-a-hero-paramedic-emergency-coma-ko/19773)

If you are using this script, add this piece of code in cl_healthplayer.lua (line 196 -- function ResPlayer() -- emergency)

```lua
TriggerEvent("es_em:cl_ResPlayer")
```

* [gc_identity](https://github.com/Gannon001/gcidentity)

If you are using this script, add this event in server.lua (gc_identity)
```lua
RegisterServerEvent('gc:copOpenIdentity')
AddEventHandler('gc:copOpenIdentity',function(other)
    local data = getIdentity(other)
    if data ~= nil then 
        TriggerClientEvent('gc:showItentity', source, {
            nom = data.nom,
            prenom = data.prenom,
            sexe = data.sexe,
            dateNaissance = tostring(data.dateNaissance),
            jobs = data.jobs,
            taille = data.taille
        })
    end
end)
```

## Commands
* /copadd ID : to add a policeman in the database
* /coprem ID : to remove a policeman from the database

## Thanks to the whole community of FiveM which help to improve this script (credits are in source code)
## Thanks to Cops testers too : `<Oskarr/> (or Oskr)` and `BritishBrotherhood`
