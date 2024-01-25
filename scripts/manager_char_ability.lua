-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

local MIN_ABILITY_NAME_LENGTH = 3;
local DEFAULT_BASIS_NAME = "Attribute";
local DEFAULT_NEW_ABILITY_POINTS = 1;

function onInit()
end

function onTabletopInit()
	DB.addHandler("charsheet.*.abilities.skilllist.*.type", "onUpdate", CharAbilityManager.onSkillDataChanged);
	DB.addHandler("charsheet.*.abilities.skilllist.*.points", "onUpdate", CharAbilityManager.onSkillDataChanged);
	DB.addHandler("charsheet.*.abilities.skilllist.*.defaults", "onUpdate", CharAbilityManager.onSkillDataChanged);
	DB.addHandler("charsheet.*.abilities.skilllist.*.level_adj", "onUpdate", CharAbilityManager.onSkillDataChanged);
	DB.addHandler("charsheet.*.abilities.skilllist.*.points_adj", "onUpdate", CharAbilityManager.onSkillDataChanged);
	DB.addHandler("charsheet.*.abilities.skilllist.*.name", "onUpdate", CharAbilityManager.onSkillNameChanged);
	DB.addHandler("charsheet.*.abilities.skilllist.*.level", "onUpdate", CharAbilityManager.onSkillLevelChanged);

	DB.addHandler("charsheet.*.abilities.spelllist.*.type", "onUpdate", CharAbilityManager.onSpellDataChanged);
	DB.addHandler("charsheet.*.abilities.spelllist.*.points", "onUpdate", CharAbilityManager.onSpellDataChanged);
	DB.addHandler("charsheet.*.abilities.spelllist.*.level_adj", "onUpdate", CharAbilityManager.onSpellDataChanged);
	DB.addHandler("charsheet.*.abilities.spelllist.*.points_adj", "onUpdate", CharAbilityManager.onSpellDataChanged);

	DB.addHandler("charsheet.*.abilities.powerlist.*.type", "onUpdate", CharAbilityManager.onPowerDataChanged);
	DB.addHandler("charsheet.*.abilities.powerlist.*.points", "onUpdate", CharAbilityManager.onPowerDataChanged);
	DB.addHandler("charsheet.*.abilities.powerlist.*.defaults", "onUpdate", CharAbilityManager.onPowerDataChanged);
	DB.addHandler("charsheet.*.abilities.powerlist.*.level_adj", "onUpdate", CharAbilityManager.onPowerDataChanged);
	DB.addHandler("charsheet.*.abilities.powerlist.*.points_adj", "onUpdate", CharAbilityManager.onPowerDataChanged);

	DB.addHandler("charsheet.*.abilities.otherlist.*.otherlevel", "onUpdate", CharAbilityManager.onOtherDataChanged);
	DB.addHandler("charsheet.*.abilities.otherlist.*.points", "onUpdate", CharAbilityManager.onOtherDataChanged);
	DB.addHandler("charsheet.*.abilities.otherlist.*.defaults", "onUpdate", CharAbilityManager.onOtherDataChanged);
end

function onSkillDataChanged(nodeField)
	local nodeSkill = DB.getChild(nodeField, "..");
	CharAbilityManager.reconcileSkill(nodeSkill);
	CharManager.updatePointsTotal(DB.getChild(nodeField, "....."));
end

function onSkillNameChanged(nodeField)
	local nodeSkill = DB.getChild(nodeField, "..");
	CharAbilityManager.reconcileSkill(nodeSkill);
	CharAbilityManager.reconcileDependentSkills(nodeSkill);
end

function onSkillLevelChanged(nodeField)
	local nodeSkill = DB.getChild(nodeField, "..");
	CharAbilityManager.reconcileDependentSkills(nodeSkill);
end

function onSpellDataChanged(nodeField)
	local nodeSpell = DB.getChild(nodeField, "..");
	CharAbilityManager.reconcileSpell(nodeSpell);
	CharManager.updatePointsTotal(DB.getChild(nodeField, "....."));
end

function onPowerDataChanged(nodeField)
	local nodePower = DB.getChild(nodeField, "..");
	CharAbilityManager.reconcileSkill(nodePower);
	CharManager.updatePointsTotal(DB.getChild(nodeField, "....."));
