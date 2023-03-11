-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	if super and super.onInit then
		super.onInit();
	end
end

function onClose()
	if super and super.onClose then
		super.onClose();
	end
end

function onDelete(node)
	if super and super.onDelete then
		super.onDelete();
	end

	local node = getDatabaseNode();
	ItemManager.onCharRemoveEvent(node);
end
