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
	local bID = LibraryData.getIDState("npc", nodeRecord);

	local bSection1 = false;
	if Session.IsHost then
		if WindowManager.callSafeControlUpdate(self, "nonid_name", bReadOnly) then bSection1 = true; end;
	else
		WindowManager.callSafeControlUpdate(self, "nonid_name", bReadOnly, true);
	end
	divider.setVisible(bSection1);

	local bSection2 = false;
	if WindowManager.callSafeControlUpdate(self, "type", bReadOnly) then bSection2 = true; end;
	if WindowManager.callSafeControlUpdate(self, "pts", bReadOnly) then bSection2 = true; end;
	divider1.setVisible(bSection2);

	WindowManager.callSafeControlUpdate(self, "strength", bReadOnly);
	WindowManager.callSafeControlUpdate(self, "dexterity", bReadOnly);
	WindowManager.callSafeControlUpdate(self, "intelligence", bReadOnly, false);
	WindowManager.callSafeControlUpdate(self, "health", bReadOnly, false);
	WindowManager.callSafeControlUpdate(self, "hitpoints", bReadOnly, false);
	WindowManager.callSafeControlUpdate(self, "will", bReadOnly, false);
	WindowManager.callSafeControlUpdate(self, "perception", bReadOnly, false);
	WindowManager.callSafeControlUpdate(self, "fatiguepoints", bReadOnly, false);
  
	WindowManager.callSafeControlUpdate(self, "basicspeed", bReadOnly, false);
	WindowManager.callSafeControlUpdate(self, "move", bReadOnly, false);
	WindowManager.callSafeControlUpdate(self, "sizemodifier", bReadOnly, false);
	WindowManager.callSafeControlUpdate(self, "reach", bReadOnly, false);
	WindowManager.callSafeControlUpdate(self, "swing", bReadOnly, false);
	WindowManager.callSafeControlUpdate(self, "thrust", bReadOnly, false);

	WindowManager.callSafeControlUpdate(self, "reactionmodifiers", bReadOnly, false);

	traits_label.setVisible(not bReadOnly or not traits.isEmpty());
	WindowManager.callSafeControlUpdate(self, "traits", bReadOnly, false);
end

function onDrop(x, y, draginfo)
	if WindowManager.getReadOnlyState(getDatabaseNode()) then
    	return true;
	end

	if draginfo.isType("shortcut") and not bReadOnly then
		local sClass = draginfo.getShortcutData();
		local nodeSource = draginfo.getDatabaseNode();

		if sClass == "reference_trait" or sClass == "trait" then
			ActorManager2.addTrait(getDatabaseNode(), nodeSource);
		end;
		return true;
	end
end
