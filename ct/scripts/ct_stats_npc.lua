-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
    DB.addHandler(DB.getPath(getDatabaseNode(), "attributes.hitpoints"), "onUpdate", self.onHitPointsChanged);
    DB.addHandler(DB.getPath(getDatabaseNode(), "attributes.fatiguepoints"), "onUpdate", self.onFatiguePointsChanged);
end

function onClose()
    DB.removeHandler(DB.getPath(getDatabaseNode(), "attributes.hitpoints"), "onUpdate", self.onHitPointsChanged);
    DB.removeHandler(DB.getPath(getDatabaseNode(), "attributes.fatiguepoints"), "onUpdate", self.onFatiguePointsChanged);
end

function onHitPointsChanged(nodeField)
    DB.setValue(getDatabaseNode(), "hps", "number", nodeField.getValue());

    ActionDamage.updateDamage(getDatabaseNode());
    ActionFatigue.updateFatigue(getDatabaseNode());
end

function onFatiguePointsChanged(nodeField)
    DB.setValue(getDatabaseNode(), "fps", "number", nodeField.getValue());

    ActionDamage.updateDamage(getDatabaseNode());
    ActionFatigue.updateFatigue(getDatabaseNode());
end
