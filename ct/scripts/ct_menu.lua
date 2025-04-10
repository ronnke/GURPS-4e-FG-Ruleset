-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	OptionsManager.registerCallback("RNDINIT", onRNDINITOptionChanged);

	setColor(ColorManager.getButtonTextColor());
	registerCTMenu();
end

function registerCTMenu()
	if Session.IsHost then
		resetMenuItems();
		registerMenuItem(Interface.getString("ct_menu_resetmenu"), "turn", 7);

		local sOptRNDINIT = OptionsManager.getOption("RNDINIT");
	    if sOptRNDINIT ~= "" then
			registerMenuItem(Interface.getString("ct_menu_initall"), "shuffle", 7, 8);
			registerMenuItem(Interface.getString("ct_menu_initnpc"), "mask", 7, 7);
			registerMenuItem(Interface.getString("ct_menu_initpc"), "portrait", 7, 6);
		end

		registerMenuItem(Interface.getString("ct_menu_resetcombat"), "pointer_circle", 7, 4);

		registerMenuItem(Interface.getString("ct_menu_itemdelete"), "delete", 3);
		registerMenuItem(Interface.getString("ct_menu_itemdeletenonfriendly"), "delete", 3, 1);
		registerMenuItem(Interface.getString("ct_menu_itemdeletefoe"), "delete", 3, 3);
		registerMenuItem(Interface.getString("ct_menu_itemdeleteall"), "delete", 3, 5);

		registerMenuItem(Interface.getString("ct_menu_effectdelete"), "hand", 5);
		registerMenuItem(Interface.getString("ct_menu_effectdeleteall"), "pointer_circle", 5, 7);
		registerMenuItem(Interface.getString("ct_menu_effectdeleteexpiring"), "pointer_cone", 5, 5);
	end
end

function onRNDINITOptionChanged()
	registerCTMenu();

	local sOptRNDINIT = OptionsManager.getOption("RNDINIT");
	if sOptRNDINIT == "" then
		function resetSpeeds(nodeCT)
			local nSpeed = tonumber(DB.getValue(nodeCT, "attributes.basicspeed", "0"));

			local rActor = ActorManager.resolveActor(nodeCT);
			if ActorManager.isPC(rActor) then
				local nodePC = ActorManager.getCreatureNode(rActor);
				nSpeed = tonumber(DB.getValue(nodePC, "attributes.basicspeed", "0"));
			end

			DB.setValue(nodeCT, "speed", "number", nSpeed);
		end
		CombatManager.callForEachCombatant(resetSpeeds);
	end
end

function onClickDown(button, x, y)
	return true;
end

function onClickRelease(button, x, y)
	if button == 1 then
		Interface.openRadialMenu();
		return true;
	end
end

function onMenuSelection(selection, subselection)
	if Session.IsHost then
		if selection == 7 then
			if subselection == 4 then
				CombatManager.resetInit();
			elseif subselection == 8 then
				CombatManagerGURPS4e.rollInit();
			elseif subselection == 7 then
				CombatManagerGURPS4e.rollInit("npc");
			elseif subselection == 6 then
				CombatManagerGURPS4e.rollInit("pc");
			end
		end
		if selection == 5 then
			if subselection == 7 then
				CombatManager.resetCombatantEffects();
			elseif subselection == 5 then
				CombatManagerGURPS4e.clearExpiringEffects();
			end
		end
		if selection == 3 then
			if subselection == 1 then
				CombatManager.deleteNonFaction("friend");
			elseif subselection == 3 then
				CombatManager.deleteFaction("foe");
			elseif subselection == 5 then
				CombatManager.deleteNonFaction("friend");
				CombatManager.deleteFaction("friend");
			end
		end
	end
end
