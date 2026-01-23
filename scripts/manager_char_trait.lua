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
--		DB.addHandler(DB.getPath("charsheet.*.traits.perkslist.*.*"), "onUpdate", self.onPerkUpdated);
--		DB.addHandler(DB.getPath("charsheet.*.traits.disadslist.*.*"), "onUpdate", self.onDisadvantageUpdated);
--		DB.addHandler(DB.getPath("charsheet.*.traits.quirkslist.*.*"), "onUpdate", self.onQuirkUpdated);
	end
end

function onAdvantageUpdated(nodeField)
end

function onPerkUpdated(nodeField)
end

function onDisadvantageUpdated(nodeField)
end

function onQuirkUpdated(nodeField)
end

function addTrait(nodeChar, nodeTrait)
	if not nodeChar or not nodeTrait then  
		return false;
	end
 
	local bAdvantage = LibraryDataGURPS4e.isAdvantage(nodeTrait);
	local bDisadvantage = LibraryDataGURPS4e.isDisadvantage(nodeTrait);
	local bPerk = LibraryDataGURPS4e.isPerk(nodeTrait);
	local bQuirk = LibraryDataGURPS4e.isQuirk(nodeTrait);
	local bFeature = LibraryDataGURPS4e.isFeature(nodeTrait);

	if not (bAdvantage or bDisadvantage or bPerk or bQuirk or bFeature) then
		return false;
	end

	local nodeActor = ActorManager.getCreatureNode(nodeChar);
	if not nodeActor then
		return false;
	end

	if ActorManager.isRecordType(nodeChar, "npc") then
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

	if ActorManager.isPC(nodeChar) then
		local traitList = "";
		if bAdvantage then
			traitList = "traits.adslist";
		elseif bPerk then
			traitList = "traits.perkslist";
		elseif bDisadvantage then
			traitList = "traits.disadslist";
		elseif bQuirk then
			traitList = "traits.quirkslist";
		elseif bFeature then
			traitList = "traits.featureslist";
		else
			return false;
		end

		local nodeTraitList = DB.getChild(nodeChar, traitList);
		if not nodeTraitList then
			nodeTraitList = DB.createChild(nodeChar, traitList);
		end

		local nodeNewTrait = DB.createChild(nodeTraitList);
		DB.setValue(nodeNewTrait, "type", "string", DB.getValue(nodeTrait,"type",""));  
		DB.setValue(nodeNewTrait, "subtype", "string", DB.getValue(nodeTrait,"subtype",""));  
		DB.setValue(nodeNewTrait, "name", "string", DB.getValue(nodeTrait,"name",""));  
		DB.setValue(nodeNewTrait, "points", "number", DB.getValue(nodeTrait,"points",0));
		DB.setValue(nodeNewTrait, "page", "string", DB.getValue(nodeTrait, "page", ""));
		DB.setValue(nodeNewTrait, "text", "formattedtext", DB.getValue(nodeTrait,"text",""));

		return true;
	end

	return false;
end
