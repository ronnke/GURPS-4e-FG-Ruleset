-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function getItemIsIdentified(vRecord, vDefault)
	return LibraryData.getIDState("item", vRecord, true);
end

function isDefense(vRecord)
  local bIsDefense = false;

  local nodeItem;
  if type(vRecord) == "string" then
    nodeItem = DB.findNode(vRecord);
  elseif type(vRecord) == "databasenode" then
    nodeItem = vRecord;
  end
  if not nodeItem then
    return false, "", "";
  end
  
  local sTypeLower = StringManager.trim(DB.getValue(nodeItem, "type", "")):lower();
  local sSubtypeLower = StringManager.trim(DB.getValue(nodeItem, "subtype", "")):lower();

  if string.find(sTypeLower, "defense") then    
    bIsDefense = true;
  end
  
  return bIsDefense, sTypeLower, sSubtypeLower;
end

function isMeleeWeapon(vRecord)
  local bIsMeleeWeapon = false;

  local nodeItem;
  if type(vRecord) == "string" then
    nodeItem = DB.findNode(vRecord);
  elseif type(vRecord) == "databasenode" then
    nodeItem = vRecord;
  end
  if not nodeItem then
    return false, "", "";
  end
  
  local sTypeLower = StringManager.trim(DB.getValue(nodeItem, "type", "")):lower();
  local sSubtypeLower = StringManager.trim(DB.getValue(nodeItem, "subtype", "")):lower();
    
  if string.find(sTypeLower, "melee") then
    bIsMeleeWeapon = true;
  end
  
  return bIsMeleeWeapon, sTypeLower, sSubtypeLower;
end

function isRangedWeapon(vRecord)
  local bIsRangedWeapon = false;

  local nodeItem;
  if type(vRecord) == "string" then
    nodeItem = DB.findNode(vRecord);
  elseif type(vRecord) == "databasenode" then
    nodeItem = vRecord;
  end
  if not nodeItem then
    return false, "", "";
  end

  local sTypeLower = StringManager.trim(DB.getValue(nodeItem, "type", "")):lower();
  local sSubtypeLower = StringManager.trim(DB.getValue(nodeItem, "subtype", "")):lower();
  
  if string.find(sTypeLower, "ranged") then
    bIsRangedWeapon = true;
  end
  
  return bIsRangedWeapon, sTypeLower, sSubtypeLower;
end

function isGroundVehicle(vRecord)
  local bIsGroundVehicle = false;

  local nodeItem;
  if type(vRecord) == "string" then
    nodeItem = DB.findNode(vRecord);
  elseif type(vRecord) == "databasenode" then
    nodeItem = vRecord;
  end
  if not nodeItem then
    return false, "", "";
  end
  
  local sTypeLower = StringManager.trim(DB.getValue(nodeItem, "type", "")):lower();
  local sSubtypeLower = StringManager.trim(DB.getValue(nodeItem, "subtype", "")):lower();

  if string.find(sTypeLower, "ground vehicle") then
    bIsGroundVehicle = true;
  end
  
  return bIsGroundVehicle, sTypeLower, sSubtypeLower;
end

function isWatercraft(vRecord)
  local bIsWatercraft = false;

  local nodeItem;
  if type(vRecord) == "string" then
    nodeItem = DB.findNode(vRecord);
  elseif type(vRecord) == "databasenode" then
    nodeItem = vRecord;
  end
  if not nodeItem then
    return false, "", "";
  end
  
  local sTypeLower = StringManager.trim(DB.getValue(nodeItem, "type", "")):lower();
  local sSubtypeLower = StringManager.trim(DB.getValue(nodeItem, "subtype", "")):lower();

  if string.find(sTypeLower, "watercraft") then
    bIsWatercraft = true;
  end
  
  return bIsWatercraft, sTypeLower, sSubtypeLower;
end

function isAircraft(vRecord)
  local bIsAircraft = false;

  local nodeItem;
  if type(vRecord) == "string" then
    nodeItem = DB.findNode(vRecord);
  elseif type(vRecord) == "databasenode" then
    nodeItem = vRecord;
  end
  if not nodeItem then
    return false, "", "";
  end
  
  local sTypeLower = StringManager.trim(DB.getValue(nodeItem, "type", "")):lower();
  local sSubtypeLower = StringManager.trim(DB.getValue(nodeItem, "subtype", "")):lower();

  if string.find(sTypeLower, "aircraft") then
    bIsAircraft = true;
  end
  
  return bIsAircraft, sTypeLower, sSubtypeLower;
end

