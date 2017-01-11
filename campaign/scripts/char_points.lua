function onValueChanged()
  node = window.getDatabaseNode();
  
  while node.getParent().getNodeName() ~= "charsheet" and node.getParent() ~= nil do
    node = node.getParent()
  end
  
  if node ~= nil then  
    updatePointsTotalForNode(node);
  end
end

function updatePointsTotalForNode(nodePC)

  local total = 0;
  local temp = 0;
  local tempquirks = 0;

  temp = temp + DB.getValue(nodePC,"attributes.strength_points",0);
  temp = temp + DB.getValue(nodePC,"attributes.dexterity_points",0);
  temp = temp + DB.getValue(nodePC,"attributes.intelligence_points",0);
  temp = temp + DB.getValue(nodePC,"attributes.health_points",0);
  temp = temp + DB.getValue(nodePC,"attributes.hitpoints_points",0);
  temp = temp + DB.getValue(nodePC,"attributes.will_points",0);
  temp = temp + DB.getValue(nodePC,"attributes.perception_points",0);
  temp = temp + DB.getValue(nodePC,"attributes.fatiguepoints_points",0);
  temp = temp + DB.getValue(nodePC,"attributes.basicspeed_points",0);
  temp = temp + DB.getValue(nodePC,"attributes.basicmove_points",0);
  temp = temp + DB.getValue(nodePC,"traits.tl_points",0);
  
  DB.setValue(nodePC,"pointtotals.attributes","number",temp);

  total = total + temp;
  temp = 0;

  for _,node in pairs(DB.getChildren(nodePC,"traits.culturalfamiliaritylist")) do
    temp = temp + DB.getValue(node,"points",0);
  end

  for _,node in pairs(DB.getChildren(nodePC,"traits.languagelist")) do
    temp = temp + DB.getValue(node,"points",0);
  end

  for _,node in pairs(DB.getChildren(nodePC,"traits.adslist")) do
    temp = temp + DB.getValue(node,"points",0);
  end
  DB.setValue(nodePC,"pointtotals.ads","number",temp);

  total = total + temp;
  temp = 0;

  for _,node in pairs(DB.getChildren(nodePC,"traits.disadslist")) do
    if DB.getValue(node,"points",0) == -1 then
      tempquirks = tempquirks + DB.getValue(node,"points",0);
    else
      temp = temp + DB.getValue(node,"points",0);
    end
  end
  DB.setValue(nodePC,"pointtotals.disads","number",temp);
  DB.setValue(nodePC,"pointtotals.quirks","number",tempquirks);
  
  total = total + temp + tempquirks;
  temp = 0;
  
  for _,node in pairs(DB.getChildren(nodePC,"abilities.skilllist")) do
    temp = temp + DB.getValue(node,"points",0);
  end
  DB.setValue(nodePC,"pointtotals.skills","number",temp);

  total = total + temp;
  temp = 0;

  for _,node in pairs(DB.getChildren(nodePC,"abilities.spelllist")) do
    temp = temp + DB.getValue(node,"points",0);
  end
  DB.setValue(nodePC,"pointtotals.spells","number",temp);

  total = total + temp;
  temp = 0;

  for _,node in pairs(DB.getChildren(nodePC,"abilities.powerlist")) do
    temp = temp + DB.getValue(node,"points",0);
  end
  DB.setValue(nodePC,"pointtotals.powers","number",temp);

  total = total + temp;
  temp = 0;
 
 for _,node in pairs(DB.getChildren(nodePC,"abilities.otherlist")) do
    temp = temp + DB.getValue(node,"points",0);
  end
  DB.setValue(nodePC,"pointtotals.others","number",temp);

  total = total + temp;
  temp = 0;

  DB.setValue(nodePC,"pointtotals.totalpoints","number",total);
end