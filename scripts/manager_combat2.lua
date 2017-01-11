-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

CT_LIST = "combattracker.list"

function onInit()
	CombatManager.setCustomSort(sortfuncGURPS);

  CombatManager.setCustomAddPC(addPC);

	CombatManager.setCustomAddNPC(addNPC);

  CombatManager.setCustomNPCSpaceReach(funcSpaceReach);
  
	CombatManager.setCustomCombatReset(resetInit);
end

--
-- COMBAT TRACKER SORT
--

-- NOTE: Lua sort function expects the opposite boolean value compared to built-in FG sorting
function sortfuncGURPS(node1, node2)
  local bHost = User.isHost();
  local sOptCTSI = OptionsManager.getOption("CTSI");
  
  local sFaction1 = DB.getValue(node1, "friendfoe", "");
  local sFaction2 = DB.getValue(node2, "friendfoe", "");
  
  local bShowInit1 = bHost or ((sOptCTSI == "friend") and (sFaction1 == "friend")) or (sOptCTSI == "on");
  local bShowInit2 = bHost or ((sOptCTSI == "friend") and (sFaction2 == "friend")) or (sOptCTSI == "on");
  
  if bShowInit1 ~= bShowInit2 then
    if bShowInit1 then
      return true;
    elseif bShowInit2 then
      return false;
    end
  else
    if bShowInit1 then
      local nValue1 = DB.getValue(node1, "speed", 0);
      local nDX1 = DB.getValue(node1, "dexterity", 0);
      local nValue2 = DB.getValue(node2, "speed", 0);
      local nDX2 = DB.getValue(node2, "dexterity", 0);
      
      if nValue1 ~= nValue2 then
        return nValue1 > nValue2;
      end
      
      if nDX1 ~= nDX2 then
        return nDX1 > nDX2;
      end
      
      if sFaction1 ~= sFaction2 then
        if sFaction1 == "friend" then
          return true;
        elseif sFaction2 == "friend" then
          return false;
        end
      end
    else
      if sFaction1 ~= sFaction2 then
        if sFaction1 == "friend" then
          return true;
        elseif sFaction2 == "friend" then
          return false;
        end
      end
    end
  end
  
  local sValue1 = DB.getValue(node1, "name", "");
  local sValue2 = DB.getValue(node2, "name", "");
  if sValue1 ~= sValue2 then
    return sValue1 < sValue2;
  end

  return node1.getNodeName() < node2.getNodeName();
end

--
-- ADD FUNCTIONS
--

function addPC(nodePC)
  if not nodePC then
    return;
  end
  
  -- Create a new combat tracker window
  local nodeEntry = DB.createChild(CT_LIST);
  if not nodeEntry then
    return;
  end
  
  -- Set up the CT specific information
  DB.setValue(nodeEntry, "link", "windowreference", "charsheet", nodePC.getNodeName());
  DB.setValue(nodeEntry, "friendfoe", "string", "friend");

  local sToken = DB.getValue(nodePC, "token", nil);
  if not sToken or sToken == "" then
    sToken = "portrait_" .. nodePC.getName() .. "_token"
  end
  DB.setValue(nodeEntry, "token", "token", sToken);

  -- Setup
  DB.setValue(nodeEntry, "speed", "number", tonumber(DB.getValue(nodePC, "attributes.basicspeed", "0")));
  DB.setValue(nodeEntry, "hps", "number", DB.getValue(nodePC, "attributes.current_hps", 0));
  DB.setValue(nodeEntry, "fps", "number", DB.getValue(nodePC, "attributes.current_fps", 0));

  DB.setValue(nodeEntry, "space", "number", tonumber(DB.getValue(nodePC, "traits.sizemodifier", "0")));
  DB.setValue(nodeEntry, "reach", "number", tonumber(DB.getValue(nodePC, "traits.reach", "0")));
  
  DB.setValue(nodeEntry, "attributes.strength", "number", DB.getValue(nodePC, "attributes.strength", 0));
  DB.setValue(nodeEntry, "attributes.dexterity", "number", DB.getValue(nodePC, "attributes.dexterity", 0));
  DB.setValue(nodeEntry, "attributes.intelligence", "number", DB.getValue(nodePC, "attributes.intelligence", 0));
  DB.setValue(nodeEntry, "attributes.health", "number", DB.getValue(nodePC, "attributes.health", 0));
  DB.setValue(nodeEntry, "attributes.hps", "number", DB.getValue(nodePC, "attributes.hps", 0));
  DB.setValue(nodeEntry, "attributes.will", "number", DB.getValue(nodePC, "attributes.will", 0));
  DB.setValue(nodeEntry, "attributes.perception", "number", DB.getValue(nodePC, "attributes.perception", 0));
  DB.setValue(nodeEntry, "attributes.fps", "number", DB.getValue(nodePC, "attributes.fps", 0));

  DB.setValue(nodeEntry, "combat.dodge", "number", DB.getValue(nodePC, "combat.dodge", 0));
  DB.setValue(nodeEntry, "combat.parry", "number", DB.getValue(nodePC, "combat.parry", 0));
  DB.setValue(nodeEntry, "combat.block", "number", DB.getValue(nodePC, "combat.block", 0));
  DB.setValue(nodeEntry, "combat.dr", "string", DB.getValue(nodePC, "combat.dr", "0"));

  DB.setValue(nodeEntry, "attributes.move", "string", DB.getValue(nodePC, "attributes.current_move", "0"));

  return nodeEntry;
end

function addNPC(sClass, nodeNPC, sName)
	local nodeEntry, nodeLastMatch = CombatManager.addNPCHelper(nodeNPC, sName);

	-- Setup
  DB.setValue(nodeEntry, "speed", "number", tonumber(DB.getValue(nodeNPC, "attributes.basicspeed", "0")));
  DB.setValue(nodeEntry, "hps", "number", DB.getValue(nodeNPC, "attributes.hps", 0));
  DB.setValue(nodeEntry, "fps", "number", DB.getValue(nodeNPC, "attributes.fps", 0));
  
	return nodeEntry;
end

function funcSpaceReach(nodeNPC)
   local nSpace = tonumber(DB.getValue(nodeNPC, "traits.sizemodifier", "0"));
   local nReach = tonumber(DB.getValue(nodeNPC, "traits.reach", "0"));
   
   return nSpace, nReach;
end
--
-- RESET FUNCTIONS
--

function resetEffects()
	for _, vChild in pairs(DB.getChildren(CombatManager.CT_LIST)) do
		local nodeEffects = vChild.getChild("effects");
		if nodeEffects then
			for _, vEffect in pairs(nodeEffects.getChildren()) do
				vEffect.delete();
			end
		end
	end
end

function resetInit()
end
