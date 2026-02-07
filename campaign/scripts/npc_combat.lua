-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--


function onDrop(x, y, draginfo)
	if WindowManager.getReadOnlyState(getDatabaseNode()) then
    	return true;
	end

	if not draginfo.isType("shortcut") then
		return false;
	end

	local nodeItem = draginfo.getDatabaseNode();
	local nodeNPC = getDatabaseNode();
	local bAdded = false;

	if LibraryDataGURPS4e.isMeleeWeapon(nodeItem) then
		bAdded = addMeleeWeapon(nodeNPC, nodeItem);
	end

	if LibraryDataGURPS4e.isRangedWeapon(nodeItem) then
		bAdded = addRangedWeapon(nodeNPC, nodeItem);
	end

	if LibraryDataGURPS4e.isDefense(nodeItem) then
		bAdded = addDefense(nodeNPC, nodeItem);
	end

	return bAdded;
end

function addDefense(nodeNPC, nodeItem)
	if not nodeItem or not nodeNPC then
		return false;
	end

	local nodeCombat = nodeNPC.createChild("combat.defenseslist");
	if not nodeCombat then
		return false;
	end
	
	local nodeCombatItem = nodeCombat.createChild();
	if nodeCombatItem then
		DB.setValue(nodeCombatItem, "name", "string", DB.getValue(nodeItem, "name", ""));
		DB.setValue(nodeCombatItem, "db", "number", tonumber(DB.getValue(nodeItem, "db", "0")));
		DB.setValue(nodeCombatItem, "dr", "string", DB.getValue(nodeItem, "dr", ""));
		DB.setValue(nodeCombatItem, "locations", "string", DB.getValue(nodeItem, "locations", ""));
		DB.setValue(nodeCombatItem, "text", "formattedtext", DB.getValue(nodeItem, "notes", ""));
	end

    return true;
end

function addMeleeWeapon(nodeNPC, nodeItem)
	if not nodeItem or not nodeNPC then
		return false;
	end

	local nodeCombat = nodeNPC.createChild("combat.meleecombatlist");
	if not nodeCombat then
		return false;
	end
	
	local nodeCombatItem = nodeCombat.createChild();
	if nodeCombatItem then
		DB.setValue(nodeCombatItem, "name", "string", DB.getValue(nodeItem, "name", ""));
		DB.setValue(nodeCombatItem, "st", "string", DB.getValue(nodeItem, "st", ""));
		DB.setValue(nodeCombatItem, "weight", "string", DB.getValue(nodeItem, "weight", ""));
		DB.setValue(nodeCombatItem, "cost", "string", DB.getValue(nodeItem, "cost", ""));
		DB.setValue(nodeCombatItem, "tl", "string", DB.getValue(nodeItem, "tl", ""));
		DB.setValue(nodeCombatItem, "text", "formattedtext", DB.getValue(nodeItem, "notes", ""));

		local charST = DB.getValue(nodeNPC, "attributes.strength", 0);
		local charThrust = DB.getValue(nodeNPC, "attributes.thrust", ManagerGURPS4e.getItemThrust(charST));
		local charSwing = DB.getValue(nodeNPC, "attributes.swing", ManagerGURPS4e.getItemSwing(charST));

		local nodeModeList = DB.createChild(nodeCombatItem, "meleemodelist");
		if not hasWeaponModes(nodeItem) then
			local aModesDamage = StringManager.split(DB.getValue(nodeItem, "damage", ""), "|");
			local aModesReach = StringManager.split(DB.getValue(nodeItem, "reach", ""), "|");
			local aModesParry = StringManager.split(DB.getValue(nodeItem, "parry", ""), "|");

			for index, _ in ipairs(aModesDamage) do
				local modeDamage = StringManager.trim(aModesDamage[index] or DB.getValue(nodeItem, "damage", ""));
				local modeReach = StringManager.trim(aModesReach[index] or DB.getValue(nodeItem, "reach", ""));
				local modeParry = StringManager.trim(aModesParry[index] or DB.getValue(nodeItem, "parry", ""));

				local sModeName, sResolvedDamage = getModeNameAndDamage(modeDamage, charThrust, charSwing);

				local nodeMode = DB.createChild(nodeModeList);
				DB.setValue(nodeMode, "lvl", "number", 0);
				DB.setValue(nodeMode, "name", "string", sModeName);
				DB.setValue(nodeMode, "damage", "string", sResolvedDamage);
				DB.setValue(nodeMode, "reach", "string", modeReach);
				DB.setValue(nodeMode, "parry", "string", modeParry);
			end
		else
			local minstVals = ManagerGURPS4e.strsplit("|", DB.getValue(nodeItem, "st", ""));
			local minstCount = 0;

			for _, flds in pairs(DB.getChildren(nodeItem, "")) do
				for _, idk in pairs(DB.getChildren(flds, "")) do
					local sModeName = DB.getValue(idk, "modename", "");
					local sReach = DB.getValue(idk, "reach", "");
					if sModeName ~= "" and sReach ~= "" then
						minstCount = minstCount + 1;

						local sDamage = DB.getValue(idk, "damage", "");
						local nLevel = DB.getValue(idk, "Level", "0");
						local sResolvedName, sResolvedDamage = getModeNameAndDamage(sDamage, charThrust, charSwing);

						local nodeMode = DB.createChild(nodeModeList);
						DB.setValue(nodeMode, "name", "string", sModeName ~= "" and sModeName or sResolvedName);
						DB.setValue(nodeMode, "lvl", "number", nLevel);
						DB.setValue(nodeMode, "damage", "string", sResolvedDamage);
						DB.setValue(nodeMode, "reach", "string", sReach);
						DB.setValue(nodeMode, "parry", "string", ManagerGURPS4e.calculateParry(DB.getValue(idk, "parry", "")));
					end
				end
			end

			local lastVal = "";
			local mstr = "";
			for i = 1, minstCount do
				if minstVals[i] and tonumber(minstVals[i]) ~= tonumber(lastVal) then
					if lastVal ~= "" then mstr = mstr .. "|"; end
					lastVal = minstVals[i];
					mstr = mstr .. minstVals[i];
				end
			end
			DB.setValue(nodeCombatItem, "st", "string", mstr);
		end
	end

    return true;
