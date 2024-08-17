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
	
	local bSkill = LibraryDataGURPS4e.isSkill(nodeRecord);
	local bSpell = LibraryDataGURPS4e.isSpell(nodeRecord);
	local bPower = LibraryDataGURPS4e.isPower(nodeRecord);
	local bOther = LibraryDataGURPS4e.isOther(nodeRecord);

	local bSection1 = false;
	if WindowManager.callSafeControlUpdate(self, "type", bReadOnly) then bSection1 = true; end;
	if WindowManager.callSafeControlUpdate(self, "subtype", bReadOnly) then bSection1 = true; end;
	if WindowManager.callSafeControlUpdate(self, "page", bReadOnly) then bSection1 = true; end;
	divider1.setVisible(bSection1);

	local bSection2 = false;
	if WindowManager.callSafeControlUpdate(self, "skilltype", bReadOnly, not bSkill) then bSection2 = true; end;
	if WindowManager.callSafeControlUpdate(self, "skilldefault", bReadOnly, not bSkill) then bSection2 = true; end;
	if WindowManager.callSafeControlUpdate(self, "skillprerequisite", bReadOnly, not bSkill) then bSection2 = true; end;
	divider2.setVisible(bSection2);

	local bSection3 = false;
	if WindowManager.callSafeControlUpdate(self, "spellcollege", bReadOnly, not bSpell) then bSection3 = true; end;
	if WindowManager.callSafeControlUpdate(self, "spellclass", bReadOnly, not bSpell) then bSection3 = true; end;
	if WindowManager.callSafeControlUpdate(self, "spelltype", bReadOnly, not bSpell) then bSection3 = true; end;
	if WindowManager.callSafeControlUpdate(self, "spellresist", bReadOnly, not bSpell) then bSection3 = true; end;
	if WindowManager.callSafeControlUpdate(self, "spellduration", bReadOnly, not bSpell) then bSection3 = true; end;
	if WindowManager.callSafeControlUpdate(self, "spellcost", bReadOnly, not bSpell) then bSection3 = true; end;
	if WindowManager.callSafeControlUpdate(self, "spelltimetocast", bReadOnly, not bSpell) then bSection3 = true; end;
	if WindowManager.callSafeControlUpdate(self, "spellprerequisite", bReadOnly, not bSpell) then bSection3 = true; end;
	divider3.setVisible(bSection3);

	local bSection4 = false;
	if WindowManager.callSafeControlUpdate(self, "powerskill", bReadOnly, not bPower) then bSection4 = true; end;
	if WindowManager.callSafeControlUpdate(self, "powerdefault", bReadOnly, not bPower) then bSection4 = true; end;
	divider4.setVisible(bSection4);

	local bSection5 = false;
	if WindowManager.callSafeControlUpdate(self, "otherpoints", bReadOnly, not bOther) then bSection5 = true; end;
	if WindowManager.callSafeControlUpdate(self, "otherlevel", bReadOnly, not bOther) then bSection5 = true; end;
	if WindowManager.callSafeControlUpdate(self, "otherdefault", bReadOnly, not bOther) then bSection5 = true; end;
	divider5.setVisible(bSection5);

	text.setReadOnly(bReadOnly);
end
