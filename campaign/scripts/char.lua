-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
  if User.isLocal() then
    speak.setVisible(false);
    portrait.setVisible(false);
    localportrait.setVisible(true);
  end

  local node = getDatabaseNode();
  ActorManager2.updatePointsTotal(node);
  ActorManager2.updateEncumbrance(node);
end
