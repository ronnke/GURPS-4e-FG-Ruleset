-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	super.onInit();
	self.onHealthChanged();
	self.onFatigueChanged();
end

function onFactionChanged()
	super.onFactionChanged();
	updateHealthDisplay();
end
function onHealthChanged()
	local sColor = ActorManagerGURPS4e.getInjuryStatusColor("ct", getDatabaseNode());

	hps.setColor(sColor);
	status.setColor(sColor);
end
function onFatigueChanged()
	local sColor, sStatus, nStatus = ActorManagerGURPS4e.getFatigueStatusColor("ct", getDatabaseNode());

	fps.setColor(sColor);
end

function updateHealthDisplay()
	local sFaction = friendfoe.getStringValue();
    local sOptSHPC = OptionsManager.getOption("SHPC");
    local sOptSHNPC = OptionsManager.getOption("SHNPC");
    local bShowDetail = (sFaction == "friend" and sOptSHPC == "detailed") or (sFaction ~= "friend" and sOptSHNPC == "detailed");
    local bStatusOff = (sFaction == "friend" and sOptSHPC == "off") or (sFaction ~= "friend" and sOptSHNPC == "off") or bShowDetail;

	hps.setVisible(bShowDetail);
	fps.setVisible(bShowDetail);
	injury.setVisible(bShowDetail);
	fatigue.setVisible(bShowDetail);
	status.setVisible(not bStatusOff);
end

function updateShowOrder()
	local sFaction = friendfoe.getStringValue();
	local sOptCTSI = OptionsManager.getOption("CTSI");
	local bShowSpeed = ((sOptCTSI == "friend") and (sFaction == "friend")) or (sOptCTSI == "on");
    speed.setVisible(bShowSpeed);
end
