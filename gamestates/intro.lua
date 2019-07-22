local intro = {}

function intro:init() -- Called once, and only once, before entering the state the first time
end

function intro:enter(previous) -- Called every time when entering the state
end

function intro:leave() -- Called when leaving a state.
end

function intro:resume() -- Called when re-entering a state by Gamestate.pop()
end

function intro:update(dt)
end

function intro:draw()
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
