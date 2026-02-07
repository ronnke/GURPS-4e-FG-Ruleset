-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
  ActionsManager.registerModHandler("ranged", ActionRanged.modRoll);
  ActionsManager.registerResultHandler("ranged", ActionRanged.onRoll);
end

function modRoll(rSource, rTarget, rRoll)
    local sOptAUTORANGE = OptionsManager.getOption("AUTORANGE");
    if sOptAUTORANGE ~= "on" then
        return;
    end

    local function getRangeModifier(rSource, rTarget)
        local nodeCTSource = ActorManager.getCTNode(rSource);
        local nodeCTTarget = ActorManager.getCTNode(rTarget);

        if nodeCTSource and nodeCTTarget then
            local tokenSource = CombatManager.getTokenFromCT(nodeCTSource);
            local tokenTarget = CombatManager.getTokenFromCT(nodeCTTarget);
            local nDistance = TokenManagerGURPS4e.getDistance(tokenSource, tokenTarget);

            if nDistance and nDistance > 0 then
                return ManagerGURPS4e.calcRangeMod(nDistance);
            end
        end
        return 0;
    end

    if rSource and rTarget then
        local nRangeModifier = getRangeModifier(rSource, rTarget);
        rRoll.nMod = (rRoll.nMod or 0) + nRangeModifier;
        rRoll.sDesc = string.format("%s(%+d)", rRoll.sDesc or "", nRangeModifier);
    end
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

    local nRoF, nRoFMultiplier = string.match(DB.getValue(node, "rof", ""), "(%d+)%s*[x]?%s*(%d*)");
    nRoF = tonumber(((nRoF == nil or nRoF == "" or tonumber(nRoF) < 0) and 0 or nRoF));
    nRoFMultiplier = tonumber(((nRoFMultiplier == nil or nRoFMultiplier == "") and 1 or nRoFMultiplier));

    local nAmmo = DB.getValue(node.getChild("..."), "ammo", 0) - nRoF;
    nAmmo = ((nAmmo < 0) and 0 or nAmmo);
  
    DB.setValue(node.getChild("..."), "ammo", "number",  nAmmo );

    local nRcl = tonumber(string.match(DB.getValue(node, "rcl", ""), "%d+"));
    nRcl = ((nRcl == nil or nRcl < 1) and 1 or nRcl);

    local nHits = 1 + math.floor((nTarget + rRoll.nMod - nTotal) / nRcl);
    nHits = (nHits > (nRoF*nRoFMultiplier) and (nRoF*nRoFMultiplier) or nHits);

    rMessage.text = string.format("%s%s\n%s%s %s(%d)\n%s%s",
        rTarget and rTarget.sName and rTarget.sName .. ", " or "",
        rMessage.text,
        sWeapon or "",
        sMode and sMode ~= "" and ((sWeapon and sWeapon ~= "") and " (" .. sMode .. ")" or sMode) or "",
        rRoll.nMod ~= 0 and string.format("(%d%+d)=", nTarget, rRoll.nMod) or "",
        nTarget + rRoll.nMod,
        ManagerGURPS4e.rollResult(nTotal, nTarget + rRoll.nMod),
        nHits > 0 and string.format(" [Maximum %d hit%s]", nHits, nHits > 1 and "s" or "") or ""
    );
    
    Comm.deliverChatMessage(rMessage);
end

function performRoll(draginfo, rActor, sNode)
    local rRoll = { sType = "ranged", sDesc = "[RANGED]", aDice = { "d6","d6","d6" }, nMod = 0, sNode = sNode };
    
    ActionsManagerGURPS4e.performAction(draginfo, rActor, rRoll);
end
