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

local eventLookup = {
	[hs.caffeinate.watcher.screensaverDidStart] = 'off',
	[hs.caffeinate.watcher.screensaverDidStop] = 'on',
	[hs.caffeinate.watcher.screensDidLock] = 'off',
	[hs.caffeinate.watcher.screensDidUnlock] = 'on',
	[hs.caffeinate.watcher.systemWillSleep] = 'off',
	[hs.caffeinate.watcher.screensDidWake] = 'on',
}

local function sleepWatcher(eventType)
    local power = eventLookup[eventType]
    if eventType ~= nil then
    	print("Received event " .. eventType .. ", setting bluetooth power " .. power)
			hs.task.new('/opt/homebrew/bin/blueutil', checkBluetoothResult, { '--power', power }):start()
		end
end
-- https://www.hammerspoon.org/docs/hs.caffeinate.watcher.html
hs.caffeinate.watcher.new(sleepWatcher):start()

hs.loadSpoon('ReloadConfiguration')
spoon.ReloadConfiguration:start()
