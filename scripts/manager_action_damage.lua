-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

OOB_MSGTYPE_APPLYDMG = "applydmg";

function onInit()
	OOBManager.registerOOBMsgHandler(OOB_MSGTYPE_APPLYDMG, handleApplyDamage);

	ActionsManager.registerResultHandler("damage", onDamage);
end

function handleApplyDamage(msgOOB)
	local rSource = ActorManager.getActor(msgOOB.sSourceType, msgOOB.sSourceNode);
	local rTarget = ActorManager.getActor(msgOOB.sTargetType, msgOOB.sTargetNode);
	if rTarget then
		rTarget.nOrder = msgOOB.nTargetOrder;
	end
	
	local nTotal = tonumber(msgOOB.nTotal) or 0;
	applyDamage(rSource, rTarget, (tonumber(msgOOB.nSecret) == 1), msgOOB.sRollType, msgOOB.sDamage, nTotal);
end

function notifyApplyDamage(rSource, rTarget, bSecret, sRollType, sDesc, nTotal)
	if not rTarget then
		return;
	end
	local sTargetType, sTargetNode = ActorManager.getTypeAndNodeName(rTarget);
	if sTargetType ~= "pc" and sTargetType ~= "ct" then
		return;
	end

	local msgOOB = {};
	msgOOB.type = OOB_MSGTYPE_APPLYDMG;
	
	if bSecret then
		msgOOB.nSecret = 1;
	else
		msgOOB.nSecret = 0;
	end
	msgOOB.sRollType = sRollType;
	msgOOB.nTotal = nTotal;
	msgOOB.sDamage = sDesc;
	msgOOB.sTargetType = sTargetType;
	msgOOB.sTargetNode = sTargetNode;
	msgOOB.nTargetOrder = rTarget.nOrder;

	local sSourceType, sSourceNode = ActorManager.getTypeAndNodeName(rSource);
	msgOOB.sSourceType = sSourceType;
	msgOOB.sSourceNode = sSourceNode;

	Comm.deliverOOBMessage(msgOOB, "");
end

function onDamage(rSource, rTarget, rRoll)
	local rMessage = ActionsManager.createActionMessage(rSource, rRoll);
	Comm.deliverChatMessage(rMessage);

	-- Apply damage to the PC or CT entry referenced
	local nTotal = ActionsManager.total(rRoll);
	notifyApplyDamage(rSource, rTarget, rMessage.secret, rRoll.sType, rMessage.text, nTotal);
end

