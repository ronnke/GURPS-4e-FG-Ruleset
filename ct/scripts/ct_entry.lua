-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	-- Set the displays to what should be shown
	setTargetingVisible();
    setStatsVisible();
	setCombatVisible();
	setEffectsVisible();

	-- Acquire token reference, if any
	linkToken();
	
	-- Set up the PC links
	onLinkChanged();
	
	-- Update the displays
	onFactionChanged();
	onHealthChanged();
    onSkipChanged();
	
	-- Register the deletion menu item for the host	
	registerMenuItem(Interface.getString("list_menu_deleteitem"), "delete", 6);
	registerMenuItem(Interface.getString("list_menu_deleteconfirm"), "delete", 6, 7);
end

function updateDisplay()
	local sFaction = friendfoe.getStringValue();

	if DB.getValue(getDatabaseNode(), "active", 0) == 1 then
		name.setFont("sheetlabel");
	    nonid_name.setFont("sheetlabel");
		
		active_spacer_top.setVisible(true);
		active_spacer_bottom.setVisible(true);
		
		if sFaction == "friend" then
			setFrame("ctentrybox_friend_active");
		elseif sFaction == "neutral" then
			setFrame("ctentrybox_neutral_active");
		elseif sFaction == "foe" then
			setFrame("ctentrybox_foe_active");
		else
			setFrame("ctentrybox_active");
		end
	else
		name.setFont("sheettext");
	    nonid_name.setFont("sheettext");
		
		active_spacer_top.setVisible(false);
		active_spacer_bottom.setVisible(false);
		
		if sFaction == "friend" then
			setFrame("ctentrybox_friend");
		elseif sFaction == "neutral" then
			setFrame("ctentrybox_neutral");
		elseif sFaction == "foe" then
			setFrame("ctentrybox_foe");
		else
			setFrame("ctentrybox");
		end
	end
 
	skip.setValue(DB.getValue(getDatabaseNode(), "skip", 0));
end

function linkToken()
	local imageinstance = token.populateFromImageNode(tokenrefnode.getValue(), tokenrefid.getValue());
	if imageinstance then
		TokenManager.linkToken(getDatabaseNode(), imageinstance);
	end
end

function onMenuSelection(selection, subselection)
	if selection == 6 and subselection == 7 then
		delete();
	end
end

function delete()
	local node = getDatabaseNode();
	if not node then
		close();
		return;
	end
	
	-- Remember node name
	local sNode = node.getNodeName();
	
	-- Clear any effects and wounds first, so that rolls aren't triggered when initiative advanced
	effects.reset(false);
	
	-- Move to the next actor, if this CT entry is active
	if DB.getValue(node, "active", 0) == 1 then
		CombatManager.nextActor();
	end

	-- Delete the database node and close the window
	node.delete();

	-- Update list information (global subsection toggles)
	windowlist.onVisibilityToggle();
	windowlist.onEntrySectionToggle();
end

function onLinkChanged()
	-- If a PC, then set up the links to the char sheet
	local sClass, sRecord = link.getValue();
	if sClass == "charsheet" then
		linkPCFields();
		name.setLine(false);
	end
  onIDChanged();
end

function onIDChanged()
  local nodeRecord = getDatabaseNode();
  local sClass = DB.getValue(nodeRecord, "link", "", "");
  if sClass == "npc" then
    local bID = LibraryData.getIDState("npc", nodeRecord, true);
    name.setVisible(bID);
    nonid_name.setVisible(not bID);
    isidentified.setVisible(true);
  else
    name.setVisible(true);
    nonid_name.setVisible(false);
    isidentified.setVisible(false);
  end
end

function onFactionChanged()
	-- Update the entry frame
	updateDisplay();

	-- If not a friend, then show visibility toggle
	if friendfoe.getStringValue() == "friend" then
		tokenvis.setVisible(false);
	else
		tokenvis.setVisible(true);
	end
end

function onVisibilityChanged()
	TokenManager.updateVisibility(getDatabaseNode());
	windowlist.onVisibilityToggle();
end

function onActiveChanged()
  setCombatVisible();
end

