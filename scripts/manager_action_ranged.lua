-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
  ActionsManager.registerResultHandler("ranged", onRanged);
end

function onRanged(rSource, rTarget, rRoll)
  local rMessage = ActionsManager2.createActionMessage(rSource, rRoll);
  
  local nTotal = ActionsManager2.total(rRoll);
  local aAddIcons = {};

  local nTarget = rRoll.nTarget + rRoll.nMod;

  local sSummary = rRoll.sTargetDesc .. " (" .. nTarget ..")";
  if rRoll.nMod > 0 then
    sSummary = rRoll.sTargetDesc .. " " .. rRoll.nTarget ..  "+" .. math.abs(rRoll.nMod) .. "=(" .. nTarget .. ")";
  elseif rRoll.nMod < 0 then
    sSummary = rRoll.sTargetDesc .. " " .. rRoll.nTarget ..  "-" .. math.abs(rRoll.nMod) .. "=(" .. nTarget .. ")";
  end
  
  local sResult = "";
  if nTotal <= nTarget then
    if ((nTarget - nTotal) >= 10 and nTotal <= 6) or nTotal <= 4 then
      sResult = "[ Critical Hit! ] by " .. math.abs(nTarget - nTotal);
    else
      sResult = "[ Hit! ] by " .. math.abs(nTarget - nTotal);
    end
  else
    if ((nTotal - nTarget) >= 10 and nTarget <= 15) or nTotal == 18 then
      sResult = "[ Critical Miss! ] by " .. math.abs(nTarget - nTotal);
    else
      sResult = "[ Miss! ] by " .. math.abs(nTarget - nTotal);
    end
  end
  
  rMessage.text = rMessage.text .. "\n" .. sSummary .. ":" .. sResult;
  
  if #aAddIcons > 0 then
    rMessage.icon = { rMessage.icon };
    for _,v in ipairs(aAddIcons) do
      table.insert(rMessage.icon, v);
    end
  end
  
  Comm.deliverChatMessage(rMessage);
end
