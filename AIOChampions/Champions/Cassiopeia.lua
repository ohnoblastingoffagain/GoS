local function IsValid1(unit, range)
    if (unit and unit.valid and unit.isTargetable and unit.alive and unit.visible and unit.networkID and unit.pathing and unit.health > 0) and myHero.pos:DistanceTo(unit.pos) <= (range + myHero.boundingRadius + unit.boundingRadius) then
        return true;
    end
    return false;
end

local function GetEnemyHeroes()
    local _EnemyHeroes = {}
    for i = 1, GameHeroCount() do
        local unit = GameHero(i)
        if unit.isEnemy then
            TableInsert(_EnemyHeroes, unit)
        end
    end
    return _EnemyHeroes
end 

local function HasPoison(unit)
	for i = 0, unit.buffCount do 
	local buff = unit:GetBuff(i)
		if buff.type == 23 and GameTimer() < buff.expireTime - 0.141  then
			return true
		end
	end
	return false
end

local function EnemiesNear(pos,range)
	local pos = pos.pos
	local N = 0
	for i, hero in ipairs(GetEnemyHeroes()) do
		local Range = range * range
		if IsValid(hero) and pos:DistanceTo(hero.pos) < Range then
			N = N + 1
		end
	end
	return N	
end

local function MinionsNear(pos,range)
	local pos = pos.pos
	local N = 0
		for i = 1, GameMinionCount() do 
		local Minion = GameMinion(i)
		local Range = range * range
		if IsValid1(Minion, 800) and Minion.team == TEAM_ENEMY and Minion.pos:DistanceTo(pos) < Range then
			N = N + 1
		end
	end
	return N	
end

local function EnemyInRange(range)
	local count = 0
	for i, target in ipairs(GetEnemyHeroes()) do
		if target.pos:DistanceTo(myHero.pos) < range and IsValid(target) then 
			count = count + 1
		end
	end
	return count
end

