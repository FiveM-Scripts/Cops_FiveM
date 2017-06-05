-- Manifest
resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5'

-- General
client_scripts {
  'config.lua',
  'client.lua',
  'vestpolice.lua',
  'menupolice.lua',
  'policeveh.lua',
}

server_scripts {
  'config.lua',
  'config_db.lua',
  'server.lua',
}

export 'getIsInService'
