local events = wl_requireModule("util.events")
local player = wl_requireModule("util.player")

local connected = {}

function connected.Start(clientId, firstTime, isBot)
  local info = player.getIP(clientId)
  et.trap_SendConsoleCommand(et.EXEC_APPEND, "say Player Connected!\n")
  et.trap_SendConsoleCommand(et.EXEC_APPEND, ""..info.."")
end
events.handle("onClientConnectAttempt", connected.Start)

return connected
