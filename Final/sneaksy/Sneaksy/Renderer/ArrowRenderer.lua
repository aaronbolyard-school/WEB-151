--------------------------------------------------------------------------------
-- Sneaksy/Renderer/Renderer.lua
--
-- This file is a part of Sneaksy.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "Sneaksy.Common.Class"
local Renderer = require "Sneaksy.Renderer.Renderer"

local ArrowRenderer = Class(Renderer)

function ArrowRenderer:new(t)
	Renderer.new(self)

	t = t or {}

	self.image = love.graphics.newImage(
		t.filename or "Resources/Projectile/Arrow.png")
end

function ArrowRenderer:draw(peep)
	self:visit(peep)

	local velocity = peep:getVelocity()
	local position = peep:getPosition()
	local angle = math.atan2(velocity.y, velocity.x)

	love.graphics.draw(
		self.image,
		position.x, position.y,
		angle,
		1, 1,
		-self.image:getWidth(), self.image:getHeight() / 2)
end

return ArrowRenderer
