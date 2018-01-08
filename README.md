# Cops_FiveM (Beta)
[![Version](https://img.shields.io/badge/Version-v1.4.2-brightgreen.svg)](https://github.com/Kyominii/Cops_FiveM/releases/tag/v1.4.1)

Cops_FiveM is a script for RP server mainly. It let servers to have a cops system with loadout, vehicles, inventory check, ...    
You can find the complete list with all the features [here](docs/features.md).

## Changelog
You can find the changelog [here](https://github.com/FiveM-Scripts/Cops_FiveM/blob/master/CHANGELOG.md).

## Community Support
A Discord server is available: [![](https://discordapp.com/api/guilds/361144123681538060/widget.png)](https://discord.gg/yBtN2bc)

## Requirements
- [Mysql](https://dev.mysql.com/downloads/mysql/)
- [Mysql-Async](https://forum.fivem.net/t/beta-mysql-async-library-v0-2-2/21881)

## Installation
1. Download the latest version from the [GitHub repository](https://github.com/FiveM-Scripts/Cops_FiveM/releases/latest).    
2. Put the `police` folder in the resources folder on your server.    
3. Edit [config file](https://github.com/FiveM-Scripts/Cops_FiveM/blob/master/police/config/config.lua) as you want.    
4. Add "start police" in your server.cfg (make sure you start this resource after all dependencies).

## Commands 
**You need to add a rank for each cop, configure the `minRankSetRank` in the config file.** 

* /copadd ID : to add a policeman in the database.
* /coprem ID : to remove a policeman from the database.
* /coprank ID Rank : To change the rank of a police officer.

**You can also use RCON commands (`CopAdd` / `CopAddAdmin` / `CopRem` / `CopRank`). To see how to use them, just type the command you want without any parameter**

## Ranks
| ID | Name |
| -- | ---- |
| 0  | Trainee|
| 1  | Trooper|
| 2  | Master Police Officer|
| 3  | Sergeant|
| 4  | Lieutenant|
| 5  | Captain|
| 6  | Chief of Police|
| 7  | Admin Police Rank|

## Contribute
If you are a developer and  would like to contribute any help is welcome!.   
The contribution guide can be found [here](https://github.com/Kyominii/Cops_FiveM/blob/master/CONTRIBUTING.md).
(Readme, Contributing and Changelog files from by [FiveM Script](https://github.com/FiveM-Scripts/), thanks ^^).

## Supported Scripts
you can find some supported scripts [here](docs/scripts.md).    

### Thanks to the whole community of FiveM which help to improve this script
