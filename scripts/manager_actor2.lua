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
COLOR_FATIGUE_CRITICAL = "C11B17";

function getInjuryStatus(sNodeType, node)
	local rActor = ActorManager.getActor(sNodeType, node);
	
	local nHP = DB.getValue(node, "attributes.hitpoints", 0);
	local nCHP = DB.getValue(node, "hps", 0);

	local sStatus, nStatus;
	if nCHP >= nHP then
		sStatus = "Healthy";
		nStatus = 0;
	elseif nCHP > 0 and nCHP > nHP/2 then
		sStatus = "Good";
		nStatus = 1;
	elseif nCHP > 0 then
		sStatus = "Fair";
	    nStatus = 2;
	elseif nCHP < 1 and nCHP > -nHP then
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
	elseif nCFP > 0 and nCFP < nFP/3 then
		sStatus = "Fatigued";
		nStatus = 1;
	else
		sStatus = "Critical";
	    nStatus = 2;
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
	else
	    sColor = COLOR_FATIGUE_CRITICAL;
	end

	return sColor, sStatus, nStatus;
end

function getHPStatus(sNodeType, node)
	if sNodeType ~= "pc" and sNodeType ~= "ct" then
	Debug.chat(sNodeType, node);
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

	if nHP == 0 then return ""; end;

	local hpLevel = math.floor(nInjury/nHP) - 1;

	return (hpLevel > 0 and -hpLevel.."xHP" or "");
end

