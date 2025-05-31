-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	CombatManager.setCustomSort(CombatManagerGURPS4e.sortfuncGURPS);

	CombatManager.setCustomRoundStart(CombatManagerGURPS4e.onRoundStart);
	CombatManager.setCustomTurnStart(CombatManagerGURPS4e.onTurnStart);
	CombatManager.setCustomTurnEnd(CombatManagerGURPS4e.onTurnEnd);
	CombatManager.setCustomCombatReset(CombatManagerGURPS4e.resetCombat);

	CombatRecordManager.addStandardVehicleCombatRecordType();

	ActorCommonManager.setRecordTypeSpaceReachCallback("charsheet", CombatManagerGURPS4e.getSpaceReachFromActor);
	ActorCommonManager.setRecordTypeSpaceReachCallback("npc", CombatManagerGURPS4e.getSpaceReachFromActor);
	ActorCommonManager.setRecordTypeSpaceReachCallback("vehicle", CombatManagerGURPS4e.getSpaceReachFromVehicle);

	CombatRecordManager.setRecordTypePostAddCallback("charsheet", CombatManagerGURPS4e.onPCPostAdd);
	CombatRecordManager.setRecordTypePostAddCallback("npc", CombatManagerGURPS4e.onNPCPostAdd);
	CombatRecordManager.setRecordTypePostAddCallback("vehicle", CombatManagerGURPS4e.onVehiclePostAdd);
end

function isCTSkipped(vEntry)
	if DB.getValue(vEntry, "skip", 0) == 0 then
        return false;
	end
	return true;
end

function isCTAllSkipped()
  	for _,v in pairs(CombatManager.getCombatantNodes()) do
		if not isCTSkipped(v) then
          return false;
		end
	end
	return true;
end

function onRoundStart(nCurrent)
end

function onTurnStart(nodeEntry)
	if not nodeEntry then
		return;
	end
    
    if isCTAllSkipped() then
        return;
    end
    
    if isCTSkipped(nodeEntry) then
        CombatManager.nextActor();
    end
end

function onTurnEnd(nodeEntry)
	if not nodeEntry then
		return;
	end
end

--
-- COMBAT TRACKER SORT
--

-- NOTE: Lua sort function expects the opposite boolean value compared to built-in FG sorting
function sortfuncGURPS(node1, node2)
  local bHost = User.isHost();
  local sOptCTSI = OptionsManager.getOption("CTSI");
  
  local sFaction1 = DB.getValue(node1, "friendfoe", "");
  local sFaction2 = DB.getValue(node2, "friendfoe", "");
  
  local bShowInit1 = bHost or ((sOptCTSI == "friend") and (sFaction1 == "friend")) or (sOptCTSI == "on");
  local bShowInit2 = bHost or ((sOptCTSI == "friend") and (sFaction2 == "friend")) or (sOptCTSI == "on");
  
  if bShowInit1 ~= bShowInit2 then
    if bShowInit1 then
      return true;
    elseif bShowInit2 then
      return false;
    end
  else
    if bShowInit1 then
      local nValue1 = DB.getValue(node1, "speed", 0);
      local nDX1 = DB.getValue(node1, "attributes.dexterity", 0);
      local nValue2 = DB.getValue(node2, "speed", 0);
      local nDX2 = DB.getValue(node2, "attributes.dexterity", 0);
      
      if nValue1 ~= nValue2 then
        return nValue1 > nValue2;
      end
      
      if nDX1 ~= nDX2 then
        return nDX1 > nDX2;
      end
      
      if sFaction1 ~= sFaction2 then
        if sFaction1 == "friend" then
          return true;
        elseif sFaction2 == "friend" then
          return false;
        end
      end
    else
      if sFaction1 ~= sFaction2 then
        if sFaction1 == "friend" then
          return true;
        elseif sFaction2 == "friend" then
          return false;
        end
      end
    end
  end
  
  local sValue1 = DB.getValue(node1, "name", "");
  local sValue2 = DB.getValue(node2, "name", "");
  if sValue1 ~= sValue2 then
    return sValue1 < sValue2;
  end

  return node1.getNodeName() < node2.getNodeName();
end

--
-- ADD FUNCTIONS
--

