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
	local bID = LibraryData.getIDState("item", nodeRecord);
	
	local bDefense = LibraryDataGURPS4e.isDefense(nodeRecord);
	local bMeleeWeapon = LibraryDataGURPS4e.isMeleeWeapon(nodeRecord);
	local bRangedWeapon = LibraryDataGURPS4e.isRangedWeapon(nodeRecord);
	
	local bSection1 = false;
	if Session.IsHost then
		if WindowManager.callSafeControlUpdate(self, "nonid_name", bReadOnly) then bSection1 = true; end;
	else
		WindowManager.callSafeControlUpdate(self, "nonid_name", bReadOnly, true);
	end
	if (Session.IsHost or not bID) then
		if WindowManager.callSafeControlUpdate(self, "nonid_notes", bReadOnly) then bSection1 = true; end;
	else
		WindowManager.callSafeControlUpdate(self, "nonid_notes", bReadOnly, true);
	end
	divider1.setVisible(bSection1);
	
	local bSection2 = false;
	if WindowManager.callSafeControlUpdate(self, "type", bReadOnly) then bSection2 = true; end;
	if WindowManager.callSafeControlUpdate(self, "subtype", bReadOnly) then bSection2 = true; end;
	divider2.setVisible(bSection2);

	local bSection3 = false;
	if WindowManager.callSafeControlUpdate(self, "tl", bReadOnly, not bID) then bSection3 = true; end
	if WindowManager.callSafeControlUpdate(self, "cost", bReadOnly, not bID) then bSection3 = true; end
	if WindowManager.callSafeControlUpdate(self, "weight", bReadOnly, not bID) then bSection3 = true; end
	if WindowManager.callSafeControlUpdate(self, "lc", bReadOnly, not bID) then bSection3 = true; end
	divider3.setVisible(bSection3);

	local bSection4 = false;
	if WindowManager.callSafeControlUpdate(self, "locations", bReadOnly, not bID or not bDefense) then bSection4 = true; end
	if WindowManager.callSafeControlUpdate(self, "db", bReadOnly, not bID or not bDefense) then bSection4 = true; end
	if WindowManager.callSafeControlUpdate(self, "dr", bReadOnly, not bID or not bDefense) then bSection4 = true; end
	if WindowManager.callSafeControlUpdate(self, "don", bReadOnly, not bID or not bDefense) then bSection4 = true; end
	if WindowManager.callSafeControlUpdate(self, "holdout", bReadOnly, not bID or not bDefense) then bSection4 = true; end

	if WindowManager.callSafeControlUpdate(self, "damage", bReadOnly, not bID or (not bMeleeWeapon and not bRangedWeapon)) then bSection4 = true; end
	if WindowManager.callSafeControlUpdate(self, "reach", bReadOnly, not bID or not bMeleeWeapon) then bSection4 = true; end
	if WindowManager.callSafeControlUpdate(self, "parry", bReadOnly, not bID or not bMeleeWeapon) then bSection4 = true; end
	if WindowManager.callSafeControlUpdate(self, "acc", bReadOnly, not bID or not bRangedWeapon) then bSection4 = true; end
	if WindowManager.callSafeControlUpdate(self, "range", bReadOnly, not bID or not bRangedWeapon) then bSection4 = true; end
	if WindowManager.callSafeControlUpdate(self, "rof", bReadOnly, not bID or not bRangedWeapon) then bSection4 = true; end
	if WindowManager.callSafeControlUpdate(self, "shots", bReadOnly, not bID or not bRangedWeapon) then bSection4 = true; end
	if WindowManager.callSafeControlUpdate(self, "st", bReadOnly, not bID or (not bMeleeWeapon and not bRangedWeapon)) then bSection4 = true; end
	if WindowManager.callSafeControlUpdate(self, "bulk", bReadOnly, not bID or not bRangedWeapon) then bSection4 = true; end
	if WindowManager.callSafeControlUpdate(self, "rcl", bReadOnly, not bID or not bRangedWeapon) then bSection4 = true; end
	divider4.setVisible(bSection4);

	local bSection5 = bID;
	notes.setVisible(bID);
	notes.setReadOnly(bReadOnly);
		
--	divider1.setVisible(bSection1 and bSection2);
--	divider2.setVisible((bSection1 or bSection2) and bSection3);
--	divider3.setVisible((bSection1 or bSection2 or bSection3) and bSection4);
end
