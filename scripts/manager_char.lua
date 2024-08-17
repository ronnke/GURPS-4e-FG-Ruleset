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
	if Session.IsHost then
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

		DB.addHandler("charsheet.*.attributes.injury", "onUpdate", CharManager.onInjuryChanged);
		DB.addHandler("charsheet.*.attributes.fatigue", "onUpdate", CharManager.onFatigueChanged);
	end
end

function onCharItemAdd(nodeItem)
	CharCombatManager.addItem(nodeItem);
end

function onCharItemDelete(nodeItem)
	CharCombatManager.removeItem(nodeItem);
end

function addAbility(nodeChar, nodeAbility)
	CharAbilityManager.addAbility(nodeChar, nodeAbility);
end

function addTrait(nodeChar, nodeTrait)
	CharTraitManager.addTrait(nodeChar, nodeTrait);
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
	local resourceLevel = DB.getValue(nodeResource, "resource_level", 0);

	local min = DB.getValue(nodeResource, "min_level", 0);
	if min and resourceLevel < min then
		DB.setValue(nodeResource, "resource_level", "number", min);
		return;
	end

	local max = DB.getValue(nodeResource, "max_level", 0);
	if max and resourceLevel > max then
		DB.setValue(nodeResource, "resource_level", "number", max);
		return;
	end
end

function onInjuryChanged(nodeField)
	local nodeChar = DB.getChild(nodeField, "...");
	ActionDamage.updateDamage(nodeChar);
end

function onFatigueChanged(nodeField)
	local nodeChar = DB.getChild(nodeField, "...");
	ActionFatigue.updateFatigue(nodeChar);
end

function getResourceColor(nodeResource)
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
