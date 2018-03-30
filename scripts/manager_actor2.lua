-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

COLOR_HEALTH_UNWOUNDED = "008000";
COLOR_HEALTH_LT_WOUNDS = "408000";
COLOR_HEALTH_MOD_WOUNDS = "AF7817";
COLOR_HEALTH_HVY_WOUNDS = "E56717";
COLOR_HEALTH_CRIT_WOUNDS = "C11B17";

function getStatus(sNodeType, node)
	local rActor = ActorManager.getActor(sNodeType, node);
	
	local nHP = DB.getValue(node, "attributes.hitpoints", 0);
  local nCHP = DB.getValue(node, "hps", 0);

	local sStatus, nStatus;
	if nCHP >= nHP then
		sStatus = "Healthy";
		nStatus = 0;
  elseif nCHP > 0 and nCHP > nHP/2 then
    sStatus = "Good";
    nStatus = 1;
	elseif nCHP > 0 then
		sStatus = "Fair";
    nStatus = 2;
	elseif nCHP < 1 and nCHP > -nHP then
		sStatus = "Serious";
    nStatus = 3;
	else
		sStatus = "Critical";
    nStatus = 4;
	end

	return sStatus, nStatus, rActor;
end

function getStatusColor(sNodeType, node)
	local sStatus, nStatus, rActor = getStatus(sNodeType, node);
	if not rActor then
		return COLOR_HEALTH_UNWOUNDED, nStatus, sStatus;
	end

	local sColor;
	if nStatus == 0 then
		sColor = COLOR_HEALTH_UNWOUNDED;
	elseif nStatus == 1 then
    sColor = COLOR_HEALTH_LT_WOUNDS;
  elseif nStatus == 2 then
    sColor = COLOR_HEALTH_MOD_WOUNDS;
	elseif nStatus == 3 then
    sColor = COLOR_HEALTH_HVY_WOUNDS;
	else
    sColor = COLOR_HEALTH_CRIT_WOUNDS;
	end

	return sColor, sStatus, nStatus;
end

function hasMeleeWeapons(node)
  local nCount = DB.getChildCount(node, "combat.meleecombatlist")
  if nCount > 0 then
    return true;
  end
  
  return false
end

function hasRangedWeapons(node)
  local nCount = DB.getChildCount(node, "combat.rangedcombatlist")
  if nCount > 0 then
    return true;
  end
  
  return false
end
