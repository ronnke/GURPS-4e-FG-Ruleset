-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
  EffectManager.registerEffectVar("nStatus", { sDBType = "number", sDBField = "status", bSkipAdd = false });
  EffectManager.registerEffectVar("sUnits", { sDBType = "string", sDBField = "units", bSkipAdd = false });
  
  EffectManager.setCustomOnEffectAddStart(onEffectAddStart);

  EffectManager.setCustomOnEffectStartTurn(onEffectStartTurn);
  EffectManager.setCustomOnEffectEndTurn(onEffectEndTurn);

  EffectManager.setCustomOnEffectActorStartTurn(onEffectActorStartTurn);
  EffectManager.setCustomOnEffectActorEndTurn(onEffectActorEndTurn);
  
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
  return true;
end

function onEffectActorStartTurn(nodeActor, nodeEffect)
    DB.setValue(nodeEffect, "status", "number", 1);
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
