-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	ActionsManager.registerModHandler("dice", ActionGeneral.modRoll);
	ActionsManager.registerResultHandler("dice", ActionGeneral.onRoll);
end

function modRoll(rSource, rTarget, rRoll)
end

function onRoll(rSource, rTarget, rRoll)
	local rMessage = ActionsManagerGURPS4e.createActionMessage(rSource, rRoll);
	Comm.deliverChatMessage(rMessage);
end
