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
	DB.addHandler(DB.getPath("charsheet.*.abilities.skilllist"), "onChildAdded", onPCSkillAdded);
	DB.addHandler(DB.getPath("charsheet.*.abilities.spelllist"), "onChildAdded", onPCSpellAdded);
	DB.addHandler(DB.getPath("charsheet.*.abilities.powerlist"), "onChildAdded", onPCPowerAdded);
	DB.addHandler(DB.getPath("charsheet.*.abilities.otherlist"), "onChildAdded", onPCOtherAbilityAdded);
	DB.addHandler(DB.getPath("charsheet.*.abilities.skilllist.*"), "onChildUpdate", onPCSkillUpdated);
	DB.addHandler(DB.getPath("charsheet.*.abilities.spelllist.*"), "onChildUpdate", onPCSpellUpdated);
	DB.addHandler(DB.getPath("charsheet.*.abilities.powerlist.*"), "onChildUpdate", onPCPowerUpdated);
	DB.addHandler(DB.getPath("charsheet.*.abilities.otherlist.*"), "onChildUpdate", onPCOtherAbilityUpdated);
	DB.addHandler(DB.getPath("charsheet.*.traits.adslist"), "onChildAdded", onPCAdvantageAdded);
	DB.addHandler(DB.getPath("charsheet.*.traits.disadslist"), "onChildAdded", onPCDisadvantageAdded);
	DB.addHandler(DB.getPath("charsheet.*.traits.adslist.*"), "onChildUpdate", onPCAdvantageUpdated);
	DB.addHandler(DB.getPath("charsheet.*.traits.disadslist.*"), "onChildUpdate", onPCDisadvantageUpdated);
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

function getSkillLevel(nodeChar, type, points)
	if not nodeChar then  
		return;
	end

	local attribute, difficulty = type:match("^(%a+)[/]([%a%s]+)");
	if not attribute or not difficulty then
		return;
	end

	local nLevel = -4;
	local relativelevel = "";
	local skilltype;
	
	if attribute:lower() ~= "tech" then
		if points >=4 then
			nLevel = 1 + math.floor(points/4);
		elseif points >= 2 then
			nLevel = 1;
		elseif points == 1 then
			nLevel = 0;
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

	local result = { };
	result.adjustedLevel = nLevel;
	result.abbreviatedSkillType = skilltype;
	result.relativeLevel = relativelevel;
	return result;
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

		local skillData = {};
		local level = 0;
		if bSkill then
			skillData = getSkillLevel(nodeChar, DB.getValue(nodeAbility,"skilltype",""), 1);
			if not skillData then
				return false;
			end
			level = skillData.adjustedLevel;
		elseif bSpell then
			skillData = getSkillLevel(nodeChar, DB.getValue(nodeAbility,"spelltype",""), 1);
			if not skillData then
				return false;
			end
			level = skillData.adjustedLevel;
		elseif bPower then
			skillData = getSkillLevel(nodeChar, DB.getValue(nodeAbility,"powerskill",""), 1);
			if not skillData then
				return false;
			end
			level = skillData.adjustedLevel;
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

		local nodeSkill = DB.createChild(nodeSkillsList);
		DB.copyNode(nodeAbility, nodeSkill);
		local skillData = getSkillLevel(nodeChar, DB.getValue(nodeAbility,"skilltype",""), 1);
		if not skillData then
			return false;
		end
		DB.setValue(nodeSkill, "points", "number", 1);
		DB.setValue(nodeSkill, "level", "number", skillData.adjustedLevel);
		DB.setValue(nodeSkill, "type_abbr", "string", skillData.abbreviatedSkillType);
		DB.setValue(nodeSkill, "relativelevel", "string", skillData.relativeLevel);
		return true;
	end

	if bSpell then
		local nodeSpellsList = DB.getChild(nodeChar, "abilities.spelllist");
		if not nodeSpellsList then
			nodeSpellsList = DB.createChild(nodeChar, "abilities.spelllist");
		end
	  
		local nodeSpell = DB.createChild(nodeSpellsList);
		DB.copyNode(nodeAbility, nodeSpell);
		local skillData = getSkillLevel(nodeChar, DB.getValue(nodeAbility,"spelltype",""), 1);
		if not skillData then
			return false;
		end
		DB.setValue(nodeSpell, "points", "number", 1);
		DB.setValue(nodeSpell, "level", "number", skillData.adjustedLevel);
		DB.setValue(nodeSpell, "type_abbr", "string", skillData.abbreviatedSkillType);
		DB.setValue(nodeSpell, "relativelevel", "string", skillData.relativeLevel);
		return true;
	end

	if bPower then
		local nodePowersList = DB.getChild(nodeChar, "abilities.powerlist");
		if not nodePowersList then
			nodePowersList = DB.createChild(nodeChar, "abilities.powerlist");
		end

		local nodePower = DB.createChild(nodePowersList);
		DB.copyNode(nodeAbility, nodePower);
		local skillData = getSkillLevel(nodeChar, DB.getValue(nodeAbility,"powerskill",""), 1);
		if not skillData then
			return false;
		end
		DB.setValue(nodePower, "points", "number", 1);
		DB.setValue(nodePower, "level", "number", skillData.adjustedLevel);
		DB.setValue(nodePower, "type_abbr", "string", skillData.abbreviatedSkillType);
		DB.setValue(nodePower, "relativelevel", "string", skillData.relativeLevel);
		return true;
	end

	if bOther then
		local nodeOtherList = DB.getChild(nodeChar, "abilities.otherlist");
		if not nodeOthersList then
			nodeOthersList = DB.createChild(nodeChar, "abilities.otherlist");
		end

		local nodeOther = DB.createChild(nodeOtherList);
		DB.copyNode(nodeAbility, nodePower);
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
		DB.copyNode(nodeTrait, nodeAdvantage);
		return true;
	end

	if bDisadvantage or bQuirk then
		local nodeDisadvantageList = DB.getChild(nodeChar, "traits.disadslist")
		if not nodeDisadvantageList then
			nodeDisadvantageList = DB.createChild(nodeChar, "traits.disadslist");
		end

		local nodeDisadvantage = DB.createChild(nodeDisadvantageList);
		DB.copyNode(nodeTrait, nodeDisadvantage);
		return true;
	end

	return false;
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

