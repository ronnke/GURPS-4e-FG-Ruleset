-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	onIDChanged();
end

function onLockChanged()
	onStateChanged();
end

function onStateChanged()
	if header.subwindow then
		header.subwindow.update();
	end
	if main.subwindow then
		main.subwindow.update();
	end
	if combat.subwindow then
    	combat.subwindow.update();
	end
	if abilities.subwindow then
		abilities.subwindow.update();
	end

	local bReadOnly = WindowManager.getReadOnlyState(getDatabaseNode());
	notes.setReadOnly(bReadOnly);
end

function onIDChanged()
	if User.isHost() then
		if main.subwindow then
			main.subwindow.update();
		end
		if combat.subwindow then
    		combat.subwindow.update();
		end
		if abilities.subwindow then
			abilities.subwindow.update();
		end
	else
		local bID = LibraryData.getIDState("npc", getDatabaseNode(), true);
		tabs.setVisibility(bID);
	end
end
