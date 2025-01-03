--Credits to zalanwastaken (https://github.com/zalanwastaken)
local function getScriptFolder() --* get the path from the root folder in which THIS script is running
	return (debug.getinfo(1, "S").source:sub(2):match("(.*/)"))
end
PATH = getScriptFolder()
CORE = PATH .. "src.core."
ELEMENTS = PATH .. "src.elements."

local global = {}
local internal = {}

return global
