hs.logger.defaultLogLevel = 'info'
hs.console.clearConsole()
local SpoonInstall = hs.loadSpoon('SpoonInstall')
SpoonInstall:updateAllRepos()
SpoonInstall:andUse('EmmyLua')
SpoonInstall:andUse('ReloadConfiguration', {start = true})
SpoonInstall:andUse('NoSleepingBluetooth', {start = true})
SpoonInstall:andUse('Clock', {
    config = (function()
        local mainRes = hs.screen.primaryScreen():fullFrame()
        local width = 60
        local height = 20
        local alpha = 0.7
        local color = setmetatable({alpha = alpha},
                                   {__index = hs.drawing.color.green})
        local strokeColor = setmetatable({alpha = alpha},
                                         {__index = hs.drawing.color.black})
        return {
            width = width,
            height = height,
            x = mainRes.w - width,
            y = mainRes.h - height,
            textStyle = {
                font = {name = 'Impact', size = 16},
                color = color,
                strokeColor = strokeColor,
                strokeWidth = -5,
                paragraphStyle = {alignment = 'right'},
                kerning = 1.2
            }
        }
    end)(),
    loglevel = 'debug',
    start = true
})

-- TODO re-arrange windows back to correct displays

-- SpoonInstall:andUse('MoveSpaces', {
--	hotkeys = {
--		moveSpaceLeft = {{"ctrl", "alt"}, "left"},
--		moveSpaceRight = {{"ctrl", "alt"}, "right"},
--	}
-- })
