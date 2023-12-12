-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

local rsname = "GURPS";

function onInit()
	if Session.IsHost then
		updateCampaign();
	end

	DB.addEventHandler("onAuxCharLoad", onCharImport);
	DB.addEventHandler("onImport", onImport);
--	Module.addEventHandler("onModuleLoad", onModuleLoad);
end

function onCharImport(nodePC)
	local _, _, aMajor, _ = DB.getImportRulesetVersion();
	updateChar(nodePC, aMajor[rsname]);
end

function onImport(node)
	local aPath = StringManager.split(node.getNodeName(), ".");
	if #aPath == 2 and aPath[1] == "charsheet" then
		local _, _, aMajor, _ = DB.getImportRulesetVersion();
		updateChar(node, aMajor[rsname]);
	end
end

--function onModuleLoad(sModule)
--	local _, _, aMajor, _ = DB.getRulesetVersion(sModule);
--	updateModule(sModule, aMajor[rsname]);
--end

function updateChar(nodePC, nVersion)
	if not nVersion then
		nVersion = 0;
	end

	if nVersion < 3 then
		migrateChar3(nodePC);
	end
    if nVersion < 4 then
        migrateChar4(nodePC);
    end
    if nVersion < 5 then
        migrateChar5(nodePC);
    end
    if nVersion < 6 then
        migrateChar6(nodePC);
    end
    if nVersion < 7 then
        migrateChar7(nodePC);
    end
    if nVersion < 8 then
        migrateChar8(nodePC);
    end
    if nVersion < 9 then
        migrateChar9(nodePC);
    end
    if nVersion < 10 then
        migrateChar10(nodePC);
    end
end

function updateCampaign()
	local _, _, aMajor, aMinor = DB.getRulesetVersion();
	local major = aMajor[rsname];
	if not major then
		return;
	end
	if major > 0 and major < 10 then
		print("Migrating campaign database to latest data version. (" .. rsname ..")");
		DB.backup();
		
	    if major < 3 then
		    convertChars3();
	    end
        if major < 4 then
          convertChars4();
        end
        if major < 5 then
          convertChars5();
        end
        if major < 6 then
          convertChars6();
        end
        if major < 7 then
          convertChars7();
        end
        if major < 8 then
          convertChars8();
        end
        if major < 9 then
          convertChars9();
        end
        if major < 10 then
          convertChars10();
        end
	end
end

--function updateModule(sModule, nVersion)
--	if not nVersion then
--		nVersion = 0;
--	end
--	
--	local nodeRoot = DB.getRoot(sModule);
--	if nVersion < 10 then
--		convertPregenCharacters10(nodeRoot);
--	end
--end

function convertChars3()
  for _,nodeChar in ipairs(DB.getChildList("charsheet")) do
    migrateChar3(nodeChar);
  end
end

function convertChars4()
  for _,nodeChar in ipairs(DB.getChildList("charsheet")) do
    migrateChar4(nodeChar);
  end
end

function convertChars5()
  for _,nodeChar in ipairs(DB.getChildList("charsheet")) do
    migrateChar5(nodeChar);
  end
end

function convertChars6()
  for _,nodeChar in ipairs(DB.getChildList("charsheet")) do
    migrateChar6(nodeChar);
  end
end

function convertChars7()
  for _,nodeChar in ipairs(DB.getChildList("charsheet")) do
    migrateChar7(nodeChar);
  end
end

function convertChars8()
  for _,nodeChar in ipairs(DB.getChildList("charsheet")) do
    migrateChar8(nodeChar);
  end
end

function convertChars9()
  for _,nodeChar in ipairs(DB.getChildList("charsheet")) do
    migrateChar9(nodeChar);
  end
end

function convertChars10()
  for _,nodeChar in ipairs(DB.getChildList("charsheet")) do
    migrateChar10(nodeChar);
  end
end

--function convertPregenCharacters10(nodeRoot)
--	for _,nodeChar in ipairs(DB.getChildList(nodeRoot, "pregencharsheet")) do
--		migrateChar10(nodeChar);
--	end
--end

