-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	update();
end

function updateControl(sControl, bReadOnly, bForceHide)
	if not self[sControl] then
		return false;
	end
	
  self[sControl].setReadOnly(bReadOnly);
  self[sControl].setVisible(not bForceHide);
  return true;
end

function update()
  local bReadOnly = WindowManager.getReadOnlyState(getDatabaseNode());

  updateControl("dodge", bReadOnly, false);
  updateControl("parry", bReadOnly, false);
  updateControl("block", bReadOnly, false);
  updateControl("dr", bReadOnly, false);
  
  updateControl("meleecombat", bReadOnly, false);
	if bReadOnly then
		if meleecombat_iadd then
		  meleecombat_iadd.setVisible(false);
		end
		if meleecombat_iedit then
			meleecombat_iedit.setValue(0);
			meleecombat_iedit.setVisible(false);
		end
		
		local bShow = (meleecombat.getWindowCount() ~= 0);
		header_meleecombat.setVisible(bShow);
		meleecombat.setVisible(bShow);
	else
		if meleecombat_iadd then
		  meleecombat_iadd.setVisible(true);
		end
		if meleecombat_iedit then
			meleecombat_iedit.setVisible(true);
		end
		header_meleecombat.setVisible(true);
		meleecombat.setVisible(true);
	end
	for _,w in ipairs(meleecombat.getWindows()) do
    w.name.setReadOnly(bReadOnly);
    w.st.setReadOnly(bReadOnly);
    w.weight.setReadOnly(bReadOnly);
    w.update(bReadOnly);
	end

  updateControl("rangedcombat", bReadOnly, false);
  if bReadOnly then
	if rangedcombat_iadd then
	  rangedcombat_iadd.setVisible(false);
	end
    if rangedcombat_iedit then
      rangedcombat_iedit.setValue(0);
      rangedcombat_iedit.setVisible(false);
    end
    
    local bShow = (rangedcombat.getWindowCount() ~= 0);
    header_rangedcombat.setVisible(bShow);
    rangedcombat.setVisible(bShow);
  else
	if rangedcombat_iadd then
	  rangedcombat_iadd.setVisible(true);
	end
    if rangedcombat_iedit then
      rangedcombat_iedit.setVisible(true);
    end
    header_rangedcombat.setVisible(true);
    rangedcombat.setVisible(true);
  end
  for _,w in ipairs(rangedcombat.getWindows()) do
    w.name.setReadOnly(bReadOnly);
    w.st.setReadOnly(bReadOnly);
    w.bulk.setReadOnly(bReadOnly);
    w.ammo.setReadOnly(bReadOnly);
    w.update(bReadOnly);
  end
	
end

function addMeleeCombat(sName, sDesc)
	local w = meleecombat.createWindow();
	if w then
		w.name.setValue(sName);
	end
end

function addRangedCombat(sName, sDesc)
	local w = rangedcombat.createWindow();
	if w then
		w.name.setValue(sName);
	end
end

function onDrop(x, y, draginfo)
	if draginfo.isType("shortcut") then
		local nodeItem = draginfo.getDatabaseNode();
        local nodeNPC = getDatabaseNode();

		if LibraryDataGURPS4e.isMeleeWeapon(nodeItem) then
			bAdded = addMeleeWeapon(nodeNPC, nodeItem);
		end

		if LibraryDataGURPS4e.isRangedWeapon(nodeItem) then
			bAdded = addRangedWeapon(nodeNPC, nodeItem);
		end

	    return true;
	end
end

function hasWeaponModes(nodeItem)
    if DB.getChild(nodeItem, "meleemodelist") or DB.getChild(nodeItem, "rangedmodelist") then 
        return true;
    end
    return false;
end

function addDefense(nodeNPC, nodeItem)
	if not nodeItem then
		return false;
	end

	-- Get the combat list we are going to add to
	local nodeCombat = nodeNPC.createChild("combat.defenseslist");
	if not nodeCombat then
		return false;
	end
	
	-- Determine identification
	local nItemID = 0;
	if LibraryData.getIDState("item", nodeItem, true) then
		nItemID = 1;
	end
	
	-- Grab some information from the source node to populate the new weapon entries
	local sName;
	if nItemID == 1 then
		sName = DB.getValue(nodeItem, "name", "");
	else
		sName = DB.getValue(nodeItem, "nonid_name", "");
		if sName == "" then
			sName = Interface.getString("item_unidentified");
		end
		sName = "** " .. sName .. " **";
	end
	
	-- Create entries
	local nodeCombatItem = nodeCombat.createChild();
	if nodeCombatItem then
		DB.setValue(nodeCombatItem, "isidentified", "number", nItemID);
		DB.setValue(nodeCombatItem, "isHidden", "number", 0);
		DB.setValue(nodeCombatItem, "shortcut", "windowreference", "item", ".....inventorylist." .. nodeItem.getName());

		DB.setValue(nodeCombatItem, "name", "string", sName);
		DB.setValue(nodeCombatItem, "db", "number", tonumber(DB.getValue(nodeItem,"db","0")));
		DB.setValue(nodeCombatItem, "dr", "string", DB.getValue(nodeItem,"dr",""));
		DB.setValue(nodeCombatItem, "locations", "string", DB.getValue(nodeItem,"locations",""));
		DB.setValue(nodeCombatItem, "text", "formattedtext", DB.getValue(nodeItem,"notes",""));   
	end

    return true;
