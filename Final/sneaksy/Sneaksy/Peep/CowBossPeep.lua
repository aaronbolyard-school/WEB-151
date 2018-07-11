--------------------------------------------------------------------------------
-- Sneaksy/Peep/CowBossPeep.lua
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

local CowBossPeep = Class(MeleePeep)

function CowBossPeep:new(name)
	MeleePeep.new(self, "Super Cow")

	self:setDamageRange(12, 16)
	self:setAttackCooldown(1.8)
	self:setMaxHealth(128)

	self:setShape(CircleShape(64))
	self:setIsBoss(true)
end

return CowBossPeep
