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

COLOR_RESOURCE_MAX = "008000";
COLOR_RESOURCE_MIN = "C11B17";
COLOR_RESOURCE_USED = "AF7817";


local DEFAULT_NEW_ABILITY_POINTS = 1;

function onInit()
	DB.addHandler(DB.getPath("charsheet.*.attributes.*"), "onUpdate", onAttributeUpdated);
	DB.addHandler(DB.getPath("charsheet.*.traits.adslist.*.*"), "onUpdate", onAdvantageUpdated);
	DB.addHandler(DB.getPath("charsheet.*.traits.disadslist.*.*"), "onUpdate", onDisadvantageUpdated);
end

function getInjuryStatus(sNodeType, node)
	local rActor = ActorManager.getActor(sNodeType, node);
	
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
	local rActor = ActorManager.getActor(sNodeType, node);
	
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

function onAttributeUpdated(nodeAttribute)
	local nodeActor = nodeAttribute.getParent().getParent();
	local attributeName = nodeAttribute.getName();
	local newValue = DB.getValue(nodeActor, attributeName, 0);
	if attributeName == "strength" then
		onStrengthUpdated(nodeActor, newValue);
	elseif attributeName == "dexterity" then
		onDexterityUpdated(nodeActor, newValue);
	elseif attributeName == "intelligence" then
		onIntelligenceUpdated(nodeActor, newValue);
	elseif attributeName == "health" then
		onHealthUpdated(nodeActor, newValue);
	elseif attributeName == "perception" then
		onPerceptionUpdated(nodeActor, newValue);
	elseif attributeName == "will" then
		onWillUpdated(nodeActor, newValue);
	end
end

function onStrengthUpdated(nodeActor, newValue)
	ActorAbilityManager.reconcileAbilitiesBasedOn(nodeActor, "ST");
end

function onDexterityUpdated(nodeActor, newValue)
	ActorAbilityManager.reconcileAbilitiesBasedOn(nodeActor, "DX");
end

function onIntelligenceUpdated(nodeActor, newValue)
	ActorAbilityManager.reconcileAbilitiesBasedOn(nodeActor, "IQ");
end

function onHealthUpdated(nodeActor, newValue)
	ActorAbilityManager.reconcileAbilitiesBasedOn(nodeActor, "HT");
end

function onPerceptionUpdated(nodeActor, newValue)
	ActorAbilityManager.reconcileAbilitiesBasedOn(nodeActor, "Per");
end

function onWillUpdated(nodeActor, newValue)
	ActorAbilityManager.reconcileAbilitiesBasedOn(nodeActor, "Will");
end

