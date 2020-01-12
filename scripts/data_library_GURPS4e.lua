-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function getItemIsIdentified(vRecord, vDefault)
	return LibraryData.getIDState("item", vRecord, true);
end

function getTypeValue(vNode)
	local v = StringManager.trim(DB.getValue(vNode, "type", ""));
  local sType = v:match("^[^(%s]+");
	if sType then
--    v = StringManager.trim(sType);
    v = StringManager.trim(v);
	end
	v = StringManager.capitalize(v);
	return v;
end


function getItemRecordDisplayClass(vNode)
  local sRecordDisplayClass = "item"
  if vNode then
    local sBasePath, sSecondPath = UtilityManager.getDataBaseNodePathSplit(vNode)
    if sBasePath == "reference" then
      if sSecondPath == "defense" or sSecondPath == "defenses" then
        sRecordDisplayClass = "defense"
      elseif sSecondPath == "meleeweapon" or sSecondPath == "meleeweapons" then
        sRecordDisplayClass = "meleeweapon"
      elseif sSecondPath == "rangedweapon" or sSecondPath == "rangedweapons" then
        sRecordDisplayClass = "rangedweapon"
      end
    end
  end
  return sRecordDisplayClass
end

function getVehicleRecordDisplayClass(vNode)
  local sRecordDisplayClass = "vehicle"
  if vNode then
    local sBasePath, sSecondPath = UtilityManager.getDataBaseNodePathSplit(vNode)
    if sBasePath == "reference" then
      if sSecondPath == "groundvehicle" or sSecondPath == "groundvehicles" then
        sRecordDisplayClass = "groundvehicle"
      elseif sSecondPath == "watercraft" then
        sRecordDisplayClass = "watercraft"
      elseif sSecondPath == "aircraft" then
        sRecordDisplayClass = "aircraft"
      elseif sSecondPath == "spacecraft" then
        sRecordDisplayClass = "spacecraft"
      end
    end
  end
  return sRecordDisplayClass
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

  if (sTypeLower == "defense") or (sTypeLower == "defenses") or (sSubtypeLower == "defense") or (sSubtypeLower == "defenses")then
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

  if (sTypeLower == "melee weapon") or (sTypeLower == "melee weapons") or (sSubtypeLower == "melee weapon") or (sSubtypeLower == "melee weapons") then
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

  if (sTypeLower == "ranged weapon") or (sTypeLower == "ranged weapons") or (sSubtypeLower == "ranged weapon") or (sSubtypeLower == "ranged weapons") then
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

  if (sTypeLower == "ground vehicle") or (sTypeLower == "ground vehicles") then
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

  if (sTypeLower == "watercraft") then
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

  if (sTypeLower == "aircraft") then
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

  if (sTypeLower == "spacecraft") then
    bIsSpacecraft = true;
  end
  
  return bIsSpacecraft, sTypeLower, sSubtypeLower;
end

aRecordOverrides = {
	["npc"] = { 
    aGMListButtons = { "button_npc_letter", "button_npc_type" };
		aCustomFilters = {
      ["Type"] = { sField = "type" },
		},
	},
	["item"] = { 
		fRecordDisplayClass = getItemRecordDisplayClass,
		aRecordDisplayClasses = { "item", "reference.defenses", "reference.meleeweapons", "reference.rangedweapons" },
		aGMListButtons = { "button_item_bytype", "button_item_defenses", "button_item_meleeweapons", "button_item_rangedweapons" };
		aPlayerListButtons = { "button_item_bytype", "button_item_defenses", "button_item_meleeweapons", "button_item_rangedweapons" };
		aCustomFilters = {
			["Type"] = { sField = "type"  },
		},
	},
  ["vehicle"] = { 
    fRecordDisplayClass = getVehicleRecordDisplayClass,
    aRecordDisplayClasses = { "vehicle", "reference.groundvehicle", "reference.watercraft", "reference.aircraft", "reference.spacecraft" },
    aGMListButtons = { "button_vehicle_groundvehicle", "button_vehicle_watercraft", "button_vehicle_aircraft", "button_vehicle_spacecraft" };
    aPlayerListButtons = { "button_vehicle_groundvehicle", "button_vehicle_watercraft", "button_vehicle_aircraft", "button_vehicle_spacecraft" };
    aCustomFilters = {
      ["Type"] = { sField = "type"  },
    },
  },
	
};

