-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	local nodeChar = getDatabaseNode();
--	DB.addHandler(DB.getPath("charsheet.*.traits.adslist.*.*"), "onUpdate", onAdvantageUpdated);
--	DB.addHandler(DB.getPath("charsheet.*.traits.disadslist.*.*"), "onUpdate", onDisadvantageUpdated);
end

function onClose()
	local nodeChar = getDatabaseNode();
--	DB.removeHandler(DB.getPath("charsheet.*.traits.adslist.*.*"), "onUpdate", onAdvantageUpdated);
--	DB.removeHandler(DB.getPath("charsheet.*.traits.disadslist.*.*"), "onUpdate", onDisadvantageUpdated);
end

function onAdvantageUpdated(node)
	ActorManager2.onAdvantageUpdated(node);
end

function onDisadvantageUpdated(node)
	ActorManager2.onDisadvantageUpdated(node);
end

function onDrop(x, y, draginfo)
	if draginfo.isType("shortcut") then
		return ActorManager2.addTrait(getDatabaseNode(), draginfo.getDatabaseNode());
	end
end
