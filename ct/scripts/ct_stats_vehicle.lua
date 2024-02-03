-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
    DB.addHandler(DB.getPath(getDatabaseNode(), "sthp"), "onUpdate", self.onHPSTChanged);
end

function onClose()
    DB.removeHandler(DB.getPath(getDatabaseNode(), "sthp"), "onUpdate", self.onHPSTChanged);
end

function onHPSTChanged()
    DB.setValue(getDatabaseNode(), "attributes.hitpoints", "number", ManagerGURPS4e.getVehicleHP(getDatabaseNode()));
    DB.setValue(getDatabaseNode(), "hps", "number", ManagerGURPS4e.getVehicleHP(getDatabaseNode()));

    ActionDamage.updateDamage(getDatabaseNode());
    ActionFatigue.updateFatigue(getDatabaseNode());
end
