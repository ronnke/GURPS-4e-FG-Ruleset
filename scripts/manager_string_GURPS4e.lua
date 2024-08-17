-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

-----------------------
--  CONVERSION FUNCTIONS
-----------------------

-- NOTE: Ignores negative dice references
function convertStringToDice(s)
	-- SETUP
	local aDice = {};
	local nDieCount = 0;
	local nDice = 0;
	
	local nDefaultDice = 6;
	
	-- PARSING
	if s then
		local aRulesetDice = Interface.getDice();
		
    nDieCount, nDice  = s:match("^(%d*)[dD]([%dF]*)");
    
    if nDieCount then
      local sDie = string.format("d%d", (tonumber(nDice) or nDefaultDice));
      
      for i = 1, nDieCount do
        table.insert(aDice, sDie);
      end
    end
	end
	
	-- RESULTS
	return aDice;
end

function convertRelativeLevel(s)
  -- SETUP
  local sOperator = "+";
  local nNum = 0
  
  -- PARSING
  if s then
    sOperator, nNum = s:match("%a+([+-])%s*([%dF]*)%s*$");
    
    if sOperator and nNum then
      nNum = (tonumber(nNum) or 0);
    else
      return "+", 0
    end
  end
  
  -- RESULTS
  return sOperator, nNum;
end
