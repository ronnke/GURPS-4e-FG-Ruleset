-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
    DB.addHandler(DB.getPath(getDatabaseNode(), "attributes.halfmovedodge"), "onUpdate", self.onHalfMoveDodgeChanged);
end

function onClose()
    DB.removeHandler(DB.getPath(getDatabaseNode(), "attributes.halfmovedodge"), "onUpdate", self.onHalfMoveDodgeChanged);
end

function onHalfMoveDodgeChanged(nodeField)
	local nodeChar = DB.getChild(nodeField, "...");
	CombatManagerGURPS4e.updateMoveDodge(nodeChar);
end