end

function addRangedWeapon(nodeNPC, nodeItem)
	if not nodeItem or not nodeNPC then
		return false;
	end

	local nodeCombat = nodeNPC.createChild("combat.rangedcombatlist");
	if not nodeCombat then
		return false;
	end
	
	local nodeCombatItem = nodeCombat.createChild();
	if nodeCombatItem then
		DB.setValue(nodeCombatItem, "name", "string", DB.getValue(nodeItem, "name", ""));
		DB.setValue(nodeCombatItem, "st", "string", DB.getValue(nodeItem, "st", ""));
		DB.setValue(nodeCombatItem, "bulk", "number", tonumber(DB.getValue(nodeItem, "bulk", "0")));
		DB.setValue(nodeCombatItem, "lc", "string", DB.getValue(nodeItem, "lc", ""));
		DB.setValue(nodeCombatItem, "tl", "string", DB.getValue(nodeItem, "tl", ""));
		DB.setValue(nodeCombatItem, "text", "formattedtext", DB.getValue(nodeItem, "notes", ""));

		local charST = DB.getValue(nodeNPC, "attributes.strength", 0);
		local charThrust = DB.getValue(nodeNPC, "attributes.thrust", ManagerGURPS4e.getItemThrust(charST));
		local charSwing = DB.getValue(nodeNPC, "attributes.swing", ManagerGURPS4e.getItemSwing(charST));

		local nodeModeList = DB.createChild(nodeCombatItem, "rangedmodelist");
		if not hasWeaponModes(nodeItem) then
			local aModesDamage = StringManager.split(DB.getValue(nodeItem, "damage", ""), "|");
			local aModesAcc = StringManager.split(DB.getValue(nodeItem, "acc", "0"), "|");
			local aModesRange = StringManager.split(DB.getValue(nodeItem, "range", ""), "|");
			local aModesRoF = StringManager.split(DB.getValue(nodeItem, "rof", ""), "|");
			local aModesShots = StringManager.split(DB.getValue(nodeItem, "shots", ""), "|");
			local aModesRcl = StringManager.split(DB.getValue(nodeItem, "rcl", ""), "|");

			for index, _ in ipairs(aModesDamage) do
				local modeDamage = StringManager.trim(aModesDamage[index] or DB.getValue(nodeItem, "damage", ""));
				local modeAcc = StringManager.trim(aModesAcc[index] or DB.getValue(nodeItem, "acc", ""));
				local modeRange = StringManager.trim(aModesRange[index] or DB.getValue(nodeItem, "range", ""));
				local modeRoF = StringManager.trim(aModesRoF[index] or DB.getValue(nodeItem, "rof", ""));
				local modeShots = StringManager.trim(aModesShots[index] or DB.getValue(nodeItem, "shots", ""));
				local modeRcl = StringManager.trim(aModesRcl[index] or DB.getValue(nodeItem, "rcl", ""));

				local sModeName, sResolvedDamage = getModeNameAndDamage(modeDamage, charThrust, charSwing);

				local nodeMode = DB.createChild(nodeModeList);
				DB.setValue(nodeMode, "lvl", "number", 0);
				DB.setValue(nodeMode, "name", "string", sModeName);
				DB.setValue(nodeMode, "damage", "string", sResolvedDamage);
				DB.setValue(nodeMode, "acc", "number", tonumber(modeAcc));
				DB.setValue(nodeMode, "range", "string", ManagerGURPS4e.calculateRange(charST, modeRange));
				DB.setValue(nodeMode, "rof", "string", modeRoF);
				DB.setValue(nodeMode, "shots", "string", modeShots);
				DB.setValue(nodeMode, "rcl", "number", tonumber(modeRcl));
			end
		else
			local accMods = "";
			local modifierFlag = 0;
			local minstVals = ManagerGURPS4e.strsplit("|", DB.getValue(nodeItem, "st", ""));
			local minstCount = 0;

			for _, flds in pairs(DB.getChildren(nodeItem, "")) do
				for _, idk in pairs(DB.getChildren(flds, "")) do
					if (DB.getValue(idk, "modename", "") ~= "") and (DB.getValue(idk, "rof", "") ~= "") then
						local nodeMode = DB.createChild(nodeModeList);
						minstCount = minstCount + 1;

						DB.setValue(nodeMode, "name", "string", DB.getValue(idk, "modename", "atk name"));
						DB.setValue(nodeMode, "lvl", "number", 0);

						local useST = DB.getValue(nodeItem, "weaponst", charST);
						useST = (useST ~= "" and useST or charST);
						useThrust = ManagerGURPS4e.getItemThrust(useST);
						useSwing = ManagerGURPS4e.getItemSwing(useST);

						local sResolvedName, sResolvedDamage = getModeNameAndDamage(DB.getValue(idk, "damage", ""), useThrust, useSwing);
						DB.setValue(nodeMode, "damage", "string", sResolvedDamage);

						accMods = DB.getValue(idk, "acc", "0");
						accMods = ManagerGURPS4e.strsplit("%+", accMods);
						DB.setValue(nodeMode, "acc", "number", tonumber(accMods[1]));
						DB.setValue(nodeMode, "range", "string", ManagerGURPS4e.calculateRange(useST, DB.getValue(idk, "range", "")));
						DB.setValue(nodeMode, "rof", "string", DB.getValue(idk, "rof", ""));
						DB.setValue(nodeMode, "shots", "string", DB.getValue(idk, "shots", ""));
						DB.setValue(nodeMode, "rcl", "number", tonumber(DB.getValue(idk, "rcl", "0")));
						if (#accMods > 1) and (modifierFlag ~= 1) then
							modifierFlag = 1;
							local modifNode = DB.createChild(nodeCombatItem, "modifierlist");
							local mofNode = DB.createChild(modifNode);
							DB.setValue(mofNode, "name", "string", "Bonus Acc");
							DB.setValue(mofNode, "modifier", "number", tonumber(accMods[2]));
						end
					end
				end
			end
  
			local lastVal = "";
			local mstr = "";
			local startPos = #minstVals - minstCount + 1;
			for i = startPos, #minstVals do
				if minstVals[i] and tonumber(minstVals[i]) ~= tonumber(lastVal) then
					if lastVal ~= "" then mstr = mstr .. "|"; end
					lastVal = minstVals[i];
					mstr = mstr .. minstVals[i];
				end
			end
			DB.setValue(nodeCombatItem, "st", "string", mstr);
		end
	end

    return true;
end

function hasWeaponModes(nodeItem)
	return DB.getChild(nodeItem, "meleemodelist") ~= nil or DB.getChild(nodeItem, "rangedmodelist") ~= nil;
end

function getModeNameAndDamage(sDamage, charThrust, charSwing)
	local sDamageLower = string.lower(sDamage or "");
	if string.find(sDamageLower, "thr") or string.find(sDamageLower, "thrust") then
		return "Thrust", ManagerGURPS4e.calculateDam(charThrust, sDamage);
	elseif string.find(sDamageLower, "sw") or string.find(sDamageLower, "swing") then
		return "Swing", ManagerGURPS4e.calculateDam(charSwing, sDamage);
	end
	return "", sDamage;
end
