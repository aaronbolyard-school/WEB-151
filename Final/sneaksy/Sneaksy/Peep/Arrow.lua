--------------------------------------------------------------------------------
-- Sneaksy/Peep/Arrow.lua
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

-- An arrow does ranged damage; it keeps going until it hits an enemy.
local Arrow = Class(Peep)
Arrow.SPEED = 100

function Arrow:new(damage, direction, team)
	Peep.new(self, "Arrow")

	self.damage = damage
	self:setVelocity(direction * Arrow.SPEED)

	self:setTeam(team)
end

function Arrow:update(delta)
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

	if target then
		target:poke('Damaged', {
			instigator = self,
			damage = self.damage
		})

		self:getDirector():poof(self)
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

return Arrow
