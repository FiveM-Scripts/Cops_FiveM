-- Manifest
resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5'

-- Requiring essentialmode
dependency 'essentialmode'

-- General
client_scripts {
  'vestpolice.lua',
  'client.lua',
  'menupolice.lua',
  'policeveh.lua',
}

server_scripts {
  'server.lua',
}

export 'getIsInService'
