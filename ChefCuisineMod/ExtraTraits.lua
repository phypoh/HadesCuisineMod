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
TraitData["GemDrop_Trait"] =
{
		InheritFrom = { "ShopTier3Trait" },
		RequiredFalseTrait = "RoomRewardHealDrop_Trait",
		Icon = "RockCandyIcon",
		PropertyChanges =
		{
			{
				WeaponNames = WeaponSets.HeroNonPhysicalWeapons,
				WeaponProperty = "MaxAmmo",
				ChangeValue = 1,
				ChangeType = "Add",
				ExtractValue =
				{
					ExtractAs = "TooltipAmmo",
				}
			},
		}
}
TraitData["BetterChaosGates_Trait"] =
{
		InheritFrom = { "ShopTier3Trait" },
		RequiredFalseTrait = "BetterChaosGates_Trait",
		Icon = "BetterChaosGatesIcon",
}
TraitData["BetterShrinePoints_Trait"] =
{
		InheritFrom = { "ShopTier3Trait" },
		RequiredFalseTrait = "BetterShrinePoints_Trait",
		Icon = "BetterShrinePointsIcon",
}

TraitData["Fish_Asphodel_Legendary_01_Trait"] =
{
		InheritFrom = { "ShopTier3Trait" },
		RequiredFalseTrait = "Fish_Asphodel_Legendary_01_Trait",
		Icon = "BetterShrinePointsIcon",
		ChefGodToForce = "ZuesUpgrade",
		RarityBonus =
		{
			RequiredGod = "ZeusUpgrade",
			RareBonus = { BaseValue = 0.15},
			EpicBonus = 0.15,
			LegendaryBonus = 0.15,
		},
}
TraitData["Fish_Elysium_Rare_01_Trait"] =
{
		InheritFrom = { "ShopTier3Trait" },
		RequiredFalseTrait = "Fish_Elysium_Rare_01_Trait",
		Icon = "BetterShrinePointsIcon",
		ChefGodToForce = "AphroditeUpgrade",
		RarityBonus =
		{
			RequiredGod = "AphroditeUpgrade",
			RareBonus = { BaseValue = 0.15},
			EpicBonus = 0.15,
			LegendaryBonus = 0.15,
		},
}
TraitData["Fish_Asphodel_Rare_01_Trait"] =
{
		InheritFrom = { "ShopTier3Trait" },
		RequiredFalseTrait = "Fish_Asphodel_Rare_01_Trait",
		Icon = "BetterShrinePointsIcon",
		ChefGodToForce = "DemeterUpgrade",
		RarityBonus =
		{
			RequiredGod = "DemeterUpgrade",
			RareBonus = { BaseValue = 0.15},
			EpicBonus = 0.15,
			LegendaryBonus = 0.15,
		},
}
TraitData["Fish_Chaos_Common_01_Trait"] =
{
		InheritFrom = { "ShopTier3Trait" },
		RequiredFalseTrait = "Fish_Chaos_Common_01_Trait",
		Icon = "BetterShrinePointsIcon",
		ChefGodToForce = "AresUpgrade",
		RarityBonus =
		{
			RequiredGod = "AresUpgrade",
			RareBonus = { BaseValue = 0.15},
			EpicBonus = 0.15,
			LegendaryBonus = 0.15,
		},
}
TraitData["Fish_Styx_Rare_01_Trait"] =
{
		InheritFrom = { "ShopTier3Trait" },
		RequiredFalseTrait = "Fish_Styx_Rare_01_Trait",
		Icon = "BetterShrinePointsIcon",
		ChefGodToForce = "AthenaUpgrade",
		RarityBonus =
		{
			RequiredGod = "AthenaUpgrade",
			RareBonus = { BaseValue = 0.15},
			EpicBonus = 0.15,
			LegendaryBonus = 0.15,
		},
}
TraitData["Fish_Tartarus_Legendary_01_Trait"] =
{
		InheritFrom = { "ShopTier3Trait" },
		RequiredFalseTrait = "Fish_Tartarus_Legendary_01_Trait",
		Icon = "BetterShrinePointsIcon",
		ChefGodToForce = "ArtemisUpgrade",
		RarityBonus =
		{
			RequiredGod = "ArtemisUpgrade",
			RareBonus = { BaseValue = 0.15},
			EpicBonus = 0.15,
			LegendaryBonus = 0.15,
		},
}
TraitData["Fish_Chaos_Rare_01_Trait"] =
{
		InheritFrom = { "ShopTier3Trait" },
		RequiredFalseTrait = "Fish_Chaos_Rare_01_Trait",
		Icon = "BetterShrinePointsIcon",
		ChefGodToForce = "PoseidonUpgrade",
		RarityBonus =
		{
			RequiredGod = "PoseidonUpgrade",
			RareBonus = { BaseValue = 0.15},
			EpicBonus = 0.15,
			LegendaryBonus = 0.15,
		},
}
TraitData["Fish_Tartarus_Rare_01_Trait"] =
{
		InheritFrom = { "ShopTier3Trait" },
		RequiredFalseTrait = "Fish_Tartarus_Rare_01_Trait",
		Icon = "BetterShrinePointsIcon",
		ChefGodToForce = "DionysusUpgrade",
		RarityBonus =
		{
			RequiredGod = "DionysusUpgrade",
			RareBonus = { BaseValue = 0.15},
			EpicBonus = 0.15,
			LegendaryBonus = 0.15,
		},
}
TraitData["Fish_Chaos_Legendary_01_Trait"] =
{
		InheritFrom = { "ShopTier3Trait" },
		RequiredFalseTrait = "Fish_Chaos_Legendary_01_Trait",
		Icon = "MysteryJansIcon",
		RoomsPerUpgrade = 3,
		CurrentRoom = 0,
}