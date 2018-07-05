--------------------------------------------------------------------------------
-- Sneaksy/Common/Math/CircleBoxCollider.lua
--
-- This file is a part of Sneaksy.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "Sneaksy.Common.Class"
local BoxShape = require "Sneaksy.Common.Math.BoxShape"
local CircleShape = require "Sneaksy.Common.Math.CircleShape"
local Collider = require "Sneaksy.Common.Math.Collider"
local Vector = require "Sneaksy.Common.Math.Vector"

local CircleBoxCollider = Class(Collider)

function CircleBoxCollider:new()
	Collider.new(self)
end

local function intersection(v, w, p, radius)
	local lengthSquared = (v - w):getLengthSquared()
	if lengthSquared == 0 then
		return false, nil
	end

	local t = math.max(0, math.min(1, Vector.dot(p - v, w - v) / lengthSquared))
	local projection = v + t * (w - v)
	local distance = (p - projection):getLength()
	if distance < radius then
		return true, projection
	end

	return false, nil
end

function CircleBoxCollider:check(a, i, b, j)
	local circle, circlePosition
	local box, boxPosition
	if Class.isType(a, CircleShape) then
		assert(Class.isType(b, BoxShape), "b is not Box")
		circle = a
		circlePosition = i
		box = b
		boxPosition = j
	else
		assert(Class.isType(a, BoxShape), "a is not Box")
		assert(Class.isType(b, CircleShape), "b is not Circle")
		box = a
		boxPosition = i
		circle = b
		circlePosition = j
	end

	local boxHalfSize = box:getSize() / 2
	local topLeft = Vector(boxPosition.x - boxHalfSize.x, boxPosition.y - boxHalfSize.y)
	local topRight = Vector(boxPosition.x + boxHalfSize.x, boxPosition.y - boxHalfSize.y)
	local bottomLeft = Vector(boxPosition.x - boxHalfSize.x, boxPosition.y + boxHalfSize.y)
	local bottomRight = Vector(boxPosition.x + boxHalfSize.x, boxPosition.y + boxHalfSize.y)

	local circleRadius = circle:getRadius()

	local collision, point
	do
		collision, point = intersection(topLeft, topRight, circlePosition, circleRadius)
		if collision then return true, point end

		collision, point = intersection(bottomLeft, bottomRight, circlePosition, circleRadius)
		if collision then return true, point end

		collision, point = intersection(topLeft, bottomLeft, circlePosition, circleRadius)
		if collision then return true, point end

		collision, point = intersection(topRight, bottomRight, circlePosition, circleRadius)
		if collision then return true, point end
	end

	return false, nil
end

return CircleBoxCollider
