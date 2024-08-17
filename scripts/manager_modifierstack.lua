-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

local control = nil;
local freeadjustment = 0;
slots = {};

function onTabletopInit()
	Interface.addKeyedEventHandler("onHotkeyActivated", "number", ModifierStack.onHotkeyModifier);
end
function onHotkeyModifier(draginfo)
	ModifierStack.addSlot(draginfo.getDescription(), draginfo.getNumberData());
	return true;
end

function registerControl(c)
	control = c;
end
function updateControl()
	if control then
		if adjustmentedit then
			if control.label then
				control.label.setValue(Interface.getString("modstack_label_adjusting"));
			end
		else
			if control.label then
				control.label.setValue(Interface.getString("modstack_label_modifier"));

				if freeadjustment > 0 then
					control.label.setValue("(+" .. freeadjustment .. ")");
				elseif freeadjustment < 0 then
					control.label.setValue("(" .. freeadjustment .. ")");
				end
			end
			
			if control.modifier then
				control.modifier.setValue(ModifierStack.getSum());
			end
			
			if control.base then
				if control.base.resetCounters and control.base.addCounter then
					control.base.resetCounters();
					for i = 1, #ModifierStack.slots do
						control.base.addCounter();
					end
				end
			end
			
			if control.label then
				if hoverslot and hoverslot ~= 0 and ModifierStack.slots[hoverslot] then
					control.label.setValue(ModifierStack.slots[hoverslot].description);
				end
			end
		end
		
		if control.modifier then
			if math.abs(control.modifier.getValue()) > 999 then
				control.modifier.setFont("modcollectorlabel");
			else
				control.modifier.setFont("modcollector");
			end
		end
	end
end

function isEmpty()
	if freeadjustment == 0 and #ModifierStack.slots == 0 then
		return true;
	end

	return false;
end

function getSum()
	local total = freeadjustment;
	
	for i = 1, #ModifierStack.slots do
		total = total + ModifierStack.slots[i].number;
	end
	
	return total;
end

function getDescription(forcebonus)
	local s = "";
	
	if not forcebonus and #ModifierStack.slots == 1 and freeadjustment == 0 then
		s = ModifierStack.slots[1].description;
	else
		local aMods = {};
		
		for i = 1, #ModifierStack.slots do
			table.insert(aMods, string.format("%s %+d", ModifierStack.slots[i].description, ModifierStack.slots[i].number));
		end
		
		if freeadjustment ~= 0 then
			table.insert(aMods, string.format("%+d", freeadjustment));
		end
		
		s = table.concat(aMods, ", ");
	end
	
	return s;
end

function addSlot(description, number)
	if #ModifierStack.slots < 10 then
		table.insert(ModifierStack.slots, { ['description'] = description, ['number'] = number });
	end
	
	ModifierStack.updateControl();
end
function removeSlot(number)
	table.remove(ModifierStack.slots, number);
	ModifierStack.updateControl();
end
function adjustFreeAdjustment(amount)
	freeadjustment = freeadjustment + amount;
	ModifierStack.updateControl();
end
function setFreeAdjustment(amount)
	freeadjustment = amount;
	ModifierStack.updateControl();
end
function setAdjustmentEdit(state)
	if control and control.modifier then
		if state then
			control.modifier.setValue(freeadjustment);
		else
			ModifierStack.setFreeAdjustment(control.modifier.getValue());
		end
	end

	adjustmentedit = state;
	ModifierStack.updateControl();
end

function reset()
	if control and control.modifier and control.modifier.hasFocus() then
		control.modifier.setFocus(false);
	end

	freeadjustment = 0;
	ModifierStack.slots = {};
	ModifierStack.updateControl();
end

function hoverDisplay(n)
	hoverslot = n;
	ModifierStack.updateControl();
end

function getStack(forcebonus)
	local sDesc = "";
	local nMod = 0;
	
	if not ModifierStack.isEmpty() then
		sDesc = ModifierStack.getDescription(forcebonus);
		nMod = ModifierStack.getSum();
	end

	if not ModifierManager.isLocked() then
		ModifierStack.reset();
	end
	
	return sDesc, nMod;
end

function getTargeting()
	if control and control.targeting then
		return (control.targeting.getValue() == 1);
	end
	return true;
end

--
--  Preset handling
--
function lock()
	ModifierManager.lock();
end
function unlock(bReset)
	ModifierManager.unlock(bReset);
end
function getModifierKey(sButton)
	return ModifierManager.getKey(sButton);
end
function setModifierKey(sButton, bState, bUpdateWnd)
	ModifierManager.setKey(sButton, bState, bUpdateWnd);
end
