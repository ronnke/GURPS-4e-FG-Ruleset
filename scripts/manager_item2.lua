--
-- Please see the license.html file included with this distribution for
-- attribution and copyright information.
--

function onInit()
	ItemManager.setCustomCharAdd(onItemAdded)
end

function onAddItemToCombat(nodeChar, nodeItem)
  if not nodeChar or not nodeItem then 
    return;
  end
 
  local bDefense = LibraryDataGURPS4e.isDefense(nodeItem);
  local bMeleeWeapon = LibraryDataGURPS4e.isMeleeWeapon(nodeItem);
  local bRangedWeapon = LibraryDataGURPS4e.isRangedWeapon(nodeItem);

  if bDefense then
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
  end

  if bMeleeWeapon then
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
  end

  if bRangedWeapon then
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
  end
end

function onItemAdded(nodeItem)
  local nodeChar = nodeItem.getParent().getParent();
  onAddItemToCombat(nodeChar, nodeItem);
end

--
-- Item Types
--

