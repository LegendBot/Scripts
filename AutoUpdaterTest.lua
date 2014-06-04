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
	["Selector"] = "https://raw.github.com/LegendBot/Scripts/master/Common/Selector.lua",
	["VPrediction"] = "https://raw.github.com/LegendBot/Scripts/master/Common/VPrediction.lua",
	["SOW"] = "https://raw.github.com/LegendBot/Scripts/master/Common/SOW.lua"
}
function PrintMessage(message) 
	print("<font color=\"#00A300\"><b>"..SCRIPT_INFO["SCRIPT_Name"]..":</b></font> <font color=\"#FFFFFF\">"..message.."</font>")
end
if SCRIPT_UPDATER["Activate"] then
	local OnlineVersion = GetWebResult(SCRIPT_UPDATER["URL_HOST"], SCRIPT_UPDATER["URL_VERSION"])
	if OnlineVersion then
		local OnlineVersion = type(tonumber(OnlineVersion)) == "number" and tonumber(OnlineVersion) or nil
		if OnlineVersion then
			if tonumber(SCRIPT_INFO["Version"]) < OnlineVersion then
				PrintMessage("New version available "..OnlineVersion..". Downloading the latest version.")
				DownloadFile(SCRIPT_UPDATER["URL_HOST"]..SCRIPT_UPDATER["URL_PATH"],SCRIPT_PATH..GetCurrentEnv().FILE_NAME,function() PrintMessage("Successfully updated. Previous Version: "..SCRIPT_INFO["Version"].." -> "..OnlineVersion..". Please Reload [F9 x2] to use the latest version") end)
			end
		end
	end
end
for LIBRARY, LIBRARY_URL in pairs(SCRIPT_LIBS) do
	if FileExist(LIB_PATH..LIBRARY..".lua") then
		require(LIBRARY)
	else
		DownloadFile(LIBRARY_URL,LIB_PATH..".lua")
	end
end
