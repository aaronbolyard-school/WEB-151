local Director = require "Sneaksy.Director"
local Waves = require "Sneaksy.Waves"
local Vector = require "Sneaksy.Common.Math.Vector"
local ArrowRenderer = require "Sneaksy.Renderer.ArrowRenderer"
local EnemyRenderer = require "Sneaksy.Renderer.EnemyRenderer"
local Renderer = require "Sneaksy.Renderer.Renderer"
local SneaksyRenderer = require "Sneaksy.Renderer.SneaksyRenderer"
local StormOfArmadylloRenderer = require "Sneaksy.Renderer.StormOfArmadylloRenderer"

local _D, _W
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

	_W = Waves(_D)
	_W:push({
		{ peep = "WeakMeleePeep", count = 1 },
	})
	_W:push({
		{ peep = "WeakMeleePeep", count = 2 }
	})
	_W:push({
		{ peep = "WeakMeleePeep", count = 2 },
		{ peep = "StrongMeleePeep", count = 1 },
	})
	_W:push({
		{ peep = "WeakMeleePeep", count = 3 },
		{ peep = "StrongMeleePeep", count = 1 },
		{ peep = "WeakArcherPeep", count = 1 },
	})
	_W:push({
		{ peep = "CowBossPeep", count = 1 },
		{ peep = "StrongMeleePeep", count = 2 },
	})
	_W:push({
		{ peep = "WeakMeleePeep", count = 1 },
		{ peep = "WeakArcherPeep", count = 1 },
	})
	_W:push({
		{ peep = "WeakMeleePeep", count = 1 },
		{ peep = "WeakArcherPeep", count = 2 },
	})
	_W:push({
		{ peep = "WeakMeleePeep", count = 1 },
		{ peep = "WeakArcherPeep", count = 2 },
		{ peep = "StrongArcherPeep", count = 1 },
	}) 

	_D:addRenderer(
		require "Sneaksy.Peep.StormOfArmadyllo",
		StormOfArmadylloRenderer())

	_D:addRenderer(
		require "Sneaksy.Peep.Sneaksy",
		SneaksyRenderer())

	_D:addRenderer(
		require "Sneaksy.Peep.Arrow",
		ArrowRenderer())

	_D:addRenderer(
		require "Sneaksy.Peep.WeakArcherPeep",
		EnemyRenderer({
			idle = "Resources/WeakArcher/WeakArcher.png",
			attack = "Resources/WeakArcher/WeakArcher_Attack.png"
		}))

	_D:addRenderer(
		require "Sneaksy.Peep.WeakMeleePeep",
		EnemyRenderer({
			idle = "Resources/WeakKnight/WeakKnight.png",
			attack = "Resources/WeakKnight/WeakKnight_Attack.png"
		}))

	_D:addRenderer(
		require "Sneaksy.Peep.StrongArcherPeep",
		EnemyRenderer({
			idle = "Resources/StrongArcher/StrongArcher.png",
			attack = "Resources/StrongArcher/StrongArcher_Attack.png"
		}))

	_D:addRenderer(
		require "Sneaksy.Peep.StrongMeleePeep",
		EnemyRenderer({
			idle = "Resources/StrongKnight/StrongKnight.png",
			attack = "Resources/StrongKnight/StrongKnight_Attack.png"
		}))

	_D:addRenderer(
		require "Sneaksy.Peep.CowBossPeep",
		EnemyRenderer({
			idle = "Resources/Cow/Cow.png",
			attack = "Resources/Cow/Cow_Attack.png"
		}))
end

function love.update(delta)
	_D:update(delta)
	_W:update(delta)
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
	_W:draw()
end
