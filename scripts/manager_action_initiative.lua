-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

OOB_MSGTYPE_APPLYINIT = "applyinit";

function onInit()
	OOBManager.registerOOBMsgHandler(OOB_MSGTYPE_APPLYINIT, handleApplyInit);

	ActionsManager.registerModHandler("initiative", modRoll);
	ActionsManager.registerResultHandler("initiative", onRoll);
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
	local rMessage = ActionsManager.createActionMessage(rSource, rRoll);
	local nTotal = ActionsManagerGURPS4e.total(rRoll);
    
    local sOptRNDINIT = OptionsManager.getOption("RNDINIT");
    if sOptRNDINIT == "d4x" or sOptRNDINIT == "d6x" then
        nTotal = nTotal * 0.25;
    end

    local bAddMod = false;
    if GameSystem.actions[rRoll.sType] then
        bAddMod = GameSystem.actions[rRoll.sType].bAddMod;
    end

	local msgOOB = {};
	msgOOB.type = OOB_MSGTYPE_APPLYINIT;
	msgOOB.nTotal = nTotal;
	msgOOB.sSourceNode = ActorManager.getCreatureNodeName(rSource);
	Comm.deliverOOBMessage(msgOOB, "");

    -- Send the chat message
    local bShowMsg = true;
    if not rSource then
        bShowMsg = false;
    end
  
    if bShowMsg then
        rMessage.text = string.format("%s %s", rMessage.text, string.format("[ %+g ]", nTotal));

        rMessage.diemodifier = (bAddMod and rRoll.nMod or 0);
  	
        Comm.deliverChatMessage(rMessage);
    end
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

    rRoll = { sType = "initiative", sDesc = "[INIT]", aDice = aDice, nMod = 0 };

    ActionsManagerGURPS4e.performAction(draginfo, rActor, rRoll);
end
