--------------------------------------------------------------------------------
-- Sneaksy/Peep/Drakkenson.lua
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

local Drakkenson = Class(Enemy)
Drakkenson.STATE_MELEE = 1
Drakkenson.STATE_RANGED = 2
Drakkenson.STATE_MAGIC = 3
Drakkenson.STATE_SUMMON = 4
Drakkenson.STATE_MIN = 1
Drakkenson.STATE_MAX = 4
Drakkenson.PEEPS = {
	"Sneaksy.Peep.WeakMeleePeep",
	"Sneaksy.Peep.WeakArcherPeep",
	"Sneaksy.Peep.WeakWizardPeep"
}

function Drakkenson:new(name)
	Enemy.new(self, "Drakkenson")

	self:setShape(CircleShape(64))

	self.speed = math.random(200, 250)

	self.minDamage = 10
	self.maxDamage = 15

	self.attackCooldown = 3.6
	self.currentCooldown = 0

	self:setDampening(0.9)

	self:setMaxHealth(200)
	self:setIsBoss(true)

	self:nextState()
end

function Drakkenson:nextState()
	self.state = math.random(
		Drakkenson.STATE_MIN,
		Drakkenson.STATE_MAX)
end

function Drakkenson:getDamage()
	return math.random(self.minDamage, self.maxDamage)
end

function Drakkenson:setDamageRange(min, max)
	local i = min or self.minDamage
	local j = max or self.maxDamage

	self.minDamage = math.min(i, j)
	self.maxDamage = math.max(i, j)
end

function Drakkenson:getAttackCooldown()
	return self.attackCooldown
end

function Drakkenson:setAttackCooldown(value)
	self.attackCooldown = self.attackCooldown or value
end

function Drakkenson:resurrect()
	-- can't do that.
end

function Drakkenson:update(delta)
	Enemy.update(self, delta)

	self.currentCooldown = math.max(self.currentCooldown - delta, 0)

	local target = self:findTarget()
	if target and not self:getIsDead() then
		local targetSize = target:getShape():getBounds() / 2
		local targetPosition = target:getPosition() + Vector(targetSize.x * target:getDirection() * 2, 0, 0)
		local difference = targetPosition - self:getPosition()

		local distance
		if self.state == Drakkenson.STATE_MELEE then
			distance = 2.5
		else
			distance = 4
		end

		local isInRange = difference:getLength() < self:getShape():getRadius() * distance

		if isInRange then
			if self.currentCooldown <= 0 then
				if self.state == Drakkenson.STATE_MELEE then
					target:poke('Damaged', {
						instigator = self,
						damage = self:getDamage()
					})
				elseif self.state == Drakkenson.STATE_MAGIC then
					local fireball = self:getDirector():spawn(
						require "Sneaksy.Peep.Fireball",
						self:getDamage(),
						(target:getPosition() - self:getPosition()):getNormal(),
						self:getTeam())
					fireball:teleport(self:getPosition())
				elseif self.state == Drakkenson.STATE_RANGED then
					local arrow = self:getDirector():spawn(
						require "Sneaksy.Peep.Arrow",
						self:getDamage(),
						(target:getPosition() - self:getPosition()):getNormal(),
						self:getTeam())
					arrow:teleport(self:getPosition())
				elseif self.state == Drakkenson.STATE_SUMMON then
					local peepTypeName = Drakkenson.PEEPS[math.random(1, #Drakkenson.PEEPS)]
					local peep = self:getDirector():spawn(require(peepTypeName))
					local angle = math.random() * math.pi * 2
					local offset = Vector(math.cos(angle), math.sin(angle))
					peep:teleport(self:getPosition() + offset * self:getShape():getRadius() * 1.25)
				end

				self:nextState()

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

return Drakkenson
