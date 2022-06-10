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
		local bHasGrid = super.getImage().hasGrid();
		local bRangeModifierOn = (rangemodifer.getValue() ~= 0);
			    
		rangemodifer.setVisible(bHasGrid)
        rangescale_h2.setVisible(bHasGrid);
		scaleunits.setVisible(bRangeModifierOn)
        rangescale_h1.setVisible(bRangeModifierOn);

		if bRangeModifierOn then
			super.getImage().setDistanceSuffix(scaleunits.getStringValue());
		end
	end
end

function onScaleUnitsValueChanged()
	if Session.IsHost then
		local bRangeModifierOn = (rangemodifer.getValue() ~= 0);
		if bRangeModifierOn then
			super.getImage().setDistanceSuffix(scaleunits.getStringValue());
		end
	end
end

function onRangeModifierButtonPressed()
	if Session.IsHost then
		local bRangeModifierOn = (rangemodifer.getValue() ~= 0);
			    
		scaleunits.setVisible(bRangeModifierOn)
		rangescale_h1.setVisible(bRangeModifierOn);

		if bRangeModifierOn then
			super.getImage().setDistanceSuffix(scaleunits.getStringValue());
			scaleunits.setStringValue("yd");
		end
	end
end
