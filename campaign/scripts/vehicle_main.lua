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
	local bID = LibraryData.getIDState("npc", nodeRecord);

	local bGroundVehicle = LibraryDataGURPS4e.isGroundVehicle(nodeRecord);
	local bWatercraft = LibraryDataGURPS4e.isWatercraft(nodeRecord);
	local bAircraft = LibraryDataGURPS4e.isAircraft(nodeRecord);
	local bSpacecraft = LibraryDataGURPS4e.isSpacecraft(nodeRecord); 

	local bSection1 = false;
	if Session.IsHost then
		if WindowManager.callSafeControlUpdate(self, "nonid_name", bReadOnly) then bSection1 = true; end;
	else
		WindowManager.callSafeControlUpdate(self, "nonid_name", bReadOnly, true);
	end
	divider1.setVisible(bSection1);
  
	local bSection2 = false;
	if WindowManager.callSafeControlUpdate(self, "type", bReadOnly) then bSection2 = true; end;
	if WindowManager.callSafeControlUpdate(self, "subtype", bReadOnly) then bSection2 = true; end;
	divider2.setVisible(bSection2);

	local bSection3 = false;
	if WindowManager.callSafeControlUpdate(self, "tl", bReadOnly) then bSection3 = true; end;
	if WindowManager.callSafeControlUpdate(self, "sthp", bReadOnly) then bSection3 = true; end;
	if WindowManager.callSafeControlUpdate(self, "hndsr", bReadOnly) then bSection3 = true; end;
	if WindowManager.callSafeControlUpdate(self, "ht", bReadOnly) then bSection3 = true; end;
	if WindowManager.callSafeControlUpdate(self, "move", bReadOnly, bSpacecraft) then bSection3 = true; end;
	if WindowManager.callSafeControlUpdate(self, "moveg", bReadOnly, not bSpacecraft) then bSection3 = true; end;
	if WindowManager.callSafeControlUpdate(self, "lwt", bReadOnly) then bSection3 = true; end;
	if WindowManager.callSafeControlUpdate(self, "load", bReadOnly) then bSection3 = true; end;
	if WindowManager.callSafeControlUpdate(self, "sm", bReadOnly) then bSection3 = true; end;
	if WindowManager.callSafeControlUpdate(self, "occ", bReadOnly) then bSection3 = true; end;
	if WindowManager.callSafeControlUpdate(self, "dr", bReadOnly) then bSection3 = true; end;
	if WindowManager.callSafeControlUpdate(self, "range", bReadOnly) then bSection3 = true; end;
	if WindowManager.callSafeControlUpdate(self, "cost", bReadOnly) then bSection3 = true; end;
	if WindowManager.callSafeControlUpdate(self, "locations", bReadOnly) then bSection3 = true; end;
	if WindowManager.callSafeControlUpdate(self, "draft", bReadOnly, not bWatercraft) then bSection3 = true; end;
	if WindowManager.callSafeControlUpdate(self, "stall", bReadOnly, not bAircraft) then bSection3 = true; end;
	divider3.setVisible(bSection3);

	notes.setReadOnly(bReadOnly);
end
