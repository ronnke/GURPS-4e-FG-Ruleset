-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--
function onInit()	
	DB.addHandler(DB.getPath("charsheet.*.inventorylist.*.carried"), "onUpdate", onCarriedChanged);
end

function onClose()
	
end

function onCarriedChanged(nodeCarried)		
	local nodeChar = DB.getChild(nodeCarried, "....");	
	if nodeChar ~= "" then		
		local nodeCarriedItem = DB.getChild(nodeCarried, "..");	
		if DB.getValue(nodeCarriedItem, "carried") == 2 then								
			if DB.getValue(nodeCarriedItem, "combatmeleelink", "") ~= "" or DB.getValue(nodeCarriedItem, "combatrangedlink", "") ~= "" or DB.getValue(nodeCarriedItem, "defenselink", "") ~= "" then				
				toggleEquipped(nodeCarriedItem, "add")						
			end
		else
			toggleEquipped(nodeCarriedItem, "del");
		end
	end	
end

function toggleEquipped(nodeItem, view)
	if view == "add" then			
		local nodeChar = nodeItem.getParent().getParent();				
		ItemManager2.AddItemToCombat(nodeChar, nodeItem, true);									
	else		
		setHidden(nodeItem, 1);		
	end	
end

function setHidden(nodeItem, value)		
	if LibraryDataGURPS4e.isMeleeWeapon(nodeItem) and DB.getValue(nodeItem, "combatmeleelink", "") ~= "" then			
		DB.setValue(DB.findNode(DB.getValue(nodeItem, "combatmeleelink")), "isHidden", "number", value);		
	end	
	if LibraryDataGURPS4e.isRangedWeapon(nodeItem) and DB.getValue(nodeItem, "combatrangedlink", "") ~= "" then			
		DB.setValue(DB.findNode(DB.getValue(nodeItem, "combatrangedlink")), "isHidden", "number", value);
	end	
	if LibraryDataGURPS4e.isDefense(nodeItem) and DB.getValue(nodeItem, "defenselink", "") ~= "" then		
		DB.setValue(DB.findNode(DB.getValue(nodeItem, "defenselink")), "isHidden", "number", value);		   		
	end
end