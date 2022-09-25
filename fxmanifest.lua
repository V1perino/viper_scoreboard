fx_version 'cerulean'
games { 'gta5' }

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server/main.lua'
}

client_script 'client/main.lua'

ui_page 'html/scoreboard.html'

files {
	'html/scoreboard.html',
	'html/raphtalia.ttf',
	'html/style.css',
	'html/listener.js'
}