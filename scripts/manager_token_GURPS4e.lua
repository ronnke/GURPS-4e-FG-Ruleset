function onInit()
	-- CoreRPG
	--TokenManager.getDistance = getDistance
end

--
-- Distance
--

function getDistance(tokenSource, tokenTarget)
--	if tokenSource and tokenTarget then
--		local ctrlImage, winImage, bWindowOpened = ImageManager.getImageControl(tokenSource, true)
--		if ctrlImage and winImage then
--			local nDistance, bAdjacent = getTokenDistance(ctrlImage, tokenSource, tokenTarget)
--			return nDistance, bAdjacent
--		end
--	end

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
