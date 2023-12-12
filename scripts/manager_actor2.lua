-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

COLOR_HEALTH_UNWOUNDED = "008000";
COLOR_HEALTH_LT_WOUNDS = "408000";
COLOR_HEALTH_MOD_WOUNDS = "AF7817";
COLOR_HEALTH_HVY_WOUNDS = "E56717";
COLOR_HEALTH_CRIT_WOUNDS = "C11B17";

COLOR_FATIGUE_NORMAL = "008000";
COLOR_FATIGUE_FATIGUED = "AF7817";
COLOR_FATIGUE_CRITICAL = "E56717";
COLOR_FATIGUE_UNCONSCIOUS = "C11B17";

function onInit()
end

function getInjuryStatus(sNodeType, node)
	local rActor = ActorManager.resolveActor(node);
	
	local nHP = DB.getValue(node, "attributes.hitpoints", 0);
	local nCHP = DB.getValue(node, "hps", 0);

	local sStatus, nStatus;
	if nCHP >= nHP then
		sStatus = "Healthy";
		nStatus = 0;
	elseif nCHP > nHP/2 then
		sStatus = "Good";
		nStatus = 1;
	elseif nCHP > 0 then
		sStatus = "Fair";
	    nStatus = 2;
	elseif nCHP > -nHP then
		sStatus = "Serious";
	    nStatus = 3;
	else
		sStatus = "Critical";
	    nStatus = 4;
	end

	return sStatus, nStatus, rActor;
end

function getInjuryStatusColor(sNodeType, node)
	local sStatus, nStatus, rActor = getInjuryStatus(sNodeType, node);
	if not rActor then
		return COLOR_HEALTH_UNWOUNDED, nStatus, sStatus;
	end

	local sColor;
	if nStatus == 0 then
		sColor = COLOR_HEALTH_UNWOUNDED;
	elseif nStatus == 1 then
	    sColor = COLOR_HEALTH_LT_WOUNDS;
	elseif nStatus == 2 then
	    sColor = COLOR_HEALTH_MOD_WOUNDS;
	elseif nStatus == 3 then
	    sColor = COLOR_HEALTH_HVY_WOUNDS;
	else
	    sColor = COLOR_HEALTH_CRIT_WOUNDS;
	end

	return sColor, sStatus, nStatus;
end

function getFatigueStatus(sNodeType, node)
	local rActor = ActorManager.resolveActor(node);
	
	local nFP = DB.getValue(node, "attributes.fatiguepoints", 0);
	local nCFP = DB.getValue(node, "fps", 0);

	local sStatus, nStatus;
	if nCFP >= nFP/3 then
		sStatus = "Normal";
		nStatus = 0;
	elseif nCFP > 0 then
		sStatus = "Fatigued";
		nStatus = 1;
	elseif nCFP > -nFP then
		sStatus = "Critical";
		nStatus = 2;
	else
		sStatus = "Unconscious";
	    nStatus = 3;
	end

	return sStatus, nStatus, rActor;
end

function getFatigueStatusColor(sNodeType, node)
	local sStatus, nStatus, rActor = getFatigueStatus(sNodeType, node);
	if not rActor then
		return COLOR_FATIGUE_NORMAL, nStatus, sStatus;
	end

	local sColor;
	if nStatus == 0 then
		sColor = COLOR_FATIGUE_NORMAL;
	elseif nStatus == 1 then
	    sColor = COLOR_FATIGUE_FATIGUED;
	elseif nStatus == 2 then
	    sColor = COLOR_FATIGUE_CRITICAL;
	else
	    sColor = COLOR_FATIGUE_UNCONSCIOUS;
	end

	return sColor, sStatus, nStatus;
end

function getHPStatus(sNodeType, node)
	if sNodeType ~= "pc" and sNodeType ~= "ct" then
		return "";
	end
	
	local nHP, nInjury;
	if sNodeType == "pc" then
		nHP = DB.getValue(node, "attributes.hitpoints", 0);
		nInjury = DB.getValue(node, "attributes.injury", 0);
	else
		nHP = DB.getValue(node, "attributes.hitpoints", 0);
		nInjury = DB.getValue(node, "injury", 0);
	end

	local hpLevel = math.floor(nInjury/nHP) - 1;
	if hpLevel > 0 then return -hpLevel.."xHP"; end;

	if (nHP - nInjury) <= 0 then return "0 HP"; end;

	if (nHP - nInjury) < nHP/3 then return "1/3 HP"; end;

	return "";
end

