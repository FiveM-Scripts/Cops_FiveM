db = {
	driver = "couchdb",
	--[[
	* "mysql" : use classic mysql library (not recommended, this version break your server with errors related to "DataReader" or "connection not open" )
	* "mysql-async" : use a beta mysql library (it's in beta test so it can have some issues, please report any problem here : https://forum.fivem.net/t/beta-mysql-async-library-v0-2-0/21881)
	* "couchdb" : use db system support by essentialmode >= 3(nosql)
                Note : this script is supporting couchdb in standalone mode.
                All features aren't compatible with couchdb because there are a lot of dependencies and I won't upgrade others scripts to couchdb.
				You have to see with others author to upgrade their scripts to CouchDB if you want all feature compatible with CouchDB
	]]
	
	--SQL's credentials (only for mysql)
	sql_host = "127.0.0.1",
	sql_database = "gta5_gamemode_essential",
	sql_user = "root",
	sql_password = "toor",
	
	--CouchDB credentials
	couch_ip = "127.0.0.1",
	couch_port = 5984,
	couch_auth = "root:1202" -- "user:password"
}