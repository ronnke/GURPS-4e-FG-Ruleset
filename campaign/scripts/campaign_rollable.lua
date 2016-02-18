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
     rollable_melee or
     rollable_ranged or
     rollable_block or
     rollable_parry or
     rollable_dodge or
     rollable_weaponparry or
     rollable_damage or 
     rollable_reaction then

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
     rollable_button_melee or
     rollable_button_ranged or
     rollable_button_block or
     rollable_button_parry or
     rollable_button_dodge or
     rollable_button_weaponparry or
     rollable_button_damage or
     rollable_button_reaction then

    return true;
  end
  
  return false;
end

function action(draginfo)
  local node = window.getDatabaseNode();

  if node then
    local rActor = ActorManager.getActor("pc", node);
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
    local sFunc = "";
    local nNum = 0

    local rRoll = { sType = sType, sDesc = sDesc, aDice = aDice, nMod = nMod };
    
    if rollable_attribute or rollable_button_attribute then
      sType = "ability";
      sDesc = "[ATTRIBUTE]";
      sTargetDesc = stat[1];
      nTarget = getValue();
      rRoll = { sType = sType, sDesc = sDesc, aDice = aDice, nMod = nMod, sTargetDesc = sTargetDesc, nTarget = nTarget };
    elseif rollable_skill or rollable_button_skill then 
      rActor = ActorManager.getActor("pc", node.getChild("..."));
      sType = "ability";
      sDesc = "[SKILL]";
      sTargetDesc = DB.getValue(node, "name", "");
      nTarget = DB.getValue(node, "level", "");
      rRoll = { sType = sType, sDesc = sDesc, aDice = aDice, nMod = nMod, sTargetDesc = sTargetDesc, nTarget = nTarget };
    elseif rollable_spell or rollable_button_spell then
      rActor = ActorManager.getActor("pc", node.getChild("..."));
      sType = "ability";
      sDesc = "[SPELL]";
      sTargetDesc = DB.getValue(node, "name", "");
      nTarget = DB.getValue(node, "level", "");
      rRoll = { sType = sType, sDesc = sDesc, aDice = aDice, nMod = nMod, sTargetDesc = sTargetDesc, nTarget = nTarget };
    elseif rollable_power or rollable_button_power then
      rActor = ActorManager.getActor("pc", node.getChild("..."));
      sType = "ability";
      sDesc = "[POWER]";
      sTargetDesc = DB.getValue(node, "name", "");
      nTarget = DB.getValue(node, "level", "");
      rRoll = { sType = sType, sDesc = sDesc, aDice = aDice, nMod = nMod, sTargetDesc = sTargetDesc, nTarget = nTarget };
    elseif rollable_other or rollable_button_other then
      rActor = ActorManager.getActor("pc", node.getChild("..."));
      sType = "ability";
      sDesc = "[OTHER]";
      sTargetDesc = DB.getValue(node, "name", "");
      nTarget = DB.getValue(node, "level", "");
      rRoll = { sType = sType, sDesc = sDesc, aDice = aDice, nMod = nMod, sTargetDesc = sTargetDesc, nTarget = nTarget };
    elseif rollable_melee or rollable_button_melee then
      rActor = ActorManager.getActor("pc", node.getChild("...").getChild("..."));
      sType = "melee";
      sDesc = "[MELEE]";
      sWeapon = DB.getValue(node.getChild("..."), "name", "");
      sTargetDesc =  DB.getValue(node, "name", "");
      nTarget = getValue();
      rRoll = { sType = sType, sDesc = sDesc, sWeapon = sWeapon, aDice = aDice, nMod = nMod, sTargetDesc = sTargetDesc, nTarget = nTarget };
    elseif rollable_ranged or rollable_button_ranged then
      rActor = ActorManager.getActor("pc", node.getChild("...").getChild("..."));
      sType = "ranged";
      sDesc = "[RANGED]";
      sWeapon = DB.getValue(node.getChild("..."), "name", "");
      nRoF = DB.getValue(node, "rof", "");
      nRcl = DB.getValue(node, "rcl", "");
      sTargetDesc =  DB.getValue(node, "name", "");
      nTarget = getValue();
      rRoll = { sType = sType, sDesc = sDesc, sWeapon = sWeapon, nRoF = nRoF, nRcl = nRcl, aDice = aDice, nMod = nMod, sTargetDesc = sTargetDesc, nTarget = nTarget };
    elseif rollable_dodge or rollable_button_dodge then
      sType = "dodge";
      sDesc = "[DODGE]";
      sTargetDesc = "Dodge";
      nTarget = getValue();
      rRoll = { sType = sType, sDesc = sDesc, aDice = aDice, nMod = nMod, sTargetDesc = sTargetDesc, nTarget = nTarget };
    elseif rollable_parry or rollable_button_parry then
      sType = "parry";
      sDesc = "[PARRY]";
      sTargetDesc = "Parry";
      nTarget = getValue();
      rRoll = { sType = sType, sDesc = sDesc, aDice = aDice, nMod = nMod, sTargetDesc = sTargetDesc, nTarget = nTarget };
    elseif rollable_block or rollable_button_block then
      sType = "block";
      sDesc = "[BLOCK]";
      sTargetDesc = "Block";
      sWeapon = DB.getValue(node.getChild("..."), "name", "");
      nTarget = getValue();
      rRoll = { sType = sType, sDesc = sDesc, aDice = aDice, nMod = nMod, sTargetDesc = sTargetDesc, nTarget = nTarget };
    elseif rollable_weaponparry or rollable_button_weaponparry then
      rActor = ActorManager.getActor("pc", node.getChild("...").getChild("..."));
      sType = "parry";
      sDesc = "[PARRY]";
      sWeapon = DB.getValue(node.getChild("..."), "name", "");
      sTargetDesc = DB.getValue(node, "name", "");
      nTarget = getValue();
      rRoll = { sType = sType, sDesc = sDesc, sWeapon = sWeapon, aDice = aDice, nMod = nMod, sTargetDesc = sTargetDesc, nTarget = nTarget };
    elseif rollable_damage or rollable_button_damage then
      rActor = ActorManager.getActor("pc", node.getChild("...").getChild("..."));
      sType = "damage";
      sDesc = "[DAMAGE]";
      sWeapon = DB.getValue(node.getChild("..."), "name", "");
      sMode = DB.getValue(node, "name", "");
      sDamage = getValue();
      aDice, nMod, sFunc, nNum = StringManager2.convertStringToDice(getValue());
      rRoll = { sType = sType, sDesc = sDesc, sWeapon = sWeapon, sMode = sMode, sDamage = sDamage, sFunc = sFunc, nNum = nNum, aDice = aDice, nMod = nMod };
    elseif rollable_reaction or rollable_button_reaction then
      sType = "reaction";
      sDesc = "[REACTION]";
      rRoll = { sType = sType, sDesc = sDesc, aDice = aDice, nMod = nMod };
    end  
  
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

function onDragStart(button, x, y, draginfo)
  if isRollable() or isRollableButton() then
    action(draginfo);
  end

  return true;
end
