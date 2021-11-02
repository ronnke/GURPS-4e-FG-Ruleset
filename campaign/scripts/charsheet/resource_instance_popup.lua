-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	onStateChanged();
	onNameUpdated();
	update();
end

function onLockChanged()
	onStateChanged();
end

function onStateChanged()
	update();
end

function onNameUpdated()
	local nodeRecord = getDatabaseNode();
	
	local sTooltip = DB.getValue(nodeRecord, "name", "");
	if sTooltip == "" then
		sTooltip = Interface.getString("library_recordtype_empty_item")
	end
	setTooltipText(sTooltip);
end

function update()
	local nodeRecord = getDatabaseNode();
	local bReadOnly = WindowManager.getReadOnlyState(nodeRecord);
	self["minlevel"].update(bReadOnly);
	self["maxlevel"].update(bReadOnly);
	self["defaults"].update(bReadOnly);
	self["text"].update(bReadOnly);
end