function onPCSkillAdded(nSkillList, nSkill)
	if nSkill and DB.getValue(nSkill, "type", "") ~= "Skill" then
		DB.setValue(nSkill, "type", "string", "Skill");
	end
end

function onPCSpellAdded(nSpellList, nSpell)
	if nSpell and DB.getValue(nSpell, "type", "") ~= "Spell" then
		DB.setValue(nSpell, "type", "string", "Spell");
	end
end

function onPCPowerAdded(nPowerList, nPower)
	if nPower and DB.getValue(nPower, "type", "") ~= "Power" then
		DB.setValue(nPower, "type", "string", "Power");
	end
end

function onPCOtherAbilityAdded(nOtherList, nOtherAbility)
	if nOtherAbility and DB.getValue(nOtherAbility, "type", "") ~= "Other" then
		DB.setValue(nOtherAbility, "type", "string", "Other");
	end
end

function onPCSkillUpdated(nodeSkill)
	if DB.getValue(nodeSkill, "type", "") ~= "Skill" then
		-- someone changed the type somehow, so change it back.
		DB.setValue(nodeSkill, "type", "string", "Skill");
		return;
	end

	local nodeChar = nodeSkill.getParent().getParent().getParent();
	local skillData = getSkillLevel(nodeChar, DB.getValue(nodeSkill,"skilltype",""), DB.getValue(nodeSkill,"points",0));
	if not skillData then
		return;
	end
	if DB.getValue(nodeSkill, "type_abbr", "") ~= skillData.abbreviatedSkillType then
		DB.setValue(nodeSkill, "type_abbr", "string", skillData.abbreviatedSkillType);
	elseif DB.getValue(nodeSkill, "relativelevel", "") ~= skillData.relativeLevel then
		DB.setValue(nodeSkill, "relativelevel", "string", skillData.relativeLevel);
	elseif DB.getValue(nodeSkill, "level", 0) ~= skillData.adjustedLevel then
		DB.setValue(nodeSkill, "level", "number", skillData.adjustedLevel);
	end