function onPCPostAdd(tCustom)
	-- Parameter validation
	if not tCustom.nodeRecord or not tCustom.nodeCT then
		return;
	end

    DB.setValue(tCustom.nodeCT, "skip", "number", 0);
    
    -- Setup
    local sOptRNDINIT = OptionsManager.getOption("RNDINIT");

    local nSpeed = tonumber(DB.getValue(tCustom.nodeRecord, "attributes.basicspeed", "0"));
    if sOptRNDINIT ~= "" then
        nSpeed = 0;
    end

    DB.setValue(tCustom.nodeCT, "speed", "number", nSpeed);
    DB.setValue(tCustom.nodeCT, "hps", "number", DB.getValue(tCustom.nodeRecord, "attributes.hps", 0));
    DB.setValue(tCustom.nodeCT, "fps", "number", DB.getValue(tCustom.nodeRecord, "attributes.fps", 0));

    ActionDamage.updateDamage(tCustom.nodeCT);
    ActionFatigue.updateFatigue(tCustom.nodeCT);
end

function onNPCPostAdd(tCustom)
	-- Parameter validation
	if not tCustom.nodeRecord or not tCustom.nodeCT then
		return;
	end

    DB.setValue(tCustom.nodeCT, "skip", "number", 0);

    -- Setup
    local sOptRNDINIT = OptionsManager.getOption("RNDINIT");

    local nSpeed = tonumber(DB.getValue(tCustom.nodeRecord, "attributes.basicspeed", "0"));
    if sOptRNDINIT ~= "" then
		local sOptINIT = OptionsManager.getOption("INIT");
		if sOptINIT == "group" then
			if tCustom.nodeCTLastMatch then
				nSpeed = DB.getValue(tCustom.nodeCTLastMatch, "speed", 0);
			else
				if sOptRNDINIT == "d4" then
					nSpeed = nSpeed + math.random(4);
				elseif sOptRNDINIT == "d6" then
					nSpeed = nSpeed + math.random(6);
				elseif sOptRNDINIT == "d4x" then
					nSpeed = nSpeed + math.random(4) * 0.25
				elseif sOptRNDINIT == "d6x" then
					nSpeed = nSpeed + math.random(6) * 0.25
				end
			end
		elseif sOptINIT == "on" then
			if sOptRNDINIT == "d4" then
				nSpeed = nSpeed + math.random(4);
			elseif sOptRNDINIT == "d6" then
				nSpeed = nSpeed + math.random(6);
			elseif sOptRNDINIT == "d4x" then
				nSpeed = nSpeed + math.random(4) * 0.25
			elseif sOptRNDINIT == "d6x" then
				nSpeed = nSpeed + math.random(6) * 0.25
			end
		else
			nSpeed = 0;
		end
    end

    DB.setValue(tCustom.nodeCT, "speed", "number", nSpeed);
    DB.setValue(tCustom.nodeCT, "basemove", "string", DB.getValue(tCustom.nodeRecord, "attributes.move", "0"));
    DB.setValue(tCustom.nodeCT, "basedodge", "number", DB.getValue(tCustom.nodeRecord, "combat.dodge", 0));
    DB.setValue(tCustom.nodeCT, "hps", "number", DB.getValue(tCustom.nodeRecord, "attributes.hitpoints", 0));
    DB.setValue(tCustom.nodeCT, "fps", "number", DB.getValue(tCustom.nodeRecord, "attributes.fatiguepoints", 0));

    ActionDamage.updateDamage(tCustom.nodeCT);
    ActionFatigue.updateFatigue(tCustom.nodeCT);
end

function onVehiclePostAdd(tCustom)
	-- Parameter validation
	if not tCustom.nodeRecord or not tCustom.nodeCT then
		return;
	end

    DB.setValue(tCustom.nodeCT, "skip", "number", 0);
    
    -- Setup
    DB.setValue(tCustom.nodeCT, "speed", "number", 0);
    DB.setValue(tCustom.nodeCT, "basemove", "string", DB.getValue(tCustom.nodeRecord, "attributes.move", "0"));
    DB.setValue(tCustom.nodeCT, "basedodge", "number", DB.getValue(tCustom.nodeRecord, "combat.dodge", 0));
    DB.setValue(tCustom.nodeCT, "hps", "number", ManagerGURPS4e.getVehicleHP(tCustom.nodeRecord));
    DB.setValue(tCustom.nodeCT, "fps", "number", 0);
    DB.setValue(tCustom.nodeCT, "attributes.hitpoints", "number", ManagerGURPS4e.getVehicleHP(tCustom.nodeRecord));
    DB.setValue(tCustom.nodeCT, "attributes.fatiguepoints", "number", 0);
    DB.setValue(tCustom.nodeCT, "traits.sizemodifier", "string", DB.getValue(tCustom.nodeRecord, "sm", 0));
    DB.setValue(tCustom.nodeCT, "traits.reach", "string", 0);
    DB.setValue(tCustom.nodeCT, "combat.dr", "string", DB.getValue(tCustom.nodeRecord, "dr", 0));

    ActionDamage.updateDamage(tCustom.nodeCT);
    ActionFatigue.updateFatigue(tCustom.nodeCT);
end

