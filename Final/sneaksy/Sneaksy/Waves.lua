--------------------------------------------------------------------------------
-- Sneaksy/Waves.lua
--
-- This file is a part of Sneaksy.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "Sneaksy.Common.Class"
local Vector = require "Sneaksy.Common.Math.Vector"
local Peep = require "Sneaksy.Peep.Peep"

Waves = Class()
Waves.SPAWN_TIME = 5

function Waves:new(director)
	self.director = director

	director:listen('Killed', self.onKilled, self)

	self.waves = {}
	self.currentCount = 0
	self.currentWave = 0

	self.spawnNextWave = true
	self.spawnTime = 0

	self.font = love.graphics.newFont(32)
	self.won = false
end

function Waves:onKilled(e)
	if self.currentWave >= #self.waves then
		if e.peep:isType(require "Sneaksy.Peep.Drakkenson") then
			self.won = true
		end

		return
	end

	if e.peep:getTeam() == Peep.TEAM_DRAKKENSON then
		self.currentCount = self.currentCount + 1

		if self.currentCount >= #self.waves[self.currentWave] then
			self.spawnNextWave = true
		end
	end
end

function Waves:push(t)
	local wave = {}
	for i = 1, #t do
		for j = 1, t[i].count do
			local typeName = string.format("Sneaksy.Peep.%s", t[i].peep)
			local Type = require(typeName)
			table.insert(wave, Type)
		end
	end

	table.insert(self.waves, wave)
end

function Waves:nextWave()
	self.currentWave = self.currentWave + 1
	self.currentCount = 0

	local wave = self.waves[self.currentWave]
	if wave then
		local arenaWidth, arenaHeight = self.director:getSize()
		local spawnWidth, spawnHeight = arenaWidth * 0.5, arenaHeight * 0.5

		for i = 1, #wave do
			local peep = self.director:spawn(wave[i])

			local x = math.random(0, spawnWidth) + spawnWidth / 2
			local y = math.random(0, spawnHeight) + spawnHeight / 2

			peep:teleport(Vector(x, y))
		end
	end
end

function Waves:update(delta)
	if self.spawnNextWave then
		if self.spawnTime > Waves.SPAWN_TIME then
			self.spawnNextWave = false
			self:nextWave()

			self.spawnTime = 0
		else
			self.spawnTime = self.spawnTime + delta
		end
	end
end

function Waves:draw()
	if self.spawnNextWave or self.won then
		local oldFont = love.graphics.getFont()
		local w, h = love.window.getMode()
		local x = 0
		local y = h / 2 - self.font:getHeight() / 2

		love.graphics.setFont(self.font)

		local text
		if self.spawnNextWave then
			text = string.format(
			"NEXT WAVE IN %d SEC...",
			Waves.SPAWN_TIME - math.floor(self.spawnTime))
		else
			text = "JAKKENSTONE GET! YOU WIN!"
		end

		love.graphics.setColor(0, 0, 0, 255)
		love.graphics.printf(
			text,
			x + 1, y + 1,
			w,
			'center')

		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.printf(
			text,
			x, y,
			w,
			'center')
	end
end

return Waves
