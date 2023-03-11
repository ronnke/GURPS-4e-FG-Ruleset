-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	local nodeChar = getDatabaseNode();
	DB.addHandler(DB.getPath(nodeChar, "abilities.skilllist.*.type"), "onUpdate", onSkillDataChanged);
	DB.addHandler(DB.getPath(nodeChar, "abilities.skilllist.*.points"), "onUpdate", onSkillDataChanged);
	DB.addHandler(DB.getPath(nodeChar, "abilities.skilllist.*.defaults"), "onUpdate", onSkillDataChanged);
	DB.addHandler(DB.getPath(nodeChar, "abilities.skilllist.*.level_adj"), "onUpdate", onSkillDataChanged);
	DB.addHandler(DB.getPath(nodeChar, "abilities.skilllist.*.points_adj"), "onUpdate", onSkillDataChanged);
	DB.addHandler(DB.getPath(nodeChar, "abilities.skilllist.*.name"), "onUpdate", onSkillNameChanged);
	DB.addHandler(DB.getPath(nodeChar, "abilities.skilllist.*.level"), "onUpdate", onSkillLevelChanged);

	DB.addHandler(DB.getPath(nodeChar, "abilities.spelllist.*.type"), "onUpdate", onSpellDataChanged);
	DB.addHandler(DB.getPath(nodeChar, "abilities.spelllist.*.points"), "onUpdate", onSpellDataChanged);
	DB.addHandler(DB.getPath(nodeChar, "abilities.spelllist.*.level_adj"), "onUpdate", onSpellDataChanged);
	DB.addHandler(DB.getPath(nodeChar, "abilities.spelllist.*.points_adj"), "onUpdate", onSpellDataChanged);

	DB.addHandler(DB.getPath(nodeChar, "abilities.powerlist.*.type"), "onUpdate", onPowerDataChanged);
	DB.addHandler(DB.getPath(nodeChar, "abilities.powerlist.*.points"), "onUpdate", onPowerDataChanged);
	DB.addHandler(DB.getPath(nodeChar, "abilities.powerlist.*.defaults"), "onUpdate", onPowerDataChanged);
	DB.addHandler(DB.getPath(nodeChar, "abilities.powerlist.*.level_adj"), "onUpdate", onPowerDataChanged);
	DB.addHandler(DB.getPath(nodeChar, "abilities.powerlist.*.points_adj"), "onUpdate", onPowerDataChanged);

	DB.addHandler(DB.getPath(nodeChar, "abilities.otherlist.*.otherlevel"), "onUpdate", onOtherDataChanged);
	DB.addHandler(DB.getPath(nodeChar, "abilities.otherlist.*.defaults"), "onUpdate", onOtherDataChanged);
end

function onClose()
	local nodeChar = getDatabaseNode();
	DB.removeHandler(DB.getPath(nodeChar, "abilities.skilllist.*.type"), "onUpdate", onSkillDataChanged);
	DB.removeHandler(DB.getPath(nodeChar, "abilities.skilllist.*.points"), "onUpdate", onSkillDataChanged);
	DB.removeHandler(DB.getPath(nodeChar, "abilities.skilllist.*.defaults"), "onUpdate", onSkillDataChanged);
	DB.removeHandler(DB.getPath(nodeChar, "abilities.skilllist.*.level_adj"), "onUpdate", onSkillDataChanged);
	DB.removeHandler(DB.getPath(nodeChar, "abilities.skilllist.*.points_adj"), "onUpdate", onSkillDataChanged);
	DB.removeHandler(DB.getPath(nodeChar, "abilities.skilllist.*.name"), "onUpdate", onSkillNameChanged);
	DB.removeHandler(DB.getPath(nodeChar, "abilities.skilllist.*.level"), "onUpdate", onSkillLevelChanged);

	DB.removeHandler(DB.getPath(nodeChar, "abilities.spelllist.*.type"), "onUpdate", onSpellDataChanged);
	DB.removeHandler(DB.getPath(nodeChar, "abilities.spelllist.*.points"), "onUpdate", onSpellDataChanged);
	DB.removeHandler(DB.getPath(nodeChar, "abilities.spelllist.*.level_adj"), "onUpdate", onSpellDataChanged);
	DB.removeHandler(DB.getPath(nodeChar, "abilities.spelllist.*.points_adj"), "onUpdate", onSpellDataChanged);

	DB.removeHandler(DB.getPath(nodeChar, "abilities.powerlist.*.type"), "onUpdate", onPowerDataChanged);
	DB.removeHandler(DB.getPath(nodeChar, "abilities.powerlist.*.points"), "onUpdate", onPowerDataChanged);
	DB.removeHandler(DB.getPath(nodeChar, "abilities.powerlist.*.defaults"), "onUpdate", onPowerDataChanged);
	DB.removeHandler(DB.getPath(nodeChar, "abilities.powerlist.*.level_adj"), "onUpdate", onPowerDataChanged);
	DB.removeHandler(DB.getPath(nodeChar, "abilities.powerlist.*.points_adj"), "onUpdate", onPowerDataChanged);

	DB.removeHandler(DB.getPath(nodeChar, "abilities.otherlist.*.otherlevel"), "onUpdate", onOtherDataChanged);
	DB.removeHandler(DB.getPath(nodeChar, "abilities.otherlist.*.defaults"), "onUpdate", onOtherDataChanged);
end

function onSkillDataChanged(node)
	ActorAbilityManager.reconcilePCSkill(node.getParent());
end

function onSkillNameChanged(node)
	ActorAbilityManager.onPCSkillNameChanged(node.getParent());
end

function onSkillLevelChanged(node)
	ActorAbilityManager.onPCSkillLevelChanged(node.getParent());
end

function onSpellDataChanged(node)
	ActorAbilityManager.reconcilePCSpell(node.getParent());
end

function onPowerDataChanged(node)
	ActorAbilityManager.reconcilePCSkill(node.getParent());
end

function onOtherDataChanged(node)
	ActorAbilityManager.reconcilePCOther(node.getParent());
end
