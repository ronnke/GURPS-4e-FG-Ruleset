-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	update();
end

function update()
	local nodeRecord = getDatabaseNode();
	local bReadOnly = WindowManager.getReadOnlyState(nodeRecord);
	self["type"].update(bReadOnly);
	self["points"].update(bReadOnly);
	self["college"].update(bReadOnly);
	self["class"].update(bReadOnly);
	self["resist"].update(bReadOnly);
	self["text"].update(bReadOnly);
	self["duration"].update(bReadOnly);
	self["costmaintain"].update(bReadOnly);
	self["time"].update(bReadOnly);
	self["prereqs"].update(bReadOnly);
	self["page"].update(bReadOnly);
	self["level_adj"].update(bReadOnly);
    self["points_adj"].update(bReadOnly);
end