function addAbility(nodeChar, nodeAbility)
	if not nodeChar or not nodeAbility then  
		return false;
	end

	local bSkill = LibraryDataGURPS4e.isSkill(nodeAbility);
	local bSpell = LibraryDataGURPS4e.isSpell(nodeAbility);
	local bPower = LibraryDataGURPS4e.isPower(nodeAbility);
	local bOther = LibraryDataGURPS4e.isOther(nodeAbility);
 
	if not (bSkill or bSpell or bPower or bOther) then
		return false;
	end

	local sActorType, nodeActor = ActorManager.getTypeAndNode(nodeChar);
	local abilityName = DB.getValue(nodeAbility,"name","");
	local defaultsLine = DB.getValue(nodeAbility,"defaults","");
	if sActorType ~= "pc" then
		local nodeAbilitiesList = DB.getChild(nodeChar, "abilities.abilitieslist")
		if not nodeAbilitiesList then
			nodeAbilitiesList = DB.createChild(nodeChar, "abilities.abilitieslist");
		end

		local typeNodeTarget;
		local npcNodeAbility;
		if bOther then
			nodeNPCAbility = DB.createChild(nodeAbilitiesList);
			DB.setValue(nodeNPCAbility, "name", "string", abilityName);
			DB.setValue(nodeNPCAbility, "level", "number", DB.getValue(nodeAbility,"otherlevel",0));
			return true;
		elseif bSkill then
			typeNodeTarget = "skilltype";
		elseif bSpell then
			typeNodeTarget = "spelltype";
		elseif bPower then
			typeNodeTarget = "powerskill";
		end

		if not typeNodeTarget then
			return false;
		end

		local abilityInfo = ActorAbilityManager.calculateAbilityInfo(nodeChar, DB.getValue(nodeAbility, typeNodeTarget, ""), 1, abilityName, defaultsLine, 0);
		if not abilityInfo then
			return false;
		end

		nodeNPCAbility = DB.createChild(nodeAbilitiesList);
		DB.setValue(nodeNPCAbility, "name", "string", abilityName);  
		DB.setValue(nodeNPCAbility, "level", "number", abilityInfo.level);
		return true;
	end

	if bSkill then
		local nodeSkillsList = DB.getChild(nodeChar, "abilities.skilllist");
		if not nodeSkillsList then
			nodeSkillsList = DB.createChild(nodeChar, "abilities.skilllist");
		end

		local abilityInfo = ActorAbilityManager.calculateAbilityInfo(nodeChar, DB.getValue(nodeAbility,"skilltype",""), DEFAULT_NEW_ABILITY_POINTS, abilityName, defaultsLine, 0);
		if not abilityInfo then
			return false;
		end

		local nodeSkill = DB.createChild(nodeSkillsList);
		DB.setValue(nodeSkill, "name", "string", abilityName);
		DB.setValue(nodeSkill, "text", "formattedtext", DB.getValue(nodeAbility,"text",""));
		DB.setValue(nodeSkill, "defaults", "string", DB.getValue(nodeAbility,"skilldefault",""));
		DB.setValue(nodeSkill, "prereqs", "string", DB.getValue(nodeAbility,"skillprerequisite",""));
		DB.setValue(nodeSkill, "page", "string", DB.getValue(nodeAbility,"page",""));
		DB.setValue(nodeSkill, "level_adj", "number", 0);
		DB.setValue(nodeSkill, "points_adj", "number", 0);
		DB.setValue(nodeSkill, "points", "number", DEFAULT_NEW_ABILITY_POINTS);
		DB.setValue(nodeSkill, "level", "number", abilityInfo.level);
		DB.setValue(nodeSkill, "type", "string", abilityInfo.type);
		return true;
	end

	if bSpell then
		local nodeSpellsList = DB.getChild(nodeChar, "abilities.spelllist");
		if not nodeSpellsList then
			nodeSpellsList = DB.createChild(nodeChar, "abilities.spelllist");
		end
	  
		local abilityInfo = ActorAbilityManager.calculateAbilityInfo(nodeChar, DB.getValue(nodeAbility,"spelltype",""), DEFAULT_NEW_ABILITY_POINTS, abilityName, defaultsLine, 0);
		if not abilityInfo then
			return false;
		end

		local nodeSpell = DB.createChild(nodeSpellsList);
		DB.setValue(nodeSpell, "name", "string", abilityName);
		DB.setValue(nodeSpell, "class", "string", DB.getValue(nodeAbility,"spellclass",""));
		DB.setValue(nodeSpell, "time", "string", DB.getValue(nodeAbility,"spelltimetocast",""));
		DB.setValue(nodeSpell, "duration", "string", DB.getValue(nodeAbility,"spellduration",""));
		DB.setValue(nodeSpell, "costmaintain", "string", DB.getValue(nodeAbility,"spellcost",""));
		DB.setValue(nodeSpell, "resist", "string", DB.getValue(nodeAbility,"spellresist",""));
		DB.setValue(nodeSpell, "college", "string", DB.getValue(nodeAbility,"spellcollege",""));
		DB.setValue(nodeSpell, "page", "string", DB.getValue(nodeAbility,"page",""));
		DB.setValue(nodeSpell, "text", "formattedtext", DB.getValue(nodeAbility,"text",""));
		DB.setValue(nodeSpell, "prereqs", "string", DB.getValue(nodeAbility,"spellprerequisite",""));
		DB.setValue(nodeSpell, "level_adj", "number", 0);
		DB.setValue(nodeSpell, "points_adj", "number", 0);
		DB.setValue(nodeSpell, "points", "number", DEFAULT_NEW_ABILITY_POINTS);
		DB.setValue(nodeSpell, "level", "number", abilityInfo.level);
		DB.setValue(nodeSpell, "type", "string", abilityInfo.type);
		return true;
	end

	if bPower then
		local nodePowersList = DB.getChild(nodeChar, "abilities.powerlist");
		if not nodePowersList then
			nodePowersList = DB.createChild(nodeChar, "abilities.powerlist");
		end

		local abilityInfo = ActorAbilityManager.calculateAbilityInfo(nodeChar, DB.getValue(nodeAbility,"powerskill",""), DEFAULT_NEW_ABILITY_POINTS, abilityName, defaultsLine, 0);
		if not abilityInfo then
			return false;
		end
		
		local nodePower = DB.createChild(nodePowersList);
		DB.setValue(nodePower, "name", "string", abilityName);  
		DB.setValue(nodePower, "text", "formattedtext", DB.getValue(nodeAbility,"text",""));
		DB.setValue(nodePower, "points", "number", DEFAULT_NEW_ABILITY_POINTS);
		DB.setValue(nodePower, "level", "number", abilityInfo.level);
		return true;
	end

	if bOther then
		local nodeOtherList = DB.getChild(nodeChar, "abilities.otherlist");
		if not nodeOthersList then
			nodeOthersList = DB.createChild(nodeChar, "abilities.otherlist");
		end

		local nodeOther = DB.createChild(nodeOtherList);
		DB.setValue(nodeOther, "name", "string", abilityName);  
		DB.setValue(nodeOther, "level", "number", DB.getValue(nodeAbility,"otherlevel",0));
		DB.setValue(nodeOther, "points", "number", DB.getValue(nodeAbility,"otherpoints",0));
		DB.setValue(nodeOther, "text", "formattedtext", DB.getValue(nodeAbility,"text",""));
		return true;
	end

	return false;
