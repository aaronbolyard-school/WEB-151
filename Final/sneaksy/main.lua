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
		{ peep = "WeakMeleePeep", count = 1 }
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
	_W:push({
		{ peep = "StrongMeleePeep", count = 1 },
		{ peep = "WeakArcherPeep", count = 3 },
		{ peep = "StrongArcherPeep", count = 1 },
		{ peep = "WeakWizardPeep", count = 1 },
	})
	_W:push({
		{ peep = "GoblinBossPeep", count = 1 },
		{ peep = "StrongArcherPeep", count = 2 },
	})
	_W:push({
		{ peep = "WeakWizardPeep", count = 1 },
		{ peep = "WeakMeleePeep", count = 1 },
		{ peep = "WeakArcherPeep", count = 1 },
	})
	_W:push({
		{ peep = "WeakWizardPeep", count = 2 },
		{ peep = "WeakMeleePeep", count = 1 },
		{ peep = "WeakArcherPeep", count = 1 },
	})
	_W:push({
		{ peep = "WeakWizardPeep", count = 2 },
		{ peep = "StrongWizardPeep", count = 1 },
		{ peep = "WeakMeleePeep", count = 1 },
		{ peep = "WeakArcherPeep", count = 1 },
	})
	_W:push({
		{ peep = "StrongWizardPeep", count = 2 },
		{ peep = "StrongMeleePeep", count = 2 },
		{ peep = "StrongArcherPeep", count = 2 },
	})
	_W:push({
		{ peep = "DragonBossPeep", count = 1 },
		{ peep = "StrongWizardPeep", count = 2 },
		{ peep = "StrongMeleePeep", count = 1 },
		{ peep = "StrongArcherPeep", count = 1 },
	})
	_W:push({
		{ peep = "StrongWizardPeep", count = 3 },
		{ peep = "StrongMeleePeep", count = 3 },
		{ peep = "StrongArcherPeep", count = 3 },
	})
	_W:push({
		{ peep = "StrongWizardPeep", count = 2 },
		{ peep = "StrongMeleePeep", count = 2 },
		{ peep = "StrongArcherPeep", count = 2 },
		{ peep = "WeakWizardPeep", count = 1 },
		{ peep = "WeakMeleePeep", count = 1 },
		{ peep = "WeakArcherPeep", count = 1 },
	})
	_W:push({
		{ peep = "DragonBossPeep", count = 1 },
		{ peep = "GoblinBossPeep", count = 1 },
		{ peep = "CowBossPeep", count = 1 },
	})
	_W:push({
		{ peep = "WeakWizardPeep", count = 5 },
		{ peep = "WeakMeleePeep", count = 5 },
		{ peep = "WeakArcherPeep", count = 5 },
	})
	_W:push({
		{ peep = "Drakkenson", count = 1 }
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
		require "Sneaksy.Peep.Fireball",
		ArrowRenderer({ filename = "Resources/Projectile/Fireball.png" }))

	_D:addRenderer(
		require "Sneaksy.Peep.WeakWizardPeep",
		EnemyRenderer({
			idle = "Resources/WeakWizard/WeakWizard.png",
			attack = "Resources/WeakWizard/WeakWizard_Attack.png"
		}))

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
		require "Sneaksy.Peep.StrongWizardPeep",
		EnemyRenderer({
			idle = "Resources/StrongWizard/StrongWizard.png",
			attack = "Resources/StrongWizard/StrongWizard_Attack.png"
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
		require "Sneaksy.Peep.DragonBossPeep",
		EnemyRenderer({
			idle = "Resources/Dragon/Dragon.png",
			attack = "Resources/Dragon/Dragon_Attack.png"
		}))

	_D:addRenderer(
		require "Sneaksy.Peep.GoblinBossPeep",
		EnemyRenderer({
			idle = "Resources/Goblin/Goblin.png",
			attack = "Resources/Goblin/Goblin_Attack.png"
		}))

	_D:addRenderer(
		require "Sneaksy.Peep.CowBossPeep",
		EnemyRenderer({
			idle = "Resources/Cow/Cow.png",
			attack = "Resources/Cow/Cow_Attack.png"
		}))

	_D:addRenderer(
		require "Sneaksy.Peep.Drakkenson",
		EnemyRenderer({
			idle = "Resources/Dragonkin/Dragonkin.png",
			attack = "Resources/Dragonkin/Dragonkin_Attack.png"
		}))
end

function love.update(delta)
	_D:update(delta)
	_W:update(delta)
end

function love.touchpressed(id, x, y, dx, dy)
	_D:broadcast('MousePressed', x, y, 1)
end

function love.touchreleased(id, x, y, dx, dy)
	_D:broadcast('MouseReleased', x, y, 1)
end

function love.touchmoved(id, x, y)
	_D:broadcast('MouseMoved', x, y)
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

	local sneaksy
	for peep in _D:byType(require "Sneaksy.Peep.Sneaksy") do
		sneaksy = peep
		break
	end

	if sneaksy then
		local w = love.window.getMode()

		local message
		if sneaksy.isDead and not _W.won then
			message = "GAME OVER"
		else
			message = string.format(
				"Health: %d/%d",
				sneaksy.currentHealth,
				sneaksy.maxHealth)
		end

		love.graphics.setColor(0, 0, 0, 255)
		love.graphics.printf(message, 1, 9, w, 'center')
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.printf(message, 0, 8, w, 'center')
	end
end
