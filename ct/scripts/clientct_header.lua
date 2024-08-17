-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
    OptionsManager.registerCallback("SHPC", updateHealthDisplay);
    OptionsManager.registerCallback("SHNPC", updateHealthDisplay);
    OptionsManager.registerCallback("CTSI", updateShowOrder);
    updateHealthDisplay();
    updateShowOrder();
end

function onClose()
    OptionsManager.unregisterCallback("SHPC", updateHealthDisplay);
    OptionsManager.unregisterCallback("SHNPC", updateHealthDisplay);
    OptionsManager.unregisterCallback("CTSI", updateShowOrder);
end

function updateHealthDisplay()
    local sOptSHPC = OptionsManager.getOption("SHPC");
    local sOptSHNPC = OptionsManager.getOption("SHNPC");
    local bShowDetail = (sOptSHPC == "detailed" or sOptSHNPC == "detailed");
    local bStatusOff = (sOptSHPC == "off" and sOptSHNPC == "off") or bShowDetail;

	label_hps.setVisible(bShowDetail);
	label_fps.setVisible(bShowDetail);
	label_injury.setVisible(bShowDetail);
	label_fatigue.setVisible(bShowDetail);

	label_status.setVisible(not bStatusOff);
	label_status_spacer.setVisible(bStatusOff and not bShowDetail);
end

function updateShowOrder()
    local bShowSpeed = not OptionsManager.isOption("CTSI", "off");
    label_speed.setVisible(bShowSpeed);
end
