-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
    ActionsManager.registerModHandler("melee", ActionMelee.modRoll);
    ActionsManager.registerResultHandler("melee", ActionMelee.onRoll);
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

    local node = DB.findNode(rRoll.sNode);
    local sWeapon = DB.getValue(node.getChild("..."), "name", "");
    local sMode = DB.getValue(node, "name", "");
    local nTarget = DB.getValue(node, "level", 0);
  
    rMessage.text = string.format("%s%s\n%s%s %s(%d)\n%s",
        rTarget and rTarget.sName and rTarget.sName .. ", " or "",
        rMessage.text,
        sWeapon or "",
        sMode and sMode ~= "" and ((sWeapon and sWeapon ~= "") and " (" .. sMode .. ")" or sMode) or "",
        rRoll.nMod ~= 0 and string.format("(%d%+d)=", nTarget, rRoll.nMod) or "",
        nTarget + rRoll.nMod,
        ManagerGURPS4e.rollResult(nTotal, nTarget + rRoll.nMod)
    );
    
    Comm.deliverChatMessage(rMessage);
end

function performRoll(draginfo, rActor, sNode)
    local rRoll = { sType = "melee", sDesc = "[MELEE]", aDice = { "d6","d6","d6" }, nMod = 0, sNode = sNode };
    
    ActionsManagerGURPS4e.performAction(draginfo, rActor, rRoll);
end