end

function addMeleeWeapon(nodeNPC, nodeItem)
	if not nodeItem or not nodeNPC then
		return false;
	end

	-- Get the combat list we are going to add to
	local nodeChar = nodeItem.getChild("...");
	local nodeCombat = nodeNPC.createChild("combat.meleecombatlist");
	if not nodeCombat then
		return false;
	end
	
	-- Create entries
	local nodeCombatItem = nodeCombat.createChild();
	if nodeCombatItem then
		DB.setValue(nodeCombatItem, "name", "string", DB.getValue(nodeItem, "name", ""));  
		DB.setValue(nodeCombatItem, "st", "string", DB.getValue(nodeItem,"st",""));
		DB.setValue(nodeCombatItem, "weight", "string", DB.getValue(nodeItem,"weight",""));
		DB.setValue(nodeCombatItem, "cost", "string", DB.getValue(nodeItem,"cost",""));
		DB.setValue(nodeCombatItem, "tl", "string", DB.getValue(nodeItem,"tl",""));
		DB.setValue(nodeCombatItem, "text", "formattedtext", DB.getValue(nodeItem,"notes",""));

		local charST = DB.getValue(nodeNPC, "attributes.strength", 0);		
		local charThrust = DB.getValue(nodeNPC,"attributes.thrust", ManagerGURPS4e.getItemThrust(charST));
		local charSwing = DB.getValue(nodeNPC,"attributes.swing", ManagerGURPS4e.getItemSwing(charST));		

		local nodeModeList = DB.createChild(nodeCombatItem, "meleemodelist");  
		if not hasWeaponModes(nodeItem) then
			local aModesDamage = StringManager.split(DB.getValue(nodeItem, "damage", ""), "|");
			local aModesReach = StringManager.split(DB.getValue(nodeItem, "reach", ""), "|");
			local aModesParry = StringManager.split(DB.getValue(nodeItem, "parry", ""), "|");

			for index, value in ipairs(aModesDamage) do
				local modeDamage = StringManager.trim(aModesDamage[index] or DB.getValue(nodeItem, "damage", ""));
				local modeReach = StringManager.trim(aModesReach[index] or DB.getValue(nodeItem, "reach", ""));
				local modeParry = StringManager.trim(aModesParry[index] or DB.getValue(nodeItem, "parry", ""));

				local nodeMode = DB.createChild(nodeModeList);
				DB.setValue(nodeMode, "lvl", "number", 0);

				if (string.find(modeDamage, "thr") or string.find(modeDamage, "thrust")) then
					DB.setValue(nodeMode, "name", "string", "Thrust");				  
					DB.setValue(nodeMode, "damage", "string", ManagerGURPS4e.calculateDam(charThrust, modeDamage));
				elseif (string.find(modeDamage, "sw") or string.find(modeDamage, "swing")) then   
					DB.setValue(nodeMode, "name", "string", "Swing");				  
					DB.setValue(nodeMode, "damage", "string", ManagerGURPS4e.calculateDam(charSwing, modeDamage));
				else
					DB.setValue(nodeMode, "name", "string", "");				  
					DB.setValue(nodeMode, "damage", "string", modeDamage);
				end		  
	    
				DB.setValue(nodeMode, "reach", "string", modeReach);
				DB.setValue(nodeMode, "parry", "string", modeParry); 		  		  		  	  
			end
		else
			local minstVals = ManagerGURPS4e.strsplit("|", DB.getValue(nodeItem,"st",""));  
			local minstCount = 0;    

			for _, flds, mmNode in pairs(DB.getChildren(nodeItem, "")) do		  
				for i, idk, idNode in pairs(DB.getChildren(flds, "")) do				
					if (DB.getValue(idk, "modename", "") ~= "") and (DB.getValue(idk, "reach", "") ~= "") then		 				  
						local nodeMode = DB.createChild(nodeModeList);
						local newDmg = "";
						DB.setValue(nodeMode, "name", "string", DB.getValue(idk, "modename", "atk here"));				  
						minstCount = minstCount + 1;
						DB.setValue(nodeMode, "lvl", "number", DB.getValue(idk, "Level", "0"));		  
						if (string.find(DB.getValue(idk, "damage", ""), "thr") or string.find(DB.getValue(idk, "damage", ""), "thrust")) then
							newDmg = ManagerGURPS4e.calculateDam(charThrust, DB.getValue(idk, "damage", "") );		    
						elseif (string.find(DB.getValue(idk, "damage", ""), "sw") or string.find(DB.getValue(idk, "damage", ""), "swing")) then   
							newDmg = ManagerGURPS4e.calculateDam(charSwing, DB.getValue(idk, "damage", "") );
						else
							newDmg = DB.getValue(idk, "damage", "");
						end		  
						DB.setValue(nodeMode, "damage", "string", newDmg);
						DB.setValue(nodeMode, "reach", "string", DB.getValue(idk,"reach",""));
						local myParry = DB.getValue(idk, "parry", "");		  
						DB.setValue(nodeMode, "parry", "string", ManagerGURPS4e.calculateParry(DB.getValue(idk, "parry", ""))); 		  		  		  	  
					end
				end	     
			end

			local lastVal = "";
			local mstr = "";  
			for i=1, minstCount do	
				if minstVals[i] and tonumber(minstVals[i]) ~= tonumber(lastVal) then
					if lastVal ~= "" then mstr = mstr .. "|"; end
					lastVal = minstVals[i];		
					mstr = mstr .. minstVals[i];
				end
			end
			DB.setValue(nodeCombatItem, "st", "string", mstr);	
		end
	end

    return true;
