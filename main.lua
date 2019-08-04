Gamestate = require "lib.gamestate"

states = {}

states.intro  = require "gamestates.intro"
states.start  = require "gamestates.start"
-- states.player = require "gamestates.player"
-- states.map    = require "gamestates.map"
states.game   = require "gamestates.game"
states.finish = require "gamestates.finish"

data = {
	current_etapes = 1,
	etapes = {
		{
			start = "Lille",
			stop  = "Nante",
			size = 1000,
		},
		{
			start = "Nante",
			stop  = "Bordeaux",
			size = 1000,
		},
		{
			start = "Bordeaux",
			stop  = "Montpellier",
			size = 1000,
		},
		{
			start = "Montpellier",
			stop  = "Marseille",
			size = 1000,
		},
		{
			start = "Marseille",
			stop  = "Lyon",
			size = 1000,
		},
		{
			start = "Lyon",
			stop  = "Strasbourg",
			size = 1000,
		},
		{
			start = "Strasbourg",
			stop  = "Paris",
			size = 1000,
		},
	}
}


function rgb(r,g,b)
	return r/255, g/255, b/255
end

function love.load()
	Gamestate.registerEvents()
	Gamestate.switch(states.intro)
end
