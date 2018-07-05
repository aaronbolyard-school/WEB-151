local Director = require "Sneaksy.Director"
local Vector = require "Sneaksy.Common.Math.Vector"
local SneaksyRenderer = require "Sneaksy.Renderer.SneaksyRenderer"
local StormOfArmadylloRenderer = require "Sneaksy.Renderer.StormOfArmadylloRenderer"

local _D
function love.load()
	_D = Director()
	do
		local p = _D:spawn(require "Sneaksy.Peep.StormOfArmadyllo")
		p:setVelocity(Vector(math.random(100, 200), math.random(100, 200)))
		p:setDampening(0)
		p:teleport(Vector(400, 300))
	end
	_D:spawn(require "Sneaksy.Peep.Sneaksy")

	_D:addRenderer(
		require "Sneaksy.Peep.StormOfArmadyllo",
		StormOfArmadylloRenderer())

	_D:addRenderer(
		require "Sneaksy.Peep.Sneaksy",
		SneaksyRenderer())
end

function love.update(delta)
	_D:update(delta)
end

function love.mousepressed(...)
	_D:broadcast('MousePressed', ...)
end

function love.mousereleased(...)
	_D:broadcast('MouseReleased', ...)
end

function love.mousemoved(...)
	_D:broadcast('MouseMoved', ...)
end

function love.draw()
	_D:draw()
end
