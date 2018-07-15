--------------------------------------------------------------------------------
-- Sneaksy/Peep/StrongWizardPeep.lua
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
local WizardPeep = require "Sneaksy.Peep.WizardPeep"

local StrongWizardPeep = Class(WizardPeep)

function StrongWizardPeep:new(name)
	WizardPeep.new(self, "Mystic Wizard")

	self:setDamageRange(8, 12)
	self:setAttackCooldown(6.0)
	self:setMaxHealth(48)
end

return StrongWizardPeep
