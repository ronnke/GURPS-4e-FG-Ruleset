-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
  ActionsManager.registerModHandler("reaction", modRoll);
  ActionsManager.registerResultHandler("reaction", onReaction);
end

function modRoll(rSource, rTarget, rRoll)
end

function onReaction(rSource, rTarget, rRoll)
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
    local sResult = "";
    if nTotal <= 0 then
        sResult = "[ Disastrous! ]";
    elseif nTotal >= 1 and nTotal <=3 then
        sResult = "[ Very Bad! ]";
    elseif nTotal >= 4 and nTotal <=6 then
        sResult = "[ Bad! ]";
    elseif nTotal >= 7 and nTotal <=9 then
        sResult = "[ Poor! ]";
    elseif nTotal >= 10 and nTotal <=12 then
        sResult = "[ Neutral! ]";
    elseif nTotal >= 13 and nTotal <=15 then
        sResult = "[ Good! ]";
    elseif nTotal >= 16 and nTotal <=18 then
        sResult = "[ Very Good! ]";
    elseif nTotal >= 19 then
        sResult = "[ Excellent! ]";
    end
    
    rMessage.text = string.format("%s\n%s", string.format("%s%s",(rTarget and string.format("%s || ",rTarget.sName) or ""), rMessage.text), sResult);
  	
    rMessage.diemodifier = (bAddMod and rRoll.nMod or 0);
  	
  	Comm.deliverChatMessage(rMessage);
  end
end

function performRoll(draginfo, rActor)
    rRoll = { sType = "reaction", sDesc = "[REACTION]", aDice = { "d6","d6","d6" }, nMod = 0 };
    
    ActionsManager.performAction(draginfo, rActor, rRoll);
end
