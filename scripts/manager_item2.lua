--
-- Please see the license.html file included with this distribution for
-- attribution and copyright information.
--

function onInit()	
    ItemManager.setCustomCharAdd(onItemAdded)
    ItemManager.setCustomCharRemove(onItemRemoved);		
end

function hasWeaponModes(nodeItem)
    if DB.getChild(nodeItem, "meleemodelist") or DB.getChild(nodeItem, "rangedmodelist") then 
        return true;
    end
    return false;
end

function AddMeleeItem(nodeChar, nodeItem, seupLinks)
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

    local charST = DB.getValue(nodeChar, "attributes.strength", 0);		
    local charThrust = DB.getValue(nodeChar,"attributes.thrust", ManagerGURPS4e.getItemThrust(charST));
    local charSwing = DB.getValue(nodeChar,"attributes.swing", ManagerGURPS4e.getItemSwing(charST));		

    local nodeModeList = DB.createChild(nodeMeleeWeapon, "meleemodelist");  
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

            if (string.find(modeDamage, "thr")) then
                DB.setValue(nodeMode, "name", "string", "Thrust");				  
                DB.setValue(nodeMode, "damage", "string", ManagerGURPS4e.calculateDam(charThrust, modeDamage));
            elseif (string.find(modeDamage, "sw")) then   
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
                    if (string.find(DB.getValue(idk, "damage", ""), "thr")) then
                        newDmg = ManagerGURPS4e.calculateDam(charThrust, DB.getValue(idk, "damage", "") );		    
                    elseif (string.find(DB.getValue(idk, "damage", ""), "sw")) then   
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
        DB.setValue(nodeMeleeWeapon, "st", "string", mstr);	
    end

    if seupLinks then
        DB.setValue(nodeMeleeWeapon, "isHidden", "number", 0);		
        DB.setValue(nodeItem, "combatmeleelink", "string", nodeMeleeWeapon.getNodeName());
    end

    return true;
end

function AddRangedItem(nodeChar, nodeItem, seupLinks)
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
    
    local charST = DB.getValue(nodeChar, "attributes.strength", 0);		
    local charThrust = DB.getValue(nodeChar,"attributes.thrust", ManagerGURPS4e.getItemThrust(charST));
    local charSwing = DB.getValue(nodeChar,"attributes.swing", ManagerGURPS4e.getItemSwing(charST));		

    local nodeModeList = DB.createChild(nodeRangedWeapon, "rangedmodelist");  
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

            if (string.find(modeDamage, "thr")) then
                DB.setValue(nodeMode, "name", "string", "Thrust");				  
                DB.setValue(nodeMode, "damage", "string", ManagerGURPS4e.calculateDam(charThrust, modeDamage));
            elseif (string.find(modeDamage, "sw")) then   
                DB.setValue(nodeMode, "name", "string", "Swing");				  
                DB.setValue(nodeMode, "damage", "string", ManagerGURPS4e.calculateDam(charSwing, modeDamage));
            else
                DB.setValue(nodeMode, "name", "string", "");				  
                DB.setValue(nodeMode, "damage", "string", modeDamage);
            end		  
	    
            DB.setValue(nodeMode, "acc", "number", tonumber(modeAcc));
            DB.setValue(nodeMode, "range", "string", modeRange); 		  		  		  	  
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
                    useST = (useST ~= "" and useST or 0);
                    useThrust = ManagerGURPS4e.getItemThrust(useST);
                    useSwing = ManagerGURPS4e.getItemSwing(useST);

                    if (string.find(DB.getValue(idk, "damage", ""), "thr")) then
                        newDmg = ManagerGURPS4e.calculateDam(useThrust, DB.getValue(idk, "damage", "") );
                    elseif (string.find(DB.getValue(idk, "damage", ""), "sw")) then
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
                        local modifNode = DB.createChild(nodeRangedWeapon, "modifierlist");		
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
        DB.setValue(nodeRangedWeapon, "st", "string", mstr);
    end

    if seupLinks then
        DB.setValue(nodeRangedWeapon, "isHidden", "number", 0);
        DB.setValue(nodeItem, "combatrangedlink", "string", nodeRangedWeapon.getNodeName());	  		  
    end

    return true;
end

function AddDefenseItem(nodeChar, nodeItem, seupLinks)
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

    if seupLinks then
        DB.setValue(nodeDefenses, "isHidden", "number", 0);
        DB.setValue(nodeItem, "defenselink", "string", nodeDefenses.getNodeName());	    
    end

    return true;
end

function AddItemToCombat(nodeChar, nodeItem, setupLinks)	
	local bAdded = false;    	
	if not DB.getValue(nodeItem, "combatmeleelink") or not DB.findNode(DB.getValue(nodeItem, "combatmeleelink")) then		
		bAdded = AddMeleeItem(nodeChar, nodeItem, setupLinks) or bAdded;
    else
	end
	if not DB.getValue(nodeItem, "combatrangedlink") or not DB.findNode(DB.getValue(nodeItem, "combatrangedlink")) then			
		bAdded = AddRangedItem(nodeChar, nodeItem, setupLinks) or bAdded;
	end
	if not DB.getValue(nodeItem, "defenselink") or not DB.findNode(DB.getValue(nodeItem, "defenselink")) then			
		bAdded = AddDefenseItem(nodeChar, nodeItem, setupLinks) or bAdded;    	
	end			
	if DB.getValue(nodeItem, "combatmeleelink") ~= "" or DB.getValue(nodeItem, "combatrangedlink") ~= "" or DB.getValue(nodeItem, "defenselink") ~= "" then
		CharItemEquip.setHidden(nodeItem, 0);
	end  
	return bAdded;
end

function onItemAdded(nodeItem)
    local nodeChar = nodeItem.getParent().getParent();    
    local bAdded = AddItemToCombat(nodeChar,nodeItem, true);  
    CharItemEquip.toggleEquipped(nodeItem, true);
    return bAdded;
end

function onItemRemoved(nodeItem)	
	if LibraryDataGURPS4e.isMeleeWeapon(nodeItem) then					
		if (DB.getValue(nodeItem, "combatmeleelink", "")) ~= "" then
			DB.deleteNode(DB.getValue(nodeItem, "combatmeleelink", ""));			
		end
	end  	
	if LibraryDataGURPS4e.isRangedWeapon(nodeItem) then		
		if (DB.getValue(nodeItem, "combatrangedlink", "")) ~= "" then
			DB.deleteNode(DB.getValue(nodeItem, "combatrangedlink", ""));			
		end
	end  		
	if LibraryDataGURPS4e.isDefense(nodeItem) then		
		if (DB.getValue(nodeItem, "defenselink", "")) ~= "" then					
			DB.deleteNode(DB.getValue(nodeItem, "defenselink", ""));			
		end
	end  	
end

--
-- Item Types
--

