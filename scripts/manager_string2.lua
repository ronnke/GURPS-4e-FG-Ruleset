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
	local nMod = 0;
	
	local nDieCount = 0;
	local nDice = 0;
	local sFunc = "";
	local nNum = 0
	
	local nDefaultDice = 6;
	
	-- PARSING
	if s then
		local aRulesetDice = Interface.getDice();
		
    nDieCount, nDice, sFunc, nNum = s:match("^(%d*)[dD]([%dF]*)%s*([+-x]?)%s*([%dF]*)");
    
    if nDieCount then
      local sDie = string.format("d%d", (tonumber(nDice) or nDefaultDice));
      
      for i = 1, nDieCount do
        table.insert(aDice, sDie);
      end
    end
    
    if sFunc and nNum then
      nNum = (tonumber(nNum) or 0);
    end
	end
	
	-- RESULTS
	return aDice, nMod, sFunc, nNum;
end
