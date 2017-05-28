# Cops_FiveM v1.1.0
Thanks to FiveM Scripts for their help :

<a href="https://discord.gg/eNJraMf"><img alt="Discord Status" src="https://discordapp.com/api/guilds/285462938691567627/widget.png"></a>

Horizon RP :

<a href="https://discord.gg/btQzwvt"><img alt="Discord Status" src="https://discordapp.com/api/guilds/303627262199070720/widget.png"></a>

# Description

Cops_FiveM is a script for RP server mainly. It let servers to have a cops system with loadout, vehicles, inventory check, ...

# Current Features (full version v1.1.0)

* cops whitelist
* take/break service
* cop garage (vehicle/heli)
* check inventory
* fines
* cuff/uncuff (credits to @Marxy  : https://forum.fivem.net/t/release-simple-cuff-script-and-example-resource/4200)
* check inventory
* illegal items removed
* force cuffed player to go in the vehicle
* unseat this player (Thanks @Thefoxeur54 )
* GUI menu with some animations (Thanks @Xtas3 )
* check vehicle plate
* cops can see each other (blips : thanks @Scammer  -- https://forum.fivem.net/t/release-scammers-script-collection-09-03-17/3313)

# Current Features (lite version v1.0.1)

* Add and remove cops
* Cops can take their service in the police station
* Cops can take a break in the police station again
* When in service, cops can take/store a cop vehicle
* They can cuff (credits to @Marxy : https://forum.fivem.net/t/release-simple-cuff-script-and-example-resource/4200)
* They can force a cuffed player to enter in a vehicle

# Changelog
You can find the changelog [here](https://github.com/Kyominii/Cops_FiveM/blob/master/CHANGELOG.md)

# Contribute
if you are a developer and  would like to contribute any help is welcome!   
The contribution guide can be found [here](https://github.com/Kyominii/Cops_FiveM/blob/master/CONTRIBUTING.md).

(Readme, Contributing and Changelog files from by [FiveM Script](https://github.com/FiveM-Scripts/), thanks ^^)

# Support
* Before posting, please read if your problem was'nt resolved earlier in this thread
* If not, give me your server and client (F8) error
* If you have suggestion, please open a ticket [here](https://github.com/Kyominii/Cops_FiveM/issues/new) 

# Full-version installation

## Requirements

* Essentialmode 2.X (no download available, if you don't have es2.x, please wait this script upgrade to es3)
* es_freeroam (no download available, same that essentialmode)
* [Vdk_recolt](https://forum.fivem.net/t/release-recolt-treatment-selling-jobs-system-v1-1/15465)
* [Vdk_inventory](https://forum.fivem.net/t/release-inventory-system-v1-4/14477)
* [Simple Banking](https://forum.fivem.net/t/release-simple-banking-2-0-now-with-gui/13896)
* [JobSystem](https://forum.fivem.net/t/release-jobs-system-v1-0-and-paycheck-v2-0/14054)
* [Skin Customization](https://forum.fivem.net/t/release-skin-customization-v1-0/16491)
* [Player in db](https://forum.fivem.net/t/release-nameofplayers-v-1-get-name-of-players-in-database/17983)
* [es_weashop](https://forum.fivem.net/t/release-es-weapon-store-v1-1/12195)

## Installation

* Install requirements
* Download police folder from this [git](https://github.com/Kyominii/Cops_FiveM)
* Put this folder to resources folder in your server
* Add this piece of code in server.lua (Simple Banking)
```lua
RegisterServerEvent('bank:withdrawAmende')
AddEventHandler('bank:withdrawAmende', function(amount)
    TriggerEvent('es:getPlayerFromId', source, function(user)
        local player = user.identifier
        local bankbalance = bankBalance(player)
		withdraw(player, amount)
		local new_balance = bankBalance(player)
		TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Maze Bank", false, "New Balance: ~g~$" .. new_balance)
		TriggerClientEvent("banking:updateBalance", source, new_balance)
		TriggerClientEvent("banking:removeBalance", source, amount)
		CancelEvent()
    end)
end)
```
(it's just a copy of withdraw event but we remove give money to the player)
* Please following all this vdk_recolt modifications or use Modified Scripts package (contains inventory, harvest, banking, jobs):

   [Modification #1 : Blips per job and hidding illegal blips](https://pastebin.com/H3J4B9q8)
 
   [Modification #2 : Change name of blips](https://pastebin.com/PDtfeYDP)
 
   [Modification #3 : Add limitations](https://pastebin.com/0a91wkPh)
 
   ### OR
 
   [Modified Scripts Package](https://mega.nz/#!f5pRTBiA!LxMhNGswMfnxrD-FRcWIXVJXzOYpQSZWSfO8Ot3LUf0), don't forget to add a limitation INT NOT NULL (greater than 0) column in your items table

   [VirusTotal](https://www.virustotal.com/fr/file/bc0a20172877962af1c42018bb1202efd9021e9a8526a7dd92772ff11ba47a66/analysis/1494780846/)
   
* Add police.sql to your database
* Add police to your .yml file in AutoStartResource section

You're not force to use these requirements, you just need to adapt functions to your scripts. But I only give support with these requirements :)

# Lite-version installation

## Requirements

* Essentialmode (no download available, if you don't have es2.x, please wait this script upgrade to es3)
* es_freeroam (no download available, same that essentialmode)

## Installation

* Install requirements
* Download police-lite folder from this git
* Put this folder to resources folder in your server
* Add police.sql to your database
* Add police to your .yml file in AutoStartResource section


# Commands

Admin commands :
* /copadd (ID) : add a cop to bdd  -- lite & full version
* /coprem (ID) : remove a cop -- lite & full version

Cop commands (for lite version, in full version, see menu) :
* /check : check the player inventory (you have to be stick to him) -- full version
* /cuff : cuff a player (also stick to the player)  -- lite & full version
* /fines (ID) (Amount) : force a player to pay a fine  -- full version
* /forceEnter : make the player look at the vehicle and stick to it, cuff the player, use the command to force the player to enter in the vehicle  -- lite & full version
For forceEnter, the player MUST be close to the vehicle and look at it

# Special Thanks
* @Xtas3  for helping me to have policer uniform and GUI
* @Thefoxeur54  for helping me to have unseat feature
* The whole community of FiveM which help to improve this script by giving me example (devs) or ideas (users)
