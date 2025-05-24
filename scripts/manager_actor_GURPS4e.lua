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

function getInjuryStatus(nodeChar)
	local rActor = ActorManager.resolveActor(nodeChar);

	local nHP = 0;
	local nCHP = 0;
	
	local nodeCT = ActorManager.getCTNode(rActor);
	if nodeCT then
		nHP = DB.getValue(nodeCT, "attributes.hitpoints", 0);
		nCHP = DB.getValue(nodeCT, "hps", 0);
	elseif ActorManager.isPC(rActor) then
		local nodePC = ActorManager.getCreatureNode(rActor);
		if nodePC then
			nHP = DB.getValue(nodePC, "attributes.hitpoints", 0);
			nCHP = DB.getValue(nodePC, "hps", 0);
		end
	end

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

	return sStatus, nStatus;
end

function getInjuryStatusColor(nodeChar)
	local sStatus, nStatus = getInjuryStatus(nodeChar);
	if not nodeChar then
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

function getFatigueStatus(nodeChar)
	local rActor = ActorManager.resolveActor(nodeChar);
	
	local nFP = 0;
	local nCFP = 0;
	
	local nodeCT = ActorManager.getCTNode(rActor);
	if nodeCT then
		nFP = DB.getValue(nodeCT, "attributes.fatiguepoints", 0);
		nCFP = DB.getValue(nodeCT, "fps", 0);
	elseif ActorManager.isPC(rActor) then
		local nodePC = ActorManager.getCreatureNode(rActor);
		if nodePC then
			nFP = DB.getValue(nodePC, "attributes.fatiguepoints", 0);
			nCFP = DB.getValue(nodePC, "fps", 0);
		end
	end

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

	return sStatus, nStatus;
end

function getFatigueStatusColor(nodeChar)
	local sStatus, nStatus = getFatigueStatus(nodeChar);
	if not nodeChar then
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

function getHPStatus(rActor)
	local nodeActor;
	if ActorManager.isPC(rActor) then
		nodeActor = ActorManager.getCreatureNode(rActor);
	else
		nodeActor = ActorManager.getCTNode(rActor);
	end
	if not nodeActor then
		return;
	end
	
	local nHP = 0;
	local nInjury = 0;

	if ActorManager.isPC(rActor) then
		nHP = DB.getValue(nodeActor, "attributes.hitpoints", 0);
		nInjury = DB.getValue(nodeActor, "attributes.injury", 0);
	elseif ActorManager.isRecordType(rActor, "npc") then 
		nHP = DB.getValue(nodeActor, "attributes.hitpoints", 0);
		nInjury = DB.getValue(nodeActor, "injury", 0);
	end

	if nHP == 0 then return "N/A"; end;

	local hpLevel = math.floor(nInjury/nHP) - 1;
	if hpLevel > 0 then return -hpLevel.."xHP"; end;

	if (nHP - nInjury) <= 0 then return "0 HP"; end;

	if (nHP - nInjury) < nHP/3 then return "1/3 HP"; end;

	return "";
end

function getFPStatus(rActor)
	local nodeActor;
	if ActorManager.isPC(rActor) then
		nodeActor = ActorManager.getCreatureNode(rActor);
	else
		nodeActor = ActorManager.getCTNode(rActor);
	end
	if not nodeActor then
		return;
	end
	
	local nFP = 0;
	local nFatigue = 0;

	if ActorManager.isPC(rActor) then
		nFP = DB.getValue(nodeActor, "attributes.fatiguepoints", 0);
		nFatigue = DB.getValue(nodeActor, "attributes.fatigue", 0);
	elseif ActorManager.isRecordType(rActor, "npc") then
		nFP = DB.getValue(nodeActor, "attributes.fatiguepoints", 0);
		nFatigue = DB.getValue(nodeActor, "fatigue", 0);
	end

	if nFP == 0 then return "N/A"; end;

	local fpLevel = math.floor(nFatigue/nFP) - 1;
	if fpLevel > 0 then return -fpLevel.."xFP"; end;

	if (nFP - nFatigue) <= 0 then return "0 FP"; end;

	if (nFP - nFatigue) < nFP/3 then return "1/3 FP"; end;

	return "";
end

function hasMeleeWeapons(rActor)
	local nodeActor;
	if ActorManager.isPC(rActor) then
		nodeActor = ActorManager.getCreatureNode(rActor);
	else
		nodeActor = ActorManager.getCTNode(rActor);
	end
	if not nodeActor then
		return;
	end

	local nCount = DB.getChildCount(nodeActor, "combat.meleecombatlist");
	if nCount > 0 then
		return true;
	end
  
	return false
end

function hasRangedWeapons(rActor)
	local nodeActor;
	if ActorManager.isPC(rActor) then
		nodeActor = ActorManager.getCreatureNode(rActor);
	else
		nodeActor = ActorManager.getCTNode(rActor);
	end
	if not nodeActor then
		return;
	end

	local nCount = DB.getChildCount(nodeActor, "combat.rangedcombatlist");
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

-- Given an actor and the name of an attribute or ability, this will return a table with
-- current information about that stat.
function getStat(rActor, sName)
	local nodeActor;
	if ActorManager.isPC(rActor) then
		nodeActor = ActorManager.getCreatureNode(rActor);
	else
		nodeActor = ActorManager.getCTNode(rActor);
	end
	if not nodeActor then
		return;
	end

	if not sName or sName:len() < 2 then
		return;
	end

	local stat;
	if ActorManager.isPC(rActor) then
		stat = getAttributeStatFromList(nodeActor.getChild("attributes"), sName, "pc");
		if stat then 
			return stat;
		end

		stat = getAbilityStatFromList(nodeActor.getChild("abilities.skilllist"), sName, "skill", "pc");
		if stat then 
			return stat;
		end

		stat = getAbilityStatFromList(nodeActor.getChild("abilities.spelllist"), sName, "spell", "pc");
		if stat then 
			return stat;
		end

		stat = getAbilityStatFromList(nodeActor.getChild("abilities.powerlist"), sName, "power", "pc");
		if stat then 
			return stat;
		end

		stat = getAbilityStatFromList(nodeActor.getChild("abilities.otherlist"), sName, "ability", "pc");
		if stat then 
			return stat;
		end
	elseif ActorManager.isRecordType(rActor, "npc") then
		stat = getAttributeStatFromList(nodeActor.getChild("attributes"), sName, "npc");
		if stat then 
			return stat;
		end

		stat = getAbilityStatFromList(nodeActor.getChild("abilites.abilitieslist"), sName, "ability", "npc");
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
