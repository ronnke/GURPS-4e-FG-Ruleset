-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--


OOB_MSGTYPE_APPLYDMG = "applydmg";

function onInit()
	OOBManager.registerOOBMsgHandler(ActionDamage.OOB_MSGTYPE_APPLYDMG, ActionDamage.handleApplyDamage);

--	ActionsManager.registerModHandler("damage", ActionDamage.modRoll); -- If Enabled Rolling does not work due to dice expression formulas being used
	ActionsManager.registerPostRollHandler("damage", ActionDamage.onPostRoll);
	ActionsManager.registerResultHandler("damage", ActionDamage.onRoll);
end

function handleApplyDamage(msgOOB)
	local rSource = ActorManager.resolveActor(msgOOB.sSourceNode);
	local rTarget = ActorManager.resolveActor(msgOOB.sTargetNode);
	if not rTarget then
        return;
	end

	local rRoll = UtilityManager.decodeRollFromOOB(msgOOB);

    ActionDamage.applyDamage(rSource, rTarget, rRoll);
end

-- If Enabled Rolling does not work due to dice expression formulas being used
function modRoll(rSource, rTarget, rRoll)
    if rSource and rTarget then
        rRoll.nMod = rRoll.nMod + 0;
        rRoll.sDesc = rRoll.sDesc .. "";
    end
end

function onPostRoll(_, rRoll)
end

function onRoll(rSource, rTarget, rRoll)
    if not rSource and not rTarget then
        return;
    end

    local _, _, sDamage = ActionDamage.decodeDamageRoll(rRoll.sDesc or "");
    sDamage = rRoll.sDamage or sDamage;

    if not sDamage or sDamage == "" then
        return;
    end

    local sResult, tResult = ActionDamage.parseDamageString(sDamage)

    -- Add damage details
    rRoll.sDamage = sResult;
    rRoll.nDivisor = tResult.nDivisor;
    rRoll.sFragmentation = tResult.sFragmentation;
    rRoll.sDamageType = tResult.sDamageType;

    if rSource then
        local rMessage = ActionsManagerGURPS4e.createActionMessage(rSource, rRoll);
        rRoll.nTotal = ActionsManagerGURPS4e.total(rRoll);

        rMessage.text = string.format("%s%s\n%s%s: %s%s",
            rTarget and rTarget.sName and rTarget.sName .. ", " or "",
            rMessage.text,
            rRoll.sWeapon or "",
            rRoll.sMode and rRoll.sMode ~= "" and ((rRoll.sWeapon and rRoll.sWeapon ~= "") and " (" .. rRoll.sMode .. ")" or rRoll.sMode) or "",
            rRoll.sDamage or "",
            rRoll.nMod ~= 0 and string.format(" : [%+d]", rRoll.nMod) or ""
        );
        rMessage.nTotal = rRoll.nTotal;

        -- Send the chat message
		Comm.deliverChatMessage(rMessage);
    end

    if rTarget then
        if not rSource then
            local rMessage = ActionsManagerGURPS4e.createActionMessage(nil, rRoll);
            rRoll.nTotal = ActionsManagerGURPS4e.total(rRoll);
    
            rMessage.sender = nil; -- No sender for target-only messages
            rMessage.text = string.format("[DAMAGE] %s%s",
                rTarget and rTarget.sName or "",
                string.format(" : %s", rRoll.sDamage or "")
            );
            rMessage.nTotal = rRoll.nTotal;
            -- Send the chat message
		    Comm.deliverChatMessage(rMessage);
        end

        local msgOOB = UtilityManager.encodeRollToOOB(rRoll);
        msgOOB.type = ActionDamage.OOB_MSGTYPE_APPLYDMG;
        msgOOB.sSourceNode = ActorManager.getCreatureNodeName(rSource);
        msgOOB.sTargetNode = ActorManager.getCreatureNodeName(rTarget);

        -- Send the OOB message
        Comm.deliverOOBMessage(msgOOB, "");
    end

end

function applyDamage(rSource, rTarget, rRoll)
	nodeCT = ActorManager.getCTNode(rTarget)
	if not nodeCT then
		return
	end

    -- Ensure minimum damage rules are respected
    local nTotal = tonumber(rRoll.nTotal) or 0;
    if nTotal <= 0 and StringManagerGURPS4e.containsAny({ "cr" }, rRoll.sDamageType) then
        nTotal = 0;
    elseif nTotal < 1 then
        nTotal = 1;
    end

    local sDR = string.match(DB.getValue(nodeCT, "combat.dr", "0"), "%-?%d+%.?%d*")

    nodeDamage = DB.createChild(DB.createChild(nodeCT, "damage"))
    DB.setValue(nodeDamage, "damage", "number", nTotal);
    DB.setValue(nodeDamage, "armordivisor", "number", tonumber(rRoll.nDivisor) or 1);
    DB.setValue(nodeDamage, "damagetype", "string", rRoll.sDamageType);
    DB.setValue(nodeDamage, "dr", "number", tonumber(sDR) or 0);
