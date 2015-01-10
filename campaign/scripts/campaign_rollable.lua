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
     rollable_damage then

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
     rollable_button_damage then

    return true;
  end
  
  return false;
end

function action(draginfo)
  local node = window.getDatabaseNode();
  if node then
    local rActor = ActorManager.getActor("pc", node.getChild("..."));
    local sType = "dice";
    local sDesc = "[ROLL]";
    local aDice = { "d6","d6","d6" };
    local nMod = 0;
    local sTargetDesc = "";
    local nTarget = 0;
    
    if rollable_attribute or rollable_button_attribute then
      sType = "ability";
      sDesc = "[ATTRIBUTE]";
      sTargetDesc = stat[1];
      nTarget = getValue();
    elseif rollable_skill or rollable_button_skill then 
      sType = "ability";
      sDesc = "[SKILL]";
      sTargetDesc = window.name.getValue();
      nTarget = window.level.getValue();
    elseif rollable_spell or rollable_button_spell then
      sType = "ability";
      sDesc = "[SPELL]";
      sTargetDesc = window.name.getValue();
      nTarget = window.level.getValue();
    elseif rollable_power or rollable_button_power then
      sType = "ability";
      sDesc = "[POWER]";
      sTargetDesc = window.name.getValue();
      nTarget = window.level.getValue();
    elseif rollable_other or rollable_button_other then
      sType = "ability";
      sDesc = "[OTHER]";
      sTargetDesc = window.name.getValue();
      nTarget = window.level.getValue();
    elseif rollable_melee or rollable_button_melee then
      sType = "melee";
      sDesc = "[MELEE]";
      sTargetDesc = window.name.getValue();
      nTarget = window.level.getValue();
    elseif rollable_ranged or rollable_button_ranged then
      sType = "ranged";
      sDesc = "[RANGED]";
      sTargetDesc = window.name.getValue();
      nTarget = window.level.getValue();
    elseif rollable_dodge or rollable_button_dodge then
      sType = "dodge";
      sDesc = "[DODGE]";
      sTargetDesc = "Dodge";
      nTarget = getValue();
    elseif rollable_parry or rollable_button_parry then
      sType = "parry";
      sDesc = "[PARRY]";
      sTargetDesc = "Parry";
      nTarget = getValue();
    elseif rollable_block or rollable_button_block then
      sType = "block";
      sDesc = "[BLOCK]";
      sTargetDesc = "Block";
      nTarget = getValue();
    elseif rollable_damage or rollable_button_damage then
      sType = "damage";
      sDesc = "[DAMAGE] " .. window.name.getValue();
      aDice, nMod = StringManager.convertStringToDice(getValue());
    end  
  
    local rRoll = { sType = sType, sDesc = sDesc, aDice = aDice, nMod = nMod, sTargetDesc = sTargetDesc, nTarget = nTarget };
  
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
