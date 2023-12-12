-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

COLOR_RESOURCE_MAX = "008000";
COLOR_RESOURCE_MIN = "C11B17";
COLOR_RESOURCE_USED = "AF7817";

function onInit()
	ItemManager.setCustomCharAdd(onCharItemAdd);
	ItemManager.setCustomCharRemove(onCharItemDelete);

	if Session.IsHost then
		CharInventoryManager.enableInventoryUpdates();
		CharInventoryManager.enableSimpleLocationHandling();

--	TODO	CharInventoryManager.registerFieldUpdateCallback("carried", CharManager.onCharInventoryArmorCalc);
--	TODO	CharInventoryManager.registerFieldUpdateCallback("isidentified", CharManager.onCharInventoryArmorCalcIfCarried);
	end
end

function onTabletopInit()
	DB.addHandler("charsheet.*.attributes.strength", "onUpdate", CharManager.onStrengthChanged);
	DB.addHandler("charsheet.*.attributes.dexterity", "onUpdate", CharManager.onDexterityChanged);
	DB.addHandler("charsheet.*.attributes.intelligence", "onUpdate", CharManager.onIntelligenceChanged);
	DB.addHandler("charsheet.*.attributes.health", "onUpdate", CharManager.onHealthChanged);
	DB.addHandler("charsheet.*.attributes.hitpoints", "onUpdate", CharManager.onHitPointsChanged);
	DB.addHandler("charsheet.*.attributes.will", "onUpdate", CharManager.onWillChanged);
	DB.addHandler("charsheet.*.attributes.perception", "onUpdate", CharManager.onPerceptionChanged);
	DB.addHandler("charsheet.*.attributes.fatiguepoints", "onUpdate", CharManager.onFatiguePointsChanged);

	DB.addHandler("charsheet.*.traits.resourcelist.*.min_level", "onUpdate", CharManager.onResourceChanged);
	DB.addHandler("charsheet.*.traits.resourcelist.*.max_level", "onUpdate", CharManager.onResourceChanged);
	DB.addHandler("charsheet.*.traits.resourcelist.*.resource_level", "onUpdate", CharManager.onResourceChanged);
end

function onCharItemAdd(nodeItem)
	CharCombatManager.addItem(nodeItem);
end

