-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function calcRangeModifier(length,unit)
  local rangeMod = -1;
  local factor = 0;
  local scale = 1;
  
  if unit == "ft" then
    scale = 0.333333333;
  elseif unit == "yd" then
    scale = 1;
  elseif unit == "mi" then
    scale = 1760;
  elseif unit == "m" then
    scale = 1.0936133;
  elseif unit == "km" then
    scale = 1093.6133
  elseif unit == "AU" then
    scale = 0
  elseif unit == "ly" then
    scale = 0
  elseif unit == "pc" then
    scale = 0
  end

  factor = math.log10((length * scale));
  if math.fmod(factor,1) <= math.fmod(math.log10(15),1) then
    factor = factor - 1;
  end
  factor = math.floor(factor);
  
  if (length*scale) <= (2 * math.pow(10,factor)) then
    rangeMod = ((factor * 6) + 0);
  elseif (length*scale) <= (3 * math.pow(10,factor)) then
    rangeMod = ((factor * 6) + 1);
  elseif (length*scale) <= (5 * math.pow(10,factor)) then
    rangeMod = ((factor * 6) + 2);
  elseif (length*scale) <= (7 * math.pow(10,factor)) then
    rangeMod = ((factor * 6) + 3);
  elseif (length*scale) <= (10 * math.pow(10,factor)) then
    rangeMod = ((factor * 6) + 4);
  elseif (length*scale) <= (15 * math.pow(10,factor)) then
    rangeMod = ((factor * 6) + 5);
  end
  
  return (rangeMod <= 0 and 0 or -rangeMod);
end

function parseBasicDamage(s)
  -- SETUP
  local aDice = {};
  local nMod = 0;
  
  local nDieCount = 0;
  local nDice = 0;
  local sOperator = "";
  local nNum = 0
  
  -- PARSING
  if s then
    nDieCount, nDice, sOperator, nNum = s:match("^(%d*)[dD]([%dF]*)%s*([+-x]?)%s*([%dF]*)");
    
    if nDieCount then
      local sDie = string.format("d%d", (tonumber(nDice) or DICE_DEFAULT));
      
      for i = 1, nDieCount do
        table.insert(aDice, sDie);
      end
    end
    
    if sOperator and nNum then
      nNum = (tonumber(nNum) or 0);
    end
  end
  
  -- RESULTS
  return aDice, nMod, sOperator, nNum;
end

function parseDamage(s)
  -- SETUP
  local aDice = {};
  local nMod = 0;
  
  local nDieCount = 0;
  local nDice = 0;
  local sOperator = "";
  local nNum = 0
  
  -- PARSING
  if s then
    nDieCount, nDice, sOperator, nNum = s:match("^(%d*)[dD]([%dF]*)%s*([+-x]?)%s*([%dF]*)");
    
    if nDieCount then
      local sDie = string.format("d%d", (tonumber(nDice) or DICE_DEFAULT));
      
      for i = 1, nDieCount do
        table.insert(aDice, sDie);
      end
    end
    
    if sOperator and nNum then
      nNum = (tonumber(nNum) or 0);
    end
  end
  
  -- RESULTS
  return aDice, nMod, sOperator, nNum;
end

local thrustDmg = {
[1]="1d-6",
[2]="1d-6",
[3]="1d-5",
[4]="1d-5",
[5]="1d-4",
[6]="1d-4",
[7]="1d-3",
[8]="1d-3",
[9]="1d-2",
[10]="1d-2",
[11]="1d-1",
[12]="1d-1",
[13]="1d",
[14]="1d",
[15]="1d+1",
[16]="1d+1",
[17]="1d+2",
[18]="1d+2",
[19]="2d-1",
[20]="2d-1",
[21]="2d",
[22]="2d",
[23]="2d+1",
[24]="2d+1",
[25]="2d+2",
[26]="2d+2",
[27]="3d-1",
[28]="3d-1",
[29]="3d",
[30]="3d",
[31]="3d+1",
[32]="3d+1",
[33]="3d+2",
[34]="3d+2",
[35]="4d-1",
[36]="4d-1",
[37]="4d",
[38]="4d",
[39]="4d+1",
[40]="4d+1",
[45]="5d",
[50]="5d+2",
[55]="6d",
[60]="7d-1",
[65]="7d+1",
[70]="8d",
[75]="8d+2",
[80]="9d",
[85]="9d+2",
[90]="10d",
[95]="10d+2",
[100]="11d"
};

