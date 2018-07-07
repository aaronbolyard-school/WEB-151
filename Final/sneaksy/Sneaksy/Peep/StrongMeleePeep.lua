--------------------------------------------------------------------------------
-- Sneaksy/Peep/StrongMeleePeep.lua
--
-- This file is a part of Sneaksy.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "Sneaksy.Common.Class"
local CircleShape = require "Sneaksy.Common.Math.CircleShape"
local Peep = require "Sneaksy.Peep.Peep"
local MeleePeep = require "Sneaksy.Peep.MeleePeep"

local StrongMeleePeep = Class(MeleePeep)

function StrongMeleePeep:new(name)
	MeleePeep.new(self, "Itsy Knight")

	self:setDamageRange(2, 7)
	self:setAttackCooldown(2.4)
	self:setMaxHealth(96)
end

function StrongMeleePeep:damage(value)
	print("Strong Knight damaged", value)

	MeleePeep.damage(self, value)
end

return StrongMeleePeep