end

function addTrait(nodeChar, nodeTrait)
	if not nodeChar or not nodeTrait then  
		return false;
	end
 
	local bAdvantage = LibraryDataGURPS4e.isAdvantage(nodeTrait);
	local bDisadvantage = LibraryDataGURPS4e.isDisadvantage(nodeTrait);
	local bPerk = LibraryDataGURPS4e.isPerk(nodeTrait);
	local bQuirk = LibraryDataGURPS4e.isQuirk(nodeTrait);

	if not (bAdvantage or bDisadvantage or bPerk or bQuirk) then
		return false;
	end

	local sActorType, nodeActor = ActorManager.getTypeAndNode(nodeChar);
	if sActorType ~= "pc" then
		local nodeNPCTraits = DB.getChild(nodeChar, "traits");
		if not nodeNPCTraits then
			nodeNPCTraits = DB.createChild(nodeChar, "traits");
		end
		
		local traits = DB.getValue(nodeNPCTraits,"description","");  
		if not (traits == nil or traits == "") then
			traits = traits .. ", ";
		end
		traits = traits .. DB.getValue(nodeTrait,"name","");

		DB.setValue(nodeNPCTraits, "description", "string", traits);  

		return true;
	end

	if bAdvantage or bPerk then
		local nodeAdvantageList = DB.getChild(nodeChar, "traits.adslist");
		if not nodeAdvantageList then
			nodeAdvantageList = DB.createChild(nodeChar, "traits.adslist");
		end

		local nodeAdvantage = DB.createChild(nodeAdvantageList);
		DB.setValue(nodeAdvantage, "name", "string", DB.getValue(nodeTrait,"name",""));  
		DB.setValue(nodeAdvantage, "points", "number", DB.getValue(nodeTrait,"points",0));
		DB.setValue(nodeAdvantage, "page", "string", DB.getValue(nodeTrait, "page", ""));
		DB.setValue(nodeAdvantage, "text", "formattedtext", DB.getValue(nodeTrait,"text",""));

		return true;
	end

	if bDisadvantage or bQuirk then
		local nodeDisadvantageList = DB.getChild(nodeChar, "traits.disadslist")
		if not nodeDisadvantageList then
			nodeDisadvantageList = DB.createChild(nodeChar, "traits.disadslist");
		end

		local nodeDisadvantage = DB.createChild(nodeDisadvantageList);
		DB.setValue(nodeDisadvantage, "name", "string", DB.getValue(nodeTrait,"name",""));  
		DB.setValue(nodeDisadvantage, "points", "number", DB.getValue(nodeTrait,"points",0));
		DB.setValue(nodeDisadvantage, "page", "string", DB.getValue(nodeTrait, "page", ""));
		DB.setValue(nodeDisadvantage, "text", "formattedtext", DB.getValue(nodeTrait,"text",""));
		
		return true;
	end

	return false;
