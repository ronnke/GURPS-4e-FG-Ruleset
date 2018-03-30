-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function measureVector(nVectorX, nVectorY, sGridType, nGridSize, nGridHexWidth, nGridHexHeight)
  local nDistance = 0
  local bAdjacent = false
  local nAdjacentDistance = 1

  if sGridType == "hexrow" or sGridType == "hexcolumn" then
    local nCol, nRow = 0, 0
    if sGridType == "hexcolumn" then
      nCol = nVectorX / (nGridHexWidth*3)
      nRow = (nVectorY / (nGridHexHeight*2)) - (nCol * 0.5)
    else
      nRow = nVectorY / (nGridHexWidth*3)
      nCol = (nVectorX / (nGridHexHeight*2)) - (nRow * 0.5)
    end
    local toFirstDecimal = function(nValue)
      return math.ceil(nValue - 0.5)
    end
    nRow = toFirstDecimal(nRow)
    nCol = toFirstDecimal(nCol)
    bAdjacent = nRow <= nAdjacentDistance and nCol <= nAdjacentDistance

    if((nRow >= 0 and nCol >= 0) or (nRow < 0 and nCol < 0)) then
      nDistance = math.abs(nCol) + math.abs(nRow)
    else
      nDistance = math.max(math.abs(nCol), math.abs(nRow))
    end
  else
    local nDiagonals = 0
    local nStraights = 0

    local getVectorValue = function(nVector, nGridSize)
      local nValue = math.abs(nVector / nGridSize)
      return math.ceil(nValue - 0.5)
    end
    local nGridX = getVectorValue(nVectorX, nGridSize)
    local nGridY = getVectorValue(nVectorY, nGridSize)
    bAdjacent = nGridX <= nAdjacentDistance and nGridY <= nAdjacentDistance

    if nGridX > nGridY then
      nDiagonals = nDiagonals + nGridY
      nStraights = nStraights + nGridX - nGridY
    else
      nDiagonals = nDiagonals + nGridX
      nStraights = nStraights + nGridY - nGridX
    end

    nDistance = nDiagonals * 1.5 + nStraights
  end

  return nDistance, bAdjacent
end

function scaledDistance(nDistance, nScale)
  if nDistance and nScale then
    local nScaledDistance = nDistance * nScale
    return math.abs(math.ceil(nScaledDistance - 0.5))
  else
    return 0
  end
end