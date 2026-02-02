-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
  ActionsManager.registerModHandler("dodge", ActionDefense.modRoll);
  ActionsManager.registerResultHandler("dodge", ActionDefense.onRoll);

  ActionsManager.registerModHandler("parry", ActionDefense.modRoll);
  ActionsManager.registerResultHandler("parry", ActionDefense.onRoll);

  ActionsManager.registerModHandler("block", ActionDefense.modRoll);
  ActionsManager.registerResultHandler("block", ActionDefense.onRoll);
end

function modRoll(rSource, rTarget, rRoll)
end

function onRoll(rSource, rTarget, rRoll)
    if not rSource then
        return;
    end

    -- Send the chat message
    local rMessage = ActionsManagerGURPS4e.createActionMessage(rSource, rRoll);
    local nTotal = ActionsManagerGURPS4e.total(rRoll);

    local nTarget = tonumber(string.match(rRoll.nTarget, "%d+") or "0");
    local sExtra = string.match(rRoll.nTarget, "[uUfF]") or "";

    rMessage.text = string.format("%s\n%s%s%s %s(%d%s)\n%s",
        (string.format("%s%s",(rTarget and string.format("%s, ",rTarget.sName) or ""), rMessage.text)),
        (rRoll.sWeapon or ""), 
        ((rRoll.sWeapon and rRoll.sWeapon ~= '' and rRoll.sTargetDesc and rRoll.sTargetDesc ~= '') and "\n" or ""), 
        (rRoll.sTargetDesc or ""), 
        (rRoll.nMod ~= 0 and string.format("(%d%s%d)=", nTarget, (rRoll.nMod > 0 and "+" or ""), rRoll.nMod) or ""),
        nTarget + rRoll.nMod, 
        sExtra,
        ManagerGURPS4e.rollResult(nTotal, nTarget + rRoll.nMod)
    );
  
    Comm.deliverChatMessage(rMessage);
end

function performDodgeRoll(draginfo, rActor, nTarget)
    local rRoll = { sType = "dodge", sDesc = "[DODGE]", aDice = { "d6","d6","d6" }, nMod = 0, sTargetDesc = "Dodge", nTarget = nTarget };
    
    ActionsManagerGURPS4e.performAction(draginfo, rActor, rRoll);
end

function performBlockRoll(draginfo, rActor, nTarget)
    local rRoll = { sType = "block", sDesc = "[BLOCK]", aDice = { "d6","d6","d6" }, nMod = 0, sTargetDesc = "Block", nTarget = nTarget };
    
    ActionsManagerGURPS4e.performAction(draginfo, rActor, rRoll);
end

function performParryRoll(draginfo, rActor, nTarget)
    local rRoll = { sType = "parry", sDesc = "[PARRY]", aDice = { "d6","d6","d6" }, nMod = 0, sTargetDesc = "Parry", nTarget = nTarget };
    
    ActionsManagerGURPS4e.performAction(draginfo, rActor, rRoll);
end

function performWeaponParryRoll(draginfo, rActor, sWeapon, sMode, sTargetDesc, nTarget)
    local rRoll = { sType = "parry", sDesc = "[PARRY]", aDice = { "d6","d6","d6" }, nMod = 0, sWeapon = sWeapon, sMode = sMode, sTargetDesc = sTargetDesc, nTarget = nTarget };
    
    ActionsManagerGURPS4e.performAction(draginfo, rActor, rRoll);
end