end

function onResourceUpdated(nodeResource)
	if not nodeResource then
		return 0;
	end

	local current = DB.getValue(nodeResource, "resource_level");
	local min = DB.getValue(nodeResource, "min_level");
	local max = DB.getValue(nodeResource, "max_level");

	if max and current >= max then
		DB.setValue(nodeResource, "resource_level", "number", max);
		return COLOR_RESOURCE_MAX
	end
        
	if min and current <= min then
		DB.setValue(nodeResource, "resource_level", "number", min);
		return COLOR_RESOURCE_MIN
	end

	return COLOR_RESOURCE_USED;
end


function onAdvantageUpdated(nodeField)
	local advantageName = nodeField.getName();
	local advantage = nodeField.getParent();
	if advantageName == "points" then
		local points = DB.getValue(advantage, "points", 0);
		if points < 0 then
			-- Note: This can cause a recursion warning. Since we are terminating the function
			-- right now anyway, this is okay.
			DB.setValue(advantage, "points", "number", 0);
			return;
		end
	end
end

function onDisadvantageUpdated(nodeField)
	local disadvantageName = nodeField.getName();
	local disadvantage = nodeField.getParent();
	if disadvantageName == "points" then
		local points = DB.getValue(disadvantage, "points", 0);
		if points > 0 then
			-- Note: This can cause a recursion warning. Since we are terminating the function
			-- right now anyway, this is okay.
			DB.setValue(disadvantage, "points", "number", 0);
			return;
		end
	end
end

