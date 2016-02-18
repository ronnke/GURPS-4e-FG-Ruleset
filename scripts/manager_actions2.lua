-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

--  ACTION FLOW
--
--	1. INITIATE ACTION (DRAG OR DOUBLE-CLICK)
--	2. DETERMINE TARGETS (DROP OR TARGETING SUBSYSTEM)
--	3. APPLY MODIFIERS
--	4. PERFORM ROLLS (IF ANY)
--	5. RESOLVE ACTION

-- ROLL
--		.sType
--		.sDesc
--		.aDice
--		.nMod
--		(Any other fields added as string -> string map, if possible)

function createActionMessage(rSource, rRoll)
  local bAddMod = false;
 
  if GameSystem.actions[rRoll.sType] then
    bAddMod = GameSystem.actions[rRoll.sType].bAddMod;
  end
    
  -- Build the basic message to deliver
  local rMessage = ChatManager.createBaseMessage(rSource, rRoll.sUser);
  rMessage.type = rRoll.sType;
  rMessage.text = rMessage.text .. rRoll.sDesc; 
  rMessage.dice = rRoll.aDice;
  rMessage.diemodifier = 0;
  
  if rRoll.sType == "damage" and rRoll.sFunc then 
    if rRoll.sFunc:find("[+-]") then
      rMessage.diemodifier = (rRoll.nNum or 0);
    end
  else
    if bAddMod then
      rMessage.diemodifier = rRoll.nMod;
    end
  end
  
  -- Check to see if this roll should be secret (GM or dice tower tag)
  if rRoll.bSecret then
    rMessage.secret = true;
    if rRoll.bTower then
      rMessage.icon = "dicetower_icon";
    end
  elseif User.isHost() and OptionsManager.isOption("REVL", "off") then
    rMessage.secret = true;
  end
  
  -- Show total if option enabled
  if OptionsManager.isOption("TOTL", "on") and rRoll.aDice and #(rRoll.aDice) > 0 then
    rMessage.dicedisplay = 1;
  end
  
  return rMessage;
end

function total(rRoll)
  local nTotal = 0;
  local bAddMod = false;
 
  for _,v in ipairs(rRoll.aDice) do
    nTotal = nTotal + v.result;
  end

  if GameSystem.actions[rRoll.sType] then
    bAddMod = GameSystem.actions[rRoll.sType].bAddMod;
  end
  
  if (rRoll.sFunc == "+") then
    nTotal = nTotal + (rRoll.nNum or 0);
  elseif (rRoll.sFunc == "-") then
    nTotal = nTotal - (rRoll.nNum or 0);
  elseif (rRoll.sFunc == "x") then
    nTotal = nTotal * (rRoll.nNum or 1);
  end
  
  if bAddMod then
    nTotal = nTotal + rRoll.nMod;
  end
  
  return nTotal;
end
