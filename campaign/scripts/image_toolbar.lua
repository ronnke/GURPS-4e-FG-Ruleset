--
-- Please see the license.html file included with this distribution for
-- attribution and copyright information.
--

function onInit()
	super.onInit();
	updateRangeScale();
end

function update(bInit)
	super.update(bInit)
	updateRangeScale();
end

function updateRangeScale()
	if Session.IsHost then
		local cImage = WindowManager.callOuterWindowFunction(self, "getImage");
		local bHasGrid = cImage.hasGrid();
		local bRangeModifierOn = (rangemodifer.getValue() ~= 0);
			    
		rangemodifer.setVisible(bHasGrid)
        rangescale_h2.setVisible(bHasGrid);
		scaleunits.setVisible(bRangeModifierOn)
        rangescale_h1.setVisible(bRangeModifierOn);

		if bRangeModifierOn then
			cImage.setDistanceSuffix(scaleunits.getStringValue());
		end
	end
end

function onScaleUnitsValueChanged()
	if Session.IsHost then
		local cImage = WindowManager.callOuterWindowFunction(self, "getImage");
		local bRangeModifierOn = (rangemodifer.getValue() ~= 0);
		if bRangeModifierOn then
			cImage.setDistanceSuffix(scaleunits.getStringValue());
		end
	end
end

function onRangeModifierButtonPressed()
	if Session.IsHost then
		local cImage = WindowManager.callOuterWindowFunction(self, "getImage");
		local bRangeModifierOn = (rangemodifer.getValue() ~= 0);
			    
		scaleunits.setVisible(bRangeModifierOn)
		rangescale_h1.setVisible(bRangeModifierOn);

		if bRangeModifierOn then
			cImage.setDistanceSuffix(scaleunits.getStringValue());
			scaleunits.setStringValue("yd");
		end
	end
end
