-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onDrop(x, y, draginfo)
	if draginfo.isType("shortcut") then
		return CharManager.addTrait(getDatabaseNode(), draginfo.getDatabaseNode());
	end
end
