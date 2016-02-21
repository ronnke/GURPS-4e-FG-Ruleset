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
  ["melee"] = { sIcon = "action_melee", bUseModStack = true, bAddMod = false },
  ["ranged"] = { sIcon = "action_ranged", bUseModStack = true, bAddMod = false },
  ["dodge"] = { sIcon = "action_defense", bUseModStack = true, bAddMod = false },
  ["parry"] = { sIcon = "action_defense", bUseModStack = true, bAddMod = false },
  ["block"] = { sIcon = "action_defense", bUseModStack = true, bAddMod = false },
  ["damage"] = { sIcon = "action_damage", bUseModStack = true, bAddMod = true  },
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
  return "";
end

function requestCharSelectDetailClient()
  return "name";
end

function receiveCharSelectDetailClient(vDetails)
  return vDetails, "";
end

function getCharSelectDetailLocal(nodeLocal)
  return DB.getValue(nodeLocal, "name", ""), "";
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
