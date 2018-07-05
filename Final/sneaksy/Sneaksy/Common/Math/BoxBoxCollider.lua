--------------------------------------------------------------------------------
-- Sneaksy/Common/Math/BoxBoxCollider.lua
--
-- This file is a part of Sneaksy.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "Sneaksy.Common.Class"
local BoxShape = require "Sneaksy.Common.Math.BoxShape"
local BoxShape = require "Sneaksy.Common.Math.BoxShape"
local Collider = require "Sneaksy.Common.Math.Collider"
local Vector = require "Sneaksy.Common.Math.Vector"

local BoxBoxCollider = Class(Collider)

function BoxBoxCollider:new()
	Collider.new(self)
end

local function cross(a, b)
	return a.x * b.y - a.y * b.x
end

local function intersection(lineA, lineB, rayPosition, rayDirection)
	local difference = lineB - lineA

	local t = cross(rayPosition - lineA, difference) / cross(difference, rayDirection)
	local u = cross(lineA - rayPosition, rayDirection) / cross(rayDirection, difference)
	if t > 0 and t < 1 and u > 0 then
		return true, rayPosition + u * rayDirection
	end

	return false
end

function BoxBoxCollider:check(a, i, b, j)
	local s = a:getSize()
	local t = b:getSize()
	local boxHalfSizeA = s / 2
	local boxHalfSizeB = t / 2

	local u = i - j
	local v = boxHalfSizeA + boxHalfSizeB
	if u.x < v.x and u.y < v.y then
		local q = i
		local r = Vector.getNormal(j - i)

		local c, p
		do
			-- Left
			c, p = intersection(Vector(i.x, i.y), Vector(i.x, i.y + t.y), q, r)
			if c then return true, p end

			-- Right
			c, p = intersection(Vector(i.x + t.x, i.y), Vector(i.x + t.x, i.y + t.y), q, r)
			if c then return true, p end

			-- Top
			c, p = intersection(Vector(i.x, i.y), Vector(i.x + t.x, i.y), q, r)
			if c then return true, p end

			-- Bottom
			c, p = intersection(Vector(i.x, i.y + t.y), Vector(i.x + t.x, i.y + t.y), q, r)
			if c then return true, p end

			local m = string.format(
				"collision but failed to intersect; a = (%dx%d), i = (%d, %d), b = (%dx%d), j = (%d, %d)",
				s.x, s.y,
				i.x, i.y,
				t.x, t.y,
				j.x, j.y)
			error(m)
		end
	end

	return false
end

return BoxBoxCollider
