local events = wolfa_requireModule("util.events")

local connected = {}


function playerInfo.Start()
  et.trap_SendConsoleCommand(et.EXEC_APPEND, "say Player Connected!")
end
events.handle("onClientConnectAttempt", playerInfo.Start)

return connected
