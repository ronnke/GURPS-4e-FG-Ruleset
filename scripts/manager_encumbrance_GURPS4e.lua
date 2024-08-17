-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	CharEncumbranceManager.addCustomCalc(CharEncumbranceManagerGURPS4e.calcEncumbrance);
end

function onTabletopInit()
	if Session.IsHost then
		DB.addHandler("charsheet.*.attributes.basiclift", "onUpdate", CharEncumbranceManagerGURPS4e.onBasicLiftChange);
		DB.addHandler("charsheet.*.attributes.halfmovedodge", "onUpdate", CharEncumbranceManagerGURPS4e.onHalfMoveDodgeChange);

		DB.addHandler("charsheet.*.encumbrance.enc0_weight", "onUpdate", CharEncumbranceManagerGURPS4e.onEncumbranceFieldChange);
		DB.addHandler("charsheet.*.encumbrance.enc1_weight", "onUpdate", CharEncumbranceManagerGURPS4e.onEncumbranceFieldChange);
		DB.addHandler("charsheet.*.encumbrance.enc2_weight", "onUpdate", CharEncumbranceManagerGURPS4e.onEncumbranceFieldChange);
		DB.addHandler("charsheet.*.encumbrance.enc3_weight", "onUpdate", CharEncumbranceManagerGURPS4e.onEncumbranceFieldChange);
		DB.addHandler("charsheet.*.encumbrance.enc4_weight", "onUpdate", CharEncumbranceManagerGURPS4e.onEncumbranceFieldChange);
	end
end

function onHalfMoveDodgeChange(nodeField)
	local nodeChar = DB.getChild(nodeField, "...");
	CharEncumbranceManagerGURPS4e.updateEncumbranceLevel(nodeChar);
end

function onBasicLiftChange(nodeField)
	local nodeChar = DB.getChild(nodeField, "...");
	CharEncumbranceManagerGURPS4e.updateEncumbranceLevel(nodeChar);
end

function onEncumbranceFieldChange(nodeField)
	local nodeChar = DB.getChild(nodeField, "...");
	CharEncumbranceManagerGURPS4e.updateEncumbranceLevel(nodeChar);
end

function calcEncumbrance(nodeChar)
	local nEncumbrance = CharEncumbranceManager.calcDefaultInventoryEncumbrance(nodeChar);
	nEncumbrance = nEncumbrance + CharEncumbranceManager.calcDefaultCurrencyEncumbrance(nodeChar);
	CharEncumbranceManager.setDefaultEncumbranceValue(nodeChar, nEncumbrance);

	CharEncumbranceManagerGURPS4e.updateEncumbranceLevel(nodeChar);
end

function updateEncumbranceLevel(nodeChar)
	if not DB.isOwner(nodeChar) then
		return;
	end

	local nodeEnc = DB.getChild(nodeChar, "encumbrance");
	local nEncNone = tonumber(string.match(DB.getValue(nodeEnc,"enc0_weight","0"), "%d+")) or 0;
	local nEncLight = tonumber(string.match(DB.getValue(nodeEnc,"enc1_weight","0"), "%d+")) or 0;
	local nEncMedium = tonumber(string.match(DB.getValue(nodeEnc,"enc2_weight","0"), "%d+")) or 0;
	local nEncHeavy = tonumber(string.match(DB.getValue(nodeEnc,"enc3_weight","0"), "%d+")) or 0;
	local nEncXHeavy = tonumber(string.match(DB.getValue(nodeEnc,"enc4_weight","0"), "%d+")) or 0;

	DB.setValue(nodeEnc, "enc_0", "number", 0);  
	DB.setValue(nodeEnc, "enc_1", "number", 0);  
	DB.setValue(nodeEnc, "enc_2", "number", 0);  
	DB.setValue(nodeEnc, "enc_3", "number", 0);  
	DB.setValue(nodeEnc, "enc_4", "number", 0);  
	
	local nTotal = DB.getValue(nodeEnc, "load", 0);
	if nTotal <= nEncNone then 
		DB.setValue(nodeEnc, "level", "string", "None");  
		DB.setValue(nodeEnc, "enc_0", "number", 1);  
		DB.setValue(nodeChar, "attributes.move", "string", DB.getValue(nodeEnc,"enc0_move","0"));  
		DB.setValue(nodeChar, "combat.dodge", "number", DB.getValue(nodeEnc,"enc0_dodge",0));  
	elseif nTotal <= nEncLight then 
		DB.setValue(nodeEnc, "level", "string", "Light");  
		DB.setValue(nodeEnc, "enc_1", "number", 1);  
		DB.setValue(nodeChar, "attributes.move", "string", DB.getValue(nodeEnc,"enc1_move","0"));  
		DB.setValue(nodeChar, "combat.dodge", "number", DB.getValue(nodeEnc,"enc1_dodge",0));  
	elseif nTotal <= nEncMedium then 
		DB.setValue(nodeEnc, "level", "string", "Medium");  
		DB.setValue(nodeEnc, "enc_2", "number", 1);  
		DB.setValue(nodeChar, "attributes.move", "string", DB.getValue(nodeEnc,"enc2_move","0"));  
		DB.setValue(nodeChar, "combat.dodge", "number", DB.getValue(nodeEnc,"enc2_dodge",0));  
	elseif nTotal <= nEncHeavy then 
		DB.setValue(nodeEnc, "level", "string", "Heavy");  
		DB.setValue(nodeEnc, "enc_3", "number", 1);  
		DB.setValue(nodeChar, "attributes.move", "string", DB.getValue(nodeEnc,"enc3_move","0"));  
		DB.setValue(nodeChar, "combat.dodge", "number", DB.getValue(nodeEnc,"enc3_dodge",0));  
	elseif nTotal <= nEncXHeavy then 
		DB.setValue(nodeEnc, "level", "string", "X-Heavy");  
		DB.setValue(nodeEnc, "enc_4", "number", 1);  
		DB.setValue(nodeChar, "attributes.move", "string", DB.getValue(nodeEnc,"enc4_move","0"));  
		DB.setValue(nodeChar, "combat.dodge", "number", DB.getValue(nodeEnc,"enc4_dodge",0));  
	else
		DB.setValue(nodeEnc, "level", "string", "Overloaded");  
		DB.setValue(nodeEnc, "enc_0", "number", 1);  
		DB.setValue(nodeEnc, "enc_1", "number", 1);  
		DB.setValue(nodeEnc, "enc_2", "number", 1);  
		DB.setValue(nodeEnc, "enc_3", "number", 1);  
		DB.setValue(nodeEnc, "enc_4", "number", 1);  
		DB.setValue(nodeChar, "attributes.move", "string", "0");  
		DB.setValue(nodeChar, "combat.dodge", "number", 3);  
	end

	if DB.getValue(nodeChar, "attributes.halfmovedodge", 0) == 1 then 
		local halfMove = math.ceil(tonumber(string.match(DB.getValue(nodeChar, "attributes.move", "0"), "%d+") or 0) / 2);
		local halfDodge = math.ceil(DB.getValue(nodeChar, "combat.dodge", 0) / 2);
		DB.setValue(nodeChar, "attributes.move", "string", halfMove);  
		DB.setValue(nodeChar, "combat.dodge", "number", halfDodge);  
	end
end
