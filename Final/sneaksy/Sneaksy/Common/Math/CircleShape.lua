--------------------------------------------------------------------------------
-- Sneaksy/Common/Math/CircleShape.lua
--
-- This file is a part of Sneaksy.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "Sneaksy.Common.Class"
local Shape = require "Sneaksy.Common.Math.Shape"
local Vector = require "Sneaksy.Common.Math.Vector"

local CircleShape = Class(Shape)

function CircleShape:new(radius)
	self.radius = radius or 0.5
end

function CircleShape:getRadius()
	return self.radius
end

function CircleShape:setRadius(value)
	self.radius = value or self.radius
end

function CircleShape:getBounds()
	return Vector(self.radius * 2, self.radius * 2)
end

function CircleShape:toLove()
	return love.physics.newCircleShape(self.radius)
end

return CircleShape
