-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	registerOptions();
end

function registerOptions()
-- GURPS Options  
	OptionsManager.registerOption2("SHPC", false, "option_header_combat", "option_label_SHPC", "option_entry_cycler", 
			{ labels = "option_val_detailed|option_val_status", values = "detailed|status", baselabel = "option_val_off", baseval = "off", default = "detailed" });
	OptionsManager.registerOption2("SHNPC", false, "option_header_combat", "option_label_SHNPC", "option_entry_cycler", 
			{ labels = "option_val_detailed|option_val_status", values = "detailed|status", baselabel = "option_val_off", baseval = "off", default = "status" });

-- CoreRPG Options  
	if not UtilityManager.isClientFGU() then
		OptionsManager.registerOption2("DDCL", false, "option_header_game", "option_label_DDCL", "option_entry_cycler", 
			{ labels = "option_val_DDCL_gurps|option_val_DDCL_dfrpg|option_val_DDCL_sw", values = "desktopdecal_gurps|desktopdecal_dfrpg|desktopdecal_sw", baselabel = "option_val_off", baseval = "off", default = "off" });
	end
end
