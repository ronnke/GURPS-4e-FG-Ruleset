-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	if super and super.onInit then
		super.onInit();
	end
	self.onHealthChanged();
	self.onFatigueChanged();
end

function onFactionChanged()
	super.onFactionChanged();
	updateHealthDisplay();
end
function onHealthChanged()
	local _, _, sColor = ActorManagerGURPS4e.getInjuryStatus(getDatabaseNode());

	hps.setColor(sColor);
	status.setColor(sColor);
end
function onFatigueChanged()
	local _, _, sColor = ActorManagerGURPS4e.getFatigueStatus(getDatabaseNode());

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
