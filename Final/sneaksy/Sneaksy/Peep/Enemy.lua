--------------------------------------------------------------------------------
-- Sneaksy/Peep/Enemy.lua
--
-- This file is a part of Sneaksy.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "Sneaksy.Common.Class"
local Vector = require "Sneaksy.Common.Math.Vector"
local Peep = require "Sneaksy.Peep.Peep"

local Enemy = Class(Peep)

function Enemy:new(name)
	Peep.new(self, name)

	self.maxHealth = 1
	self.currentHealth = 1
	self.isResurrected = false
end

function Enemy:setMaxHealth(value)
	if self.currentHealth == self.maxHealth then
		self.currentHealth = value or self.currentHealth
	end

	self.maxHealth = value or self.maxHealth
end

function Enemy:getMaxHealth()
	return self.maxHealth
end

function Enemy:getCurrentHealth()
	return self.currentHealth
end

function Enemy:getIsDead()
	return self.currentHealth <= 0
end

function Enemy:onNotifyBeginCollision(e)
	local StormOfArmadyllo = require "Sneaksy.Peep.StormOfArmadyllo"

	if e.other:isType(StormOfArmadyllo) then
		self:damage(e.other:getDamage())
		self:broadcast('Damaged')
	end
end

function Enemy:damage(value)
	value = math.floor(value or 0)

	if self.currentHealth > 0 then
		self.currentHealth = math.floor(math.max(self.currentHealth - value, 0))

		if self.currentHealth == 0 then
			self:killed()
			self:broadcast('Killed', {})
		end
	end
end

function Enemy:onResurrect(e)
	if self:getIsDead() then
		self:resurrect()
	end
end

function Enemy:resurrect()
	self:getDirector():poof(self)
end

function Enemy:killed()
	self:setAcceleration(Vector(0))
	self:setVelocity(Vector(0))
end

-- Poof!
function Enemy:onWaveFinished()
	self:getDirector():poof(self)
end

return Enemy
