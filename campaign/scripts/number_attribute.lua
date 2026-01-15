-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	if super and super.onInit then
		super.onInit();
	end
	self.onValueChanged();

end

function update(bReadOnly)
	setReadOnly(bReadOnly);
end

function onValueChanged()
end

-- function onDragStart(_, _, _, draginfo)
--	if window.onCheckAction then
--		return WindowManager.callOuterWindowFunction(window, "onCheckAction", draginfo, self.target[1]);
--	end
-- end
