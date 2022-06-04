-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--


function onInit()
  super.onInit();
  
  onGridStateChanged(getGridType());
end

function onGridStateChanged(sGridType)
  if User.isHost() then
    if sGridType == "hexcolumn" or sGridType == "hexrow" then
      setTokenOrientationCount(12)
    else
      setTokenOrientationCount(8)
    end
  end
end

function onMeasurePointer(nLength, sPointerType, nStartX, nStartY, nEndX, nEndY)
	local getPositions = function(nStartX, nStartY, nEndX, nEndY)
		return { x = nStartX, y = nStartY }, { x = nEndX, y = nEndY }
	end
	local rStart, rEnd = getPositions(nStartX, nStartY, nEndX, nEndY)
	if rStart and rEnd then
		local getDistance = function(rStart, rEnd)
			return math.floor((getDistanceBetween(rStart, rEnd) + 0.05) * 10) / 10;
		end
		local nDistance = getDistance(rStart, rEnd);
		local sUnits = getDistanceSuffix();
		local nRangeMod = ManagerGURPS4e.calcRangeModifier(nDistance, sUnits);
		if nRangeMod < 0 then
			return nDistance .. sUnits .. "\n(" .. nRangeMod .. ")";
		end
		return nDistance .. sUnits;
	end
	return ""
end
