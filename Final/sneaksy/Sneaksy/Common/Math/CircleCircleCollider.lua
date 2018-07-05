--------------------------------------------------------------------------------
-- Sneaksy/Common/Math/CircleCircleCollider.lua
--
-- This file is a part of Sneaksy.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "Sneaksy.Common.Class"
local CircleShape = require "Sneaksy.Common.Math.CircleShape"
local CircleShape = require "Sneaksy.Common.Math.CircleShape"
local Collider = require "Sneaksy.Common.Math.Collider"
local Vector = require "Sneaksy.Common.Math.Vector"

local CircleCircleCollider = Class(Collider)

function CircleCircleCollider:new()
	Collider.new(self)
end

function CircleCircleCollider:check(a, i, b, j)
	local distance = (i - j):getLength()
	if distance < a:getRadius() or distance < b:getRadius() then
		-- We just want a good point, so choose the one that is along
		-- the direction of either a to b or b to a.
		local point
		if a:getRadius() < b:getRadius() then
			local direction = Vector.getNormal(j - i)
			point = j - direction * b:getRadius()
		else
			local direction = Vector.getNormal(i - j)
			point = i - direction * a:getRadius()
		end

		return true, point
	end

	return false
end

return CircleCircleCollider
