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
end
