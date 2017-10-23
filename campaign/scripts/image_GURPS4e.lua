-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
  if User.isHost() then
    setGridToolType("hex");
    setTokenOrientationCount(12);
  end
end

function onGridStateChanged(sGridType)
  super.onGridStateChanged(sGridType)
  if User.isHost() then
    if sGridType == "hexcolumn" or sGridType == "hexrow" then
      setTokenOrientationCount(12)
    else
      setTokenOrientationCount(8)
    end
  end
end

function measureVector(aVector, sGridType, nGridSize)
  if nGridSize <= 0 then
    return 0;
  end
  
  local dist = 0;
  if sGridType == "hexcolumn" or sGridType == "hexrow" then
    local qw = math.floor((nGridSize * math.tan(3.14159/6) / 2) + 0.5);
    local hh = nGridSize / 2;
        
    if qw > 0 and hh > 0 then
      for _,pt in pairs(aVector) do
        local column, row;

        if sGridType == "hexcolumn" then
          column = pt.x / (qw * 3);
          row = (pt.y / (hh * 2)) - (column * 0.5);
        else
          row = pt.y / (qw * 3);
          column = (pt.x / (hh * 2)) - (row * 0.5);
        end
        
        if (row >= 0 and column >= 0) or (row < 0 and column < 0) then
          dist = dist + math.abs(column) + math.abs(row);
        else
          dist = dist + math.max(math.abs(column), math.abs(row));
        end
      end
    end
  else -- sGridType == "square"
    local diagonals = 0;
    local straights = 0;

      for _,pt in pairs(aVector) do
        local gx = math.abs(pt.x / nGridSize);
        local gy = math.abs(pt.y / nGridSize);
        
        diagonals = diagonals + math.min(gx, gy);
        straights = math.abs(gx - gy);
      end

      dist = straights + diagonals;
  end
  
  return dist;
end

function onMeasurePointer(pixellength, pointertype, startx, starty, endx, endy)
  local aVector = {}
  table.insert(aVector, {x = endx - startx, y = endy - starty});
  
  local node = window.getDatabaseNode();
  local mapScale = DB.getValue(node, "mapscale", 1);
  local scaleUnits = DB.getValue(node, "scaleunits", "yd");
  local showRange = DB.getValue(node, "range", "");

  local dist = math.floor((measureVector(aVector, getGridType(), getGridSize()) * mapScale));
  
  local rangeMod = "";
  if showRange == "on" and scaleUnits ~= "" and scaleUnits ~= "AU" and scaleUnits ~= "ly" and scaleUnits ~= "pc" then
    rangeMod = " (" .. ManagerGURPS4e.calcRangeModifier(dist, scaleUnits) .. ")";
  end
  
  return dist .. scaleUnits .. rangeMod;
end

function onMeasureVector(token, vector)
  local node = window.getDatabaseNode();
  local mapScale = DB.getValue(node, "mapscale", 1);
  local scaleUnits = DB.getValue(node, "scaleunits", "yd");
  local showRange = DB.getValue(node, "range", "");

  local dist = math.floor((measureVector(vector, getGridType(), getGridSize()) * mapScale));
  
  local rangeMod = "";
  if showRange == "on" and scaleUnits ~= "" and scaleUnits ~= "AU" and scaleUnits ~= "ly" and scaleUnits ~= "pc" then
    rangeMod = " (" .. ManagerGURPS4e.calcRangeModifier(dist, scaleUnits) .. ")";
  end
  
  return dist .. scaleUnits .. rangeMod;
end
