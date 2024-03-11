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

	local bSection1 = false;
	if WindowManager.callSafeControlUpdate(self, "resource_level", false) then bSection1 = true; end;
	divider1.setVisible(bSection1);

	local bSection2 = false;
	if WindowManager.callSafeControlUpdate(self, "min_level", bReadOnly) then bSection2 = true; end;
	if WindowManager.callSafeControlUpdate(self, "max_level", bReadOnly) then bSection2 = true; end;
--	if WindowManager.callSafeControlUpdate(self, "defaults", bReadOnly) then bSection2 = true; end; To be developed
	divider2.setVisible(bSection2);

	text.setReadOnly(bReadOnly);
end
