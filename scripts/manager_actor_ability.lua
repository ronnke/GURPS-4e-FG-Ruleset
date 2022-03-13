-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	DB.addHandler(DB.getPath("charsheet.*.abilities.skilllist.*.*"), "onUpdate", onSkillFieldUpdated);
	DB.addHandler(DB.getPath("charsheet.*.abilities.spelllist.*.*"), "onUpdate", onSpellFieldUpdated);
end

local MIN_ABILITY_NAME_LENGTH = 3;
local DEFAULT_BASIS_NAME = "Attribute";

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

			local stat = ActorManager2.getStat(nodeActor, defInfo.name);
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
		local baseStat = ActorManager2.getStat(nodeChar, typeInfo.basis);
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
		local baseStat = ActorManager2.getStat(nodeChar, typeInfo.basis);
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

function onSkillFieldUpdated(nodeField)
	local name = nodeField.getName();
	-- we only care about certain properties changing for the purposes of ability reconciliaition.
	if name == "type" then
		reconcilePCSkill(nodeField.getParent());
	elseif name == "points" then
		reconcilePCSkill(nodeField.getParent());
	elseif name == "defaults" then
		reconcilePCSkill(nodeField.getParent());
	elseif name == "level_adj" then
		reconcilePCSkill(nodeField.getParent());
	elseif name == "points_adj" then
		reconcilePCSkill(nodeField.getParent());
	elseif name == "name" then
		onPCSkillNameChanged(nodeField.getParent());
	elseif name == "level" then
		onPCSkillLevelChanged(nodeField.getParent());
	end
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
				reconcilePCSkill(nodeSkill);
			end
		end
	end

	list = nodeActor.getChild("abilities.spelllist");
	if list then
		for _,nodeSpell in pairs(list.getChildren()) do
			local typeInfo = getBasisAndDiffFromType(DB.getValue(nodeSpell, "type", ""));
			if typeInfo.basis == sBasis then
				reconcilePCSpell(nodeSpell);
			end
		end
	end
end

-- the purpose of this function is to take a PC's skill node and calculate the
-- level it should have, based on the points spent and the defaults available.
function reconcilePCSkill(nodeSkill)
	-- we can skip skills that don't have complete data.
	if not nodeSkill then return end;
	local abilityType;
	if nodeSkill.getChild("type") == nil then
		return;
	else
		abilityType = DB.getValue(nodeSkill, "type");
	end
	
	local totalCP = 0; -- contains the points spent on this skill.
	if nodeSkill.getChild("points") == nil then
		return;
	elseif DB.getValue(nodeSkill, "points") < 0 then
		DB.setValue(nodeSkill, "points", "number", 0);
		return;
	else
		totalCP = DB.getValue(nodeSkill, "points") + DB.getValue(nodeSkill, "points_adj", 0);
	end

	if totalCP < 0 then
		totalCP = 0;
	end

	local abilityName;
	if nodeSkill.getChild("name") == nil then
		return;
	else
		abilityName = DB.getValue(nodeSkill, "name", "");
	end

	local nCharacter = nodeSkill.getParent().getParent().getParent();
	local abilityInfo = calculateAbilityInfo(nCharacter, abilityType, totalCP, abilityName, DB.getValue(nodeSkill, "defaults", ""), DB.getValue(nodeSkill, "level_adj", 0));
	if not abilityInfo then
		return;
	end

	DB.setValue(nodeSkill, "basis", "string", abilityInfo.basis);
	DB.setValue(nodeSkill, "level", "number", abilityInfo.level);
	DB.setValue(nodeSkill, "relativelevel", "string", abilityInfo.relativelevel);
end

function onPCSkillLevelChanged(nodeSkill)
	reconcileDependentSkills(nodeSkill);
end

function onPCSkillNameChanged(nodeSkill)
	reconcilePCSkill(nodeSkill);
	reconcileDependentSkills(nodeSkill);
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
					reconcilePCSkill(skill);
				end
			end
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

	local statInfo = ActorManager2.getStat(nodeCharacter, abilityName);
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

function onSpellFieldUpdated(nodeField)
	local name = nodeField.getName();
	if name == "type" then
		reconcilePCSpell(nodeField.getParent());
	elseif name == "points" then
		reconcilePCSpell(nodeField.getParent());
	elseif name == "level_adj" then
		reconcilePCSpell(nodeField.getParent());
	elseif name == "points_adj" then
		reconcilePCSpell(nodeField.getParent());
	end
end

function reconcilePCSpell(nodeSpell)
	-- we can skip spells that don't have complete data.
	if not nodeSpell then return end;
	local abilityType;
	if nodeSpell.getChild("type") == nil then
		return;
	else
		abilityType = DB.getValue(nodeSpell, "type");
	end
	
	local totalCP = 0; -- contains the points spent on this skill.
	if nodeSpell.getChild("points") == nil then
		return;
	elseif DB.getValue(nodeSpell, "points") < 0 then
		DB.setValue(nodeSpell, "points", "number", 0);
		return;
	else
		totalCP = DB.getValue(nodeSpell, "points") + DB.getValue(nodeSpell, "points_adj", 0);
	end

	if totalCP < 0 then
		totalCP = 0;
	end

	local abilityName;
	if nodeSpell.getChild("name") == nil then
		return;
	else
		abilityName = DB.getValue(nodeSpell, "name", "");
	end

	local nCharacter = nodeSpell.getParent().getParent().getParent();
	local abilityInfo = calculateAbilityInfo(nCharacter, abilityType, totalCP, abilityName, "", DB.getValue(nodeSpell, "level_adj", 0));
	if not abilityInfo then
		return;
	end

	DB.setValue(nodeSpell, "level", "number", abilityInfo.level);
end
