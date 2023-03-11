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
	self["points"].update(bReadOnly);
	self["otherlevel"].update(bReadOnly);
	self["defaults"].update(bReadOnly);
	self["text"].update(bReadOnly);
	self["page"].update(bReadOnly);
end
