-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onTabletopInit()
	RecordShareManager.setRecordTypeCallback("ability", handleAbilityShare);
	RecordShareManager.setRecordTypeCallback("trait", handleTraitShare);
	RecordShareManager.setRecordTypeCallback("item", handleItemShare);
	RecordShareManager.setRecordTypeCallback("vehicle", handleVehicleShare);

	RecordShareManager.setWindowClassCallback("ability_skill", handleAbilitySkillShare);
	RecordShareManager.setWindowClassCallback("ability_spell", handleAbilitySpellShare);
	RecordShareManager.setWindowClassCallback("ability_power", handleAbilityPowerShare);
	RecordShareManager.setWindowClassCallback("ability_other", handleAbilityOtherShare);

	RecordShareManager.setWindowClassCallback("trait_advantage", handleTraitShare);
	RecordShareManager.setWindowClassCallback("trait_perk", handleTraitShare);
	RecordShareManager.setWindowClassCallback("trait_disadvantage", handleTraitShare);
	RecordShareManager.setWindowClassCallback("trait_quirk", handleTraitShare);

	RecordShareManager.setWindowClassCallback("charnote", handleNoteShare);
end

function handleAbilityShare(node, tOutput)
	if LibraryDataGURPS4e.isSkill(node) then
		handleAbilitySkillShare(node, tOutput)
		return;
	end

	if LibraryDataGURPS4e.isSpell(node) then
		handleAbilitySpellShare(node, tOutput)
		return;
	end

	if LibraryDataGURPS4e.isPower(node) then
		handleAbilityPowerShare(node, tOutput)
		return;
	end

	if LibraryDataGURPS4e.isOther(node) then
		handleAbilityOtherShare(node, tOutput)
		return;
	end

	table.insert(tOutput, string.format("%s - %s", LibraryData.getSingleDisplayText("ability"), DB.getText(node, "name", "")));
	table.insert(tOutput, "");

	if DB.getText(node, "page", "") ~= "" then
		table.insert(tOutput, string.format("%s: %s", Interface.getString("ability_page_label"), DB.getText(node, "page", "")));
	end

	if DB.getText(node, "text", "") ~= "" then
		table.insert(tOutput, "");
		table.insert(tOutput, DB.getText(node, "text", ""));
	end
end

function handleAbilitySkillShare(node, tOutput)
	table.insert(tOutput, string.format("%s - %s", Interface.getString("library_recordtype_single_skill"), DB.getText(node, "name", "")));
	table.insert(tOutput, "");

	if DB.getText(node, "skilltype", "") ~= "" then
		table.insert(tOutput, string.format("%s: %s", Interface.getString("ability_type_label"), DB.getText(node, "skilltype", "")));
	end
	if DB.getText(node, "skilldefault", "") ~= "" then
		table.insert(tOutput, string.format("%s: %s", Interface.getString("ability_default_label"), DB.getText(node, "skilldefault", "")));
	end
	if DB.getText(node, "skillprerequisite", "") ~= "" then
		table.insert(tOutput, string.format("%s: %s", Interface.getString("ability_prerequisite_label"), DB.getText(node, "skillprerequisite", "")));
	end

	if DB.getText(node, "type", "") ~= "" then
		table.insert(tOutput, string.format("%s: %s", Interface.getString("ability_type_label"), DB.getText(node, "type", "")));
	end
	if DB.getText(node, "defaults", "") ~= "" then
		table.insert(tOutput, string.format("%s: %s", Interface.getString("ability_default_label"), DB.getText(node, "defaults", "")));
	end
	if DB.getText(node, "prereqs", "") ~= "" then
		table.insert(tOutput, string.format("%s: %s", Interface.getString("ability_prerequisite_label"), DB.getText(node, "prereqs", "")));
	end
	if DB.getText(node, "page", "") ~= "" then
		table.insert(tOutput, string.format("%s: %s", Interface.getString("ability_page_label"), DB.getText(node, "page", "")));
	end

	if DB.getText(node, "text", "") ~= "" then
		table.insert(tOutput, "");
		table.insert(tOutput, DB.getText(node, "text", ""));
	end
end