function getFPStatus(sNodeType, node)
	if sNodeType ~= "pc" and sNodeType ~= "ct" then
		return "";
	end
	
	local nFP, nFatigue;
	if sNodeType == "pc" then
		nFP = DB.getValue(node, "attributes.fatiguepoints", 0);
		nFatigue = DB.getValue(node, "attributes.fatigue", 0);
	else
		nFP = DB.getValue(node, "attributes.fatiguepoints", 0);
		nFatigue = DB.getValue(node, "fatigue", 0);
	end

	local fpLevel = math.floor(nFatigue/nFP) - 1;
	if fpLevel > 0 then return -fpLevel.."xFP"; end;

	if (nFP - nFatigue) <= 0 then return "0 FP"; end;

	if (nFP - nFatigue) < nFP/3 then return "1/3 FP"; end;

	return "";
end

function hasMeleeWeapons(node)
  local nCount = DB.getChildCount(node, "combat.meleecombatlist");
  if nCount > 0 then
    return true;
  end
  
  return false
end

function hasRangedWeapons(node)
  local nCount = DB.getChildCount(node, "combat.rangedcombatlist");
  if nCount > 0 then
    return true;
  end
  
  return false
end


function resolveActor(node)
	while node.getParent() ~= nil and node.getParent().getNodeName() ~= "charsheet" and node.getParent().getNodeName() ~= "npc" and node.getParent().getPath() ~= "combattracker.list" do
		node = node.getParent();
	end

	return ActorManager.resolveActor(node);
end

function getTypeAndRootNode(node)
	while node.getParent() ~= nil and node.getParent().getNodeName() ~= "charsheet" and node.getParent().getNodeName() ~= "npc" and node.getParent().getPath() ~= "combattracker.list" do
		node = node.getParent();
	end

	return ActorManager.getTypeAndNode(node);
end

-- Given an actor and the name of an attribute or ability, this will return a table with
-- current information about that stat.
function getStat(nodeActor, sName)
	if not nodeActor or not sName or sName:len() < 2 then
		return;
	end

	local nodeChar = nodeActor;
	local stat;
	if ActorManager.isPC(nodeChar) then
		stat = getAttributeStatFromList(nodeChar.getChild("attributes"), sName, "pc");
		if stat then 
			return stat;
		end

		stat = getAbilityStatFromList(nodeChar.getChild("abilities.skilllist"), sName, "skill", "pc");
		if stat then 
			return stat;
		end

		stat = getAbilityStatFromList(nodeChar.getChild("abilities.spelllist"), sName, "spell", "pc");
		if stat then 
			return stat;
		end

		stat = getAbilityStatFromList(nodeChar.getChild("abilities.powerlist"), sName, "power", "pc");
		if stat then 
			return stat;
		end

		stat = getAbilityStatFromList(nodeChar.getChild("abilities.otherlist"), sName, "ability", "pc");
		if stat then 
			return stat;
		end

	else
		stat = getAttributeStatFromList(nodeChar.getChild("attributes"), sName, "npc");
		if stat then 
			return stat;
		end

		stat = getAbilityStatFromList(nodeChar.getChild("abilites.abilitieslist"), sName, "ability", "npc");
		if stat then 
			return stat;
		end
    end
    
	return;
end

function getAttributeStatFromList(nAttributeList, sName, sActorType)
	if not nAttributeList or not sName or sName:len() < 2 then
		return;
    end
    
    local name = StringManager.trim(sName:lower());
    if name == "st" then
        name = "strength";
    elseif name == "dx" then
        name = "dexterity";
    elseif name == "iq" then
        name = "intelligence";
    elseif name == "ht" then
        name = "health";
    elseif name == "per" then
        name = "perception";
    end

	local node = nAttributeList.getChild(name);
	if not node then
		return;
	end

	local result = {};
	result.requestedName = sName;
	result.name = name;
	result.actorType = sActorType;
	result.statType = "attribute";
	result.level = DB.getValue(nAttributeList, name, 0);
	result.points = DB.getValue(nAttributeList, name .. "_points", 0);
	return result;
end

-- Gets the numeric value of an ability from a list of abilities.
-- This will not return a default ability unless that default
-- ability has been entered in the list already.
function getAbilityStatFromList(nodeList, sName, sActorType, sStatType)
	if not nodeList or not sName or sName:len() < 2 then
		return;
	end

	for _, node in pairs(nodeList.getChildren()) do
		local name = DB.getValue(node, "name", "");
		if name == sName then
			local result = {};
			result.requestedName = sName;
			result.name = name;
			result.actorType = sActorType;
			result.statType = sStatType;
			result.level = DB.getValue(node, "level", 0);
			result.level_adj = DB.getValue(node, "level_adj", 0);
			result.points = DB.getValue(node, "points", 0);
			result.points_adj = DB.getValue(node, "points_adj", 0);
			result.basis = DB.getValue(node, "basis", CharAbilityManager.DEFAULT_BASIS_NAME);
			result.relativelevel = DB.getValue(node, "relativelevel", "");
			result.type = DB.getValue(node, "type", "");
			return result;
		end
	end
end
