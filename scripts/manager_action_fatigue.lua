-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
end

function applyFatigue(rSource, rTarget, bSecret, sDamage, nTotal)
  -- Get fatigue fields
  local sTargetType, nodeTarget = ActorManager.getTypeAndNode(rTarget);
  if sTargetType ~= "pc" and sTargetType ~= "ct" then
    return;
  end

  local nFP, nFatigue;
  if sTargetType == "pc" then
    nFP = DB.getValue(nodeTarget, "attributes.fatiguepoints", 0);
    nFatigue = DB.getValue(nodeTarget, "attributes.fatigue", 0) + nTotal;
    DB.setValue(nodeTarget, "attributes.fps", "number", nFP - (nFatigue < 0 and 0 or nFatigue));
    DB.setValue(nodeTarget, "attributes.fatigue", "number", (nFatigue < 0 and 0 or nFatigue));
    DB.setValue(nodeTarget, "attributes.fpstatus", "string", ActorManager2.getFPStatus(sTargetType, nodeTarget));
  else
    nFP = DB.getValue(nodeTarget, "attributes.fatiguepoints", 0);
    nFatigue = DB.getValue(nodeTarget, "fatigue", 0) + nTotal;
    DB.setValue(nodeTarget, "fps", "number", nFP - (nFatigue < 0 and 0 or nFatigue));
    DB.setValue(nodeTarget, "fatigue", "number", (nFatigue < 0 and 0 or nFatigue));
    DB.setValue(nodeTarget, "fpstatus", "string", ActorManager2.getFPStatus(sTargetType, nodeTarget));
  end
end

function updateFatigue(rActor)
  -- Get fatigue fields
  local sActorType, nodeActor = ActorManager.getTypeAndNode(rActor);
  if sActorType ~= "pc" and sActorType ~= "ct" then
    return;
  end

  local nFP, nFatigue;
  if sActorType == "pc" then
    nFP = DB.getValue(nodeActor, "attributes.fatiguepoints", 0);
    nFatigue = DB.getValue(nodeActor, "attributes.fatigue", 0);
    DB.setValue(nodeActor, "attributes.fps", "number", nFP - (nFatigue < 0 and 0 or nFatigue));
    DB.setValue(nodeActor, "attributes.fpstatus", "string", ActorManager2.getFPStatus(sActorType, nodeActor));
  else
    nFP = DB.getValue(nodeActor, "attributes.fatiguepoints", 0);
    nFatigue = DB.getValue(nodeActor, "fatigue", 0);
    DB.setValue(nodeActor, "fps", "number", nFP - (nFatigue < 0 and 0 or nFatigue));
    DB.setValue(nodeActor, "fpstatus", "string", ActorManager2.getFPStatus(sActorType, nodeActor));
  end
end
