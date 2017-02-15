-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

-- Ruleset action types
actions = {
  ["dice"] = { sIcon = "action_roll", bUseModStack = true, bAddMod = true },
  ["table"] = { },
  ["effect"] = { sIcon = "action_effect", sTargeting = "all" },
  ["ability"] = { sIcon = "action_roll", bUseModStack = true, bAddMod = false },
  ["melee"] = { sIcon = "action_melee", bUseModStack = true, bAddMod = false, sTargeting = "each" },
  ["ranged"] = { sIcon = "action_ranged", bUseModStack = true, bAddMod = false, sTargeting = "each" },
  ["dodge"] = { sIcon = "action_defense", bUseModStack = true, bAddMod = false },
  ["parry"] = { sIcon = "action_defense", bUseModStack = true, bAddMod = false },
  ["block"] = { sIcon = "action_defense", bUseModStack = true, bAddMod = false },
  ["damage"] = { sIcon = "action_damage", bUseModStack = true, bAddMod = true, sTargeting = "each"},
  ["reaction"] = { sIcon = "action_roll", bUseModStack = true, bAddMod = true },
};

targetactions = {
  "effect",
  "ability",
  "melee",
  "ranged",
  "damage",
  "dodge",
  "parry",
  "block",
  "reaction",
};

currencies = { "$" };
currencyDefault = "$";

function getCharSelectDetailHost(nodeChar)
  return "Points: " .. DB.getValue(nodeChar, "pointtotals.totalpoints", 0);
end

function requestCharSelectDetailClient()
  return "name,#pointtotals.totalpoints,#pointtotals.unspentpoints";
end

function receiveCharSelectDetailClient(vDetails)
  return vDetails[1], "Points: " .. vDetails[2] .. "\n" .. "Unspent Points: " .. vDetails[3];
end

function getCharSelectDetailLocal(nodeLocal)
  local vDetails = {};
  table.insert(vDetails, DB.getValue(nodeLocal, "name", ""));
  table.insert(vDetails, DB.getValue(nodeLocal, "pointtotals.totalpoints", 0));
  table.insert(vDetails, DB.getValue(nodeLocal, "pointtotals.unspentpoints", 0));
  return receiveCharSelectDetailClient(vDetails);
end

function getDistanceUnitsPerGrid()
  return 1;
end

-- GURPS Utility Functions

function rollResult(nTotal, nTarget)
  local sResult = "";
  
  if nTotal <= 4 or (nTotal <= 16 and nTotal <= nTarget) then
    if nTotal <= 4 then
      sResult = string.format("[ Critical Success! ] by %s", math.abs(nTotal - (nTarget < 4 and nTotal or nTarget)));
    elseif nTarget - nTotal >= 10 and nTotal <= 6 then
      sResult = string.format("[ Margin Critical! ] by %s", math.abs(nTotal - nTarget));
    else
      sResult = string.format("[ Success! ] by %s", math.abs(nTotal - nTarget));
    end
  else
    if nTotal == 18 or (nTotal == 17 and nTarget <= 15) or nTotal - nTarget >= 10 then
      sResult = string.format("[ Critical Failure! ] by %s", math.abs(nTotal - (nTarget > 18 and 18 or nTarget)));
    else
      sResult = string.format("[ Failure! ] by %s", math.abs(nTotal - (nTarget > 18 and 18 or nTarget)));
    end
  end
  
  return sResult;
end

function calcRangeMod(nRange)
  local rangeMod = -1;
  local factor = 0;
  local scale = getDistanceUnitsPerGrid();
  
  if nRange == nil then 
    nRange = 0;
  end
  
  while rangeMod < 0 do
    if (nRange*scale) <= (2 * math.pow(10,factor)) then
      rangeMod = ((factor * 6) + 0);
    elseif (nRange*scale) <= (3 * math.pow(10,factor)) then
      rangeMod = ((factor * 6) + 1);
    elseif (nRange*scale) <= (5 * math.pow(10,factor)) then
      rangeMod = ((factor * 6) + 2);
    elseif (nRange*scale) <= (7 * math.pow(10,factor)) then
      rangeMod = ((factor * 6) + 3);
    elseif (nRange*scale) <= (10 * math.pow(10,factor)) then
      rangeMod = ((factor * 6) + 4);
    elseif (nRange*scale) <= (15 * math.pow(10,factor)) then
      rangeMod = ((factor * 6) + 5);
    else
      factor = factor + 1;
    end
  end
  
  return (rangeMod <= 0 and 0 or -rangeMod);
end

function calcSizeModifierGridUnits(nSM)
  local nSize = 2;
  local nSizeModifier = tonumber(nSM and nSM or 0);
  
  if nSizeModifier == nil or nSizeModifier <= 0 then 
    return 1;
  end
  if nSizeModifier >= 10 then 
    return 100; -- Stop at 100 so the tokens token scale doesn't get extreme
  end
  
  while nSizeModifier >= math.abs(calcRangeMod(nSize + 1)) do
    nSize = nSize + 1;
  end
   
  return nSize;
end