function isSpacecraft(vRecord)
  local bIsSpacecraft = false;

  local nodeItem;
  if type(vRecord) == "string" then
    nodeItem = DB.findNode(vRecord);
  elseif type(vRecord) == "databasenode" then
    nodeItem = vRecord;
  end
  if not nodeItem then
    return false, "", "";
  end
  
  local sTypeLower = StringManager.trim(DB.getValue(nodeItem, "type", "")):lower();
  local sSubtypeLower = StringManager.trim(DB.getValue(nodeItem, "subtype", "")):lower();

  if string.find(sTypeLower, "spacecraft") then
    bIsSpacecraft = true;
  end
  
  return bIsSpacecraft, sTypeLower, sSubtypeLower;
end

function isSkill(vRecord)
  local nodeItem;
  if type(vRecord) == "string" then
    nodeItem = DB.findNode(vRecord);
  elseif type(vRecord) == "databasenode" then
    nodeItem = vRecord;
  end
  if not nodeItem then
    return false, "", "";
  end
  
  local sTypeLower = StringManager.trim(DB.getValue(nodeItem, "type", "")):lower();

  if string.find(sTypeLower, "skill") then    
    return true;
  end
  
  return false;
end

function isSpell(vRecord)
  local nodeItem;
  if type(vRecord) == "string" then
    nodeItem = DB.findNode(vRecord);
  elseif type(vRecord) == "databasenode" then
    nodeItem = vRecord;
  end
  if not nodeItem then
    return false, "", "";
  end
  
  local sTypeLower = StringManager.trim(DB.getValue(nodeItem, "type", "")):lower();

  if string.find(sTypeLower, "spell") then    
    return true;
  end
  
  return false;
end

function isPower(vRecord)
  local nodeItem;
  if type(vRecord) == "string" then
    nodeItem = DB.findNode(vRecord);
  elseif type(vRecord) == "databasenode" then
    nodeItem = vRecord;
  end
  if not nodeItem then
    return false, "", "";
  end
  
  local sTypeLower = StringManager.trim(DB.getValue(nodeItem, "type", "")):lower();
  
  if string.find(sTypeLower, "power") then    
    return true;
  end
  
  return false;
end

function isOther(vRecord)
  local nodeItem;
  if type(vRecord) == "string" then
    nodeItem = DB.findNode(vRecord);
  elseif type(vRecord) == "databasenode" then
    nodeItem = vRecord;
  end
  if not nodeItem then
    return false, "", "";
  end
  
  local sTypeLower = StringManager.trim(DB.getValue(nodeItem, "type", "")):lower();

  if string.find(sTypeLower, "other") then    
    return true;
  end
  
  return false;
end

function isAdvantage(vRecord)
  local nodeItem;
  if type(vRecord) == "string" then
    nodeItem = DB.findNode(vRecord);
  elseif type(vRecord) == "databasenode" then
    nodeItem = vRecord;
  end
  if not nodeItem then
    return false, "", "";
  end
  
  local sTypeLower = StringManager.trim(DB.getValue(nodeItem, "type", "")):lower();

  if sTypeLower == "advantage" then    
    return true;
  end
  
  return false;
end

function isDisadvantage(vRecord)
  local nodeItem;
  if type(vRecord) == "string" then
    nodeItem = DB.findNode(vRecord);
  elseif type(vRecord) == "databasenode" then
    nodeItem = vRecord;
  end
  if not nodeItem then
    return false, "", "";
  end
  
  local sTypeLower = StringManager.trim(DB.getValue(nodeItem, "type", "")):lower();

  if sTypeLower == "disadvantage" then    
    return true;
  end
  
  return false;
end

function isPerk(vRecord)
  local nodeItem;
  if type(vRecord) == "string" then
    nodeItem = DB.findNode(vRecord);
  elseif type(vRecord) == "databasenode" then
    nodeItem = vRecord;
  end
  if not nodeItem then
    return false, "", "";
  end
  
  local sTypeLower = StringManager.trim(DB.getValue(nodeItem, "type", "")):lower();

  if sTypeLower == "perk" then    
    return true;
  end
  
  return false;
end

function isQuirk(vRecord)
  local nodeItem;
  if type(vRecord) == "string" then
    nodeItem = DB.findNode(vRecord);
  elseif type(vRecord) == "databasenode" then
    nodeItem = vRecord;
  end
  if not nodeItem then
    return false, "", "";
  end
  
  local sTypeLower = StringManager.trim(DB.getValue(nodeItem, "type", "")):lower();

  if sTypeLower == "quirk" then    
    return true;
  end
  
  return false;
end