function handleAbilitySpellShare(node, tOutput)
	table.insert(tOutput, string.format("%s - %s", Interface.getString("library_recordtype_single_spell"), DB.getText(node, "name", "")));
	table.insert(tOutput, "");

	if DB.getText(node, "spellcollege", "") ~= "" then
		table.insert(tOutput, string.format("%s: %s", Interface.getString("ability_spellcollege_label"), DB.getText(node, "spellcollege", "")));
	end
	if DB.getText(node, "spellclass", "") ~= "" then
		table.insert(tOutput, string.format("%s: %s", Interface.getString("ability_spellclass_label"), DB.getText(node, "spellclass", "")));
	end
	if DB.getText(node, "spelltype", "") ~= "" then
		table.insert(tOutput, string.format("%s: %s", Interface.getString("ability_spelltype_label"), DB.getText(node, "spelltype", "")));
	end
	if DB.getText(node, "spellresist", "") ~= "" then
		table.insert(tOutput, string.format("%s: %s", Interface.getString("ability_spellresist_label"), DB.getText(node, "spellresist", "")));
	end
	if DB.getText(node, "spellduration", "") ~= "" then
		table.insert(tOutput, string.format("%s: %s", Interface.getString("ability_spellduration_label"), DB.getText(node, "spellduration", "")));
	end
	if DB.getText(node, "spellcost", "") ~= "" then
		table.insert(tOutput, string.format("%s: %s", Interface.getString("ability_spellcost_label"), DB.getText(node, "spellcost", "")));
	end
	if DB.getText(node, "spelltimetocast", "") ~= "" then
		table.insert(tOutput, string.format("%s: %s", Interface.getString("ability_spelltimetocast_label"), DB.getText(node, "spelltimetocast", "")));
	end
	if DB.getText(node, "spellprerequisite", "") ~= "" then
		table.insert(tOutput, string.format("%s: %s", Interface.getString("ability_spellprerequisite_label"), DB.getText(node, "spellprerequisite", "")));
	end

	if DB.getText(node, "college", "") ~= "" then
		table.insert(tOutput, string.format("%s: %s", Interface.getString("ability_spellcollege_label"), DB.getText(node, "college", "")));
	end
	if DB.getText(node, "class", "") ~= "" then
		table.insert(tOutput, string.format("%s: %s", Interface.getString("ability_spellclass_label"), DB.getText(node, "class", "")));
	end
	if DB.getText(node, "type", "") ~= "" then
		table.insert(tOutput, string.format("%s: %s", Interface.getString("ability_spelltype_label"), DB.getText(node, "type", "")));
	end
	if DB.getText(node, "resist", "") ~= "" then
		table.insert(tOutput, string.format("%s: %s", Interface.getString("ability_spellresist_label"), DB.getText(node, "resist", "")));
	end
	if DB.getText(node, "duration", "") ~= "" then
		table.insert(tOutput, string.format("%s: %s", Interface.getString("ability_spellduration_label"), DB.getText(node, "duration", "")));
	end
	if DB.getText(node, "costmaintain", "") ~= "" then
		table.insert(tOutput, string.format("%s: %s", Interface.getString("ability_spellcost_label"), DB.getText(node, "costmaintain", "")));
	end
	if DB.getText(node, "time", "") ~= "" then
		table.insert(tOutput, string.format("%s: %s", Interface.getString("ability_spelltimetocast_label"), DB.getText(node, "time", "")));
	end
	if DB.getText(node, "prereqs", "") ~= "" then
		table.insert(tOutput, string.format("%s: %s", Interface.getString("ability_spellprerequisite_label"), DB.getText(node, "prereqs", "")));
	end

	if DB.getText(node, "page", "") ~= "" then
		table.insert(tOutput, string.format("%s: %s", Interface.getString("ability_page_label"), DB.getText(node, "page", "")));
	end

	if DB.getText(node, "text", "") ~= "" then
		table.insert(tOutput, "");
		table.insert(tOutput, DB.getText(node, "text", ""));
	end
end

function handleAbilityPowerShare(node, tOutput)
	table.insert(tOutput, string.format("%s - %s", Interface.getString("library_recordtype_single_power"), DB.getText(node, "name", "")));
	table.insert(tOutput, "");

	if DB.getText(node, "powerskill", "") ~= "" then
		table.insert(tOutput, string.format("%s: %s", Interface.getString("ability_type_label"), DB.getText(node, "powerskill", "")));
	end
	if DB.getText(node, "powerdefault", "") ~= "" then
		table.insert(tOutput, string.format("%s: %s", Interface.getString("ability_default_label"), DB.getText(node, "powerdefault", "")));
	end

	if DB.getText(node, "type", "") ~= "" then
		table.insert(tOutput, string.format("%s: %s", Interface.getString("ability_type_label"), DB.getText(node, "type", "")));
	end
	if DB.getText(node, "defaults", "") ~= "" then
		table.insert(tOutput, string.format("%s: %s", Interface.getString("ability_default_label"), DB.getText(node, "defaults", "")));
	end

	if DB.getText(node, "page", "") ~= "" then
		table.insert(tOutput, string.format("%s: %s", Interface.getString("ability_page_label"), DB.getText(node, "page", "")));
	end

	if DB.getText(node, "text", "") ~= "" then
		table.insert(tOutput, "");
		table.insert(tOutput, DB.getText(node, "text", ""));
	end
