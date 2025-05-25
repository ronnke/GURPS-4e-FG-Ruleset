-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	if super and super.onInit then
		super.onInit();
	end

	if Session.IsHost then
	end

	local nodeChar = getDatabaseNode();
	CharManager.updatePointsTotal(nodeChar);
	CharEncumbranceManagerGURPS4e.updateEncumbranceLevel(nodeChar);
end
