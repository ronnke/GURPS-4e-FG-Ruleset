function onInit()
	TokenManager.addDefaultHealthFeatures(TokenManagerGURPS4e.getTokenHealthInfo, {"injury", "fatigue"});

	TokenManager.addEffectTagIconConditional("IF", TokenManagerGURPS4e.handleIFEffectTag);
	TokenManager.addEffectTagIconSimple("IFT", "");
	TokenManager.addEffectTagIconBonus(DataCommon.bonuscomps);
	TokenManager.addEffectTagIconSimple(DataCommon.othercomps);
	TokenManager.addEffectConditionIcon(DataCommon.condcomps);
	TokenManager.addDefaultEffectFeatures(nil, EffectManagerGURPS4e.parseEffectComp);
end

function handleIFEffectTag(rActor, nodeEffect, vComp)
	return EffectManagerGURPS4e.checkConditional(rActor, nodeEffect, vComp.remainder);
end

function getTokenHealthInfo(v)
	local nPercent, sStatus, sColor = ActorManagerGURPS4e.getInjuryStatus(v);
	return nPercent, sStatus, sColor;
end


--
-- Distance
--

function getDistance(tokenSource, tokenTarget)
	if tokenSource and tokenTarget then
		local nodeSourceContainer = tokenSource.getContainerNode()
		local nodeTargetContainer = tokenTarget.getContainerNode()
		if DB.getPath(nodeSourceContainer) == DB.getPath(nodeTargetContainer) then
			local ctrlImage, winImage, bWindowOpened = ImageManager.getImageControl(tokenSource, true)
			if ctrlImage and winImage then
				local nDistance, bAdjacent = getTokenDistance(ctrlImage, tokenSource, tokenTarget)
				if bWindowOpened then
					winImage.close()
				end
				return nDistance, bAdjacent
			end
		end
	end
end


function getTokenDistance(ctrlImage, tokenSource, tokenTarget)
	if ctrlImage and tokenSource and tokenTarget then
		local nDistance = ctrlImage.getDistanceBetween(tokenSource, tokenTarget)
		local nAdjacentThreshold = math.max(Interface.getDistanceDiagMult(), 1)
		return nDistance, nDistance <= nAdjacentThreshold
	end
end
