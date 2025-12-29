-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
  EffectManager.registerEffectVar("nStatus", { sDBType = "number", sDBField = "status", bSkipAdd = false });
  EffectManager.registerEffectVar("sUnits", { sDBType = "string", sDBField = "units", bSkipAdd = false });
  
  EffectManager.setCustomOnEffectAddStart(onEffectAddStart);

  EffectManager.setCustomOnEffectStartTurn(onEffectStartTurn);
  EffectManager.setCustomOnEffectActorStartTurn(onEffectActorStartTurn);

  EffectManager.setCustomOnEffectActorEndTurn(onEffectActorEndTurn);
  EffectManager.setCustomOnEffectEndTurn(onEffectEndTurn);
  
  EffectManager.setCustomOnEffectTextEncode(onEffectTextEncode);
  EffectManager.setCustomOnEffectTextDecode(onEffectTextDecode);
end

function onEffectAddStart(rEffect)
  rEffect.nStatus = 0;    
  rEffect.nDuration = rEffect.nDuration or 1;
  if rEffect.sUnits == "min" then
    rEffect.nDuration = rEffect.nDuration * 60;
    rEffect.sUnits = "sec";
  elseif rEffect.sUnits == "sec+" then        
    rEffect.nStatus = 1;    
  end
end

function onEffectStartTurn(nodeEffect)
  return true;
end
function onEffectEndTurn(nodeEffect)
  return false;
end

function onEffectActorStartTurn(nodeActor, nodeEffect)
  DB.setValue(nodeEffect, "status", "number", 1);
  return false;
end

function onEffectActorEndTurn(nodeActor, nodeEffect)
  local nDuration = DB.getValue(nodeEffect, "duration", 0);
  local sUnits = DB.getValue(nodeEffect, "units", "");
  local nStatus = DB.getValue(nodeEffect, "status", 0);

  -- Convert minutes to seconds
  if sUnits == "min" then
    sUnits = "sec";
    nDuration = nDuration * 60;
    DB.setValue(nodeEffect, "units", "string", sUnits);
  end

  if sUnits == "sec+" then
    nDuration = nDuration + 1;
  elseif sUnits == "sec" and nStatus == 1 then
    nDuration = nDuration - 1;
  end

  if nDuration <= 0 and sUnits ~= "" and sUnits ~= "sec+" then
    EffectManager.expireEffect(nodeActor, nodeEffect, 0);
  else
    DB.setValue(nodeEffect, "status", "number", 1);
    DB.setValue(nodeEffect, "duration", "number", nDuration);
  end
  return false;
end

function onEffectTextEncode(rEffect)
  local aMessage = {};
  
  if rEffect.sUnits and rEffect.sUnits ~= "" then
    local sOutputUnits = nil;
    if rEffect.sUnits == "sec+" then
      sOutputUnits = "SEC+";
    elseif rEffect.sUnits == "sec" then
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
  
  return table.concat(aMessage, " ");
end

function onEffectTextDecode(sEffect, rEffect)
  local s = sEffect;
  
  local sUnits = s:match("%[UNITS ([^]]+)]");
  if sUnits then
    s = s:gsub("%[UNITS ([^]]+)]", "");
    if sUnits == "SEC+" then
      rEffect.sUnits = "sec+";
    elseif sUnits == "SEC" then
      rEffect.sUnits = "sec";
    elseif sUnits == "MIN" then
      rEffect.sUnits = "min";
    elseif sUnits == "HR" then
      rEffect.sUnits = "hr";
    elseif sUnits == "DAY" then
      rEffect.sUnits = "day";
    end
  end
  
  return s;
end

