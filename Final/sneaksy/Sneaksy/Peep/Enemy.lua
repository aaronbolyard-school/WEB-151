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
local Shape = require "Sneaksy.Common.Math.Shape"
local Peep = require "Sneaksy.Peep.Peep"

local Enemy = Class(Peep)
Enemy.DRAIN_RATE = 0.5

function Enemy:new(name)
	Peep.new(self, name)

	self:setTeam(Peep.TEAM_DRAKKENSON)

	self.maxHealth = 1
	self.currentHealth = 1
	self.isResurrected = false
	self.targetTeam = Peep.TEAM_SNEAKSY

	self.isBoss = false

	self.tick = 0
end

function Enemy:getIsBoss()
	return self.isBoss
end

function Enemy:setIsBoss(value)
	self.isBoss = value or false
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

	if e.other:isType(StormOfArmadyllo) and
	   self:getTeam() == Peep.TEAM_DRAKKENSON
	then
		self:damage(e.other:getDamage())
		self:broadcast('Damaged')
	end
end

function Enemy:onDamaged(e)
	self:damage(e.damage)
end

function Enemy:damage(value)
	value = math.floor(value or 0)

	if self.currentHealth > 0 then
		self.currentHealth = math.floor(math.max(self.currentHealth - value, 0))

		if self.currentHealth == 0 then
			self:killed()
			self:getDirector():broadcast('Killed', { peep = self })
			self:broadcast('Killed')
		end
	end
end

function Enemy:onResurrect(e)
	if self:getIsDead() then
		self:resurrect()
	end
end

function Enemy:resurrect()
	self.targetTeam = Peep.TEAM_DRAKKENSON
	self:setTeam(Peep.TEAM_SNEAKSY)

	self.maxHealth = self.maxHealth * 1.5
	self.currentHealth = self.maxHealth

	self:broadcast('Resurrected', {})

	self.isResurrected = true
end

function Enemy:killed()
	if self:getTeam() == Peep.TEAM_SNEAKSY then
		self:getDirector():poof(self)
	end

	self:setAcceleration(Vector(0))
	self:setVelocity(Vector(0))
end

function Enemy:findTarget()
	local target
	if self.targetTeam == Peep.TEAM_SNEAKSY then
		local Sneaksy = require "Sneaksy.Peep.Sneaksy"
		for peep in self:getDirector():byType(Sneaksy) do
			target = peep
			break
		end
	end

	if target and self.isBoss and self:getTeam() == Peep.TEAM_DRAKKENSON then
		return target
	end

	local distance
	if target then
		distance = Vector.getLength(target:getPosition() - self:getPosition())
	else
		distance = math.huge
	end

	for peep in self:getDirector():byTeam(self.targetTeam) do
		local d = Vector.getLength(peep:getPosition() - self:getPosition())
		if d < distance and peep:isCompatibleType(Enemy) and not peep:getIsDead() then
			target = peep
		end
	end

	return target
end

function Enemy:update(delta)
	Peep.update(self, delta)

	if self.isResurrected then
		if self.tick > Enemy.DRAIN_RATE then
			self:damage(1)
			self.tick = 0
		end

		self.tick = self.tick + delta
	end
end

return Enemy
