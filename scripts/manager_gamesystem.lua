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
  ["melee"] = { sIcon = "action_melee", sTargeting = "each", bUseModStack = true, bAddMod = false },
  ["ranged"] = { sIcon = "action_ranged", sTargeting = "each", bUseModStack = true, bAddMod = false },
  ["dodge"] = { sIcon = "action_defense", bUseModStack = true, bAddMod = false },
  ["parry"] = { sIcon = "action_defense", bUseModStack = true, bAddMod = false },
  ["block"] = { sIcon = "action_defense", bUseModStack = true, bAddMod = false },
  ["damage"] = { sIcon = "action_damage", sTargeting = "each", bUseModStack = true, bAddMod = true },
  ["reaction"] = { sIcon = "action_roll", bUseModStack = true, bAddMod = true },
};

targetactions = {
  "melee",
  "ranged",
  "damage",
  "effect",
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
