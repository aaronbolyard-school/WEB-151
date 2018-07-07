--------------------------------------------------------------------------------
-- Sneaksy/Peep/MeleePeep.lua
--
-- This file is a part of Sneaksy.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "Sneaksy.Common.Class"
local CircleShape = require "Sneaksy.Common.Math.CircleShape"
local Vector = require "Sneaksy.Common.Math.Vector"
local Peep = require "Sneaksy.Peep.Peep"
local Enemy = require "Sneaksy.Peep.Enemy"

local MeleePeep = Class(Enemy)

function MeleePeep:new(name)
	Enemy.new(self, name)

	self:setShape(CircleShape(32))

	self.speed = math.random(50, 100)

	self.minDamage = 1
	self.maxDamage = 1

	self.attackCooldown = 1
	self.currentCooldown = 0

	self:setDampening(0.5)
end

function MeleePeep:getDamage()
	return math.random(self.minDamage, self.maxDamage)
end

function MeleePeep:getDamageRange()
	return self.minDamage, self.maxDamage
end

function MeleePeep:setDamageRange(min, max)
	local i = min or self.minDamage
	local j = max or self.maxDamage

	self.minDamage = math.min(i, j)
	self.maxDamage = math.max(i, j)
end

function MeleePeep:getAttackCooldown()
	return self.attackCooldown
end

function MeleePeep:setAttackCooldown(value)
	self.attackCooldown = self.attackCooldown or value
end

function MeleePeep:resurrect()
	Enemy.resurrect(self)
	self.attackCooldown = 0
end

function MeleePeep:update(delta)
	Enemy.update(self, delta)

	self.currentCooldown = math.max(self.currentCooldown - delta, 0)

	local target = self:findTarget()
	if target and not self:getIsDead() then
		local targetSize = target:getShape():getBounds() / 2
		local targetPosition = target:getPosition() + Vector(targetSize.x * target:getDirection() * 2, 0, 0)
		local difference = targetPosition - self:getPosition()

		if math.abs(difference.x) < targetSize.x + self:getShape():getRadius() * 1.5 and
		   math.abs(difference.y) < targetSize.y
		then
			if self.currentCooldown <= 0 then
				target:poke('Damaged', {
					instigator = self,
					damage = self:getDamage()
				})

				self:broadcast('Attack', {})

				self.currentCooldown = self.attackCooldown

				if difference.x < -1 then
					self:setDirection(Peep.DIRECTION_LEFT)
				elseif difference.x > 1 then
					self:setDirection(Peep.DIRECTION_RIGHT)
				end
			end

			self:setVelocity(Vector(0))
		else
			self:setVelocity(self.speed * difference:getNormal())
		end
	end
end

return MeleePeep