aRecordOverrides = {
-- Core Overrides
    ["npc"] = { 
		aDataMap = { "npc", "reference.npcs", "reference.npc", "reference.npcdata" }, 
        aGMListButtons = { "button_npc_byletter", "button_npc_bytype" };
	    aCustomFilters = {
            ["Type"] = { sField = "type" },
	    },
    },
    ["item"] = { 
		aDataMap = { "item", "reference.items", "reference.item", "reference.itemdata" }, 
	    aGMListButtons = { "button_item_bytype", "button_item_defense", "button_item_meleeweapon", "button_item_rangedweapon" };
	    aPlayerListButtons = { "button_item_bytype", "button_item_defense", "button_item_meleeweapon", "button_item_rangedweapon" };
	    aCustomFilters = {
		    ["Type"] = { sField = "type" },
		    ["Sub Type"] = { sField = "subtype" },
	    },
		aCustom = {
			tWindowMenu = { ["right"] = { "chat_output" } },
		},
    },
	["note"] = { 
		aCustom = {
			tWindowMenu = { ["right"] = { "chat_output" } },
		},
	},
    ["vehicle"] = { 
		aDataMap = { "vehicle", "reference.vehicles", "reference.vehicle", "reference.vehicledata" }, 
        aGMListButtons = { "button_vehicle_groundvehicle", "button_vehicle_watercraft", "button_vehicle_aircraft", "button_vehicle_spacecraft" };
        aPlayerListButtons = { "button_vehicle_groundvehicle", "button_vehicle_watercraft", "button_vehicle_aircraft", "button_vehicle_spacecraft" };
        aCustomFilters = {
            ["Type"] = { sField = "type" },
		    ["Sub Type"] = { sField = "subtype" },
        },
		aCustom = {
			tWindowMenu = { ["right"] = { "chat_output" } },
		},
    },

    -- New Record Types

	["ability"] = {
		bExport = true, 
		aDataMap = { "ability", "reference.abilities", "reference.ability", "reference.abilitydata" }, 
	    aGMListButtons = { "button_ability_skill", "button_ability_spell", "button_ability_power", "button_ability_other" };
	    aPlayerListButtons = { "button_ability_skill", "button_ability_spell", "button_ability_power", "button_ability_other" };
        sSidebarCategory = "create",
	    aCustomFilters = {
		    ["Type"] = { sField = "type" },
		    ["Sub Type"] = { sField = "subtype" },
	    },
		aCustom = {
			tWindowMenu = { ["right"] = { "chat_output" } },
		},
	},
	["trait"] = {
		bExport = true, 
		aDataMap = { "trait", "reference.traits", "reference.trait", "reference.traitdata" }, 
	    aGMListButtons = { "button_trait_advantage", "button_trait_disadvantage", "button_trait_perk", "button_trait_quirk" };
	    aPlayerListButtons = { "button_trait_advantage", "button_trait_disadvantage", "button_trait_perk", "button_trait_quirk" };
        sSidebarCategory = "create",
	    aCustomFilters = {
		    ["Type"] = { sField = "type" },
		    ["Sub Type"] = { sField = "subtype" },
	    },
		aCustom = {
			tWindowMenu = { ["right"] = { "chat_output" } },
		},
	},
};

