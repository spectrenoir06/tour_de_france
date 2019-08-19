local moonshine = require 'lib.moonshine'
local Timer = require 'lib.timer'

local vs = {}

local dx, dy = love.graphics.getDimensions()

function vs:init() -- Called once, and only once, before entering the state the first time


	self.text_1 = love.graphics.newImage("ressource/img/game/VS 1.png")
	self.text_2 = love.graphics.newImage("ressource/img/game/VS 2.png")

	self.effect = moonshine(moonshine.effects.chromasep).chain(moonshine.effects.scanlines).chain(moonshine.effects.vignette).chain(moonshine.effects.crt)
	self.effect.chromasep.radius = 3
	self.effect.scanlines.width = 2
	self.effect.scanlines.opacity = 0.2
	self.effect.crt.distortionFactor = {1.06, 1.065}

	self.font = love.graphics.newFont("ressource/font/vintage.ttf", 60)
end

function vs:enter(previous) -- Called every time when entering the state
	self.pos = 0
	love.graphics.setFont(self.font)
	Timer.tween(1, self, {pos = 540}, 'in-bounce')
end

function vs:leave() -- Called when leaving a state.
end

function vs:resume() -- Called when re-entering a state by Gamestate.pop()
end

function vs:update(dt)
	Timer.update(dt)
end

function vs:draw()
	love.graphics.setColor(1,1,1)
	love.graphics.draw(self.text_1, -540 + self.pos, 0)
	love.graphics.draw(self.text_2, 1080 - self.pos, 0)
	love.graphics.print("VS", dx/2-70, dy/2-60)
end

function vs:focus(focus)
end

function vs:quit()
end

function vs:keypressed(key, scancode)
	if key == "space" then
		Gamestate.switch(states.countdown)
	end
end

function vs:mousepressed(x,y, mouse_btn)
end

function vs:joystickpressed(joystick, button )
end

return vs