function parseEffectComp(s)
	local sType = nil;
	local aDice = {};
	local nMod = 0;
	local aRemainder = {};
	local nRemainderIndex = 1;

	local aWords, aWordStats = StringManager.parseWords(s, "/\\%.%[%]%(%):{}");
	if #aWords > 0 then
		sType = aWords[1]:match("^([^:]+):");
		if sType then
			nRemainderIndex = 2;

			local sValueCheck = aWords[1]:sub(#sType + 2);
			if sValueCheck ~= "" then
				table.insert(aWords, 2, sValueCheck);
				table.insert(aWordStats, 2, { startpos = aWordStats[1].startpos + #sType + 1, endpos = aWordStats[1].endpos });
				aWords[1] = aWords[1]:sub(1, #sType + 1);
				aWordStats[1].endpos = #sType + 1;
			end

			if #aWords > 1 then
				if StringManager.isDiceString(aWords[2]) then
					aDice, nMod = StringManager.convertStringToDice(aWords[2]);
					nRemainderIndex = 3;
				end
			end
		end

		if nRemainderIndex <= #aWords then
			while nRemainderIndex <= #aWords and aWords[nRemainderIndex]:match("^%[[%+%-]?%w+%]$") do
				table.insert(aRemainder, aWords[nRemainderIndex]);
				nRemainderIndex = nRemainderIndex + 1;
			end
		end

		if nRemainderIndex <= #aWords then
			local sRemainder = s:sub(aWordStats[nRemainderIndex].startpos);
			local nStartRemainderPhrase = 1;
			local i = 1;
			while i < #sRemainder do
				local sCheck = sRemainder:sub(i, i);
				if sCheck == "," then
					local sRemainderPhrase = sRemainder:sub(nStartRemainderPhrase, i - 1);
					if sRemainderPhrase and sRemainderPhrase ~= "" then
						sRemainderPhrase = StringManager.trim(sRemainderPhrase);
						table.insert(aRemainder, sRemainderPhrase);
					end
					nStartRemainderPhrase = i + 1;
				elseif sCheck == "(" then
					while i < #sRemainder do
						if sRemainder:sub(i, i) == ")" then
							break;
						end
						i = i + 1;
					end
				elseif sCheck == "[" then
					while i < #sRemainder do
						if sRemainder:sub(i, i) == "]" then
							break;
						end
						i = i + 1;
					end
				end
				i = i + 1;
			end
			local sRemainderPhrase = sRemainder:sub(nStartRemainderPhrase, #sRemainder);
			if sRemainderPhrase and sRemainderPhrase ~= "" then
				sRemainderPhrase = StringManager.trim(sRemainderPhrase);
				table.insert(aRemainder, sRemainderPhrase);
			end
		end
	end

	return {
		type = sType or "",
		mod = nMod,
		dice = aDice,
		remainder = aRemainder,
		original = StringManager.trim(s),
	};
end

function checkConditional(rActor, nodeEffect, aConditions, rTarget, aIgnore)
	local bReturn = true;

	if not aIgnore then
		aIgnore = {};
	end
	table.insert(aIgnore, DB.getPath(nodeEffect));

	for _,v in ipairs(aConditions) do
		local sLower = v:lower();
		if StringManager.contains(DataCommon.conditions, sLower) then
			if not EffectManagerGURPS4e.checkConditionalHelper(rActor, sLower, rTarget, aIgnore) then
				bReturn = false;
				break;
			end
		elseif StringManager.contains(DataCommon.conditionaltags, sLower) then
			if not EffectManagerGURPS4e.checkConditionalHelper(rActor, sLower, rTarget, aIgnore) then
				bReturn = false;
				break;
			end
		else
		end
	end

	table.remove(aIgnore);

	return bReturn;
end

function checkConditionalHelper(rActor, sEffect, rTarget, aIgnore)
	if not rActor then
		return false;
	end

	for _,v in ipairs(DB.getChildList(ActorManager.getCTNode(rActor), "effects")) do
		local nActive = DB.getValue(v, "isactive", 0);
		if nActive ~= 0 and not StringManager.contains(aIgnore, DB.getPath(v)) then
			-- Parse each effect label
			local sLabel = DB.getValue(v, "label", "");
			local aEffectComps = EffectManager.parseEffect(sLabel);

			-- Iterate through each effect component looking for a type match
			for _,sEffectComp in ipairs(aEffectComps) do
				local rEffectComp = EffectManagerGURPS4e.parseEffectComp(sEffectComp);

				-- CHECK CONDITIONALS
				if rEffectComp.type == "IF" then
					if not EffectManagerGURPS4e.checkConditional(rActor, v, rEffectComp.remainder, nil, aIgnore) then
						break;
					end
				elseif rEffectComp.type == "IFT" then
					if not rTarget then
						break;
					end
					if not EffectManagerGURPS4e.checkConditional(rTarget, v, rEffectComp.remainder, rActor, aIgnore) then
						break;
					end

				-- CHECK FOR AN ACTUAL EFFECT MATCH
				elseif rEffectComp.original:lower() == sEffect then
					if EffectManager.isTargetedEffect(v) then
						if EffectManager.isEffectTarget(v, rTarget) then
							return true;
						end
					else
						return true;
					end
				end
			end
		end
	end

	return false;
end