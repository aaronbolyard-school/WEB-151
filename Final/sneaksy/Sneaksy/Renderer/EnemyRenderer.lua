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
local Peep = require "Sneaksy.Peep.Peep"
local Renderer = require "Sneaksy.Renderer.Renderer"

local EnemyRenderer = Class(Renderer)
EnemyRenderer.ATTACK_DURATION = 0.25

function EnemyRenderer:new(t)
	Renderer.new(self)

	self.idleImage = love.graphics.newImage(t.idle)
	self.attackImage = love.graphics.newImage(t.attack)
	self.time = 0

	self.images = {}
	self.times = {}
end

function EnemyRenderer:onPeepAdded(peep)
	peep:listen('Attack', self.attack, self, peep)
	self.images[peep] = self.idleImage
	self.times[peep] = math.random(0, 10)
end

function EnemyRenderer:onPeepRemoved(peep)
	peep:silence('Attack', self.attack)
	self.times[peep] = nil
	self.images[peep] = nil
end

function EnemyRenderer:attack(peep)
	self.times[peep] = 0
	self.images[peep] = self.attackImage
end

function EnemyRenderer:update(delta)
	for peep, time in pairs(self.times) do
		if time > EnemyRenderer.ATTACK_DURATION then
			self.images[peep] = self.idleImage
		end

		local t = time + delta
		self.times[peep] = t
	end
end

local function lerp(from, to, delta)
	return (from - to) * (1 - delta) + to * delta
end

function EnemyRenderer:draw(peep)
	self:visit(peep)

	local position = peep:getPosition()
	local image = self.images[peep]

	local speed = peep:getVelocity():getLength()
	local angle
	local positionX, positionY = position.x, position.y - image:getHeight() / 2
	local anchorX, anchorY = image:getWidth() / 2, image:getHeight() / 2
	if speed > 1 and not peep:getIsDead() then
		local mu = self.times[peep] * math.pi * 2
		local delta = (math.sin(mu) + 1) / 2
		angle = lerp(-math.pi / 16, math.pi / 16, delta)
	elseif peep:getIsDead() then
		angle = math.pi / 2
		positionY = position.y
	else
		angle = 0
	end

	if peep:getTeam() == Peep.TEAM_SNEAKSY then
		love.graphics.setColor(255, 0, 255, 255)
	end

	love.graphics.draw(
		image,
		positionX, positionY,
		angle,
		1 * peep:getDirection(), 1,
		anchorX, anchorY)
	love.graphics.circle('line', position.x, position.y, peep:getShape():getRadius())

	love.graphics.setColor(255, 255, 255, 255)
end

return EnemyRenderer
