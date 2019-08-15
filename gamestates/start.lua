local start = {}

function start:init() -- Called once, and only once, before entering the state the first time
end

function start:enter(previous) -- Called every time when entering the state
end

function start:leave() -- Called when leaving a state.
end

function start:resume() -- Called when re-entering a state by Gamestate.pop()
end

function start:update(dt)
end

function start:draw()
end

function start:focus(focus)
end

function start:quit()
end



function start:keypressed(key, scancode)
end

function start:mousepressed(x,y, mouse_btn)
end

function start:joystickpressed(joystick, button)
end

return start
