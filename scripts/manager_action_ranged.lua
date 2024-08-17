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
  local nTotal = ActionsManagerGURPS4e.total(rRoll);

  local bAddMod = false;
  if GameSystem.actions[rRoll.sType] then
    bAddMod = GameSystem.actions[rRoll.sType].bAddMod;
  end

  local node = DB.findNode(rRoll.sNode);
  local sWeapon = DB.getValue(node.getChild("..."), "name", "");
  local sMode = DB.getValue(node, "name", "");

  local nRoF, nRoFMultiplier = string.match(DB.getValue(node, "rof", ""), "(%d+)%s*[x]?%s*(%d*)");
  nRoF = tonumber(((nRoF == nil or nRoF == "" or tonumber(nRoF) < 0) and 0 or nRoF));
  nRoFMultiplier = tonumber(((nRoFMultiplier == nil or nRoFMultiplier == "") and 1 or nRoFMultiplier));

  local nAmmo = DB.getValue(node.getChild("..."), "ammo", 0) - nRoF;
  nAmmo = ((nAmmo < 0) and 0 or nAmmo);
  
  DB.setValue(node.getChild("..."), "ammo", "number",  nAmmo );

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
    nHits = (nHits > (nRoF*nRoFMultiplier) and (nRoF*nRoFMultiplier) or nHits);
    
    rMessage.text = string.format("%s\n%s%s%s %s(%d)\n%s%s",
        (string.format("%s%s",(rTarget and string.format("%s || ",rTarget.sName) or ""), rMessage.text)),
        sWeapon, 
        ((sWeapon and sWeapon ~= '' and sTargetDesc and sTargetDesc ~= '') and "\n" or ""), 
        sTargetDesc, 
        (rRoll.nMod ~= 0 and string.format("(%d%s%d)=", nTarget, (rRoll.nMod > 0 and "+" or ""), rRoll.nMod) or ""),
        nTarget + rRoll.nMod, 
        ManagerGURPS4e.rollResult(nTotal, nTarget + rRoll.nMod),
        (nHits > 0 and string.format(" [Maximum %d hit%s]", nHits, (nHits > 1 and "s" or "")) or "")
    );
    
    rMessage.diemodifier = (bAddMod and rRoll.nMod or 0);
    
    Comm.deliverChatMessage(rMessage);
  end
end

function performRoll(draginfo, rActor, sNode)
    rRoll = { sType = "ranged", sDesc = "[RANGED]", aDice = { "d6","d6","d6" }, nMod = 0, sNode = sNode };
    
    ActionsManager.performAction(draginfo, rActor, rRoll);
end
