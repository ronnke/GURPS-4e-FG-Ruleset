-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	ActionsManager.registerResultHandler("damage", onDamage);
end

function onDamage(rSource, rTarget, rRoll)
  local rMessage = ActionsManager2.createActionMessage(rSource, rRoll);
  local nTotal = ActionsManager2.total(rRoll);
  local aAddIcons = {};

  rMessage.text = string.format("%s\n%s%s%s %s",
      (string.format("%s%s",(rTarget and string.format("%s || ",rTarget.sName) or ""), rMessage.text)),
      (rRoll.sWeapon or ""), 
      ((rRoll.sWeapon and rRoll.sWeapon ~= '' and rRoll.sMode and rRoll.sMode ~= '') and "\n" or ""), 
      (rRoll.sMode or ""), 
      (string.format("[%s]%s", (rRoll.sDamage or ""), (rRoll.nMod ~= 0 and string.format("(%s%d)",(rRoll.nMod > 0 and "+" or ""),rRoll.nMod) or "")) or "")
  );

  if #aAddIcons > 0 then
    rMessage.icon = { rMessage.icon };
    for _,v in ipairs(aAddIcons) do
      table.insert(rMessage.icon, v);
    end
  end

  -- Deliver Dice Result
  Comm.deliverChatMessage(rMessage);
  
  -- Deliver Total Damage
  rMessage.text = string.format("Total [%s]%s", (rRoll.sDamage or ""), (rRoll.nMod ~= 0 and string.format("(%s%d)",(rRoll.nMod > 0 and "+" or ""),rRoll.nMod) or ""));
  rMessage.dice = {};
  rMessage.diemodifier = nTotal;
  rMessage.dicedisplay = 0;
  
  -- Deliver Total Damage
  Comm.deliverChatMessage(rMessage);
end
