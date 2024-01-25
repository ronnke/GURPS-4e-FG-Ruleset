-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

--
-- Actions
--

function applyDamage()
--		ActionDamage.applyWounds("ct", getCombatantNode(), nResultWounds, isNonLethal(), bResultGrittyDamage)
	removeEntry()
end

function removeEntry()
	DB.deleteNode(getDatabaseNode())
end
