-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--


OOB_MSGTYPE_APPLYDMG = "applydmg";
OOB_MSGTYPE_APPLYINJ = "applyinj";

function onInit()
	OOBManager.registerOOBMsgHandler(ActionDamage.OOB_MSGTYPE_APPLYDMG, ActionDamage.handleApplyDamage);
	OOBManager.registerOOBMsgHandler(ActionDamage.OOB_MSGTYPE_APPLYINJ, ActionDamage.handleApplyInjury);

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

    if Session.IsHost then
	    local rRoll = UtilityManager.decodeRollFromOOB(msgOOB);

        ActionDamage.applyDamage(rSource, rTarget, rRoll);
    end
end

function handleApplyInjury(msgOOB)
	local rSource = ActorManager.resolveActor(msgOOB.sSourceNode);
	local rTarget = ActorManager.resolveActor(msgOOB.sTargetNode);
	if not rTarget then
        return;
	end

    if Session.IsHost then
        local sType = StringManagerGURPS4e.containsAny({ "fat" }, msgOOB.sDamageType) and "FP" or "HP";
        local nInjury = tonumber(msgOOB.nInjury) or 0;
        local sMessage = msgOOB.sMessage or "";

        ActionDamage.applyInjury(rSource, rTarget, sType, nInjury, sMessage);
    end
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

	    if rRoll.nTotal <= 0 and StringManagerGURPS4e.containsAny({ "cr" }, rRoll.sDamageType) then
		    rMessage.text = rMessage.text .. "\n[NO DAMAGE]";
            rMessage.nTotal = 0;
	    elseif rRoll.nTotal < 1 then
		    rMessage.text = rMessage.text .. "\n[MINIMUM 1 DAMAGE]";
            rMessage.nTotal = 1;
	    end

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
        Comm.deliverOOBMessage(msgOOB);
    end
end

function applyDamage(rSource, rTarget, rRoll)
	local nodeCT = ActorManager.getCTNode(rTarget);
	if not nodeCT then
		return;
	end

    local nTotal = rRoll.nTotal or 0;
	if nTotal <= 0 and StringManagerGURPS4e.containsAny({ "cr" }, rRoll.sDamageType) then
        nTotal = 0;
	elseif nTotal < 1 then
        nTotal = 1;
	end

    if nTotal <= 0 then
        return;
    end

	local sDR = string.match(DB.getValue(nodeCT, "combat.dr", "0"), "%-?%d+%.?%d*");
	local nDR = tonumber(sDR) or 0;

	local nodeDamage = DB.createChild(DB.createChild(nodeCT, "damage"));
    DB.setValue(nodeDamage, "sourcenode", "string", ActorManager.getCreatureNodeName(rSource));
    DB.setValue(nodeDamage, "targetnode", "string", ActorManager.getCreatureNodeName(rTarget));
	DB.setValue(nodeDamage, "damage", "number", nTotal);
	DB.setValue(nodeDamage, "armordivisor", "number", tonumber(rRoll.nDivisor) or 1);
	DB.setValue(nodeDamage, "damagetype", "string", rRoll.sDamageType or "");
	DB.setValue(nodeDamage, "dr", "number", nDR);
end

