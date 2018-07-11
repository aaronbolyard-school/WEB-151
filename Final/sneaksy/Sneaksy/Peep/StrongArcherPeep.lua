--------------------------------------------------------------------------------
-- Sneaksy/Peep/StrongArcherPeep.lua
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

local StrongArcherPeep = Class(ArcherPeep)

function StrongArcherPeep:new(name)
	ArcherPeep.new(self, "Newbie Archer")

	self:setDamageRange(3, 6)
	self:setAttackCooldown(4.2)
	self:setMaxHealth(24)
end

return StrongArcherPeep
