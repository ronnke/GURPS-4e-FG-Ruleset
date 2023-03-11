-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	local nodeChar = getDatabaseNode();
	DB.addHandler(DB.getPath("charsheet.*.attributes.*"), "onUpdate", onAttributeUpdated);
end

function onClose()
	local nodeChar = getDatabaseNode();
	DB.removeHandler(DB.getPath("charsheet.*.attributes.*"), "onUpdate", onAttributeUpdated);
end

function onAttributeUpdated(node)
	ActorManager2.onAttributeUpdated(node);
end

function onHealthChanged()
	local rActor = ActorManager.resolveActor(getDatabaseNode());
	ActionDamage.updateDamage(rActor);
end

function onFatigueChanged()
	local rActor = ActorManager.resolveActor(getDatabaseNode());
	ActionFatigue.updateFatigue(rActor);
end

function onEncumbranceChanged()
	local rActor = ActorManager.resolveActor(getDatabaseNode());
	ActorManager2.updateEncumbrance(rActor);
end
