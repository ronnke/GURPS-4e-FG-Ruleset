-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

--
-- Actions
--

function onInit()
	updateInjury();
end

function updateInjury()
	local node = getDatabaseNode();
	if not node then return end

	local rActor = ActorManager.resolveActor(DB.getChild(node, "..."));
	local nodeCT = rActor and ActorManager.getCTNode(rActor);
	if not nodeCT then return end

	local function setArmorDivisorText(nDivisor)
		if nDivisor == 0 then
			armordivisortext.setValue("(∞)");
		elseif nDivisor == 0.5 then
			armordivisortext.setValue("(0.5)");
		elseif nDivisor == 0.2 then
			armordivisortext.setValue("(0.2)");
		elseif nDivisor == 1 then
			armordivisortext.setValue("(none)");
		else
			armordivisortext.setValue(string.format("(%s)", nDivisor));
		end
	end

	local function getLocationMaxDamage(sHitLocation, nHP)
		if sHitLocation == "Arm" or sHitLocation == "Leg" then
			return math.floor(nHP / 2) + 1;
		elseif sHitLocation == "Hand" or sHitLocation == "Foot" then
			return math.floor(nHP / 3) + 1;
		end
		return 0;
	end

	local nHP = DB.getValue(nodeCT, "attributes.hitpoints", 0);
	local nST = DB.getValue(nodeCT, "attributes.strength", 0);

	local nDamage = math.max(0, tonumber(DB.getValue(node, "damage", 0)) or 0);
	local sDamageType = DB.getValue(node, "damagetype", "");
	local nDR = DB.getValue(node, "dr", 0);
	local nDivisor = DB.getValue(node, "armordivisor", 1);

	local sHitLocation = hitlocation.getValue();
	local sHardened = hardened.getValue();
	local sInjuryTolerance = injurytolerance.getValue();

	local bDiffuse = sInjuryTolerance == "Diffuse";
	local bHomogeneous = sInjuryTolerance == "Homogeneous";

	local nDamageMultiplier = 1;
	local nMaxDamage = getLocationMaxDamage(sHitLocation, nHP);
	local nDRModifier = (sHitLocation == "Skull" and not bDiffuse and not bHomogeneous) and 2 or 0;
	local nKnockback = 0;

	local bInc = false;
	local bExplosion = false;
	local bCr = false;
	local bCut = false;
	local bNoKnockback = false;
	local bDoubleKnockback = false;

	local tOptions = {};
	if bDiffuse then
		tOptions = { noBrain = true, noVitals = true, noBlood = true };
	elseif bHomogeneous then
		tOptions = { noBrain = true, noVitals = true };
	end

	local tDamageTypes = StringManagerGURPS4e.splitDamageTypes(sDamageType);

	for _, dt in ipairs(tDamageTypes) do
		if dt == "inc" then bInc = true end
		if dt == "ex" or dt == "exp" then bExplosion = true end
		if dt == "cr" then bCr = true end
		if dt == "cut" then bCut = true end
		if dt == "nkb" then bNoKnockback = true end
		if dt == "dkb" then bDoubleKnockback = true end

		local nDM = ActionDamage.getWoundModifier(dt, sHitLocation, sInjuryTolerance, tOptions);
		if nDM > nDamageMultiplier then
			nDamageMultiplier = nDM;
		end
	end

	if bDiffuse then
		if bExplosion then
			nMaxDamage = 0;
		else
			nMaxDamage = 1;
			for _, dt in ipairs(tDamageTypes) do
				local nMax = (dt == "imp" or dt == "pi-" or dt == "pi" or dt == "pi+" or dt == "pi++") and 1 or 2;
				if nMax > nMaxDamage then
					nMaxDamage = nMax;
				end
			end
		end
	end

	nDivisor = ActionDamage.applyHardened(nDivisor, sHardened);

	if nDivisor == 0 then
		nDR = 0;
	else
		nDR = math.floor((nDR + nDRModifier) / nDivisor);
	end

	local nInjury = math.max(0, nDamage - nDR);
	nInjury = nInjury * nDamageMultiplier;
	nInjury = (nInjury > 0 and nInjury <= 1) and 1 or math.floor(nInjury);

	if nInjury > 0 and bInc then
		nInjury = nInjury + 1;
	end

	if nMaxDamage ~= 0 and nInjury >= nMaxDamage then
		nInjury = nMaxDamage;
	end

	if not bNoKnockback and ((bCr and nDamage > 0) or (bCut and nInjury == 0)) then
		local nKBST = math.max(3, (nST > 0 and nST or nHP));
		local nKBDamage = bDoubleKnockback and (nDamage * 2) or nDamage;
		nKnockback = math.floor(nKBDamage / (nKBST - 2));
	end

	setArmorDivisorText(nDivisor);

	DB.setValue(node, "knockback", "number", nKnockback);
	DB.setValue(node, "injury", "number", nInjury);

	updateInjuryMessage();
end

