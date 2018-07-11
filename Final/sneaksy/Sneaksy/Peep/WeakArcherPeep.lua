--------------------------------------------------------------------------------
-- Sneaksy/Peep/WeakArcherPeep.lua
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

local WeakArcherPeep = Class(ArcherPeep)

function WeakArcherPeep:new(name)
	ArcherPeep.new(self, "Newbie Archer")

	self:setDamageRange(1, 2)
	self:setAttackCooldown(4.8)
	self:setMaxHealth(16)
end

return WeakArcherPeep
