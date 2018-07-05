--------------------------------------------------------------------------------
-- Sneaksy/Common/Math/Collider.lua
--
-- This file is a part of Sneaksy.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "Sneaksy.Common.Class"

local Collider = Class()

function Collider:new()
	-- Nothing.
end

-- Checks the collision between shapes 'a' and 'b'.
--
-- 'i' is the position (a Vector) of shape 'a' and 'j' is the position of shape
-- 'b'.
--
-- Returns true if there was a collision, plus the point(s) of collision.
-- Otherwise, returns false.
function Collider:check(a, i, b, j)
	return Class.ABSTRACT()
end

return Collider
