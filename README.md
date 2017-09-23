# Cops_FiveM v1.4.0

## /!\ If you are upgrading Cops_FiveM to 1.4.0, please have a look to the Upgrade section. If it is the first installation of Cops_FiveM, you can ignore this message. /!\

# Description

Cops_FiveM is a script for RP server mainly. It let servers to have a cops system with loadout, vehicles, inventory check, ...

# Current Features

* support mysql-async
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
* ranks (example of use : cloackroom.lua line 12)
* so many other features ...

# Changelog
You can find the changelog [here](https://github.com/Kyominii/Cops_FiveM/blob/master/CHANGELOG.md)

# Contribute
If you are a developer and  would like to contribute any help is welcome!   
The contribution guide can be found [here](https://github.com/Kyominii/Cops_FiveM/blob/master/CONTRIBUTING.md).

(Readme, Contributing and Changelog files from by [FiveM Script](https://github.com/FiveM-Scripts/), thanks ^^)


## Installation

* Install supported scripts you want
* Download police folder from this [git](https://github.com/Kyominii/Cops_FiveM) and rename it police
* Put this folder to resources folder in your server
* Add [sql file](https://github.com/Kyominii/Cops_FiveM/blob/master/police.sql) in your database
* Edit [config file](https://github.com/Kyominii/Cops_FiveM/blob/master/police/config/config.lua) as you want
* Add "start police" in server.cfg (make sure you start this resource after all dependencies)

# Upgrade

The database has changed with the v1.4.0, so you have to execute [upgrade file](https://github.com/Kyominii/Cops_FiveM/blob/master/upgrade-1.3-to-1.4.sql) on your database to migrate to the new police database

# Supported scripts

* [mysql-async](https://forum.fivem.net/t/beta-mysql-async-library-v0-2-2/21881)
* [fs_freemode](https://github.com/FiveM-Scripts/fs_freemode)
* [Vdk_inventory](https://forum.fivem.net/t/release-inventory-system-v1-4/14477)
* [Simple Banking](https://forum.fivem.net/t/release-simple-banking-2-0-now-with-gui/13896)

If you are using this script, add this piece of code in server.lua (banking)


```lua
RegisterServerEvent('bank:withdrawAmende')
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
        TriggerClientEvent("fs_core:notify", source, "CHAR_BANK_MAZE", 1, "Maze Bank", false, "Withdrew: ~g~$".. rounded .." ~n~~s~New Balance: ~g~$" .. new_balance)
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

* [Heli Script](https://forum.fivem.net/t/release-heli-script/24094) : it is not really "supported" because it's working without anything, but I recommand this script for the cop helicopter
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

## Commands (you have to have a rank >= minRankSetRank from config file)
* /copadd ID : to add a policeman in the database
* /coprem ID : to remove a policeman from the database
* /coprank ID Rank : To change the rank of a police officer

## Thanks to the whole community of FiveM which help to improve this script