function updateMoveDodge(nodeActor)
	if not nodeActor then
		return;
	end

	local move = tonumber(string.match(DB.getValue(nodeActor, "basemove", "0"), "%d+") or 0);
	local dodge = DB.getValue(nodeActor, "basedodge", 0);

	DB.setValue(nodeActor, "attributes.move", "string", move);  
	DB.setValue(nodeActor, "combat.dodge", "number", dodge);  

	if DB.getValue(nodeActor, "attributes.halfmovedodge", 0) == 1 then 
		local halfMove = math.ceil(tonumber(string.match(DB.getValue(nodeActor, "attributes.move", "0"), "%d+") or 0) / 2);
		local halfDodge = math.ceil(DB.getValue(nodeActor, "combat.dodge", 0) / 2);
		DB.setValue(nodeActor, "attributes.move", "string", halfMove);  
		DB.setValue(nodeActor, "combat.dodge", "number", halfDodge);  
	end
end

function getSpaceReachFromActor(rActor)
	local nSpace = GameSystem.getDistanceUnitsPerGrid();
	local nReach = nSpace;

	local nodeActor = ActorManager.getCreatureNode(rActor);
	if nodeActor then
        nSpace = tonumber(ManagerGURPS4e.calcSizeModifierGridUnits(DB.getValue(nodeActor, "traits.sizemodifier", "0")));
        nReach = tonumber(DB.getValue(nodeActor, "traits.reach", "0"));
	end

	return nSpace, nReach;
end

function getSpaceReachFromVehicle(rVehicle)
	local nSpace = GameSystem.getDistanceUnitsPerGrid();
	local nReach = nSpace;

	local nodeActor = ActorManager.getCreatureNode(rVehicle);
	if nodeActor then
        nSpace = tonumber(ManagerGURPS4e.calcSizeModifierGridUnits(DB.getValue(nodeActor, "sm", "0")));
        nReach = 0;
	end

	return nSpace, nReach;
end

function updateSpaceReach(rActor)
	local nodeActor = ActorManager.getCreatureNode(rActor);
	if not nodeActor then
		return 0;
	end

    local nSpace = ManagerGURPS4e.calcSizeModifierGridUnits(DB.getValue(nodeActor, "traits.sizemodifier", "0"));
	local nReach = tonumber(DB.getValue(nodeActor, "traits.reach", "0"));

	DB.setValue(nodeActor, "space", "number", nSpace);
    DB.setValue(nodeActor, "reach", "number", nReach);
end

--
-- RESET FUNCTIONS
--

function resetCombat()
    local sOptRNDINIT = OptionsManager.getOption("RNDINIT");
	function resetCombat(nodeCT)
		if sOptRNDINIT ~= "" then
		    DB.setValue(nodeCT, "speed", "number", 0);
		end
	end
	CombatManager.callForEachCombatant(resetCombat);

    CombatManagerGURPS4e.clearExpiringEffects();
end

function resetEffects()
	function clearEffect(nodeEffect)
		nodeEffect.delete();
	end
	CombatManager.callForEachCombatantEffect(clearEffect);
end

function clearExpiringEffects()
	function checkEffectExpire(nodeEffect)
		local sUnits = DB.getValue(nodeEffect, "units", "");

		if sUnits == "sec" or sUnits == "min" or sUnits == "hr" or sUnits == "day" then
			nodeEffect.delete();
		end
	end
	CombatManager.callForEachCombatantEffect(checkEffectExpire);
end

--
-- INIT FUNCTIONS
--

function rollInit(sType)
	CombatManagerGURPS4e.rollTypeInit(sType, CombatManagerGURPS4e.rollEntryInit);
end
function rollEntryInit(nodeEntry)
	CombatManagerGURPS4e.rollStandardEntryInit(CombatManagerGURPS4e.getEntryInitRecord(nodeEntry));
end
function getEntryInitRecord(nodeEntry)
	if not nodeEntry then
		return nil;
	end

	local tInit = { nodeEntry = nodeEntry };
	tInit.nBasicSpeed = tonumber(DB.getValue(nodeEntry, "attributes.basicspeed", "0"));
	tInit.nBonus = 0;
    tInit.fnRollRandom = CombatManagerGURPS4e.rollRandomInit;

	return tInit;
end
function rollRandomInit(tInit)
	local tSuffix = {};

	local sOptRNDINIT = OptionsManager.getOption("RNDINIT");

	local nInitResult = 0;
    if sOptRNDINIT == "d4" then
        nInitResult = math.random(4);
		tInit.nBonus = nInitResult
    elseif sOptRNDINIT == "d6" then
        nInitResult = math.random(6);
		tInit.nBonus = nInitResult
    elseif sOptRNDINIT == "d4x" then
        nInitResult = math.random(4);
		tInit.nBonus = nInitResult * 0.25
    elseif sOptRNDINIT == "d6x" then
        nInitResult = math.random(6);
		tInit.nBonus = nInitResult * 0.25
    end
	table.insert(tSuffix, string.format("[ %+g ]", tInit.nBonus));
	tInit.sSuffix = table.concat(tSuffix, " ");

	return nInitResult;
