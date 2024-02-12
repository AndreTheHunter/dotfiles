-- based on https://gist.github.com/ysimonson/fea48ee8a68ed2cbac12473e87134f58
local obj = {
    name = 'NoSleepingBluetooth',
    version = '0.1',
    author = 'André de Jager <andrethehunter@gmail.com>',
    license = 'MIT - https://opensource.org/licenses/MIT',
    logger = hs.logger.new('NoSleepingBluetooth')
}
obj.__index = obj

obj.eventLookup = {
    [hs.caffeinate.watcher.screensaverDidStart] = 'off',
    [hs.caffeinate.watcher.screensaverDidStop] = 'on',
    [hs.caffeinate.watcher.screensDidLock] = 'off',
    [hs.caffeinate.watcher.screensDidUnlock] = 'on',
    [hs.caffeinate.watcher.systemWillSleep] = 'off',
    [hs.caffeinate.watcher.screensDidWake] = 'on'
}

function obj:checkBluetoothResult(exitCode, stdOut, stdErr)
    if exitCode ~= 0 then
        self.logger.ef(
            'Unexpected result executing `blueutil`: rc=%d stdErr=%s stdOut=%s',
            exitCode, stdErr, stdOut)
    end
end

function obj:sleepWatcher(eventType)
    local power = self.eventLookup[eventType]
    if power then
        self.logger.i('Received event ' .. eventType ..
                          ', setting bluetooth power ' .. power)
        local callbackFn = hs.fnutils.partial(self.checkBluetoothResult, self)
        hs.task
            .new('/opt/homebrew/bin/blueutil', callbackFn, {'--power', power}):start()
    end
end

function obj:init()
    -- https://www.hammerspoon.org/docs/hs.caffeinate.watcher.html
    local fn = hs.fnutils.partial(self.sleepWatcher, self)
    self.watcher = hs.caffeinate.watcher.new(fn)
end

function obj:start() self.watcher:start() end

return obj
