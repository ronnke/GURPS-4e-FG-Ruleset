-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

OOB_MSGTYPE_APPLYEFF = "applyeff";
OOB_MSGTYPE_EXPIREEFF = "expireeff";

local nLocked = 0;

function onInit()
	OOBManager.registerOOBMsgHandler(OOB_MSGTYPE_APPLYEFF, handleApplyEffect);
  OOBManager.registerOOBMsgHandler(OOB_MSGTYPE_EXPIREEFF, handleExpireEffect);
  
  CombatManager.setCustomTurnStart(processSOTEffects);
  CombatManager.setCustomTurnEnd(processEOTEffects);
end

function handleApplyEffect(msgOOB)
	-- Get the combat tracker node
	local nodeCTEntry = DB.findNode(msgOOB.sTargetNode);
	if not nodeCTEntry then
		ChatManager.SystemMessage(Interface.getString("ct_error_effectapplyfail") .. " (" .. msgOOB.sTargetNode .. ")");
		return;
	end
	
	-- Reconstitute the effect details
	local rEffect = {};
	rEffect.sName = msgOOB.sName;
  rEffect.nDuration = tonumber(msgOOB.nDuration) or 0;
  rEffect.sUnits = msgOOB.sUnits;
	rEffect.nGMOnly = tonumber(msgOOB.nGMOnly) or 0;
	
	-- Apply the damage
	addEffect(msgOOB.user, msgOOB.identity, nodeCTEntry, rEffect, true);
end

function handleExpireEffect(msgOOB)
  -- Get the effect and combat tracker node
  local nodeEffect = DB.findNode(msgOOB.sEffectNode);
  if not nodeEffect then
    ChatManager.SystemMessage(Interface.getString("ct_error_effectdeletefail") .. " (" .. msgOOB.sEffectNode .. ")");
    return;
  end
  local nodeActor = nodeEffect.getChild("...");
  if not nodeActor then
    ChatManager.SystemMessage(Interface.getString("ct_error_effectmissingactor") .. " (" .. msgOOB.sEffectNode .. ")");
    return;
  end
  
  -- Get the parameters
  local nExpireType = tonumber(msgOOB.nExpireType) or 0;
  
  -- Apply the damage
  expireEffect(nodeActor, nodeEffect, nExpireType);
end

function notifyApply(rEffect, vTargets)
	-- Build OOB message to pass effect to host
	local msgOOB = {};
	msgOOB.type = OOB_MSGTYPE_APPLYEFF;
	if User.isHost() then
		msgOOB.user = "";
	else
		msgOOB.user = User.getUsername();
	end
	msgOOB.identity = User.getIdentityLabel();

	msgOOB.sName = rEffect.sName or "";
  msgOOB.nDuration = rEffect.nDuration or 0;
  msgOOB.sUnits = rEffect.sUnits or "";
	msgOOB.nGMOnly = rEffect.nGMOnly or 0; 

	-- Send one message for each target
	if type(vTargets) == "table" then
		for _, v in pairs(vTargets) do
			msgOOB.sTargetNode = v;
			Comm.deliverOOBMessage(msgOOB, "");
		end
	else
		msgOOB.sTargetNode = vTargets;
		Comm.deliverOOBMessage(msgOOB, "");
	end
end

function notifyExpire(varEffect, nMatch)
  if type(varEffect) == "databasenode" then
    varEffect = varEffect.getNodeName();
  elseif type(varEffect) ~= "string" then
    return;
  end
  
  local msgOOB = {};
  msgOOB.type = OOB_MSGTYPE_EXPIREEFF;
  msgOOB.sEffectNode = varEffect;
  msgOOB.nExpireType = nMatch;
  
  Comm.deliverOOBMessage(msgOOB, "");
end

function setEffect(nodeEffect, rEffect)
	DB.setValue(nodeEffect, "label", "string", rEffect.sName);
  DB.setValue(nodeEffect, "duration", "number", rEffect.nDuration);
  DB.setValue(nodeEffect, "units", "string", rEffect.sUnits);
  DB.setValue(nodeEffect, "isgmonly", "number", rEffect.nGMOnly);
end

function getEffect(nodeEffect)
	return { 
			sName = DB.getValue(nodeEffect, "label", ""),
      nDuration = DB.getValue(nodeEffect, "duration", 0),
      sUnits = DB.getValue(nodeEffect, "units", ""),
      nGMOnly = DB.getValue(nodeEffect, "isgmonly", 0),
	};
end

--
-- EFFECTS
--

