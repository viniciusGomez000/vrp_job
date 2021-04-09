fx_version "bodacious"
game "gta5"

ui_page "web/index.html"

client_script {
    '@vrp/lib/utils.lua',
    "client/*"
}

server_script {
    '@vrp/lib/utils.lua',
    "server/*"
}

files {
	"web/*"
}