end

function onOtherDataChanged(nodeField)
	local nodeOther = DB.getChild(nodeField, "..");
	CharAbilityManager.reconcileOther(nodeOther);
	CharManager.updatePointsTotal(DB.getChild(nodeField, "....."));
end

function reconcileSkill(nodeSkill)
	-- we can skip skills that don't have complete data.
	if not nodeSkill then return end;

	local totalCP = 0; -- contains the points spent on this skill.
	if DB.getValue(nodeSkill, "points", 0) < 0 then
		DB.setValue(nodeSkill, "points", "number", 0);
		return;
	else
		totalCP = DB.getValue(nodeSkill, "points") + DB.getValue(nodeSkill, "points_adj", 0);
	end

	if totalCP < 0 then
		totalCP = 0;
	end

	local abilityType = DB.getValue(nodeSkill, "type", "");
	if (StringManager.trim(abilityType) or "") == "" then
		local defaultsLine = DB.getValue(nodeSkill, "defaults", "");
		local defaultlevel = DB.getValue(nodeSkill, "level_adj", 0);
		if not ((StringManager.trim(defaultsLine) or "") == "") then
			local nodeChar = nodeSkill.getParent().getParent().getParent();
			defaultlevel = defaultlevel + CharManager.getBestDefaultLevel(nodeChar, defaultsLine);
		end

		DB.setValue(nodeSkill, "basis", "string", "");
		DB.setValue(nodeSkill, "relativelevel", "string", "");
		DB.setValue(nodeSkill, "level", "number", defaultlevel);
		return;
	end;

	local abilityName = DB.getValue(nodeSkill, "name", "");
	local nodeChar = nodeSkill.getParent().getParent().getParent();
	local abilityInfo = calculateAbilityInfo(nodeChar, abilityType, totalCP, abilityName, DB.getValue(nodeSkill, "defaults", ""), DB.getValue(nodeSkill, "level_adj", 0));
	if abilityInfo then
		DB.setValue(nodeSkill, "basis", "string", abilityInfo.basis);
		DB.setValue(nodeSkill, "relativelevel", "string", abilityInfo.relativelevel);
		DB.setValue(nodeSkill, "level", "number", abilityInfo.level);
		return;
	end

	DB.setValue(nodeSkill, "basis", "string", "");
	DB.setValue(nodeSkill, "relativelevel", "string", "");
	DB.setValue(nodeSkill, "level", "number", DB.getValue(nodeSkill, "level_adj", 0));
end

function reconcileSpell(nodeSpell)
	-- we can skip spells that don't have complete data.
	if not nodeSpell then return end;

	local totalCP = 0; -- contains the points spent on this skill.
	if DB.getValue(nodeSpell, "points", 0) < 0 then
		DB.setValue(nodeSpell, "points", "number", 0);
		return;
	end

	totalCP = DB.getValue(nodeSpell, "points") + DB.getValue(nodeSpell, "points_adj", 0);
	if totalCP < 0 then
		totalCP = 0;
	end

	local abilityType = DB.getValue(nodeSpell, "type", "");
	if (StringManager.trim(abilityType) or "") == "" or totalCP == 0 then
		DB.setValue(nodeSpell, "level", "number", DB.getValue(nodeSpell, "level_adj", 0));
		return;
	end;

	local abilityName = DB.getValue(nodeSpell, "name", "");
	local nodeChar = nodeSpell.getParent().getParent().getParent();
	local abilityInfo = calculateAbilityInfo(nodeChar, abilityType, totalCP, abilityName, "", DB.getValue(nodeSpell, "level_adj", 0));
	if abilityInfo then
		DB.setValue(nodeSpell, "level", "number", abilityInfo.level);
		return;
	end

	DB.setValue(nodeSpell, "level", "number", DB.getValue(nodeSpell, "level_adj", 0));
end

