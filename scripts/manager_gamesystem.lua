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

currencies = { 
	{ name = "$", weight = 0.0, value = 1 },
};
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
