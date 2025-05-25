-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	registerOptions();
end

function registerOptions()
-- GURPS Options  
	OptionsManager.registerOptionData({
		sKey = "SHPC", sGroupRes = "option_header_combat",
		tCustom = { labelsres = "option_val_detailed|option_val_status", values = "detailed|status", baselabelres = "option_val_off", baseval = "off", default = "detailed", },
	});
			
	OptionsManager.registerOptionData({	
		sKey = "SHNPC", sGroupRes = "option_header_combat",
		tCustom = { labelsres = "option_val_detailed|option_val_status", values = "detailed|status", baselabelres = "option_val_off", baseval = "off", default = "status", },
	});

	OptionsManager.registerOptionData({	
		sKey = "AUTORANGE", sGroupRes = "option_header_combat", bLocal = true,
		tCustom = { labelsres = "option_val_on|option_val_off", values = "on|off", baselabelres = "option_val_off", baseval = "off", default = "off", },
	});

	OptionsManager.registerOptionData({	
		sKey = "RNDINIT", sGroupRes = "option_header_houserule",
		tCustom = { labelsraw = "+d4|+d6|+d4 x 0.25|+d6 x 0.25", values = "d4|d6|d4x|d6x", baselabelres = "option_val_off", baseval = "", default = "", },
	});
	OptionsManager.registerOptionData({	
		sKey = "INIT", sGroupRes = "option_header_houserule",
		tCustom = { labelsres = "option_val_on|option_val_group", values = "on|group", baselabelres = "option_val_off", baseval = "off", default = "group", },
	});
end
