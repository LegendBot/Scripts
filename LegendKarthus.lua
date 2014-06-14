if not VIP_USER or myHero.charName ~= "Karthus" then return end
local SCRIPT_INFO = {
	["Name"] = "LegendKarthus",
	["Version"] = 0.006,
	["Author"] = {
		["Turtlebot"] = "http://botoflegends.com/forum/user/18902-"
	},
	["Credits"] = {
		["Pain"] = "http://botoflegends.com/forum/user/2005-"
	},		
}
local SCRIPT_UPDATER = {
	["Activate"] = true,
	["Script"] = SCRIPT_PATH..GetCurrentEnv().FILE_NAME,
	["URL_HOST"] = "raw.github.com",
	["URL_PATH"] = "/LegendBot/Scripts/master/LegendKarthus.lua",
	["URL_VERSION"] = "/LegendBot/Scripts/master/Versions/LegendKarthus.version"
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
--{ Initiate Script (Checks for updates)
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
	PrintMessage("Loaded")
--}
--{ Initiate Data Load
	local Karthus = {
		Q = {range = 875, speed = 1700, delay = 0.5, width = 100, collision = false, DamageType = _MAGIC, BaseDamage = 40, DamagePerLevel = 20, ScalingStat = _MAGIC, PercentScaling = _AP, Condition = 0.30, Extra = function() return (myHero:CanUseSpell(_Q) == READY) end},
		W = {range = 1000, speed = 1600, delay = 0.5, width = 450, collision = false, DamageType = _MAGIC, BaseDamage = 0, DamagePerLevel = 0, ScalingStat = _MAGIC, PercentScaling = _AP, Condition = 0.0, Extra = function() return (myHero:CanUseSpell(_W) == READY) end},
		E = {range = 550, speed = 1000, delay = 0.5, collision = false, DamageType = _MAGIC, BaseDamage = 30, DamagePerLevel = 20, ScalingStat = _MAGIC, PercentScaling = _AP, Condition = 0.2, Extra = function() return (myHero:CanUseSpell(_E) == READY) end},
		R = {range = math.huge, speed = math.huge, delay = 3.0, DamageType = _MAGIC, BaseDamage = 150, DamagePerLevel = 100, ScalingStat = _MAGIC, PercentScaling = _AP, Condition = .6, Extra = function() return (myHero:CanUseSpell(_R) == READY) end}
	}
--}
--{ Script Load
	function OnLoad()
		--{ Variables
			VP = VPrediction(true)
			OW = SOW(VP)
			OW:RegisterAfterAttackCallback(AutoAttackReset)
			TS = SimpleTS(STS_LESS_CAST_MAGIC)
			Selector.Instance()
			SpellQ = Spell(_Q, Karthus.Q["range"]):SetSkillshot(VP, SKILLSHOT_CIRCULAR, Karthus.Q["width"], Karthus.Q["delay"], Karthus.Q["speed"], Karthus.Q["collision"])
			SpellW = Spell(_W, Karthus.W["range"]):SetSkillshot(VP, SKILLSHOT_LINEAR, Karthus.Q["width"], Karthus.Q["delay"], Karthus.Q["speed"], Karthus.Q["collision"])
			SpellE = Spell(_E, Karthus.E["range"])
			SpellR = Spell(_R, Karthus.R["range"])
			EnemyMinions = minionManager(MINION_ENEMY, Karthus.Q["range"], myHero, MINION_SORT_MAXHEALTH_DEC)
			JungleMinions = minionManager(MINION_JUNGLE, Karthus.Q["range"], myHero, MINION_SORT_MAXHEALTH_DEC)
		--}
		--{ DamageCalculator
			DamageCalculator = DamageLib()
			DamageCalculator:RegisterDamageSource(_Q, Karthus.Q["DamageType"], Karthus.Q["BaseDamage"], Karthus.Q["DamagePerLevel"], Karthus.Q["ScalingStat"], Karthus.Q["PercentScaling"], Karthus.Q["Condition"], Karthus.Q["Extra"])
			DamageCalculator:RegisterDamageSource(_W, Karthus.W["DamageType"], Karthus.W["BaseDamage"], Karthus.W["DamagePerLevel"], Karthus.W["ScalingStat"], Karthus.W["PercentScaling"], Karthus.W["Condition"], Karthus.W["Extra"])
			DamageCalculator:RegisterDamageSource(_E, Karthus.E["DamageType"], Karthus.E["BaseDamage"], Karthus.E["DamagePerLevel"], Karthus.E["ScalingStat"], Karthus.E["PercentScaling"], Karthus.E["Condition"], Karthus.E["Extra"])
			DamageCalculator:RegisterDamageSource(_R, Karthus.R["DamageType"], Karthus.R["BaseDamage"], Karthus.R["DamagePerLevel"], Karthus.R["ScalingStat"], Karthus.R["PercentScaling"], Karthus.R["Condition"], Karthus.R["Extra"])
		--}
				--{ Initiate Menu
			Menu = scriptConfig("Karthus","LegendKarthus")
			Menu:addParam("Author","Author: Turtle",5,"")
			Menu:addParam("Version","Version: "..SCRIPT_INFO["Version"],5,"")
			--{ General/Key Bindings
				Menu:addSubMenu("Karthus: General","General")
				Menu.General:addParam("Combo","Combo",2,false,32)
				Menu.General:addParam("Harass","Harass (Mixed Mode)",2,false,string.byte("C"))
				Menu.General:addParam("LastHit","Last Hit Creeps",2,false,string.byte("X"))
				Menu.General:addParam("LaneClear","Lane Clear",2,false,string.byte("V"))
				Menu.General:addParam("JungleFarm","Jungle Farm",2,false,string.byte("G"))
			--}
			--{ Target Selector			
				Menu:addSubMenu("Karthus: Target Selector","TS")
				Menu.TS:addParam("TS","Target Selector",7,2,{ "AllClass", "SourceLib", "Selector", "SAC:Reborn", "MMA" })
				ts = TargetSelector(8,Karthus.R["range"],1,false)
				ts.name = "AllClass TS"
				Menu.TS:addTS(ts)				
			--}
			--{ Orbwalking
				Menu:addSubMenu("Karthus: Orbwalking","Orbwalking")
				OW:LoadToMenu(Menu.Orbwalking)
				Menu.Orbwalking.Mode0 = false
			--}
			--{	Combo Settings
				Menu:addSubMenu("Karthus: Combo","Combo")
				Menu.Combo:addParam("Q","Use Q in 'Combo'",1,true)
				Menu.Combo:addParam("W","Use W in 'Combo'",1,true)
				Menu.Combo:addParam("E","Use E in 'Combo'",1,true)
				Menu.Combo:addParam("R", "Use R in'Combo'",3, true, GetKey("G"))
			--}
			--{ Harass Settings
				Menu:addSubMenu("Karthus: Harass (Mixed Mode)","Harass")
				Menu.Harass:addParam("Q","Use Q in 'Harass'",1,true)
				Menu.Harass:addParam("Qfarm","Farm Q in 'Harass'",1,true) 
				Menu.Harass:addParam("W","Use W in 'Harass'",1,true)
				Menu.Harass:addParam("E","Use E in 'Harass'",1,false)
			--}
			--{ Farm Settings
				Menu:addSubMenu("Karthus: Farm","Farm")
				Menu.Farm:addParam("Mana","Minimum Mana Percentage",4,70,0,100,0)
				Menu.Farm:addParam("Q","Use Q in 'Farm'",1,true)
				Menu.Farm:addParam("Qclear","Use Q in 'Lane Clear'",1,true)
			--}
			--{ Jungle Farm Settings
				Menu:addSubMenu("Karthus: JungleFarm","JungleFarm")
	    	    Menu.JungleFarm:addParam("JungleQ", "Jungle Q", SCRIPT_PARAM_ONOFF, true)
	        	Menu.JungleFarm:addParam("JungleE", "Jungle E", SCRIPT_PARAM_ONOFF, false)
	        	--}
			--{ Extra Settings
				Menu:addSubMenu("Karthus: Extra","Extra")
				Menu.Extra:addParam("Tick","Tick Suppressor (Tick Delay)",4,20,1,50,0)
				Menu.Extra:addParam("RCount","Enemies to Kill w/ Ulti",7,2,{"One Enemy","Two Enemies","Three Enemies","Four Enemies","Five Enemies"})
                Menu.Extra:addParam("Notify","Ping when enemy can be Requiem'd",1,true)
			--}
			--{ Draw Settings
				Menu:addSubMenu("Karthus: Draw","Draw")
				DrawHandler = DrawManager()
				DrawHandler:CreateCircle(myHero,Karthus.Q["range"],1,{255, 255, 255, 255}):AddToMenu(Menu.Draw, "Q Range", true, true, true):LinkWithSpell(SpellQ, true)
				DrawHandler:CreateCircle(myHero,Karthus.W["range"],1,{255, 255, 255, 255}):AddToMenu(Menu.Draw, "W Range", true, true, true):LinkWithSpell(SpellW, true)
				DrawHandler:CreateCircle(myHero,Karthus.E["range"],1,{255, 255, 255, 255}):AddToMenu(Menu.Draw, "E Range", true, true, true):LinkWithSpell(SpellE, true)
				Menu.Draw:addSubMenu("Karthus R","Ulti")
				Menu.Draw.Ulti:addParam("X","X position for Text",4,50,0,WINDOW_W,0)
				Menu.Draw.Ulti:addParam("Y","Y position for Text",4,50,0,WINDOW_H,0)
				DamageCalculator:AddToMenu(Menu.Draw,{_Q,_W,_E,_R,_AA})
			--}
			--{ Perma Show Settings
				Menu:addSubMenu("Karthus: Perma Show","Perma")
				Menu.Perma:addParam("INFO","The following options require a restart [F9 x2] to take effect",5,"")
				Menu.Perma:addParam("GC","Perma Show 'General > Combo'",1,true)				
				Menu.Perma:addParam("GF","Perma Show 'General > Farm'",1,true)
				Menu.Perma:addParam("GH","Perma Show 'General > Harass'",1,true)
				if Menu.Perma.GC then Menu.General:permaShow("Combo") end
				if Menu.Perma.GF then Menu.General:permaShow("LastHit") end
				if Menu.Perma.GH then Menu.General:permaShow("Harass") end
				Menu.Perma:addParam("CQ","Perma Show 'Combo > Q'",1,false)
				Menu.Perma:addParam("CW","Perma Show 'Combo > W'",1,false)
				Menu.Perma:addParam("CE","Perma Show 'Combo > E'",1,false)
				Menu.Perma:addParam("CR","Perma Show 'Combo > R'",1,false)
				if Menu.Perma.CQ then Menu.Combo:permaShow("Q") end
				if Menu.Perma.CW then Menu.Combo:permaShow("W") end
				if Menu.Perma.CE then Menu.Combo:permaShow("E") end
				if Menu.Perma.CR then Menu.Combo:permaShow("R") end
				Menu.Perma:addParam("HQ","Perma Show 'Harass > Q'",1,false)
				Menu.Perma:addParam("HF","Perma Show 'Harass > Qfarm'",1,false)
				Menu.Perma:addParam("HW","Perma Show 'Harass > W'",1,false)
				Menu.Perma:addParam("HE","Perma Show 'Harass > E'",1,false)
				if Menu.Perma.HQ then Menu.Harass:permaShow("Q") end
				if Menu.Perma.HF then Menu.Harass:permaShow("Qfarm") end
				if Menu.Perma.HW then Menu.Harass:permaShow("W") end
				if Menu.Perma.HE then Menu.Harass:permaShow("E") end
				Menu.Perma:addParam("FQ","Perma Show 'Farm > Q'",1,false)
				Menu.Perma:addParam("FC","Perma Show 'Farm > Qclear'",1,false)
				if Menu.Perma.FQ then Menu.Farm:permaShow("Q") end
				if Menu.Perma.FC then Menu.Farm:permaShow("Qclear") end
				Menu.Perma:addParam("JQ","Perma Show 'JungleFarm > JungleQ'",1,false)
				Menu.Perma:addParam("JE","Perma Show 'JungleFarm > JungleE'",1,false)
				if Menu.Perma.JQ then Menu.JungleFarm:permaShow("JungleQ") end
				if Menu.Perma.JE then Menu.JungleFarm:permaShow("JungleE") end
				Menu.Perma:addParam("ET","Perma Show 'Extra > Tick Delay'",1,false)
				Menu.Perma:addParam("ER","Perma Show 'Extra > R Count'",1,false)
				Menu.Perma:addParam("EN","Perma Show 'Extra > Notify'",1,false)
				if Menu.Perma.ET then Menu.Extra:permaShow("Tick") end
				if Menu.Perma.ER then Menu.Extra:permaShow("RCount") end
				if Menu.Perma.EN then Menu.Extra:permaShow("Notify") end
			--}
		--}
	end
--}
--{ Script Loop
	function OnTick()
		--{ Tick Manager
			if GetTickCount() < (TickSuppressor or 0) then return end
			TickSuppressor = GetTickCount() + Menu.Extra.Tick
		--}
		--{ Variables
			QMANA = GetSpellData(_Q).mana
			WMANA = GetSpellData(_W).mana
			EMANA = GetSpellData(_E).mana
			RMANA = GetSpellData(_R).mana
			Farm = (Menu.General.LastHit or Menu.General.LaneClear) and Menu.Farm.Mana <= myHero.mana / myHero.maxMana * 100
			JungleFarm = Menu.General.JungleFarm
			Combat = Menu.General.Combo or Menu.General.Harass
			QREADY = (SpellQ:IsReady() and ((Menu.General.Combo and Menu.Combo.Q) or (Menu.General.Harass and Menu.Harass.Q) or (Menu.General.JungleFarm and Menu.JungleFarm.JungleQ) or (Farm and (Menu.Farm.Q or Menu.Farm.Qclear)) ))
			WREADY = (SpellW:IsReady() and ((Menu.General.Combo and Menu.Combo.W) or (Menu.General.Harass and Menu.Harass.W) ))
			EREADY = (SpellE:IsReady() and ((Menu.General.Combo and Menu.Combo.E) or (Menu.General.JungleFarm and Menu.JungleFarm.JungleE) or (Menu.General.Harass and Menu.Harass.E) or (Farm and Menu.Farm.E) ))
			RREADY = (SpellR:IsReady() and ((Menu.General.Combo and Menu.Combo.R) ) and Menu.Extra.RCount <= RCountEnemyHeroInRange(Karthus.R["range"], myHero))
			Target = GrabTarget()
		--}	
		--{ Combo and Harass
			if Combat then
				--{ Defile Manager
					if myHero:GetSpellData(_E).toggleState == 2 and (not Target or (Target and GetDistance(myHero,Target) >= Karthus.E["range"])) then
						CastSpell(_E)
					end
				--}
				if Target then
					if DamageCalculator:IsKillable(Target,{_Q,_E,_W,_R,_AA}) then
						if DamageCalculator:IsKillable(Target,{_Q}) and QREADY then
							SpellQ:Cast(Target) 
						elseif DamageCalculator:IsKillable(Target,{_R}) and RREADY then
							SpellR:Cast(Target) 
						elseif DamageCalculator:IsKillable(Target,{_Q,_W}) and QREADY and WREADY then
							SpellQ:Cast(Target) 
							SpellW:Cast(Target)
							--
						elseif DamageCalculator:IsKillable(Target,{_Q,_W,_E}) and QREADY and WREADY and EREADY then
					    	SpellQ:Cast(Target) 
						    SpellW:Cast(Target)
							if myHero:GetSpellData(_E).toggleState == 1 then SpellE:Cast(Target) end
							--
						elseif DamageCalculator:IsKillable(Target,{_Q,_W,_E,_R}) and QREADY and WREADY and RREADY then
					    	SpellQ:Cast(Target) 
						    SpellW:Cast(Target)
						    if myHero:GetSpellData(_E).toggleState == 1 then SpellE:Cast(Target) end
							SpellR:Cast(Target)
						else
							if QREADY then
								SpellQ:Cast(Target) 
							end
							if WREADY then
								SpellW:Cast(Target)
							end
							if EREADY then
								if myHero:GetSpellData(_E).toggleState == 1 then SpellE:Cast(Target) end
							end
						end
					else
						if QREADY then
							SpellQ:Cast(Target) 
						end
						if WREADY then
							SpellW:Cast(Target)
						end
						if EREADY then
							if myHero:GetSpellData(_E).toggleState == 1 then SpellE:Cast(Target) end
						end
					end
					if Menu.Orbwalking.Enabled and (Menu.Orbwalking.Mode0 or Menu.Orbwalking.Mode1) then
						OW:ForceTarget(Target)
					end
				end
			end
		--}	
		--{ Mixed Mode
		    if Menu.General.Harass and not Target then
				if Menu.Harass.Qfarm and SpellQ:IsReady() then
	    			EnemyMinions:update()
					for i, Minion in pairs(EnemyMinions.objects) do
						if ValidTarget(Minion) and GetDistance(myHero,Minion) <= Karthus.Q["range"] then
							if DamageCalculator:IsKillable(Minion,{_Q}) then
								SpellQ:Cast(Minion)
							end
						end
					end
    			end
		    end
		--}
		--{ Farming
			if Farm then
				EnemyMinions:update()
				for i, Minion in pairs(EnemyMinions.objects) do
					if ValidTarget(Minion) then
						if QREADY and (DamageCalculator:IsKillable(Minion,{_Q}) or Menu.General.LaneClear) then
							SpellQ:Cast(Minion)
						end
					end
				end
			end
		--}
		--{ Jungle Farming
			if JungleFarm then
				JungleMinions:update()
					JungleCreep = JungleMinions.objects[1]
					if ValidTarget(JungleCreep) then
						if QREADY and EREADY then 
							SpellQ:Cast(JungleCreep)
							SpellE:Cast(JungleCreep)
						elseif QREADY then
							SpellQ:Cast(JungleCreep)
						end
					end
				end
		--}	
		if GetTickCount() > (PingTick or 0) then
			PingTick = GetTickCount() + 500
			if Menu.Extra.Notify then
				for i = 1, heroManager.iCount, 1 do
					local hero = heroManager:getHero(i)
					if ValidTarget(hero) and DamageCalculator:IsKillable(hero,{_R}) then
						if PingOnce ~= true then
							PingSignal(PING_ALERT,hero.x,hero.y,hero.z,2) 
							PingOnce = true
							DelayAction(function() PingOnce = false end, 5)
						end
					end
				end
			end
		end
	end
--}
	function OnDraw()
		DrawText(RCountEnemyHeroInRange(Karthus.R["range"],myHero).." players can by killed by Requiem.",15,Menu.Draw.Ulti.X,Menu.Draw.Ulti.Y,ARGB(255,1,255,74))
	end
--{ Target Selector
	function GrabTarget()
		if _G.MMA_Loaded and Menu.TS.TS == 5 then
			return _G.MMA_ConsideredTarget(MaxRange()) 
		elseif _G.AutoCarry and Menu.TS.TS == 4 then
			return _G.AutoCarry.Crosshair:GetTarget()
		elseif _G.Selector_Enabled and Menu.TS.TS == 3 then
			return Selector.GetTarget(SelectorMenu.Get().mode, 'AP', {distance = MaxRange()})
		elseif Menu.TS.TS == 2 then
			return TS:GetTarget(MaxRange())
		elseif Menu.TS.TS == 1 then
			ts.range = MaxRange()
			ts:update()
			return ts.target
		end
	end
--}
--{ Target Selector Range
	function MaxRange()
		if WREADY then
			return Karthus.W["range"]
		end
		if QREADY then
			return Karthus.Q["range"]
		end
		if RREADY then
			return Karthus.R["range"]
		end	
		if EREADY then
			return Karthus.E["range"]
		end
		return myHero.range + 50
	end
--}
function RCountEnemyHeroInRange(range, object)
    object = object or myHero
    range = range and range * range or myHero.range * myHero.range
    local enemyInRange = 0
    for i = 1, heroManager.iCount, 1 do
        local hero = heroManager:getHero(i)
        if ValidTarget(hero) and GetDistanceSqr(object, hero) <= range and DamageCalculator:IsKillable(hero,{_R}) then
            enemyInRange = enemyInRange + 1
        end
    end
    return enemyInRange
end
