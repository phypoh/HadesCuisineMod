TraitData["Fish_Surface_Common_01_Trait"] =
{
		InheritFrom = { "ShopTier3Trait" },
		RequiredFalseTrait = "Fish_Surface_Common_01_Trait",
		Icon = "Boon_Poseidon_13",
		HigherFishLootChance = 0.25,
		ExtractValues =
		{
			{
				Key = "HigherFishLootChance",
				ExtractAs = "TooltipBonus",
				Format = "Percent",
			}
		}
}
TraitData["Fish_Elysium_Common_01_Trait"] =
{
		InheritFrom = { "ShopTier3Trait" },
		RequiredFalseTrait = "Fish_Elysium_Common_01_Trait",
		Icon = "Boon_Poseidon_13",
		DefenseBoostMultiplier = 2,
}
TraitData["Fish_Tartarus_Common_01_Trait"] =
{
		InheritFrom = { "ShopTier3Trait" },
		RequiredFalseTrait = "Fish_Tartarus_Common_01_Trait",
		Icon = "Boon_Poseidon_13",
}