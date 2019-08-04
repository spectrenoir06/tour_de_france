local moonshine = require 'lib.moonshine'

local intro = {}

function intro:init() -- Called once, and only once, before entering the state the first time
	self.video = love.graphics.newVideo("ressource/video/countdown.ogv", { audio = true})

	local dx, dy = love.graphics.getDimensions()

	self.kx = dx / self.video:getWidth()
	self.ky = dy / self.video:getHeight()

	self.effect = moonshine(moonshine.effects.chromasep).chain(moonshine.effects.scanlines).chain(moonshine.effects.vignette).chain(moonshine.effects.crt)
	self.effect.chromasep.radius = 3
	self.effect.scanlines.width = 2
	self.effect.scanlines.opacity = 0.2
	self.effect.crt.distortionFactor = {1.06, 1.065}
end

function intro:enter(previous) -- Called every time when entering the state
	self.video:play()
end

function intro:leave() -- Called when leaving a state.
end

function intro:resume() -- Called when re-entering a state by Gamestate.pop()
end

function intro:update(dt)
	if self.video:tell() > 11.5 then
		data.current_etapes = 1
		Gamestate.switch(states.game, data.etapes[1])
	end
end

function intro:draw()
	self.effect(function()
		love.graphics.draw(self.video, 0, 0, 0, self.kx, self.ky)
	end)
end

function intro:focus(focus)
end

function intro:quit()
end

function intro:keypressed(key, scancode)
end

function intro:mousepressed(x,y, mouse_btn)
end

function intro:joystickpressed(joystick, button )
end

return intro
