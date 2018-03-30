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

function updateReadOnly(sControl, bReadOnly, bHide)
  if not self[sControl] then
    return;
  end
  
  self[sControl].setReadOnly(bReadOnly);
  self[sControl].setVisible(not bHide);
end

function update()
	local bReadOnly = WindowManager.getReadOnlyState(getDatabaseNode());

  local bSection1 = false;
  if updateControl("type", bReadOnly, bReadOnly and type.isEmpty()) then bSection1 = true; end;
  if updateControl("pts", bReadOnly, bReadOnly and pts.getValue() == 0) then bSection1 = true; end;
  divider1.setVisible(bSection1);

	updateReadOnly("strength", bReadOnly, false);
  updateReadOnly("dexterity", bReadOnly, false);
  updateReadOnly("intelligence", bReadOnly, false);
  updateReadOnly("health", bReadOnly, false);
  updateReadOnly("hitpoints", bReadOnly, false);
  updateReadOnly("will", bReadOnly, false);
  updateReadOnly("perception", bReadOnly, false);
  updateReadOnly("fatiguepoints", bReadOnly, false);
  
  updateReadOnly("basicspeed", bReadOnly, false);
  updateReadOnly("move", bReadOnly, false);
  updateReadOnly("sizemodifier", bReadOnly, false);
  updateReadOnly("swing", bReadOnly, false);
  updateReadOnly("thrust", bReadOnly, false);

  updateReadOnly("reactionmodifiers", bReadOnly, false);
  
  updateReadOnly("label_traits", bReadOnly, bReadOnly and traits.isEmpty());
  updateReadOnly("traits", bReadOnly, bReadOnly and traits.isEmpty());

end

function onDrop(x, y, draginfo)
	if draginfo.isType("shortcut") then
		local sClass = draginfo.getShortcutData();
		local nodeSource = draginfo.getDatabaseNode();
		
		return true;
	end
end
