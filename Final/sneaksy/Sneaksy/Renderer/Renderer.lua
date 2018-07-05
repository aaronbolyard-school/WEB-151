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

local Renderer = Class()

function Renderer:new()
	self.peeps = {}
end

function Renderer:visit(peep)
	if not self.peeps[peep] then
		self.peeps[peep] = true
		self:onPeepAdded(peep)
	end

	self.unvisited[peep] = nil
end

function Renderer:start()
	self.unvisited = {}
	for peep in pairs(self.peeps) do
		self.unvisited[peep] = true
	end
end

function Renderer:stop()
	for peep in pairs(self.unvisited) do
		self.peeps[peep] = nil
		self:onPeepRemoved(peep)
	end
end

function Renderer:onPeepAdded(peep)
	-- Nothing.
end

function Renderer:onPeepRemoved(peep)
	-- Nothing.
end

function Renderer:update(delta)
	-- Nothing.
end

function Renderer:draw(peep)
	self:visit(peep)

	local bounds = peep:getShape():getBounds()
	local position = peep:getPosition()

	love.graphics.setColor(0, 255, 0, 255)
	love.graphics.rectangle(
		'line',
		position.x - bounds.x / 2, position.y - bounds.y / 2,
		bounds.x, bounds.y)
	love.graphics.printf(
		peep:getName(),
		position.x - bounds.x / 2, position.y,
		bounds.x,
		'center')

	love.graphics.setColor(255, 255, 255, 255)
end

return Renderer