aListViews = {
	["npc"] = {
		["byletter"] = {
			sTitleRes = "npc_grouped_title_byletter",
			aColumns = {
				{ sName = "name", sType = "string", sHeadingRes = "npc_grouped_label_name", nWidth=250 },
				{ sName = "pts", sType = "number", sHeadingRes = "npc_grouped_label_pts", sTooltipRe = "npc_grouped_tooltip_pts", bCentered=true },
			},
			aFilters = {},
			aGroups = { { sDBField = "name", nLength = 1 } },
			aGroupValueOrder = { },
		},
		["bytype"] = {
			sTitleRes = "npc_grouped_title_bytype",
			aColumns = {
				{ sName = "name", sType = "string", sHeadingRes = "npc_grouped_label_name", nWidth=250 },
				{ sName = "pts", sType = "number", sHeadingRes = "npc_grouped_label_pts", sTooltipRe = "npc_grouped_tooltip_pts", bCentered=true },
			},
			aFilters = {},
			aGroups = { { sDBField = "type" } },
			aGroupValueOrder = {},
		},
	},
	["item"] = {
    ["bytype"] = {
      sTitleRes = "item_grouped_title_bytype",
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
      aGroupValueOrder = {},
    },
    ["defense"] = {
      sTitleRes = "item_grouped_title_defenses",
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
        { sDBField = "type", vFilterValue = "Defense" }, 
      },
      aGroups = { { sDBField = "subtype" } },
      aGroupValueOrder = {},
    },
		["meleeweapon"] = {
			sTitleRes = "item_grouped_title_meleeweapons",
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
				{ sDBField = "type", vFilterValue = "Melee Weapon" }, 
			},
      aGroups = { { sDBField = "subtype" } },
      aGroupValueOrder = {},
		},
		["rangedweapon"] = {
			sTitleRes = "item_grouped_title_rangedweapons",
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
				{ sDBField = "type", vFilterValue = "Ranged Weapon" }, 
			},
      aGroups = { { sDBField = "subtype" } },
      aGroupValueOrder = {},
		},
	},
  ["vehicle"] = {
    ["groundvehicle"] = {
      sTitleRes = "vehicle_grouped_title_groundvehicle",
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
      aGroups = { { sDBField = "subtype" } },
      aGroupValueOrder = {},
    },
    ["watercraft"] = {
      sTitleRes = "vehicle_grouped_title_watercraft",
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
      aGroups = { { sDBField = "subtype" } },
      aGroupValueOrder = {},
    },
    ["aircraft"] = {
      sTitleRes = "vehicle_grouped_title_aircraft",
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
      aGroups = { { sDBField = "subtype" } },
      aGroupValueOrder = {},
    },
    ["spacecraft"] = {
      sTitleRes = "vehicle_grouped_title_spacecraft",
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
      aGroups = { { sDBField = "subtype" } },
      aGroupValueOrder = {},
    },
  },
};

aDefaultSidebarState = {
  ["gm"] = "charsheet,note,image,story,table,npc,battle,item,treasureparcel,vehicle",
  ["play"] = "charsheet,note,image,story,table,npc,item",
  ["create"] = "charsheet,item",
}

function onInit()
	for kDefSidebar,vDefSidebar in pairs(aDefaultSidebarState) do
		DesktopManager.setDefaultSidebarState(kDefSidebar, vDefSidebar);
	end
	for kRecordType,vRecordType in pairs(aRecordOverrides) do
		LibraryData.overrideRecordTypeInfo(kRecordType, vRecordType);
	end
	for kRecordType,vRecordListViews in pairs(aListViews) do
		for kListView, vListView in pairs(vRecordListViews) do
			LibraryData.setListView(kRecordType, kListView, vListView);
		end
	end
end
