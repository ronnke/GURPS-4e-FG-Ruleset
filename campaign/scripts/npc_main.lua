-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	self.onLockModeChanged(WindowManager.getWindowReadOnlyState(self));
end

function onLockModeChanged(bReadOnly)
	WindowManager.callSafeControlsSetLockMode(self, { "pts", "type" }, bReadOnly);
	divider1.setVisible(WindowManager.getAnyControlVisible(self, { "type", "pts" }));

	WindowManager.callSafeControlsSetLockMode(self, { "strength", "dexterity", "intelligence", "health", "hitpoints", "will", "perception", "fatiguepoints" }, bReadOnly);
	WindowManager.callSafeControlsSetLockMode(self, { "basicspeed", "move", "sizemodifier", "reach", "swing", "thrust", "reactionmodifiers" }, bReadOnly);
  
	WindowManager.callSafeControlsSetLockMode(self, {"traits"}, bReadOnly);
	traits_label.setVisible(WindowManager.getAnyControlVisible(self, { "traits" }))
end

function onDrop(x, y, draginfo)
	if WindowManager.getReadOnlyState(getDatabaseNode()) then
    	return true;
	end

	if draginfo.isType("shortcut") and not bReadOnly then
		local sClass = draginfo.getShortcutData();
		local nodeSource = draginfo.getDatabaseNode();

		if sClass == "reference_trait" or sClass == "trait" then
			CharManager.addTrait(getDatabaseNode(), nodeSource);
		end;
		return true;
	end
end