--TODO re-arrange windows back to correct displays
--TODO on login, restart wifi if connected to desktop hotspot

require 'hs.caffeinate.watcher'
require 'hs.fs'
require 'hs.ipc'
require 'hs.task'
require 'string'

--install hs CLI
local dest = '/opt/homebrew'
if not hs.ipc.cliStatus(dest) then
    if not hs.ipc.cliInstall(dest) then
        error('Could not install hs CLI')
    end
end

--TODO makey bluetooth sleep a Spoon https://github.com/Hammerspoon/hammerspoon/blob/master/SPOONS.md#how-do-i-create-a-spoon
local function checkBluetoothResult(exitCode, stdOut, stdErr)
    if exitCode ~= 0 then
        print(string.format("Unexpected result executing `blueutil`: rc=%d stdErr=%s stdOut=%s", exitCode, stdErr, stdOut))
    end
end

local function sleepWatcher(eventType)
    local power
    if eventType == hs.caffeinate.watcher.systemWillSleep or eventType == hs.caffeinate.watcher.screensDidLock then
        power = 'off'
    elseif eventType == hs.caffeinate.watcher.screensDidWake or eventType == hs.caffeinate.watcher.screensDidUnlock then
        power = 'on'
    end
    hs.task.new('/opt/homebrew/bin/blueutil', checkBluetoothResult, { '--power', power }):start()

end
hs.caffeinate.watcher.new(sleepWatcher):start()

hs.loadSpoon('ReloadConfiguration')
spoon.ReloadConfiguration:start()