function message(sMsg, nodeCTEntry, gmflag, sUser)
	-- ADD NAME OF CT ENTRY TO NOTIFICATION
	if nodeCTEntry then
		sMsg = sMsg .. " [on " .. DB.getValue(nodeCTEntry, "name", "") .. "]";
	end

	-- BUILD MESSAGE OBJECT
	local msg = {font = "msgfont", icon = "roll_effect", text = sMsg};
	
	-- DELIVER MESSAGE BASED ON TARGET AND GMFLAG
	if sUser then
		if sUser == "" then
			Comm.addChatMessage(msg);
		else
			Comm.deliverChatMessage(msg, sUser);
		end
	elseif gmflag then
		msg.secret = true;
		if User.isHost() then
			Comm.addChatMessage(msg);
		else
			Comm.deliverChatMessage(msg, User.getUsername());
		end
	else
		Comm.deliverChatMessage(msg);
	end
end

function getEffectsString(nodeCTEntry, bPublicOnly)
	-- Start with an empty effects list string
	local aOutputEffects = {};
	
	-- Iterate through each effect
	local aSorted = {};
	for _,nodeChild in pairs(DB.getChildren(nodeCTEntry, "effects")) do
		table.insert(aSorted, nodeChild);
	end
	table.sort(aSorted, function (a, b) return a.getName() < b.getName() end);
	for _,v in pairs(aSorted) do
		local sLabel = DB.getValue(v, "label", "");

		local bAddEffect = true;
		local bGMOnly = false;
		if sLabel == "" then
			bAddEffect = false;
		elseif DB.getValue(v, "isgmonly", 0) == 1 then
			if User.isHost() and not bPublicOnly then
				bGMOnly = true;
			else
				bAddEffect = false;
			end
		end

		if bAddEffect then
      local sOutputLabel = sLabel;
      local nDuration = DB.getValue(v, "duration", 0);
      local sUnits = DB.getValue(v, "units", "");

      if nDuration > 0 or sUnits == "sec+" then
        local sOutputUnits = nil;
        if sUnits == "sec+" then
          sOutputUnits = "SEC+";
        elseif sUnits == "sec" then
          sOutputUnits = "SEC";
        elseif sUnits == "min" then
          sOutputUnits = "MIN";
        elseif sUnits == "hr" then
          sOutputUnits = "HR";
        elseif sUnits == "day" then
          sOutputUnits = "DAY";
        end
        
        if sOutputUnits then
          sOutputLabel = sOutputLabel .. " [D:" .. nDuration .. " " .. sOutputUnits .. "] ";
        else
          sOutputLabel = sOutputLabel .. " [D:" .. nDuration .. "] ";
        end
      end
		
			if bGMOnly then
				sOutputLabel = "(" .. sOutputLabel .. ")";
			end

			table.insert(aOutputEffects, sOutputLabel);
		end
	end
	
	-- Return the final effect list string
	return table.concat(aOutputEffects, " | ");
end

function isGMEffect(nodeActor, nodeEffect)
	if nodeEffect and (DB.getValue(nodeEffect, "isgmonly", 0) == 1) then
		return true;
	end
	if nodeActor and CombatManager.isCTHidden(nodeActor) then
		return true;
	end
	return false;
end

