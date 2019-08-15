local moonshine = require 'lib.moonshine'

local countdown = {}

function countdown:init() -- Called once, and only once, before entering the state the first time
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

function countdown:enter(previous) -- Called every time when entering the state
	self.video:play()
end

function countdown:leave() -- Called when leaving a state.
end

function countdown:resume() -- Called when re-entering a state by Gamestate.pop()
end

function countdown:update(dt)
	if self.video:tell() > 11.5 then
		data.current_etapes = 1
		Gamestate.switch(states.game, data.etapes[1])
	end
end

function countdown:draw()
	self.effect(function()
		love.graphics.draw(self.video, 0, 0, 0, self.kx, self.ky)
	end)
end

function countdown:focus(focus)
end

function countdown:quit()
end

function countdown:keypressed(key, scancode)
end

function countdown:mousepressed(x,y, mouse_btn)
end

function countdown:joystickpressed(joystick, button )
end

return countdown
