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

local events
local test
local connected

local version = "1.2.1"
local release = "14 April 2020"

local basepath
local homepath
local lualibspath
local luamodspath

-- need to do this somewhere else
function wl_getVersion()
    return version
end

function wl_getRelease()
    return release
end

function wl_getBasePath()
    return basepath
end

function wl_getHomePath()
    return homepath
end

function wl_getLuaLibsPath()
    return lualibspath
end

function wl_getLuaModsPath()
    return luamodspath
end

function wl_requireLib(lib)
    return require(wl_getLuaLibsPath().."/"..string.gsub(lib, "%.", "/"))
end

function wl_requireModule(module)
    return require(wl_getLuaModsPath().."/"..string.gsub(module, "%.", "/"))
end

function et_InitGame(levelTime, randomSeed, restartMap)
    -- set up paths
    basepath = string.gsub(et.trap_Cvar_Get("fs_basepath"), "\\", "/").."/"..et.trap_Cvar_Get("fs_game").."/"
    homepath = string.gsub(et.trap_Cvar_Get("fs_homepath"), "\\", "/").."/"..et.trap_Cvar_Get("fs_game").."/"
    lualibspath = "lualibs"
    luamodspath = "luascripts/wolfloader"

    events = wl_requireModule("util.events")
    test = wl_requireModule("util.test")
    conected = wl_requireModule("util.connected")


    -- register the module
    et.RegisterModname("WolfAdmin "..wl_getVersion())
    et.trap_SendConsoleCommand(et.EXEC_APPEND, "sets mod_wolfadmin "..wl_getVersion()..";")


    events.trigger("onGameInit", levelTime, randomSeed, (restartMap == 1))
end

function et_ShutdownGame(restartMap)
    -- check whether the module has fully initialized
    if events then
        events.trigger("onGameShutdown", (restartMap == 1))
    end
end

function et_ConsoleCommand(cmdText)
    return events.trigger("onServerCommand", cmdText)
end

function et_ClientConnect(clientId, firstTime, isBot)
    return events.trigger("onClientConnectAttempt", clientId, (firstTime == 1), (isBot == 1))
end

function et_ClientBegin(clientId)
    events.trigger("onClientBegin", clientId)
end

function et_ClientDisconnect(clientId)
    events.trigger("onClientDisconnect", clientId)
end

function et_ClientUserinfoChanged(clientId)
    events.trigger("onClientInfoChange", clientId)
end

function et_ClientCommand(clientId, cmdText)
    return events.trigger("onClientCommand", clientId, cmdText)
end

function et_RunFrame(levelTime)
    events.trigger("onGameFrame", levelTime)
end
-- no callbacks defined for these things, so had to invent some special regexes
-- note for etlegacy team: please take a look at this, might come in handy :-)
function et_Print(consoleText)

end

function et_Obituary(victimId, killerId, mod)
    events.trigger("onPlayerDeath", victimId, killerId, mod)
end

function et_ClientSpawn(clientId, revived)
    if revived == 0 then
        events.trigger("onPlayerSpawn", clientId)
    end
end
