---@class cassiopea.lib.path
local M = {}

---@param path any
---@return string
function M.cwd(path)
	local str = debug.getinfo(2, "S").source:sub(2)
	local src = str:match("(.*/)") or str:match("(.*\\)") or "./"
	return src .. path
end

return M