end

function handleAbilityOtherShare(node, tOutput)
	table.insert(tOutput, string.format("%s - %s", Interface.getString("library_recordtype_single_other"), DB.getText(node, "name", "")));
	table.insert(tOutput, "");

	if DB.getText(node, "otherpoints", "") ~= "" then
		table.insert(tOutput, string.format("%s: %s", Interface.getString("ability_otherpoints_label"), DB.getText(node, "otherpoints", "")));
	end
	if DB.getText(node, "otherlevel", "") ~= "" then
		table.insert(tOutput, string.format("%s: %s", Interface.getString("ability_otherlevel_label"), DB.getText(node, "otherlevel", "")));
	end
	if DB.getText(node, "otherdefault", "") ~= "" then
		table.insert(tOutput, string.format("%s: %s", Interface.getString("ability_otherdefault_label"), DB.getText(node, "otherdefault", "")));
	end

	if DB.getText(node, "text", "") ~= "" then
		table.insert(tOutput, "");
		table.insert(tOutput, DB.getText(node, "text", ""));
	end
end

function handleTraitShare(node, tOutput)
	table.insert(tOutput, string.format("%s - %s", DB.getText(node, "type", ""), DB.getText(node, "name", "")));
	table.insert(tOutput, "");

	if DB.getText(node, "subtype", "") ~= "" then
		table.insert(tOutput, string.format("%s: %s", Interface.getString("trait_subtype_label"), DB.getText(node, "subtype", "")));
	end
	if DB.getText(node, "page", "") ~= "" then
		table.insert(tOutput, string.format("%s: %s", Interface.getString("trait_page_label"), DB.getText(node, "page", "")));
	end
	if DB.getText(node, "points", "") ~= "" then
		table.insert(tOutput, string.format("%s: %s", Interface.getString("trait_points_label"), DB.getText(node, "points", "")));
	end

	if DB.getText(node, "text", "") ~= "" then
		table.insert(tOutput, "");
		table.insert(tOutput, DB.getText(node, "text", ""));
	end
end

function handleItemShare(node, tOutput)
	if LibraryData.getIDState("item", node, true) then
		local sItemType = StringManager.trim(DB.getText(node, "type", ""));

		table.insert(tOutput, string.format("%s - %s", sItemType, DB.getText(node, "name", "")));
		table.insert(tOutput, "");
		table.insert(tOutput, string.format("%s: %s", Interface.getString("item_label_cost"), DB.getText(node, "cost", 0)));
		table.insert(tOutput, string.format("%s: %s", Interface.getString("item_label_weight"), DB.getText(node, "weight", 0)));

		if DB.getText(node, "page", "") ~= "" then
			table.insert(tOutput, string.format("%s: %s", Interface.getString("trait_page_label"), DB.getText(node, "page", "")));
		end

		if bDefense then
		end
		if bMeleeWeapon then
		end
		if bRangedWeapon then
		end

		if DB.getText(node, "notes", "") ~= "" then
			table.insert(tOutput, "");
			table.insert(tOutput, DB.getText(node, "notes", ""));
		end
	else
		RecordShareManager.onShareRecordTypeUnidentified("item", node, tOutput);

		if DB.getText(node, "nonid_notes", "") ~= "" then
			table.insert(tOutput, DB.getText(node, "nonid_notes", ""));
		end
	end
end

function handleVehicleShare(node, tOutput)
	RecordShareManager.onShareRecordType("vehicle", node, tOutput);

	if DB.getText(node, "notes", "") ~= "" then
		table.insert(tOutput, "");
		table.insert(tOutput, DB.getText(node, "notes", ""));
	end
end

function handleNoteShare(node, tOutput)
	RecordShareManager.onShareRecordBasic(Interface.getString("library_recordtype_single_note"), node, tOutput);
end
