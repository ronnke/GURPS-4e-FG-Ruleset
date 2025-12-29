-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
end

function applyFatigue(rSource, rTarget, bSecret, sDamage, nTotal)
	local nodeTarget;
	if ActorManager.isPC(rTarget) then
		nodeTarget = ActorManager.getCreatureNode(rTarget);
	else
		nodeTarget = ActorManager.getCTNode(rTarget);
	end
	if not nodeTarget then
		return;
	end

	local nFP, nFatigue;
	if ActorManager.isPC(rTarget) then
		nFP = DB.getValue(nodeTarget, "attributes.fatiguepoints", 0);
		nFatigue = DB.getValue(nodeTarget, "attributes.fatigue", 0) + nTotal;
		DB.setValue(nodeTarget, "attributes.fps", "number", nFP - (nFatigue < 0 and 0 or nFatigue));
		DB.setValue(nodeTarget, "attributes.fatigue", "number", (nFatigue < 0 and 0 or nFatigue));
		DB.setValue(nodeTarget, "attributes.fpstatus", "string", ActorManagerGURPS4e.getFPStatusThreshold(rTarget));
	elseif ActorManager.isRecordType(rTarget, "npc") then
		nFP = DB.getValue(nodeTarget, "attributes.fatiguepoints", 0);
		nFatigue = DB.getValue(nodeTarget, "fatigue", 0) + nTotal;
		DB.setValue(nodeTarget, "fps", "number", nFP - (nFatigue < 0 and 0 or nFatigue));
		DB.setValue(nodeTarget, "fatigue", "number", (nFatigue < 0 and 0 or nFatigue));
		DB.setValue(nodeTarget, "fpstatus", "string", ActorManagerGURPS4e.getFPStatusThreshold(rTarget));
	else
		return;
	end
end

function updateFatigue(rActor)
	local nodeActor;
	if ActorManager.isPC(rActor) then
		nodeActor = ActorManager.getCreatureNode(rActor);
	else
		nodeActor = ActorManager.getCTNode(rActor);
	end
	if not nodeActor then
		return;
	end

	local nFP, nFatigue;
	if ActorManager.isPC(rActor) then
		nFP = DB.getValue(nodeActor, "attributes.fatiguepoints", 0);
		nFatigue = DB.getValue(nodeActor, "attributes.fatigue", 0);
		DB.setValue(nodeActor, "attributes.fps", "number", nFP - (nFatigue < 0 and 0 or nFatigue));
		DB.setValue(nodeActor, "attributes.fpstatus", "string", ActorManagerGURPS4e.getFPStatusThreshold(rActor));
    elseif ActorManager.isRecordType(rActor, "npc") then
		nFP = DB.getValue(nodeActor, "attributes.fatiguepoints", 0);
		nFatigue = DB.getValue(nodeActor, "fatigue", 0);
		DB.setValue(nodeActor, "fps", "number", nFP - (nFatigue < 0 and 0 or nFatigue));
		DB.setValue(nodeActor, "fpstatus", "string", ActorManagerGURPS4e.getFPStatusThreshold(rActor));
	else
		return;
	end
end
