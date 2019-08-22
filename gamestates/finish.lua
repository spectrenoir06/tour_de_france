local finish = {}

local moonshine = require 'lib.moonshine'
local Timer = require 'lib.timer'

local lx, ly = 1080, 864

function finish:init() -- Called once, and only once, before entering the state the first time

	self.text = {}

	for k,v in ipairs(love.filesystem.getDirectoryItems("ressource/img/game/villes")) do
		self.text[v] = {}
		self.text[v].ville = love.graphics.newImage("ressource/img/game/villes/"..v.."/ville.png")
		self.text[v].pub   = love.graphics.newImage("ressource/img/game/villes/"..v.."/pub.png")
	end

	self.ville_ky = ly / self.text[data.etapes[data.current_etapes].stop].ville:getHeight() * 0.75
	-- self.pub_ky = ly / self.pub:getHeight() / 2

	self.effect = moonshine(1080,864,moonshine.effects.chromasep).chain(moonshine.effects.scanlines).chain(moonshine.effects.vignette).chain(moonshine.effects.crt)
	self.effect.chromasep.radius = 3
	self.effect.scanlines.width = 2
	self.effect.scanlines.opacity = 0.2
	self.effect.crt.distortionFactor = {1.06, 1.065}

	self.font = love.graphics.newFont("ressource/font/vintage.ttf", 60)
	self.font2 = love.graphics.newFont(40)

end

function finish:enter(previous, players) -- Called every time when entering the state
	self.msg_text  = (players[1].score < players[2].score) and "Winner Team Blue" or "Winner Team Red"
	self.msg_color = (players[1].score < players[2].score) and {0,0,1} or {1,0,0}
	print(self.msg_text)

	self.posY = ly
	self.posPub = -lx
	Timer.tween(4, self, {posY = ly/2 - (self.text[data.etapes[data.current_etapes].stop].ville:getHeight() / 2 * self.ville_ky)}, 'in-bounce')

	Timer.after(5, function()
		Timer.tween(4, self, {posPub = 0}, 'out-elastic')
	end)

	Timer.after(10, function()
		data.current_etapes = data.current_etapes + 1

		if data.current_etapes > #data.etapes then
			-- Gamestate.switch(states.intro)
		else
			Gamestate.switch(states.vs)
		end
	end)

	love.graphics.setFont(self.font)
end

function finish:leave() -- Called when leaving a state.
end

function finish:resume() -- Called when re-entering a state by Gamestate.pop()
end

function finish:update(dt)
	Timer.update(dt)
end

function finish:draw()

	love.graphics.setCanvas(screen)
	love.graphics.clear()

	self.effect(function()
		love.graphics.setColor(rgb(242, 195, 91))
		love.graphics.rectangle("fill", 0, 0, 1500, 1000)

		love.graphics.setFont(self.font)
		love.graphics.setColor(self.msg_color)
		love.graphics.print(self.msg_text, 50, self.posY)

		love.graphics.setFont(self.font2)

		local score = data.etapes[data.current_etapes].players[1].score
		local min = math.floor(score/60)
		local sec = math.floor(score%60)
		love.graphics.print(min.."min "..sec.."S", 50, self.posY + 80)

		local score = data.etapes[data.current_etapes].players[2].score
		local min = math.floor(score/60)
		local sec = math.floor(score%60)
		love.graphics.print(min.."min "..sec.."S", 50, self.posY + 80 * 2)


		love.graphics.setColor(1,1,1)
		love.graphics.draw(self.text[data.etapes[data.current_etapes].stop].ville, 400, self.posY, 0, self.ville_ky, self.ville_ky)

		love.graphics.draw(self.text[data.etapes[data.current_etapes].stop].pub, self.posPub)
		-- love.graphics.draw(self.text.pub, 0, 0, 0, self.pub_ky, self.pub_ky)
	end)

	love.graphics.setCanvas()
	local lx,ly = love.graphics.getDimensions()
	love.graphics.draw(screen,0,0,0,lx/1080,ly/864)

end

function finish:focus(focus)
end

function finish:quit()
end

function finish:keypressed(key, scancode)
end

function finish:mousepressed(x,y, mouse_btn)
end

function finish:joystickpressed(joystick, button )
end

return finish
