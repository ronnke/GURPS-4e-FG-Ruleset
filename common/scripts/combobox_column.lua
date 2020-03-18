function onInit()
	super.onInit();
	if isReadOnly() then
		self.update(true);
	else
		local node = getDatabaseNode();
		if not node or node.isReadOnly() then
			self.update(true);
		end
	end
end

function update(bReadOnly, bForceHide)
	local bLocalShow;
	if bForceHide then
		bLocalShow = false;
	else
		bLocalShow = true;
		if bReadOnly and not nohide and isEmpty() then
			bLocalShow = false;
		end
	end
	
	setVisible(bLocalShow);
	setComboBoxReadOnly(bReadOnly or not bLocalShow)
					
	local sLabel = getName() .. "_label";
	if window[sLabel] then
		window[sLabel].setVisible(bLocalShow);
	end
	if separator then
		if window[separator[1]] then
			window[separator[1]].setVisible(bLocalShow);
		end
	end
	
	if self.onVisUpdate then
		self.onVisUpdate(bLocalShow, bReadOnly);
	end
	
	return bLocalShow;
end

function onVisUpdate(bLocalShow, bReadOnly)
	if bReadOnly then
		setFrame(nil);
	else
		setFrame("fielddark", 7,5,7,5);
	end
end

function onValueChanged()
	if isVisible() then
		if window.VisDataCleared then
			if isEmpty() then
				window.VisDataCleared();
			end
		end
	else
		if window.InvisDataAdded then
			if not isEmpty() then
				window.InvisDataAdded();
			end
		end
	end
end