function LoadScript()
	Menu = MenuElement({type = MENU, id = "PussyAIO".. myHero.charName, name = myHero.charName})
	Menu:MenuElement({name = " ", drop = {"Version 0.10"}})	
		Menu:MenuElement({name = " ", drop = {"General Settings"}})
		
		--Prediction
		Menu:MenuElement({type = MENU, id = "Pred", name = "Prediction"})
		Menu.Pred:MenuElement({name = " ", drop = {"After change Pred.Typ reload 2x F6"}})	
		Menu.Pred:MenuElement({id = "Change", name = "Change Prediction Typ", value = 3, drop = {"Gamsteron Prediction", "Premium Prediction", "GGPrediction"}})	
		Menu.Pred:MenuElement({id = "PredQ", name = "Hitchance[Q]", value = 1, drop = {"Normal", "High", "Immobile"}})
		Menu.Pred:MenuElement({id = "PredR", name = "Hitchance[R]", value = 1, drop = {"Normal", "High", "Immobile"}})		
		
		--RSetting
		Menu:MenuElement({type = MENU, id = "R", name = "R Range Setting"})
		Menu.R:MenuElement({id = "Rrange", name = "Max CastR Range", value = 780, min = 100, max = 825, identifier = "range"})		
		
		--Combo   
		Menu:MenuElement({type = MENU, id = "c", name = "Combo"})		
		Menu.c:MenuElement({id = "Q", name = "Use Q", value = true})
		Menu.c:MenuElement({id = "W", name = "Use W", value = true})
		Menu.c:MenuElement({id = "E", name = "Use E", value = true})
		Menu.c:MenuElement({id = "SR", name = "Manual R ", key = string.byte("A")})
		Menu.c:MenuElement({id = "R", name = "Use R ", value = true})
		Menu.c:MenuElement({id = "Count", name = "Min Amount to hit R", value = 2, min = 1, max = 5, step = 1})
		Menu.c:MenuElement({id = "P", name = "Use Panic R and Ghost", value = true})
		Menu.c:MenuElement({id = "HP", name = "Min HP % to Panic R", value = 30, min = 0, max = 100, step = 1})
		Menu.c:MenuElement({name = " ", drop = {"-------------------------------------------"}})		
		Menu.c:MenuElement({name = " ", drop = {"-------------------------------------------"}})		
		Menu.c:MenuElement({name = " ", drop = {"Block AutoAttack Settings"}})		
		Menu.c:MenuElement({name = " ", drop = {"Turn off AutoAttack in LoL Options/Game/"}})
		Menu.c:MenuElement({id = "Block", name = "Block AA in Combo for E", value = true})
		Menu.c:MenuElement({id = "Cd", name = "Block AA if Cooldown E lower than", value = 0.55, min = 0, max = 0.8, step = 0.01})		
		
		--Harass
		Menu:MenuElement({type = MENU, id = "h", name = "Harass"})
		Menu.h:MenuElement({id = "Q", name = "UseQ", value = true})
		Menu.h:MenuElement({id = "E", name = "UseE only poisend", value = true})		
		
		--Clear
		Menu:MenuElement({type = MENU, id = "w", name = "Clear"})
		Menu.w:MenuElement({id = "Q", name = "Use Q", value = true})
		Menu.w:MenuElement({id = "W", name = "Use W", value = true})
		Menu.w:MenuElement({id = "Count", name = "Min Minions to hit W", value = 3, min = 1, max = 5, step = 1})		
		Menu.w:MenuElement({id = "E", name = "Auto E Toggle Key", key = 84, toggle = true, value = true})
		Menu.w:MenuElement({id = "E2", name = "Auto E off in Combo Mode", value = true})		
		
		--JungleClear
		Menu:MenuElement({type = MENU, id = "j", name = "JungleClear"})
		Menu.j:MenuElement({id = "Q", name = "Use Q", value = true})
		Menu.j:MenuElement({id = "W", name = "Use W", value = true})
		Menu.j:MenuElement({id = "E", name = "Use E[poisend or Lasthit]", value = true})		
		
		--KillSteal
		Menu:MenuElement({type = MENU, id = "ks", name = "KillSteal"})
		Menu.ks:MenuElement({id = "Q", name = "UseQ", value = true})
		Menu.ks:MenuElement({id = "W", name = "UseW", value = true})
		Menu.ks:MenuElement({id = "E", name = "UseE", value = true})
	

		--Engage
		Menu:MenuElement({type = MENU, id = "kill", name = "Engage"})
		Menu.kill:MenuElement({id = "Eng", name = "EngageKill 1vs1", key = string.byte("Z")})
		
		--Mana
		Menu:MenuElement({type = MENU, id = "m", name = "Mana Settings"})
		Menu.m:MenuElement({name = " ", drop = {"Harass [%]"}})
		Menu.m:MenuElement({id = "Q", name = "Q Mana", value = 10, min = 0, max = 100, step = 1})
		Menu.m:MenuElement({id = "W", name = "W Mana", value = 10, min = 0, max = 100, step = 1})
		Menu.m:MenuElement({id = "E", name = "E Mana", value = 5, min = 0, max = 100, step = 1})
		Menu.m:MenuElement({id = "R", name = "R Mana", value = 5, min = 0, max = 100, step = 1})		
		Menu.m:MenuElement({name = " ", drop = {"Lane/JungleClear [%]"}})
		Menu.m:MenuElement({id = "QW", name = "Q Mana", value = 10, min = 0, max = 100, step = 1})
		Menu.m:MenuElement({id = "WW", name = "W Mana", value = 10, min = 0, max = 100, step = 1})
		Menu.m:MenuElement({id = "EW", name = "E Mana", value = 10, min = 0, max = 100, step = 1})
		
		Menu:MenuElement({name = " ", drop = {"Advanced Settings"}})

		--Drawings
		Menu:MenuElement({type = MENU, id = "d", name = "Drawings"})
		Menu.d:MenuElement({id = "ON", name = "Enable Drawings", value = true})
		Menu.d:MenuElement({type = MENU, id = "XY", name = "Text Pos Settings"})	
		Menu.d.XY:MenuElement({id = "Text", name = "Draw AutoE Text", value = true})		
		Menu.d.XY:MenuElement({id = "x", name = "Pos: [X]", value = 700, min = 0, max = 1500, step = 10})
		Menu.d.XY:MenuElement({id = "y", name = "Pos: [Y]", value = 0, min = 0, max = 860, step = 10})		
		Menu.d:MenuElement({type = MENU, id = "Q", name = "Q"})
		Menu.d.Q:MenuElement({id = "ON", name = "Enabled", value = false})       
		Menu.d.Q:MenuElement({id = "Width", name = "Width", value = 1, min = 1, max = 5, step = 1})
		Menu.d.Q:MenuElement({id = "Color", name = "Color", color = DrawColor(255, 255, 255, 255)})
		Menu.d:MenuElement({type = MENU, id = "W", name = "W"})
		Menu.d.W:MenuElement({id = "ON", name = "Enabled", value = false})       
		Menu.d.W:MenuElement({id = "Width", name = "Width", value = 1, min = 1, max = 5, step = 1})
		Menu.d.W:MenuElement({id = "Color", name = "Color", color = DrawColor(255, 255, 255, 255)})
		Menu.d:MenuElement({type = MENU, id = "E", name = "E"})
		Menu.d.E:MenuElement({id = "ON", name = "Enabled", value = false})       
		Menu.d.E:MenuElement({id = "Width", name = "Width", value = 1, min = 1, max = 5, step = 1})
		Menu.d.E:MenuElement({id = "Color", name = "Color", color = DrawColor(255, 255, 255, 255)})
		Menu.d:MenuElement({type = MENU, id = "R", name = "R"})
		Menu.d.R:MenuElement({id = "ON", name = "Enabled", value = false})       
		Menu.d.R:MenuElement({id = "Width", name = "Width", value = 1, min = 1, max = 5, step = 1})
		Menu.d.R:MenuElement({id = "Color", name = "Color", color = DrawColor(255, 255, 255, 255)})						
	
	QData =
	{
	Type = _G.SPELLTYPE_CIRCLE, Delay = 0.75, Radius = 150, Range = 850, Speed = MathHuge, Collision = false
	}
	
	spellData = {speed = MathHuge, range = 850, delay = 0.75, radius = 150, collision = {nil}, type = "circular"}	

	RData =
	{
	Type = _G.SPELLTYPE_CONE, Delay = 0.5, Radius = 80, Range = 725, Speed = MathHuge, Collision = false
	}
	
	RspellData = {speed = MathHuge, range = 725, delay = 0.5, radius = 0, angle = 80, windup = 0.5, collision = {nil}, type = "conic"}	
	
	if _G.SDK then
		_G.SDK.Orbwalker:OnPreAttack(function(...) StopAutoAttack(...) end)
	elseif _G.PremiumOrbwalker then
		_G.PremiumOrbwalker:OnPreAttack(function(...) StopAutoAttack(...) end)
	end	
  	                                           
	Callback.Add("Tick", function() Tick() end)
	
	Callback.Add("Draw", function()
		if myHero.dead == false and Menu.d.ON:Value() then
			
			if Menu.d.XY.Text:Value() then 
				DrawText("Auto E: ", 15, Menu.d.XY.x:Value(), Menu.d.XY.y:Value()+10, DrawColor(255, 225, 255, 0))
				if Menu.w.E:Value() then 
					if Menu.w.E2:Value() then
						if GetMode() ~= "Combo" then
							DrawText("ON", 15, Menu.d.XY.x:Value()+45, Menu.d.XY.y:Value()+10, DrawColor(255, 0, 255, 0))
						else						
							DrawText("OFF", 15, Menu.d.XY.x:Value()+45, Menu.d.XY.y:Value()+10, DrawColor(255, 255, 0, 0)) 
						end	
					else
						DrawText("ON", 15, Menu.d.XY.x:Value()+45, Menu.d.XY.y:Value()+10, DrawColor(255, 0, 255, 0))
					end	
				else
					DrawText("OFF", 15, Menu.d.XY.x:Value()+45, Menu.d.XY.y:Value()+10, DrawColor(255, 255, 0, 0)) 
				end
			end
			if Menu.d.Q.ON:Value() then
				DrawCircle(myHero.pos, 850, Menu.d.Q.Width:Value(), Menu.d.Q.Color:Value())
			end
			if Menu.d.W.ON:Value() then
				DrawCircle(myHero.pos, 340, Menu.d.W.Width:Value(), Menu.d.W.Color:Value())
				DrawCircle(myHero.pos, 960, Menu.d.W.Width:Value(), Menu.d.W.Color:Value())
			end
			if Menu.d.E.ON:Value() then
				DrawCircle(myHero.pos, 750, Menu.d.E.Width:Value(), Menu.d.E.Color:Value())
			end	
			if Menu.d.R.ON:Value() then
				DrawCircle(myHero.pos, 750, Menu.d.E.Width:Value(), Menu.d.E.Color:Value())
			end			
		end
		local target = GetTarget(1200)
		if target == nil then return end

		if EnemiesNear(myHero,1200) == 1 and Ready(_R) and Ready(_W) and Ready(_E) and Ready(_Q) then	
			local fulldmg = getdmg("Q", target, myHero) + getdmg("W", target, myHero) + getdmg("E", target, myHero) + getdmg("R", target, myHero)
			local textPos = target.pos:To2D()
			if IsValid(target) then
				if fulldmg > target.health then 
					DrawText("Engage PressKey", 25, textPos.x - 33, textPos.y + 60, DrawColor(255, 255, 0, 0))
				end
			end
		end
	end)		
