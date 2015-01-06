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
  local rActor = ActorManager.getActor("pc", node);
  local sDesc = "[ROLL]";
  local aDice = { "d6","d6","d6" };
  local nMod = 0;
  
  if rollable_attribute or rollable_button_attribute then
    sDesc = "[ATTRIBUTE] " .. stat[1];
  elseif rollable_skill or rollable_button_skill then 
    sDesc = "[SKILL] " .. window.name.getValue();
  elseif rollable_spell or rollable_button_spell then
    sDesc = "[SPELL] " .. window.name.getValue();
  elseif rollable_power or rollable_button_power then
    sDesc = "[POWER] " .. window.name.getValue();
  elseif rollable_other or rollable_button_other then
    sDesc = "[OTHER] " .. window.name.getValue();
  elseif rollable_melee or rollable_button_melee then
    sDesc = "[MELEE] " .. window.name.getValue();
  elseif rollable_ranged or rollable_button_ranged then
    sDesc = "[RANGED] " .. window.name.getValue();
  elseif rollable_block or rollable_button_block then
    sDesc = "[BLOCK] " .. window.name.getValue();
  elseif rollable_parry or rollable_button_parry then
    sDesc = "[PARRY] " .. window.name.getValue();
  elseif rollable_dodge or rollable_button_dodge then
    sDesc = "[DODGE] " .. window.name.getValue();
  elseif rollable_damage or rollable_button_damage then
    aDice, nMod = StringManager.convertStringToDice(getValue());
    sDesc = "[DAMAGE] " .. window.name.getValue();
  end  

  local rRoll = { sType = "dice", sDesc = sDesc, aDice = aDice, nMod = nMod };

  ActionsManager.performAction(draginfo, rActor, rRoll);
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
    return true;
  end

  return false;
end
