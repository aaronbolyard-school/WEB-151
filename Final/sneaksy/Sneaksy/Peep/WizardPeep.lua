--------------------------------------------------------------------------------
-- Sneaksy/Peep/WizardPeep.lua
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

local WizardPeep = Class(Enemy)

function WizardPeep:new(name)
	Enemy.new(self, name)

	self:setShape(CircleShape(32))

	self.speed = math.random(50, 100)

	self.minDamage = 1
	self.maxDamage = 1

	self.attackCooldown = 1
	self.currentCooldown = 0

	self.range = 200

	self:setDampening(0.5)
end

function WizardPeep:getDamage()
	return math.random(self.minDamage, self.maxDamage)
end

function WizardPeep:getDamageRange()
	return self.minDamage, self.maxDamage
end

function WizardPeep:setDamageRange(min, max)
	local i = min or self.minDamage
	local j = max or self.maxDamage

	self.minDamage = math.min(i, j)
	self.maxDamage = math.max(i, j)
end

function WizardPeep:getAttackCooldown()
	return self.attackCooldown
end

function WizardPeep:setAttackCooldown(value)
	self.attackCooldown = self.attackCooldown or value
end

function WizardPeep:getRange()
	return self.range
end

function WizardPeep:setRange(value)
	self.range = value or self.range
end

function WizardPeep:getSpeed()
	return self.speed
end

function WizardPeep:setSpeed(value)
	self.speed = value
end

function WizardPeep:update(delta)
	Enemy.update(self, delta)

	self.currentCooldown = math.max(self.currentCooldown - delta, 0)

	local target = self:findTarget()
	if target and not self:getIsDead() then
		local targetSize = target:getShape():getBounds() / 2
		local targetPosition = target:getPosition() + Vector(targetSize.x * target:getDirection() * 2, 0, 0)
		local difference = targetPosition - self:getPosition()

		local isInRange
		if target:isType(require "Sneaksy.Peep.Sneaksy") then
			local dx = math.abs(difference.x) < targetSize.x + self.range
			local dy = difference.y < targetSize.y
			isInRange = dx and dy
		else
			isInRange = difference:getLength() < self.range
		end

		if isInRange then
			if self.currentCooldown <= 0 then
				local arrow = self:getDirector():spawn(
					require "Sneaksy.Peep.Fireball",
					self:getDamage(),
					(target:getPosition() - self:getPosition()):getNormal(),
					self:getTeam())
				arrow:teleport(self:getPosition())

				self:broadcast('Attack', {})

				self.currentCooldown = self.attackCooldown

				if difference.x < -10 then
					self:setDirection(Peep.DIRECTION_LEFT)
				elseif difference.x > 10 then
					self:setDirection(Peep.DIRECTION_RIGHT)
				end
			end

			self:setVelocity(Vector(0))
		else
			self:setVelocity(self.speed * difference:getNormal())
		end
	else
		self:setVelocity(Vector(0))
	end
end

return WizardPeep