end

local QRange = 850
local MaxWRange = 700 	
local ERange = 700
local RRange = 825
local result = false

function Tick()
	if result then
		DelayAction(function()
			result = false
		end,0.3)	
	end	

	if MyHeroNotReady() then return end
	local Mode = GetMode()
	if Mode == "Combo" then
		Combo()
	elseif Mode == "Harass" then
		Harass()
	elseif Mode == "Clear" then
		Clear()
		JClear()		
	end
	
	if Menu.w.E:Value() then
		if Menu.w.E2:Value() then
			if Mode ~= "Combo" then	
				AutoE()
			end
		else
			AutoE()
		end	
	end
	
	if Menu.kill.Eng:Value() then
		Engage()
	end	
	
	if Menu.c.SR:Value() then
		SemiR()
	end
	
	KsQ()
	KsW()
	KsE()	
end

local function ReadyForE()
    return myHero:GetSpellData(_E).currentCd <= Menu.c.Cd:Value() and myHero:GetSpellData(_E).level > 0 and myHero:GetSpellData(_E).mana <= myHero.mana 
end

function StopAutoAttack(args)
	local Mode = GetMode()
	if Menu.c.Block:Value() and Mode == "Combo" and ReadyForE() then
		args.Process = false 
		return
	end
end

function EdmgCreep()
	local level = myHero.levelData.lvl
	local base = (48 + 4 * level) + (0.1 * myHero.ap)
	return base