function updateEncumbrance(nodeChar)
	local sActorType, nodeActor = ActorManager.getTypeAndNode(nodeChar);
	if sActorType ~= "pc" and sActorType ~= "ct" then
		return;
	end

	if sActorType == "pc" then
		local nodeEnc = DB.getChild(nodeActor, "encumbrance");
		local nTotal = DB.getValue(nodeEnc,"load",0);

		local nEncNone = tonumber(string.match(DB.getValue(nodeEnc,"enc0_weight","0"), "%d+")) or 0;
		local nEncLight = tonumber(string.match(DB.getValue(nodeEnc,"enc1_weight","0"), "%d+")) or 0;
		local nEncMedium = tonumber(string.match(DB.getValue(nodeEnc,"enc2_weight","0"), "%d+")) or 0;
		local nEncHeavy = tonumber(string.match(DB.getValue(nodeEnc,"enc3_weight","0"), "%d+")) or 0;
		local nEncXHeavy = tonumber(string.match(DB.getValue(nodeEnc,"enc4_weight","0"), "%d+")) or 0;

		DB.setValue(nodeEnc, "enc_0", "number", 0);  
		DB.setValue(nodeEnc, "enc_1", "number", 0);  
		DB.setValue(nodeEnc, "enc_2", "number", 0);  
		DB.setValue(nodeEnc, "enc_3", "number", 0);  
		DB.setValue(nodeEnc, "enc_4", "number", 0);  

		if nTotal <= nEncNone then 
			DB.setValue(nodeEnc, "level", "string", "None");  
			DB.setValue(nodeEnc, "enc_0", "number", 1);  
			DB.setValue(nodeActor, "attributes.move", "string", DB.getValue(nodeEnc,"enc0_move","0"));  
			DB.setValue(nodeActor, "combat.dodge", "number", DB.getValue(nodeEnc,"enc0_dodge",0));  
		elseif nTotal <= nEncLight then 
			DB.setValue(nodeEnc, "level", "string", "Light");  
			DB.setValue(nodeEnc, "enc_1", "number", 1);  
			DB.setValue(nodeActor, "attributes.move", "string", DB.getValue(nodeEnc,"enc1_move","0"));  
			DB.setValue(nodeActor, "combat.dodge", "number", DB.getValue(nodeEnc,"enc1_dodge",0));  
		elseif nTotal <= nEncMedium then 
			DB.setValue(nodeEnc, "level", "string", "Medium");  
			DB.setValue(nodeEnc, "enc_2", "number", 1);  
			DB.setValue(nodeActor, "attributes.move", "string", DB.getValue(nodeEnc,"enc2_move","0"));  
			DB.setValue(nodeActor, "combat.dodge", "number", DB.getValue(nodeEnc,"enc2_dodge",0));  
		elseif nTotal <= nEncHeavy then 
			DB.setValue(nodeEnc, "level", "string", "Heavy");  
			DB.setValue(nodeEnc, "enc_3", "number", 1);  
			DB.setValue(nodeActor, "attributes.move", "string", DB.getValue(nodeEnc,"enc3_move","0"));  
			DB.setValue(nodeActor, "combat.dodge", "number", DB.getValue(nodeEnc,"enc3_dodge",0));  
		elseif nTotal <= nEncXHeavy then 
			DB.setValue(nodeEnc, "level", "string", "X-Heavy");  
			DB.setValue(nodeEnc, "enc_4", "number", 1);  
			DB.setValue(nodeActor, "attributes.move", "string", DB.getValue(nodeEnc,"enc4_move","0"));  
			DB.setValue(nodeActor, "combat.dodge", "number", DB.getValue(nodeEnc,"enc4_dodge",0));  
		else
			DB.setValue(nodeEnc, "level", "string", "Overloaded");  
			DB.setValue(nodeEnc, "enc_0", "number", 1);  
			DB.setValue(nodeEnc, "enc_1", "number", 1);  
			DB.setValue(nodeEnc, "enc_2", "number", 1);  
			DB.setValue(nodeEnc, "enc_3", "number", 1);  
			DB.setValue(nodeEnc, "enc_4", "number", 1);  
			DB.setValue(nodeActor, "attributes.move", "string", "0");  
			DB.setValue(nodeActor, "combat.dodge", "number", 3);  
		end
	else
		local move = tonumber(string.match(DB.getValue(nodeActor, "basemove", "0"), "%d+") or 0);
		local dodge = DB.getValue(nodeActor, "basedodge", 0);

		DB.setValue(nodeActor, "attributes.move", "string", move);  
		DB.setValue(nodeActor, "combat.dodge", "number", dodge);  
	end

	if DB.getValue(nodeActor, "attributes.halfmovedodge", 0) == 1 then 
		local halfMove = math.ceil(tonumber(string.match(DB.getValue(nodeActor, "attributes.move", "0"), "%d+") or 0) / 2);
		local halfDodge = math.ceil(DB.getValue(nodeActor, "combat.dodge", 0) / 2);
		DB.setValue(nodeActor, "attributes.move", "string", halfMove);  
		DB.setValue(nodeActor, "combat.dodge", "number", halfDodge);  
	end
end

function getTypeAndRootNode(node)
	while node.getParent() ~= nil and node.getParent().getNodeName() ~= "charsheet" and node.getParent().getNodeName() ~= "npc" do
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
			result.basis = DB.getValue(node, "basis", ActorAbilityManager.DEFAULT_BASIS_NAME);
			result.relativelevel = DB.getValue(node, "relativelevel", "");
			result.type = DB.getValue(node, "type", "");
			return result;
		end
	end
end

