-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

-- Define as module constants instead of local variables
STATUS_HEALTH_HEALTHY = "Healthy";
STATUS_HEALTH_GOOD = "Good";
STATUS_HEALTH_FAIR = "Fair";
STATUS_HEALTH_SERIOUS = "Serious";
STATUS_HEALTH_CRITICAL = "Critical";
STATUS_HEALTH_DEAD = "Dead";
STATUS_HEALTH_DESTROYED = "Destroyed";

COLOR_HEALTH_HEALTHY = "008000";
COLOR_HEALTH_GOOD = "408000";
COLOR_HEALTH_FAIR = "AF7817";
COLOR_HEALTH_SERIOUS = "E56717";
COLOR_HEALTH_CRITICAL = "C11B17";
COLOR_HEALTH_DEAD = "404040";
COLOR_HEALTH_DESTROYED = "404040";

STATUS_FATIGUE_NORMAL = "Normal";
STATUS_FATIGUE_FATIGUED = "Fatigued";
STATUS_FATIGUE_SERIOUS = "Serious";
STATUS_FATIGUE_UNCONSCIOUS = "Unconscious";

COLOR_FATIGUE_NORMAL = "008000";
COLOR_FATIGUE_FATIGUED = "AF7817";
COLOR_FATIGUE_SERIOUS = "E56717";
COLOR_FATIGUE_UNCONSCIOUS = "C11B17";

function onInit()
	ActorHealthManager.registerStatusHealthColor(ActorManagerGURPS4e.STATUS_HEALTH_HEALTHY, ActorManagerGURPS4e.COLOR_HEALTH_HEALTHY);
	ActorHealthManager.registerStatusHealthColor(ActorManagerGURPS4e.STATUS_HEALTH_GOOD, ActorManagerGURPS4e.COLOR_HEALTH_GOOD);
	ActorHealthManager.registerStatusHealthColor(ActorManagerGURPS4e.STATUS_HEALTH_FAIR, ActorManagerGURPS4e.COLOR_HEALTH_FAIR);
	ActorHealthManager.registerStatusHealthColor(ActorManagerGURPS4e.STATUS_HEALTH_SERIOUS, ActorManagerGURPS4e.COLOR_HEALTH_SERIOUS);
	ActorHealthManager.registerStatusHealthColor(ActorManagerGURPS4e.STATUS_HEALTH_CRITICAL, ActorManagerGURPS4e.COLOR_HEALTH_CRITICAL);
	ActorHealthManager.registerStatusHealthColor(ActorManagerGURPS4e.STATUS_HEALTH_DEAD, ActorManagerGURPS4e.COLOR_HEALTH_DEAD);
	ActorHealthManager.registerStatusHealthColor(ActorManagerGURPS4e.STATUS_HEALTH_DESTROYED, ActorManagerGURPS4e.COLOR_HEALTH_DESTROYED);

	ActorHealthManager.getWoundPercent = ActorManagerGURPS4e.getInjuryPercent;
end

function getInjuryPercent(v)
	local rActor = ActorManager.resolveActor(v);

	local nHP = 0;
	local nInjury = 0;
	
	local nodeCT = ActorManager.getCTNode(rActor);
	if nodeCT then
		nHP = DB.getValue(nodeCT, "attributes.hitpoints", 0);
		nInjury = DB.getValue(nodeCT, "injury", 0);
	elseif ActorManager.isPC(rActor) then
		local nodePC = ActorManager.getCreatureNode(rActor);
		if nodePC then
			nHP = DB.getValue(nodePC, "attributes.hitpoints", 0);
			nInjury = DB.getValue(nodePC, "attributes.injury", 0);
		end
	end

	local nPercentInjured = 0;
	if nHP > 0 then
		nPercentInjured = nInjury / nHP;
	end

	local sStatus;
	if nPercentInjured >= 11 then
		sStatus = ActorManagerGURPS4e.STATUS_HEALTH_DESTROYED;
	elseif nPercentInjured >= 6 then
		sStatus = ActorManagerGURPS4e.STATUS_HEALTH_DEAD;
	elseif nPercentInjured >= 2 then
		sStatus = ActorManagerGURPS4e.STATUS_HEALTH_CRITICAL;
	elseif nPercentInjured >= 1 then
		sStatus = ActorManagerGURPS4e.STATUS_HEALTH_SERIOUS;
	elseif nPercentInjured >= 1/2 then
		sStatus = ActorManagerGURPS4e.STATUS_HEALTH_FAIR;
	elseif nPercentInjured > 0 then
		sStatus = ActorManagerGURPS4e.STATUS_HEALTH_GOOD;
	else
		sStatus = ActorManagerGURPS4e.STATUS_HEALTH_HEALTHY;
	end

	return nPercentInjured, sStatus, nHP;
end

