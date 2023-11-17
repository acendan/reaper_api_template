-- Aaron Cendan, 2023

-- Visual Studio 2022: $ premake5 vs2022
-- XCode: $ premake5 xcode4
-- Make: $ premake5 gmake2

-- User-specific settings
local users = {
	-- Windows
	["Aaron"] = {
		user_plugins_dir = "C:/REAPER/UserPlugins",
		reaper = "C:/REAPER/reaper.exe"
	},
	-- Linux
	["acendan"] = {
		user_plugins_dir = "/home/acendan/.config/REAPER/UserPlugins",
		reaper = "/home/acendan/opt/REAPER/reaper"
	},
	-- Mac
	["acendanmac"] = {
		user_plugins_dir = "/Users/acendanmac/Library/Application\\ Support/REAPER/UserPlugins",
		reaper = "/Applications/REAPER.app"
	}
}
local current_user = os.getenv("USERNAME") or os.getenv("USER")
local settings = users[current_user]
if not settings then error("No settings found for current user (" .. current_user .. ") in premake5.lua file!") end

--Update the PROJECT_NAME, RUN_PATH, and PROGRAM_PARAMS variables in the .idea/workspace.xml file
if _TARGET_OS == "linux" then
	local project_name = _WORKING_DIR:match("^.+/(.+)$")
    local clion_workspace = _WORKING_DIR .. "/.idea/workspace.xml"
    local file = io.open(clion_workspace, "r")
    local content = file:read("*all")
    file:close()

    content = content:gsub("_TEMP_PROJECT_NAME", project_name)
    content = content:gsub("_TEMP_RUN_PATH", settings.reaper)
    content = content:gsub("_TEMP_PROGRAM_PARAMS", "$PROJECT_DIR$/testing/rpp/" .. project_name .. ".rpp")

	file = io.open(clion_workspace, "w")
	file:write(content)
	file:close()
end

-- Premake
workspace("reaper_api_template")
	configurations({ "debug", "release" })
	location("build")

filter({ "action:vs*" })
	location("build/vs")
	system("Windows")
	architecture("x86_64")
	
filter({ "action:xcode*" })
	location("build/xcode")
	system("MacOSX")
	targetprefix("")
	
filter({ "action:gmake*" })
	location("build/make")
	system("Linux")
	targetprefix("")
	
project("reaper_api_template")
  	kind("SharedLib")
  	language("C++")
	cppdialect("C++20")
  	files({ "source/*.h", "source/*.cpp", "vendor/*.h", 
			"vendor/reaper-sdk/sdk/reaper_plugin.h",
			"vendor/reaper-sdk/sdk/reaper_plugin_functions.h",
			"vendor/WDL/WDL/swell/swell.h" })
	includedirs({ "vendor", "vendor/reaper-sdk/sdk/", "vendor/WDL/WDL" })
	targetdir("bin/%{cfg.system}/%{cfg.buildcfg}")
	postbuildcommands({ "{COPYFILE} %{cfg.buildtarget.relpath} " .. settings.user_plugins_dir })
	debugcommand(settings.reaper)
	debugargs({ "../../testing/rpp/%{prj.name}.rpp" })

  	filter({ "configurations:debug" })
    	defines({ "DEBUG" })
    	symbols("On")

 	 filter({ "configurations:release" })
    	defines({ "RELEASE" })
   		optimize("On")
