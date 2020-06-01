-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
  ActionsManager.registerModHandler("dodge", modRoll);
  ActionsManager.registerModHandler("parry", modRoll);
  ActionsManager.registerModHandler("block", modRoll);

  ActionsManager.registerResultHandler("dodge", onDefense);
  ActionsManager.registerResultHandler("parry", onDefense);
  ActionsManager.registerResultHandler("block", onDefense);
end

function modRoll(rSource, rTarget, rRoll)
end

function onDefense(rSource, rTarget, rRoll)
  local rMessage = ActionsManager.createActionMessage(rSource, rRoll);
	local nTotal = ActionsManager2.total(rRoll);

  local bAddMod = false;
  if GameSystem.actions[rRoll.sType] then
    bAddMod = GameSystem.actions[rRoll.sType].bAddMod;
  end

  -- Send the chat message
  local bShowMsg = true;
  if not rSource then
    bShowMsg = false;
  end
  
  if bShowMsg then
    local nTarget = tonumber((string.match(rRoll.nTarget, "%d+") or "0"));
    local sExtra = (string.match(rRoll.nTarget, "[uUfF]") or "");
  
    rMessage.text = string.format("%s\n%s%s%s %s(%d%s):%s",
        (string.format("%s%s",(rTarget and string.format("%s || ",rTarget.sName) or ""), rMessage.text)),
        (rRoll.sWeapon or ""), 
        ((rRoll.sWeapon and rRoll.sWeapon ~= '' and rRoll.sTargetDesc and rRoll.sTargetDesc ~= '') and "\n" or ""), 
        (rRoll.sTargetDesc or ""), 
        (rRoll.nMod ~= 0 and string.format("(%d%s%d)=", nTarget, (rRoll.nMod > 0 and "+" or ""), rRoll.nMod) or ""),
        nTarget + rRoll.nMod, 
        sExtra,
        GameSystem.rollResult(nTotal, nTarget + rRoll.nMod)
    );
  
    rMessage.diemodifier = (bAddMod and rRoll.nMod or 0);
  	
  	Comm.deliverChatMessage(rMessage);
  end
end
