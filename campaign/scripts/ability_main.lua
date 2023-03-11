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
		
	if bForceHide then
		return self[sControl].update(bReadOnly, true);
	end
	
	return self[sControl].update(bReadOnly);
end

function update()
	local nodeRecord = getDatabaseNode();
	local bReadOnly = WindowManager.getReadOnlyState(nodeRecord);
	
	local bSkill = LibraryDataGURPS4e.isSkill(nodeRecord);
	local bSpell = LibraryDataGURPS4e.isSpell(nodeRecord);
	local bPower = LibraryDataGURPS4e.isPower(nodeRecord);
	local bOther = LibraryDataGURPS4e.isOther(nodeRecord);

	local bSection1 = false;
	if updateControl("type", bReadOnly) then bSection1 = true; end;
	if updateControl("subtype", bReadOnly) then bSection1 = true; end;
	if updateControl("page", bReadOnly) then bSection1 = true; end;

	local bSection2 = false;
	if updateControl("skilltype", bReadOnly, not bSkill) then bSection2 = true; end
	if updateControl("skilldefault", bReadOnly, not bSkill) then bSection2 = true; end
	if updateControl("skillprerequisite", bReadOnly, not bSkill) then bSection2 = true; end

	local bSection3 = false;
	if updateControl("spellcollege", bReadOnly, not bSpell) then bSection3 = true; end
	if updateControl("spellclass", bReadOnly, not bSpell) then bSection3 = true; end
	if updateControl("spelltype", bReadOnly, not bSpell) then bSection3 = true; end
	if updateControl("spellresist", bReadOnly, not bSpell) then bSection3 = true; end
	if updateControl("spellduration", bReadOnly, not bSpell) then bSection3 = true; end
	if updateControl("spellcost", bReadOnly, not bSpell) then bSection3 = true; end
	if updateControl("spelltimetocast", bReadOnly, not bSpell) then bSection3 = true; end
	if updateControl("spellprerequisite", bReadOnly, not bSpell) then bSection3 = true; end

	local bSection4 = false;
	if updateControl("powerskill", bReadOnly, not bPower) then bSection4 = true; end
	if updateControl("powerdefault", bReadOnly, not bPower) then bSection4 = true; end

	local bSection5 = false;
	if updateControl("otherpoints", bReadOnly, not bOther) then bSection5 = true; end
	if updateControl("otherlevel", bReadOnly, not bOther) then bSection5 = true; end
	if updateControl("otherdefault", bReadOnly, not bOther) then bSection5 = true; end

	local bSection6 = false;
	if updateControl("text", bReadOnly) then bSection6 = true; end

	divider1.setVisible(bSection1 and bSection2);
	divider2.setVisible((bSection1 or bSection2) and bSection3);
	divider3.setVisible((bSection1 or bSection2 or bSection3) and bSection4);
	divider4.setVisible((bSection1 or bSection2 or bSection3 or bSection4) and bSection5);
	divider5.setVisible((bSection1 or bSection2 or bSection3 or bSection4 or bSection5) and bSection6);
end
