-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	ItemManager.setCustomCharAdd(onCharItemAdd);
	ItemManager.setCustomCharRemove(onCharItemDelete);
end

function onCharItemAdd(nodeItem)
	CharCombatManager.addItem(nodeItem);
end

function onCharItemDelete(nodeItem)
	CharCombatManager.removeItem(nodeItem);
end
