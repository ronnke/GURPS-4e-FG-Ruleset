-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	update();
end

function updateControl(sControl, bReadOnly, bForceHide)
	if not self[sControl] then
		return false;
	end
	
	return self[sControl].update(bReadOnly, bForceHide);
end

function update()
	local bReadOnly = WindowManager.getReadOnlyState(getDatabaseNode());

	strength.setReadOnly(bReadOnly);
  dexterity.setReadOnly(bReadOnly);
  intelligence.setReadOnly(bReadOnly);
  health.setReadOnly(bReadOnly);
  hitpoints.setReadOnly(bReadOnly);
  will.setReadOnly(bReadOnly);
  perception.setReadOnly(bReadOnly);
  fatiguepoints.setReadOnly(bReadOnly);
  
  basicspeed.setReadOnly(bReadOnly);
  move.setReadOnly(bReadOnly);
  sizemodifier.setReadOnly(bReadOnly);
  swing.setReadOnly(bReadOnly);
  thrust.setReadOnly(bReadOnly);
  label_traits.setVisible(not bReadOnly or traits.getValue("") ~= "");
  traits.setReadOnly(bReadOnly);
  reactionmodifiers.setReadOnly(bReadOnly);

  dodge.setReadOnly(bReadOnly);
  parry.setReadOnly(bReadOnly);
  block.setReadOnly(bReadOnly);
  dr.setReadOnly(bReadOnly);
  
	if bReadOnly then
		if meleecombat_iedit then
			meleecombat_iedit.setValue(0);
			meleecombat_iedit.setVisible(false);
		end
		
		local bShow = (meleecombat.getWindowCount() ~= 0);
		header_meleecombat.setVisible(bShow);
		meleecombat.setVisible(bShow);
	else
		if meleecombat_iedit then
			meleecombat_iedit.setVisible(true);
		end
		header_meleecombat.setVisible(true);
		meleecombat.setVisible(true);
	end
	for _,w in ipairs(meleecombat.getWindows()) do
    w.name.setReadOnly(bReadOnly);
    w.st.setReadOnly(bReadOnly);
    w.weight.setReadOnly(bReadOnly);
    w.update(bReadOnly);
	end

  updateControl("rangedcombat",bReadOnly,false);
  if bReadOnly then
    if rangedcombat_iedit then
      rangedcombat_iedit.setValue(0);
      rangedcombat_iedit.setVisible(false);
    end
    
    local bShow = (rangedcombat.getWindowCount() ~= 0);
    header_rangedcombat.setVisible(bShow);
    rangedcombat.setVisible(bShow);
  else
    if rangedcombat_iedit then
      rangedcombat_iedit.setVisible(true);
    end
    header_rangedcombat.setVisible(true);
    rangedcombat.setVisible(true);
  end
  for _,w in ipairs(rangedcombat.getWindows()) do
    w.name.setReadOnly(bReadOnly);
    w.st.setReadOnly(bReadOnly);
    w.bulk.setReadOnly(bReadOnly);
    w.update(bReadOnly);
  end
  
  updateControl("abilities",bReadOnly);
  if bReadOnly then
    if abilities_iedit then
      abilities_iedit.setValue(0);
      abilities_iedit.setVisible(false);
    end
    
    local bShow = (abilities.getWindowCount() ~= 0);
    header_abilities.setVisible(bShow);
    abilities.setVisible(bShow);
  else
    if abilities_iedit then
      abilities_iedit.setVisible(true);
    end
    header_abilities.setVisible(true);
    abilities.setVisible(true);
  end
  for _,w in ipairs(abilities.getWindows()) do
    w.name.setReadOnly(bReadOnly);
    w.level.setReadOnly(bReadOnly);
    w.update(bReadOnly);
  end
	
end

function addMeleeCombat(sName, sDesc)
	local w = meleecombat.createWindow();
	if w then
		w.name.setValue(sName);
	end
end

function addRangedCombat(sName, sDesc)
	local w = rangedcombat.createWindow();
	if w then
		w.name.setValue(sName);
	end
end

function addAbilities(sName, sDesc)
  local w = abilities.createWindow();
  if w then
    w.name.setValue(sName);
  end
end

function onDrop(x, y, draginfo)
	if draginfo.isType("shortcut") then
		local sClass = draginfo.getShortcutData();
		local nodeSource = draginfo.getDatabaseNode();
		
		if sClass == "meleeweapon" then
			addMeleeWeapon(nodeSource);
		elseif sClass == "rangedweapon" then
      addRangedWeapon(nodeSource);
		elseif sClass == "abilities" then
      addAbilities(nodeSource);
		end
		return true;
	end
end