function updateInjuryMessage()
	local node = getDatabaseNode();
	if not node then
		return;
	end

	local rActor = ActorManager.resolveActor(DB.getChild(node, "..."));
	local nodeCT = rActor and ActorManager.getCTNode(rActor);
	if not nodeCT then
		return;
	end

	local nHP = DB.getValue(nodeCT, "attributes.hitpoints", 0);
	local sDamageType = DB.getValue(node, "damagetype", "");
	local nInjury = DB.getValue(node, "injury", 0);
	local nKnockback = DB.getValue(node, "knockback", 0);
	local sInjuryTolerance = injurytolerance.getValue();
	local sHitLocation = hitlocation.getValue();

	local bDiffuse = sInjuryTolerance == "Diffuse";
	local bHomogeneous = sInjuryTolerance == "Homogeneous";
	local isImpPiBurn = StringManagerGURPS4e.containsAny({ "imp", "pi-", "pi", "pi+", "pi++", "burn" }, sDamageType);

	if bDiffuse or bHomogeneous then
		if sHitLocation == "Skull" then
			sHitLocation = "Face";
		elseif sHitLocation == "Vitals" or sHitLocation == "Groin" then
			sHitLocation = "Torso";
		elseif bDiffuse and (sHitLocation == "Arm" or sHitLocation == "Leg" or sHitLocation == "Hand" or sHitLocation == "Foot") then
			sHitLocation = "Torso";
		elseif sHitLocation == "Eye" then
			sHitLocation = "Eye Only";
		end
	elseif sHitLocation == "Vitals" and not isImpPiBurn then
		sHitLocation = "Torso";
	elseif sHitLocation == "Eye" and not isImpPiBurn then
		sHitLocation = "Eye Only";
	end

	local sMessageText = buildInjuryMessage(sHitLocation, sDamageType, nInjury, nHP, nKnockback);
	messagetext.setValue(sMessageText);
	DB.setValue(node, "message", "string", sMessageText);
end

function buildInjuryMessage(sHitLocation, sDamageType, nInjury, nHP, nKnockback)
	local tMessage = {};
	local tLimb = { Arm = true, Leg = true };
	local tExtremity = { Hand = true, Foot = true };
	local tSpecial = { Skull = true, Face = true, Eye = true, ["Eye Only"] = true, Vitals = true };

	local function add(s)
		tMessage[#tMessage + 1] = s;
	end

	local nMajorWound = math.floor(nHP / 2) + 1;
	local nExtremityCripple = math.floor(nHP / 3) + 1;
	local nEyeBlinding = math.floor(nHP / 10) + 1;

	if sHitLocation == "Skull" then
		add("Skull DR +2");
	end

	if nInjury > 0 and StringManagerGURPS4e.containsAny({ "inc" }, sDamageType) then
		add("+1 Incendiary damage");
	end

	if tLimb[sHitLocation] and nInjury >= nMajorWound then
		add("Major Wound");
		add(string.format("Crippled (%s)", sHitLocation));
		add("Knockdown");

	elseif tExtremity[sHitLocation] and nInjury >= nExtremityCripple then
		add("Major Wound");
		add(string.format("Crippled (%s)", sHitLocation));
		add("Knockdown");

	elseif nInjury >= nMajorWound then
		add("Major Wound");

		if sHitLocation == "Skull" then
			add("-10 Knockdown");
		elseif sHitLocation == "Eye" then
			add("-10 Knockdown");
			add("Eye blinded");
		elseif sHitLocation == "Face" or sHitLocation == "Vitals" then
			add("-5 Knockdown");
		elseif sHitLocation == "Eye Only" then
			add("-5 Knockdown");
			add("Eye blinded");
		elseif sHitLocation == "Groin" then
			add("-5 Knockdown (Males only)");
		else
			add("Knockdown");
		end

	elseif tSpecial[sHitLocation] then
		if (sHitLocation == "Eye" or sHitLocation == "Eye Only") and nInjury >= nEyeBlinding then
			add("Knockdown");
			add("Eye blinded");
		elseif nInjury > 0 then
			add("Knockdown");
		end
	end

	if nKnockback > 0 then
		add(string.format("Knockback %s yards", nKnockback));
	end

	return #tMessage > 0 and (table.concat(tMessage, "; ") .. "; ") or "";
end

function applyDamage()
	local node = getDatabaseNode();
	if not node then
		return;
	end

	local rSourceNode = DB.getValue(node, "sourcenode", "");
	local rTargetNode = DB.getValue(node, "targetnode", "");
	local nInjury = DB.getValue(node, "injury", 0);
	local sDamageType = DB.getValue(node, "damagetype", "");
	local sMessage = DB.getValue(node, "message", "");

    local msgOOB = {};
    msgOOB.type = ActionDamage.OOB_MSGTYPE_APPLYINJ;
    msgOOB.sSourceNode = rSourceNode;
    msgOOB.sTargetNode = rTargetNode;
	msgOOB.nInjury = nInjury;
	msgOOB.sDamageType = sDamageType;
	msgOOB.sMessage = sMessage;

    -- Send the OOB message
    Comm.deliverOOBMessage(msgOOB);

	removeEntry();
end

function removeEntry()
	DB.deleteNode(getDatabaseNode())
end