end

function applyInjury(rActor, nHPInjury, nFPInjury)
	local nodeTarget;
	if ActorManager.isPC(rActor) then
		nodeTarget = ActorManager.getCreatureNode(rActor);
	else
		nodeTarget = ActorManager.getCTNode(rActor);
	end
	if not nodeTarget then
		return;
	end

    local nHP, nFP;
	if ActorManager.isPC(rActor) then
        nHP = DB.getValue(nodeTarget, "attributes.injury", 0) + nHPInjury;
        nFP = DB.getValue(nodeTarget, "attributes.fatigue", 0) + nFPInjury;
        DB.setValue(nodeTarget, "attributes.injury", "number", (nHP < 0 and 0 or nHP));
        DB.setValue(nodeTarget, "attributes.fatigue", "number", (nFP < 0 and 0 or nFP));
	elseif ActorManager.isRecordType(rActor, "npc") then
        nHP = DB.getValue(nodeTarget, "injury", 0) + nHPInjury;
        nFP = DB.getValue(nodeTarget, "fatigue", 0) + nFPInjury;
        DB.setValue(nodeTarget, "injury", "number", (nHP < 0 and 0 or nHP));
        DB.setValue(nodeTarget, "fatigue", "number", (nFP < 0 and 0 or nFP));
	elseif ActorManager.isRecordType(rActor, "vehicle") then
        -- TODO: Vehicle Damage
	else
		return;
    end


    local rMessage = ChatManager.createBaseMessage(nil, nil);
    rMessage.sender = nil; -- No sender for target-only messages
	rMessage.text = string.format("[INJURY] Applied to: %s", ActorManager.resolveDisplayName(rActor));
    
    Comm.deliverChatMessage(rMessage);
end

function updateDamage(rActor)
	local nodeActor;
	if ActorManager.isPC(rActor) then
		nodeActor = ActorManager.getCreatureNode(rActor);
	else
		nodeActor = ActorManager.getCTNode(rActor);
	end
	if not nodeActor then
		return;
	end

    local nHP, nInjury;
    if ActorManager.isPC(rActor) then
        nHP = DB.getValue(nodeActor, "attributes.hitpoints", 0);
        nInjury = DB.getValue(nodeActor, "attributes.injury", 0);
        DB.setValue(nodeActor, "attributes.hps", "number", nHP - (nInjury < 0 and 0 or nInjury));
        DB.setValue(nodeActor, "attributes.hpstatus", "string", ActorManagerGURPS4e.getHPStatusThreshold(rActor));
    elseif ActorManager.isRecordType(rActor, "npc") then
        nHP = DB.getValue(nodeActor, "attributes.hitpoints", 0);
        nInjury = DB.getValue(nodeActor, "injury", 0);
        DB.setValue(nodeActor, "hps", "number", nHP - (nInjury < 0 and 0 or nInjury));
        DB.setValue(nodeActor, "hpstatus", "string", ActorManagerGURPS4e.getHPStatusThreshold(rActor));
    elseif ActorManager.isRecordType(rActor, "vehicle") then
    -- TODO: Vehicle Damage
	else
		return;
    end
end

function performRoll(draginfo, rActor, sWeapon, sMode, sDamage)
    local sResult, tResult = ActionDamage.parseDamageString(sDamage)
    
    local rRoll = {
        sType = "damage",
        sDesc = "[DAMAGE]",
        aDice = { expr = ManagerGURPS4e.normalizeGURPSDice(tResult.sDamage) },
        nMod = 0,

        sWeapon = sWeapon,
        sMode = sMode,
        sDamage = sResult,
    };
    
    ActionsManagerGURPS4e.performAction(draginfo, rActor, rRoll);
end

function performThrustRoll(draginfo, rActor, sDamage)
    ActionDamage.performRoll(draginfo, rActor, "Basic Thrust", "", sDamage);
end

function performSwingRoll(draginfo, rActor, sDamage)
    ActionDamage.performRoll(draginfo, rActor, "Basic Swing", "", sDamage);
