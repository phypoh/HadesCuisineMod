TraitData["Fish_Surface_Common_01_Trait"] =
{
		InheritFrom = { "ShopTier3Trait" },
		RequiredFalseTrait = "Fish_Surface_Common_01_Trait",
		Icon = "TroutSoupIcon",
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
		Icon = "SteamedChlamsIcon",
		DefenseBoostMultiplier = 2,
}
TraitData["Fish_Tartarus_Common_01_Trait"] =
{
		InheritFrom = { "ShopTier3Trait" },
		RequiredFalseTrait = "Fish_Tartarus_Common_01_Trait",
		Icon = "HellfishScoopIcon",
}
TraitData["StackUpgrade_Trait"] =
{
		InheritFrom = { "ShopTier3Trait" },
		RequiredFalseTrait = "StackUpgrade_Trait",
		Icon = "PomSaladIcon",
}
TraitData["RoomRewardHealDrop_Trait"] =
{
		InheritFrom = { "ShopTier3Trait" },
		RequiredFalseTrait = "RoomRewardHealDrop_Trait",
		Icon = "KidsMealIcon",
		AddOutgoingDamageModifiers =
		{
			UseTraitValue = "AccumulatedDamageBonusFood",
		},
		AccumulatedDamageBonusFood = 1,
}