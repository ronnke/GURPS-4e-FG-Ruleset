-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

--  ACTION FLOW
--
--	1. INITIATE ACTION (DRAG OR DOUBLE-CLICK)
--	2. DETERMINE TARGETS (DROP OR TARGETING SUBSYSTEM)
--	3. APPLY MODIFIERS
--	4. PERFORM ROLLS (IF ANY)
--	5. RESOLVE ACTION

-- ROLL
--		.sType
--		.sDesc
--		.aDice
--		.nMod
--		(Any other fields added as string -> string map, if possible)

function total(rRoll)
	local nTotal = rRoll and rRoll.nTotal or 0;
	
	if GameSystem.actions[rRoll.sType] and not GameSystem.actions[rRoll.sType].bAddMod then
		nTotal = nTotal - rRoll.nMod;
	end
	
	return nTotal;
end

function actionIcon(rRoll)
	if not rRoll or not rRoll.sType then
		return "action_roll";
	end

	return GameSystem.actions[rRoll.sType] and GameSystem.actions[rRoll.sType].sIcon or "action_roll";
end

function performAction(draginfo, rActor, rRoll)
	if Input.isControlPressed() then
	    rRoll.bSecret = true;
	    rRoll.bTower = true;
	end 
	ActionsManager.performAction(draginfo, rActor, rRoll);
end

function createActionMessage(rSource, rRoll)
	local rMessage = ActionsManager.createActionMessage(rSource, rRoll);
	rMessage.icon = ActionsManagerGURPS4e.actionIcon(rRoll);
	rMessage.diemodifier = GameSystem.actions[rRoll.sType] and not GameSystem.actions[rRoll.sType].bAddMod and 0 or rMessage.diemodifier
	return rMessage;
end

function messageDamageResult(rSource, rTarget, rMessageGM, rMessagePlayer)
	local bTargetFriendly = rTarget and ActorManager.isFaction(rTarget, "friend");
	local nodeCT = ActorManager.getCTNode(rTarget);
	local bIsTargetHidden = nodeCT and CombatManager.isCTHidden(nodeCT);

	local bShowGMToPlayers = bTargetFriendly and not bIsTargetHidden;

	-- GM always sees GM message
	if bShowGMToPlayers then
		rMessageGM.secret = false;
		Comm.deliverChatMessage(rMessageGM);
		return; -- already shown to everyone
	end

	rMessageGM.secret = true;
	Comm.deliverChatMessage(rMessageGM, "");

	-- Players see player message only when GM message is secret/hidden
	if Session.IsHost then
		local tUsers = User.getActiveUsers();
		if #tUsers > 0 then
			Comm.deliverChatMessage(rMessagePlayer, tUsers);
		end
	else
		Comm.addChatMessage(rMessagePlayer);
	end
end
