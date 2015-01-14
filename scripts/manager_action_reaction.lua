-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	ActionsManager.registerResultHandler("reaction", onReaction);
end

function onReaction(rSource, rTarget, rRoll)
	local rMessage = ActionsManager2.createActionMessage(rSource, rRoll);
	
	local nTotal = ActionsManager2.total(rRoll);
  local aAddIcons = {};

  local sResult = "";
  if nTotal <= 0 then
      sResult = "[ Disastrous! ]";
  elseif nTotal >= 1 and nTotal <=3 then
      sResult = "[ Very Bad! ]";
  elseif nTotal >= 4 and nTotal <=6 then
      sResult = "[ Bad! ]";
  elseif nTotal >= 7 and nTotal <=9 then
      sResult = "[ Poor! ]";
  elseif nTotal >= 10 and nTotal <=12 then
      sResult = "[ Neutral! ]";
  elseif nTotal >= 13 and nTotal <=15 then
      sResult = "[ Good! ]";
  elseif nTotal >= 16 and nTotal <=18 then
      sResult = "[ Very Good! ]";
  elseif nTotal >= 19 then
      sResult = "[ Excellent! ]";
  end
  
  rMessage.text = rMessage.text .. "\n" .. sResult;
	
	if #aAddIcons > 0 then
		rMessage.icon = { rMessage.icon };
		for _,v in ipairs(aAddIcons) do
			table.insert(rMessage.icon, v);
		end
	end
	
	Comm.deliverChatMessage(rMessage);
end
