resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'
resource_version '1.4.6'
resource_versionNum '146'
resource_Isdev 'no'
resource_fname 'Cops FiveM'

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
  'client/i18n.lua',
  'locales/en.lua',
  'locales/fr.lua',
  'locales/de.lua',  
  'config/config.lua',
  'server/server.lua'
}
