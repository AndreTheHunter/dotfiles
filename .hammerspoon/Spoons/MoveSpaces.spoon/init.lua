require 'hs.spaces'

local obj = {}
obj.__index = obj

-- Metadata
obj.name = "MoveSpaces"
obj.version = "0.1"
obj.author = "André de Jager <andrethehunter@gmail.com>"
obj.license = "MIT - https://opensource.org/licenses/MIT"

function obj:bindHotkeys(mapping)
   local spec = {
    moveSpaceLeft = hs.fnutils.partial(self.moveSpaceLeft, self),
    moveSpaceRight = hs.fnutils.partial(self.moveSpaceRight, self),
  }
  hs.spoons.bindHotkeysToSpec(spec, mapping)
  return self
end

function obj:moveSpaceLeft()
  --FIXME add delay for mission control appearing and dissapearing https://www.hammerspoon.org/docs/hs.timer.delayed.html
  --  or set https://www.hammerspoon.org/docs/hs.spaces.html#MCwaitTime
	--hs.spaces.openMissionControl()
  local space = hs.spaces.focusedSpace()
  --hs.spaces.closeMissionControl()
end

function obj:moveSpaceRight()

end

return obj