aListViews = {
    ["npc"] = {
        ["byletter"] = {
            aColumns = {
	            { sName = "name", sType = "string", sHeadingRes = "npc_grouped_label_name", nWidth=250 },
	            { sName = "pts", sType = "number", sHeadingRes = "npc_grouped_label_pts", sTooltipRe = "npc_grouped_tooltip_pts", bCentered=true },
            },
            aFilters = {},
            aGroups = { 
                { sDBField = "name", nLength = 1 } 
            },
            aGroupValueOrder = { },
        },
        ["bytype"] = {
            aColumns = {
	            { sName = "name", sType = "string", sHeadingRes = "npc_grouped_label_name", nWidth=250 },
	            { sName = "pts", sType = "number", sHeadingRes = "npc_grouped_label_pts", sTooltipRe = "npc_grouped_tooltip_pts", bCentered=true },
            },
            aFilters = {},
            aGroups = { 
                { sDBField = "type" } 
            },
            aGroupValueOrder = {},
        },
    },

    ["ability"] = {
        ["skill"] = {
            aColumns = {
                { sName = "name", sType = "string", sHeadingRes = "ability_grouped_label_name", nWidth=140 },
                { sName = "skilltype", sType = "string", sHeadingRes = "ability_grouped_label_type", nWidth=80 },
                { sName = "skilldefault", sType = "string", sHeadingRes = "ability_grouped_label_default", nWidth=100 },
                { sName = "skillprerequisite", sType = "string", sHeadingRes = "ability_grouped_label_prerequisite", nWidth=120 },
                { sName = "page", sType = "string", sHeadingRes = "ability_grouped_label_page", nWidth=60, bCentered=true },
            },
            aFilters = { 
                { sDBField = "type", vFilterValue = "Skill" }, 
            },
            aGroups = { 
                { sDBField = "subtype" } 
            },
            aGroupValueOrder = {},
        },
        ["spell"] = {
            aColumns = {
                { sName = "name", sType = "string", sHeadingRes = "ability_grouped_label_name", nWidth=140 },
                { sName = "spellclass", sType = "string", sHeadingRes = "ability_grouped_label_class", nWidth=100 },
                { sName = "spellduration", sType = "string", sHeadingRes = "ability_grouped_label_duration", nWidth=60, bCentered=true },
                { sName = "spellcost", sType = "string", sHeadingRes = "ability_grouped_label_cost", nWidth=80, bCentered=true },
                { sName = "spelltimetocast", sType = "string", sHeadingRes = "ability_grouped_label_timetocast", nWidth=70, bCentered=true },
                { sName = "spellprerequisite", sType = "string", sHeadingRes = "ability_grouped_label_prerequisite", nWidth=120 },
                { sName = "page", sType = "string", sHeadingRes = "ability_grouped_label_page", nWidth=60, bCentered=true },
            },
            aFilters = { 
                { sDBField = "type", vFilterValue = "Spell" }, 
            },
            aGroups = { 
                { sDBField = "subtype" },
                { sDBField = "spellcollege" } 
            },
            aGroupValueOrder = {},
        },
        ["power"] = {
            aColumns = {
                { sName = "name", sType = "string", sHeadingRes = "ability_grouped_label_name", nWidth=140 },
                { sName = "powertype", sType = "string", sHeadingRes = "ability_grouped_label_type", nWidth=80 },
                { sName = "powerdefault", sType = "string", sHeadingRes = "ability_grouped_label_default", nWidth=100 },
                { sName = "page", sType = "string", sHeadingRes = "ability_grouped_label_page", nWidth=60, bCentered=true },
            },
            aFilters = { 
                { sDBField = "type", vFilterValue = "Power" }, 
            },
            aGroups = { 
                { sDBField = "subtype" },
            },
            aGroupValueOrder = {},
        },
        ["other"] = {
            aColumns = {
                { sName = "name", sType = "string", sHeadingRes = "ability_grouped_label_name", nWidth=140 },
                { sName = "otherlevel", sType = "number", sHeadingRes = "ability_grouped_label_level", nWidth=80, bCentered=true },
                { sName = "otherpoints", sType = "number", sHeadingRes = "ability_grouped_label_points", nWidth=100, bCentered=true },
                { sName = "page", sType = "string", sHeadingRes = "ability_grouped_label_page", nWidth=60, bCentered=true },
            },
            aFilters = { 
                { sDBField = "type", vFilterValue = "Other" }, 
            },
            aGroups = { 
                { sDBField = "subtype" },
            },
            aGroupValueOrder = {},
        },
    },

    ["trait"] = {
        ["advantage"] = {
            aColumns = {
                { sName = "name", sType = "string", sHeadingRes = "trait_grouped_label_name", nWidth=160 },
                { sName = "points", sType = "number", sHeadingRes = "trait_grouped_label_points", nWidth=80, bCentered=true },
                { sName = "page", sType = "string", sHeadingRes = "trait_grouped_label_page", nWidth=60, bCentered=true },
            },
            aFilters = { 
                { sDBField = "type", vFilterValue = "Advantage" }, 
            },
            aGroups = { 
                { sDBField = "subtype" } 
            },
            aGroupValueOrder = {},
        },
        ["disadvantage"] = {
            aColumns = {
                { sName = "name", sType = "string", sHeadingRes = "trait_grouped_label_name", nWidth=160 },
                { sName = "points", sType = "number", sHeadingRes = "trait_grouped_label_points", nWidth=80, bCentered=true },
                { sName = "page", sType = "string", sHeadingRes = "trait_grouped_label_page", nWidth=60, bCentered=true },
            },
            aFilters = { 
                { sDBField = "type", vFilterValue = "Disadvantage" }, 
            },
            aGroups = { 
                { sDBField = "subtype" } 
            },
            aGroupValueOrder = {},
        },
        ["perk"] = {
            aColumns = {
                { sName = "name", sType = "string", sHeadingRes = "trait_grouped_label_name", nWidth=160 },
                { sName = "points", sType = "number", sHeadingRes = "trait_grouped_label_points", nWidth=80, bCentered=true },
                { sName = "page", sType = "string", sHeadingRes = "trait_grouped_label_page", nWidth=60, bCentered=true },
            },
            aFilters = { 
                { sDBField = "type", vFilterValue = "Perk" }, 
            },
            aGroups = { 
                { sDBField = "subtype" } 
            },
            aGroupValueOrder = {},
        },
        ["quirk"] = {
            aColumns = {
                { sName = "name", sType = "string", sHeadingRes = "trait_grouped_label_name", nWidth=160 },
                { sName = "points", sType = "number", sHeadingRes = "trait_grouped_label_points", nWidth=80, bCentered=true },
                { sName = "page", sType = "string", sHeadingRes = "trait_grouped_label_page", nWidth=60, bCentered=true },
            },
            aFilters = { 
                { sDBField = "type", vFilterValue = "Quirk" }, 
            },
            aGroups = { 
                { sDBField = "subtype" } 
            },
            aGroupValueOrder = {},
        },
    },

    ["item"] = {
        ["bytype"] = {
            aColumns = {
                { sName = "tl", sType = "string", sHeadingRes = "item_grouped_label_tl", sTooltipRes = "item_grouped_tooltip_tl", nWidth=30, bCentered=true },
                { sName = "name", sType = "string", sHeadingRes = "item_grouped_label_name", nWidth=140 },
                { sName = "cost", sType = "string", sHeadingRes = "item_grouped_label_cost", bCentered=true },
                { sName = "weight", sType = "number", sHeadingRes = "item_grouped_label_weight", sTooltipRes = "item_grouped_tooltip_weight", nWidth=30, bCentered=true },
                { sName = "lc", sType = "string", sHeadingRes = "item_grouped_label_lc", nWidth=30, bCentered=true },
            },
            aFilters = {},
            aGroups = { 
                { sDBField = "type" },
                { sDBField = "subtype" } 
            },
			aGroupValueOrder = { },
        },
        ["defense"] = {
            aColumns = {
                { sName = "tl", sType = "string", sHeadingRes = "item_grouped_label_tl", sTooltipRes = "item_grouped_tooltip_tl", nWidth=30, bCentered=true },
                { sName = "name", sType = "string", sHeadingRes = "item_grouped_label_name", nWidth=140 },
                { sName = "locations", sType = "string", sHeadingRes = "item_grouped_label_locations", nWidth=120 },
                { sName = "db", sType = "string", sHeadingRes = "item_grouped_label_db", sTooltipRes = "item_grouped_tooltip_db", nWidth=40, bCentered=true },
                { sName = "dr", sType = "string", sHeadingRes = "item_grouped_label_dr", sTooltipRes = "item_grouped_tooltip_dr", nWidth=40, bCentered=true },
                { sName = "cost", sType = "string", sHeadingRes = "item_grouped_label_cost", bCentered=true },
                { sName = "weight", sType = "number", sHeadingRes = "item_grouped_label_weight", sTooltipRes = "item_grouped_tooltip_weight", nWidth=30, bCentered=true },
                { sName = "don", sType = "string", sHeadingRes = "item_grouped_label_don", nWidth=30, bCentered=true },
                { sName = "holdout", sType = "string", sHeadingRes = "item_grouped_label_holdout", nWidth=50, bCentered=true },
                { sName = "lc", sType = "string", sHeadingRes = "item_grouped_label_lc", nWidth=30, bCentered=true },
            },
            aFilters = { 
				{ sCustom = "item_isdefense" }
            },
            aGroups = { 
                { sDBField = "subtype" } 
            },
            aGroupValueOrder = {},
        },
        ["meleeweapon"] = {
            aColumns = {
                { sName = "tl", sType = "string", sHeadingRes = "item_grouped_label_tl", sTooltipRes = "item_grouped_tooltip_tl", nWidth=30, bCentered=true },
	            { sName = "name", sType = "string", sHeadingRes = "item_grouped_label_name", nWidth=140 },
                { sName = "damage", sType = "string", sHeadingRes = "item_grouped_label_damage", nWidth=110, bCentered=true },
                { sName = "reach", sType = "string", sHeadingRes = "item_grouped_label_reach", nWidth=40, bCentered=true },
                { sName = "parry", sType = "string", sHeadingRes = "item_grouped_label_parry", nWidth=40, bCentered=true },
	            { sName = "cost", sType = "string", sHeadingRes = "item_grouped_label_cost", bCentered=true },
	            { sName = "weight", sType = "number", sHeadingRes = "item_grouped_label_weight", sTooltipRes = "item_grouped_tooltip_weight", nWidth=30, bCentered=true },
                { sName = "st", sType = "string", sHeadingRes = "item_grouped_label_st", sTooltipRes = "item_grouped_tooltip_st", nWidth=30, bCentered=true },
                { sName = "lc", sType = "string", sHeadingRes = "item_grouped_label_lc", nWidth=30, bCentered=true },
            },
            aFilters = { 
				{ sCustom = "item_ismeleeweapon" }
            },
            aGroups = { 
                { sDBField = "subtype" } 
            },
            aGroupValueOrder = {},
        },
        ["rangedweapon"] = {
            aColumns = {
                { sName = "tl", sType = "string", sHeadingRes = "item_grouped_label_tl", sTooltipRes = "item_grouped_tooltip_tl", nWidth=30, bCentered=true },
	            { sName = "name", sType = "string", sHeadingRes = "item_grouped_label_name", nWidth=140 },
                { sName = "damage", sType = "string", sHeadingRes = "item_grouped_label_damage", nWidth=110, bCentered=true },
                { sName = "acc", sType = "string", sHeadingRes = "item_grouped_label_acc", sTooltipRes = "item_grouped_tooltip_acc", nWidth=30, bCentered=true },
                { sName = "range", sType = "string", sHeadingRes = "item_grouped_label_range", nWidth=80, bCentered=true },
                { sName = "weight", sType = "number", sHeadingRes = "item_grouped_label_weight", sTooltipRes = "item_grouped_tooltip_weight", nWidth=30, bCentered=true },
                { sName = "rof", sType = "string", sHeadingRes = "item_grouped_label_rof", sTooltipRes = "item_grouped_tooltip_rof", nWidth=40, bCentered=true },
                { sName = "shots", sType = "string", sHeadingRes = "item_grouped_label_shots", sTooltipRes = "item_grouped_tooltip_shots", nWidth=50, bCentered=true },
                { sName = "st", sType = "string", sHeadingRes = "item_grouped_label_st", sTooltipRes = "item_grouped_tooltip_st", nWidth=30, bCentered=true },
                { sName = "bulk", sType = "string", sHeadingRes = "item_grouped_label_bulk", sTooltipRes = "item_grouped_tooltip_bulk", nWidth=30, bCentered=true },
                { sName = "rcl", sType = "string", sHeadingRes = "item_grouped_label_rcl", sTooltipRes = "item_grouped_tooltip_rcl", nWidth=30, bCentered=true },
	            { sName = "cost", sType = "string", sHeadingRes = "item_grouped_label_cost", bCentered=true },
                { sName = "lc", sType = "string", sHeadingRes = "item_grouped_label_lc", sTooltipRes = "item_grouped_tooltip_lc", nWidth=30, bCentered=true },
            },
            aFilters = { 
				{ sCustom = "item_israngedweapon" }
            },
            aGroups = { 
                { sDBField = "subtype" } 
            },
            aGroupValueOrder = {},
        },
    },

    ["vehicle"] = {
        ["groundvehicle"] = {
            aColumns = {
                { sName = "tl", sType = "string", sHeadingRes = "vehicle_grouped_label_tl", sTooltipRes = "vehicle_grouped_tooltip_tl", nWidth=30, bCentered=true },
                { sName = "name", sType = "string", sHeadingRes = "vehicle_grouped_label_name", nWidth=140 },
                { sName = "sthp", sType = "string", sHeadingRes = "vehicle_grouped_label_sthp", sTooltipRes = "vehicle_grouped_tooltip_sthp", nWidth=40, bCentered=true },
                { sName = "hndsr", sType = "string", sHeadingRes = "vehicle_grouped_label_hndsr", sTooltipRes = "vehicle_grouped_tooltip_hndsr", nWidth=40, bCentered=true },
                { sName = "ht", sType = "string", sHeadingRes = "vehicle_grouped_label_ht", sTooltipRes = "vehicle_grouped_tooltip_ht", nWidth=30, bCentered=true },
                { sName = "move", sType = "string", sHeadingRes = "vehicle_grouped_label_move", nWidth=80, bCentered=true },
                { sName = "lwt", sType = "string", sHeadingRes = "vehicle_grouped_label_lwt", sTooltipRes = "vehicle_grouped_tooltip_lwt", nWidth=40, bCentered=true },
                { sName = "load", sType = "string", sHeadingRes = "vehicle_grouped_label_load", nWidth=40, bCentered=true },
                { sName = "sm", sType = "string", sHeadingRes = "vehicle_grouped_label_sm", sTooltipRes = "vehicle_grouped_tooltip_sm", nWidth=30, bCentered=true },
                { sName = "occ", sType = "string", sHeadingRes = "vehicle_grouped_label_occ", sTooltipRes = "vehicle_grouped_tooltip_occ", nWidth=40, bCentered=true },
                { sName = "dr", sType = "string", sHeadingRes = "vehicle_grouped_label_dr", sTooltipRes = "vehicle_grouped_tooltip_dr", nWidth=30, bCentered=true },
                { sName = "range", sType = "string", sHeadingRes = "vehicle_grouped_label_range", nWidth=40, bCentered=true },
                { sName = "cost", sType = "string", sHeadingRes = "vehicle_grouped_label_cost", nWidth=80, bCentered=true },
                { sName = "locations", sType = "string", sHeadingRes = "vehicle_grouped_label_locations", nWidth=80, bCentered=true },
            },
            aFilters = { 
                { sDBField = "type", vFilterValue = "Ground Vehicle" }, 
            },
            aGroups = { 
                { sDBField = "subtype" } 
            },
            aGroupValueOrder = {},
        },
        ["watercraft"] = {
            aColumns = {
                { sName = "tl", sType = "string", sHeadingRes = "vehicle_grouped_label_tl", sTooltipRes = "vehicle_grouped_tooltip_tl", nWidth=30, bCentered=true },
                { sName = "name", sType = "string", sHeadingRes = "vehicle_grouped_label_name", nWidth=120 },
                { sName = "sthp", sType = "string", sHeadingRes = "vehicle_grouped_label_sthp", sTooltipRes = "vehicle_grouped_tooltip_sthp", nWidth=40, bCentered=true },
                { sName = "hndsr", sType = "string", sHeadingRes = "vehicle_grouped_label_hndsr", sTooltipRes = "vehicle_grouped_tooltip_hndsr", nWidth=40, bCentered=true },
                { sName = "ht", sType = "string", sHeadingRes = "vehicle_grouped_label_ht", sTooltipRes = "vehicle_grouped_tooltip_ht", nWidth=30, bCentered=true },
                { sName = "move", sType = "string", sHeadingRes = "vehicle_grouped_label_move", nWidth=80, bCentered=true },
                { sName = "lwt", sType = "string", sHeadingRes = "vehicle_grouped_label_lwt", sTooltipRes = "vehicle_grouped_tooltip_lwt", nWidth=40, bCentered=true },
                { sName = "load", sType = "string", sHeadingRes = "vehicle_grouped_label_load", nWidth=40, bCentered=true },
                { sName = "sm", sType = "string", sHeadingRes = "vehicle_grouped_label_sm", sTooltipRes = "vehicle_grouped_tooltip_sm", nWidth=30, bCentered=true },
                { sName = "occ", sType = "string", sHeadingRes = "vehicle_grouped_label_occ", sTooltipRes = "vehicle_grouped_tooltip_occ", nWidth=40, bCentered=true },
                { sName = "dr", sType = "string", sHeadingRes = "vehicle_grouped_label_dr", sTooltipRes = "vehicle_grouped_tooltip_dr", nWidth=30, bCentered=true },
                { sName = "range", sType = "string", sHeadingRes = "vehicle_grouped_label_range", nWidth=40, bCentered=true },
                { sName = "cost", sType = "string", sHeadingRes = "vehicle_grouped_label_cost", nWidth=80, bCentered=true },
                { sName = "locations", sType = "string", sHeadingRes = "vehicle_grouped_label_locations", nWidth=80, bCentered=true },
                { sName = "draft", sType = "string", sHeadingRes = "vehicle_grouped_label_draft", nWidth=40, bCentered=true },
            },
            aFilters = { 
                { sDBField = "type", vFilterValue = "Watercraft" }, 
            },
            aGroups = { 
                { sDBField = "subtype" } 
            },
            aGroupValueOrder = {},
        },
        ["aircraft"] = {
            aColumns = {
                { sName = "tl", sType = "string", sHeadingRes = "vehicle_grouped_label_tl", sTooltipRes = "vehicle_grouped_tooltip_tl", nWidth=30, bCentered=true },
                { sName = "name", sType = "string", sHeadingRes = "vehicle_grouped_label_name", nWidth=120 },
                { sName = "sthp", sType = "string", sHeadingRes = "vehicle_grouped_label_sthp", sTooltipRes = "vehicle_grouped_tooltip_sthp", nWidth=40, bCentered=true },
                { sName = "hndsr", sType = "string", sHeadingRes = "vehicle_grouped_label_hndsr", sTooltipRes = "vehicle_grouped_tooltip_hndsr", nWidth=40, bCentered=true },
                { sName = "ht", sType = "string", sHeadingRes = "vehicle_grouped_label_ht", sTooltipRes = "vehicle_grouped_tooltip_ht", nWidth=30, bCentered=true },
                { sName = "move", sType = "string", sHeadingRes = "vehicle_grouped_label_move", nWidth=80, bCentered=true },
                { sName = "lwt", sType = "string", sHeadingRes = "vehicle_grouped_label_lwt", sTooltipRes = "vehicle_grouped_tooltip_lwt", nWidth=40, bCentered=true },
                { sName = "load", sType = "string", sHeadingRes = "vehicle_grouped_label_load", nWidth=40, bCentered=true },
                { sName = "sm", sType = "string", sHeadingRes = "vehicle_grouped_label_sm", sTooltipRes = "vehicle_grouped_tooltip_sm", nWidth=30, bCentered=true },
                { sName = "occ", sType = "string", sHeadingRes = "vehicle_grouped_label_occ", sTooltipRes = "vehicle_grouped_tooltip_occ", nWidth=40, bCentered=true },
                { sName = "dr", sType = "string", sHeadingRes = "vehicle_grouped_label_dr", sTooltipRes = "vehicle_grouped_tooltip_dr", nWidth=30, bCentered=true },
                { sName = "range", sType = "string", sHeadingRes = "vehicle_grouped_label_range", nWidth=40, bCentered=true },
                { sName = "cost", sType = "string", sHeadingRes = "vehicle_grouped_label_cost", nWidth=80, bCentered=true },
                { sName = "locations", sType = "string", sHeadingRes = "vehicle_grouped_label_locations", nWidth=80, bCentered=true },
                { sName = "stall", sType = "string", sHeadingRes = "vehicle_grouped_label_stall", nWidth=40, bCentered=true },
            },
            aFilters = { 
                { sDBField = "type", vFilterValue = "Aircraft" }, 
            },
            aGroups = { 
                { sDBField = "subtype" } 
            },
            aGroupValueOrder = {},
        },
        ["spacecraft"] = {
            aColumns = {
                { sName = "tl", sType = "string", sHeadingRes = "vehicle_grouped_label_tl", sTooltipRes = "vehicle_grouped_tooltip_tl", nWidth=30, bCentered=true },
                { sName = "name", sType = "string", sHeadingRes = "vehicle_grouped_label_name", nWidth=120 },
                { sName = "sthp", sType = "string", sHeadingRes = "vehicle_grouped_label_sthp", sTooltipRes = "vehicle_grouped_tooltip_sthp", nWidth=40, bCentered=true },
                { sName = "hndsr", sType = "string", sHeadingRes = "vehicle_grouped_label_hndsr", sTooltipRes = "vehicle_grouped_tooltip_hndsr", nWidth=40, bCentered=true },
                { sName = "ht", sType = "string", sHeadingRes = "vehicle_grouped_label_ht", sTooltipRes = "vehicle_grouped_tooltip_ht", nWidth=30, bCentered=true },
                { sName = "moveg", sType = "string", sHeadingRes = "vehicle_grouped_label_moveg", nWidth=80, bCentered=true },
                { sName = "lwt", sType = "string", sHeadingRes = "vehicle_grouped_label_lwt", sTooltipRes = "vehicle_grouped_tooltip_lwt", nWidth=40, bCentered=true },
                { sName = "load", sType = "string", sHeadingRes = "vehicle_grouped_label_load", nWidth=40, bCentered=true },
                { sName = "sm", sType = "string", sHeadingRes = "vehicle_grouped_label_sm", sTooltipRes = "vehicle_grouped_tooltip_sm", nWidth=30, bCentered=true },
                { sName = "occ", sType = "string", sHeadingRes = "vehicle_grouped_label_occ", sTooltipRes = "vehicle_grouped_tooltip_occ", nWidth=40, bCentered=true },
                { sName = "dr", sType = "string", sHeadingRes = "vehicle_grouped_label_dr", sTooltipRes = "vehicle_grouped_tooltip_dr", nWidth=30, bCentered=true },
                { sName = "cost", sType = "string", sHeadingRes = "vehicle_grouped_label_cost", nWidth=80, bCentered=true },
                { sName = "locations", sType = "string", sHeadingRes = "vehicle_grouped_label_locations", nWidth=80, bCentered=true },
            },
            aFilters = { 
                { sDBField = "type", vFilterValue = "Spacecraft" }, 
            },
            aGroups = { 
                { sDBField = "subtype" } 
            },
            aGroupValueOrder = {},
        },
    },
};

function onInit()
	LibraryData.setCustomFilterHandler("item_isidentified", getItemIsIdentified);
	
    LibraryData.setCustomFilterHandler("item_isdefense", isDefense);
	LibraryData.setCustomFilterHandler("item_ismeleeweapon", isMeleeWeapon);
	LibraryData.setCustomFilterHandler("item_israngedweapon", isRangedWeapon);

	LibraryData.overrideRecordTypes(aRecordOverrides);
	LibraryData.setRecordViews(aListViews);
end