function applyDamage(rSource, rTarget, bSecret, sRollType, sDamage, nTotal)
	local sTargetType, nodeTarget = ActorManager.getTypeAndNode(rTarget);
	if sTargetType ~= "pc" and sTargetType ~= "ct" then
		return;
	end
	
	-- Get damage type
	local sDamageType = string.match(sDamage, "%[TYPE: (%w+)%]") or "";
	if sDamageType ~= "intellect" and sDamageType ~= "speed" then
		sDamageType = "might";
	end
	
	-- Apply damage, and generate notifications
	local nPCWounds = nil;
	local aNotifications = {};
	if sTargetType == "pc" then
		local nIntellectHP = DB.getValue(nodeTarget, "abilities.intellect.current", 0);
		local nSpeedHP = DB.getValue(nodeTarget, "abilities.speed.current", 0);
		local nMightHP = DB.getValue(nodeTarget, "abilities.might.current", 0);
		local nWounds = DB.getValue(nodeTarget, "wounds", 0);
		
		-- Apply Armor
		if nTotal > 0 and sDamageType == "might" then
			local nArmor = DB.getValue(nodeTarget, "armor", 0);
			if nArmor > 0 then
				nTotal = math.max(nTotal - nArmor, 0);
				table.insert(aNotifications, "[ARMOR -" .. nArmor .. "]");
			end
		end
		
		local nOrigIntellectHP = nIntellectHP;
		local nOrigSpeedHP = nSpeedHP;
		local nOrigMightHP = nMightHP;

		-- Damage
		if nTotal > 0 then
			local nDamage = nTotal;
		
			if sDamageType == "intellect" then
				if nIntellectHP > 0 then
					nIntellectHP = nIntellectHP - nDamage;
					if nIntellectHP < 0 then
						nDamage = -nIntellectHP;
						nIntellectHP = 0;
					else
						nDamage = 0;
					end
				end
			elseif sDamageType == "speed" then
				if nSpeedHP > 0 then
					nSpeedHP = nSpeedHP - nDamage;
					if nSpeedHP < 0 then
						nDamage = -nSpeedHP;
						nSpeedHP = 0;
					else
						nDamage = 0;
					end
				end
			end
			
			if nMightHP > 0 then
				nMightHP = nMightHP - nDamage;
				if nMightHP < 0 then
					nDamage = -nMightHP;
					nMightHP = 0;
				else
					nDamage = 0;
				end
			end
			if nSpeedHP > 0 then
				nSpeedHP = nSpeedHP - nDamage;
				if nSpeedHP < 0 then
					nDamage = -nSpeedHP;
					nSpeedHP = 0;
				else
					nDamage = 0;
				end
			end
			if nIntellectHP > 0 then
				nIntellectHP = nIntellectHP - nDamage;
				if nIntellectHP < 0 then
					nDamage = -nIntellectHP;
					nIntellectHP = 0;
				else
					nDamage = 0;
				end
			end
			
			local nNewWounds = 0;
			if nOrigIntellectHP > 0 and nIntellectHP <= 0 then
				nNewWounds = nNewWounds + 1;
			end
			if nOrigSpeedHP > 0 and nSpeedHP <= 0 then
				nNewWounds = nNewWounds + 1;
			end
			if nOrigMightHP > 0 and nMightHP <= 0 then
				nNewWounds = nNewWounds + 1;
			end
			if nNewWounds > 0 then
				if nWounds < 3 then
					local nOrigWounds = nWounds;
					nWounds = math.min(nWounds + nNewWounds, 3);
					nPCWounds = nOrigWounds - nWounds;
					if nWounds == 1 then
						table.insert(aNotifications, "[IMPAIRED]");
					elseif nWounds == 2 then
						table.insert(aNotifications, "[DEBILITATED]");
					else
						table.insert(aNotifications, "[DEAD]");
					end
				else
					table.insert(aNotifications, "[DEAD]");
				end
			end
		
		-- Healing?
		elseif nTotal < 0 then
			if sDamageType == "intellect" then
				local nIntellectMax = DB.getValue(nodeTarget, "abilities.intellect.max", 0);
				if nIntellectHP < nIntellectMax then
					nIntellectHP = math.min(nIntellectHP - nTotal, nIntellectMax);
				end
			elseif sDamageType == "speed" then
				local nSpeedMax = DB.getValue(nodeTarget, "abilities.speed.max", 0);
				if nSpeedHP < nSpeedMax then
					nSpeedHP = math.min(nSpeedHP - nTotal, nSpeedMax);
				end
			else
				local nMightMax = DB.getValue(nodeTarget, "abilities.might.max", 0);
				if nMightHP < nMightMax then
					nMightHP = math.min(nMightHP - nTotal, nMightMax);
				end
			end
			
			local nNewHealing = 0;
			if nOrigIntellectHP <= 0 and nIntellectHP > 0 then
				nNewHealing = nNewHealing + 1;
			end
			if nOrigSpeedHP <= 0 and nSpeedHP > 0 then
				nNewHealing = nNewHealing + 1;
			end
			if nOrigMightHP <= 0 and nMightHP > 0 then
				nNewHealing = nNewHealing + 1;
			end
			if nNewHealing > 0 then
				if nWounds > 0 then
					local nOrigWounds = nWounds;
					nWounds = math.max(nWounds - nNewHealing, 0);
					nPCWounds = nOrigWounds - nWounds;
					if nWounds <= 0 then
						table.insert(aNotifications, "[HALE]");
					elseif nWounds == 1 then
						table.insert(aNotifications, "[IMPAIRED]");
					elseif nWounds == 2 then
						table.insert(aNotifications, "[DEBILITATED]");
					else
						table.insert(aNotifications, "[DEAD]");
					end
				else
					table.insert(aNotifications, "[HALE]");
				end
			end
		end
		
		DB.setValue(nodeTarget, "abilities.intellect.current", "number", nIntellectHP);
		DB.setValue(nodeTarget, "abilities.speed.current", "number", nSpeedHP);
		DB.setValue(nodeTarget, "abilities.might.current", "number", nMightHP);
		DB.setValue(nodeTarget, "wounds", "number", nWounds);
		
	else
		local nWounds = DB.getValue(nodeTarget, "wounds", 0);
		
		if nTotal > 0 and sDamageType == "might" then
			local nArmor = DB.getValue(nodeTarget, "armor", 0);
			if nArmor > 0 then
				nTotal = math.max(nTotal - nArmor, 0);
				table.insert(aNotifications, "[ARMOR -" .. nArmor .. "]");
			end
		end

		local nOriginalWounds = nWounds;
		nWounds = math.max(nWounds + nTotal, 0);

		if nTotal > 0 then
			local nHP = DB.getValue(nodeTarget, "hp", 0);
			local nBloodied = nHP / 2;
			if (nOriginalWounds < nHP) and (nWounds >= nHP) then
				table.insert(aNotifications, "[DEAD]");
			elseif (nOriginalWounds < nBloodied) and (nWounds >= nBloodied) then
				table.insert(aNotifications, "[HEAVY]");
			end
		end
		
		DB.setValue(nodeTarget, "wounds", "number", nWounds);
	end
	
	-- Output
	if not (rTarget or sExtraResult ~= "") then
		return;
	end
	
	local msgShort = {font = "msgfont"};
	local msgLong = {font = "msgfont"};

	if nTotal < 0 then
		msgShort.icon = "roll_heal";
		msgLong.icon = "roll_heal";
	else
		msgShort.icon = "roll_damage";
		msgLong.icon = "roll_damage";
	end

	msgLong.text = "[" .. nTotal;
	if nPCWounds then
		msgLong.text = msgLong.text .. string.format(" (%+d)", nPCWounds);
	end
	msgLong.text = msgLong.text .. "] ->";
	if rTarget then
		msgLong.text = msgLong.text .. " [to " .. rTarget.sName .. "]";
	end
	msgShort.text = msgLong.text;
	
	if #aNotifications > 0 then
		msgLong.text = msgLong.text .. " " .. table.concat(aNotifications, " ");
	end
	
	ActionsManager.messageResult(bSecret, rSource, rTarget, msgLong, msgShort);
end