function onCharItemDelete(nodeItem)
	CharCombatManager.removeItem(nodeItem);
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
	local abilityName = DB.getValue(nodeAbility, "name", "");
	local defaultsLine = DB.getValue(nodeAbility, "defaults", "");
	if sActorType ~= "pc" then
		local nodeAbilitiesList = DB.getChild(nodeChar, "abilities.abilitieslist")
		if not nodeAbilitiesList then
			nodeAbilitiesList = DB.createChild(nodeChar, "abilities.abilitieslist");
		end

		local nodeNPCAbility = DB.createChild(nodeAbilitiesList);
		DB.setValue(nodeNPCAbility, "name", "string", abilityName);  
		DB.setValue(nodeNPCAbility, "level", "number", DB.getValue(nodeAbility, "otherlevel", 0));

		local typeNodeTarget;
		if bSkill then
			typeNodeTarget = "skilltype";
		elseif bSpell then
			typeNodeTarget = "spelltype";
		elseif bPower then
			typeNodeTarget = "powerskill";
		else
			return true;
		end

		local abilityInfo = CharAbilityManager.calculateAbilityInfo(nodeChar, DB.getValue(nodeAbility, typeNodeTarget, ""), DEFAULT_NEW_ABILITY_POINTS, abilityName, defaultsLine, 0);
		if abilityInfo then
			DB.setValue(nodeNPCAbility, "level", "number", abilityInfo.level);
		end

		return true;
	end

	if bSkill then
		local nodeSkillsList = DB.getChild(nodeChar, "abilities.skilllist");
		if not nodeSkillsList then
			nodeSkillsList = DB.createChild(nodeChar, "abilities.skilllist");
		end

		local nodeSkill = DB.createChild(nodeSkillsList);
		DB.setValue(nodeSkill, "name", "string", abilityName);
		DB.setValue(nodeSkill, "prereqs", "string", DB.getValue(nodeAbility, "skillprerequisite", ""));
		DB.setValue(nodeSkill, "page", "string", DB.getValue(nodeAbility, "page", ""));
		DB.setValue(nodeSkill, "text", "formattedtext", DB.getValue(nodeAbility, "text", ""));

		--Will trigger reconcile
		DB.setValue(nodeSkill, "type", "string", ManagerGURPS4e.getSkillType(DB.getValue(nodeAbility, "skilltype", "")));
		DB.setValue(nodeSkill, "points", "number", DEFAULT_NEW_ABILITY_POINTS);
		DB.setValue(nodeSkill, "defaults", "string", DB.getValue(nodeAbility, "skilldefault", ""));
		DB.setValue(nodeSkill, "level_adj", "number", 0);
		DB.setValue(nodeSkill, "points_adj", "number", 0);

		return true;
	end

	if bSpell then
		local nodeSpellsList = DB.getChild(nodeChar, "abilities.spelllist");
		if not nodeSpellsList then
			nodeSpellsList = DB.createChild(nodeChar, "abilities.spelllist");
		end
	  
		local nodeSpell = DB.createChild(nodeSpellsList);
		DB.setValue(nodeSpell, "name", "string", abilityName);
		DB.setValue(nodeSpell, "class", "string", DB.getValue(nodeAbility, "spellclass", ""));
		DB.setValue(nodeSpell, "time", "string", DB.getValue(nodeAbility, "spelltimetocast", ""));
		DB.setValue(nodeSpell, "duration", "string", DB.getValue(nodeAbility, "spellduration", ""));
		DB.setValue(nodeSpell, "costmaintain", "string", DB.getValue(nodeAbility, "spellcost", ""));
		DB.setValue(nodeSpell, "resist", "string", DB.getValue(nodeAbility, "spellresist", ""));
		DB.setValue(nodeSpell, "college", "string", DB.getValue(nodeAbility, "spellcollege", ""));
		DB.setValue(nodeSpell, "prereqs", "string", DB.getValue(nodeAbility, "spellprerequisite", ""));
		DB.setValue(nodeSpell, "page", "string", DB.getValue(nodeAbility, "page", ""));
		DB.setValue(nodeSpell, "text", "formattedtext", DB.getValue(nodeAbility, "text", ""));

		--Will trigger reconcile
		DB.setValue(nodeSpell, "type", "string", ManagerGURPS4e.getSkillType(DB.getValue(nodeAbility, "spelltype", "")));
		DB.setValue(nodeSpell, "points", "number", DEFAULT_NEW_ABILITY_POINTS);
		DB.setValue(nodeSpell, "level_adj", "number", 0);
		DB.setValue(nodeSpell, "points_adj", "number", 0);

		return true;
	end

	if bPower then
		local nodePowersList = DB.getChild(nodeChar, "abilities.powerlist");
		if not nodePowersList then
			nodePowersList = DB.createChild(nodeChar, "abilities.powerlist");
		end

		local nodePower = DB.createChild(nodePowersList);
		DB.setValue(nodePower, "name", "string", abilityName);  
		DB.setValue(nodePower, "page", "string", DB.getValue(nodeAbility, "page", ""));
		DB.setValue(nodePower, "text", "formattedtext", DB.getValue(nodeAbility, "text", ""));

		--Will trigger reconcile
		DB.setValue(nodePower, "type", "string", ManagerGURPS4e.getSkillType(DB.getValue(nodeAbility, "powerskill", "")));
		DB.setValue(nodePower, "points", "number", DEFAULT_NEW_ABILITY_POINTS);
		DB.setValue(nodePower, "defaults", "string", DB.getValue(nodeAbility, "powerdefault", ""));
		DB.setValue(nodePower, "level_adj", "number", 0);
		DB.setValue(nodePower, "points_adj", "number", 0);

		return true;
	end

	if bOther then
		local nodeOtherList = DB.getChild(nodeChar, "abilities.otherlist");
		if not nodeOthersList then
			nodeOthersList = DB.createChild(nodeChar, "abilities.otherlist");
		end

		local nodeOther = DB.createChild(nodeOtherList);
		DB.setValue(nodeOther, "name", "string", abilityName);  
		DB.setValue(nodeOther, "points", "number", DB.getValue(nodeAbility, "otherpoints", 0));
		DB.setValue(nodeOther, "level", "number", DB.getValue(nodeAbility, "otherlevel", 0));
		DB.setValue(nodeOther, "page", "string", DB.getValue(nodeAbility, "page", ""));
		DB.setValue(nodeOther, "text", "formattedtext", DB.getValue(nodeAbility, "text", ""));
		
		--Will trigger reconcile
		DB.setValue(nodeOther, "otherlevel", "number", DB.getValue(nodeAbility, "otherlevel", 0));
		DB.setValue(nodeOther, "defaults", "string", DB.getValue(nodeAbility, "otherdefault", ""));

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

