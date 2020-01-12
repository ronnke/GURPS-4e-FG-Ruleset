--
-- Please see the license.html file included with this distribution for
-- attribution and copyright information.
--

function onInit()
	ItemManager.setCustomCharAdd(onItemAdded)
	ItemManager.setCustomCharRemove(onItemRemoved);
end

function AddMeleeItem(nodeChar, nodeItem)
  if not nodeChar or not nodeItem then 
    return false;
  end
 
  if not LibraryDataGURPS4e.isMeleeWeapon(nodeItem) then
	return false;
  end

  local nodeMeleeCombatList = DB.getChild(nodeChar, "combat.meleecombatlist")
  if not nodeMeleeCombatList then
    nodeMeleeCombatList = DB.createChild(nodeChar, "combat.meleecombatlist");
  end
    
  local nodeMeleeWeapon = DB.createChild(nodeMeleeCombatList);
  DB.setValue(nodeMeleeWeapon, "name", "string", DB.getValue(nodeItem,"name",""));
  DB.setValue(nodeMeleeWeapon, "st", "string", DB.getValue(nodeItem,"st",""));
  DB.setValue(nodeMeleeWeapon, "weight", "string", DB.getValue(nodeItem,"weight",""));
  DB.setValue(nodeMeleeWeapon, "cost", "string", DB.getValue(nodeItem,"cost",""));
  DB.setValue(nodeMeleeWeapon, "tl", "string", DB.getValue(nodeItem,"tl",""));
  DB.setValue(nodeMeleeWeapon, "text", "formattedtext", DB.getValue(nodeItem,"notes",""));
  
  local nodeModeList = DB.createChild(nodeMeleeWeapon, "meleemodelist");
  local nodeMode = DB.createChild(nodeModeList);
  DB.setValue(nodeMode, "name", "string", "");
  DB.setValue(nodeMode, "lvl", "number", 0);
  DB.setValue(nodeMode, "damage", "string", DB.getValue(nodeItem,"damage",""));
  DB.setValue(nodeMode, "reach", "string", DB.getValue(nodeItem,"reach",""));
  DB.setValue(nodeMode, "parry", "string", DB.getValue(nodeItem,"parry",""));

  return true;
end

function AddRangedItem(nodeChar, nodeItem)
  if not nodeChar or not nodeItem then 
    return false;
  end
 
  if not LibraryDataGURPS4e.isRangedWeapon(nodeItem) then
	return false;
  end

  local nodeRangedCombatList = DB.getChild(nodeChar, "combat.rangedcombatlist")
  if not nodeRangedCombatList then
    nodeRangedCombatList = DB.createChild(nodeChar, "combat.rangedcombatlist");
  end
    
  local nodeRangedWeapon = DB.createChild(nodeRangedCombatList);
  DB.setValue(nodeRangedWeapon, "name", "string", DB.getValue(nodeItem,"name",""));
  DB.setValue(nodeRangedWeapon, "st", "string", DB.getValue(nodeItem,"st",""));
  DB.setValue(nodeRangedWeapon, "bulk", "number", tonumber(DB.getValue(nodeItem,"bulk","0")));
  DB.setValue(nodeRangedWeapon, "lc", "string", DB.getValue(nodeItem,"lc",""));
  DB.setValue(nodeRangedWeapon, "tl", "string", DB.getValue(nodeItem,"tl",""));
  DB.setValue(nodeRangedWeapon, "text", "formattedtext", DB.getValue(nodeItem,"notes",""));
    
  local nodeModeList = DB.createChild(nodeRangedWeapon, "rangedmodelist");
  local nodeMode = DB.createChild(nodeModeList);
  DB.setValue(nodeMode, "name", "string", "");
  DB.setValue(nodeMode, "lvl", "number", 0);
  DB.setValue(nodeMode, "damage", "string", DB.getValue(nodeItem,"damage",""));
  DB.setValue(nodeMode, "acc", "number", tonumber(DB.getValue(nodeItem,"acc","0")));
  DB.setValue(nodeMode, "range", "string", DB.getValue(nodeItem,"range",""));
  DB.setValue(nodeMode, "rof", "string", DB.getValue(nodeItem,"rof",""));
  DB.setValue(nodeMode, "shots", "string", DB.getValue(nodeItem,"shots",""));
  DB.setValue(nodeMode, "rcl", "number", tonumber(DB.getValue(nodeItem,"rcl","0")));

  return true;
end

function AddDefenseItem(nodeChar, nodeItem)
  if not nodeChar or not nodeItem then 
    return false;
  end
 
  if not LibraryDataGURPS4e.isDefense(nodeItem) then
	return false;
  end

  local nodeDefensesList = DB.getChild(nodeChar, "combat.defenseslist")
  if not nodeDefensesList then
    nodeDefensesList = DB.createChild(nodeChar, "combat.defenseslist");
  end
    
  local nodeDefenses = DB.createChild(nodeDefensesList);
  DB.setValue(nodeDefenses, "name", "string", DB.getValue(nodeItem,"name",""));
  DB.setValue(nodeDefenses, "db", "number", tonumber(DB.getValue(nodeItem,"db","0")));
  DB.setValue(nodeDefenses, "dr", "string", DB.getValue(nodeItem,"dr",""));
  DB.setValue(nodeDefenses, "locations", "string", DB.getValue(nodeItem,"locations",""));
  DB.setValue(nodeDefenses, "text", "formattedtext", DB.getValue(nodeItem,"notes",""));

  return true;
end

function AddItemToCombat(nodeChar, nodeItem)
  local bAdded = false;

  bAdded = AddMeleeItem(nodeChar, nodeItem) or bAdded;
  bAdded = AddRangedItem(nodeChar, nodeItem) or bAdded;
  bAdded = AddDefenseItem(nodeChar, nodeItem) or bAdded;

  return bAdded;
end

function onItemAdded(nodeItem)
  local nodeChar = nodeItem.getParent().getParent();
  return AddItemToCombat(nodeChar, nodeItem);
end

function onItemRemoved(nodeItem)
-- Do your remove code
end

--
-- Item Types
--

