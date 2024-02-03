-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	super.onInit();

    self.onInjuryChanged();
    self.onFatigueChanged();

	self.onSkipChanged();
    
    DB.addHandler(DB.getPath(getDatabaseNode(), "injury"), "onUpdate", self.onInjuryChanged);
    DB.addHandler(DB.getPath(getDatabaseNode(), "fatigue"), "onUpdate", self.onFatigueChanged);
    DB.addHandler(DB.getPath(getDatabaseNode(), "traits.sizemodifier"), "onUpdate", self.onSMReachChanged);
    DB.addHandler(DB.getPath(getDatabaseNode(), "traits.reach"), "onUpdate", self.onSMReachChanged);
end

function onClose()
    DB.removeHandler(DB.getPath(getDatabaseNode(), "injury"), "onUpdate", self.onInjuryChanged);
    DB.removeHandler(DB.getPath(getDatabaseNode(), "fatigue"), "onUpdate", self.onFatigueChanged);
    DB.removeHandler(DB.getPath(getDatabaseNode(), "traits.sizemodifier"), "onUpdate", self.onSMReachChanged);
    DB.removeHandler(DB.getPath(getDatabaseNode(), "traits.reach"), "onUpdate", self.onSMReachChanged);
end

function onActiveChanged()
	self.onSectionChanged("stats");
	self.onSectionChanged("combat");
end

function getSectionToggle(sKey)
	local bResult = false;

	local sButtonName = "button_section_" .. sKey;
	local cButton = self[sButtonName];
	if cButton then
		bResult = (cButton.getValue() == 1);
		if ((sKey == "stats") or (sKey == "combat")) and self.isActive() and not self.isPC() then
			bResult = true;
		end
	end

	return bResult;
end

function onHitPointsChanged(nValue)
    hitpoints.setValue(nValue);
	self.onInjuryChanged();
end

function onFatiguePointsChanged(nValue)
    fatiguepoints.setValue(nValue);
	self.onFatigueChanged();
end

function onInjuryChanged()
    local rActor = ActorManager.resolveActor(getDatabaseNode());
    ActionDamage.updateDamage(rActor);

    local sColor, sStatus, nStatus = ActorManagerGURPS4e.getInjuryStatusColor("ct", getDatabaseNode());

    hps.setColor(sColor);
    status.setValue(sStatus);
    ctstatus.subwindow.hpstatus.setColor(sColor);
end

function onFatigueChanged()
    local rActor = ActorManager.resolveActor(getDatabaseNode());
    ActionFatigue.updateFatigue(rActor);

    local sColor, sStatus, nStatus = ActorManagerGURPS4e.getFatigueStatusColor("ct", getDatabaseNode());

    fps.setColor(sColor);
    ctstatus.subwindow.fpstatus.setColor(sColor);
end

function onSMReachChanged()
    local node = getDatabaseNode();
    CombatManagerGURPS4e.updateSpaceReach(node);
end

function onSkipChanged()
  local nodeRecord = getDatabaseNode();
  DB.setValue(nodeRecord, "skip", "number", skip.getValue());
end

function linkPCFields()
  local nodeChar = link.getTargetDatabaseNode();
  if nodeChar then
    name.setLink(DB.createChild(nodeChar, "name", "string"), true);
	senses.setLink(DB.createChild(nodeChar, "senses", "string"), true);

    strength.setLink(DB.createChild(nodeChar, "attributes.strength", "number"), true);
    dexterity.setLink(DB.createChild(nodeChar, "attributes.dexterity", "number"), true);
    intelligence.setLink(DB.createChild(nodeChar, "attributes.intelligence", "number"), true);
    health.setLink(DB.createChild(nodeChar, "attributes.health", "number"), true);
    hitpoints.setLink(DB.createChild(nodeChar, "attributes.hitpoints", "number"), true);
    will.setLink(DB.createChild(nodeChar, "attributes.will", "number"), true);
    perception.setLink(DB.createChild(nodeChar, "attributes.perception", "number"), true);
    fatiguepoints.setLink(DB.createChild(nodeChar, "attributes.fatiguepoints", "number"), true);

    sizemodifier.setLink(DB.createChild(nodeChar, "traits.sizemodifier", "string"), true);
    reach.setLink(DB.createChild(nodeChar, "traits.reach", "string"), true);

    dodge.setLink(DB.createChild(nodeChar, "combat.dodge", "number"), true);
    parry.setLink(DB.createChild(nodeChar, "combat.parry", "number"), true);
    block.setLink(DB.createChild(nodeChar, "combat.block", "number"), true);
    dr.setLink(DB.createChild(nodeChar, "combat.dr", "string"), true);
    move.setLink(DB.createChild(nodeChar, "attributes.move", "string"), true);
	
	halfmovedodge.setLink(DB.createChild(nodeChar, "attributes.halfmovedodge", "number"));

    hps.setLink(nodeChar.createChild("attributes.hps", "number"));
    fps.setLink(nodeChar.createChild("attributes.fps", "number"));
    injury.setLink(nodeChar.createChild("attributes.injury", "number"));
    fatigue.setLink(nodeChar.createChild("attributes.fatigue", "number"));
    hpstatus.setLink(nodeChar.createChild("attributes.hpstatus", "string"));
    fpstatus.setLink(nodeChar.createChild("attributes.fpstatus", "string"));
  end
end