function migrateChar3(nodeChar)
  if DB.getChild(nodeChar, "stats") then
    DB.setValue(nodeChar, "attributes.strength", "number", DB.getValue(nodeChar, "stats.strength", 0));
    DB.setValue(nodeChar, "attributes.strength_points", "number", DB.getValue(nodeChar, "stats.strength_points", 0));
    DB.setValue(nodeChar, "attributes.dexterity", "number", DB.getValue(nodeChar, "stats.dexterity", 0));
    DB.setValue(nodeChar, "attributes.dexterity_points", "number", DB.getValue(nodeChar, "stats.dexterity_points", 0));
    DB.setValue(nodeChar, "attributes.intelligence", "number", DB.getValue(nodeChar, "stats.intelligence", 0));
    DB.setValue(nodeChar, "attributes.intelligence_points", "number", DB.getValue(nodeChar, "stats.intelligence_points", 0));
    DB.setValue(nodeChar, "attributes.health", "number", DB.getValue(nodeChar, "stats.health", 0));
    DB.setValue(nodeChar, "attributes.health_points", "number", DB.getValue(nodeChar, "stats.health_points", 0));
    DB.setValue(nodeChar, "attributes.hps", "number", DB.getValue(nodeChar, "stats.hps", 0));
    DB.setValue(nodeChar, "attributes.hps_points", "number", DB.getValue(nodeChar, "stats.hps_points", 0));
    DB.setValue(nodeChar, "attributes.will", "number", DB.getValue(nodeChar, "stats.will", 0));
    DB.setValue(nodeChar, "attributes.will_points", "number", DB.getValue(nodeChar, "stats.will_points", 0));
    DB.setValue(nodeChar, "attributes.perception", "number", DB.getValue(nodeChar, "stats.perception", 0));
    DB.setValue(nodeChar, "attributes.perception_points", "number", DB.getValue(nodeChar, "stats.perception_points", 0));
    DB.setValue(nodeChar, "attributes.fps", "number", DB.getValue(nodeChar, "stats.fps", 0));
    DB.setValue(nodeChar, "attributes.fps_points", "number", DB.getValue(nodeChar, "stats.fps_points", 0));

    DB.setValue(nodeChar, "attributes.basiclift", "string", DB.getValue(nodeChar, "stats.basic_lift", ""));
    DB.setValue(nodeChar, "attributes.basicspeed", "string", DB.getValue(nodeChar, "stats.speed", ""));
    DB.setValue(nodeChar, "attributes.basicspeed_points", "number", DB.getValue(nodeChar, "stats.speed_points", 0));
    DB.setValue(nodeChar, "attributes.basicmove", "string", DB.getValue(nodeChar, "stats.move", ""));
    DB.setValue(nodeChar, "attributes.basicmove_points", "number", DB.getValue(nodeChar, "stats.move_points", 0));

    DB.setValue(nodeChar, "attributes.swing", "string", DB.getValue(nodeChar, "stats.swing", ""));
    DB.setValue(nodeChar, "attributes.thrust", "string", DB.getValue(nodeChar, "stats.thrust", ""));

    DB.setValue(nodeChar, "attributes.current_hps", "number", DB.getValue(nodeChar, "stats.current_hps", 0));
    DB.setValue(nodeChar, "attributes.current_fps", "number", DB.getValue(nodeChar, "stats.current_fps", 0));
    DB.setValue(nodeChar, "attributes.current_move", "string", "");

    DB.setValue(nodeChar, "combat.block", "number", DB.getValue(nodeChar, "stats.block", 0));
    DB.setValue(nodeChar, "combat.block_notes", "string", DB.getValue(nodeChar, "stats.block_notes", 0));
    DB.setValue(nodeChar, "combat.parry", "number", DB.getValue(nodeChar, "stats.parry", 0));
    DB.setValue(nodeChar, "combat.parry_notes", "string", DB.getValue(nodeChar, "stats.parry_notes", 0));
    DB.setValue(nodeChar, "combat.dr", "string", DB.getValue(nodeChar, "stats.dr_torso", ""));

    DB.deleteChild(nodeChar, "stats");
  end

  -- Convert Enc/Dodge 
  if DB.getChild(nodeChar, "encumbrance") then

    DB.setValue(nodeChar, "encumbrance.enc_0", "number", DB.getValue(nodeChar, "enc_0", 0));
    DB.setValue(nodeChar, "encumbrance.enc_1", "number", DB.getValue(nodeChar, "enc_1", 0));
    DB.setValue(nodeChar, "encumbrance.enc_2", "number", DB.getValue(nodeChar, "enc_2", 0));
    DB.setValue(nodeChar, "encumbrance.enc_3", "number", DB.getValue(nodeChar, "enc_3", 0));
    DB.setValue(nodeChar, "encumbrance.enc_4", "number", DB.getValue(nodeChar, "enc_4", 0));

    DB.deleteChild(nodeChar, "enc_0");
    DB.deleteChild(nodeChar, "enc_1");
    DB.deleteChild(nodeChar, "enc_2");
    DB.deleteChild(nodeChar, "enc_3");
    DB.deleteChild(nodeChar, "enc_4");
  
    local nDodge0 = DB.getValue(nodeChar, "encumbrance.enc0_dodge", 0);
    local nDodge1 = DB.getValue(nodeChar, "encumbrance.enc1_dodge", 0);
    local nDodge2 = DB.getValue(nodeChar, "encumbrance.enc2_dodge", 0);
    local nDodge3 = DB.getValue(nodeChar, "encumbrance.enc3_dodge", 0);
    local nDodge4 = DB.getValue(nodeChar, "encumbrance.enc4_dodge", 0);

    DB.deleteChild(nodeChar, "encumbrance.enc0_dodge");
    DB.deleteChild(nodeChar, "encumbrance.enc1_dodge");
    DB.deleteChild(nodeChar, "encumbrance.enc2_dodge");
    DB.deleteChild(nodeChar, "encumbrance.enc3_dodge");
    DB.deleteChild(nodeChar, "encumbrance.enc4_dodge");

    DB.setValue(nodeChar, "encumbrance.enc0_dodge", "number", nDodge0);
    DB.setValue(nodeChar, "encumbrance.enc1_dodge", "number", nDodge1);
    DB.setValue(nodeChar, "encumbrance.enc2_dodge", "number", nDodge2);
    DB.setValue(nodeChar, "encumbrance.enc3_dodge", "number", nDodge3);
    DB.setValue(nodeChar, "encumbrance.enc4_dodge", "number", nDodge4);
  end

  -- Convert General Traits 
  if DB.getChild(nodeChar, "general") then
    DB.setValue(nodeChar, "traits.race", "string", DB.getValue(nodeChar, "general.race", ""));
    DB.setValue(nodeChar, "traits.age", "string", DB.getValue(nodeChar, "general.age", ""));
    DB.setValue(nodeChar, "traits.height", "string", DB.getValue(nodeChar, "general.height", ""));
    DB.setValue(nodeChar, "traits.weight", "string", DB.getValue(nodeChar, "general.weight", ""));
    DB.setValue(nodeChar, "traits.sizemodifier", "string", DB.getValue(nodeChar, "general.size_modifier", ""));
    DB.setValue(nodeChar, "traits.appearance", "string", DB.getValue(nodeChar, "general.appearance", ""));
    DB.setValue(nodeChar, "traits.tl", "string", DB.getValue(nodeChar, "general.tl_score", ""));
    DB.setValue(nodeChar, "traits.tl_points", "number", DB.getValue(nodeChar, "general.tl_points", 0));

    DB.setValue(nodeChar, "description", "string", DB.getValue(nodeChar, "general.description", ""));

    DB.setValue(nodeChar, "traits.reactionmodifiers", "string", DB.getValue(nodeChar, "general.reaction_modifiers", ""));

    if DB.getValue(nodeChar, "general.notes", "") ~= "" then
      local nodeNew = DB.createChild(DB.createChild(nodeChar, "notelist"));
      DB.setValue(nodeNew, "name", "string", "Imported Note");
      DB.setValue(nodeNew, "text", "string", DB.getValue(nodeChar, "general.notes", ""));
    end

    DB.deleteChild(nodeChar, "general");
  end

  -- Convert Languages
  if DB.getChild(nodeChar, "adslist") then
    local nodeLang = DB.createChild(nodeChar, "traits.languagelist");
    for _,nodeOld in pairs(DB.getChildren(nodeChar, "languagelist")) do
      local nodeNew = DB.createChild(nodeLang);
      DB.setValue(nodeNew, "name", "string", DB.getValue(nodeOld,"language_name",""));
      DB.setValue(nodeNew, "spoken", "string", DB.getValue(nodeOld,"language_spoken",""));
      DB.setValue(nodeNew, "written", "string", DB.getValue(nodeOld,"language_written",""));
      DB.setValue(nodeNew, "points", "number", DB.getValue(nodeOld,"language_points",0));
    end
    
    DB.deleteChild(nodeChar, "languagelist");
  end

  -- Convert Cultural Familiarities
  if DB.getChild(nodeChar, "culturelist") then
    local nodeCF = DB.createChild(nodeChar, "traits.culturalfamiliaritylist");
    for _,nodeOld in pairs(DB.getChildren(nodeChar, "culturelist")) do
      local nodeNew = DB.createChild(nodeCF);
      DB.setValue(nodeNew, "name", "string", DB.getValue(nodeOld,"culture_name",""));
      DB.setValue(nodeNew, "points", "number", DB.getValue(nodeOld,"culture_points",0));
    end
    
    DB.deleteChild(nodeChar, "culturelist");
  end

  -- Convert Advantages
  if DB.getChild(nodeChar, "adslist") then
    local nodeAds = DB.createChild(nodeChar, "traits.adslist");
    for _,nodeOld in pairs(DB.getChildren(nodeChar, "adslist")) do
      local nodeNew = DB.createChild(nodeAds);
      DB.setValue(nodeNew, "name", "string", DB.getValue(nodeOld,"trait_name",""));
      DB.setValue(nodeNew, "points", "number", DB.getValue(nodeOld,"trait_points",0));
    end
    
    DB.deleteChild(nodeChar, "adslist");
  end

  -- Convert Disadvantages
  if DB.getChild(nodeChar, "disadslist") then
    local nodeDisads = DB.createChild(nodeChar, "traits.disadslist");
    for _,nodeOld in pairs(DB.getChildren(nodeChar, "disadslist")) do
      local nodeNew = DB.createChild(nodeDisads);
      DB.setValue(nodeNew, "name", "string", DB.getValue(nodeOld,"trait_name",""));
      DB.setValue(nodeNew, "points", "number", DB.getValue(nodeOld,"trait_points",0));
    end
    
    DB.deleteChild(nodeChar, "disadslist");
  end

  -- Convert Skills
	if DB.getChild(nodeChar, "skilllist") then
    local nodeSkills = DB.createChild(nodeChar, "abilities.skilllist");
    for _,nodeOld in pairs(DB.getChildren(nodeChar, "skilllist")) do
      local nodeNew = DB.createChild(nodeSkills);
      DB.setValue(nodeNew, "name", "string", DB.getValue(nodeOld,"skill_name",""));
      DB.setValue(nodeNew, "level", "number", DB.getValue(nodeOld,"skill_level",0));
      DB.setValue(nodeNew, "type", "string", DB.getValue(nodeOld,"skill_type",""));
      DB.setValue(nodeNew, "relativelevel", "string", DB.getValue(nodeOld,"skill_relative_level",""));
      DB.setValue(nodeNew, "points", "number", DB.getValue(nodeOld,"skill_points",0));
    end
    
    DB.deleteChild(nodeChar, "skilllist");
	end

  -- Convert Spells
  if DB.getChild(nodeChar, "spelllist") then
    local nodeSpells = DB.createChild(nodeChar, "abilities.spelllist");
    for _,nodeOld in pairs(DB.getChildren(nodeChar, "spelllist")) do
      local nodeNew = DB.createChild(nodeSpells);
      DB.setValue(nodeNew, "name", "string", DB.getValue(nodeOld,"skill_name",""));
      DB.setValue(nodeNew, "level", "number", DB.getValue(nodeOld,"skill_level",0));
      DB.setValue(nodeNew, "type", "string", DB.getValue(nodeOld,"skill_type",""));
      DB.setValue(nodeNew, "points", "number", DB.getValue(nodeOld,"skill_points",0));
    end
    
    DB.deleteChild(nodeChar, "spelllist");
  end

  -- Convert Powers
  if DB.getChild(nodeChar, "powerlist") then
    local nodePowers = DB.createChild(nodeChar, "abilities.powerlist");
    for _,nodeOld in pairs(DB.getChildren(nodeChar, "powerlist")) do
      local nodeNew = DB.createChild(nodePowers);
      DB.setValue(nodeNew, "name", "string", DB.getValue(nodeOld,"power_name",""));
      DB.setValue(nodeNew, "points", "number", DB.getValue(nodeOld,"power_points",0));
    end
    
    DB.deleteChild(nodeChar, "powerlist");
  end

  -- Convert Melee Combat
  if DB.getChild(nodeChar, "handweaponlist") then
    local nodeWeapon = DB.createChild(nodeChar, "combat.meleecombatlist");
    for _,nodeOld in pairs(DB.getChildren(nodeChar, "handweaponlist")) do

      -- Check if exists    
      local nodeNew = nil;
      for _,nodeExisting in pairs(DB.getChildren(nodeChar, "combat.meleecombatlist")) do
        if DB.getValue(nodeOld,"handweapon_name") == DB.getValue(nodeExisting,"name") then
          nodeNew = nodeExisting;
          break;
        end
      end 
      
      if nodeNew == nil then
        local sName = "";
        if DB.getValue(nodeOld,"handweapon_name","") ~= "" then
          sName = DB.getValue(nodeOld,"handweapon_name",""); 
        elseif DB.getValue(nodeOld,"handweapon_mode","") ~= "" then
          sName = DB.getValue(nodeOld,"handweapon_mode","");
        end
        
        if sName ~= "" then 
          nodeNew = DB.createChild(nodeWeapon);
          DB.setValue(nodeNew, "name", "string", sName);
          DB.setValue(nodeNew, "text", "string", DB.getValue(nodeOld,"handweapon_notes",""));
          DB.setValue(nodeNew, "st", "string", DB.getValue(nodeOld,"handweapon_ST",""));
          DB.setValue(nodeNew, "weight", "string", DB.getValue(nodeOld,"handweapon_weight",""));
          DB.setValue(nodeNew, "cost", "string", DB.getValue(nodeOld,"handweapon_cost",""));
        end
      end
      
      if nodeNew ~= nil then
        nodeMode = DB.createChild(DB.createChild(nodeNew,"meleemodelist"));
        DB.setValue(nodeMode, "name", "string", DB.getValue(nodeOld,"handweapon_mode",""));
        DB.setValue(nodeMode, "level", "number", DB.getValue(nodeOld,"handweapon_skilllevel",0));
        DB.setValue(nodeMode, "damage", "string", DB.getValue(nodeOld,"handweapon_damage",""));
        DB.setValue(nodeMode, "reach", "string", DB.getValue(nodeOld,"handweapon_reach",""));
        DB.setValue(nodeMode, "parry", "string", DB.getValue(nodeOld,"handweapon_parry",""));
      end
    end
    
    DB.deleteChild(nodeChar, "handweaponlist");
  end

  -- Convert Ranged Combat
  if DB.getChild(nodeChar, "rangedweaponlist") then
    local nodeWeapon = DB.createChild(nodeChar, "combat.rangedcombatlist");
    for _,nodeOld in pairs(DB.getChildren(nodeChar, "rangedweaponlist")) do

      -- Check if exists    
      local nodeNew = nil;
      for _,nodeExisting in pairs(DB.getChildren(nodeChar, "combat.rangedcombatlist")) do
        if DB.getValue(nodeOld,"rangedweapon_name") == DB.getValue(nodeExisting,"name") then
          nodeNew = nodeExisting;
          break;
        end
      end 
      
      if nodeNew == nil then
        local sName = "";
        if DB.getValue(nodeOld,"rangedweapon_name","") ~= "" then
          sName = DB.getValue(nodeOld,"rangedweapon_name",""); 
        elseif DB.getValue(nodeOld,"rangedweapon_name_mode","") ~= "" then
          sName = DB.getValue(nodeOld,"rangedweapon_name_mode","");
        elseif DB.getValue(nodeOld,"rangedweapon_mode","") ~= "" then
          sName = DB.getValue(nodeOld,"rangedweapon_mode","");
        end
        
        if sName ~= "" then 
          nodeNew = DB.createChild(nodeWeapon);
          DB.setValue(nodeNew, "name", "string", sName);
          DB.setValue(nodeNew, "text", "string", DB.getValue(nodeOld,"rangedweapon_notes",""));
          DB.setValue(nodeNew, "st", "string", DB.getValue(nodeOld,"rangedweapon_ST",""));
          DB.setValue(nodeNew, "bulk", "number", tonumber(DB.getValue(nodeOld,"rangedweapon_bulk","0")));
          DB.setValue(nodeNew, "weight", "string", DB.getValue(nodeOld,"rangedweapon_weight",""));
          DB.setValue(nodeNew, "cost", "string", DB.getValue(nodeOld,"rangedweapon_cost",""));
          DB.setValue(nodeNew, "lc", "string", DB.getValue(nodeOld,"rangedweapon_lc",""));
        end
      end
      
      if nodeNew ~= nil then
        nodeMode = DB.createChild(DB.createChild(nodeNew,"rangedmodelist"));
        DB.setValue(nodeMode, "name", "string", DB.getValue(nodeOld,"rangedweapon_name_mode",""));
        DB.setValue(nodeMode, "level", "number", tonumber(DB.getValue(nodeOld,"rangedweapon_skilllevel","0")));
        DB.setValue(nodeMode, "damage", "string", DB.getValue(nodeOld,"rangedweapon_damage",""));
        DB.setValue(nodeMode, "acc", "number", tonumber(DB.getValue(nodeOld,"rangedweapon_acc",0)));
        DB.setValue(nodeMode, "range", "string", DB.getValue(nodeOld,"rangedweapon_range",""));
        DB.setValue(nodeMode, "rof", "string", DB.getValue(nodeOld,"rangedweapon_rof",0));
        DB.setValue(nodeMode, "shots", "string", DB.getValue(nodeOld,"rangedweapon_shots",""));
        DB.setValue(nodeMode, "rcl", "number", tonumber(DB.getValue(nodeOld,"rangedweapon_recoil",0)));
      end
    end
    
    DB.deleteChild(nodeChar, "rangedweaponlist");
  end

  -- Convert DR
  if DB.getChild(nodeChar, "DRlist") then
    local nodeProtection = DB.createChild(nodeChar, "combat.protectionlist");
    for _,nodeOld in pairs(DB.getChildren(nodeChar, "DRlist")) do
      local nodeNew = DB.createChild(nodeProtection);
      DB.setValue(nodeNew, "dr", "string", DB.getValue(nodeOld,"DR_score",0));
      DB.setValue(nodeNew, "location", "string", DB.getValue(nodeOld,"DR_location",""));
    end
    
    DB.deleteChild(nodeChar, "DRlist");
  end

  -- Convert Inventory
  if DB.getChild(nodeChar, "inventorylist") then
    for _,nodeInv in pairs(DB.getChildren(nodeChar, "inventorylist")) do
      
      local nQty = tonumber(DB.getValue(nodeInv,"inventory_quantity",0))
      local nWeight = tonumber(DB.getValue(nodeInv,"inventory_weight",0));
      local nCost = tonumber(DB.getValue(nodeInv,"inventory_cost","0"));
      
      if nQty ~= 0 and nQty ~= nil then
        nWeight = nWeight / nQty;
        nCost = nCost / nQty;
      end
      
      DB.setValue(nodeInv, "name", "string", DB.getValue(nodeInv,"inventory_name",""));
      DB.setValue(nodeInv, "weight", "number", nWeight);
      DB.setValue(nodeInv, "count", "number", nQty);
      DB.setValue(nodeInv, "location", "string", DB.getValue(nodeInv,"inventory_location",""));
      DB.setValue(nodeInv, "cost", "string", nCost);
      
      DB.deleteChild(nodeInv,"inventory_name");      
      DB.deleteChild(nodeInv,"inventory_weight");      
      DB.deleteChild(nodeInv,"inventory_quantity");      
      DB.deleteChild(nodeInv,"inventory_location");      
      DB.deleteChild(nodeInv,"inventory_cost");      
    end
  end
	
	-- Calculations Move/Dodge
	if DB.getValue(nodeChar, "encumbrance.enc_0", 0) == 1 then
    DB.setValue(nodeChar, "attributes.current_move", "string", DB.getValue(nodeChar, "encumbrance.enc0_move", "")); 
    DB.setValue(nodeChar, "combat.dodge", "number", DB.getValue(nodeChar, "encumbrance.enc0_dodge", 0)); 
  elseif DB.getValue(nodeChar, "encumbrance.enc_1", 0) == 1 then
    DB.setValue(nodeChar, "attributes.current_move", "string", DB.getValue(nodeChar, "encumbrance.enc1_move", "")); 
    DB.setValue(nodeChar, "combat.dodge", "number", DB.getValue(nodeChar, "encumbrance.enc1_dodge", 0)); 
  elseif DB.getValue(nodeChar, "encumbrance.enc_2", 0) == 1 then
    DB.setValue(nodeChar, "attributes.current_move", "string", DB.getValue(nodeChar, "encumbrance.enc2_move", "")); 
    DB.setValue(nodeChar, "combat.dodge", "number", DB.getValue(nodeChar, "encumbrance.enc2_dodge", 0)); 
  elseif DB.getValue(nodeChar, "encumbrance.enc_3", 0) == 1 then
    DB.setValue(nodeChar, "attributes.current_move", "string", DB.getValue(nodeChar, "encumbrance.enc3_move", "")); 
    DB.setValue(nodeChar, "combat.dodge", "number", DB.getValue(nodeChar, "encumbrance.enc3_dodge", 0)); 
  elseif DB.getValue(nodeChar, "encumbrance.enc_4", 0) == 1 then
    DB.setValue(nodeChar, "attributes.current_move", "string", DB.getValue(nodeChar, "encumbrance.enc4_move", "")); 
    DB.setValue(nodeChar, "combat.dodge", "number", DB.getValue(nodeChar, "encumbrance.enc4_dodge", 0)); 
	end
	
	
  -- Convert Point Total 
  if DB.getChild(nodeChar, "points_cost_totals") then
    DB.setValue(nodeChar, "pointtotals.attributes", "number", DB.getValue(nodeChar, "points_cost_totals.total_stats_points", 0));
    DB.setValue(nodeChar, "pointtotals.ads", "number", DB.getValue(nodeChar, "points_cost_totals.total_ads_points", 0));
    DB.setValue(nodeChar, "pointtotals.disads", "number", DB.getValue(nodeChar, "points_cost_totals.total_disads_points", 0));
    DB.setValue(nodeChar, "pointtotals.quirks", "number", DB.getValue(nodeChar, "points_cost_totals.total_quirks_points", 0));
    DB.setValue(nodeChar, "pointtotals.skills", "number", DB.getValue(nodeChar, "points_cost_totals.total_skills_points", 0));
    DB.setValue(nodeChar, "pointtotals.spells", "number", DB.getValue(nodeChar, "points_cost_totals.total_spells_points", 0));
    DB.setValue(nodeChar, "pointtotals.powers", "number", DB.getValue(nodeChar, "points_cost_totals.total_powers_points", 0));
    DB.setValue(nodeChar, "pointtotals.others", "number", 0);
    DB.setValue(nodeChar, "pointtotals.totalpoints", "number", DB.getValue(nodeChar, "points_cost_totals.total_points", 0));
    DB.setValue(nodeChar, "pointtotals.unspent", "number", DB.getValue(nodeChar, "points_cost_totals.unspent_points", 0));

    DB.deleteChild(nodeChar, "points_cost_totals");
  end
	
  -- Cleanup
  DB.deleteChild(nodeChar, "use_powers");
  DB.deleteChild(nodeChar, "points_visible");
  DB.deleteChild(nodeChar, "disclaimer_link");
