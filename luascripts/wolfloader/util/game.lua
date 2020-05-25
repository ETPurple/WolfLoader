
-- WolfAdmin module for Wolfenstein: Enemy Territory servers.
-- Copyright (C) 2015-2020 Timo 'Timothy' Smit

-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- at your option any later version.

-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.

-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.

local events = wl_requireModule("util.events")
local players = wl_requireModule("players.players")

local game = {}

local killCount = 0
local lastKillerId

local currentState
local currentMaps = {}
local currentMap, nextMap

function game.getState()
    return currentState
end

function game.getMode()
    return tonumber( et.trap_Cvar_Get( "g_gametype" ) )
end

function game.getMaps()
    return currentMaps
end

function game.getMap()
    return string.lower( et.trap_Cvar_Get( "mapname" ) )
end

function game.getNextMap()
    return nextMap
end

function game.maxClients()
  return tonumber( et.trap_Cvar_Get( "sv_maxClients" ) )
end

function game.axisRespawn()
  return tonumber( et.trap_Cvar_Get( "g_userAxisRespawnTime" ) )
end

function game.alliesRespawn()
  return tonumber( et.trap_Cvar_Get( "g_userAlliedRespawnTime" ) )
end

function game.gameType()
  return tonumber( et.trap_Cvar_Get( "g_gameType" ) )
end

function game.currentRound()
  return tonumber( et.trap_Cvar_Get( "g_currentRound" ) )
end

function game.getLevelTime()
   return ( et.trap_Milliseconds() )
end

function game.getTimeLimit()
  return tonumber( et.trap_Cvar_Get( "timelimit" ) )
end

return game
