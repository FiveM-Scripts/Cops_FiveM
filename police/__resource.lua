resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'

client_scripts {
  'config/config.lua',
  'client/i18n.lua',
  'locales/en.lua',
  'locales/fr.lua',
  'client/client.lua',
  'client/cloackroom.lua',
  'client/menu.lua',
  'client/garage.lua',
  'client/armory.lua'
}

ui_page('client/html/index.html')

files({
    'client/html/index.html',
    'client/html/script.js',
    'client/html/style.css',
    'client/html/BebasNeue.otf',
})

server_scripts {
  '@mysql-async/lib/MySQL.lua',
  'config/config.lua',
  'server/server.lua'
}
