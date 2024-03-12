-- based on https://github.com/Hammerspoon/Spoons/tree/master/Source/AClock.spoon
local obj = {
    name = 'Clock',
    version = '0.1',
    author = 'André de Jager <andrethehunter@gmail.com>',
    license = 'MIT - https://opensource.org/licenses/MIT',
    logger = hs.logger.new('Clock')
}
obj.__index = obj

obj.defaultConfig = {
    format = '%H:%M',
    width = 320,
    height = 230,
    textStyle = {
        font = {name = 'Impact', size = 135},
        color = hs.drawing.color.blue,
        paragraphStyle = {textAlignment = 'center'}
    }
}

function obj:init()
    setmetatable(self, {__index = self.defaultConfig})
    if not self.canvas then
        self.canvas = hs.canvas.new({x = 0, y = 0, w = 0, h = 0})
    end
    self.screen_watcher = hs.screen.watcher.newWithActiveScreen(function()
        self:show()
    end)
    self.space_watcher = hs.spaces.watcher.new(function() self:show() end)
    self.timer = hs.timer.new(1, function() self:update_clock_text() end)
    return self
end

function obj:update_clock_text()
    self.canvas[1].text = self.canvas[1].text:setString(os.date(self.format))
    return self
end

function obj:start()
    if not self.x or not self.x then
        local mainRes = hs.screen.primaryScreen():fullFrame()
        self.x = (mainRes.w - self.width) / 2
        self.y = (mainRes.h - self.height) / 2
    end
    self.canvas[1] = {
        type = 'text',
        text = hs.styledtext.new(' ', self.textStyle)
    }
    self.canvas:frame({x = self.x, y = self.y, w = self.width, h = self.height})
    self:update_clock_text()
    self:show()
    self.timer:start()
    self.screen_watcher:start()
    self.space_watcher:start()
    return self
end

function obj:stop()
    self.canvas:hide()
    self.timer:stop()
    self.screen_watcher:stop()
    self.space_watcher:stop()
    return self
end

function obj:show()
    self.canvas:show()
    return self
end

return obj
