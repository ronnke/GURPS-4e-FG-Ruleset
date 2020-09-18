-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
  super.onInit();

  if User.isHost() then
    setGridToolType("hex");
    setTokenOrientationCount(12);
  end
  onCursorModeChanged();
  onGridStateChanged(getGridType());
end

function onCursorModeChanged(sTool)
	super.onCursorModeChanged();
end

function onGridStateChanged(sGridType)
  super.onGridStateChanged(sGridType);

  if User.isHost() then
    if sGridType == "hexcolumn" or sGridType == "hexrow" then
      setTokenOrientationCount(12)
    else
      setTokenOrientationCount(8)
    end
  end
end

function getScale()
  local node = window.getDatabaseNode()
  return DB.getValue(node, "mapscale", 1)
end

function getScaleUnits()
  local node = window.getDatabaseNode()
  return DB.getValue(node, "scaleunits", "yd")
end

function getRange()
  local node = window.getDatabaseNode();
  return DB.getValue(node, "range", "");
end

function onMeasureVector(token, aVector)
  if hasGrid() then
    local sGridType = getGridType()
    local nGridSize = getGridSize()
    local nDistance = 0
    if sGridType == "hexrow" or sGridType == "hexcolumn" then
      local nGridHexWidth, nGridHexHeight = getGridHexElementDimensions()
      for nIndex = 1, #aVector do
        local nVector = ImageManagerGURPS4e.measureVector(aVector[nIndex].x, aVector[nIndex].y, sGridType, nGridSize, nGridHexWidth, nGridHexHeight)
        nDistance = nDistance + nVector
      end
    else
      for nIndex = 1, #aVector do
        local nVector = ImageManagerGURPS4e.measureVector(aVector[nIndex].x, aVector[nIndex].y, sGridType, nGridSize)
        nDistance = nDistance + nVector
      end
    end
    return scaledDistance(nDistance) .. getScaleUnits() .. rangeModifier(nDistance)
  end
  return ""
end

function onMeasurePointer(nLength, sPointerType, nStartX, nStartY, nEndX, nEndY)
  if hasGrid() then
    local sGridType = getGridType()
    local nGridSize = getGridSize()
    if sGridType == "hexrow" or sGridType == "hexcolumn" then
      local nGridHexWidth, nGridHexHeight = getGridHexElementDimensions()
      nDistance = ImageManagerGURPS4e.measureVector(nEndX - nStartX, nEndY - nStartY, sGridType, nGridSize, nGridHexWidth, nGridHexHeight)
    else
      nDistance = ImageManagerGURPS4e.measureVector(nEndX - nStartX, nEndY - nStartY, sGridType, nGridSize)
    end
    return scaledDistance(nDistance) .. getScaleUnits() .. rangeModifier(nDistance)
  end
  return ""
end

function scaledDistance(nDistance)
  return ImageManagerGURPS4e.scaledDistance(nDistance, getScale())
end

function rangeModifier(nDistance)
  local scaleUnits = getScaleUnits();
  local showRange = getRange();
  local nDistance = ImageManagerGURPS4e.scaledDistance(nDistance, getScale());
  if showRange == "on" and scaleUnits ~= "" and scaleUnits ~= "AU" and scaleUnits ~= "ly" and scaleUnits ~= "pc" then
    return " (" .. ManagerGURPS4e.calcRangeModifier(nDistance, scaleUnits) .. ")";
  end
  return ""
end

