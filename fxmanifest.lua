fx_version 'cerulean'
game 'gta5'

shared_scripts {
    '@es_extended/imports.lua',
    'config.lua'
}

server_script 'server.lua'

client_scripts {
    -- If you use normal NativeUI you will need to change it here
    "@NativeUILua_Reloaded/src/NativeUIReloaded.lua", 
    'client.lua'
} 