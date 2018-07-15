--------------------------------------------------------------------------------
-- Sneaksy/Peep/GoblinBossPeep.lua
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
local ArcherPeep = require "Sneaksy.Peep.ArcherPeep"

local GoblinBossPeep = Class(ArcherPeep)

function GoblinBossPeep:new(name)
	ArcherPeep.new(self, "Goblin")

	self:setDamageRange(14, 18)
	self:setAttackCooldown(2.4)
	self:setMaxHealth(160)

	self:setShape(CircleShape(64))
	self:setIsBoss(true)
end

return GoblinBossPeep
