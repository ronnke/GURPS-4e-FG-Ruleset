-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
    DB.addHandler(DB.getPath(getDatabaseNode(), "sm"), "onUpdate", self.onSMChanged);
    DB.addHandler(DB.getPath(getDatabaseNode(), "dr"), "onUpdate", self.onDRChanged);
end

function onClose()
    DB.removeHandler(DB.getPath(getDatabaseNode(), "sm"), "onUpdate", self.onSMChanged);
    DB.removeHandler(DB.getPath(getDatabaseNode(), "dr"), "onUpdate", self.onDRChanged);
end

function onSMChanged(nodeField)
    local node = getDatabaseNode();
    DB.setValue(node, "traits.sizemodifier", "string", nodeField.getValue());
end

function onDRChanged(nodeField)
    local node = getDatabaseNode();
    DB.setValue(node, "combat.dr", "string", nodeField.getValue());
end
