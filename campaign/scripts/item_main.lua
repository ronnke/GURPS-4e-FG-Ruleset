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

function updateControl(sControl, bReadOnly, bID)
	if not self[sControl] then
		return false;
	end
		
	if not bID then
		return self[sControl].update(bReadOnly, true);
	end
	
	return self[sControl].update(bReadOnly);
end

function update()
	local nodeRecord = getDatabaseNode();
	local bReadOnly = WindowManager.getReadOnlyState(nodeRecord);
	local bID, bOptionID = LibraryData.getIDState("item", nodeRecord);
	
  local bDefense = LibraryDataGURPS4e.isDefense(nodeRecord);
  local bMeleeWeapon = LibraryDataGURPS4e.isMeleeWeapon(nodeRecord);
  local bRangedWeapon = LibraryDataGURPS4e.isRangedWeapon(nodeRecord);
	
	local bSection1 = false;
	if bOptionID and User.isHost() then
		if updateControl("nonid_name", bReadOnly, true) then bSection1 = true; end;
	else
    updateControl("nonid_name", bReadOnly, false);
	end
	if bOptionID and (User.isHost() or not bID) then
		if updateControl("nonid_notes", bReadOnly, true) then bSection1 = true; end;
	else
		updateControl("nonid_notes", bReadOnly, false);
	end
	
	local bSection2 = false;
  if updateControl("type", bReadOnly, true) then bSection2 = true; end;
  if updateControl("subtype", bReadOnly, true) then bSection2 = true; end;

  local bSection3 = false;
  if updateControl("tl", bReadOnly, bID) then bSection3 = true; end
  if updateControl("cost", bReadOnly, bID) then bSection3 = true; end
  if updateControl("weight", bReadOnly, bID) then bSection3 = true; end
  if updateControl("lc", bReadOnly, bID) then bSection3 = true; end

  local bSection4 = false;
  if updateControl("locations", bReadOnly, bID and bDefense) then bSection4 = true; end
  if updateControl("db", bReadOnly, bID and bDefense) then bSection4 = true; end
  if updateControl("dr", bReadOnly, bID and bDefense) then bSection4 = true; end
  if updateControl("don", bReadOnly, bID and bDefense) then bSection4 = true; end
  if updateControl("holdout", bReadOnly, bID and bDefense) then bSection4 = true; end

  if updateControl("damage", bReadOnly, bID and (bMeleeWeapon or bRangedWeapon)) then bSection4 = true; end
  if updateControl("reach", bReadOnly, bID and bMeleeWeapon) then bSection4 = true; end
  if updateControl("parry", bReadOnly, bID and bMeleeWeapon) then bSection4 = true; end
  if updateControl("acc", bReadOnly, bID and bRangedWeapon) then bSection4 = true; end
  if updateControl("range", bReadOnly, bID and bRangedWeapon) then bSection4 = true; end
  if updateControl("rof", bReadOnly, bID and bRangedWeapon) then bSection4 = true; end
  if updateControl("shots", bReadOnly, bID and bRangedWeapon) then bSection4 = true; end
  if updateControl("st", bReadOnly, bID and (bMeleeWeapon or bRangedWeapon)) then bSection4 = true; end
  if updateControl("bulk", bReadOnly, bID and bRangedWeapon) then bSection4 = true; end
  if updateControl("rcl", bReadOnly, bID and bRangedWeapon) then bSection4 = true; end

	local bSection5 = bID;
	notes.setVisible(bID);
	notes.setReadOnly(bReadOnly);
		
	divider1.setVisible(bSection1 and bSection2);
  divider2.setVisible((bSection1 or bSection2) and bSection3);
  divider3.setVisible((bSection1 or bSection2 or bSection3) and bSection4);
end
