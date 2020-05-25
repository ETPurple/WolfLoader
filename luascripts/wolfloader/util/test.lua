local events = wl_requireModule("util.events")
local player = wl_requireModule("util.player")


local test = {}
local var = 0

function test.start()
  if var < 50 then
    et.trap_SendConsoleCommand(et.EXEC_APPEND, "say test.start() RunFrame")
    var = var + 1
  end
end
events.handle("onGameFrame", test.start)


function test.commands(clientNum, cmdText)
    et.trap_SendConsoleCommand(et.EXEC_APPEND, "say "..clientId.." + "..cmdtext.."")
end
events.handle("onClientCommand", test.commands)

return test
