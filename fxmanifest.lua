fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'AxTackle'
author 'SpunkyDunkie'
version '1.1.0'
description 'Enhanced and updated tackling system'

shared_scripts { '@ox_lib/init.lua', 'configs/axtackle.config.lua' }
server_script 'axtackle/server.lua'
client_script 'axtackle/client.lua'