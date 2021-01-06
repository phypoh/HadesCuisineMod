ModUtil.RegisterMod("ChefCuisineMod")
ModUtil.WrapBaseFunction("HandleDeath", function(baseFunc, currentRun, killer, killingUnitWeapon)
hasBeenUsed = false
return baseFunc(currentRun, killer, killingUnitWeapon)
end,ChefCuisineMod) 
ModUtil.BaseOverride("GetFish", function(biome, fishingState)
	local fishName = nil
	local biomeData = FishingData.BiomeFish.Defaults
	if FishingData.BiomeFish[biome] then
		biomeData = FishingData.BiomeFish[biome]
	end

	if biomeData[fishingState] then
		local fishingTable = {}
		for _, fishData in ipairs(biomeData[fishingState]) do
		if HeroHasTrait("FishingExtraChef") then
		DebugPrint({Text="Wah Hoo, weight *2"})
		fishingTable.Weight = 2
		else
		fishingTable.Weight = 1
		end
			fishingTable[fishData.Name] = fishingTable.Weight or 1
		end

		fishName = GetRandomValueFromWeightedList( fishingTable )
	end

	return fishName
end,ChefCuisineMod) 


