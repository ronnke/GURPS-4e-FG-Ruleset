-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
  ActionsManager.registerResultHandler("melee", onMelee);
end

function onMelee(rSource, rTarget, rRoll)
  local rMessage = ActionsManager.createActionMessage(rSource, rRoll);
  local nTotal = ActionsManager2.total(rRoll);

  local bAddMod = false;
  if GameSystem.actions[rRoll.sType] then
    bAddMod = GameSystem.actions[rRoll.sType].bAddMod;
  end

  local node = DB.findNode(rRoll.sNode);
  local sWeapon = DB.getValue(node.getParent().getParent(), "name", "");
  local sMode = DB.getValue(node, "name", "");

  -- Send the chat message
  local bShowMsg = true;
  if not rSource then
    bShowMsg = false;
  end
  
  if bShowMsg then
    local sTargetDesc =  DB.getValue(node, "name", "");
    local nTarget = DB.getValue(node, "level", 0);
    
    rMessage.text = string.format("%s\n%s%s%s %s(%d):%s",
        (string.format("%s%s",(rTarget and string.format("%s || ",rTarget.sName) or ""), rMessage.text)),
        sWeapon, 
        ((sWeapon and sWeapon ~= '' and sTargetDesc and sTargetDesc ~= '') and "\n" or ""), 
        sTargetDesc, 
        (rRoll.nMod ~= 0 and string.format("(%d%s%d)=", nTarget, (rRoll.nMod > 0 and "+" or ""), rRoll.nMod) or ""),
        nTarget + rRoll.nMod, 
        GameSystem.rollResult(nTotal, nTarget + rRoll.nMod)
    );
    
    rMessage.diemodifier = (bAddMod and rRoll.nMod or 0);
    
    Comm.deliverChatMessage(rMessage);
  end
end
