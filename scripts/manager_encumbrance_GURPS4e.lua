-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	Interface.onDesktopInit = onDesktopInit;
end

function onDesktopInit()
	CharEncumbranceManager.addCustomCalc(CharEncumbranceManagerGURPS.calcEncumbrance);
end

function calcEncumbrance(nodeChar)
	local nEncumbrance = CharEncumbranceManager.calcDefaultInventoryEncumbrance(nodeChar);
	nEncumbrance = nEncumbrance + CharEncumbranceManager.calcDefaultCurrencyEncumbrance(nodeChar);
	CharEncumbranceManager.setDefaultEncumbranceValue(nodeChar, nEncumbrance);

	ActorManager2.updateEncumbrance(nodeChar);
end
