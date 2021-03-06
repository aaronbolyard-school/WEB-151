--------------------------------------------------------------------------------
-- Sneaksy/Peep/Fireball.lua
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

-- A fireball is a like an arrow, but it pierces enemies and disappears
-- when off the screen.
local Fireball = Class(Peep)
Fireball.SPEED = 400

function Fireball:new(damage, direction, team)
	Peep.new(self, "Fireball")

	self.damage = damage
	self:setVelocity(direction * Fireball.SPEED)

	self:setTeam(team)

	self.damaged = {}
end

function Fireball:update(delta)
	Peep.update(self, delta)

	self:move(self:getVelocity() * delta)

	local width, height = self:getDirector():getSize()

	local position = self:getPosition()

	local target = nil
	for peep in self:getDirector():near(position, 128) do
		local t1 = peep:getTeam() == Peep.TEAM_DRAKKENSON and self:getTeam() == Peep.TEAM_SNEAKSY
		local t2 = peep:getTeam() == Peep.TEAM_SNEAKSY and self:getTeam() == Peep.TEAM_DRAKKENSON
		local s = peep:getShape():inside(position - peep:getPosition())

		if (t1 or t2) and s then
			target = peep
			break
		end
	end

	if target and not self.damaged[target] then
		target:poke('Damaged', {
			instigator = self,
			damage = self.damage
		})

		self.damaged[target] = true
	end

	if position.x < 0 then
		self:getDirector():poof(self)
	end

	if position.x > width then
		self:getDirector():poof(self)
	end

	if position.y < 0 then
		self:getDirector():poof(self)
	end

	if position.y > height then
		self:getDirector():poof(self)
	end
end

return Fireball
