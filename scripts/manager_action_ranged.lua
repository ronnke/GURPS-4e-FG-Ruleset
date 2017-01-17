-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
  ActionsManager.registerResultHandler("ranged", onRanged);
end

function onRanged(rSource, rTarget, rRoll)
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
  
    local nRoF = tonumber(string.match(rRoll.nRoF, "%d+")); 
    nRoF = ((nRoF == nil or nRoF < 1) and 1 or nRoF);
  
    local nRcl = tonumber(string.match(rRoll.nRcl, "%d+"));
    nRcl = ((nRcl == nil or nRcl < 1) and 1 or nRcl);
     
    local nHits = 1 + math.floor((nTarget + rRoll.nMod - nTotal) / nRcl);
    nHits = (nHits > nRoF and nRoF or nHits);
    
    rMessage.text = string.format("%s\n%s%s%s %s(%d):%s%s",
        (string.format("%s%s",(rTarget and string.format("%s || ",rTarget.sName) or ""), rMessage.text)),
        (rRoll.sWeapon or ""), 
        ((rRoll.sWeapon and rRoll.sWeapon ~= '' and rRoll.sTargetDesc and rRoll.sTargetDesc ~= '') and "\n" or ""), 
        (rRoll.sTargetDesc or ""), 
        (rRoll.nMod ~= 0 and string.format("(%d%s%d)=", nTarget, (rRoll.nMod > 0 and "+" or ""), rRoll.nMod) or ""),
        nTarget + rRoll.nMod, 
        GameSystem.rollResult(nTotal, nTarget + rRoll.nMod),
        (nHits > 0 and string.format(" [Maximum %d hit%s]", nHits, (nHits > 1 and "s" or "")) or "")
    );
    
    rMessage.diemodifier = (bAddMod and rRoll.nMod or 0);
    
    Comm.deliverChatMessage(rMessage);
  end
end