--FIXME commit and restore saves spoons
--FIXME on sleep, turn off bluetooth and wifi
--FIXME on awake, turn on bluetooth and wifi
--FIXME on login, restart wifi if connected to desktop hotspot

require "hs.fs"
require "hs.ipc"

--install hs CLI
local dest = "/opt/homebrew"
if not hs.ipc.cliStatus(dest) then
	if not hs.ipc.cliInstall(dest) then
		error("Could not install hs CLI")
	end
end

hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()
