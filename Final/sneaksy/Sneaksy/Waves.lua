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

function Waves:new(director)
	self.director = director

	director:listen('Killed', self.onKilled, self)

	self.waves = {}
	self.currentCount = 0
	self.currentWave = 0

	self.spawnNextWave = true
end

function Waves:onKilled(e)
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
		self.spawnNextWave = false
		self:nextWave()
	end
end

return Waves
