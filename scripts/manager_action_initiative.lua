-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

OOB_MSGTYPE_APPLYINIT = "applyinit";

function onInit()
	OOBManager.registerOOBMsgHandler(OOB_MSGTYPE_APPLYINIT, ActionInitiative.handleApplyInit);

	ActionsManager.registerModHandler("initiative", ActionInitiative.modRoll);
	ActionsManager.registerResultHandler("initiative", ActionInitiative.onRoll);
end

function handleApplyInit(msgOOB)
	local rSource = ActorManager.resolveActor(msgOOB.sSourceNode);
	local nTotal = tonumber(msgOOB.nTotal) or 0;

    local nodeCT = ActorManager.getCTNode(rSource);
	if not nodeCT then
        return;
    end

    local nSpeed = nTotal;
	if ActorManager.isPC(rSource) then
		local nodePC = ActorManager.getCreatureNode(rSource);
		if nodePC then
            nSpeed = nSpeed + tonumber(DB.getValue(nodePC, "attributes.basicspeed", "0"));
		end
    else
        nSpeed = nSpeed + tonumber(DB.getValue(nodeCT, "attributes.basicspeed", "0"));
	end

    DB.setValue(nodeCT, "speed", "number", nSpeed);
end

function modRoll(rSource, rTarget, rRoll)
end

function onRoll(rSource, rTarget, rRoll)
    if not rSource then
        return;
    end

	local rMessage = ActionsManagerGURPS4e.createActionMessage(rSource, rRoll);
	local nTotal = ActionsManagerGURPS4e.total(rRoll);
    
    local sOptRNDINIT = OptionsManager.getOption("RNDINIT");
    if sOptRNDINIT == "d4x" or sOptRNDINIT == "d6x" then
        nTotal = nTotal * 0.25;
    end

    local msgOOB = UtilityManager.encodeRollToOOB(rRoll);
	msgOOB.type = ActionInitiative.OOB_MSGTYPE_APPLYINIT;
    msgOOB.sSourceNode = ActorManager.getCreatureNodeName(rSource);
	msgOOB.nTotal = nTotal;

	Comm.deliverOOBMessage(msgOOB, "");

    if not rSource then
        return;
    end

    -- Send the chat message
    rMessage.text = string.format("%s %s", rMessage.text, string.format("[ %+g ]", nTotal));

    Comm.deliverChatMessage(rMessage);
end

function performRoll(draginfo, rActor)
    local sOptRNDINIT = OptionsManager.getOption("RNDINIT");

    local aDice = { };
    if sOptRNDINIT == "d4" or sOptRNDINIT == "d4x" then
        aDice = { "d4" };
    elseif sOptRNDINIT == "d6" or sOptRNDINIT == "d6x" then
        aDice = { "d6" };
    else
        return;
    end

    local rRoll = { sType = "initiative", sDesc = "[INIT]", aDice = aDice, nMod = 0 };

    ActionsManagerGURPS4e.performAction(draginfo, rActor, rRoll);
end
