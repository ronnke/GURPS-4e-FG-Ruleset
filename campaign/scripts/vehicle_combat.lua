-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	update();
end
function VisDataCleared()
	update();
end
function InvisDataAdded()
	update();
end

function update()
	local nodeRecord = getDatabaseNode();
	local bReadOnly = WindowManager.getReadOnlyState(nodeRecord);

	local bGroundVehicle = LibraryDataGURPS4e.isGroundVehicle(nodeRecord);
	local bWatercraft = LibraryDataGURPS4e.isWatercraft(nodeRecord);
	local bAircraft = LibraryDataGURPS4e.isAircraft(nodeRecord);
	local bSpacecraft = LibraryDataGURPS4e.isSpacecraft(nodeRecord); 

end
