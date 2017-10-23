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
