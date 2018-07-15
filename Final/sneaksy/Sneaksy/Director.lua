--------------------------------------------------------------------------------
-- Sneaksy/Director.lua
--
-- This file is a part of Sneaksy.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Callback = require "Sneaksy.Common.Callback"
local Class = require "Sneaksy.Common.Class"
local Vector = require "Sneaksy.Common.Math.Vector"
local Peep = require "Sneaksy.Peep.Peep"
local Renderer = require "Sneaksy.Renderer.Renderer"

local Director = Class()

-- Constructs a new Director.
--
-- A Director manages Peeps. Events can be broadcast via the director to peeps,
-- and peeps can be retrieved via the director.
function Director:new()
	self.peeps = {}
	self.world = love.physics.newWorld()

	local function beginTouch(fa, fb, contact)
		local ba, bb = fa:getBody(), fb:getBody()
		local a, b = ba:getUserData(), bb:getUserData()

		a:poke('NotifyBeginCollision', {
			other = b,
			normal = Vector(contact:getNormal())
		})

		b:poke('NotifyBeginCollision', {
			other = a,
			normal = Vector(contact:getNormal())
		})

		self:broadcast('BeginCollision', {
			a = a,
			b = b,
			point = p
		})
	end

	local function endTouch(fa, fb, contact)
		local fa, fb = contact:getFixtures()
		local ba, bb = fa:getBody(), fb:getBody()
		local a, b = ba:getUserData(), bb:getUserData()

		a:poke('NotifyEndCollision', {
			other = b,
			point = p
		})

		b:poke('NotifyEndCollision', {
			other = a,
			point = p
		})

		self:broadcast('EndCollision', {
			a = a,
			b = b,
			point = p
		})
	end

	local function beforeTouch(fa, fb, contact)
		local ba, bb = fa:getBody(), fb:getBody()
		local a, b = ba:getUserData(), bb:getUserData()

		a:poke('NotifyBeginTouch', {
			other = b,
			normal = Vector(contact:getNormal()),
			contact = contact
		})

		b:poke('NotifyBeginTouch', {
			other = a,
			normal = Vector(contact:getNormal()),
			contact = contact
		})

		self:broadcast('BeginTouch', {
			a = a,
			b = b,
			point = p
		})
	end

	self.world:setCallbacks(beginTouch, endTouch, beforeTouch)

	self.renderers = {}
	self.defaultRenderer = Renderer()

	self.callbacks = {}

	self.peepsPendingRemoval = {}
	self.peepsPendingAddition = {}

	self.background = love.graphics.newImage("Resources/Background.png")
end

function Director:addRenderer(Type, renderer)
	if not self.renderers[Type] then
		self.renderers[Type] = renderer
	end
end

-- Gets the size of the play area.
function Director:getSize()
	local w, h = love.window.getMode()
	return w, h
end

function Director:getWorld()
	return self.world
end

-- Spawns a Peep of type 'Type'.
--
-- Any extra arguments are passed on to the Peep constructor.
--
-- Returns the Peep on success, nil on failure. Failure can occur if 'Type' is
-- not derived from Peep.
function Director:spawn(Type, ...)
	if Class.isDerived(Type, Peep) then
		local peep = Type(...)
		peep:init(self)

		self.peepsPendingAddition[peep] = true

		return peep
	end

	return nil
end

-- Poofs a peep.
--
-- Returns true if the Peep existed within the director and was poofed, false
-- otherwise.
function Director:poof(peep)
	if self.peeps[peep] then
		table.insert(self.peepsPendingRemoval, peep)
		return true
	end

	return false
end

-- Listens for global broadcasts.
function Director:listen(event, func, ...)
	local c = self.callbacks[event]
	if not c then
		c = Callback()
		self.callbacks[event] = c
	end

	c:register(func, ...)
end

-- Silences a global broadcast.
function Director:silence(event, func)
	local c = self.callbacks[event]
	if c then
		c:unregister(event, func)
	end
end

-- Broadcasts an event to all Peeps.
function Director:broadcast(event, e, ...)
	for peep in pairs(self.peeps) do
		peep:poke(event, e, ...)
	end

	local c = self.callbacks[event]
	if c then
		c(e, ...)
	end
end

-- Broadcasts an event to all Peeps within distance radius of point.
function Director:broadcastNear(point, distance, event, e, ...)
	for peep in pairs(self.peeps) do
		local d = Vector.getLength(peep:getPosition() - point)
		if d <= distance then
			peep:poke(event, e, ...)
		end
	end
end

function Director:byType(Type)
	return self:iterate(function(c)
		return Class.isDerived(c:getType(), Type)
	end)
end

function Director:byTeam(team)
	return self:iterate(function(c)
		return c:getTeam() == team
		end)
end

function Director:near(position, distance)
	return self:iterate(function(c)
		local difference = position - c:getPosition()
		return difference:getLength() < distance
	end)
end

function Director:update(delta)
	for _, peep in pairs(self.peepsPendingRemoval) do
		peep:poof()

		self.peeps[peep] = nil
	end
	self.peepsPendingRemoval = {}

	for peep in pairs(self.peepsPendingAddition) do
		self.peeps[peep] = true
	end
	self.peepsPendingAddition = {}

	self.world:update(delta)

	for peep in self:iterate() do
		peep:update(delta)
	end

	for _, renderer in pairs(self.renderers) do
		renderer:update(delta)
	end
end

function Director:iterate(filter)
	filter = filter or function() return true end

	local n, c = next, nil
	return function()
		repeat
			c = n(self.peeps, c)
		until not c or filter(c)

		return c
	end
end

function Director:draw()
	local peeps = {}
	for peep in self:iterate() do
		table.insert(peeps, peep)
	end

	table.sort(peeps, function(a, b) return a:getPosition().y < b:getPosition().y end)

	do
		local w, h = love.window.getMode()
		local scaleX, scaleY = w / self.background:getWidth(), h / self.background:getHeight()
		local scale = math.max(scaleX, scaleY)

		love.graphics.draw(
			self.background,
			w / 2, h / 2,
			0,
			scale, scale,
			self.background:getWidth() / 2,
			self.background:getHeight() / 2)
	end

	for _, renderer in pairs(self.renderers) do
		renderer:start()
	end
	self.defaultRenderer:start()

	for i = 1, #peeps do
		local peep = peeps[i]
		local t = peep:getType()

		if self.renderers[t] then
			self.renderers[t]:draw(peep)
		else
			self.defaultRenderer:draw(peep)
		end
	end

	for _, renderer in pairs(self.renderers) do
		renderer:stop()
	end
	self.defaultRenderer:stop()
end

return Director