function addEffect(sUser, sIdentity, nodeCT, rNewEffect, bShowMsg)
	-- VALIDATE
	if not nodeCT or not rNewEffect or not rNewEffect.sName then
		return;
	end
	
  rNewEffect.nDuration = rNewEffect.nDuration or 0;
  rNewEffect.sUnits = rNewEffect.sUnits or "";  
  if rNewEffect.sUnits == "min" then
    rNewEffect.sUnits = "sec";
    rNewEffect.nDuration = rNewEffect.nDuration * 60;
  end
	
	-- GET EFFECTS LIST
	local nodeEffectsList = nodeCT.createChild("effects");
	if not nodeEffectsList then
		return;
	end
	
	-- CHECKS TO IGNORE NEW EFFECT (DUPLICATE)
	for k, v in pairs(nodeEffectsList.getChildren()) do
		-- CHECK FOR DUPLICATE EFFECT
		if (DB.getValue(v, "label", "") == rNewEffect.sName) then
			local sMsg = "Effect ['" .. rNewEffect.sName .. "'] ";
			sMsg = sMsg .. "-> [ALREADY EXISTS]";
			message(sMsg, nodeCT, false, sUser);
			return;
		end
	end
	
	-- WRITE EFFECT RECORD
	local nodeTargetEffect = nodeEffectsList.createChild();
	DB.setValue(nodeTargetEffect, "label", "string", rNewEffect.sName);
  DB.setValue(nodeTargetEffect, "duration", "number", rNewEffect.nDuration);
  DB.setValue(nodeTargetEffect, "units", "string", rNewEffect.sUnits);
	DB.setValue(nodeTargetEffect, "isgmonly", "number", rNewEffect.nGMOnly);
  DB.setValue(nodeTargetEffect, "status", "number", 0);

	-- BUILD MESSAGE
	local msg = {font = "msgfont", icon = "roll_effect"};
	msg.text = "Effect ['" .. rNewEffect.sName .. "'] ";
  if rNewEffect.nDuration > 0 or rNewEffect.sUnits == "sec+" then

    if rNewEffect.sUnits and rNewEffect.sUnits ~= "" then
      local sOutputUnits = nil;
      if rNewEffect.sUnits == "sec+" then
        sOutputUnits = "SEC+";
      elseif rNewEffect.sUnits == "sec" then
        sOutputUnits = "SEC";
      elseif rNewEffect.sUnits == "min" then
        sOutputUnits = "MIN";
      elseif rNewEffect.sUnits == "hr" then
        sOutputUnits = "HR";
      elseif rNewEffect.sUnits == "day" then
        sOutputUnits = "DAY";
      end
      
      if sOutputUnits then
        msg.text = msg.text .. " [D:" .. rNewEffect.nDuration .. " " .. sOutputUnits .. "] ";
      else
        msg.text = msg.text .. " [D:" .. rNewEffect.nDuration .. "] ";
      end
    end

  end
	msg.text = msg.text .. "-> [to " .. DB.getValue(nodeCT, "name", "") .. "]";
	
	-- SEND MESSAGE
	if bShowMsg then
		if isGMEffect(nodeCT, nodeTargetEffect) then
			if sUser == "" then
				msg.secret = true;
				Comm.addChatMessage(msg);
			elseif sUser ~= "" then
				Comm.addChatMessage(msg);
				Comm.deliverChatMessage(msg, sUser);
			end
		else
			Comm.deliverChatMessage(msg);
		end
	end
end

function processSOTEffects(nodeActor)
  -- Check each effect
  for _,nodeEffect in pairs(DB.getChildren(nodeActor, "effects")) do
    -- Check status 0 = new effect
    local nDuration = DB.getValue(nodeEffect, "duration", 0);
    local sUnits = DB.getValue(nodeEffect, "units", "");
    local nStatus = DB.getValue(nodeEffect, "status", 0);

    if (nDuration <= 0) and (sUnits ~= "") and (sUnits ~= "sec+") then
        expireEffect(nodeActor, nodeEffect, 0);
    end

    if (nStatus == 0) then
      DB.setValue(nodeEffect, "status", "number", 1);
    end
    
  end
end

function processEOTEffects(nodeActor)
  -- Check each effect
  for _,nodeEffect in pairs(DB.getChildren(nodeActor, "effects")) do
    
    local nDuration = DB.getValue(nodeEffect, "duration", 0);
    local sUnits = DB.getValue(nodeEffect, "units", "");
    local nStatus = DB.getValue(nodeEffect, "status", 0);
    
    -- Skip if new effect
    if (nStatus ~= 0) then
      if (nDuration > 0) or (sUnits == "sec+") then
        -- Convert minutes to seconds
        if sUnits == "min" then
          sUnits = "sec";
          nDuration = nDuration * 60;
          DB.setValue(nodeEffect, "units", "string", sUnits);
        end
      
        -- Decrement effect and check for expiration
        if (sUnits == "") or (sUnits == "sec") then
          nDuration = nDuration - 1;
          if (nDuration <= 0) then
            expireEffect(nodeActor, nodeEffect, 0);
          else
            DB.setValue(nodeEffect, "duration", "number", nDuration);
          end
        end

        -- Increment effect
        if (sUnits == "sec+") then
          nDuration = nDuration + 1;
          DB.setValue(nodeEffect, "duration", "number", nDuration);
        end
      elseif (sUnits ~= "") then
          expireEffect(nodeActor, nodeEffect, 0);
      end
    end
  end
end

function expireEffect(nodeActor, nodeEffect, nExpireComponent)
  -- VALIDATE
  if not nodeEffect then
    return false;
  end

  -- PARSE THE EFFECT
  local sEffect = DB.getValue(nodeEffect, "label", "");

  -- DETERMINE MESSAGE VISIBILITY
  local bGMOnly = isGMEffect(nodeActor, nodeEffect);

  -- DELETE THE EFFECT
  sMsg = "Effect ['" .. sEffect .. "'] -> [EXPIRES]";
  nodeEffect.delete();

  -- SEND NOTIFICATION TO THE HOST
  message(sMsg, nodeActor, bGMOnly);
  return true;
end

--
--  HANDLE EFFECT LOCKING
--

function lock()
	nLocked = nLocked + 1;
end

function unlock()
	nLocked = nLocked - 1;
	if nLocked < 0 then
		nLocked = 0;
	end

	if nLocked == 0 then
	end
end
