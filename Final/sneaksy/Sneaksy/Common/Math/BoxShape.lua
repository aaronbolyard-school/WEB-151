--------------------------------------------------------------------------------
-- Sneaksy/Common/Math/BoxShape.lua
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

local BoxShape = Class(Shape)

function BoxShape:new(size)
	self.size = size or Vector(1)
end

function BoxShape:getSize()
	return self.size
end

function BoxShape:setSize(value)
	self.size = value or self.size
end

function BoxShape:getBounds()
	return self.size
end

function BoxShape:toLove()
	return love.physics.newRectangleShape(self.size.x, self.size.y)
end

function BoxShape:inside(p)
	local halfSize = self.size
	if p.x > -halfSize.x and p.x < halfSize.x and
	   p.y > -halfSize.y and p.y < halfSize.y
	then
		return true
	else
		return false
	end
end

return BoxShape
