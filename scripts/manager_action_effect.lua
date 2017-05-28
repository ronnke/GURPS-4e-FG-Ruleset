-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

--	
--	DATA STRUCTURES
--
-- rEffect
--    sName = ""
--    nDuration = #
--    sUnits = ""
--    nGMOnly = 0, 1

function onInit()
	Interface.onHotkeyDrop = onHotkeyDrop;

	ActionsManager.registerResultHandler("effect", onEffect);
end

function onHotkeyDrop(draginfo)
	local rEffect = decodeEffectFromDrag(draginfo);
	if rEffect then
		draginfo.setSlot(1);
		draginfo.setStringData(encodeEffectAsText(rEffect));
	end
end

function getRoll(draginfo, rActor, rAction)
	local rRoll = encodeEffect(rAction);
	if rRoll.sDesc == "" then
		return nil;
	end

	return rRoll;
end

function performRoll(draginfo, rActor, rAction)
	local rRoll = getRoll(draginfo, rActor, rAction);
	if not rRoll then
		return false;
	end
	
	ActionsManager.performAction(draginfo, rActor, rRoll);
	return true;
end

function onEffect(rSource, rTarget, rRoll)
	-- If no target, then report to chat window and exit
	if not rTarget then
		-- Report effect to chat window
		local rMessage = ActionsManager.createActionMessage(nil, rRoll);
		rMessage.icon = "roll_effect";
		Comm.deliverChatMessage(rMessage);
		
		return;
	end

	-- If target not in combat tracker, then we're done
	local sTargetCT = ActorManager.getCTNodeName(rTarget);
	if sTargetCT == "" then
		ChatManager.SystemMessage(Interface.getString("ct_error_effectdroptargetnotinct"));
		return;
	end

	-- Decode effect from roll
	local rEffect = decodeEffect(rRoll);
	if not rEffect then
		ChatManager.SystemMessage(Interface.getString("ct_error_effectdecodefail"));
		return;
	end
	
	-- If source is non-friendly faction and target does not exist or is non-friendly, then effect should be GM only
	if (rSource and ActorManager.getFaction(rSource) ~= "friend") and (not rTarget or ActorManager.getFaction(rTarget) ~= "friend") then
		rEffect.nGMOnly = 1;
	end

  -- If shift-dragging, then apply to the source actor targets
  if Input.isShiftPressed() then
    local aTargetNodes = {};
    local aTargets;
    aTargets = TargetingManager.getFullTargets(rTarget);
    for _,v in ipairs(aTargets) do
      local sCTNode = ActorManager.getCTNodeName(v);
      if sCTNode ~= "" then
        table.insert(aTargetNodes, sCTNode);
      end
    end
    -- Apply effect to all targets
      EffectManager.notifyApply(rEffect, aTargetNodes);
  
  -- Apply to the source actor targets
  elseif rRoll.aTargets then
    local aTargets = StringManager.split(rRoll.aTargets, "|");
    -- Apply effect to all targets
    EffectManager.notifyApply(rEffect, aTargets);
  
  -- Otherwise, just apply effect to target normally
  else
    EffectManager.notifyApply(rEffect, sTargetCT);
  end
end

--
-- UTILITY FUNCTIONS
--

function decodeEffectFromDrag(draginfo)
	local sDragType = draginfo.getType();
	local sDragDesc = "";

	local bEffectDrag = false;
	if sDragType == "effect" then
		bEffectDrag = true;
		sDragDesc = draginfo.getStringData();
	elseif sDragType == "number" then
		if string.match(sDragDesc, "%[EFFECT") then
			bEffectDrag = true;
			sDragDesc = draginfo.getDescription();
		end
	end
	
	local rEffect = nil;
	if bEffectDrag then
		rEffect = decodeEffectFromText(sDragDesc, draginfo.getSecret());
    if rEffect then
      rEffect.nDuration = draginfo.getNumberData();
    end
	end
	
	return rEffect;
end

function encodeEffect(rAction)
	local rRoll = {};
	rRoll.sType = "effect";
	rRoll.sDesc = encodeEffectAsText(rAction);
  rRoll.aDice = rAction.aDice or {};
  rRoll.nMod = rAction.nDuration or 0;
	if rAction.nGMOnly then
		rRoll.bSecret = (rAction.nGMOnly ~= 0);
	end
	
	return rRoll;
end

function decodeEffect(rRoll)
	local rEffect = decodeEffectFromText(rRoll.sDesc, rRoll.bSecret);
  if rEffect then
    rEffect.nDuration = ActionsManager.total(rRoll);
  end
  
	return rEffect;
end

function encodeEffectAsText(rEffect)
	local aMessage = {};
	
	if rEffect then
		table.insert(aMessage, "[EFFECT] " .. rEffect.sName);
		
    if rEffect.sUnits and rEffect.sUnits ~= "" then
      local sOutputUnits = nil;
      if rEffect.sUnits == "sec" then
        sOutputUnits = "SEC";
      elseif rEffect.sUnits == "min" then
        sOutputUnits = "MIN";
      elseif rEffect.sUnits == "hr" then
        sOutputUnits = "HR";
      elseif rEffect.sUnits == "day" then
        sOutputUnits = "DAY";
      end
  
      if sOutputUnits then
        table.insert(aMessage, "[UNITS " .. sOutputUnits .. "]");
      end
    end
		
	end
	
	return table.concat(aMessage, " ");
end

function decodeEffectFromText(sEffect, bSecret)
	local rEffect = nil;

	local sEffectName = sEffect:gsub("^%[EFFECT%] ", "");
  sEffectName = sEffectName:gsub("%[UNITS ([^]]+)]", "");
	sEffectName = StringManager.trim(sEffectName);
	
	if sEffectName ~= "" then
		rEffect = {};
		
		if bSecret then
			rEffect.nGMOnly = 1;
		else
			rEffect.nGMOnly = 0;
		end

		rEffect.sName = sEffectName;
		
    rEffect.sUnits = "";
    local sUnits = sEffect:match("%[UNITS ([^]]+)]");
    if sUnits then
      if sUnits == "SEC" then
        rEffect.sUnits = "sec";
      elseif sUnits == "MIN" then
        rEffect.sUnits = "min";
      elseif sUnits == "HR" then
        rEffect.sUnits = "hr";
      elseif sUnits == "DAY" then
        rEffect.sUnits = "day";
      end
    end
		
	end
	
	return rEffect;
end
