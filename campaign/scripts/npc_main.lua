-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	update();
end

function VisDataCleared()
	update();
end

function InvisDataAdded()
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
	local nodeRecord = getDatabaseNode();
	local bReadOnly = WindowManager.getReadOnlyState(nodeRecord);
	local bID = LibraryData.getIDState("npc", nodeRecord);

	local bSection1 = false;
	if User.isHost() then
		if updateControl("nonid_name", bReadOnly) then bSection1 = true; end;
	else
		updateControl("nonid_name", bReadOnly, true);
	end
	if updateControl("type", bReadOnly, bReadOnly and type.isEmpty()) then bSection1 = true; end;
	if updateControl("pts", bReadOnly, bReadOnly and pts.getValue() == 0) then bSection1 = true; end;
	divider.setVisible(bSection1);
	
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