function updatePointsTotal(nodeChar)
	local sActorType, nodeActor = getTypeAndRootNode(nodeChar);
	if sActorType ~= "pc" then
		return;
	end

	if sActorType == "pc" then
	  local total = 0;
	  local temp = 0;
	  local tempquirks = 0;
	  local tempdisadvantages = 0;

	  local attributes = {};
	  table.insert(attributes, DB.getValue(nodeActor,"attributes.strength_points",0));
	  table.insert(attributes, DB.getValue(nodeActor,"attributes.dexterity_points",0));
	  table.insert(attributes, DB.getValue(nodeActor,"attributes.intelligence_points",0));
	  table.insert(attributes, DB.getValue(nodeActor,"attributes.health_points",0));
	  table.insert(attributes, DB.getValue(nodeActor,"attributes.hitpoints_points",0));
	  table.insert(attributes, DB.getValue(nodeActor,"attributes.will_points",0));
	  table.insert(attributes, DB.getValue(nodeActor,"attributes.perception_points",0));
	  table.insert(attributes, DB.getValue(nodeActor,"attributes.fatiguepoints_points",0));
	  table.insert(attributes, DB.getValue(nodeActor,"attributes.basicspeed_points",0));
	  table.insert(attributes, DB.getValue(nodeActor,"attributes.basicmove_points",0));
	  table.insert(attributes, DB.getValue(nodeActor,"traits.tl_points",0));
  
	  for _,value in pairs(attributes) do 
		temp = temp + value;
		if value < 0 then
		  tempdisadvantages = tempdisadvantages + value;
		end
	  end

	  DB.setValue(nodeActor,"pointtotals.attributes","number",temp);

	  total = total + temp;
	  temp = 0;

	  for _,node in pairs(DB.getChildren(nodeActor,"traits.culturalfamiliaritylist")) do
		temp = temp + DB.getValue(node,"points",0);
	  end

	  for _,node in pairs(DB.getChildren(nodeActor,"traits.languagelist")) do
		temp = temp + DB.getValue(node,"points",0);
	  end

	  for _,node in pairs(DB.getChildren(nodeActor,"traits.adslist")) do
		temp = temp + DB.getValue(node,"points",0);
	  end
	  DB.setValue(nodeActor,"pointtotals.ads","number",temp);

	  total = total + temp;
	  temp = 0;

	  for _,node in pairs(DB.getChildren(nodeActor,"traits.disadslist")) do
		if DB.getValue(node,"points",0) == -1 then
		  tempquirks = tempquirks + DB.getValue(node,"points",0);
		else
		  temp = temp + DB.getValue(node,"points",0);
		end
	  end
	  DB.setValue(nodeActor,"pointtotals.disads","number",temp);
	  DB.setValue(nodeActor,"pointtotals.quirks","number",tempquirks);
  	  DB.setValue(nodeActor,"pointtotals.totaldisads","number",temp + tempdisadvantages + tempquirks);

	  total = total + temp + tempquirks;
	  temp = 0;
  
	  for _,node in pairs(DB.getChildren(nodeActor,"abilities.skilllist")) do
		temp = temp + DB.getValue(node,"points",0);
	  end
	  DB.setValue(nodeActor,"pointtotals.skills","number",temp);

	  total = total + temp;
	  temp = 0;

	  for _,node in pairs(DB.getChildren(nodeActor,"abilities.spelllist")) do
		temp = temp + DB.getValue(node,"points",0);
	  end
	  DB.setValue(nodeActor,"pointtotals.spells","number",temp);

	  total = total + temp;
	  temp = 0;

	  for _,node in pairs(DB.getChildren(nodeActor,"abilities.powerlist")) do
		temp = temp + DB.getValue(node,"points",0);
	  end
	  DB.setValue(nodeActor,"pointtotals.powers","number",temp);

	  total = total + temp;
	  temp = 0;
 
	  for _,node in pairs(DB.getChildren(nodeActor,"abilities.otherlist")) do
		temp = temp + DB.getValue(node,"points",0);
	  end
	  DB.setValue(nodeActor,"pointtotals.others","number",temp);

	  total = total + temp;

	  local disads = DB.getValue(nodeActor,"pointtotals.disads",0);
	  local totaldisads = DB.getValue(nodeActor,"pointtotals.totaldisads",0);

	  if disads == totaldisads then
	    DB.setValue(nodeActor,"pointtotals.disadsummary","string", string.format("%d", disads));
	  else
		DB.setValue(nodeActor,"pointtotals.disadsummary","string", string.format("%d (%d)", disads, totaldisads));  
	  end 

	  DB.setValue(nodeActor,"pointtotals.totalpoints","number",total);
	end
end
