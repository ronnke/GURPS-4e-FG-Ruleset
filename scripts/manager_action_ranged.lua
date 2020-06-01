-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
  ActionsManager.registerModHandler("ranged", modRoll);
  ActionsManager.registerResultHandler("ranged", onRanged);
end

function modRoll(rSource, rTarget, rRoll)
end

function onRanged(rSource, rTarget, rRoll)
  local rMessage = ActionsManager.createActionMessage(rSource, rRoll);
  local nTotal = ActionsManager2.total(rRoll);

  local bAddMod = false;
  if GameSystem.actions[rRoll.sType] then
    bAddMod = GameSystem.actions[rRoll.sType].bAddMod;
  end

  local node = DB.findNode(rRoll.sNode);
  local sWeapon = DB.getValue(node.getParent().getParent(), "name", "");
  local sMode = DB.getValue(node, "name", "");

  local nRoF = tonumber(string.match(DB.getValue(node, "rof", ""), "%d+"));
  nRoF = ((nRoF == nil or nRoF < 1) and 1 or nRoF);
  
  local nAmmo = DB.getValue(node.getParent().getParent(), "ammo", 0) - nRoF;
  nAmmo = ((nAmmo < 0) and 0 or nAmmo);
  
  DB.setValue(node.getParent().getParent(), "ammo", "number",  nAmmo );

  -- Send the chat message
  local bShowMsg = true;
  if not rSource then
    bShowMsg = false;
  end
  
  if bShowMsg then
    local sTargetDesc =  DB.getValue(node, "name", "");
    local nTarget = DB.getValue(node, "level", 0);
    
    local nRcl = tonumber(string.match(DB.getValue(node, "rcl", ""), "%d+"));
    nRcl = ((nRcl == nil or nRcl < 1) and 1 or nRcl);

    local nHits = 1 + math.floor((nTarget + rRoll.nMod - nTotal) / nRcl);
    nHits = (nHits > nRoF and nRoF or nHits);
    
    rMessage.text = string.format("%s\n%s%s%s %s(%d):%s%s",
        (string.format("%s%s",(rTarget and string.format("%s || ",rTarget.sName) or ""), rMessage.text)),
        sWeapon, 
        ((sWeapon and sWeapon ~= '' and sTargetDesc and sTargetDesc ~= '') and "\n" or ""), 
        sTargetDesc, 
        (rRoll.nMod ~= 0 and string.format("(%d%s%d)=", nTarget, (rRoll.nMod > 0 and "+" or ""), rRoll.nMod) or ""),
        nTarget + rRoll.nMod, 
        GameSystem.rollResult(nTotal, nTarget + rRoll.nMod),
        (nHits > 0 and string.format(" [Maximum %d hit%s]", nHits, (nHits > 1 and "s" or "")) or "")
    );
    
    rMessage.diemodifier = (bAddMod and rRoll.nMod or 0);
    
    Comm.deliverChatMessage(rMessage);
  end
end