function reconcileOther(nodeOther)
	if not nodeOther then return end;

	local level = DB.getValue(nodeOther, "level", 0);
	local otherLevel = DB.getValue(nodeOther, "otherlevel", 0);
	local defaultsLine = DB.getValue(nodeOther, "defaults", "");
	
	if not ((StringManager.trim(defaultsLine) or "") == "") then
		local nodeChar = DB.getChild(nodeOther, "....");
		local defaultLevel = CharAbilityManager.getBestDefaultLevel(nodeChar, defaultsLine)
		if (defaultLevel > otherLevel) then
			DB.setValue(nodeOther, "level", "number", defaultLevel);
			return;
		end
	end

	if (level ~= otherLevel) then
		DB.setValue(nodeOther, "level", "number", otherLevel);
	end
end

function reconcileDependentSkills(changedSkill)
	local list = changedSkill.getParent();
	local changedName = DB.getValue(changedSkill, "name", "");
	if changedName:len() < MIN_ABILITY_NAME_LENGTH then
		return;
	end

	for _,skill in pairs(list.getChildren()) do
		if changedSkill ~= skill then
			for _, defaultName in ipairs(parseAbilityDefaultNames(DB.getValue(skill, "defaults", ""))) do
				if defaultName == changedName then
					CharAbilityManager.reconcileSkill(skill);
				end
			end
		end
	end
end

function getBestDefaultLevel(nodeChar, defaults)
	local result = 0;
	if not nodeChar or not defaults then
		return 0;
	end

	local defaultsInfo = CharAbilityManager.parseAbilityDefaults(nodeChar, defaults)
	for expr, statInfo in pairs(defaultsInfo) do
		if statInfo.defaultInfo.level > result then
			result = statInfo.defaultInfo.level;
		end
	end

	return result;
end

function parseAbilityExpression(sAbilityExpression)
    local result = {};
    local sRemainder = StringManager.trim(sAbilityExpression);
    local lhs, rhs = sRemainder:match("(.+)([+-].*)$");
    if rhs then
        local modifier = tonumber(rhs);
        if modifier then
            result.modifier = modifier;
        end
        sRemainder = StringManager.trim(lhs);
    end

	result.name = sRemainder;
    lhs, rhs = sRemainder:match("(.+)%((.+)%)$");
    if rhs then
        result.specialty = rhs;
        sRemainder = StringManager.trim(lhs);
    end

    lhs, rhs = sRemainder:match("(.+)%/TL(.*)$");
    if rhs then
        result.tl = rhs;
        sRemainder = StringManager.trim(lhs);
    end

    if sRemainder == "" then
        return result;
    end

    result.wild = sRemainder:sub(sRemainder:len()) == "!";
    if result.wild then
        sRemainder = sRemainder:sub(0, sRemainder:len() - 1);
    end
    result.root_name = sRemainder;
    return result;
end

function parseAbilityDefaultNames(sCommaSeparatedDefaultsLine)
	local results = {};
	if not sCommaSeparatedDefaultsLine then
		return results;
	end

	for _,defExp in ipairs(StringManager.split(sCommaSeparatedDefaultsLine, ",", true)) do
		local lhs, rhs = defExp:match("(.+)([+-].*)$");
		local str = "";
		if rhs then
			str = StringManager.trim(lhs);
		else
			str = StringManager.trim(defExp);
		end

		table.insert(results, str);
	end

	return results;
end

function parseAbilityDefaults(nodeActor, sCommaSeparatedDefaultsLine)
	local results = {};
	if not nodeActor or not sCommaSeparatedDefaultsLine then
		return results;
	end

	for _,defExp in ipairs(StringManager.split(sCommaSeparatedDefaultsLine, ",", true)) do
		local defInfo = parseAbilityExpression(defExp);
		if defInfo then
			if defInfo.name == "None" then
				return {};
			end

			local stat = ActorManagerGURPS4e.getStat(nodeActor, defInfo.name);
			if stat and stat.level then
				if stat.statType ~= "attribute" and (stat.points > 0 or stat.points_adj > 0) then
					defInfo.level = stat.level;
					if defInfo.modifier then
						defInfo.level = defInfo.level + defInfo.modifier;
					end

					stat.defaultInfo = defInfo;
					results[defExp] = stat;
				elseif stat.statType == "attribute" then
					defInfo.level = stat.level;
					-- Rule of 20 (B:173)
					if defInfo.level > 20 then
						defInfo.level = 20;
					end

					if defInfo.modifier then
						defInfo.level = defInfo.level + defInfo.modifier;
					end

					stat.defaultInfo = defInfo;
					results[defExp] = stat;
				end
			end
		end
	end

	return results;
