-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	CombatManager.setCustomSort(sortfuncGURPS);

	ActorCommonManager.setRecordTypeSpaceReachCallback("charsheet", npcSpaceReach);
	ActorCommonManager.setRecordTypeSpaceReachCallback("npc", npcSpaceReach);
	CombatRecordManager.setRecordTypePostAddCallback("charsheet", onPCPostAdd);
	CombatRecordManager.setRecordTypePostAddCallback("npc", onNPCPostAdd);

	CombatManager.setCustomCombatReset(resetCombat);

	CombatManager.setCustomRoundStart(onRoundStart);
	CombatManager.setCustomTurnStart(onTurnStart);
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
    
    -- Setup
    DB.setValue(tCustom.nodeCT, "skip", "number", 0);

    DB.setValue(tCustom.nodeCT, "speed", "number", tonumber(DB.getValue(tCustom.nodeRecord, "attributes.basicspeed", "0")));
    DB.setValue(tCustom.nodeCT, "hps", "number", DB.getValue(tCustom.nodeRecord, "attributes.hps", 0));
    DB.setValue(tCustom.nodeCT, "fps", "number", DB.getValue(tCustom.nodeRecord, "attributes.fps", 0));

    DB.setValue(tCustom.nodeCT, "traits.sizemodifier", "string", DB.getValue(tCustom.nodeRecord, "traits.sizemodifier", "0"));
    DB.setValue(tCustom.nodeCT, "traits.reach", "string", DB.getValue(tCustom.nodeRecord, "traits.reach", "0"));
    DB.setValue(tCustom.nodeCT, "space", "number", ManagerGURPS4e.calcSizeModifierGridUnits(DB.getValue(tCustom.nodeRecord, "traits.sizemodifier", "0")));
    DB.setValue(tCustom.nodeCT, "reach", "number", tonumber(DB.getValue(tCustom.nodeRecord, "traits.reach", "0")));
  
    DB.setValue(tCustom.nodeCT, "attributes.strength", "number", DB.getValue(tCustom.nodeRecord, "attributes.strength", 0));
    DB.setValue(tCustom.nodeCT, "attributes.dexterity", "number", DB.getValue(tCustom.nodeRecord, "attributes.dexterity", 0));
    DB.setValue(tCustom.nodeCT, "attributes.intelligence", "number", DB.getValue(tCustom.nodeRecord, "attributes.intelligence", 0));
    DB.setValue(tCustom.nodeCT, "attributes.health", "number", DB.getValue(tCustom.nodeRecord, "attributes.health", 0));
    DB.setValue(tCustom.nodeCT, "attributes.hitpoints", "number", DB.getValue(tCustom.nodeRecord, "attributes.hitpoints", 0));
    DB.setValue(tCustom.nodeCT, "attributes.will", "number", DB.getValue(tCustom.nodeRecord, "attributes.will", 0));
    DB.setValue(tCustom.nodeCT, "attributes.perception", "number", DB.getValue(tCustom.nodeRecord, "attributes.perception", 0));
    DB.setValue(tCustom.nodeCT, "attributes.fatiguepoints", "number", DB.getValue(tCustom.nodeRecord, "attributes.fatiguepoints", 0));

    DB.setValue(tCustom.nodeCT, "combat.dodge", "number", DB.getValue(tCustom.nodeRecord, "combat.dodge", 0));
    DB.setValue(tCustom.nodeCT, "combat.parry", "number", DB.getValue(tCustom.nodeRecord, "combat.parry", 0));
    DB.setValue(tCustom.nodeCT, "combat.block", "number", DB.getValue(tCustom.nodeRecord, "combat.block", 0));
    DB.setValue(tCustom.nodeCT, "combat.dr", "string", DB.getValue(tCustom.nodeRecord, "combat.dr", "0"));

    DB.setValue(tCustom.nodeCT, "attributes.move", "string", DB.getValue(tCustom.nodeRecord, "attributes.move", "0"));
end

function onNPCPostAdd(tCustom)
	-- Parameter validation
	if not tCustom.nodeRecord or not tCustom.nodeCT then
		return;
	end

    DB.setValue(tCustom.nodeCT, "skip", "number", 0);

    DB.setValue(tCustom.nodeCT, "traits.sizemodifier", "string", DB.getValue(tCustom.nodeRecord, "traits.sizemodifier", "0"));
    DB.setValue(tCustom.nodeCT, "traits.reach", "string", DB.getValue(tCustom.nodeRecord, "traits.reach", "0"));
    DB.setValue(tCustom.nodeCT, "space", "number", ManagerGURPS4e.calcSizeModifierGridUnits(DB.getValue(tCustom.nodeRecord, "traits.sizemodifier", "0")));
    DB.setValue(tCustom.nodeCT, "reach", "number", tonumber(DB.getValue(tCustom.nodeRecord, "traits.reach", "0")));

    -- Setup
    DB.setValue(tCustom.nodeCT, "basemove", "string", DB.getValue(tCustom.nodeRecord, "attributes.move", "0"));
    DB.setValue(tCustom.nodeCT, "basedodge", "number", DB.getValue(tCustom.nodeRecord, "combat.dodge", 0));
    DB.setValue(tCustom.nodeCT, "attributes.move", "string", DB.getValue(tCustom.nodeRecord, "attributes.move", "0"));
    DB.setValue(tCustom.nodeCT, "speed", "number", tonumber(DB.getValue(tCustom.nodeRecord, "attributes.basicspeed", "0")));
    DB.setValue(tCustom.nodeCT, "hps", "number", DB.getValue(tCustom.nodeRecord, "attributes.hitpoints", 0));
    DB.setValue(tCustom.nodeCT, "fps", "number", DB.getValue(tCustom.nodeRecord, "attributes.fatiguepoints", 0));

    ActionDamage.updateDamage(tCustom.nodeCT);
    ActionFatigue.updateFatigue(tCustom.nodeCT);

    return nodeEntry;
end

function npcSpaceReach(rActor)
	local nodeActor = ActorManager.getCreatureNode(rActor);
	if not nodeActor then
		return 0;
	end

   local nSpace = ManagerGURPS4e.calcSizeModifierGridUnits(DB.getValue(nodeActor, "traits.sizemodifier", "0"));
   local nReach = tonumber(DB.getValue(nodeActor, "traits.reach", "0"));

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
	function resetCombatant(nodeCT)
	end
	CombatManager.callForEachCombatant(resetCombatant);
end

function resetEffects()
	function clearEffect(nodeEffect)
		nodeEffect.delete();
	end
	CombatManager.callForEachCombatantEffect(clearEffect);
end

function clearExpiringEffects()
	function checkEffectExpire(nodeEffect)
		local sLabel = DB.getValue(nodeEffect, "label", "");
		local nDuration = DB.getValue(nodeEffect, "duration", 0);
		local sApply = DB.getValue(nodeEffect, "apply", "");
		
		if nDuration ~= 0 or sApply ~= "" or sLabel == "" then
			nodeEffect.delete();
		end
	end
	CombatManager.callForEachCombatantEffect(checkEffectExpire);
end
