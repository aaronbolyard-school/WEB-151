--------------------------------------------------------------------------------
-- Sneaksy/Renderer/Renderer.lua
--
-- This file is a part of Sneaksy.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "Sneaksy.Common.Class"
local Renderer = require "Sneaksy.Renderer.Renderer"

local SneaksyRenderer = Class(Renderer)
SneaksyRenderer.SWIPE_DURATION = 0.25

function SneaksyRenderer:new()
	Renderer.new(self)

	self.image = love.graphics.newImage("Resources/Sneaksy/Sneaksy.png")
	self.swipeUp = love.graphics.newImage("Resources/Sneaksy/Sneaksy_SwipeUp.png")
	self.swipeDown = love.graphics.newImage("Resources/Sneaksy/Sneaksy_SwipeDown.png")
	self.time = 0

	self.currentImage = self.image
	self.currentImageTime = 0
end

function SneaksyRenderer:onPeepAdded(peep)
	peep:listen('SneaksySwipe', self.swipe, self, peep)
end

function SneaksyRenderer:onPeepRemoved(peep)
	peep:silence('SneaksySwipe', self.swipe)
end

function SneaksyRenderer:swipe(peep, e)
	if e.normal.y < 0 then
		self.currentImage = self.swipeDown
	else
		self.currentImage = self.swipeUp
	end

	self.currentImageTime = 0
end

function SneaksyRenderer:update(delta)
	self.time = self.time + delta

	if self.currentImageTime > SneaksyRenderer.SWIPE_DURATION
	   and self.currentImage ~= self.image
	then
		self.currentImageTime = 0
		self.currentImage = self.image
	else
		self.currentImageTime = self.currentImageTime + delta
	end
end

local function lerp(from, to, delta)
	return (from - to) * (1 - delta) + to * delta
end

function SneaksyRenderer:draw(peep)
	self:visit(peep)

	local velocityDelta = 1 - math.max(peep:getVelocity():getLength(), 8) / 8
	local angle = self.time * math.pi * 2
	local scaleY = (math.sin(angle) + 1) / 2

	local position = peep:getPosition()

	love.graphics.draw(
		self.currentImage,
		position.x, position.y + self.currentImage:getHeight() / 2,
		lerp(-math.pi / 16, math.pi / 16, scaleY),
		1 * peep:getDirection(), 1,
		self.currentImage:getWidth() / 2, self.currentImage:getHeight())
end

return SneaksyRenderer
