--based on https://gist.github.com/ysimonson/fea48ee8a68ed2cbac12473e87134f58
require 'hs.caffeinate.watcher'
require 'hs.task'
require 'hs.logger'

local obj = {}
obj.__index = obj

-- Metadata
obj.name = 'NoSleepingBluetooth'
obj.version = '0.1'
obj.author = 'André de Jager <andrethehunter@gmail.com>'
obj.license = 'MIT - https://opensource.org/licenses/MIT'

local log = hs.logger.new('NoSleepingBluetooth')

local function checkBluetoothResult(exitCode, stdOut, stdErr)
    if exitCode ~= 0 then
        log.ef('Unexpected result executing `blueutil`: rc=%d stdErr=%s stdOut=%s', exitCode, stdErr, stdOut)
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
			log.i('Received event ' .. eventType .. ', setting bluetooth power ' .. power)
			hs.task.new('/opt/homebrew/bin/blueutil', checkBluetoothResult, { '--power', power }):start()
		end
end

function obj:start()
	-- https://www.hammerspoon.org/docs/hs.caffeinate.watcher.html#screensaverDidStop
	hs.caffeinate.watcher.new(sleepWatcher):start()
end

return obj
