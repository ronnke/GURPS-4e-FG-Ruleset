-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	ActionsManager.registerModHandler("ability", modRoll);
	ActionsManager.registerResultHandler("ability", onRoll);
end

function modRoll(rSource, rTarget, rRoll)
end

function onRoll(rSource, rTarget, rRoll)
	local rMessage = ActionsManager.createActionMessage(rSource, rRoll);
	local nTotal = ActionsManagerGURPS4e.total(rRoll);

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
  
    rMessage.text = string.format("%s\n%s%s%s %s(%d)\n%s",
        (string.format("%s%s",(rTarget and string.format("%s || ",rTarget.sName) or ""), rMessage.text)),
        (rRoll.sWeapon or ""), 
        ((rRoll.sWeapon and rRoll.sWeapon ~= '' and rRoll.sTargetDesc and rRoll.sTargetDesc ~= '') and "\n" or ""), 
        (rRoll.sTargetDesc or ""), 
        (rRoll.nMod ~= 0 and string.format("(%d%s%d)=", nTarget, (rRoll.nMod > 0 and "+" or ""), rRoll.nMod) or ""),
        nTarget + rRoll.nMod, 
        ManagerGURPS4e.rollResult(nTotal, nTarget + rRoll.nMod)
    );
  	
    rMessage.diemodifier = (bAddMod and rRoll.nMod or 0);
 	
  	Comm.deliverChatMessage(rMessage);
  end
end

function performAbilityRoll(draginfo, rActor, sTargetDesc, nTarget)
    rRoll = { sType = "ability", sDesc = "[ABILITY]", aDice = { "d6","d6","d6" }, nMod = 0, sTargetDesc = sTargetDesc, nTarget = nTarget };

    ActionsManager.performAction(draginfo, rActor, rRoll);
end

function performAttributeRoll(draginfo, rActor, sTargetDesc, nTarget)
    rRoll = { sType = "ability", sDesc = "[ATTRIBUTE]", aDice = { "d6","d6","d6" }, nMod = 0, sTargetDesc = sTargetDesc, nTarget = nTarget };

    ActionsManager.performAction(draginfo, rActor, rRoll);
end

function performSkillRoll(draginfo, rActor, sTargetDesc, nTarget)
    rRoll = { sType = "ability", sDesc = "[SKILL]", aDice = { "d6","d6","d6" }, nMod = 0, sTargetDesc = sTargetDesc, nTarget = nTarget };

    ActionsManager.performAction(draginfo, rActor, rRoll);
end

function performRelativeSkillRoll(draginfo, rActor, sTargetDesc, nTarget)
    rRoll = { sType = "ability", sDesc = "[RELATIVE SKILL]", aDice = { "d6","d6","d6" }, nMod = 0, sTargetDesc = sTargetDesc, nTarget = nTarget };
    
    ActionsManager.performAction(draginfo, rActor, rRoll);
end

function performSpellRoll(draginfo, rActor, sTargetDesc, nTarget)
    rRoll = { sType = "ability", sDesc = "[SPELL]", aDice = { "d6","d6","d6" }, nMod = 0, sTargetDesc = sTargetDesc, nTarget = nTarget };
    
    ActionsManager.performAction(draginfo, rActor, rRoll);
end

function performPowerRoll(draginfo, rActor, sTargetDesc, nTarget)
    rRoll = { sType = "ability", sDesc = "[POWER]", aDice = { "d6","d6","d6" }, nMod = 0, sTargetDesc = sTargetDesc, nTarget = nTarget };
    
    ActionsManager.performAction(draginfo, rActor, rRoll);
end

function performOtherRoll(draginfo, rActor, sTargetDesc, nTarget)
    rRoll = { sType = "ability", sDesc = "[OTHER]", aDice = { "d6","d6","d6" }, nMod = 0, sTargetDesc = sTargetDesc, nTarget = nTarget };
    
    ActionsManager.performAction(draginfo, rActor, rRoll);
end
