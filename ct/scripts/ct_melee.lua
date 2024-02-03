-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

--
--	SECTION HANDLING
--

function getSectionToggle(sKey)
	local bResult = false;

	local sButtonName = "button_section_" .. sKey;
	local cButton = self[sButtonName];
	if cButton then
		bResult = (cButton.getValue() == 1);
	end

	return bResult;
end

function onSectionChanged(sKey)
	local bShow = self.getSectionToggle(sKey);

	local sSectionName = "sub_" .. sKey;
	local cSection = self[sSectionName];
	if cSection then
		cSection.setVisible(bShow);
	end
end
