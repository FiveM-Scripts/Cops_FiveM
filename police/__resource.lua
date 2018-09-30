resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'
resource_version 'v1.4.5'
resource_versionNum '144'
resource_Isdev 'no'

dependency 'mysql-async'

ui_page('client/html/index.html')

files({
    'client/html/index.html',
    'client/html/js/script.js',
    'client/html/css/style.css',
    'client/html/img/background.png',
    'client/html/img/arrows_upanddown.jpg',
    'client/html/fonts/SignPainter-HouseScript.ttf'
})

client_scripts {
  'client/i18n.lua',
  'locales/en.lua',
  'locales/fr.lua',
  'locales/de.lua',
  'config/cloackroom.lua',
  'config/config.lua',
  'config/objects.lua',
  'config/vehicles.lua',
  'config/weapons.lua',
  'client/client.lua',
  'client/cloackroom.lua',
  'client/menu.lua',
  'client/garage.lua',
  'client/armory.lua'
}

server_scripts {
  '@mysql-async/lib/MySQL.lua',
  'client/i18n.lua',
  'locales/en.lua',
  'locales/fr.lua',
  'locales/de.lua',  
  'config/config.lua',
  'server/server.lua'
}