function getSkillLevel(nodeChar, type, points)
	if not nodeChar then  
		return;
	end

	local attribute, difficulty = type:match("^(%a+)[/]([%a%s]+)");
	if not attribute or not difficulty then
		return;
	end

	local nLevel, skilltype, relativelevel;
	
	nLevel = 0
	if attribute:lower() ~= "tech" then
		if points == 1 then
			nLevel = 0;
		elseif points == 2 then
			nLevel = 1;
		elseif points >= 4 then
			nLevel = 1 + math.floor(points/4);
		end

		if difficulty:lower() == "easy" then
			skilltype = string.format("%s/%s", attribute, "E");
		elseif difficulty:lower() == "average" then
			skilltype = string.format("%s/%s", attribute, "A");
			nLevel = nLevel - 1;
		elseif difficulty:lower() == "hard" then
			skilltype = string.format("%s/%s", attribute, "H");
			nLevel = nLevel - 2;
		elseif difficulty:lower() == "very hard" then
			skilltype = string.format("%s/%s", attribute, "VH");
			nLevel = nLevel - 3;
		end

		relativelevel = string.format("%s%s%d", attribute, (nLevel >= 0 and "+" or ""), nLevel);
	elseif attribute:lower() == "tech" then
		if difficulty:lower() == "average" then
			skilltype = string.format("%s/%s", attribute, "A");
			nLevel = points;
		elseif difficulty:lower() == "hard" then
			skilltype = string.format("%s/%s", attribute, "H");
			nLevel = (points >= 2 and points - 1 or 0);
		end

		relativelevel = string.format("Def+%d", nLevel);
	end

	if nodeChar then  
		if attribute:lower() == "st" then
			nLevel = nLevel + DB.getValue(nodeChar,"attributes.strength",0);
		elseif attribute:lower() == "dx" then
			nLevel = nLevel + DB.getValue(nodeChar,"attributes.dexterity",0);
		elseif attribute:lower() == "iq" then
			nLevel = nLevel + DB.getValue(nodeChar,"attributes.intelligence",0);
		elseif attribute:lower() == "ht" then
			nLevel = nLevel + DB.getValue(nodeChar,"attributes.health",0);
		elseif attribute:lower() == "will" then
			nLevel = nLevel + DB.getValue(nodeChar,"attributes.will",0);
		elseif attribute:lower() == "per" then
			nLevel = nLevel + DB.getValue(nodeChar,"attributes.perception",0);
		else
			nLevel = 0;
		end
	end

	return nLevel, skilltype, relativelevel;
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
	if sActorType ~= "pc" then
		local nodeAbilitiesList = DB.getChild(nodeChar, "abilities.abilitieslist")
		if not nodeAbilitiesList then
			nodeAbilitiesList = DB.createChild(nodeChar, "abilities.abilitieslist");
		end

		local level = 0;
		if bSkill then
			level = getSkillLevel(nodeChar, DB.getValue(nodeAbility,"skilltype",""), 1);
		elseif bSpell then
			level = getSkillLevel(nodeChar, DB.getValue(nodeAbility,"spelltype",""), 1);
		elseif bPower then
			level = getSkillLevel(nodeChar, DB.getValue(nodeAbility,"powerskill",""), 1);
		elseif bOther then
			level = DB.getValue(nodeAbility,"otherlevel",0);
		end

		local nodeNPCAbility = DB.createChild(nodeAbilitiesList);
		DB.setValue(nodeNPCAbility, "name", "string", DB.getValue(nodeAbility,"name",""));  
		DB.setValue(nodeNPCAbility, "level", "number", level);

		return true;
	end

	if bSkill then
		local nodeSkillsList = DB.getChild(nodeChar, "abilities.skilllist");
		if not nodeSkillsList then
			nodeSkillsList = DB.createChild(nodeChar, "abilities.skilllist");
		end

		local level, type, relativelevel = getSkillLevel(nodeChar, DB.getValue(nodeAbility,"skilltype",""), 1);

		local nodeSkill = DB.createChild(nodeSkillsList);
		DB.setValue(nodeSkill, "name", "string", DB.getValue(nodeAbility,"name",""));  
		DB.setValue(nodeSkill, "level", "number", level);
		DB.setValue(nodeSkill, "type", "string", type);
		DB.setValue(nodeSkill, "relativelevel", "string", relativelevel);
		DB.setValue(nodeSkill, "points", "number", 1);
		DB.setValue(nodeSkill, "text", "formattedtext", DB.getValue(nodeAbility,"text",""));

		return true;
	end

	if bSpell then
		local nodeSpellsList = DB.getChild(nodeChar, "abilities.spelllist");
		if not nodeSpellsList then
			nodeSpellsList = DB.createChild(nodeChar, "abilities.spelllist");
		end

		local level, type, relativelevel = getSkillLevel(nodeChar, DB.getValue(nodeAbility,"spelltype",""), 1);
	  
		local nodeSpell = DB.createChild(nodeSpellsList);
		DB.setValue(nodeSpell, "name", "string", DB.getValue(nodeAbility,"name",""));  
		DB.setValue(nodeSpell, "level", "number", level);
		DB.setValue(nodeSpell, "class", "string", DB.getValue(nodeAbility,"spellclass",""));
		DB.setValue(nodeSpell, "type", "string", type);
		DB.setValue(nodeSpell, "points", "number", 1);
		DB.setValue(nodeSpell, "time", "string", DB.getValue(nodeAbility,"spelltimetocast",""));
		DB.setValue(nodeSpell, "duration", "string", DB.getValue(nodeAbility,"spellduration",""));
		DB.setValue(nodeSpell, "costmaintain", "string", DB.getValue(nodeAbility,"spellcost",""));
		DB.setValue(nodeSpell, "resist", "string", DB.getValue(nodeAbility,"spellresist",""));
		DB.setValue(nodeSpell, "college", "string", DB.getValue(nodeAbility,"spellcollege",""));
		DB.setValue(nodeSpell, "page", "string", DB.getValue(nodeAbility,"page",""));
		DB.setValue(nodeSpell, "text", "formattedtext", DB.getValue(nodeAbility,"text",""));
	
		return true;
	end

	if bPower then
		local nodePowersList = DB.getChild(nodeChar, "abilities.powerlist");
		if not nodePowersList then
			nodePowersList = DB.createChild(nodeChar, "abilities.powerlist");
		end

		local level, type, relativelevel = getSkillLevel(nodeChar, DB.getValue(nodeAbility,"powerskill",""), 1);

		local nodePower = DB.createChild(nodePowersList);
		DB.setValue(nodePower, "name", "string", DB.getValue(nodeAbility,"name",""));  
		DB.setValue(nodePower, "level", "number", level);
		DB.setValue(nodePower, "points", "number", 1);
		DB.setValue(nodePower, "text", "formattedtext", DB.getValue(nodeAbility,"text",""));
	
		return true;
	end

	if bOther then
		local nodeOtherList = DB.getChild(nodeChar, "abilities.otherlist");
		if not nodeOthersList then
			nodeOthersList = DB.createChild(nodeChar, "abilities.otherlist");
		end

		local nodeOther = DB.createChild(nodeOtherList);
		DB.setValue(nodeOther, "name", "string", DB.getValue(nodeAbility,"name",""));  
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
		DB.setValue(nodeDisadvantage, "text", "formattedtext", DB.getValue(nodeTrait,"text",""));

		return true;
	end

	return false;
end

function updateEncumbrance(nodeChar)
	local sActorType, nodeActor = ActorManager.getTypeAndNode(nodeChar);
	if not sActorType or not nodeActor then  
		return false;
	end

	local nodeEnc = DB.getChild(nodeActor, "encumbrance");
	local nTotal = DB.getValue(nodeEnc,"load",0);

	local nEncNone = tonumber(DB.getValue(nodeEnc,"enc0_weight","0")) or 0;
	local nEncLight = tonumber(DB.getValue(nodeEnc,"enc1_weight","0")) or 0;
	local nEncMedium = tonumber(DB.getValue(nodeEnc,"enc2_weight","0")) or 0;
	local nEncHeavy = tonumber(DB.getValue(nodeEnc,"enc3_weight","0")) or 0;
	local nEncXHeavy = tonumber(DB.getValue(nodeEnc,"enc4_weight","0")) or 0;

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

	return true;
end
