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

function updateControl(sControl, bReadOnly, bForceHide)
	if not self[sControl] then
		return false;
	end
	
	return self[sControl].update(bReadOnly, bForceHide);
end

function update()
	local nodeRecord = getDatabaseNode();
	local bReadOnly = WindowManager.getReadOnlyState(nodeRecord);
  
	local bGroundVehicle = LibraryDataGURPS4e.isGroundVehicle(nodeRecord);
	local bWatercraft = LibraryDataGURPS4e.isWatercraft(nodeRecord);
	local bAircraft = LibraryDataGURPS4e.isAircraft(nodeRecord);
	local bSpacecraft = LibraryDataGURPS4e.isSpacecraft(nodeRecord); 
  
	local bSection1 = false;
	if updateControl("type", bReadOnly, bReadOnly and type.isEmpty()) then bSection1 = true; end;
	if updateControl("subtype", bReadOnly, bReadOnly and subtype.isEmpty()) then bSection1 = true; end;

	local bSection2 = false;
	if updateControl("tl", bReadOnly, false) then bSection2 = true; end
	if updateControl("sthp", bReadOnly, false) then bSection2 = true; end
	if updateControl("hndsr", bReadOnly, false) then bSection2 = true; end
	if updateControl("ht", bReadOnly, false) then bSection2 = true; end
	if updateControl("move", bReadOnly, bSpacecraft) then bSection2 = true; end
	if updateControl("moveg", bReadOnly, not bSpacecraft) then bSection2 = true; end
	if updateControl("lwt", bReadOnly, false) then bSection2 = true; end
	if updateControl("load", bReadOnly, false) then bSection2 = true; end
	if updateControl("sm", bReadOnly, false) then bSection2 = true; end
	if updateControl("occ", bReadOnly, false) then bSection2 = true; end
	if updateControl("dr", bReadOnly, false) then bSection2 = true; end
	if updateControl("range", bReadOnly, false) then bSection2 = true; end
	if updateControl("cost", bReadOnly, false) then bSection2 = true; end
	if updateControl("locations", bReadOnly, false) then bSection2 = true; end
	if updateControl("draft", bReadOnly, not bWatercraft) then bSection2 = true; end
	if updateControl("stall", bReadOnly, not bAircraft) then bSection2 = true; end

	local bSection3 = true;
	notes.setVisible(true);
	notes.setReadOnly(bReadOnly);
    
	divider1.setVisible(bSection1 and bSection2);
	divider2.setVisible((bSection1 or bSection2) and bSection3);
end
