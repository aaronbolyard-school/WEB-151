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

local StormOfArmadylloRenderer = Class(Renderer)
StormOfArmadylloRenderer.BOUNCE_TIME = 0.5

function StormOfArmadylloRenderer:new()
	Renderer.new(self)

	self.times = {}

	self.image = love.graphics.newImage("Resources/StormOfArmadyllo/StormOfArmadyllo.png")
end

function StormOfArmadylloRenderer:onCollision(peep)
	local t = self.times[peep]
	if not t then
		t = { life = 0, current = 0 }
		self.times[peep] = t
	end

	t.life = math.min(t.life + StormOfArmadylloRenderer.BOUNCE_TIME, StormOfArmadylloRenderer.BOUNCE_TIME * 8)
end

function StormOfArmadylloRenderer:onPeepAdded(peep)
	peep:listen('NotifyBeginCollision', self.onCollision, self, peep)
end

function StormOfArmadylloRenderer:onPeepRemoved(peep)
	peep:silence('NotifyBeginCollision', self.onCollision)
end

function StormOfArmadylloRenderer:update(delta)
	local done = {}
	for peep, t in pairs(self.times) do
		local time = t.current + delta
		if time > t.life then
			done[peep] = true
		end

		t.current = time
	end

	for peep in pairs(done) do
		self.times[peep] = nil
	end
end

function StormOfArmadylloRenderer:draw(peep)
	self:visit(peep)

	local radius = peep:getShape():getRadius()
	local position = peep:getPosition()

	local time = self.times[peep]
	if time then
		time = time.current
	else
		time = 0
	end

	local mu = time / StormOfArmadylloRenderer.BOUNCE_TIME
	local scale = math.sin(mu * math.pi * 4 + math.pi / 2) * 0.25 + 0.75
	local scaleX = (radius * 2) / self.image:getWidth() * scale
	local scaleY = (radius * 2) / self.image:getHeight() * scale

	love.graphics.draw(
		self.image,
		position.x, position.y,
		0,
		scaleX, scaleY,
		self.image:getWidth() / 2, self.image:getHeight() / 2)

	love.graphics.setColor(255, 255, 255, 255)
end

return StormOfArmadylloRenderer