end

function migrateChar4(nodeChar)
  -- Convert Hit Points/HPS 
  if DB.getChild(nodeChar, "attributes") then

    DB.setValue(nodeChar, "attributes.hitpoints", "number", DB.getValue(nodeChar, "attributes.hps", 0));
    DB.setValue(nodeChar, "attributes.hitpoints_points", "number", DB.getValue(nodeChar, "attributes.hps_points", 0));
    DB.setValue(nodeChar, "attributes.fatiguepoints", "number", DB.getValue(nodeChar, "attributes.fps", 0));
    DB.setValue(nodeChar, "attributes.fatiguepoints_points", "number", DB.getValue(nodeChar, "attributes.fps_points", 0));

    DB.deleteChild(nodeChar, "attributes.hps");
    DB.deleteChild(nodeChar, "attributes.hps_points");
    DB.deleteChild(nodeChar, "attributes.fps");
    DB.deleteChild(nodeChar, "attributes.fps_points");
  
    DB.setValue(nodeChar, "attributes.hps", "number", DB.getValue(nodeChar, "attributes.current_hps", 0));
    DB.setValue(nodeChar, "attributes.fps", "number", DB.getValue(nodeChar, "attributes.current_fps", 0));
    DB.setValue(nodeChar, "attributes.move", "string", DB.getValue(nodeChar, "attributes.current_move", ""));

    DB.deleteChild(nodeChar, "attributes.current_hps");
    DB.deleteChild(nodeChar, "attributes.current_fps");
    DB.deleteChild(nodeChar, "attributes.current_move");
  end