end	

function PEdmgCreep()
	local level = myHero:GetSpellData(_E).level
	local bonus = (({10, 30, 50, 70, 90})[level] + 0.60 * myHero.ap)
	local PEdamage = EdmgCreep() + bonus
	return PEdamage
end	

function GetAngle(v1, v2)
	local vec1 = v1:Len()
	local vec2 = v2:Len()
	local Angle = math.abs(math.deg(math.acos((v1*v2)/(vec1*vec2))))
	if Angle < 90 then
		return true
	end
	return false
end

function IsFacing(unit)
	local V = Vector((unit.pos - myHero.pos))
	local D = Vector(unit.dir)
	local Angle = 180 - math.deg(math.acos(V*D/(V:Len()*D:Len())))
	if math.abs(Angle) < 80 then 
		return true  
	end
	return false
end

function RLogic()
	local RTarget = nil 
	local Most = 0
	local ShouldCast = false
		local InFace = {}
		for i = 1, Game.HeroCount() do
		local Hero = Game.Hero(i)
			if IsValid1(Hero, 850) then 
				--local LS = LineSegment(myHero.pos, Hero.pos)
				--LS:__draw()
				InFace[#InFace + 1] = Hero
			end
		end
		local IsFace = {}
		for r = 1, #InFace do 
		local FHero = InFace[r]
			if IsFacing(FHero) then
				local Vectori = Vector(myHero.pos - FHero.pos)
				IsFace[#IsFace + 1] = {Vector = Vectori, Host = FHero}
			end
		end
		local Count = {}
		local Number = #InFace
		for c = 1, #IsFace do 
		local MainLine = IsFace[c]
		if Count[MainLine] == nil then Count[MainLine] = 1 end
			for w = 1, #IsFace do 
			local CloseLine = IsFace[w] 
			local A = CloseLine.Vector
			local B = MainLine.Vector
				if A ~= B then
					if GetAngle(A,B) and myHero.pos:DistanceTo(MainLine.Host.pos) < Menu.R.Rrange:Value() then 
						Count[MainLine] = Count[MainLine] + 1
					end
				end
			end
			if Count[MainLine] > Most then
				Most = Count[MainLine]
				RTarget = MainLine.Host
			end
		end
	--	print(Most)
		if Most >= Menu.c.Count:Value() or Most == Number then
			ShouldCast = true 
		end
	--	print(Most)
	--	if RTarget then
	--		LSS = Circle(Point(RTarget), 50)
	--		LSS:__draw()
	--	end
	return RTarget, ShouldCast
end
	
function Combo()
local target = GetTarget(950)
if target == nil then return end

	if IsValid(target) then	
    local Dist = myHero.pos:DistanceTo(target.pos) 
	local RTarget, ShouldCast = RLogic()   
	
		if not result and Menu.c.E:Value() and Ready(_E) and Dist < ERange then
            result = Control.CastSpell(HK_E, target)
        end
		
        if not result and Menu.c.Q:Value() and Ready(_Q) then 
            if Dist < QRange then 
				if Menu.Pred.Change:Value() == 1 then
					local pred = GetGamsteronPrediction(target, QData, myHero)
					if pred.Hitchance >= Menu.Pred.PredQ:Value()+1 then
						result = Control.CastSpell(HK_Q, pred.CastPosition)
					end
				elseif Menu.Pred.Change:Value() == 2 then
					local pred = _G.PremiumPrediction:GetPrediction(myHero, target, spellData)
					if pred.CastPos and ConvertToHitChance(Menu.Pred.PredQ:Value(), pred.HitChance) then
						result = Control.CastSpell(HK_Q, pred.CastPos)
					end
				else
					CastQGGPred(target)
				end	
            end
        end
		
        if not result and Menu.c.W:Value() and Ready(_W) then 
            if Dist < MaxWRange then
                if Dist < 554 then 
					local castPos = target.pos:Extended(myHero.pos, -200)    
					result = Control.CastSpell(HK_W, castPos)
				elseif Dist > 554 then
					result = Control.CastSpell(HK_W, target.pos)				
                end
            end
        end
 
		if Menu.c.P:Value() and myHero.health/myHero.maxHealth < Menu.c.HP:Value()/100 and Ready(_R) then
			if myHero:GetSpellData(SUMMONER_1).name == "SummonerHaste" and Ready(SUMMONER_1) then
				Control.CastSpell(HK_SUMMONER_1)
			elseif myHero:GetSpellData(SUMMONER_2).name == "SummonerHaste" and Ready(SUMMONER_2) then
				Control.CastSpell(HK_SUMMONER_2)
			end

			if Dist < Menu.R.Rrange:Value() and GetAngle(myHero.pos, target.pos) then
				result = Control.CastSpell(HK_R, target.pos)
			end
		end
		
		if Menu.c.R:Value() and Ready(_R) then
			if Dist < Menu.R.Rrange:Value() then 
				if RTarget and ShouldCast == true then
					result = Control.CastSpell(HK_R, target.pos)					
				end 
			end
		end
	end
end	
	
function SemiR()
local target = GetTarget(950)
if target == nil then return end
	local Dist = myHero.pos:DistanceTo(target.pos)	
	if IsValid(target) and Dist < Menu.R.Rrange:Value() and Ready(_R) then
		result = Control.CastSpell(HK_R, target.pos)			
	end 
end
	
function Harass()
local target = GetTarget(950)
if target == nil then return end
	
	if IsValid(target) then
		local EDmg = getdmg("E", target, myHero) * 2
		local Dist = myHero.pos:DistanceTo(target.pos)
		
		if not result and Dist < ERange and Menu.h.E:Value() and Ready(_E) and (HasPoison(target) or EDmg >= target.health) then
            result = Control.CastSpell(HK_E, target)
        end
		
        if not result and Dist < QRange and Menu.h.Q:Value() and Ready(_Q) and myHero.mana/myHero.maxMana > Menu.m.Q:Value()/100 then 
			if Menu.Pred.Change:Value() == 1 then
				local pred = GetGamsteronPrediction(target, QData, myHero)
				if pred.Hitchance >= Menu.Pred.PredQ:Value()+1 then
					result = Control.CastSpell(HK_Q, pred.CastPosition)
				end
			elseif Menu.Pred.Change:Value() == 2 then
				local pred = _G.PremiumPrediction:GetPrediction(myHero, target, spellData)
				if pred.CastPos and ConvertToHitChance(Menu.Pred.PredQ:Value(), pred.HitChance) then
					result = Control.CastSpell(HK_Q, pred.CastPos)
				end
			else
				CastQGGPred(target)
			end
        end
	end
end	
	
function Clear()
	for i = 1, GameMinionCount() do 
	local minion = GameMinion(i)
		if minion.team == TEAM_ENEMY and IsValid(minion) then
		local mana_ok = myHero.mana/myHero.maxMana >= Menu.m.QW:Value() / 100
			
			if not result and Menu.w.Q:Value() and mana_ok and myHero.pos:DistanceTo(minion.pos) <= QRange and Ready(_Q) then
				result = Control.CastSpell(HK_Q, minion.pos)
			end
			
			if not result and Menu.w.W:Value() and mana_ok and Ready(_W) then
				local Dist = myHero.pos:DistanceTo(minion.pos)
				if Dist < MaxWRange and MinionsNear(minion,500) >= Menu.w.Count:Value() then
					result = Control.CastSpell(HK_W, minion.pos)
				end	
			end
		end
	end
end

function JClear()
	for i = 1, GameMinionCount() do 
	local Minion = GameMinion(i)		 

		if Minion.team == TEAM_JUNGLE then	
		local Dist = myHero.pos:DistanceTo(Minion.pos)
			
			if not result and IsValid(Minion) and Dist < QRange then	
				if Menu.j.Q:Value() and Ready(_Q) and myHero.mana/myHero.maxMana > Menu.m.QW:Value()/100 then
					result = Control.CastSpell(HK_Q, Minion.pos)
					
				end
			end
			
			if not result and IsValid(Minion) then
				if Dist < MaxWRange then	
					if Menu.j.W:Value() and Ready(_W) and myHero.mana/myHero.maxMana > Menu.m.WW:Value()/100 then
						result = Control.CastSpell(HK_W, Minion.pos)
					
					end
				end
			end
			
			if not result and IsValid(Minion) and Dist < ERange then	
				if Menu.j.E:Value() and Ready(_E) then
					if HasPoison(Minion) then
						result = Control.CastSpell(HK_E, Minion)
						break
					elseif EdmgCreep() > Minion.health then
						result = Control.CastSpell(HK_E, Minion)
						break
					elseif HasPoison(Minion) and PEdmgCreep() > Minion.health then
						result = Control.CastSpell(HK_E, Minion)
						break					
					end
				end
			end
		end
	end
end

function KsE()
local target = GetTarget(750)
if target == nil then return end
local Dist = myHero.pos:DistanceTo(target.pos)	 	
	if IsValid(target) and Dist < ERange then	
		local EDmg = getdmg("E", target, myHero) * 2
		local PEDmg = getdmg("E", target, myHero)
		
		if not result and Menu.ks.E:Value() and Ready(_E) then 
			
			if HasPoison(target) and PEDmg > target.health then
				result = Control.CastSpell(HK_E, target)
			end
			
			if EDmg > target.health then
				result = Control.CastSpell(HK_E, target)			
			end
		end
	end	
end	

function KsQ()
local target = GetTarget(900)
if target == nil then return end
local Dist = myHero.pos:DistanceTo(target.pos)	
	if IsValid(target) and Dist < QRange then	
		if not result and Menu.ks.Q:Value() and Ready(_Q) then 
			local QDmg = getdmg("Q", target, myHero)
			if QDmg > target.health then
				if Menu.Pred.Change:Value() == 1 then
					local pred = GetGamsteronPrediction(target, QData, myHero)
					if pred.Hitchance >= Menu.Pred.PredQ:Value()+1 then
						result = Control.CastSpell(HK_Q, pred.CastPosition)
					end
				elseif Menu.Pred.Change:Value() == 2 then
					local pred = _G.PremiumPrediction:GetPrediction(myHero, target, spellData)
					if pred.CastPos and ConvertToHitChance(Menu.Pred.PredQ:Value(), pred.HitChance) then
						result = Control.CastSpell(HK_Q, pred.CastPos)
					end
				else
					CastQGGPred(target)
				end		
			end
		end
	end
end	

function KsW()
local target = GetTarget(900)
if target == nil then return end
local Dist = myHero.pos:DistanceTo(target.pos)
	
	if not result and IsValid(target) and Dist < MaxWRange then	
		if Menu.ks.W:Value() and Ready(_W) then 
			local WDmg = getdmg("W", target, myHero)
			if WDmg > target.health then
				result = Control.CastSpell(HK_W, target.pos)			
			end
		end
	end	
end	
	
function Engage()
local target = GetTarget(1200)
if target == nil then return end
local Dist = myHero.pos:DistanceTo(target.pos)

	if IsValid(target) and Dist < ERange then
		local fulldmg = getdmg("Q", target, myHero) + getdmg("W", target, myHero) + getdmg("E", target, myHero) + getdmg("R", target, myHero)
		local RCheck = Ready(_R)
		local RTarget, ShouldCast = RLogic()
	
	
		if EnemiesNear(myHero,825) == 1 and Ready(_R) and Ready(_W) and Ready(_Q) and Ready(_E) then 
			if RTarget and EnemyInRange(Menu.R.Rrange:Value()) and fulldmg > target.health then
				if Menu.Pred.Change:Value() == 1 then
					local pred = GetGamsteronPrediction(RTarget, RData, myHero)
					if pred.Hitchance >= Menu.Pred.PredR:Value()+1 then
						result = Control.CastSpell(HK_R, pred.CastPosition)
					end
				elseif Menu.Pred.Change:Value() == 2 then
					local pred = _G.PremiumPrediction:GetPrediction(myHero, RTarget, RspellData)
					if pred.CastPos and ConvertToHitChance(Menu.Pred.PredR:Value(), pred.HitChance) then
						result = Control.CastSpell(HK_R, pred.CastPos)
					end
				else
					CastRGGPred(RTarget)
				end				
			end
		end 
		
		if not Ready(_R) then
			if myHero:GetSpellData(SUMMONER_1).name == "SummonerHaste" and Ready(SUMMONER_1) then
				Control.CastSpell(HK_SUMMONER_1)
			elseif myHero:GetSpellData(SUMMONER_2).name == "SummonerHaste" and Ready(SUMMONER_2) then
				Control.CastSpell(HK_SUMMONER_2)
			end
		end	
		
		if not result and Ready(_Q) and not Ready(_R) then 
			if Dist < QRange then 
				if Dist < QRange then
					if Menu.Pred.Change:Value() == 1 then
						local pred = GetGamsteronPrediction(target, QData, myHero)
						if pred.Hitchance >= Menu.Pred.PredQ:Value()+1 then
							result = Control.CastSpell(HK_Q, pred.CastPosition)
						end
					elseif Menu.Pred.Change:Value() == 2 then
						local pred = _G.PremiumPrediction:GetPrediction(myHero, target, spellData)
						if pred.CastPos and ConvertToHitChance(Menu.Pred.PredQ:Value(), pred.HitChance) then
							result = Control.CastSpell(HK_Q, pred.CastPos)
						end
					else
						CastQGGPred(target)
					end
				end
			end
		end
		
		if not result and Ready(_E) and not Ready(_R) then 
			if Dist < ERange then
				result = Control.CastSpell(HK_E, target)
			end
		end	
		
		if not result and Ready(_W) and not Ready(_R) then 
			if Dist < MaxWRange then
				result = Control.CastSpell(HK_W, target.pos)				
			end
		end
	end	
end
	
function AutoE()
    for i = 1, GameMinionCount() do
    local minion = GameMinion(i)
        if minion.team == TEAM_ENEMY and IsValid(minion) then	
			local mana_ok = myHero.mana/myHero.maxMana >= Menu.m.EW:Value() / 100
            local Dist = myHero.pos:DistanceTo(minion.pos)
			
			if not result and Menu.w.E:Value() and mana_ok and Dist <= ERange and Ready(_E) then
				local PDmg = CalcMagicalDamage(myHero, minion, PEdmgCreep()) 
				local EDmg = CalcMagicalDamage(myHero, minion, EdmgCreep()) 				
				if HasPoison(minion) and PDmg + 20 >= minion.health then 
					if PEdmgCreep() >= minion.health then
						result = Control.CastSpell(HK_E, minion)
					end
				end
				
				if EDmg + 20 >= minion.health then 
					if EdmgCreep() >= minion.health then
						result = Control.CastSpell(HK_E, minion)
					end
				end
            end	
		end
	end	
end

function CastQGGPred(unit)
	local QPrediction = GGPrediction:SpellPrediction({Type = GGPrediction.SPELLTYPE_CIRCLE, Delay = 0.75, Radius = 150, Range = 850, Speed = MathHuge, Collision = false})
	QPrediction:GetPrediction(unit, myHero)
	if QPrediction:CanHit(Menu.Pred.PredQ:Value()+1) then
		result = Control.CastSpell(HK_Q, QPrediction.CastPosition)
	end
end

function CastRGGPred(unit)
	local RPrediction = GGPrediction:SpellPrediction({Type = GGPrediction.SPELLTYPE_CONE, Delay = 0.5, Radius = 80, Range = 725, Speed = MathHuge, Collision = false})
	RPrediction:GetPrediction(unit, myHero)
	if RPrediction:CanHit(Menu.Pred.PredR:Value()+1) then
		result = Control.CastSpell(HK_R, RPrediction.CastPosition)
	end
end
