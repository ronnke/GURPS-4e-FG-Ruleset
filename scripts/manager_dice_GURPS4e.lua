-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	registerDiceRolls();
end

function registerDiceRolls()
	DiceRollManager.registerDamageKey();
	DiceRollManager.registerDamageTypeKey("cr");
	DiceRollManager.registerDamageTypeKey("cut");
	DiceRollManager.registerDamageTypeKey("imp");
	DiceRollManager.registerDamageTypeKey("pi-");
	DiceRollManager.registerDamageTypeKey("pi");
	DiceRollManager.registerDamageTypeKey("pi+");
	DiceRollManager.registerDamageTypeKey("pi++");
	DiceRollManager.registerDamageTypeKey("burn");
	DiceRollManager.registerDamageTypeKey("cor");
	DiceRollManager.registerDamageTypeKey("tox");
	DiceRollManager.registerDamageTypeKey("fat");
end