end

function getBasisAndDiffFromType(sAbilityType)
	if not sAbilityType then return {}; end
	local result = {};
	local basis, difficulty = sAbilityType:match("^(%a+)[/]([%a%s]+)");
	if not basis or not difficulty then
		return result;
	end

	result.basis = basis;
	result.difficulty = difficulty;
	if difficulty:len() > 2 then
		difficulty = difficulty:lower();
		if difficulty == "easy" then
			result.difficulty = "E";
		elseif difficulty == "average" then
			result.difficulty = "A";
		elseif difficulty == "hard" then
			result.difficulty = "H";
		elseif difficulty == "very hard" then
			result.difficulty = "VH";
		else
			return result;
		end
	end

	return result;
end

function calculateAbilityInfo(nodeChar, abilityType, totalCP, abilityName, defaultsLine, level_adj)
	if not nodeChar then 
		return; 
	end

	local typeInfo = getBasisAndDiffFromType(abilityType);
	if not typeInfo.basis or not typeInfo.difficulty then
		return;
	end

	local nameInfo = parseAbilityExpression(abilityName);
	if not nameInfo or nameInfo.name == "" then
		return;
	end

	local type = typeInfo.basis .. "/" .. typeInfo.difficulty;
	local name = nameInfo.name;
	local basis = DEFAULT_BASIS_NAME;
	local level = 0;
	local relativelevel = "";
	local defaultsInfo = parseAbilityDefaults(nodeChar, defaultsLine);

	-- figure out the best default in the table.
	local bestDefaultExpression = "";
	local bestDefaultLevel = -999;
	local bestDefault = nil;
	for expr, statInfo in pairs(defaultsInfo) do
		if statInfo.defaultInfo.level > bestDefaultLevel and not isBasedOnAbility(statInfo.name, nodeChar, name) then
			bestDefaultLevel = statInfo.defaultInfo.level;
			bestDefaultExpression = expr;
			bestDefault = statInfo;
		end
	end

	if typeInfo.basis == "Tech" then -- this is a technique.
		if bestDefault then
			level = bestDefaultLevel;
			if bestDefault.statType ~= "attribute" then
				basis = bestDefault.name;
			end

			if totalCP > 0 then
				if typeInfo.difficulty == "A" then
					level = level + totalCP;
				elseif typeInfo.difficulty == "H" and totalCP >= 2 then
					level = level + totalCP - 1;
				end
			end

			level = level + level_adj;
			relativelevel = makeRelativeLevelString("Def", level - bestDefaultLevel);
		else
			basis = "Unknown";
			level = level_adj;
			relativelevel = makeRelativeLevelString("Unk", level - 10);
		end
	elseif nameInfo.wild then -- this is a wildcard ability.
		local baseStat = ActorManagerGURPS4e.getStat(nodeChar, typeInfo.basis);
		if baseStat and baseStat.statType == "attribute" then -- wildcards can only be based on attributes.
			if totalCP >= 6 then
				level = baseStat.level + math.floor(totalCP/12) - 2;
			elseif totalCP >= 3 then
				level = baseStat.level - 3;
			end

			level = level + level_adj;
			relativelevel = makeRelativeLevelString(typeInfo.basis, level - baseStat.level);
		else
			basis = "Unknown";
			level = level_adj;
			relativelevel = makeRelativeLevelString("Unk", level - 10);
		end
	else -- this is a typical ability.
		local baseStat = ActorManagerGURPS4e.getStat(nodeChar, typeInfo.basis);
		if baseStat then
			if totalCP <= 0 then -- this skill is based on a default.
				if bestDefault then
					level = bestDefaultLevel;
					if bestDefault.statType ~= "attribute" then
						basis = bestDefault.name;
					end
				end
			else -- we spent points on this.
				if bestDefault then -- Improving Skills from Default (B:173)
					if bestDefault.statType ~= "attribute" then
						local bonus_points = calculatePointsNeededForAbilityLevel(baseStat.level, typeInfo.difficulty, bestDefaultLevel);
						if bonus_points > 0 then
							basis = bestDefault.name;
						end
						totalCP = totalCP + bonus_points;
					end
				end

				if totalCP >= 2 then
					level = baseStat.level + math.floor(totalCP/4) - 2;
				else
					level = baseStat.level - 3;
				end

				if typeInfo.difficulty == "E" then
					level = level + 3;
				elseif typeInfo.difficulty == "A" then
					level = level + 2;
				elseif typeInfo.difficulty == "H" then
					level = level + 1;
				end
			end

			level = level + level_adj;
			relativelevel = makeRelativeLevelString(typeInfo.basis, level - baseStat.level);
		end
	end

	result = {};
	result.typeInfo = typeInfo;
	result.type = type;
	result.nameInfo = nameInfo;
	result.name = name;
	result.basis = basis;
	result.level = level;
	result.defaultsInfo = defaultsInfo;
	result.defaults = defaultsLine;
	result.bestDefault = bestDefault;
	result.bestDefaultLevel = bestDefaultLevel;
	result.bestDefaultExpression = bestDefaultExpression;
	result.relativelevel = relativelevel;
	return result;
