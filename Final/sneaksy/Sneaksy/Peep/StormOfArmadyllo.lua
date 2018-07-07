--------------------------------------------------------------------------------
-- Sneaksy/Peep/StormOfArmadyllo.lua
--
-- This file is a part of Sneaksy.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "Sneaksy.Common.Class"
local Vector = require "Sneaksy.Common.Math.Vector"
local CircleShape = require "Sneaksy.Common.Math.CircleShape"
local Peep = require "Sneaksy.Peep.Peep"

local StormOfArmadyllo = Class(Peep)

function StormOfArmadyllo:new()
	Peep.new(self, "Storm of Armadyllo")

	self.damage = 1

	self:setShape(CircleShape(32))
end

function StormOfArmadyllo:getDamage()
	return self.damage
end

function StormOfArmadyllo:onNotifyBeginCollision(e)
	self:setVelocity(self:getVelocity():reflect(e.normal))
	self:setAcceleration(self:getAcceleration():reflect(e.normal))
end

function StormOfArmadyllo:onSneaksySwipe(e)
	local difference = e.position - self:getPosition()
	local distance = difference:getLength()
	if distance < self:getShape():getRadius() * 6 then
		local acceleration = self:getAcceleration()
		local velocity = self:getVelocity()

		-- We only want to hit the ball if it's moving towards Sneaksy, not away.
		-- Otherwise Sneaksy can hit the ball multiple times.
		if (velocity.x < 0 and difference.x < 0) or
		   (velocity.x > 0 and difference.x > 0)
		then
			if difference.x < 0 then
				acceleration = acceleration:reflect(Vector(1, 0))
				velocity = velocity:reflect(Vector(1, 0))
			else
				acceleration = acceleration:reflect(Vector(-1, 0))
				velocity = velocity:reflect(Vector(-1, 0))
			end

			if e.normal.y < 0 then
				self:setAcceleration(acceleration:reflect(Vector(0, -1)))
				self:setVelocity(velocity:reflect(Vector(0, -1)))
			else
				self:setAcceleration(acceleration:reflect(Vector(0, -1)))
				self:setVelocity(velocity:reflect(Vector(0, -1)))
			end
		end
	end
end

function StormOfArmadyllo:update(delta)
	Peep.update(self, delta)

	local width, height = self:getDirector():getSize()

	local position = self:getPosition()
	local acceleration = self:getAcceleration()
	local velocity = self:getVelocity()

	if position.x < 0 then
		self:teleport(Vector(0, position.y))
		self:setAcceleration(acceleration:reflect(Vector(1, 0)))
		self:setVelocity(velocity:reflect(Vector(1, 0)))
		self:broadcast('NotifyBeginCollision', {
			normal = Vector(-1, 0)
		})
	end

	if position.x > width then
		self:teleport(Vector(width, position.y))
		self:setAcceleration(acceleration:reflect(Vector(-1, 0)))
		self:setVelocity(velocity:reflect(Vector(-1, 0)))
		self:broadcast('NotifyBeginCollision', {
			normal = Vector(1, 0)
		})
	end

	if position.y < 0 then
		self:teleport(Vector(position.x, 0))
		self:setAcceleration(acceleration:reflect(Vector(0, 1)))
		self:setVelocity(velocity:reflect(Vector(0, 1)))
		self:broadcast('NotifyBeginCollision', {
			normal = Vector(0, -1)
		})
	end

	if position.y > height then
		self:teleport(Vector(position.x, height))
		self:setAcceleration(acceleration:reflect(Vector(0, -1)))
		self:setVelocity(velocity:reflect(Vector(0, -1)))
		self:broadcast('NotifyBeginCollision', {
			normal = Vector(0, 1)
		})
	end
end

return StormOfArmadyllo