end

function onPCSpellUpdated(nodeSpell)
	if DB.getValue(nodeSpell, "type", "") ~= "Spell" then
		DB.setValue(nodeSpell, "type", "string", "Spell");
		return;
	end

	local nodeChar = nodeSpell.getParent().getParent().getParent();
	local skillData = getSkillLevel(nodeChar, DB.getValue(nodeSkill,"spelltype",""), DB.getValue(nodeSkill,"points",0));
	if not skillData then
		return;
	end
	if DB.getValue(nodeSpell, "type_abbr", "") ~= type_abbr then
		DB.setValue(nodeSpell, "type_abbr", "string", type_abbr);
	elseif DB.getValue(nodeSpell, "relativelevel", "") ~= relativelevel then
		DB.setValue(nodeSpell, "relativelevel", "string", relativelevel);
	elseif DB.getValue(nodeSpell, "level", 0) ~= level then
		DB.setValue(nodeSpell, "level", "number", level);
	end
end

function onPCPowerUpdated(nodePower)
	if DB.getValue(nodePower, "type", "") ~= "Power" then
		DB.setValue(nodePower, "type", "string", "Power");
		return;
	end

	local nodeChar = nodePower.getParent().getParent().getParent();
	local skillData = getSkillLevel(nodeChar, DB.getValue(nodeSkill,"powerskill",""), DB.getValue(nodeSkill,"points",0));
	if not skillData then
		return;
	end
	if DB.getValue(nodePower, "type_abbr", "") ~= type_abbr then
		DB.setValue(nodePower, "type_abbr", "string", type_abbr);
	elseif DB.getValue(nodePower, "relativelevel", "") ~= relativelevel then
		DB.setValue(nodePower, "relativelevel", "string", relativelevel);
	elseif DB.getValue(nodePower, "level", 0) ~= level then
		DB.setValue(nodePower, "level", "number", level);
	end
end

function onPCOtherAbilityUpdated(nodeOther)
	if DB.getValue(nodeOther, "type", "") ~= "Other" then
		DB.setValue(nodeOther, "type", "string", "Other");
		return;
	end

end

function onPCAdvantageAdded(nodAdsList, nodeAdvantage)
	local t = DB.getValue(nodeAdvantage, "type", "");
	if t ~= "Advantage" and t ~= "Perk" then
		DB.setValue(nodeAdvantage, "type", "string", "Advantage");
	end
end

function onPCDisadvantageAdded(nodeDisadsList, nodeDisadvantage)
	local t = DB.getValue(nodeDisadvantage, "type", "");
	if t ~= "Disadvantage" and t ~= "Quirk" then
		DB.setValue(nodeDisadvantage, "type", "string", "Disadvantage");
	end
end

function onPCAdvantageUpdated(nodeAdvantage)
	local t = DB.getValue(nodeAdvantage, "type", "");
	if t ~= "Advantage" and t ~= "Perk" then
		local points = math.abs(DB.getValue(nodeAdvantage, "points", 0));
		if (points > 1) then
			DB.setValue(nodeAdvantage, "type", "string", "Advantage");
		else
			DB.setValue(nodeAdvantage, "type", "string", "Perk");
		end
		return; -- We are setting this back so it remains on the proper list.
	end
end

function onPCDisadvantageUpdated(nodeDisadvantage)
	local t = DB.getValue(nodeDisadvantage, "type", "");
	if t ~= "Disadvantage" and t ~= "Quirk" then
		local points = math.abs(DB.getValue(nodeDisadvantage, "points", 0));
		if (points > 1) then
			DB.setValue(nodeDisadvantage, "type", "string", "Disadvantage");
		else
			DB.setValue(nodeDisadvantage, "type", "string", "Quirk");
		end
		return; -- We are setting this back so it remains on the proper list.
	end
end
