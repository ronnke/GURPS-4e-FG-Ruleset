-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	if super and super.onInit then
		super.onInit();
	end

    local node = getDatabaseNode();
    DB.addHandler(DB.getPath(node, "injury"), "onUpdate", self.onInjuryChanged);
    DB.addHandler(DB.getPath(node, "fatigue"), "onUpdate", self.onFatigueChanged);

	self.onInjuryChanged();
	self.onFatigueChanged();
end

function onClose()
    local node = getDatabaseNode();
	DB.removeHandler(DB.getPath(node, "injury"), "onUpdate", self.onInjuryChanged);
	DB.removeHandler(DB.getPath(node, "fatigue"), "onUpdate", self.onFatigueChanged);
end

function onFactionChanged()
	super.onFactionChanged();
	updateHealthDisplay();
end
function onInjuryChanged()
	local rActor = ActorManager.resolveActor(getDatabaseNode())
	local _, _, sColor = ActorManagerGURPS4e.getInjuryStatus(rActor);
	hps.setColor(sColor);
	status.setColor(sColor);
end
function onFatigueChanged()
	local rActor = ActorManager.resolveActor(getDatabaseNode())
	local _, _, sColor = ActorManagerGURPS4e.getFatigueStatus(rActor);
	fps.setColor(sColor);
end

function updateHealthDisplay()
	local sFaction = friendfoe.getValue();
	local sOption = (sFaction == "friend") and OptionsManager.getOption("SHPC") or OptionsManager.getOption("SHNPC");

	local bShowDetail = (sOption == "detailed");
	local bShowStatus = (sOption == "status");

	hps.setVisible(bShowDetail);
	fps.setVisible(bShowDetail);
	injury.setVisible(bShowDetail);
	fatigue.setVisible(bShowDetail);
	status.setVisible(bShowStatus);
end

function updateShowOrder()
	local sFaction = friendfoe.getValue();
	local sOptCTSI = OptionsManager.getOption("CTSI");
	local bShowSpeed = ((sOptCTSI == "friend") and (sFaction == "friend")) or (sOptCTSI == "on");
    speed.setVisible(bShowSpeed);
end