end

function addRangedWeapon(nodeNPC, nodeItem)
	if not nodeItem then
		return false;
	end

	-- Get the combat list we are going to add to
	local nodeChar = nodeItem.getChild("...");
	local nodeCombat = nodeNPC.createChild("combat.rangedcombatlist");
	if not nodeCombat then
		return false;
	end
	
	-- Create entries
	local nodeCombatItem = nodeCombat.createChild();
	if nodeCombatItem then
		DB.setValue(nodeCombatItem, "name", "string", DB.getValue(nodeItem, "name", ""));
		DB.setValue(nodeCombatItem, "st", "string", DB.getValue(nodeItem,"st",""));
		DB.setValue(nodeCombatItem, "bulk", "number", tonumber(DB.getValue(nodeItem,"bulk","0")));
		DB.setValue(nodeCombatItem, "lc", "string", DB.getValue(nodeItem,"lc",""));
		DB.setValue(nodeCombatItem, "tl", "string", DB.getValue(nodeItem,"tl",""));
		DB.setValue(nodeCombatItem, "text", "formattedtext", DB.getValue(nodeItem,"notes",""));
    
		local charST = DB.getValue(nodeNPC, "attributes.strength", 0);		
		local charThrust = DB.getValue(nodeNPC,"attributes.thrust", ManagerGURPS4e.getItemThrust(charST));
		local charSwing = DB.getValue(nodeNPC,"attributes.swing", ManagerGURPS4e.getItemSwing(charST));		

		local nodeModeList = DB.createChild(nodeCombatItem, "rangedmodelist");  
		if not hasWeaponModes(nodeItem) then
			local aModesDamage = StringManager.split(DB.getValue(nodeItem, "damage", ""), "|");
			local aModesAcc = StringManager.split(DB.getValue(nodeItem, "acc", "0"), "|");
			local aModesRange = StringManager.split(DB.getValue(nodeItem, "range", ""), "|");
			local aModesRoF = StringManager.split(DB.getValue(nodeItem, "rof", ""), "|");
			local aModesShots = StringManager.split(DB.getValue(nodeItem, "shots", ""), "|");
			local aModesRcl = StringManager.split(DB.getValue(nodeItem, "rcl", ""), "|");

			for index, value in ipairs(aModesDamage) do
				local modeDamage = StringManager.trim(aModesDamage[index] or DB.getValue(nodeItem, "damage", ""));
				local modeAcc = StringManager.trim(aModesAcc[index] or DB.getValue(nodeItem, "acc", ""));
				local modeRange = StringManager.trim(aModesRange[index] or DB.getValue(nodeItem, "range", ""));
				local modeRoF = StringManager.trim(aModesRoF[index] or DB.getValue(nodeItem, "rof", ""));
				local modeShots = StringManager.trim(aModesShots[index] or DB.getValue(nodeItem, "shots", ""));
				local modeRcl = StringManager.trim(aModesRcl[index] or DB.getValue(nodeItem, "rcl", ""));

				local nodeMode = DB.createChild(nodeModeList);
				DB.setValue(nodeMode, "lvl", "number", 0);

				if (string.find(modeDamage, "thr") or string.find(modeDamage, "thrust")) then
					DB.setValue(nodeMode, "name", "string", "Thrust");				  
					DB.setValue(nodeMode, "damage", "string", ManagerGURPS4e.calculateDam(charThrust, modeDamage));
				elseif (string.find(modeDamage, "sw") or string.find(modeDamage, "swing")) then   
					DB.setValue(nodeMode, "name", "string", "Swing");				  
					DB.setValue(nodeMode, "damage", "string", ManagerGURPS4e.calculateDam(charSwing, modeDamage));
				else
					DB.setValue(nodeMode, "name", "string", "");				  
					DB.setValue(nodeMode, "damage", "string", modeDamage);
				end		  
	    
				DB.setValue(nodeMode, "acc", "number", tonumber(modeAcc));
				DB.setValue(nodeMode, "range", "string", ManagerGURPS4e.calculateRange(charST, modeRange)); 		  		  		  	  
				DB.setValue(nodeMode, "rof", "string", modeRoF); 		  		  		  	  
				DB.setValue(nodeMode, "shots", "string", modeShots); 		  		  		  	  
				DB.setValue(nodeMode, "rcl", "number", tonumber(modeRcl)); 		  		  		  	  
			end
		else
			local accMods = "";
			local modifierFlag = 0;
			local minstVals = ManagerGURPS4e.strsplit("|", DB.getValue(nodeItem,"st",""));  
			local minstCount = 0;

			for _, flds, mmNode in pairs(DB.getChildren(nodeItem, "")) do
				for i, idk, idNode in pairs(DB.getChildren(flds, "")) do
					if (DB.getValue(idk, "modename", "") ~= "") and (DB.getValue(idk, "rof", "") ~= "") then				  
						local nodeMode = DB.createChild(nodeModeList); 
						local newDmg = "";
						minstCount = minstCount + 1;
						DB.setValue(nodeMode, "name", "string", DB.getValue(idk, "modename", "atk name"));
						DB.setValue(nodeMode, "lvl", "number", 0);			  
                    
						local useST = DB.getValue(nodeItem, "weaponst", charST);			  		  
						useST = (useST ~= "" and useST or charST);
						useThrust = ManagerGURPS4e.getItemThrust(useST);
						useSwing = ManagerGURPS4e.getItemSwing(useST);

						if (string.find(DB.getValue(idk, "damage", ""), "thr") or string.find(DB.getValue(idk, "damage", ""), "thrust")) then
							newDmg = ManagerGURPS4e.calculateDam(useThrust, DB.getValue(idk, "damage", "") );
						elseif (string.find(DB.getValue(idk, "damage", ""), "sw") or string.find(DB.getValue(idk, "damage", ""), "swing")) then
							newDmg = ManagerGURPS4e.calculateDam(useSwing, DB.getValue(idk, "damage", "") );
						else
							newDmg = DB.getValue(idk, "damage", "");			
						end		  		  		  
						DB.setValue(nodeMode, "damage", "string", newDmg); 
						accMods = DB.getValue(idk,"acc","0");		  
						accMods = ManagerGURPS4e.strsplit("%+", accMods);	
						DB.setValue(nodeMode, "acc", "number", tonumber(accMods[1]));		  
						DB.setValue(nodeMode, "range", "string", ManagerGURPS4e.calculateRange(useST, DB.getValue(idk, "range", "")));
						DB.setValue(nodeMode, "rof", "string", DB.getValue(idk,"rof",""));
						DB.setValue(nodeMode, "shots", "string", DB.getValue(idk,"shots",""));
						DB.setValue(nodeMode, "rcl", "number", tonumber(DB.getValue(idk,"rcl","0")));
						if (#accMods > 1) and (modifierFlag ~= 1) then
							modifierFlag = 1;
							local modifNode = DB.createChild(nodeCombatItem, "modifierlist");		
							local mofNode = DB.createChild(modifNode);
							DB.setValue(mofNode, "name", "string", "Bonus Acc");
							DB.setValue(mofNode, "modifier", "number", tonumber(accMods[2]));
						end	    
					end		
				end 
			end
  
			local lastVal = "";
			local mstr = "";
			local startPos = #minstVals - minstCount + 1;	
			for i=startPos, #minstVals do		
				if minstVals[i] and tonumber(minstVals[i]) ~= tonumber(lastVal) then						
					if lastVal ~= "" then mstr = mstr .. "|"; end
					lastVal = minstVals[i];
					mstr = mstr .. minstVals[i];
				end
			end
			DB.setValue(nodeCombatItem, "st", "string", mstr);
		end
	end

    return true;
end
