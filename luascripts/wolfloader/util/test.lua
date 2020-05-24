local events = wl_requireModule("util.events")

local test = {}
local var = 0

function test.start()
  if var == 0 then
    et.trap_SendConsoleCommand(et.EXEC_APPEND, "say test.start() RunFrame")
    var = var + 1
  end
end
events.handle("onGameFrame", test.start)

return test
