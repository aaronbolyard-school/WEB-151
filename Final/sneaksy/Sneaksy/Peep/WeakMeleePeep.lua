--------------------------------------------------------------------------------
-- Sneaksy/Peep/WeakMeleePeep.lua
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

local WeakMeleePeep = Class(MeleePeep)

function WeakMeleePeep:new(name)
	MeleePeep.new(self, "Iron Knight")

	self:setDamageRange(1, 4)
	self:setAttackCooldown(1.6)
	self:setMaxHealth(4)
end

return WeakMeleePeep
