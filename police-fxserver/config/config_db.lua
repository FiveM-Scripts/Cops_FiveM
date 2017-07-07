db = {
	driver = "mysql-async",
	--[[
	* "mysql-async" : use a beta mysql library (it's in beta test so it can have some issues, please report any problem here : https://forum.fivem.net/t/beta-mysql-async-library-v0-2-0/21881)
	* "couchdb" : use db system support by essentialmode >= 3(nosql)
                All features aren't compatible with couchdb because there are a lot of dependencies and I won't upgrade others scripts to couchdb.
				You have to see with others author to upgrade their scripts to CouchDB if you want all feature compatible with CouchDB
				/!\ESSENTIALMODE IS REQUIRE IF YOU USE THIS DATABASE/!\
	]]
	
	--CouchDB credentials (if you are using couchdb ofc)
	couch_ip = "127.0.0.1",
	couch_port = 5984,
	couch_auth = "root:1202" -- "user:password"
}