-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
-- TODO: Implement Trait Management
end

function onTabletopInit()
	if Session.IsHost then
--		DB.addHandler(DB.getPath("charsheet.*.traits.adslist.*.*"), "onUpdate", self.onAdvantageUpdated);
--		DB.addHandler(DB.getPath("charsheet.*.traits.disadslist.*.*"), "onUpdate", self.onDisadvantageUpdated);
	end
end

function onAdvantageUpdated(nodeField)
end

function onDisadvantageUpdated(nodeField)
end

function addTrait(nodeChar, nodeTrait)
	if not nodeChar or not nodeTrait then  
		return false;
	end
 
	local bAdvantage = LibraryDataGURPS4e.isAdvantage(nodeTrait);
	local bDisadvantage = LibraryDataGURPS4e.isDisadvantage(nodeTrait);
	local bPerk = LibraryDataGURPS4e.isPerk(nodeTrait);
	local bQuirk = LibraryDataGURPS4e.isQuirk(nodeTrait);

	if not (bAdvantage or bDisadvantage or bPerk or bQuirk) then
		return false;
	end

	local sActorType, nodeActor = ActorManager.getTypeAndNode(nodeChar);
	if sActorType ~= "pc" then
		local nodeNPCTraits = DB.getChild(nodeChar, "traits");
		if not nodeNPCTraits then
			nodeNPCTraits = DB.createChild(nodeChar, "traits");
		end
		
		local traits = DB.getValue(nodeNPCTraits,"description","");  
		if not (traits == nil or traits == "") then
			traits = traits .. ", ";
		end
		traits = traits .. DB.getValue(nodeTrait,"name","");

		DB.setValue(nodeNPCTraits, "description", "string", traits);  

		return true;
	end

	if bAdvantage or bPerk then
		local nodeAdvantageList = DB.getChild(nodeChar, "traits.adslist");
		if not nodeAdvantageList then
			nodeAdvantageList = DB.createChild(nodeChar, "traits.adslist");
		end

		local nodeAdvantage = DB.createChild(nodeAdvantageList);
		DB.setValue(nodeAdvantage, "type", "string", DB.getValue(nodeTrait,"type",""));  
		DB.setValue(nodeAdvantage, "subtype", "string", DB.getValue(nodeTrait,"subtype",""));  
		DB.setValue(nodeAdvantage, "name", "string", DB.getValue(nodeTrait,"name",""));  
		DB.setValue(nodeAdvantage, "points", "number", DB.getValue(nodeTrait,"points",0));
		DB.setValue(nodeAdvantage, "page", "string", DB.getValue(nodeTrait, "page", ""));
		DB.setValue(nodeAdvantage, "text", "formattedtext", DB.getValue(nodeTrait,"text",""));

		return true;
	end

	if bDisadvantage or bQuirk then
		local nodeDisadvantageList = DB.getChild(nodeChar, "traits.disadslist")
		if not nodeDisadvantageList then
			nodeDisadvantageList = DB.createChild(nodeChar, "traits.disadslist");
		end

		local nodeDisadvantage = DB.createChild(nodeDisadvantageList);
		DB.setValue(nodeDisadvantage, "type", "string", DB.getValue(nodeTrait,"type",""));  
		DB.setValue(nodeDisadvantage, "subtype", "string", DB.getValue(nodeTrait,"subtype",""));  
		DB.setValue(nodeDisadvantage, "name", "string", DB.getValue(nodeTrait,"name",""));  
		DB.setValue(nodeDisadvantage, "points", "number", DB.getValue(nodeTrait,"points",0));
		DB.setValue(nodeDisadvantage, "page", "string", DB.getValue(nodeTrait, "page", ""));
		DB.setValue(nodeDisadvantage, "text", "formattedtext", DB.getValue(nodeTrait,"text",""));
		
		return true;
	end

	return false;
end
