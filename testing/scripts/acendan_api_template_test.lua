local acendan_LuaUtils = reaper.GetResourcePath()..'/Scripts/ACendan Scripts/Development/acendan_Lua Utilities.lua'
if reaper.file_exists( acendan_LuaUtils ) then dofile( acendan_LuaUtils ); if not acendan or acendan.version() < 1 then acendan.msg('This script requires a newer version of ACendan Lua Utilities. Please run:\n\nExtensions > ReaPack > Synchronize Packages',"ACendan Lua Utilities"); return end else reaper.ShowConsoleMsg("This script requires ACendan Lua Utilities! Please install them here:\n\nExtensions > ReaPack > Browse Packages > 'ACendan Lua Utilities'"); return end

local func_name_len = 0
local function dbg_header(func_name) func_name_len = func_name:len(); acendan.dbg("--- " .. func_name .. " ---") end
local function dbg_footer() acendan.dbg(string.rep("-", func_name_len + 8)); acendan.dbg("") end
reaper.ClearConsole()

dbg_header("reaper.API_HelloWorld()")
reaper.API_HelloWorld()
dbg_footer()
