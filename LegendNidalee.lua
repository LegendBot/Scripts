local version = 0.001
if not VIP_USER or myHero.charName ~= "Nidalee" then return end --[[Disables the script if not VIP or not playing Nidalee]]
--{
	function Initiate()
		local scriptName = "Nidalee" --[[Variable used for functions within the Initiate function]]
		printMessage = function(message) print("<font color=\"#00A300\"><b>"..scriptName..":</b></font> <font color=\"#FFFFFF\">"..message.."</font>") end --[[Replaces the standard print/PrintChat function to make the script look nicer]]
		if os.time() > os.time{year=2014, month=6, day=30, hour=0, sec=1} then
			printMessage("A fail safe has disabled the script, contact the Author for access")
			return true --[[Stops the script after a certain date, allows the author to update the script without people complaining about bugs]]
		end
		if FileExist(LIB_PATH.."SourceLib.lua") then
			require 'SourceLib' --[[Loads the SourceLib library from your Common folder]]
		else
			printMessage("Downloading SourceLib, please wait whilst the required library is being downloaded.")
			DownloadFile("https://raw.github.com/TheRealSource/public/master/common/SourceLib.lua",LIB_PATH.."SourceLib.lua", function() printMessage("SourceLib successfully downloaded, please reload (double [F9]).") end)
			return true --[[Stops the script after downloading SourceLib from an online directory]]
		end
		if FileExist(LIB_PATH.."Selector.lua") then
			require 'Selector' --[[Loads the Selector library from your Common folder]]
		else
			printMessage("Downloading Selector, please wait whilst the required library is being downloaded.")
			DownloadFile("http://bit.ly/bol_selector_new",LIB_PATH.."Selector.lua", function() printMessage("Selector successfully downloaded, please reload (double [F9]).") end)
			return true --[[Stops the script after downloading Selector from an online directory]]
		end
		local libDownloader = Require(scriptName) --[[Initiates the SourceLib library downloader]]
		libDownloader:Add("VPrediction", "https://raw.github.com/honda7/BoL/master/Common/VPrediction.lua") --[[Loads or Downloads VPrediction based upon if you have the file or not]]
		libDownloader:Add("SOW",		 "https://raw.github.com/honda7/BoL/master/Common/SOW.lua") --[[Loads or Downloads SOW based upon if you have the file or not]]
		libDownloader:Check() --[[Checks the files above]]
		if libDownloader.downloadNeeded then
			printMessage("Downloading required libraries, please wait whilst the required files are being downloaded.")
			return true --[[Stops the script after downloading the required files]]
		end
		SourceUpdater(scriptName, version, "raw.github.com", "/LegendBot/Scripts/master/LegendNidalee.lua", SCRIPT_PATH..GetCurrentEnv().FILE_NAME, "/LegendBot/Scripts/master/LegendNidalee.version"):CheckUpdate()
		return false
	end
	if Initiate() then return end --[[Initates the function above and stops the script if required]]
--}
--{ Initiate Data Loads
	function NidaleeData()
		if myHero:GetSpellData(_Q).name == "JavelinToss" then
			Nidalee = { --[[Loads Human Form Data]]
				Q = {range = 1500, speed = 1300, delay = 0.25, width = 70, collision = true},
				W = {range = 900, speed = math.huge, delay = 0.9, width = 100, collision = false},
				E = {range = 600}
			}
			SpellQ = Spell(_Q, Nidalee.Q["range"], true):SetSkillshot(VP, SKILLSHOT_LINEAR, Nidalee.Q["width"], Nidalee.Q["delay"], Nidalee.Q["speed"], Nidalee.Q["collision"]) --[[SourceLib: Sets Q casting as a skillshot]]
			SpellW = Spell(_W, Nidalee.W["range"], true):SetSkillshot(VP, SKILLSHOT_CIRCULAR, Nidalee.W["width"], Nidalee.W["delay"], Nidalee.W["speed"], Nidalee.W["collision"]) --[[SourceLib: Sets W casting as a skillshot]]
			SpellE = Spell(_E, Nidalee.E["range"], true)
			return true
		else
			Nidalee = { --[[Loads Cougar Form Data]]
				Q = {range = myHero.range + 50},
				W = {range = 450, speed = math.huge, delay = 0.275, width = 200, collision = false},
				E = {range = 400, speed = math.huge, delay = 0.25, width = 250, collision = false}
			}			
			SpellQ = Spell(_Q, Nidalee.Q["range"], true)
			SpellW = Spell(_W, Nidalee.W["range"], true):SetSkillshot(VP, SKILLSHOT_CIRCULAR, Nidalee.W["range"], Nidalee.W["delay"], Nidalee.W["speed"], Nidalee.W["collision"]):SetHitChance(2) --[[SourceLib: Sets W casting as a skillshot]]
			SpellE = Spell(_E, Nidalee.E["range"], true):SetSkillshot(VP, SKILLSHOT_CIRCULAR, Nidalee.E["range"], Nidalee.E["delay"], Nidalee.E["speed"], Nidalee.E["collision"]):SetHitChance(2) --[[SourceLib: Sets E casting as a skillshot]]
			return false
		end
	end
--}
--{ Script Load
	function OnLoad()
		--{ Variables
			VP = VPrediction(true) --[[Loads VPrediction]]
			_G.VPredictionMenu.Mode = 2 --[[Sets the cast mode to medium]]
			OW = SOW(VP) --[[Loads Simple Orbwalker]]
			TS = SimpleTS(STS_LESS_CAST_MAGIC) --[[SourceLib Target Selector]]
			Selector.Instance() --[[Loads Selector]]
			NidaleeData() --[[Loads Spell Data]]
			OW:RegisterAfterAttackCallback(AutoAttackReset) --[[Registers Auto Attack Reset function into SOW]]
		--}
		--{ DamageCalculator
			DamageCalculator = DamageLib() --[[Initates the Damage Calculator]]
			DamageCalculator:RegisterDamageSource(_Q,_MAGIC,55,45,_MAGIC,_AP,0.65)
			DamageCalculator:RegisterDamageSource(_W,_MAGIC,80,45,_MAGIC,_AP,0.4)
			DamageCalculator:RegisterDamageSource(_CQ,_PHYSICAL,40,30,_PHYSICAL,_AD,1)
			DamageCalculator:RegisterDamageSource(_CW,_MAGIC,125,50,_MAGIC,_AP,0.4)
			DamageCalculator:RegisterDamageSource(_CE,_MAGIC,150,75,_MAGIC,AP,0.6)
		--}
		--{ Initate Menu
			Menu = scriptConfig("Nidalee","LegendNidalee")
			--{ Script Information
				Menu:addSubMenu("Nidalee: Script Details","Script")
				Menu.Script:addParam("Author","Author: Pain",5,"")
				Menu.Script:addParam("Credits","Credits: Turtlebot",5,"")
				Menu.Script:addParam("Version","Version: "..version,5,"")
			--}
			--{ General/Key Bindings
				Menu:addSubMenu("Nidalee: General","General")
				Menu.General:addParam("Combo","Combo",2,false,32)
				Menu.General:addParam("Heal","Heal",2,false,string.byte("A"))
				Menu.General:addParam("Harass","Harass",2,false,string.byte("C"))
			--}
			--{ Target Selector
				Menu:addSubMenu("Nidalee: Target Selector","TS")
				Menu.TS:addParam("TS","Target Selector",7,2,{ "AllClass", "SourceLib", "Selector", "SAC:Reborn", "MMA" })
				ts = TargetSelector(8,1500,1,false)
				ts.name = "AllClass TS"
				Menu.TS:addTS(ts)				
			--}
			--{ Orbwalking
				Menu:addSubMenu("Nidalee: Orbwalking","Orbwalking")
				OW:LoadToMenu(Menu.Orbwalking)
			--}
			--{ Combo Settings
				Menu:addSubMenu("Nidalee: Combo","Combo")
				Menu.Combo:addParam("H","[Human Settings]",5,"")
				Menu.Combo:addParam("HQ","Use Spear in 'Combo'",1,true)
				Menu.Combo:addParam("HW","Use Trap in 'Combo'",1,true)
				Menu.Combo:addParam("C","[Cougar Settings]",5,"")
				Menu.Combo:addParam("CQ","Use Takedown in 'Combo'",1,true)
				Menu.Combo:addParam("CW","Use Pounce in 'Combo'",1,true)
				Menu.Combo:addParam("CE","Use Swipe in 'Combo'",1,true)
			--}
			--{ Harass Settings
				Menu:addSubMenu("Nidalee: Harass","Harass")
				Menu.Harass:addParam("H","[Human Settings]",5,"")
				Menu.Harass:addParam("HQ","Use Spear in 'Harass'",1,true)
				Menu.Harass:addParam("HW","Use Trap in 'Harass'",1,true)
				Menu.Harass:addParam("C","[Cougar Settings]",5,"")
				Menu.Harass:addParam("CQ","Use Takedown in 'Harass'",1,true)
				Menu.Harass:addParam("CW","Use Pounce in 'Harass'",1,true)
				Menu.Harass:addParam("CE","Use Swipe in 'Harass'",1,true)
			--}
			--{ Heal Settings
				Menu:addSubMenu("Nidalee: Heal","Heal")
				Menu.Heal:addParam("G","[Global Settings]",5,"")
				Menu.Heal:addParam("GAlly","Ally to Heal",7,3,{ "Lowest Ally", "Ally Near Mouse", "Prioritized Ally"})
				Menu.Heal:addSubMenu("Heal: Priority Menu","Priority")
				for i = 1, heroManager.iCount do
					local hero = heroManager:GetHero(i)
					if hero.team == myHero.team then
						if hero == myHero then
							Menu.Heal.Priority:addParam(hero.charName,hero.charName,4,1,1,5,0)
						else
							Menu.Heal.Priority:addParam(hero.charName,hero.charName,4,2,1,5,0)
						end
					end
				end
				Menu.Heal:addParam("A","[Automatic Setting]",5,"")
				Menu.Heal:addParam("Auto","Automatically Heal Allies",1,false)
				Menu.Heal:addParam("AHealth","Minimum Health Percentage to Heal",4,60,0,100,0)
				Menu.Heal:addParam("AMana","Minimum Mana Percentage to Heal",4,60,0,100,0)
				Menu.Heal:addParam("M","[Manual Settings]",5,"")
				Menu.Heal:addParam("MHealth","Minimum Health Percentage to Heal",4,60,0,100,0)
				Menu.Heal:addParam("MMana","Minimum Mana Percentage to Heal",4,60,0,100,0)
			--}
			--{ Draw Settings
				Menu:addSubMenu("Nidalee: Draw","Draw")
				DrawHandler = DrawManager()
				DrawHandler:CreateCircle(myHero,Nidalee.Q["range"],1,{255, 255, 255, 255}):AddToMenu(Menu.Draw, "Q Range", true, true, true):LinkWithSpell(SpellQ, true)
				DrawHandler:CreateCircle(myHero,Nidalee.W["range"],1,{255, 255, 255, 255}):AddToMenu(Menu.Draw, "W Range", true, true, true):LinkWithSpell(SpellW, true)
				DrawHandler:CreateCircle(myHero,Nidalee.E["range"],1,{255, 255, 255, 255}):AddToMenu(Menu.Draw, "E Range", true, true, true):LinkWithSpell(SpellE, true)
				DamageCalculator:AddToMenu(Menu.Draw,{_Q,_W,_CQ,_CW,_CE})
			--}
			--{ Perma Show Settings
				Menu:addSubMenu("Nidalee: Perma Show","Perma")
				Menu.Perma:addParam("INFO","The following options require a restart",5,"")
				Menu.Perma:addParam("INFO2","[F9 x2] to take effect",5,"")
				Menu.Perma:addSubMenu("Perma Show: General","General")
				Menu.Perma.General:addParam("GC","Perma Show 'General > Combo'",1,true)
				Menu.Perma.General:addParam("GP","Perma Show 'General > Heal'",1,true)
				Menu.Perma.General:addParam("GH","Perma Show 'General > Harass'",1,true)
				if Menu.Perma.General.GC then Menu.General:permaShow("Combo") end
				if Menu.Perma.General.GP then Menu.General:permaShow("Heal") end
				if Menu.Perma.General.GH then Menu.General:permaShow("Harass") end
				Menu.Perma:addSubMenu("Perma Show: Combo","Combo")
				Menu.Perma.Combo:addParam("CH","Perma Show 'Combo > Human Settings'",1,false)
				Menu.Perma.Combo:addParam("CHQ","Perma Show 'Combo > Use Spear'",1,false)
				Menu.Perma.Combo:addParam("CHW","Perma Show 'Combo > Use Trap'",1,false)
				Menu.Perma.Combo:addParam("CC","Perma Show 'Combo > Cougar Settings",1,false)
				Menu.Perma.Combo:addParam("CCQ","Perma Show 'Combo > Use Takedown'",1,false)
				Menu.Perma.Combo:addParam("CCW","Perma Show 'Combo > Use Pounce'",1,false)
				Menu.Perma.Combo:addParam("CCE","Perma Show 'Combo > Use Swipe'",1,false)
				if Menu.Perma.Combo.CH then Menu.Combo:permaShow("H") end
				if Menu.Perma.Combo.CHQ then Menu.Combo:permaShow("HQ") end
				if Menu.Perma.Combo.CHW then Menu.Combo:permaShow("HW") end
				if Menu.Perma.Combo.CC then Menu.Combo:permaShow("C") end
				if Menu.Perma.Combo.CCQ then Menu.Combo:permaShow("CQ") end
				if Menu.Perma.Combo.CCW then Menu.Combo:permaShow("CW") end
				if Menu.Perma.Combo.CCE then Menu.Combo:permaShow("CE") end
				Menu.Perma:addSubMenu("Perma Show: Harass","Harass")
				Menu.Perma.Harass:addParam("HH","Perma Show 'Harass > Human Settings'",1,false)
				Menu.Perma.Harass:addParam("HHQ","Perma Show 'Harass > Use Spear'",1,false)
				Menu.Perma.Harass:addParam("HHW","Perma Show 'Harass > Use Trap'",1,false)
				Menu.Perma.Harass:addParam("HC","Perma Show 'Harass > Cougar Settings",1,false)
				Menu.Perma.Harass:addParam("HCQ","Perma Show 'Harass > Use Takedown'",1,false)
				Menu.Perma.Harass:addParam("HCW","Perma Show 'Harass > Use Pounce'",1,false)
				Menu.Perma.Harass:addParam("HCE","Perma Show 'Harass > Use Swipe'",1,false)
				if Menu.Perma.Harass.HH then Menu.Harass:permaShow("H") end
				if Menu.Perma.Harass.HHQ then Menu.Harass:permaShow("HQ") end
				if Menu.Perma.Harass.HHW then Menu.Harass:permaShow("HW") end
				if Menu.Perma.Harass.HC then Menu.Harass:permaShow("C") end
				if Menu.Perma.Harass.HCQ then Menu.Harass:permaShow("CQ") end
				if Menu.Perma.Harass.HCW then Menu.Harass:permaShow("CW") end
				if Menu.Perma.Harass.HCE then Menu.Harass:permaShow("CE") end
				Menu.Perma:addSubMenu("Perma Show: Heal","Heal")
				Menu.Perma.Heal:addParam("HG","Perma Show 'Heal > Global Settings'",1,false)
				Menu.Perma.Heal:addParam("HGA","Perma Show 'Heal > Ally to Heal'",1,false)
				Menu.Perma.Heal:addParam("HA","Perma Show 'Heal > Auto Settings'",1,false)
				Menu.Perma.Heal:addParam("HAH","Perma Show 'Heal > Auto Health Percentage'",1,false)
				Menu.Perma.Heal:addParam("HAM","Perma Show 'Heal > Auto Mana Percentage'",1,false)
				Menu.Perma.Heal:addParam("MA","Perma Show 'Heal > Manual Settings'",1,false)
				Menu.Perma.Heal:addParam("MAH","Perma Show 'Heal > Manual Health Percentage'",1,false)
				Menu.Perma.Heal:addParam("MAM","Perma Show 'Heal > Manual Mana Percentage'",1,false)
				if Menu.Perma.Heal.HG then Menu.Heal:permaShow("G") end
				if Menu.Perma.Heal.HGA then Menu.Heal:permaShow("GAlly") end
				if Menu.Perma.Heal.HA then Menu.Heal:permaShow("A") end
				if Menu.Perma.Heal.HAH then Menu.Heal:permaShow("AHealth") end
				if Menu.Perma.Heal.HAM then Menu.Heal:permaShow("AMana") end
				if Menu.Perma.Heal.MA then Menu.Heal:permaShow("M") end
				if Menu.Perma.Heal.MAH then Menu.Heal:permaShow("MHealth") end
				if Menu.Perma.Heal.MAM then Menu.Heal:permaShow("MMana") end
			--}
		--}
	end
--}
--{ Script Loop
	function OnTick()
		--{ Variables
			QMANA = GetSpellData(_Q).mana
			WMANA = GetSpellData(_W).mana
			Combat = Menu.General.Combo or Menu.General.Harass			
			QREADY = (SpellQ:IsReady() and ((Menu.General.Combo and (NidaleeData() and Menu.Combo.HQ) or (not NidaleeData() and Menu.Combo.CQ)) or (Menu.General.Harass and (NidaleeData() and Menu.Harass.HQ) or (not NidaleeData() and Menu.Combo.CQ))))
			WREADY = (SpellW:IsReady() and ((Menu.General.Combo and (NidaleeData() and Menu.Combo.HW) or (not NidaleeData() and Menu.Combo.CW)) or (Menu.General.Harass and (NidaleeData() and Menu.Harass.HW) or (not NidaleeData() and Menu.Combo.CW))))
			EREADY = (SpellE:IsReady() and ((Menu.General.Combo and not NidaleeData() and Menu.Combo.CE) or (Menu.General.Harass and not NidaleeData() and Menu.Harass.CE)))
			Target = GrabTarget()
			Ally = GrabAlly()
		--}
		--{ Combo and Harass
			if Combat and ValidTarget(Target) then
				OW:ForceTarget(Target)
				if NidaleeData() and DamageCalculator:IsKillable(Target,{_Q,_W}) then
					if DamageCalculator:IsKillable(Target,{_W}) and WREADY then
						SpellW:Cast(Target)
					elseif DamageCalculator:IsKillable(Target,{_Q}) and QREADY then
						SpellQ:Cast(Target)
					elseif QREADY and WREADY and QMANA + WMANA <= myHero.mana then
						SpellW:Cast(Target)
						SpellQ:Cast(Target)
					end
				elseif NidaleeData() then
					if QREADY then
						SpellQ:Cast(Target)
					end
					if WREADY then
						SpellW:Cast(Target)
					end
				elseif not NidaleeData() and DamageCalculator:IsKillable(Target,{_CQ,_CW,_CE}) then
					if DamageCalculator:IsKillable(Target,{_CE}) and EREADY then
						if isFacing(myHero, Target, 200) then
							SpellE:Cast(Target)
						end					
					elseif DamageCalculator:IsKillable(Target,{_CW}) and WREADY then
						if isFacing(myHero, Target, 200) then
							SpellW:Cast(Target)
						end
					elseif DamageCalculator:IsKillable(Target,{_CW,_CE}) and WREADY and EREADY then
						if isFacing(myHero, Target, 200) then							
							SpellE:Cast(Target)
							SpellW:Cast(Target)
						end
					end
				elseif not NidaleeData() then
					if EREADY then
						if isFacing(myHero, Target, 200) then
							SpellE:Cast(Target)
						end
					end
					if WREADY then
						if isFacing(myHero, Target, 200) then
							SpellW:Cast(Target)
						end
					end					
				end
			end
		--}
		--{ Healing
			if NidaleeData() and Ally ~= nil then
				if Menu.Heal.Auto then
					if (myHero.mana/myHero.maxMana * 100 > Menu.Heal.AMana) and (Ally.health/Ally.maxHealth * 100 < Menu.Heal.AHealth) then
						CastSpell(_E,Ally)
					end
				end
				if Menu.General.Heal then
					if (myHero.mana/myHero.maxMana * 100 > Menu.Heal.MMana) and (Ally.health/Ally.maxHealth * 100 < Menu.Heal.MHealth) then
						CastSpell(_E,Ally)
					end
				end
			end
		--}
	end
--}
--{ Auto Attack Reset
	function AutoAttackReset()
		if Target and Combat and QREADY then
			SpellQ:Cast(Target)
			OW:resetAA()
		end
	end
--}
--{ Target Selector
	function GrabTarget()
		if _G.MMA_Loaded and Menu.TS.TS == 5 then
			return _G.MMA_ConsideredTarget(MaxRange())
		elseif _G.AutoCarry and Menu.TS.TS == 4 then
			return _G.AutoCarry.Crosshair:GetTarget()
		elseif _G.Selector_Enabled and Menu.TS.TS == 3 then
			return Selector.GetTarget(SelectorMenu.Get().mode, nil, {distance = MaxRange()})
		elseif Menu.TS.TS == 2 then
			return TS:GetTarget(MaxRange())
		else
			ts.range = MaxRange()
			ts:update()
			return ts.target
		end
	end
	function MaxRange()
		if NidaleeData() then
			if QREADY then
				return Nidalee.Q["range"]
			elseif WREADY then
				return Nidalee.W["range"]
			elseif EREADY then
				return Nidalee.E["range"]
			else
				return myHero.range + 50
			end
		else
			if EREADY then
				return Nidalee.E["range"]
			elseif WREADY then
				return Nidalee.W["range"]
			else
				return myHero.range + 50
			end
		end
	end
--}
--{ Ally Selector
	function GrabAlly()
		if Menu.Heal.GAlly == 1 then
			return LowestAlly()
		elseif Menu.Heal.GAlly == 2 then
			return NearMouseAlly()
		elseif Menu.Heal.GAlly == 3 then
			return PrioritizedAlly()
		end
	end
	function LowestAlly()
		for i = 1, heroManager.iCount do
			hero = heroManager:GetHero(i)
			if hero.team == myHero.team and not hero.dead and GetDistance(myHero,hero) <= 900 then
				if heroTarget == nil then
					heroTarget = hero
				elseif hero.health/hero.maxHealth < heroTarget.health/heroTarget.maxHealth then
					heroTarget = hero
				end
			end
		end
		return heroTarget
	end
	function NearMouseAlly()
		for i = 1, heroManager.iCount do
			hero = heroManager:GetHero(i)
			if hero.team == myHero.team and not hero.dead and GetDistance(myHero,hero) <= 900 then
				if heroTarget == nil then
					heroTarget = hero
				elseif GetDistance(myHero,hero) < GetDistance(myHero,heroTarget) then
					heroTarget = hero
				end
			end
		end
		return heroTarget
	end
	function PrioritizedAlly()
		for i = 1, heroManager.iCount do
			hero = heroManager:GetHero(i)
			if hero.team == myHero.team and not hero.dead and GetDistance(myHero,hero) <= 900 then
				if heroTarget == nil then
					heroTarget = hero
				elseif Menu.Heal.Priority[hero.charName] < Menu.Heal.Priority[heroTarget] then
					heroTarget = hero
				end
			end
		end
		return heroTarget
	end
--}
--{ Direction Facing
	function isFacing(source, target, lineLength)
		local sourceVector = Vector(source.visionPos.x, source.visionPos.z)
		local sourcePos = Vector(source.x, source.z)
		sourceVector = (sourceVector-sourcePos):normalized()
		sourceVector = sourcePos + (sourceVector*(GetDistance(target, source)))
		return GetDistanceSqr(target, {x = sourceVector.x, z = sourceVector.y}) <= (lineLength and lineLength^2 or 90000)
	end
--}
