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
	if WindowManager.callSafeControlUpdate(self, "type", bReadOnly) then bSection1 = true; end;
	if WindowManager.callSafeControlUpdate(self, "subtype", bReadOnly) then bSection1 = true; end;
	if WindowManager.callSafeControlUpdate(self, "points", bReadOnly) then bSection1 = true; end;
	if WindowManager.callSafeControlUpdate(self, "college", bReadOnly) then bSection1 = true; end;
	if WindowManager.callSafeControlUpdate(self, "class", bReadOnly) then bSection1 = true; end;
	if WindowManager.callSafeControlUpdate(self, "resist", bReadOnly) then bSection1 = true; end;
	if WindowManager.callSafeControlUpdate(self, "duration", bReadOnly) then bSection1 = true; end;
	if WindowManager.callSafeControlUpdate(self, "costmaintain", bReadOnly) then bSection1 = true; end;
	if WindowManager.callSafeControlUpdate(self, "time", bReadOnly) then bSection1 = true; end;
	if WindowManager.callSafeControlUpdate(self, "prereqs", bReadOnly) then bSection1 = true; end;
	if WindowManager.callSafeControlUpdate(self, "page", bReadOnly) then bSection1 = true; end;
	if WindowManager.callSafeControlUpdate(self, "level_adj", bReadOnly) then bSection1 = true; end;
	if WindowManager.callSafeControlUpdate(self, "points_adj", bReadOnly) then bSection1 = true; end;
	divider1.setVisible(bSection1);

	text.setReadOnly(bReadOnly)
end