end

function migrateChar5(nodeChar)
  -- Convert General Notes
  if DB.getChild(nodeChar, "notelist") then
    for _,nodeOld in pairs(DB.getChildren(nodeChar, "notelist")) do
      local nodeValue = DB.getValue(nodeOld,"text","");
      DB.deleteChild(nodeOld, "text");
      DB.setValue(nodeOld, "text", "formattedtext", nodeValue);
    end
  end

  -- Convert Advantages
  if DB.getChild(nodeChar, "traits.adslist") then
    for _,nodeOld in pairs(DB.getChildren(nodeChar, "traits.adslist")) do
      local nodeValue = DB.getValue(nodeOld,"text","");
      DB.deleteChild(nodeOld, "text");
      DB.setValue(nodeOld, "text", "formattedtext", nodeValue);
    end
  end

  -- Convert Disadvantages
  if DB.getChild(nodeChar, "traits.disadslist") then
    for _,nodeOld in pairs(DB.getChildren(nodeChar, "traits.disadslist")) do
      local nodeValue = DB.getValue(nodeOld,"text","");
      DB.deleteChild(nodeOld, "text");
      DB.setValue(nodeOld, "text", "formattedtext", nodeValue);
    end
  end

  -- Convert Skills
  if DB.getChild(nodeChar, "abilities.skilllist") then
    for _,nodeOld in pairs(DB.getChildren(nodeChar, "abilities.skilllist")) do
      local nodeValue = DB.getValue(nodeOld,"text","");
      DB.deleteChild(nodeOld, "text");
      DB.setValue(nodeOld, "text", "formattedtext", nodeValue);
    end
  end

  -- Convert Spells
  if DB.getChild(nodeChar, "abilities.spelllist") then
    for _,nodeOld in pairs(DB.getChildren(nodeChar, "abilities.spelllist")) do
      local nodeValue = DB.getValue(nodeOld,"text","");
      DB.deleteChild(nodeOld, "text");
      DB.setValue(nodeOld, "text", "formattedtext", nodeValue);
    end
  end

  -- Convert Powers
  if DB.getChild(nodeChar, "abilities.powerlist") then
    for _,nodeOld in pairs(DB.getChildren(nodeChar, "abilities.powerlist")) do
      local nodeValue = DB.getValue(nodeOld,"text","");
      DB.deleteChild(nodeOld, "text");
      DB.setValue(nodeOld, "text", "formattedtext", nodeValue);
    end
  end

  -- Convert Others
  if DB.getChild(nodeChar, "abilities.otherlist") then
    for _,nodeOld in pairs(DB.getChildren(nodeChar, "abilities.otherlist")) do
      local nodeValue = DB.getValue(nodeOld,"text","");
      DB.deleteChild(nodeOld, "text");
      DB.setValue(nodeOld, "text", "formattedtext", nodeValue);
    end
  end

  -- Convert Melee Combat
  if DB.getChild(nodeChar, "combat.meleecombatlist") then
    for _,nodeOld in pairs(DB.getChildren(nodeChar, "combat.meleecombatlist")) do
      local nodeValue = DB.getValue(nodeOld,"text","");
      DB.deleteChild(nodeOld, "text");
      DB.setValue(nodeOld, "text", "formattedtext", nodeValue);
    end
  end

  -- Convert Ranged Combat
  if DB.getChild(nodeChar, "combat.rangedcombatlist") then
    for _,nodeOld in pairs(DB.getChildren(nodeChar, "combat.rangedcombatlist")) do
      local nodeValue = DB.getValue(nodeOld,"text","");
      DB.deleteChild(nodeOld, "text");
      DB.setValue(nodeOld, "text", "formattedtext", nodeValue);
    end
  end

  -- Convert Protection
  if DB.getChild(nodeChar, "combat.protectionlist") then
    for _,nodeOld in pairs(DB.getChildren(nodeChar, "combat.protectionlist")) do
      local nodeValue = DB.getValue(nodeOld,"text","");
      DB.deleteChild(nodeOld, "text");
      DB.setValue(nodeOld, "text", "formattedtext", nodeValue);
    end
  end