function onStrengthChanged(nodeField)
	local nodeChar = DB.getChild(nodeField, "...");
	CharAbilityManager.reconcileAbilitiesBasedOn(nodeChar, "ST");
end

function onDexterityChanged(nodeField)
	local nodeChar = DB.getChild(nodeField, "...");
	CharAbilityManager.reconcileAbilitiesBasedOn(nodeChar, "DX");
end

function onIntelligenceChanged(nodeField)
	local nodeChar = DB.getChild(nodeField, "...");
	CharAbilityManager.reconcileAbilitiesBasedOn(nodeChar, "IQ");
end

function onHealthChanged(nodeField)
	local nodeChar = DB.getChild(nodeField, "...");
	CharAbilityManager.reconcileAbilitiesBasedOn(nodeChar, "HT");
end

function onPerceptionChanged(nodeField)
	local nodeChar = DB.getChild(nodeField, "...");
	CharAbilityManager.reconcileAbilitiesBasedOn(nodeChar, "Per");
end

function onWillChanged(nodeField)
	local nodeChar = DB.getChild(nodeField, "...");
	CharAbilityManager.reconcileAbilitiesBasedOn(nodeChar, "Will");
end

function onHitPointsChanged(nodeField)
	local nodeChar = DB.getChild(nodeField, "...");
	ActionDamage.updateDamage(nodeChar);
end

function onFatiguePointsChanged(nodeField)
	local nodeChar = DB.getChild(nodeField, "...");
	ActionFatigue.updateFatigue(nodeChar);
end

function onResourceChanged(nodeField)
	local nodeResource = DB.getChild(nodeField, "..");
	local resourceLevel = DB.getValue(nodeResource, "resource_level");

	local min = DB.getValue(nodeResource, "min_level");
	if min and resourceLevel < min then
		DB.setValue(nodeResource, "resource_level", "number", min);
		return;
	end

	local max = DB.getValue(nodeResource, "max_level");
	if max and resourceLevel > max then
		DB.setValue(nodeResource, "resource_level", "number", max);
		return;
	end
end

function getResourceColor(nodeResource)
						Debug.chat(nodeResource)

	if not nodeResource then return end;

	local resourceLevel = DB.getValue(nodeResource, "resource_level");

	local min = DB.getValue(nodeResource, "min_level");
	if min and resourceLevel <= min then
		return COLOR_RESOURCE_MIN
	end

	local max = DB.getValue(nodeResource, "max_level");
	if max and resourceLevel >= max then
		return COLOR_RESOURCE_MAX
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

