local Director = require "Sneaksy.Director"
local Vector = require "Sneaksy.Common.Math.Vector"
local EnemyRenderer = require "Sneaksy.Renderer.EnemyRenderer"
local Renderer = require "Sneaksy.Renderer.Renderer"
local SneaksyRenderer = require "Sneaksy.Renderer.SneaksyRenderer"
local StormOfArmadylloRenderer = require "Sneaksy.Renderer.StormOfArmadylloRenderer"

local _D
function love.load()
	math.randomseed(os.time())

	_D = Director()
	do
		local p = _D:spawn(require "Sneaksy.Peep.StormOfArmadyllo")
		p:setVelocity(Vector(math.random(100, 200), math.random(100, 200)))
		p:setDampening(0)
		p:teleport(Vector(400, 300))
	end
	_D:spawn(require "Sneaksy.Peep.Sneaksy")
	do
		for i = 1, 2 do
			local p = _D:spawn(require "Sneaksy.Peep.WeakMeleePeep")
			local w, h = love.window.getMode()
			p:teleport(Vector(math.random(128, w - 128), math.random(128, h - 128)))
		end
	end

	_D:addRenderer(
		require "Sneaksy.Peep.StormOfArmadyllo",
		StormOfArmadylloRenderer())

	_D:addRenderer(
		require "Sneaksy.Peep.Sneaksy",
		SneaksyRenderer())

	_D:addRenderer(
		require "Sneaksy.Peep.WeakMeleePeep",
		EnemyRenderer({
			idle = "Resources/WeakKnight/WeakKnight.png",
			attack = "Resources/WeakKnight/WeakKnight_Attack.png"
		}))
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
