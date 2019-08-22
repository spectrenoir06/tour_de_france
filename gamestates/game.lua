local moonshine	= require 'lib.moonshine'

local game = {}

local threadCode = [[
	local ffi = require'ffi'
	local sp		= require "lib/rs232"

	local serial_port = "ttyACM0"

	for k,v in ipairs(sp.ports()) do print(k,v) end

	-- Receive values sent via thread:start
	local min, max = ...

	elem_ct = ffi.typeof('char')
	buf_ct = ffi.typeof('$[?]', elem_ct)
	bufsize = 4096
	buf = buf_ct(bufsize)

	serial_start, err = sp.open(serial_port, 115200)
	if not serial_start then
		print("Can't open:", serial_port, err)
	else
		print("Open: "..serial_port)
	end

	while true do

		serial_start:read(buf, 9)
		local str = ffi.string(buf)
		-- print("serial: '"..str.."'")
		love.thread.getChannel('data'):push(str)
	end
]]

function game:init() -- Called once, and only once, before entering the state the first time

	self.text = {}

	for k,v in ipairs(love.filesystem.getDirectoryItems("ressource/img/game/villes")) do
		self.text[v] = {}
		self.text[v].panneau = love.graphics.newImage("ressource/img/game/villes/"..v.."/panneau.png")
	end

	self.text.montagne	= love.graphics.newImage("ressource/img/game/montagne.png")
	self.text.tree		= love.graphics.newImage("ressource/img/game/tree.png")

	self.text.players = {}

	for i=1,2 do
		self.text.players[i] = {
			love.graphics.newImage("ressource/img/characters/"..i.."-1.png"),
			love.graphics.newImage("ressource/img/characters/"..i.."-2.png"),
		}
	end

	self.effect = moonshine(moonshine.effects.chromasep).chain(moonshine.effects.scanlines).chain(moonshine.effects.vignette).chain(moonshine.effects.crt)
	self.effect.chromasep.radius = 3
	self.effect.scanlines.width = 2
	self.effect.scanlines.opacity = 0.2
	self.effect.crt.distortionFactor = {1.06, 1.065}

	self.font = love.graphics.newFont(20)

	self.thread = love.thread.newThread( threadCode )
	self.thread:start( 99, 1000 )

end

function game:enter(previous, etape) -- Called every time when entering the state
	print(previous, etape.start, etape.stop)
	self.map = {
		size = etape.size,
		entity = {
			{
				speed = 1,
				size = 1,
				text = "text_montagne",
				data = {},
			},
			{
				speed = 1.2,
				size = 0.8,
				text = "text_montagne",
				data = {},
			},
			{
				speed = 10,
				size = 1,
				text = "text_tree",
				data = {},
			},
		},
		background    = {242/255, 195/255, 91/255},
		text_montagne = self.text.montagne,
		text_tree     = self.text.tree,
		text_start    = self.text[etape.start].panneau,
		text_stop     = self.text[etape.stop].panneau,
	}

	for i=0, self.map.size do
		local n = love.math.noise(data.current_etapes * 1000 + i*50.1)
		if (n<0.50) then
			table.insert(self.map.entity[1].data, i*233+100)
		end
	end

	for i=0, self.map.size do
		local n = love.math.noise(data.current_etapes * 1000 + i*100.1)
		if (n<0.75) then
			table.insert(self.map.entity[2].data, i*233)
		end
	end

	for i=0, self.map.size do
		local n = love.math.noise(data.current_etapes * 1000 + i*100.1)
		if (n<0.5) then
			table.insert(self.map.entity[3].data, i*110)
		end
	end

	self.players = {
		{
			dist = 0,
			speed = 0,
			score = 0,
			texture = self.text.players[1],
			anim = 1,
		},
		{
			dist = 0,
			speed = 0,
			score = 0,
			texture = self.text.players[2],
			anim = 1,
		}
	}
	love.graphics.setFont(self.font)

	love.thread.getChannel('data'):clear()
end

function game:leave() -- Called when leaving a state.
end

function game:resume() -- Called when re-entering a state by Gamestate.pop()
end

local count = 0

function game:update(dt)
	count = count + dt
	if count > 0.2 then
		if self.players[1].speed > 0 then
			self.players[1].anim = self.players[1].anim + 1
			if self.players[1].anim > 2 then
				self.players[1].anim = 1
			end
		end
		if self.players[2].speed > 0 then
			self.players[2].anim = self.players[2].anim + 1
			if self.players[2].anim > 2 then
				self.players[2].anim = 1
			end
		end
		count = 0
	end

	if self.players[1].dist < self.map.size then
		self.players[1].dist = self.players[1].dist + dt*self.players[1].speed
		self.players[1].score = self.players[1].score + dt
	end

	if self.players[2].dist < self.map.size then
		self.players[2].dist = self.players[2].dist + dt*self.players[2].speed
		self.players[2].score = self.players[2].score + dt
	end

	if  self.players[1].dist > self.map.size
	and self.players[2].dist > self.map.size then
		data.etapes[data.current_etapes].players = self.players
		Gamestate.switch(states.finish, self.players)
	end

		-- Make sure no errors occured.
	local error = self.thread:getError()
	assert( not error, error )

	local info = love.thread.getChannel('data'):pop()
	if info then
		local p1, p2 = string.match(info, "^(%d+),(%d+)")
		-- print(info)
		if p1 and p2 then
			print(p1,p2)
			self.players[1].speed = 500--tonumber(p1)
			self.players[2].speed = 500--tonumber(p2)
		end
	end

end

function game:draw()

	love.graphics.setCanvas(screen)
	love.graphics.clear()

	self.effect(function()

		love.graphics.setColor(self.map.background)
		love.graphics.rectangle("fill", 0, 0, 1500, 1000)
		love.graphics.setColor(1,1,1)

		local off_y = {
			500,
			840
		}

		for i=1,2 do
			love.graphics.setColor(1,1,1)
			for k,v in ipairs(self.map.entity) do
				for l,m in ipairs(v.data) do
					love.graphics.draw(self.map[v.text], -self.players[i].dist * v.speed + (m - self.map[v.text]:getWidth()*v.size/2), off_y[i] - self.map[v.text]:getHeight()*v.size, 0, v.size, v.size)
				end
			end
			love.graphics.setColor(rgb(63,62,57))
			love.graphics.rectangle("fill", 0, off_y[i], 1900, 30)

			love.graphics.setColor(1,1,1)
			love.graphics.draw(self.players[i].texture[self.players[i].anim], (self.players[i].dist / self.map.size * (720 * 1.5 - self.players[i].texture[1]:getWidth()*0.08)), off_y[i] - self.players[i].texture[1]:getHeight()*0.08, 0, 0.08, 0.08)
		end
		love.graphics.draw(self.map.text_start, 0, 0, 0, 1, 1)
		love.graphics.draw(self.map.text_stop,  720*1.5-200, 0, 0, 1, 1)
	end)
	love.graphics.print(self.players[1].dist, 0, 0)
	love.graphics.print(data.etapes[data.current_etapes].start.." => "..data.etapes[data.current_etapes].stop, 0, 20)

	love.graphics.setCanvas()
	local lx,ly = love.graphics.getDimensions()
	love.graphics.draw(screen,0,0,0,lx/1080,ly/864)

end

function game:focus(focus)
end

function game:quit()
end



function game:keypressed(key, scancode)
end

function game:mousepressed(x,y, mouse_btn)
end

function game:joystickpressed(joystick, button )
end

return game