function getInjuryStatus(v)
	local nPercent, sStatus = ActorManagerGURPS4e.getInjuryPercent(v);

	local aColorMap = {
		[ActorManagerGURPS4e.STATUS_HEALTH_HEALTHY] = ActorManagerGURPS4e.COLOR_HEALTH_HEALTHY,
		[ActorManagerGURPS4e.STATUS_HEALTH_GOOD] = ActorManagerGURPS4e.COLOR_HEALTH_GOOD,
		[ActorManagerGURPS4e.STATUS_HEALTH_FAIR] = ActorManagerGURPS4e.COLOR_HEALTH_FAIR,
		[ActorManagerGURPS4e.STATUS_HEALTH_SERIOUS] = ActorManagerGURPS4e.COLOR_HEALTH_SERIOUS,
		[ActorManagerGURPS4e.STATUS_HEALTH_CRITICAL] = ActorManagerGURPS4e.COLOR_HEALTH_CRITICAL,
		[ActorManagerGURPS4e.STATUS_HEALTH_DEAD] = ActorManagerGURPS4e.COLOR_HEALTH_DEAD,
		[ActorManagerGURPS4e.STATUS_HEALTH_DESTROYED] = ActorManagerGURPS4e.COLOR_HEALTH_DESTROYED,
	};

	local sColor = aColorMap[sStatus] or ActorManagerGURPS4e.COLOR_HEALTH_HEALTHY;

	return nPercent, sStatus, sColor;
end

function getFatiguePercent(v)
	local rActor = ActorManager.resolveActor(v);
	
	local nFP = 0;
	local nFatigue = 0;
	
	local nodeCT = ActorManager.getCTNode(rActor);
	if nodeCT then
		nFP = DB.getValue(nodeCT, "attributes.fatiguepoints", 0);
		nFatigue = DB.getValue(nodeCT, "fatigue", 0);
	elseif ActorManager.isPC(rActor) then
		local nodePC = ActorManager.getCreatureNode(rActor);
		if nodePC then
			nFP = DB.getValue(nodePC, "attributes.fatiguepoints", 0);
			nFatigue = DB.getValue(nodePC, "attributes.fatigue", 0);
		end
	end

	local nPercentFatigued = 0;
	if nFP> 0 then
		nPercentFatigued = nFatigue / nFP;
	end

	local sStatus;
	if nPercentFatigued >= 2 then
		sStatus = ActorManagerGURPS4e.STATUS_FATIGUE_UNCONSCIOUS;
	elseif nPercentFatigued >= 1 then
		sStatus = ActorManagerGURPS4e.STATUS_FATIGUE_SERIOUS;
	elseif nPercentFatigued >= 1/3 then
		sStatus = ActorManagerGURPS4e.STATUS_FATIGUE_FATIGUED;
	else
		sStatus = ActorManagerGURPS4e.STATUS_FATIGUE_NORMAL;
	end

	return nPercentFatigued, sStatus, nFP;
end

function getFatigueStatus(v)
	local nPercent, sStatus = ActorManagerGURPS4e.getFatiguePercent(v);

	local aColorMap = {
		[ActorManagerGURPS4e.STATUS_FATIGUE_NORMAL] = ActorManagerGURPS4e.COLOR_FATIGUE_NORMAL,
		[ActorManagerGURPS4e.STATUS_FATIGUE_FATIGUED] = ActorManagerGURPS4e.COLOR_FATIGUE_FATIGUED,
		[ActorManagerGURPS4e.STATUS_FATIGUE_SERIOUS] = ActorManagerGURPS4e.COLOR_FATIGUE_SERIOUS,
		[ActorManagerGURPS4e.STATUS_FATIGUE_UNCONSCIOUS] = ActorManagerGURPS4e.COLOR_FATIGUE_UNCONSCIOUS,
	};

	local sColor = aColorMap[sStatus] or ActorManagerGURPS4e.COLOR_FATIGUE_NORMAL;

	return nPercent, sStatus, sColor;
end

function getHPStatusThreshold(v)
	local nPercent, _, nHP = ActorManagerGURPS4e.getInjuryPercent(v);
	
	if nHP <= 0 then
		return "N/A";
	end

	if nPercent >= 2 then
		return string.format("-%dxHP", math.floor(nPercent - 1));
	elseif nPercent >= 1 then
		return "0 HP";
	elseif nPercent >= 2/3 then
		return "1/3 HP";
	else
		return "";
	end
end

function getFPStatusThreshold(v)
	local nPercent, _, nFP = ActorManagerGURPS4e.getFatiguePercent(v);
	
	if nFP <= 0 then
		return "N/A";
	end

	if nPercent >= 2 then
		return string.format("-%dxFP", math.floor(nPercent - 1));
	elseif nPercent >= 1 then
		return "0 FP";
	elseif nPercent >= 2/3 then
		return "1/3 FP";
	else
		return "";
	end
end

function isDyingOrDead(rActor)
	local _, sStatus = ActorManagerGURPS4e.getInjuryPercent(rActor);
	return ActorManagerGURPS4e.isDyingOrDeadStatus(sStatus);
end

function isDyingOrDeadStatus(sStatus)
	return ((sStatus == ActorManagerGURPS4e.STATUS_HEALTH_DESTROYED) or
			(sStatus == ActorManagerGURPS4e.STATUS_HEALTH_DEAD) or
			(sStatus == ActorManagerGURPS4e.STATUS_HEALTH_CRITICAL));
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
	local nodeActor = ActorManager.getCreatureNode(rActor);
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