end

function migrateChar6(nodeChar)
  -- Convert Protection to Defenses
  if DB.getChild(nodeChar, "combat.protectionlist") then
    local nodeDefenses = DB.createChild(nodeChar, "combat.defenseslist");
    for _,nodeOld in pairs(DB.getChildren(nodeChar, "combat.protectionlist")) do
      local nodeNew = DB.createChild(nodeDefenses);
      DB.setValue(nodeNew, "name", "string", DB.getValue(nodeOld,"name",""));
      DB.setValue(nodeNew, "db", "number", DB.getValue(nodeOld,"db",0));
      DB.setValue(nodeNew, "dr", "string", DB.getValue(nodeOld,"dr",""));
      DB.setValue(nodeNew, "locations", "string", DB.getValue(nodeOld,"location",""));
      DB.setValue(nodeNew, "text", "formattedtext", DB.getValue(nodeOld,"text",""));
    end
   
    DB.deleteChild(nodeChar, "combat.protectionlist");
  end
end

function migrateChar7(nodeChar)
  -- Identify Inventory
  if DB.getChild(nodeChar, "inventorylist") then
    for _,nodeInv in pairs(DB.getChildren(nodeChar, "inventorylist")) do
      DB.setValue(nodeInv, "isidentified", "number", 1);
    end
  end
