--------------------------------------------------------------------------------
-- Sneaksy/Peep/Peep.lua
--
-- This file is a part of Sneaksy.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "Sneaksy.Common.Class"
local Callback = require "Sneaksy.Common.Callback"
local Vector = require "Sneaksy.Common.Math.Vector"
local Shape = require "Sneaksy.Common.Math.Shape"

local Peep = Class()
Peep.CURRENT_TALLY = 1

Peep.TEAM_SNEAKSY = 1
Peep.TEAM_DRAKKENSON = 2
Peep.TEAM_NONE = 3

-- Direction of the Peep. Used for scaling, etc.
--
-- Peeps are normally assumed to face right.
Peep.DIRECTION_RIGHT = 1
Peep.DIRECTION_LEFT  = -1

function Peep:new(name)
	self.callbacks = {}

	self.body = false
	self.acceleration = Vector(0, 0)
	self.position = Vector(0, 0)
	self.velocity = Vector(0, 0)
	self.dampening = 0.9
	self.direction = Peep.DIRECTION_RIGHT
	self.shape = Shape()
	self.fixture = false
	self.director = false

	self.team = Peep.TEAM_NONE

	self.name = name or "Guest #" .. tostring(Peep.CURRENT_TALLY)
	self.id = Peep.CURRENT_TALLY

	Peep.CURRENT_TALLY = Peep.CURRENT_TALLY + 1
end

function Peep:init(director)
	self.director = director

	self:makeBody()
end

function Peep:poof()
	if self.body then
		self.body:destroy()
	end
end

function Peep:makeBody(mode)
	if self.body then
		self.body:destroy()

		self.fixture = false
	end

	self.body = love.physics.newBody(
		self.director:getWorld(),
		self.position.x, self.position.y,
		mode or 'dynamic')
	self.body:setUserData(self)
	self.body:setLinearVelocity(self.velocity.x, self.velocity.y)
	self.body:setLinearDamping(self.dampening)
	self.body:setPosition(self.position.x, self.position.y)
	self:setShape(self:getShape())
end

-- Gets the Director this Peep belongs to.
--
-- Returns nil if the Peep has not be initialized yet.
function Peep:getDirector()
	if not self.director then
		return nil
	else
		return self.director
	end
end

function Peep:getPosition()
	return self.position
end

function Peep:teleport(position)
	self.position = position or self.position
	if self.body then
		self.body:setPosition(self.position.x, self.position.y)
	end
end

function Peep:move(offset)
	self.position = self.position + offset or Vector(0)
	if self.body then
		self.body:setPosition(self.position.x, self.position.y)
	end
end

function Peep:getAcceleration()
	return self.acceleration
end

function Peep:applyForce(value)
	self.acceleration = self.acceleration + value or Vector(0)
end

function Peep:setAcceleration(value)
	self.acceleration = value or self.acceleration
end

function Peep:getVelocity()
	return self.velocity
end

function Peep:setVelocity(value)
	self.velocity = value or self.velocity
	if self.body then
		self.body:setLinearVelocity(self.velocity.x, self.velocity.y)
	end
end

function Peep:getDampening()
	return self.dampening
end

function Peep:setDampening(value)
	self.dampening = value or self.dampening
	if self.body then
		self.body:setLinearDamping(self.dampening)
	end
end

function Peep:getDirection()
	return self.direction
end

function Peep:setDirection(value)
	self.direction = value or self.direction
end

function Peep:getShape()
	return self.shape
end

function Peep:setShape(value)
	if self.fixture then
		self.fixture:destroy()
		self.fixture = false
	end

	if not value then
		self.shape = Shape()
	else
		self.shape = value or self.shape

		if self.body then
			local s = self.shape:toLove()
			if s then
				self.fixture = love.physics.newFixture(self.body, s)
			end
		end
	end
end

function Peep:getTeam()
	return self.team
end

function Peep:setTeam(value)
	self.team = value or self.team
end

function Peep:getName()
	return self.name
end

function Peep:getID()
	return self.id
end

-- Updates the Peep.
--
-- Updates velocity by acceleration, then position by velocity.
--
-- Applies 'self.dampening' to velocity and acceleration after position is updated. 
function Peep:update(delta)
	if self.body then
		self.body:applyForce(self.acceleration.x, self.acceleration.y)
	end

	self.acceleration = self.acceleration * 1.0 / (1.0 + self.dampening * delta)

	self.position = Vector(self.body:getPosition())

	local velocity = self:getVelocity()
	if velocity.x > 1 then
		self:setDirection(Peep.DIRECTION_RIGHT)
	elseif velocity.x < -1 then
		self:setDirection(Peep.DIRECTION_LEFT)
	end
end

function Peep:listen(event, func, ...)
	local c = self.callbacks[event]
	if not c then
		c = Callback()
		self.callbacks[event] = c
	end

	c:register(func, ...)
end

function Peep:silence(event, func)
	local c = self.callbacks[event]
	if c then
		c:unregister(event, func)
	end
end

function Peep:poke(event, e, ...)
	local func = 'on' .. event
	if self[func] then
		self[func](self, e, ...)
	end

	local callback = self.callbacks[event]
	if callback then
		callback(e, ...)
	end
end

function Peep:broadcast(event, e, ...)
	local callback = self.callbacks[event]
	if callback then
		callback(e, ...)
	end
end

return Peep
