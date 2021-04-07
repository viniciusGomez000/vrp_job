fx_version "bodacious"
game "gta5"

ui_page "nui/index.html"

client_script {
    '@vrp/lib/utils.lua',
    "cl.lua"
}

server_script {
    '@vrp/lib/utils.lua',
    "sv.lua"
}

files {
	"nui/*"
}