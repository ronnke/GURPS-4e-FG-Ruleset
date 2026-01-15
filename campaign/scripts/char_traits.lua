-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onDrop(x, y, draginfo)
	if draginfo.isType("shortcut") then
		return CharManager.addTrait(getDatabaseNode(), draginfo.getDatabaseNode());
	end
end


-- function onDrop(x, y, draginfo)
--	if draginfo.isType("shortcut") then
--		local sClass, sRecord = draginfo.getShortcutData();
--		if StringManager.contains({
--			"reference_racialtrait", "reference_subracialtrait",
--			"reference_classproficiency", "reference_classfeature",
--			"reference_classfeaturechoice", "reference_backgroundfeature",
--			"reference_feat", }, sClass) then
--			return CharBuildDropManager.addInfoDB(getDatabaseNode(), sClass, sRecord);
--		end
--	end
-- end