end

function migrateChar8(nodeChar)
  if DB.getChild(nodeChar, "attributes") then
    local nInjury = DB.getValue(nodeChar, "attributes.hitpoints",  0) - DB.getValue(nodeChar, "attributes.hps",  0);
    local nFatigue = DB.getValue(nodeChar, "attributes.fatiguepoints",  0) - DB.getValue(nodeChar, "attributes.fps",  0);
    DB.setValue(nodeChar, "attributes.injury", "number", (nInjury < 0 and 0 or nInjury));
    DB.setValue(nodeChar, "attributes.fatigue", "number", (nFatigue < 0 and 0 or nFatigue));
  end
end

function migrateChar9(nodeChar)
  -- adjust existing skills and spells to take into accunt the existance of the new bonus levels feature.
  if DB.getChild(nodeChar, "abilities.skilllist") then
    for _,nodeOld in pairs(DB.getChildren(nodeChar, "abilities.skilllist")) do
      local totalCP = DB.getValue(nodeOld, "points", 0);
      local abilityName = DB.getValue(nodeOld, "name", "");
      local abilityType = DB.getValue(nodeOld, "type", "");
      local desiredLevel = DB.getValue(nodeOld, "level", 0);
      local defaultsLine = DB.getValue(nodeOld, "defaults", "");
      local level_adjust = DB.getValue(nodeOld, "level_adj", 0);
      local abilityInfo = CharAbilityManager.calculateAbilityInfo(nodeChar, abilityType, totalCP, abilityName, defaultsLine, level_adjust);
      if abilityInfo then
        DB.setValue(nodeOld, "basis", "string", abilityInfo.basis);
        if abilityInfo.level ~= desiredLevel then
          DB.setValue(nodeOld, "level_adj", "number", desiredLevel - abilityInfo.level);
        end
      end
    end
  end

  -- Convert Spells
  if DB.getChild(nodeChar, "abilities.spelllist") then
    for _,nodeOld in pairs(DB.getChildren(nodeChar, "abilities.spelllist")) do
      local totalCP = DB.getValue(nodeOld, "points", 0);
      local abilityName = DB.getValue(nodeOld, "name", "");
      local abilityType = DB.getValue(nodeOld, "type", "");
      local desiredLevel = DB.getValue(nodeOld, "level", 0);
      local level_adjust = DB.getValue(nodeOld, "level_adj", 0);
      local abilityInfo = CharAbilityManager.calculateAbilityInfo(nodeChar, abilityType, totalCP, abilityName, "", level_adjust);
      if abilityInfo and abilityInfo.level ~= desiredLevel then
        DB.setValue(nodeOld, "level_adj", "number", desiredLevel - abilityInfo.level);
      end
    end
  end
end

function migrateChar10(nodeChar)
  -- Convert Powers
  if DB.getChild(nodeChar, "abilities.powerlist") then
    for _,nodeOld in pairs(DB.getChildren(nodeChar, "abilities.powerlist")) do
        DB.setValue(nodeOld, "level_adj", "number", DB.getValue(nodeOld, "level", 0));
    end
  end

  -- Convert Others
  if DB.getChild(nodeChar, "abilities.otherlist") then
    for _,nodeOld in pairs(DB.getChildren(nodeChar, "abilities.otherlist")) do
        DB.setValue(nodeOld, "otherlevel", "number", DB.getValue(nodeOld, "level", 0));
    end
  end
end