local swingDmg = {
[1]="1d-5",
[2]="1d-5",
[3]="1d-4",
[4]="1d-4",
[5]="1d-3",
[6]="1d-3",
[7]="1d-2",
[8]="1d-2",
[9]="1d-1",
[10]="1d",
[11]="1d+1",
[12]="1d+2",
[13]="2d-1",
[14]="2d",
[15]="2d+1",
[16]="2d+2",
[17]="3d-1",
[18]="3d",
[19]="3d+1",
[20]="3d+2",
[21]="4d-1",
[22]="4d",
[23]="4d+1",
[24]="4d+2",
[25]="5d-1",
[26]="5d",
[27]="5d+1",
[28]="5d+1",
[29]="5d+2",
[30]="5d+2",
[31]="6d-1",
[32]="6d-1",
[33]="6d",
[34]="6d",
[35]="6d+1",
[36]="6d+1",
[37]="6d+2",
[38]="6d+2",
[39]="7d-1",
[40]="7d-1",
[45]="7d+1",
[50]="8d-1",
[55]="8d+1",
[60]="9d",
[65]="9d+2",
[70]="10d",
[75]="10d+2",
[80]="11d",
[85]="11d+2",
[90]="12d",
[95]="12d+2",
[100]="13d"
};

function getItemThrust(useST)
	useST = tonumber(useST);
	local val = nil;
	while not val do			
		val = thrustDmg[useST];		
		useST = useST + 1;
	end				
	return val;
end

function getItemSwing(useST)
	useST = tonumber(useST);
	local val = nil;
	while not val do		
		val = swingDmg[useST];
		useST = useST + 1;
	end	
	return val;
end

function calculateRange(charSt, itemRange)   	
	local newRange = "";
	local minmax = {};
	local symbol ="";
	local sep = "/";
	local pattern = string.format("([^%s]+)", sep);
	if not string.match(itemRange, "[%+-*]") then	    
		string.gsub(itemRange, pattern, function(c) minmax[#minmax + 1] = c end)
		if not tonumber(minmax[1]) then
			newRange = itemRange;
		else
			newRange = itemRange;
		end
	else
		local temp = {}
		string.gsub(itemRange, pattern, function(c) minmax[#minmax + 1] = c end)
		for _, k, v in pairs(minmax) do									
			calc = string.gsub(k, string.match(itemRange, "(%a+)"), charSt);			
			symbol = string.match(calc, "[%+-*]");						
			local res = strsplit(symbol, calc);						
			if symbol == "*" then result = tonumber(res[1] * res[2]);
			elseif symbol == "+" then result = tonumber(res[1]) + tonumber(res[2]);
			elseif symbol == "-" then result = tonumber(res[1]) - tonumber(res[2]);
			else result = itemRange;
			end			
			table.insert(temp, result);
		end		
		for i = 1, #temp do			
			newRange = newRange .. math.ceil(temp[i]);
			if (i < #temp) then newRange = newRange .. "/"; end
		end
	end	
	return newRange
end 

function calculateParry(charPar)	
	local calcParry = 0;
	return calcParry
end

function calculateDam(charDmg, itemDmg)		
	local myDieCount = string.match(charDmg, "([^d]+)");			
	local myMod = string.match(charDmg, "[^d]-$");
	myMod = tonumber(myMod);
	if (myMod == nil) then myMod = 0; end	
	local dmgType = string.match(itemDmg, "%s.-$");
	local pat = string.match(itemDmg, "(%a+)");			
	local itemMod = string.match(itemDmg, "[^%a"..pat.."%s]+"); 
	if not (itemMod) then
		itemMod = itemDmg;
	end
	local armDivOut = "";
	local armDiv = strsplit("%(", itemMod);
	if (armDiv[2]) then
		itemMod = armDiv[1];
		armDivOut = "("..armDiv[2];		
	end
	itemMod = tonumber(itemMod); if (itemMod == nil) then itemMod = 0; end				
	local newDmg = itemDmg;	
	local newMod = myMod + itemMod;
	if (newMod > 0) then newMod = "+" .. tostring(newMod); end 
	if (newMod == 0) then newMod = ""; end		
	newDmg = myDieCount .. "d" .. newMod .. armDivOut .. dmgType;	
	return newDmg
end

function strsplit(delimiter, text)
  local list = {};
  local pos = 1 ;
  if string.find("", delimiter, 1) then
    error("delimiter matches empty string!");
  end
  while 1 do
    local first, last = string.find(text, delimiter, pos);
    if first then 
      table.insert(list, string.sub(text, pos, first-1));
      pos = last+1;
    else
      table.insert(list, string.sub(text, pos));
      break;
    end
  end
  return list;
end
