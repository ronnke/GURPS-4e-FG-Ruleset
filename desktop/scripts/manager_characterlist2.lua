-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	if User.isHost() then
		CharacterListManager.registerDropHandler("number", onNumberDrop)
	end
end

function onNumberDrop(sIdentity, draginfo)
	CharacterListManager.onNumberDrop(sIdentity, draginfo);

	return true
end