function applyInjury(rSource, rTarget, sType, nInjury, sMessage)
    if not rSource and not rTarget then
        return;
    end

    local nodeTarget;
	if ActorManager.isPC(rTarget) then
		nodeTarget = ActorManager.getCreatureNode(rTarget);
	else
		nodeTarget = ActorManager.getCTNode(rTarget);
	end
	if not nodeTarget then
		return;
	end

    local nHP, nFP;
	if ActorManager.isPC(rTarget) then
        nHP = DB.getValue(nodeTarget, "attributes.injury", 0) + (sType == "HP" and nInjury or 0);
        nFP = DB.getValue(nodeTarget, "attributes.fatigue", 0) + (sType == "FP" and nInjury or 0);
        DB.setValue(nodeTarget, "attributes.injury", "number", (nHP < 0 and 0 or nHP));
        DB.setValue(nodeTarget, "attributes.fatigue", "number", (nFP < 0 and 0 or nFP));
	elseif ActorManager.isRecordType(rTarget, "npc") then
        nHP = DB.getValue(nodeTarget, "injury", 0) + (sType == "HP" and nInjury or 0);
        nFP = DB.getValue(nodeTarget, "fatigue", 0) + (sType == "FP" and nInjury or 0);
        DB.setValue(nodeTarget, "injury", "number", (nHP < 0 and 0 or nHP));
        DB.setValue(nodeTarget, "fatigue", "number", (nFP < 0 and 0 or nFP));
	elseif ActorManager.isRecordType(rTarget, "vehicle") then
        -- TODO: Vehicle Damage
	else
		return;
    end

    local rMessageGM = { font = "sheetlabel", icon = "action_damage" };
    local rMessagePlayer = { font = "sheetlabel", icon = "action_damage" };

    if sType == "HP" then
	    rMessageGM.text = string.format("[INJURY] %d HP applied to: %s", nInjury, ActorManager.resolveDisplayName(rTarget));
        if sMessage and sMessage ~= "" then
            rMessageGM.text = rMessageGM.text .. string.format("\n( %s)",sMessage);
        end
    elseif sType == "FP" then
	    rMessageGM.text = string.format("[INJURY] %d FP applied to: %s", nInjury, ActorManager.resolveDisplayName(rTarget));
        if sMessage and sMessage ~= "" then
            rMessageGM.text = rMessageGM.text .. string.format("\n( %s)",sMessage);
        end
    end

    rMessagePlayer.text = string.format("[INJURY] applied to: %s", ActorManager.resolveDisplayName(rTarget));

    ActionsManagerGURPS4e.messageDamageResult(rSource, rTarget, rMessageGM, rMessagePlayer);
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