function linkPCFields()
  local nodeChar = link.getTargetDatabaseNode();
  if nodeChar then
    name.setLink(nodeChar.createChild("name", "string"), true);

    sub_stats.subwindow.strength.setLink(nodeChar.createChild("attributes.strength", "number"), true);
    sub_stats.subwindow.dexterity.setLink(nodeChar.createChild("attributes.dexterity", "number"), true);
    sub_stats.subwindow.intelligence.setLink(nodeChar.createChild("attributes.intelligence", "number"), true);
    sub_stats.subwindow.health.setLink(nodeChar.createChild("attributes.health", "number"), true);
    sub_stats.subwindow.hitpoints.setLink(nodeChar.createChild("attributes.hitpoints", "number"), true);
    sub_stats.subwindow.will.setLink(nodeChar.createChild("attributes.will", "number"), true);
    sub_stats.subwindow.perception.setLink(nodeChar.createChild("attributes.perception", "number"), true);
    sub_stats.subwindow.fatiguepoints.setLink(nodeChar.createChild("attributes.fatiguepoints", "number"), true);

    sub_combat.subwindow.sizemodifier.setLink(nodeChar.createChild("traits.sizemodifier", "string"), true);
    sub_combat.subwindow.reach.setLink(nodeChar.createChild("traits.reach", "string"), true);

    sub_combat.subwindow.dodge.setLink(nodeChar.createChild("combat.dodge", "number"), true);
    sub_combat.subwindow.parry.setLink(nodeChar.createChild("combat.parry", "number"), true);
    sub_combat.subwindow.block.setLink(nodeChar.createChild("combat.block", "number"), true);
    sub_combat.subwindow.dr.setLink(nodeChar.createChild("combat.dr", "string"), true);
    sub_combat.subwindow.move.setLink(nodeChar.createChild("attributes.move", "string"), true);

    hps.setLink(nodeChar.createChild("attributes.hps", "number"), true);
    fps.setLink(nodeChar.createChild("attributes.fps", "number"), true);
    injury.setLink(nodeChar.createChild("attributes.injury", "number"));
    fatigue.setLink(nodeChar.createChild("attributes.fatigue", "number"));
    hpstatus.setLink(nodeChar.createChild("attributes.hpstatus", "string"));
  end
end

function onHealthChanged()
  local sColor, sStatus, nStatus = ActorManager2.getInjuryStatusColor("ct", getDatabaseNode());

  hps.setColor(sColor);
  status.setValue(sStatus);
end

function onFatigueChanged()
  local sColor, sStatus, nStatus = ActorManager2.getFatigueStatusColor("ct", getDatabaseNode());

  fps.setColor(sColor);
end

function onSkipChanged()
  local nodeRecord = getDatabaseNode();
  DB.setValue(nodeRecord, "skip", "number", skip.getValue());
end

--
-- SECTION VISIBILITY FUNCTIONS
--

function setTargetingVisible()
  local v = false;
  if activatetargeting.getValue() == 1 then
    v = true;
  end

  targetingicon.setVisible(v);
  sub_targeting.setVisible(v);
  frame_targeting.setVisible(v);

  target_summary.onTargetsChanged();
end

function setStatsVisible()
  local v = false;
  if activatestats.getValue() == 1 then
    v = true;
  end

  statsicon.setVisible(v);
  sub_stats.setVisible(v);
  frame_stats.setVisible(v);
end

function setCombatVisible()
  local v = false;
  if activatecombat.getValue() == 1 then
	v = true;
  end

  local sClass, sRecord = link.getValue();
  local bNPC = (sClass ~= "charsheet");
  if bNPC and active.getValue() == 1 then
    v = true;
  end

  local nodeChar = getDatabaseNode();
  local bShowMelee = ActorManager2.hasMeleeWeapons(nodeChar)
  local bShowRanged = ActorManager2.hasRangedWeapons(nodeChar)

  combaticon.setVisible(v);
  sub_combat.setVisible(v);
  sub_meleecombat.setVisible(v and bNPC and bShowMelee);
  sub_rangedcombat.setVisible(v and bNPC and bShowRanged);
  frame_combat.setVisible(v);
end

function setEffectsVisible()
  local v = false;
  if activateeffects.getValue() == 1 then
    v = true;
  end
  
  effecticon.setVisible(v);
  
  effects.setVisible(v);
  effects_iadd.setVisible(v);
  for _,w in pairs(effects.getWindows()) do
    w.idelete.setValue(0);
  end

  frame_effects.setVisible(v);
  effect_summary.onEffectsChanged();
end
