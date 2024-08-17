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
	local bID = LibraryData.getIDState("npc", nodeRecord);

	local bSection1 = false;
	if Session.IsHost then
		if WindowManager.callSafeControlUpdate(self, "nonid_name", bReadOnly) then bSection1 = true; end;
	else
		WindowManager.callSafeControlUpdate(self, "nonid_name", bReadOnly, true);
	end
	divider1.setVisible(bSection1);

	local bSection2 = false;
	if WindowManager.callSafeControlUpdate(self, "type", bReadOnly) then bSection2 = true; end;
	if WindowManager.callSafeControlUpdate(self, "pts", bReadOnly) then bSection2 = true; end;
	divider2.setVisible(bSection2);

	WindowManager.callSafeControlUpdate(self, "strength", bReadOnly);
	WindowManager.callSafeControlUpdate(self, "dexterity", bReadOnly);
	WindowManager.callSafeControlUpdate(self, "intelligence", bReadOnly);
	WindowManager.callSafeControlUpdate(self, "health", bReadOnly);
	WindowManager.callSafeControlUpdate(self, "hitpoints", bReadOnly);
	WindowManager.callSafeControlUpdate(self, "will", bReadOnly);
	WindowManager.callSafeControlUpdate(self, "perception", bReadOnly);
	WindowManager.callSafeControlUpdate(self, "fatiguepoints", bReadOnly);
  
	WindowManager.callSafeControlUpdate(self, "basicspeed", bReadOnly);
	WindowManager.callSafeControlUpdate(self, "move", bReadOnly);
	WindowManager.callSafeControlUpdate(self, "sizemodifier", bReadOnly);
	WindowManager.callSafeControlUpdate(self, "reach", bReadOnly);
	WindowManager.callSafeControlUpdate(self, "swing", bReadOnly);
	WindowManager.callSafeControlUpdate(self, "thrust", bReadOnly);

	WindowManager.callSafeControlUpdate(self, "reactionmodifiers", bReadOnly);

	traits_label.setVisible(not bReadOnly or not traits.isEmpty())
	WindowManager.callSafeControlUpdate(self, "traits", bReadOnly);
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
