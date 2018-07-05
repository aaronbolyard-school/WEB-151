--------------------------------------------------------------------------------
-- Sneaksy/Common/Math/ColliderManager.lua
--
-- This file is a part of Sneaksy.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "Sneaksy.Common.Class"

local ColliderManager = Class()

function ColliderManager:new()
	self.colliders = {}
end

function ColliderManager:register(A, B, collider)
	local a = self.colliders[A]
	if not a then
		a = {}
		self.colliders[A] = a
	end

	a[B] = collider

	local b = self.colliders[B]
	if not b then
		b = {}
		self.colliders[B] = b
	end

	b[A] = collider
end

function ColliderManager:test(a, i, b, j)
	A = a:getType()
	B = b:getType()

	local c = self.colliders[A]
	if not c then
		return false
	end

	if c[B] then
		return c[B]:check(a, i, b, j)
	else
		return false
	end
end

return ColliderManager
