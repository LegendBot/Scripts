local SCRIPT_INFO = {
	["Name"] = "AutoUpdaterTest",
	["Version"] = 1,
	["Author"] = {
		["Pain"] = "http://botoflegends.com/forum/user/2005-"
	},
	["Credits"] = {
		["Turtlebot"] = "http://botoflegends.com/forum/user/18902-"
	},		
}
local SCRIPT_UPDATER = {
	["Activate"] = true,
	["Script"] = SCRIPT_PATH..GetCurrentEnv().FILE_NAME,
	["URL_HOST"] = "raw.github.com",
	["URL_PATH"] = "/LegendBot/Scripts/master/AutoUpdaterTest.lua",
	["URL_VERSION"] = "/LegendBot/Scripts/master/Versions/AutoUpdaterTest.version"
}
local SCRIPT_LIBS = {
	["SourceLib"] = "https://raw.github.com/LegendBot/Scripts/master/Common/SourceLib.lua",
	["Selector"] = "https://raw.github.com/LegendBot/Scripts/master/Common/Selector.lua",
	["VPrediction"] = "https://raw.github.com/LegendBot/Scripts/master/Common/VPrediction.lua",
	["SOW"] = "https://raw.github.com/LegendBot/Scripts/master/Common/SOW.lua"
}
function PrintMessage(message) 
	print("<font color=\"#00A300\"><b>"..SCRIPT_INFO["Name"]..":</b></font> <font color=\"#FFFFFF\">"..message.."</font>")
end
function Initiate()
	for LIBRARY, LIBRARY_URL in pairs(SCRIPT_LIBS) do
		if FileExist(LIB_PATH..LIBRARY..".lua") then
			require(LIBRARY)
		else
			DOWNLOADING_LIBS = true
			PrintMessage("Missing Library! Downloading "..LIBRARY..". If the library doesn't download, please download it manually.")
			DownloadFile(LIBRARY_URL,LIB_PATH..LIBRARY..".lua",function() PrintMessage("Successfully downloaded "..LIBRARY) end)
		end
	end
	if DOWNLOADING_LIBS then return true end
	if SCRIPT_UPDATER["Activate"] then
		SourceUpdater("<font color=\"#00A300\">"..SCRIPT_INFO["Name"].."</font>", SCRIPT_INFO["Version"], SCRIPT_UPDATER["URL_HOST"], SCRIPT_UPDATER["URL_PATH"], SCRIPT_UPDATER["Script"], SCRIPT_UPDATER["URL_VERSION"]):CheckUpdate()
	end
end
if Initiate() then return end
function OnLoad()
	PrintMessage("Loaded")
end
