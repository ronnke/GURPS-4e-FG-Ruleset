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
	
	local bAdvantage = LibraryDataGURPS4e.isAdvantage(nodeRecord);
	local bPerk = LibraryDataGURPS4e.isPerk(nodeRecord);
	local bDisadvantage = LibraryDataGURPS4e.isDisadvantage(nodeRecord);
	local bQuirk = LibraryDataGURPS4e.isQuirk(nodeRecord);

	local bSection1 = false;
	if updateControl("type", bReadOnly) then bSection1 = true; end;
	if updateControl("subtype", bReadOnly) then bSection1 = true; end;
	if updateControl("page", bReadOnly) then bSection1 = true; end;

	local bSection2 = false;
	if updateControl("points", bReadOnly) then bSection2 = true; end

	local bSection3 = false;
	if updateControl("text", bReadOnly) then bSection3 = true; end

	divider1.setVisible(bSection1 and bSection2);
	divider2.setVisible((bSection1 or bSection2) and bSection3);
end
