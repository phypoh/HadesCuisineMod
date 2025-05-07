-- local ChefTraitData = ModUtil.Entangled.ModData(TraitData)


-- ChefTraitData["Fish_Surface_Common_01_Trait"] =
-- {
-- 		InheritFrom = { "ShopTier3Trait" },
-- 		RequiredFalseTrait = "Fish_Surface_Common_01_Trait",
-- 		Icon = "TroutSoup",
-- 		HigherFishLootChance = 0.25,
-- 		ExtractValues =
-- 		{
-- 			{
-- 				Key = "HigherFishLootChance",
-- 				ExtractAs = "TooltipBonus",
-- 				Format = "Percent",
-- 			}
-- 		}
-- }


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
		Icon = "HellfireEnergyRibsIcon",
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
		Icon = "LoversKoiIcon",
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
		Icon = "ForgivenessClawsIcon",
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
		Icon = "SnakeEyeShakeIcon",
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
		Icon = "BarricadePufferIcon",
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
		Icon = "TenArrowSushiIcon",
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
		Icon = "CuriousElixirIcon",
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
		Icon = "DazingKnuckledrinkIcon",
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
TraitData["Fish_Styx_Legendary_01_Trait"] =
{
		InheritFrom = { "ShopTier3Trait" },
		RequiredFalseTrait = "Fish_Styx_Legendary_01_Trait",
		Icon = "StabsintheIcon",
}
TraitData["Fish_Surface_Rare_01_Trait"] =
{
		InheritFrom = { "ShopTier3Trait" },
		RequiredFalseTrait = "Fish_Surface_Rare_01_Trait",
		Icon = "SlurghIcon",
		Slot = "Ranged",
		PropertyChanges =
		{
			{
				WeaponNames = WeaponSets.HeroNonPhysicalWeapons,
				WeaponProperty = "MaxAmmo",
				ChangeValue = 1,
				ChangeType = "Absolute",
			},
			{
				WeaponNames = WeaponSets.HeroNonPhysicalWeapons,
				WeaponProperty = "BarrelLength",
				ChangeValue = 128,
				ChangeType = "Absolute",
			},
			{
				WeaponNames = WeaponSets.HeroNonPhysicalWeapons,
				WeaponProperty = "Projectile",
				ChangeValue = "ChefProjectile",
				ChangeType = "Absolute",
			},

			{
				WeaponNames = WeaponSets.HeroNonPhysicalWeapons,
				WeaponProperty = "ProjectileSpacing",
				ChangeValue = 0,
				ChangeType = "Absolute",
			},
			-- For adjusting aimline collisions -- @alice
			{
				WeaponNames = WeaponSets.HeroNonPhysicalWeapons,
				ProjectileProperty = "Scale",
				ChangeValue = 1,
				ChangeType = "Absolute",
			},
			--[[
			{
				WeaponNames = WeaponSets.HeroNonPhysicalWeapons,
				ProjectileProperty = "AimLineAnimation",
				ChangeValue = "AimLineExtraDamageCap",
				ChangeType = "Absolute",
			},
			]]
			{
				WeaponNames = WeaponSets.HeroNonPhysicalWeapons,
				WeaponProperty = "ProjectileAngleOffset",
				ChangeValue = 25,
				ChangeType = "Absolute",
			},
			{
				WeaponNames = WeaponSets.HeroNonPhysicalWeapons,
				EffectName = "ReduceDamageOutput",
				EffectProperty = "Active",
				ChangeValue = true,
			},
			{
				WeaponNames = WeaponSets.HeroNonPhysicalWeapons,
				WeaponProperty = "AutoLockRange",
				ChangeValue = 440,
				ChangeType = "Absolute",
			},
			{
				WeaponNames = WeaponSets.HeroNonPhysicalWeapons,
				ProjectileProperty = "DetonateChildGraphics",
				ChangeValue = "Cone180Athena",
				ChangeType = "Absolute",
			},

			{
				WeaponNames = WeaponSets.HeroNonPhysicalWeapons,
				WeaponProperty = "FireFx",
				ChangeValue = "ProjectileFireRing-Aphrodite",
				ChangeType = "Absolute",
			},
			{
				WeaponNames = WeaponSets.HeroNonPhysicalWeapons,
				ProjectileProperty = "DamageLow",
				BaseMin = 100,
				BaseMax = 100,
			},
			{
				WeaponNames = WeaponSets.HeroNonPhysicalWeapons,
				ProjectileProperty = "DamageHigh",
				DeriveValueFrom = "DamageLow"
			},
		},
}
TraitData["Fish_Surface_Legendary_01_Trait"] =
{
		InheritFrom = { "ShopTier3Trait" },
		RequiredFalseTrait = "Fish_Surface_Legendary_01_Trait",
		Icon = "EatingMealIcon",
		PropertyChanges = {
			{
				LuaProperty = "MaxHealth",
				ChangeValue = 30,
				AsInt = true,
				ChangeType = "Add",
				MaintainDelta = true,
			},
		}
}
TraitData["Fish_Asphodel_Common_01_Trait"] =
{
		InheritFrom = { "ShopTier3Trait" },
		RequiredFalseTrait = "Fish_Asphodel_Common_01_Trait",
		Icon = "SlavugEscargotIcon",
		PropertyChanges = {
			{
				WeaponNames = WeaponSets.HeroNonPhysicalWeapons,
				WeaponProperty = "MaxAmmo",
				ChangeValue = 100,
				ChangeType = "Absolute"
			},
		}
}
TraitData["Fish_Elysium_Legendary_01_Trait"] =
{
		InheritFrom = { "ShopTier3Trait" },
		RequiredFalseTrait = "Fish_Elysium_Legendary_01_Trait",
		Icon = "DriedSeamareIcon",
		SetupFunction =
		{
			Name = "ChefBuffKeepsakes",
			Args ={},
			RunOnce = true,
		},
}
TraitData["Fish_Styx_Common_01_Trait"] =
{
		InheritFrom = { "ShopTier3Trait" },
		RequiredFalseTrait = "Fish_Styx_Common_01_Trait",
		Icon = "SweetSourGuppIcon",
}
TraitData["BetterWeaponMastery_Trait"] =
{
		InheritFrom = { "ShopTier3Trait" },
		RequiredFalseTrait = "BetterWeaponMastery_Trait",
		Icon = "BetterWeaponMasteryIcon",
}
TraitData["BetterDualWielding_Trait"] =
{
		InheritFrom = { "ShopTier3Trait" },
		RequiredFalseTrait = "BetterDualWielding_Trait",
		Icon = "BetterDualWieldingIcon",
		AddOutgoingDamageModifiers =
		{
			UseTraitValue = "CurrentWeaponSwapBonus",
		},
		CurrentWeaponSwapBonus = 1,
}
TraitData["BetterWeaponAspectRework_Trait"] =
{
		InheritFrom = { "ShopTier3Trait" },
		RequiredFalseTrait = "BetterWeaponAspectRework_Trait",
		Icon = "BetterWeaponAspectReworkIcon",
		SetupFunction =
		{
			Name = "ChefBuffAspects",
			Args ={},
			RunOnce = true,
		},
}