end

function reconcileAbilitiesBasedOn(nodeActor, sBasis)
	if not ActorManager.isPC(nodeActor) then
		return;
	end

	-- this is a pc.
	local list = nodeActor.getChild("abilities.skilllist");
	if list then
		for _,nodeSkill in pairs(list.getChildren()) do
			local typeInfo = getBasisAndDiffFromType(DB.getValue(nodeSkill, "type", ""));
			if typeInfo.basis == sBasis then
				CharAbilityManager.reconcileSkill(nodeSkill);
			end
		end
	end

	list = nodeActor.getChild("abilities.spelllist");
	if list then
		for _,nodeSpell in pairs(list.getChildren()) do
			local typeInfo = getBasisAndDiffFromType(DB.getValue(nodeSpell, "type", ""));
			if typeInfo.basis == sBasis then
				CharAbilityManager.reconcileSpell(nodeSpell);
			end
		end
	end

	list = nodeActor.getChild("abilities.powerlist");
	if list then
		for _,nodePower in pairs(list.getChildren()) do
			local typeInfo = getBasisAndDiffFromType(DB.getValue(nodePower, "type", ""));
			if typeInfo.basis == sBasis then
				CharAbilityManager.reconcileSpell(nodePower);
			end
		end
	end

	list = nodeActor.getChild("abilities.otherlist");
	if list then
		for _,nodeOther in pairs(list.getChildren()) do
			CharAbilityManager.reconcileOther(nodeOther);
		end
	end
end

function calculatePointsNeededForAbilityLevel(statLevel, difficulty, desiredLevel)
	local relative = desiredLevel - statLevel;
	if difficulty == "A" then
		relative = relative + 1;
	elseif difficulty == "H" then
		relative = relative + 2;
	elseif difficulty == "VH" then
		relative = relative + 3;
	end

	if relative >= 2 then
		return (relative - 1) * 4;
	elseif relative >= 1 then
		return 2;
	elseif relative >= 0 then
		return 1;
	end

	return 0;
end

function makeRelativeLevelString(sBasis, numRelative)
	local basis = sBasis;
	if basis:len() > 4 then
		basis = "Base";
	end

	if numRelative >= 0 then
		return basis .. "+" .. tostring(numRelative);
	end
	
	return basis .. tostring(numRelative);
end

function isBasedOnAbility(abilityName, nodeCharacter, abilityNameToFind)
	if not nodeCharacter then
		return false;
	elseif not abilityName then
		return false;
	elseif not abilityNameToFind then
		return false;
	end

	if abilityName == abilityNameToFind then
		return true;
	end

	local statInfo = ActorManagerGURPS4e.getStat(nodeCharacter, abilityName);
	if not statInfo then
		return false;
	elseif statInfo.statType == "attribute" then
		return false;
	elseif not statInfo.basis then
		return false;
	elseif statInfo.basis == DEFAULT_BASIS_NAME then
		return false;
	end

	return isBasedOnAbility(statInfo.basis, nodeCharacter, abilityNameToFind);
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
