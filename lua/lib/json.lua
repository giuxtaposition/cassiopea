local json = require("dkjson")

---@class cassiopea.lib.json
local M = {}

M.decode = function(data)
	return json.decode(data)
end

return M