end

-- Helper functions
function decodeDamageRoll(s)
    if type(s) ~= "string" then
        return nil, nil, nil
    end

    local line = s:match("^(.-):%s*%[%s*[%+%-]?%d+%s*%]%s*$") or s;

    local core, damage = line:match("^(.-):%s*(.-)%s*$");
    if not core or not damage then return nil, nil, nil end

    local name, afterDamage = core:match("^(.-)%s*,%s*%[DAMAGE%]%s*(.*)$");
    if not afterDamage then
        name = "";
        afterDamage = core:match("^%[DAMAGE%]%s*(.*)$");
        if not afterDamage then return nil, nil, nil end
    end

    local mode = afterDamage:match("^%[.-%]%s*(.-)%s*$") or afterDamage:match("^(.-)%s*$") or "";

    return name, mode, damage;
end

function parseDamageString(s)
    -- Initialize return values
    local damage, divisor, fragmentation, damageType = "", nil, "", ""

    -- Handle nil or empty input
    if not s or s:match("^%s*$") then
        return "", { sDamage = "", nDivisor = nil, sFragmentation = "", sDamageType = "" }
    end

    -- Normalize whitespace: collapse multiple spaces, trim edges
    s = s:gsub("%s+", "")
    s = s:gsub("([%(%[])", " %1")
    s = s:gsub("([%)%]])", "%1 ")

    for _, dtype in ipairs(DataCommon.aDamageTypeData) do
      local escaped = dtype:gsub("([%%%^%$%(%)%.%[%]%*%+%-%?])", "%%%1")
      s = s:gsub(escaped, " " .. dtype)
    end

    s = s:gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")

    -- Extract fragmentation (e.g., "[2d]", "[1d+1]")
    local fragInner = s:match("%[(.-)%]")
    if fragInner then
        fragmentation = fragInner:gsub("%s+", "")
        s = s:gsub("%[" .. fragInner .. "%]", "", 1)
    end
    
    -- Extract divisor (e.g., "(5)", "(0.5)", "(1/2)", "(∞)", "(inf)", "(inf.)")
    local divisorInner = s:match("%(%s*([%.%d/∞inf%.]+)%s*%)")
    if divisorInner then
        local clean = divisorInner:gsub("%s+", "")
        
        -- Check for infinite cases first
        if clean == "∞" or clean:lower() == "inf" or clean:lower() == "inf." then
            divisor = 0  -- Set infinite divisor to 0
        else
            divisor = tonumber(clean)

            -- Handle fractions
            if not divisor and clean:match("^%d+/%d+$") then
                local num, denom = clean:match("^(%d+)/(%d+)$")
                if denom and tonumber(denom) > 0 then
                    divisor = tonumber(num) / tonumber(denom)
                    divisor = math.floor((divisor * 100) + 0.5) / 100
                end
            end
            if divisor < 0 then
                divisor = nil -- Set to nil if divisor is invalid
            end
        end
        s = s:gsub("%(%s*" .. divisorInner:gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1") .. "%s*%)", "", 1);
    end

    -- Extract Damage and Damage Types
    local tDamageTypeSet = {}
    for _, v in ipairs(DataCommon.aDamageTypeData) do 
      tDamageTypeSet[v] = true
    end

    -- Tokenize first
    local tTokens = {}
    for word in s:gmatch("%S+") do
        table.insert(tTokens, word)
    end

    -- Process and rebuild string
    local tRemaining = {}
    local tDamageTypes = {}
    for _, word in ipairs(tTokens) do
        if tDamageTypeSet[word] then
            table.insert(tDamageTypes, word)
        else
            table.insert(tRemaining, word)
        end
    end

    damage = table.concat(tRemaining, " ")
    damageType = table.concat(tDamageTypes, " ")

    -- Construct sResult (modify this section to use divisorDisplay)
    local sResult = damage
    if divisor then
        if divisor == 0 then
            sResult = sResult .. "(∞)"
        elseif divisor == 1 then
            sResult = sResult .. ""
        else
            sResult = sResult .. "(" .. tostring(divisor) .. ")"
        end
    end
    if fragmentation ~= "" then
        sResult = sResult .. " [" .. fragmentation .. "]"
    end
    if damageType ~= "" then
        sResult = sResult .. " " .. damageType
    end

    -- Construct tResult
    local tResult = {
        sDamage = damage,
        nDivisor = divisor,
        sFragmentation = fragmentation,
        sDamageType = damageType
    }

    return sResult, tResult
end
