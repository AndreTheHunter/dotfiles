local obj = {
    name = "WiFiEthernetHandover",
    version = "0.1",
    author = "André de Jager <andrethehunter@gmail.com>",
    license = "MIT - https://opensource.org/licenses/MIT"
}
obj.__index = obj

local function checkBluetoothResult(exitCode, stdOut, stdErr)
    if exitCode ~= 0 then
        print(string.format(
                  "Unexpected result executing `blueutil`: rc=%d stdErr=%s stdOut=%s",
                  exitCode, stdErr, stdOut))
    end
end

function obj:init()
    hs.task.new('/opt/homebrew/bin/blueutil', checkBluetoothResult,
                {'--power', power}):start()
end

return obj
