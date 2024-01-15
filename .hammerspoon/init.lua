--TODO re-arrange windows back to correct displays

require 'hs.caffeinate.watcher'
require 'hs.fs'
require 'hs.ipc'
require 'hs.task'
require 'string'

--TODO make bluetooth sleep a Spoon https://github.com/Hammerspoon/hammerspoon/blob/master/SPOONS.md#how-do-i-create-a-spoon
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
