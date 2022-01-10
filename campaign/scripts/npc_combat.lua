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
	
  self[sControl].setReadOnly(bReadOnly);
  self[sControl].setVisible(not bForceHide);
  return true;
end

function update()
  local bReadOnly = WindowManager.getReadOnlyState(getDatabaseNode());

  updateControl("dodge", bReadOnly, false);
  updateControl("parry", bReadOnly, false);
  updateControl("block", bReadOnly, false);
  updateControl("dr", bReadOnly, false);
  
  updateControl("meleecombat", bReadOnly, false);
	if bReadOnly then
		if meleecombat_iadd then
		  meleecombat_iadd.setVisible(false);
		end
		if meleecombat_iedit then
			meleecombat_iedit.setValue(0);
			meleecombat_iedit.setVisible(false);
		end
		
		local bShow = (meleecombat.getWindowCount() ~= 0);
		header_meleecombat.setVisible(bShow);
		meleecombat.setVisible(bShow);
	else
		if meleecombat_iadd then
		  meleecombat_iadd.setVisible(true);
		end
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

  updateControl("rangedcombat", bReadOnly, false);
  if bReadOnly then
	if rangedcombat_iadd then
	  rangedcombat_iadd.setVisible(false);
	end
    if rangedcombat_iedit then
      rangedcombat_iedit.setValue(0);
      rangedcombat_iedit.setVisible(false);
    end
    
    local bShow = (rangedcombat.getWindowCount() ~= 0);
    header_rangedcombat.setVisible(bShow);
    rangedcombat.setVisible(bShow);
  else
	if rangedcombat_iadd then
	  rangedcombat_iadd.setVisible(true);
	end
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
    w.ammo.setReadOnly(bReadOnly);
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

function onDrop(x, y, draginfo)
	if draginfo.isType("shortcut") then
		local nodeItem = draginfo.getDatabaseNode();
        local nodeNPC = getDatabaseNode();

        local bMeleeWeapon = LibraryDataGURPS4e.isMeleeWeapon(nodeItem);
        local bRangedWeapon = LibraryDataGURPS4e.isRangedWeapon(nodeItem);

	    if bMeleeWeapon or bRangedWeapon then
            ItemManager2.AddItemToCombat(nodeNPC, nodeItem, false)
	    end
	    return true;
	end
end
