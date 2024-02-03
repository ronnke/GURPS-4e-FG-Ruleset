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
	local sOption;
	if friendfoe.getStringValue() == "friend" then
		sOption = OptionsManager.getOption("SHPC");
	else
		sOption = OptionsManager.getOption("SHNPC");
	end
  
	if sOption == "detailed" then
		hps.setVisible(true);
		fps.setVisible(true);
		injury.setVisible(true);
		fatigue.setVisible(true);
		status.setVisible(false);
	elseif sOption == "status" then
		hps.setVisible(false);
		fps.setVisible(false);
		injury.setVisible(false);
		fatigue.setVisible(false);
		status.setVisible(true);
	else
		hps.setVisible(false);
		fps.setVisible(false);
		injury.setVisible(false);
		fatigue.setVisible(false);
		status.setVisible(false);
	end
end

function updateShowOrder()
	local sFaction = friendfoe.getStringValue();
	local sOptCTSI = OptionsManager.getOption("CTSI");
	local bShowSpeed = ((sOptCTSI == "friend") and (sFaction == "friend")) or (sOptCTSI == "on");
    speed.setVisible(bShowSpeed);
end
