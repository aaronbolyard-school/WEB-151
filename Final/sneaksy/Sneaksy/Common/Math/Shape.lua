--------------------------------------------------------------------------------
-- Sneaksy/Common/Math/Shape.lua
--
-- This file is a part of Sneaksy.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "Sneaksy.Common.Class"
local Vector = require "Sneaksy.Common.Math.Vector"

local Shape = Class()

function Shape:new()
	-- Nothing.
end

-- Returns the bounds of the shape.
function Shape:getBounds()
	return Vector.ZERO
end

-- Converts the Shape to a Love2D Shape.
function Shape:toLove()
	return nil
end

-- Returns true if point 'p' is within the shape, false otherwise.
--
-- 'p' is assumed to be in the shape's coordinates system.
function Shape:inside(p)
	return false
end

return Shape