function performRoll(draginfo, rActor, sWeapon, sMode, sDamage, bHalfDamage)
    local sResult, tResult = ActionDamage.parseDamageString(sDamage);

    local sDesc = bHalfDamage and "[HALF DAMAGE]" or "[DAMAGE]";
    local sExpr = bHalfDamage and ("(" .. tResult.sDamage .. ")/2") or tResult.sDamage;

    local rRoll = {
        sType = "damage",
        sDesc = sDesc,
        aDice = { expr = ManagerGURPS4e.normalizeGURPSDice(sExpr) },
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
        return nil, nil, nil;
    end

    local line = s:match("^(.-):%s*%[%s*[%+%-]?%d+%s*%]%s*$") or s;

    local core, damage = line:match("^(.-):%s*(.-)%s*$");
    if not core or not damage then return nil, nil, nil end

    local function matchDamageTag(text, prefix)
        return text:match(prefix .. "%[HALF%s+DAMAGE[%]%}]%s*(.*)$")
            or text:match(prefix .. "%[DAMAGE[%]%}]%s*(.*)$");
    end

    local name, afterDamage = core:match("^(.-)%s*,%s*(.*)$");
    if afterDamage then
        afterDamage = matchDamageTag(afterDamage, "^");
    end

    if not afterDamage then
        name = "";
        afterDamage = matchDamageTag(core, "^");
        if not afterDamage then return nil, nil, nil end
    end

    local mode = afterDamage:match("^%[.-%]%s*(.-)%s*$") or afterDamage:match("^(.-)%s*$") or "";

    return name, mode, damage;
end

function parseDamageString(s)
    local function trim(str)
        return (str:gsub("^%s+", ""):gsub("%s+$", ""))
    end

    local function escapePattern(str)
        return str:gsub("([%%%^%$%(%)%.%[%]%*%+%-%?])", "%%%1")
    end

    local function buildLookupSet(list)
        local set = {}
        for _, v in ipairs(list) do
            set[trim(v)] = true
        end
        return set
    end

    local function buildSortedCopyByLengthDesc(list)
        local out = {}
        for _, v in ipairs(list) do
            table.insert(out, trim(v))
        end

        table.sort(out, function(a, b)
            if #a == #b then
                return a > b
            end
            return #a > #b
        end)

        return out
    end

    local tDamageTypeSet = buildLookupSet(DataCommon.aDamageTypeData)
    local tDamageTypesSorted = buildSortedCopyByLengthDesc(DataCommon.aDamageTypeData)
    local tArmorDivisorSet = buildLookupSet(DataCommon.aArmorDivisorData)

    local tArmorDivisorNormalize = {
        ["(1/5)"] = "(0.2)",
        ["(0.2)"] = "(0.2)",
        ["(1/2)"] = "(0.5)",
        ["(0.5)"] = "(0.5)",
        ["(1)"] = "(1)",
        ["(2)"] = "(2)",
        ["(3)"] = "(3)",
        ["(5)"] = "(5)",
        ["(10)"] = "(10)",
        ["(100)"] = "(100)",
        ["(inf)"] = "(∞)",
        ["(inf.)"] = "(∞)",
        ["(∞)"] = "(∞)",
    }

    local tArmorDivisorValue = {
        ["(1/5)"] = 0.2,
        ["(0.2)"] = 0.2,
        ["(1/2)"] = 0.5,
        ["(0.5)"] = 0.5,
        ["(1)"] = 1,
        ["(2)"] = 2,
        ["(3)"] = 3,
        ["(5)"] = 5,
        ["(10)"] = 10,
        ["(100)"] = 100,
        ["(inf)"] = 0,
        ["(inf.)"] = 0,
        ["(∞)"] = 0,
    }

    local function normalizeDamageInput(str)
        str = str or ""

        -- Normalize common pasted Unicode variants
        str = str:gsub("×", "x")
        str = str:gsub("–", "-")
        str = str:gsub("—", "-")
        str = str:gsub("−", "-")

        -- Normalize common separators to spaces
        str = str:gsub(",", " ")
        str = str:gsub("&", " ")
        str = str:gsub(";", " ")

        -- Remove characters not normally part of a standard damage string
        -- Keep: letters, digits, spaces, (), [], + - . / x X * and ∞
        str = str:gsub("[^%a%d%s%(%)%[%]%+%-%./xX%*∞]", "")

        -- Collapse whitespace
        str = trim(str:gsub("%s+", " "))

        return str
    end

    local function normalizeDamageExpressionNotation(str)
        str = str:gsub("(%d[dD])%s*%*%s*(%d+)", "%1x%2")
        str = str:gsub("([%a]+)%s*%*%s*(%d+)", "%1x%2")
        str = str:gsub("(%b())%s*%*%s*(%d+)", "%1x%2")

        str = str:gsub("(%d[dD])%s*[xX]%s*(%d+)", "%1x%2")
        str = str:gsub("([%a]+)%s*[xX]%s*(%d+)", "%1x%2")
        str = str:gsub("(%b())%s*[xX]%s*(%d+)", "%1x%2")

        return str
    end

    local function extractFragmentation(str)
        local fragToken = str:match("%b[]")
        if not fragToken then
            return str, ""
        end

        local fragInner = trim(fragToken:sub(2, -2))
        str = trim(str:gsub(escapePattern(fragToken), "", 1))

        return str, fragInner
    end

    local function extractArmorDivisor(str)
        local matches = {}
        local i = 1

        while i <= #str do
            local startPos, endPos = str:find("%b()", i)
            if not startPos then
                break
            end

            local token = str:sub(startPos, endPos)

            if tArmorDivisorSet[token] then
                table.insert(matches, {
                    token = token,
                    startPos = startPos,
                    endPos = endPos,
                    display = tArmorDivisorNormalize[token],
                    value = tArmorDivisorValue[token],
                })
            end

            i = endPos + 1
        end

        if #matches == 0 then
            return str, nil, nil
        end

        local match = matches[#matches]
        str = trim(str:sub(1, match.startPos - 1) .. " " .. str:sub(match.endPos + 1))

        return str, match.value, match.display
    end

    local function extractDamageAndTypes(str)
        local damageParts = {}
        local damageTypes = {}
        local foundTypeSection = false

        for token in str:gmatch("%S+") do
            local prefix, compactType = nil, nil

            -- Check compact token like "2dpi++"
            if not tDamageTypeSet[token] then
                for _, dtype in ipairs(tDamageTypesSorted) do
                    if #token > #dtype and token:sub(-#dtype) == dtype then
                        local p = token:sub(1, #token - #dtype)
                        if p ~= "" then
                            prefix, compactType = p, dtype
                            break
                        end
                    end
                end
            end

            if not foundTypeSection then
                if tDamageTypeSet[token] then
                    table.insert(damageTypes, token)
                    foundTypeSection = true

                elseif compactType then
                    table.insert(damageParts, prefix)
                    table.insert(damageTypes, compactType)
                    foundTypeSection = true

                else
                    table.insert(damageParts, token)
                end
            else
                -- Once type section has started, only keep recognized damage types
                if tDamageTypeSet[token] then
                    table.insert(damageTypes, token)
                elseif compactType then
                    table.insert(damageTypes, compactType)
                end
                -- else discard unknown trailing tokens like "linked"
            end
        end

        return table.concat(damageParts, " "), table.concat(damageTypes, " ")
    end

    local function normalizeDamageSpacing(damage)
        damage = trim(damage)

        damage = damage:gsub("(%b())%s+x(%d+)", "%1x%2")
        damage = damage:gsub("([%a%d%+%-]+)%s+x(%d+)", "%1x%2")

        local prefix, mult = damage:match("^(.-)x(%d+)$")
        if prefix and mult then
            prefix = trim(prefix)

            local isAlreadyParenthesized = prefix:match("^%b()$") ~= nil
            local isCompound = prefix:find("[%+%-]") ~= nil

            if isCompound and not isAlreadyParenthesized then
                damage = "(" .. prefix .. ")x" .. mult
            end
        end

        return damage
    end

    if not s or s:match("^%s*$") then
        return "", {
            sDamage = "",
            nDivisor = nil,
            sFragmentation = "",
            sDamageType = ""
        }
    end

    s = normalizeDamageInput(s)
    s = normalizeDamageExpressionNotation(s)

    local fragmentation = ""
    local divisorDisplay = nil
    local divisorValue = nil

    s, fragmentation = extractFragmentation(s)
    s, divisorValue, divisorDisplay = extractArmorDivisor(s)

    local damage, damageType = extractDamageAndTypes(s)
    damage = normalizeDamageSpacing(trim(damage))

    local sResult = damage

    if divisorDisplay and divisorDisplay ~= "(1)" then
        sResult = sResult .. divisorDisplay
    end

    if fragmentation ~= "" then
        sResult = sResult .. " [" .. fragmentation .. "]"
    end

    if damageType ~= "" then
        sResult = sResult .. " " .. damageType
    end

    sResult = trim(sResult)

    return sResult, {
        sDamage = damage,
        nDivisor = divisorValue,
        sFragmentation = fragmentation,
        sDamageType = damageType
    }
end

function getWoundModifier( sDamageType, sHitLocation, sInjuryTolerance, options )
    options = options or {}
    
    local noBrain = options.noBrain == true
    local noHead = options.noHead == true
    local noEyes = options.noEyes == true
    local noNeck = options.noNeck == true
    local noVitals = options.noVitals == true

    if noBrain and sHitLocation == "Skull" then
        hitLocation = "Other"
    end

    if noHead and (sHitLocation == "Skull" or sHitLocation == "Face") then
        sHitLocation = "Other"
    end

    if noEyes and sHitLocation == "Eye" then
        sHitLocation = "Other"
    end

    if noNeck and sHitLocation == "Neck" then
        sHitLocation = "Other"
    end

    if noVitals and sHitLocation == "Vitals" then
        sHitLocation = "Other"
    end

    local dtTable = DataCommon.aWoundsData[sDamageType]
    if not dtTable then
        return 1
    end

    local hlTable = dtTable[sHitLocation] or dtTable["Other"] or dtTable["All"]
    if not hlTable then
        return 1
    end

    return hlTable[sInjuryTolerance] or 1
end

function applyHardened(nDivisor, sHardened)
	local nHardened = tonumber(sHardened) or 0

	-- Fractional divisors are unaffected by Hardened
	if nDivisor > 0 and nDivisor < 1 then
		return nDivisor
	end

	for _ = 1, nHardened do
		if nDivisor == 0 then
			nDivisor = 100
		elseif nDivisor == 100 then
			nDivisor = 10
		elseif nDivisor == 10 then
			nDivisor = 5
		elseif nDivisor == 5 then
			nDivisor = 3
		elseif nDivisor == 3 then
			nDivisor = 2
		elseif nDivisor == 2 then
			nDivisor = 1
		else
			break
		end
	end

	return nDivisor
end