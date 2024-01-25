-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
  setHoverCursor("arrow");
  
  if isRollable() then
    local w = addBitmapWidget("field_rollable");
    w.setPosition("bottomleft", -1, -4);
  end

  if isRollable() or isRollableButton() then
    setHoverCursor("hand");
  end
end

function isRollable()
  if rollable_attribute or
     rollable_skill or
     rollable_spell or
     rollable_power or
     rollable_other or
     rollable_ability or
     rollable_melee or
     rollable_ranged or
     rollable_block or
     rollable_parry or
     rollable_dodge or
     rollable_weaponparry or
     rollable_damage or 
     rollable_reaction or 
     rollable_thrust or 
     rollable_swing then

    return true;
  end
  
  return false;
end

function isRollableButton()
  if rollable_button_attribute or
     rollable_button_skill or  
     rollable_button_spell or
     rollable_button_power or
     rollable_button_other or
     rollable_button_ability or
     rollable_button_melee or
     rollable_button_ranged or
     rollable_button_block or
     rollable_button_parry or
     rollable_button_dodge or
     rollable_button_weaponparry or
     rollable_button_damage or
     rollable_button_reaction or
     rollable_button_thrust or 
     rollable_button_swing then

    return true;
  end
  
  return false;
end

function action(draginfo)
    local  node = window.getDatabaseNode();
    if not node then
        return;
    end

    local rActor = ActorManagerGURPS4e.resolveActor(node);
    local sType = "dice";
    local sDesc = "[ROLL]";
    local sTargetDesc = ""
    local nTarget = 0;
    local aDice = { "d6","d6","d6" };
    local nMod = 0;
    local sWeapon = "";
    local sDamage = "";
    local sMode = "";
    local nRoF = 1;
    local nRcl = 1;
    local sOperator = "";
    local nNum = 0
    
    local rRoll = { sType = sType, sDesc = sDesc, aDice = aDice, nMod = nMod };

    if draginfo then
      draginfo.setDatabaseNode(node);
    end

    if rollable_attribute or rollable_button_attribute then
      sTargetDesc = stat[1];
      nTarget = getValue();
      ActionAbility.performAttributeRoll(draginfo, rActor, sTargetDesc, nTarget);
    elseif rollable_skill or rollable_button_skill then 
      sTargetDesc = DB.getValue(node, "name", "");
      nTarget = DB.getValue(node, "level", "");
      ActionAbility.performSkillRoll(draginfo, rActor, sTargetDesc, nTarget);
    elseif rollable_spell or rollable_button_spell then
      sTargetDesc = DB.getValue(node, "name", "");
      nTarget = DB.getValue(node, "level", "");
      ActionAbility.performSpellRoll(draginfo, rActor, sTargetDesc, nTarget);
    elseif rollable_power or rollable_button_power then
      sTargetDesc = DB.getValue(node, "name", "");
      nTarget = DB.getValue(node, "level", "");
      ActionAbility.performPowerRoll(draginfo, rActor, sTargetDesc, nTarget);
    elseif rollable_other or rollable_button_other then
      sTargetDesc = DB.getValue(node, "name", "");
      nTarget = DB.getValue(node, "level", "");
      ActionAbility.performOtherRoll(draginfo, rActor, sTargetDesc, nTarget);
    elseif rollable_ability or rollable_button_ability then
      sTargetDesc = DB.getValue(node, "name", "");
      nTarget = DB.getValue(node, "level", "");
      ActionAbility.performAbilityRoll(draginfo, rActor, sTargetDesc, nTarget);
    elseif rollable_melee or rollable_button_melee then
      sNode = node.getPath();
      ActionMelee.performRoll(draginfo, rActor, sNode);
    elseif rollable_ranged or rollable_button_ranged then
      sNode = node.getPath();
      ActionRanged.performRoll(draginfo, rActor, sNode);
    elseif rollable_dodge or rollable_button_dodge then
      nTarget = getValue();
      ActionDefense.performDodgeRoll(draginfo, rActor, nTarget);
    elseif rollable_parry or rollable_button_parry then
      nTarget = getValue();
      ActionDefense.performParryRoll(draginfo, rActor, nTarget);
    elseif rollable_block or rollable_button_block then
      nTarget = getValue();
      ActionDefense.performBlockRoll(draginfo, rActor, nTarget);
    elseif rollable_weaponparry or rollable_button_weaponparry then
      sWeapon = DB.getValue(node.getChild("..."), "name", "");
      sMode = DB.getValue(node, "name", "");
      sTargetDesc = DB.getValue(node, "name", "");
      nTarget = getValue();
      ActionDefense.performWeaponParryRoll(draginfo, rActor, sWeapon, sMode, sTargetDesc, nTarget);
    elseif rollable_damage or rollable_button_damage then
      sWeapon = DB.getValue(node.getChild("..."), "name", "");
      sMode = DB.getValue(node, "name", "");
      sDamage = getValue();
      ActionDamage.performRoll(draginfo, rActor, sWeapon, sMode, sDamage);
    elseif rollable_thrust or rollable_button_thrust then
      sDamage = DB.getValue(node.getChild("attributes"), "thrust", "");
      ActionDamage.performThrustRoll(draginfo, rActor, sDamage);
    elseif rollable_swing or rollable_button_swing then
      sDamage = DB.getValue(node.getChild("attributes"), "swing", "");
      ActionDamage.performSwingRoll(draginfo, rActor, sDamage);
    elseif rollable_reaction or rollable_button_reaction then
      ActionReaction.performRoll(draginfo, rActor);
    else
      ActionsManager.performAction(draginfo, rActor, rRoll);
    end  
end

function onButtonPress(x, y)
  if isRollableButton() then
    action();
  end

  return true;
end

function onDoubleClick(x, y)
  if isRollable() then
    action();
  end

  return true;
end

function onDrop(x, y, draginfo)
  if draginfo.getDescription() == "[SKILL]" and rollable_attribute then
      local node = draginfo.getDatabaseNode();
      local sOperator, nNum = StringManagerGURPS4e.convertRelativeLevel(DB.getValue(node, "relativelevel", ""));
      local rActor = ActorManagerGURPS4e.resolveActor(node);
      local sTargetDesc = string.format("%s [%s%s%s]", DB.getValue(node, "name", ""), stat[1], sOperator, nNum);
      local nTarget = getValue() + tonumber(string.format("%s%s", sOperator, nNum));

      ActionAbility.performRelativeSkillRoll(nil, rActor, sTargetDesc, nTarget);
  end

  return true;
end

function onDragStart(button, x, y, draginfo)
  if isRollable() or isRollableButton() then
    action(draginfo);
  end

  return true;
end
