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
	if not node then
		return;
	end

	local rActor = ActorManager.resolveActor(DB.getChild(node, "..."));
	local nodeCT = ActorManager.getCTNode(rActor);

	local nHP = DB.getValue(nodeCT, "attributes.hitpoints", 0);

	local nDamage = damage.getValue();
	local nDivisor = armordivisor.getValue();
	local sDamageType = damagetype.getValue();

	local nDR = dr.getValue();
	local sHitLocation = hitlocation.getValue();
	local sInjuryTolerance = injurytolerance.getValue();

	if not nDamage or nDamage < 1 then
		nDamage = 0;
	end

	if not nDivisor or nDivisor < 1 then
		nDivisor = 1;
	end

	local nMaxDamage = 0.0;
	local nDamageMultiplier = 1.0;
	local nDRModifier = 0;

	if sInjuryTolerance == "None" then
		if StringManagerGURPS4e.containsAny({ "imp" }, sDamageType) then
			nDamageMultiplier = 2;
		elseif StringManagerGURPS4e.containsAny({ "pi++" }, sDamageType) then
			nDamageMultiplier = 2;
		elseif StringManagerGURPS4e.containsAny({ "pi+" }, sDamageType) then
			nDamageMultiplier = 1 + 1/2;
		elseif StringManagerGURPS4e.containsAny({ "cut" }, sDamageType) then
			nDamageMultiplier = 1 + 1/2;
		elseif StringManagerGURPS4e.containsAny({ "pi" }, sDamageType) then
			nDamageMultiplier = 1;
		elseif StringManagerGURPS4e.containsAny({ "pi-" }, sDamageType) then
			nDamageMultiplier = 1/2;
		else
			nDamageMultiplier = 1;
		end	

		if sHitLocation == "Vitals" then
			if StringManagerGURPS4e.containsAny({ "imp", "pi-", "pi", "pi+", "pi++" }, sDamageType) then
				nDamageMultiplier = 3;
			elseif StringManagerGURPS4e.containsAny({ "burn" }, sDamageType) then
				nDamageMultiplier = 2;
			end
		elseif sHitLocation == "Skull" then
			if StringManagerGURPS4e.containsAny({ "tox" }, sDamageType) then
				nDamageMultiplier = 1;
			else
				nDRModifier = 2;
				nDamageMultiplier = 4;
			end
		elseif sHitLocation == "Eye" then
			if StringManagerGURPS4e.containsAny({ "imp", "pi-", "pi", "pi+", "pi++", "burn" }, sDamageType) then
				nDamageMultiplier = 4;
			end
		elseif sHitLocation == "Face" then
			if StringManagerGURPS4e.containsAny({ "cor" }, sDamageType) then
				nDamageMultiplier = 1 + 1/2;
			end
		elseif sHitLocation == "Neck" then
			if StringManagerGURPS4e.containsAny({ "cut" }, sDamageType) then
				nDamageMultiplier = 2;
			elseif StringManagerGURPS4e.containsAny({ "cr", "cor" }, sDamageType) then
				nDamageMultiplier = 1 + 1/2;
			end
		elseif sHitLocation == "Arm" or sHitLocation == "Leg" then
			if StringManagerGURPS4e.containsAny({ "imp", "pi+", "pi++" }, sDamageType) then
				nDamageMultiplier = 1;
			end
			nMaxDamage = math.ceil(nHP / 2);
		elseif sHitLocation == "Hand" or sHitLocation == "Foot" then
			if StringManagerGURPS4e.containsAny({ "imp", "pi+", "pi++" }, sDamageType) then
				nDamageMultiplier = 1;
			end
			nMaxDamage = math.ceil(nHP / 3);
		end
	elseif sInjuryTolerance == "Unliving" then
		if StringManagerGURPS4e.containsAny({ "cut" }, sDamageType) then
			nDamageMultiplier = 1 + 1/2;
		elseif StringManagerGURPS4e.containsAny({ "imp" }, sDamageType) then
			nDamageMultiplier = 1;
		elseif StringManagerGURPS4e.containsAny({ "pi++" }, sDamageType) then
			nDamageMultiplier = 1;
		elseif StringManagerGURPS4e.containsAny({ "pi+" }, sDamageType) then
			nDamageMultiplier = 1/2;
		elseif StringManagerGURPS4e.containsAny({ "pi-" }, sDamageType) then
			nDamageMultiplier = 1/5;
		elseif StringManagerGURPS4e.containsAny({ "pi" }, sDamageType) then
			nDamageMultiplier = 1/3;
		else
			nDamageMultiplier = 1;
		end	
	elseif sInjuryTolerance == "Homogenous" then
		if StringManagerGURPS4e.containsAny({ "cut" }, sDamageType) then
			nDamageMultiplier = 1 + 1/2;
		elseif StringManagerGURPS4e.containsAny({ "imp" }, sDamageType) then
			nDamageMultiplier = 1/2;
		elseif StringManagerGURPS4e.containsAny({ "pi++" }, sDamageType) then
			nDamageMultiplier = 1/2;
		elseif StringManagerGURPS4e.containsAny({ "pi+" }, sDamageType) then
			nDamageMultiplier = 1/3;
		elseif StringManagerGURPS4e.containsAny({ "pi" }, sDamageType) then
			nDamageMultiplier = 1/5;
		elseif StringManagerGURPS4e.containsAny({ "pi-" }, sDamageType) then
			nDamageMultiplier = 1/10;
		else
			nDamageMultiplier = 1;
		end	
	elseif sInjuryTolerance == "Diffuse" then

		if StringManagerGURPS4e.containsAny({ "ex", "exp" }, sDamageType) then
			if StringManagerGURPS4e.containsAny({ "imp" }, sDamageType) then
				nDamageMultiplier = 2;
			elseif StringManagerGURPS4e.containsAny({ "pi++" }, sDamageType) then
				nDamageMultiplier = 2;
			elseif StringManagerGURPS4e.containsAny({ "pi+" }, sDamageType) then
				nDamageMultiplier = 1 + 1/2;
			elseif StringManagerGURPS4e.containsAny({ "cut" }, sDamageType) then
				nDamageMultiplier = 1 + 1/2;
			elseif StringManagerGURPS4e.containsAny({ "pi" }, sDamageType) then
				nDamageMultiplier = 1;
			elseif StringManagerGURPS4e.containsAny({ "pi-" }, sDamageType) then
				nDamageMultiplier = 1/2;
			else
				nDamageMultiplier = 1;
			end	
		else
			if StringManagerGURPS4e.containsAny({ "imp" }, sDamageType) then
				nDamageMultiplier = 2;
				nMaxDamage = 1;
			elseif StringManagerGURPS4e.containsAny({ "pi++" }, sDamageType) then
				nDamageMultiplier = 2;
				nMaxDamage = 1;
			elseif StringManagerGURPS4e.containsAny({ "pi+" }, sDamageType) then
				nDamageMultiplier = 1 + 1/2;
				nMaxDamage = 1;
			elseif StringManagerGURPS4e.containsAny({ "cut" }, sDamageType) then
				nDamageMultiplier = 1 + 1/2;
				nMaxDamage = 2;
			elseif StringManagerGURPS4e.containsAny({ "pi" }, sDamageType) then
				nDamageMultiplier = 1;
				nMaxDamage = 1;
			elseif StringManagerGURPS4e.containsAny({ "pi-" }, sDamageType) then
				nDamageMultiplier = 1/2;
				nMaxDamage = 1;
			else
				nDamageMultiplier = 1;
				nMaxDamage = 2;
			end	
		end

	end

	nDR = math.floor((nDR + nDRModifier) / nDivisor);

	local nInjury = nDamage - nDR;
	if nInjury < 0 then
		nInjury = 0;
	end

	nInjury = math.floor(nInjury * nDamageMultiplier)

	if nMaxDamage ~= 0 and nInjury > nMaxDamage then
		nInjury = nMaxDamage;
	end

	if nInjury > 0 and StringManagerGURPS4e.containsAny({ "inc" }, sDamageType) then
		nInjury = nInjury + 1;
	end

	DB.setValue(node, "injury", "number", nInjury);
end

function applyDamage()
	local rActor = ActorManager.resolveActor(DB.getChild(getDatabaseNode(), "..."));
	ActionDamage.applyInjury(rActor, injury.getValue(), 0);

	removeEntry()
end

function removeEntry()
	DB.deleteNode(getDatabaseNode())
end
