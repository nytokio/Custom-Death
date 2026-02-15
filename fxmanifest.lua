fx_version 'cerulean'
game 'gta5'

author 'Star_SNG, MrKattsu'
description 'Custom death screen and revive command'
version '1.2.0'

client_scripts {
	'./client/colors.lua',
	'config.lua',
	'./client/revive_c.lua',
	'./client/respawn.lua',
	'./client/wasted_screen.lua'
}
server_script './server/revive_s.lua'

dependencies {
	'Noty'
}

