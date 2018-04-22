# Cops_FiveM
[![GitHub release](https://img.shields.io/github/release/Fivem-Scripts/Cops_FiveM.svg)](https://github.com/FiveM-Scripts/Cops_FiveM/releases/latest)
[![GitHub license](https://img.shields.io/github/license/FiveM-Scripts/Cops_FiveM.svg)](https://github.com/FiveM-Scripts/Cops_FiveM/blob/master/LICENSE)

Cops_FiveM is a script for RP server mainly. It let servers to have a cops system with loadout, vehicles, inventory check, ...    
You can find the complete list with all the features [here](docs/features.md).

## Changelog
You can find the changelog [here](CHANGELOG.md).

## Community Support
A Discord server is available: [![](https://discordapp.com/api/guilds/361144123681538060/widget.png)](https://discord.gg/CecEKsz)

## Requirements
- [Mysql](https://dev.mysql.com/downloads/mysql/)
- [Mysql-Async](https://forum.fivem.net/t/beta-mysql-async-library-v0-2-2/21881)

## Installation
1. Verify that you have installed the requirements from above.
2. Download the latest version from the [GitHub repository](https://github.com/FiveM-Scripts/Cops_FiveM/releases/latest).    
3. Only copy the subdirectory *police* to the *resources* folder on your server.    
4. Edit [config file](https://github.com/FiveM-Scripts/Cops_FiveM/blob/master/police/config/config.lua) as you want.    
5. Add *start police* in your server.cfg (make sure you start this resource after all dependencies).
6. The first time when you enter the game you will need to add yourself to the police database.    
you can do this in your server console enter **CopAddAdmin 1** press enter and you should receive a confirmation message.
7. Select your prefered department after you are added as a cop with the chat command **/copdept**, for example `/copdept 1 2` check below sections for more info regarding the commands and departments.

### Important
When you restart your server you will see a mysql error inside your server console.
```
[ERROR] [MySQL] An error happens on MySQL for query "ALTER TABLE police ADD dept int(11) NOT NULL DEFAULT '0' {=}": Duplicate column name 'dept'
```
This is just confirmation that the database column already exists.

## Commands
* /copadd ID : Add the player as cop to the database.
* /coprem ID : Remove a player from the database.
* /coprank ID Rank : To change the rank of a police officer.
* /copdept ID Department : Add a player to a specific department id.    

**You can also use these commands with RCON (`CopAdd` / `CopAddAdmin` / `CopRem` / `CopRank`).    
To see how to use them, just type the command you want without any parameter.**    

## Departments
| ID | Name |
| -- | ---- |
| 0  | Park Rangers |
| 1  | Los Santos Police Department|
| 2  | Sheriff's Department |
| 3  | State Highway Patrol |
| 4  | Prison Department|

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
