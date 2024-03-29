-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	registerDiceRolls();
	registerOptions();
end

function registerDiceRolls()
	DiceRollManager.registerDamageKey();
	DiceRollManager.registerDamageTypeKey("cr");
	DiceRollManager.registerDamageTypeKey("cut");
	DiceRollManager.registerDamageTypeKey("imp");
	DiceRollManager.registerDamageTypeKey("pi-");
	DiceRollManager.registerDamageTypeKey("pi");
	DiceRollManager.registerDamageTypeKey("pi+");
	DiceRollManager.registerDamageTypeKey("pi++");
	DiceRollManager.registerDamageTypeKey("burn");
	DiceRollManager.registerDamageTypeKey("cor");
	DiceRollManager.registerDamageTypeKey("tox");
	DiceRollManager.registerDamageTypeKey("fat");
end

function registerOptions()
-- GURPS Options  
	OptionsManager.registerOption2("SHPC", false, "option_header_combat", "option_label_SHPC", "option_entry_cycler", 
			{ labels = "option_val_detailed|option_val_status", values = "detailed|status", baselabel = "option_val_off", baseval = "off", default = "detailed" });
	OptionsManager.registerOption2("SHNPC", false, "option_header_combat", "option_label_SHNPC", "option_entry_cycler", 
			{ labels = "option_val_detailed|option_val_status", values = "detailed|status", baselabel = "option_val_off", baseval = "off", default = "status" });
end