end

-- Override the default rollTypeInit function to support the GURPS4e system
function rollTypeInit(sType, fRollCombatantEntryInit, ...)
	local tCombatantNodesToRoll = {};

	-- Calculate which combatants to roll initiative for
	for _,nodeCT in pairs(CombatManager.getCombatantNodes()) do
		local bRoll = true;
		if sType then
			local rActor = ActorManager.resolveActor(nodeCT);
			if sType == "pc" then
				if not ActorManager.isPC(rActor) then
					bRoll = false;
				end
			elseif not ActorManager.isRecordType(rActor, sType) then
				bRoll = false;
			end
		end
		if bRoll then
			table.insert(tCombatantNodesToRoll, nodeCT);
		end
	end

	-- Reset all entries to default "empty" value for initiative
	-- Must reset all before rolling to support initiative grouping
	for _,nodeCT in ipairs(tCombatantNodesToRoll) do
		DB.setValue(nodeCT, "speed", "number", -10000);
	end
	-- Then, roll all initiatives
	for _,nodeCT in ipairs(tCombatantNodesToRoll) do
		fRollCombatantEntryInit(nodeCT, ...);
	end
end
function rollStandardEntryInit(tInit)
	if not tInit or not tInit.nodeEntry then
		return;
	end
	
	-- For PCs, we always roll unique initiative
	if CombatManager.isPlayerCT(tInit.nodeEntry) then
		local rActor = ActorManager.resolveActor(tInit.nodeEntry);
		local nodeActor = ActorManager.getCreatureNode(rActor);
		tInit.nBasicSpeed = tonumber(DB.getValue(nodeActor, "attributes.basicspeed", "0"));
		CombatManagerGURPS4e.helperRollEntryInit(tInit);
		return;
	end
	
	-- For NPCs, if NPC init option is not group, then roll unique initiative
	local sOptINIT = OptionsManager.getOption("INIT");
	if sOptINIT ~= "group" then
		CombatManagerGURPS4e.helperRollEntryInit(tInit);
		return;
	end

	-- For NPCs with group option enabled
	
	-- Get the entry's database node name and creature name
	local sStripName = CombatManager.stripCreatureNumber(DB.getValue(tInit.nodeEntry, "name", ""));
	if sStripName == "" then
		CombatManagerGURPS4e.helperRollEntryInit(tInit);
		return;
	end
		
	-- Iterate through list looking for other creatures with same name
	tInit.nInitMatch = nil;
	local sEntryFaction = DB.getValue(tInit.nodeEntry, "friendfoe", "");
	for _,nodeCT in pairs(CombatManager.getCombatantNodes()) do
		if DB.getName(nodeCT) ~= DB.getName(tInit.nodeEntry) then
			if DB.getValue(nodeCT, "friendfoe", "") == sEntryFaction then
				local sTemp = CombatManager.stripCreatureNumber(DB.getValue(nodeCT, "name", ""));
				if sTemp == sStripName then
					local nChildInit = DB.getValue(nodeCT, "speed", 0);
					if nChildInit ~= -10000 then
						tInit.nInitMatch = nChildInit;
					end
				end
			end
		end
	end
	
	-- If we found similar creatures, then match the initiative of the last one found; otherwise, roll
	CombatManagerGURPS4e.helperRollEntryInit(tInit);
end
function helperRollEntryInit(tInit)
	if not tInit or not tInit.nodeEntry then
		return;
	end
	if tInit.nInitMatch then
		DB.setValue(tInit.nodeEntry, "speed", "number", tInit.nInitMatch);
		return;
	end

	tInit.nTotal = CombatManager.helperRollRandomInit(tInit);
	DB.setValue(tInit.nodeEntry, "speed", "number", tInit.nBasicSpeed + tInit.nBonus);

	local rMessage = {
		font = "systemfont",
		icon = "portrait_gm_token",
		type = "init",
		text = string.format("%s: [INIT]", DB.getValue(tInit.nodeEntry, "name", "")),
		diemodifier = tInit.nTotal,
		diceskipexpr = true,
		secret = true,
	};
	if (tInit.sSuffix or "") ~= "" then
		rMessage.text = string.format("%s %s", rMessage.text, tInit.sSuffix);
	end
	Comm.addChatMessage(rMessage);
end
