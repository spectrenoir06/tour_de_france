Gamestate = require "lib.gamestate"

states = {}

states.countdown	= require "gamestates.countdown"
states.start		= require "gamestates.start"
states.game			= require "gamestates.game"
states.finish		= require "gamestates.finish"
states.vs			= require "gamestates.vs"
-- states.player = require "gamestates.player"
-- states.map    = require "gamestates.map"

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
	Gamestate.switch(states.vs)
	-- data.current_etapes = 1
	-- Gamestate.switch(states.game, data.etapes[1])
end