function updatePointsTotal(nodeChar)
	local total = 0;
	local temp = 0;
	local tempquirks = 0;
	local tempdisadvantages = 0;

	local attributes = {};
	table.insert(attributes, DB.getValue(nodeChar,"attributes.strength_points",0));
	table.insert(attributes, DB.getValue(nodeChar,"attributes.dexterity_points",0));
	table.insert(attributes, DB.getValue(nodeChar,"attributes.intelligence_points",0));
	table.insert(attributes, DB.getValue(nodeChar,"attributes.health_points",0));
	table.insert(attributes, DB.getValue(nodeChar,"attributes.hitpoints_points",0));
	table.insert(attributes, DB.getValue(nodeChar,"attributes.will_points",0));
	table.insert(attributes, DB.getValue(nodeChar,"attributes.perception_points",0));
	table.insert(attributes, DB.getValue(nodeChar,"attributes.fatiguepoints_points",0));
	table.insert(attributes, DB.getValue(nodeChar,"attributes.basicspeed_points",0));
	table.insert(attributes, DB.getValue(nodeChar,"attributes.basicmove_points",0));
	table.insert(attributes, DB.getValue(nodeChar,"traits.tl_points",0));
  
	for _,value in pairs(attributes) do 
		temp = temp + value;
		if value < 0 then
			tempdisadvantages = tempdisadvantages + value;
		end
	end

	DB.setValue(nodeChar,"pointtotals.attributes","number",temp);

	total = total + temp;
	temp = 0;

	for _,node in pairs(DB.getChildren(nodeChar,"traits.culturalfamiliaritylist")) do
		temp = temp + DB.getValue(node,"points",0);
	end

	for _,node in pairs(DB.getChildren(nodeChar,"traits.languagelist")) do
		temp = temp + DB.getValue(node,"points",0);
	end

	for _,node in pairs(DB.getChildren(nodeChar,"traits.adslist")) do
		temp = temp + DB.getValue(node,"points",0);
	end
	DB.setValue(nodeChar,"pointtotals.ads","number",temp);

	total = total + temp;
	temp = 0;

	for _,node in pairs(DB.getChildren(nodeChar,"traits.disadslist")) do
		if DB.getValue(node,"points",0) == -1 then
			tempquirks = tempquirks + DB.getValue(node,"points",0);
		else
			temp = temp + DB.getValue(node,"points",0);
		end
	end
	DB.setValue(nodeChar,"pointtotals.disads","number",temp);
	DB.setValue(nodeChar,"pointtotals.quirks","number",tempquirks);
  	DB.setValue(nodeChar,"pointtotals.totaldisads","number",temp + tempdisadvantages + tempquirks);

	total = total + temp + tempquirks;
	temp = 0;
  
	for _,node in pairs(DB.getChildren(nodeChar,"abilities.skilllist")) do
		temp = temp + DB.getValue(node,"points",0);
	end
	DB.setValue(nodeChar,"pointtotals.skills","number",temp);

	total = total + temp;
	temp = 0;

	for _,node in pairs(DB.getChildren(nodeChar,"abilities.spelllist")) do
		temp = temp + DB.getValue(node,"points",0);
	end
	DB.setValue(nodeChar,"pointtotals.spells","number",temp);

	total = total + temp;
	temp = 0;

	for _,node in pairs(DB.getChildren(nodeChar,"abilities.powerlist")) do
		temp = temp + DB.getValue(node,"points",0);
	end
	DB.setValue(nodeChar,"pointtotals.powers","number",temp);

	total = total + temp;
	temp = 0;
 
	for _,node in pairs(DB.getChildren(nodeChar,"abilities.otherlist")) do
		temp = temp + DB.getValue(node,"points",0);
	end
	DB.setValue(nodeChar,"pointtotals.others","number",temp);

	total = total + temp;

	local disads = DB.getValue(nodeChar,"pointtotals.disads",0);
	local totaldisads = DB.getValue(nodeChar,"pointtotals.totaldisads",0);

	if disads == totaldisads then
		DB.setValue(nodeChar,"pointtotals.disadsummary","string", string.format("%d", disads));
	else
		DB.setValue(nodeChar,"pointtotals.disadsummary","string", string.format("%d (%d)", disads, totaldisads));  
	end 

	DB.setValue(nodeChar,"pointtotals.totalpoints","number",total);
end
