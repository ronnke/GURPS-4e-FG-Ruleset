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
		sKey = "RNDINIT", sGroupRes = "option_header_houserule",
		tCustom = { labelsraw = "+d4|+d6", values = "d4|d6", baselabelres = "option_val_default", baseval = "", default = "", },
	});
end
