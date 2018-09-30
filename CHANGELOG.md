## 1.4.4.2
* Added missing command `CopDept`.

## 1.4.4.2
* A fix has been provided regarding the mysql error `MySQL-async.js:209563: uncaught type error: cannot convert undefined or null object.`
* The vehicles list in the garage will only display vehicles that are assigned to the players department.

## 1.4.4.1
* Fixed a issue regarding the garage.

## 1.4.4
a lot of work has been provided under and above the hood in this update as part of our commitment to continuously improving the script.    
Please let us know if you have any issues or suggestions.    
    
To all translators, please provide us your translations so we can add them in our next update.    
    
Also we would like to give some credit to [Dex](https://github.com/dexslab) for providing us the fix to make the resource compatible with [ELS-Plus](https://github.com/friendsincode/ELS-Plus).

* Deprecated the old translation method.
* Added the feature in **config/objects.lua** to add more objects to the **Objects menu**.
* Added the feature in **config/weapons.lua** to add more weapons to the **Armory menu**.
* Added the feature in **config/cloackroom.lua** to configure models for each department.
* Added the feature in **config/vehicles.lua** to configure vehicles for each department.
* Added Spike stripes.
* Restyled the cops menu.
* Improved the update notification system.
* Various code fixes.
* Updated license to [GNU AGPL v3](LICENSE).

## 1.4.3
* Added i18n.
* Added new command /copdept **ID** **DepartmentID**, this will limit the player to only one skin.
* Added armory marker at each police station.

## 1.4.2 (08/01/2018)
* Added auto table creation to reduce installation issues.
* Added the option to enable or disable the blips for police stations.
* Allow two players forced into one vehicle

## 1.4.1 (12/06/2017)
* Add CopAddAdmin, CopAdd, CopRem and CopRank rcon command
* Warning message when performing copadd/coprem when whitelist is disabled
* Add version notifier
* Add suggestion commands
* Fix : Cloackroom isn't working with no record in db (whitelist disable)

## 1.4.0 (09/23/2017)
* Add ranks
* Add chat police rank
* Add parameter in menu system
* Add bindings in config file
* Remove essentialmode requirement
* Remove CouchDb support
* Remove cfx-server version support
* Fix : Disconnection won't change the job id
* Fix : Heading for police vehicles
* Fix : parachute isn't working
* Fix : Disconnect player stuck to cop when dragged

## 1.3.0 (07/07/2017)
* FXServer compatibility (drop mysql support on FXServer version)
* New en translation (thanks BCTB and BritishBrotherhood) and de translation (thanks SyfuxX)
* Add armory
* New menu (Web UI, thanks BritishBrotherhood)
* Multi location support
* Add blips to stations location
* Add cancel emote and confiscate weapons (thanks BritishBrotherhood)
* Add props spawner
* NPC stop near props (thanks Frazzle and BritishBrotherhood)
* Add flashlight on weapons
* Remove weapons in cops vehicles (thanks Valderg)
* Fix : unable to cuff/drag cops
* Fix : player stay attached to cop after death (drag)
* Fix : Person can run while cuffed after stunned
* Some little things

## 1.2.0 (06/05/2017)
* mysql-async support
* couchdb support
* emergency support
* gc-identity support
* add custom fines
* add two new mode for your service
* accept and refuse fines
* drag players
* lot of bugfixes
* others things I probably forgot ^^'

## 1.1.0 (05/14/2017)
* Delete personal weapons in service then restore it
* Job_system link
* Female model support
* Boost cop vehicle
* Checkplate
* Helicpoter
* Unseat
* GUI
* Cops can see each other (blips)
* Fix inventory check

## 1.0.1
* Fix 1 bullet per weapon
* Fix keep weapons when stop work as cop
* Keep skin and only change clothes when take or stop service (thanks Xtas3)

## 1.0.0
* Original files added
