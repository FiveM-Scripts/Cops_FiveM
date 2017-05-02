# Cops_FiveM v1.0.0
Thanks to FiveM Scripts for their help :

<a href="https://discord.gg/eNJraMf"><img alt="Discord Status" src="https://discordapp.com/api/guilds/285462938691567627/widget.png"></a>

Support Discord (Horizon) :

<a href="https://discord.gg/btQzwvt"><img alt="Discord Status" src="https://discordapp.com/api/guilds/303627262199070720/widget.png"></a>


## Description

Cops_FiveM is a script for RP server mainly. It let servers to have a cops system with loadout, vehicles, inventory check, ...

## Current Features

* Add and remove cops
* Cops can take their service in the police station
* Cops can take a break in the police station again
* When in service, cops can take/store a cop vehicle
* They can check the inventory of someone (it also remove all illegal items while checking)
* They can give fines (negative account is possible)
* They can cuff (credits to Marxy : https://forum.fivem.net/t/release-simple-cuff-script-and-example-resource/4200)
* They can force a cuffed player to enter in a vehicle

## Changelog
You can find the changelog [here](CHANGELOG.md)

## Contribute
if you are a developer and  would like to contribute any help is welcome!   
The contribution guide can be found [here](CONTRIBUTING.md).

(Readme, Contributing and Changelog files from by [FiveM Script](https://github.com/FiveM-Scripts/), thanks ^^)

## Requirements

* [Essentialmode](https://forum.fivem.net/t/release-essentialmode-base/3665)
* [Vdk_recolt](https://forum.fivem.net/t/release-recolt-treatment-selling-jobs-system-v1-1/15465)
* [Vdk_inventory](https://forum.fivem.net/t/release-inventory-system-v1-4/14477)
* [Simple Banking](https://forum.fivem.net/t/release-simple-banking-2-0-now-with-gui/13896)

## Installation

* Install requirements
* Download police folder from this git
* Put this folder to resources folder in your server
* Add police to your .yml file in AutoStartResource section

## Commands

Admin commands :
* /copadd <ID> : add a cop to bdd
* /coprem <ID> : remove a cop

Cop commands :
* /fouille : check the player inventory (you have to be stick to him)
* /cuff : cuff a player (also stick to the player)
* /amende <ID> <Amount> : force a player to pay a fine
* /forceEnter : make the player look at the vehicle and stick to it, cuff the player, use the command to force the player to enter in the vehicle 

## Bugs
Please share us your bugs by using Github's isssues system
