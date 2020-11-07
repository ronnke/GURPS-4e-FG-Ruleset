-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	onStateChanged();
	onNameUpdated();
end

function onLockChanged()
	onStateChanged();
end

function onIDChanged()
	onStateChanged();
	onNameUpdated();
end

function onStateChanged()
	if header.subwindow then
		header.subwindow.update();
	end
	if details.subwindow then
		details.subwindow.update();
	end
end

function onNameUpdated()
	local nodeRecord = getDatabaseNode();
	
	local sTooltip = DB.getValue(nodeRecord, "name", "");
	if sTooltip == "" then
		sTooltip = Interface.getString("library_recordtype_empty_item")
	end
	setTooltipText(sTooltip);
	if header.subwindow and header.subwindow.link then
		header.subwindow.link.setTooltipText(sTooltip);
	end
end
