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

function getBestDefaultLevel(nodeChar, defaults)
	local result = 0;
	if not nodeChar or not defaults then
		return 0;
	end

	local defaultsInfo = ActorAbilityManager.parseAbilityDefaults(nodeChar, defaults)
	for expr, statInfo in pairs(defaultsInfo) do
		if statInfo.defaultInfo.level > result then
			result = statInfo.defaultInfo.level;
		end
	end

	return result;
end
