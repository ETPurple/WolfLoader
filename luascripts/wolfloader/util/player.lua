
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

local player = {}

local data = {[-1337] = {["guid"] = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"}}

function player.isConnected(clientId)
    return (data[clientId] ~= nil)
end

function player.getName(clientId)
    if clientId == -1337 then
        return "console"
    end

    return et.gentity_get(clientId, "pers.netname")
end

function player.getGUID(clientId)
    return data[clientId]["guid"]
end

function player.getIP(clientId)
    return data[clientId]["ip"]
end

function player.getProtocol(clientId)
    return data[clientId]["protocol"]
end

function player.isBot(clientId)
    return data[clientId]["bot"]
end

function player.onClientConnect(clientId, firstTime, isBot)
    local clientInfo = et.trap_GetUserinfo(clientId)

    -- name is NOT yet set in pers.netname, so get all info out of infostring
    data[clientId] = {}

    -- data[clientId]["name"] is cached version for detecting namechanges, do not
    -- use it to retrieve a player's name
    data[clientId]["name"] = et.Info_ValueForKey(clientInfo, "name")
    data[clientId]["guid"] = et.Info_ValueForKey(clientInfo, "cl_guid")
    data[clientId]["ip"] = string.gsub(et.Info_ValueForKey(clientInfo, "ip"), ":%d*", "")
    data[clientId]["protocol"] = tonumber(et.Info_ValueForKey(clientInfo, "protocol"))
    data[clientId]["bot"] = isBot
    data[clientId]["team"] = tonumber(et.gentity_get(clientId, "sess.sessionTeam"))

    if firstTime then
        data[clientId]["new"] = true
    end
end
events.handle("onClientConnectAttempt", player.onClientConnect)

function player.onClientBegin(clientId)
    events.trigger("onPlayerReady", clientId, data[clientId]["new"])

    data[clientId]["new"] = false

    -- this is now available
    local clientInfo = et.trap_GetUserinfo(clientId)
end
events.handle("onClientBegin", player.onClientBegin)

function player.onClientDisconnect(clientId)
    data[clientId] = nil
end
events.handle("onClientDisconnect", player.onClientDisconnect)

function player.onClientInfoChange(clientId)
  local oldTeam = data[clientId]["team"]
  local newTeam = tonumber(et.gentity_get(clientId, "sess.sessionTeam"))

  if newTeam ~= oldTeam then
      data[clientId]["team"] = newTeam

      events.trigger("onClientTeamChange", clientId, oldTeam, newTeam)
  end

  local oldName = data[clientId]["name"]
  local newName = et.gentity_get(clientId, "pers.netname")

  if newName ~= oldName then
      data[clientId]["name"] = newName

      events.trigger("onClientNameChange", clientId, oldName, newName)
  end
end
events.handle("onClientInfoChange", player.onClientInfoChange)

return player
