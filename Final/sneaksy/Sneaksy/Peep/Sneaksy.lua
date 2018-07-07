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
end

function Sneaksy:init(...)
	Peep.init(self, ...)

	self:makeBody('kinematic')
end

function Sneaksy:update(delta)
	Peep.update(self, delta)

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

function Sneaksy:swipe(normal)
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
	else
		self:getDirector():broadcast('SneaksySwipe', {
			position = self:getPosition(),
			normal = normal
		})
	end
end

function Sneaksy:onNotifyCollision(e)
	local StormOfArmadyllo = require "Sneaksy.Peep.StormOfArmadyllo"

	if e.other:isType(StormOfArmadyllo) then
		-- Nothing.
	end
end

return Sneaksy
