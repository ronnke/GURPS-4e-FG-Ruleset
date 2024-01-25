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

  updateControl("abilities", bReadOnly, false);
  if bReadOnly then
	if abilities_iadd then
	  abilities_iadd.setVisible(false);
	end
    if abilities_iedit then
      abilities_iedit.setValue(0);
      abilities_iedit.setVisible(false);
    end
    
    local bShow = (abilities.getWindowCount() ~= 0);
    header_abilities.setVisible(bShow);
    abilities.setVisible(bShow);
  else
	if abilities_iadd then
      abilities_iadd.setVisible(true);
	end
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

function addAbilities(sName, sDesc)
  local w = abilities.createWindow();
  if w then
    w.name.setValue(sName);
  end
end

function onDrop(x, y, draginfo)
	if WindowManager.getReadOnlyState(getDatabaseNode()) then
    	return true;
	end

	if draginfo.isType("shortcut") and not bReadOnly then
		return CharManager.addAbility(getDatabaseNode(), draginfo.getDatabaseNode());
	end
end

