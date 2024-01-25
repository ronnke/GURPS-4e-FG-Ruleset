-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	onFactionChanged();
    updateHealthDisplay();
end

function updateDisplay()
	local sFaction = friendfoe.getStringValue();
	local sOptCTSI = OptionsManager.getOption("CTSI");
	local bShowSpeed = ((sOptCTSI == "friend") and (sFaction == "friend")) or (sOptCTSI == "on");
    speed.setVisible(bShowSpeed);
	
	if active.getValue() == 1 then
		name.setFont("sheetlabel");
		nonid_name.setFont("sheetlabel");

		active_spacer_top.setVisible(true);
		active_spacer_bottom.setVisible(true);
		
		if sFaction == "friend" then
			setFrame("ctentrybox_friend_active");
		elseif sFaction == "neutral" then
			setFrame("ctentrybox_neutral_active");
		elseif sFaction == "foe" then
			setFrame("ctentrybox_foe_active");
		else
			setFrame("ctentrybox_active");
		end
		
		windowlist.scrollToWindow(self);
	else
		name.setFont("sheettext");
		nonid_name.setFont("sheettext");

		active_spacer_top.setVisible(false);
		active_spacer_bottom.setVisible(false);
		
		if sFaction == "friend" then
			setFrame("ctentrybox_friend");
		elseif sFaction == "neutral" then
			setFrame("ctentrybox_neutral");
		elseif sFaction == "foe" then
			setFrame("ctentrybox_foe");
		else
			setFrame("ctentrybox");
		end
	end
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

function onActiveChanged()
	updateDisplay();
    updateHealthDisplay();
end

function onFactionChanged()
	updateDisplay();
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

function onIDChanged()
	local nodeRecord = getDatabaseNode();
	local sClass = DB.getValue(nodeRecord, "link", "npc", "");
	if sClass == "npc" then
		local bID = LibraryData.getIDState("npc", nodeRecord, true);
		name.setVisible(bID);
		nonid_name.setVisible(not bID);
	else
		name.setVisible(true);
		nonid_name.setVisible(false);
	end
end
