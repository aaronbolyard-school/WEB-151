--------------------------------------------------------------------------------
-- Sneaksy/Peep/Sneaksy.lua
--
-- This file is a part of Sneaksy.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "Sneaksy.Common.Class"
local Vector = require "Sneaksy.Common.Math.Vector"
local BoxShape = require "Sneaksy.Common.Math.BoxShape"
local Peep = require "Sneaksy.Peep.Peep"

local Sneaksy = Class(Peep)

function Sneaksy:new()
	Peep.new(self, "Sneaksy")

	self:setShape(BoxShape(Vector(96, 192)))
	self:teleport(Vector(48, 96))

	self.isDragging = false
	self.startDragX = 0
	self.startDragY = 0

	self:setTeam(Peep.TEAM_SNEAKSY)

	self.currentHealth = 200
	self.maxHealth = 200
	self.isDead = false
end

function Sneaksy:init(...)
	Peep.init(self, ...)

	self:makeBody('kinematic')
end

function Sneaksy:update(delta)
	Peep.update(self, delta)

	-- Only move if alive.
	if not self.isDead then
		local StormOfArmadyllo = require "Sneaksy.Peep.StormOfArmadyllo"
		local stormOfArmadyllo
		for peep in self:getDirector():byType(StormOfArmadyllo) do
			stormOfArmadyllo = peep
			break
		end

		if stormOfArmadyllo then
			local distanceY = stormOfArmadyllo:getPosition().y - self.position.y
			self:setVelocity(Vector(0, distanceY / 32 * stormOfArmadyllo:getVelocity():getLength()))
		end
	end
end

function Sneaksy:onMousePressed(x, y, button)
	if button == 1 then
		self.isDragging = true
		self.startDragX = x
		self.startDragY = y

		 self:getDirector():broadcastNear(
			Vector(x, y),
			128,
			'Resurrect',
			{})
	end
end

function Sneaksy:onMouseReleased(x, y, button)
	if button == 1 and self.isDragging then
		local s = Vector(self.startDragX, self.startDragY)
		local t = Vector(x, y)
		local normal = (t - s):getNormal()
		self:swipe(normal)
	end
end

function Sneaksy:onDamaged(e)
	self.currentHealth = self.currentHealth - e.damage
	self.currentHealth = math.max(self.currentHealth, 0)

	if self.currentHealth < 1 then
		self.isDead = true
	end
end

function Sneaksy:swipe(normal)
	-- Teleport across the arena if mostly vertical (+/- ~20? degrees)
	if math.abs(normal.y) < 0.25 then
		local width = self:getShape():getSize().x
		local arenaWidth = self:getDirector():getSize()
		local position = self:getPosition()
		if normal.x > 0 then
			self:teleport(Vector(arenaWidth - width / 2, position.y))
			self:setDirection(Peep.DIRECTION_LEFT)
		else
			self:teleport(Vector(width / 2, position.y))
			self:setDirection(Peep.DIRECTION_RIGHT)
		end

		self:broadcast('Teleport', {})
	-- Otherwise, swipe.
	else
		self:getDirector():broadcast('SneaksySwipe', {
			position = self:getPosition(),
			normal = normal
		})
	end
end

function Sneaksy:onNotifyBeginCollision(e)
	local StormOfArmadyllo = require "Sneaksy.Peep.StormOfArmadyllo"

	-- Heal if not swiped. The ball will bounce based on the normal, instead
	-- of based on user specified input.
	if e.other:isType(StormOfArmadyllo) and not self.isDead then
		self.currentHealth = self.currentHealth + math.floor(e.other:getDamage() / 2)
		self.currentHealth = math.min(self.currentHealth, self.maxHealth)
	end
end

return Sneaksy
