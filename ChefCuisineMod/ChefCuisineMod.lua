ModUtil.RegisterMod("ChefCuisineMod")
GodBoonAmount = {}
BoonsThisLevel = 0
CompletedLevels = 0
local ChefJanTraitData = {}
local currentJanTrait = nil
SaveIgnores["GodBoonAmount"] = true

ModUtil.WrapBaseFunction("HandleDeath", function(baseFunc, currentRun, killer, killingUnitWeapon)
	hasBeenUsed = false
	ChefRetaliateBufRevert()
	return baseFunc(currentRun, killer, killingUnitWeapon)
end,ChefCuisineMod)

OnAnyLoad{function ()
	if CurrentRun.CurrentRoom ~= nil and SelectedFish == "BetterShrinePoints" then
		CurrentRun.CurrentRoom.ShrinePointDoorCost = 1
	end
end}
OnAnyLoad{"DeathArea DeathAreaBedroom RoomPreRun", function ()
	if SelectedFish ~= "Fish_Elysium_Legendary_01" then
		ChefResetKeepsakes()
	end
end}
ModUtil.WrapBaseFunction("StartNewRun", function(baseFunc, prevRun, args)
	local returnVal = baseFunc(prevRun, args)
	if SelectedFish ~= nil then
		AddTraitToHero({ TraitData = GetProcessedTraitData({ Unit = CurrentRun.Hero, TraitName = SelectedFish .. "_Trait", Rarity = "Legendary" }) })
	end
	if SelectedFish == "Fish_Chaos_Legendary_01" then
		local traitData = CollapseTable( TraitData ) -- no mutation
		for i, trait in ipairs( traitData ) do
  			if trait.Slot ~= nil or not IsGodTrait(trait.Name) or (trait.RarityLevels == nil or trait.RarityLevels.Common == nil) or RequiredWeapon ~= nil then
    			traitData[ i ] = nil
  			end
		end
		traitData = CollapseTable( traitData)
		ChefJanTraitData = traitData
		local n = #ChefJanTraitData
		local janTraitData = GetProcessedTraitData({ Unit = CurrentRun.Hero, TraitName = "Fish_Chaos_Legendary_01_Trait", Rarity = "Legendary" })
		
		local currentTrait = ChefJanTraitData[RandomInt(1,n)]
		currentJanTrait = currentTrait.Name
		AddTraitToHero({TraitName = currentTrait.Name})
		
	elseif SelectedFish == "Fish_Styx_Legendary_01" then
		ChefRetaliateBuffSetup()
	end
	BoonsThisLevel = 0
	CompletedLevels = 0
	GodBoonAmount = {}
	return returnVal
end,ChefCuisineMod) 


ModUtil.BaseOverride("CalculateDamageMultipliers", function ( attacker, victim, weaponData, triggerArgs )
	local damageReductionMultipliers = 1
	local damageMultipliers = 1.0
	local lastAddedMultiplierName = ""

	if ConfigOptionCache.LogCombatMultipliers then
		DebugPrint({Text = " SourceWeapon : " .. tostring( triggerArgs.SourceWeapon )})
	end
	if SelectedFish == "Fish_Styx_Common_01" then
		local curHelath = CurrentRun.Hero.Health
		local maxHealth =  CurrentRun.Hero.MaxHealth
		local x = (maxHealth - curHelath) / maxHealth
		if victim.ObjectId ~= CurrentRun.Hero.ObjectId and (curHelath / maxHealth > 0.5)  then
			local m = -2
			local b = 1
			local healthMultiplier = (m*x) + b
			damageMultipliers = damageMultipliers + healthMultiplier - 1
		elseif victim.ObjectId == CurrentRun.Hero.ObjectId and (curHelath / maxHealth < 0.5) then
			local m = 1.5625
			local b = -0.8125
			local healthMultiplier = (m*x) + b
			damageMultipliers = damageMultipliers + healthMultiplier
		end
	end
	local addDamageMultiplier = function( data, multiplier )
		if multiplier >= 1.0 then
			if data.Multiplicative then
				damageReductionMultipliers = damageReductionMultipliers * multiplier
			else
				damageMultipliers = damageMultipliers + multiplier - 1
			end
			if ConfigOptionCache.LogCombatMultipliers then
				lastAddedMultiplierName = data.Name or "Unknown"
				DebugPrint({Text = " Additive Damage Multiplier (" .. lastAddedMultiplierName .. "):" .. multiplier })
			end
		else
			if data.Additive then
				if GetTotalHeroTraitValue("DefenseBoostMultiplier") > 0 then
				damageReductionMultipliers = damageReductionMultipliers + (multiplier * GetTotalHeroTraitValue("DefenseBoostMultiplier")) - 1
				else
				damageMultipliers = damageMultipliers + multiplier - 1
				end
			else
				if GetTotalHeroTraitValue("DefenseBoostMultiplier") > 0 then
				damageReductionMultipliers = damageReductionMultipliers * (multiplier * GetTotalHeroTraitValue("DefenseBoostMultiplier"))
				else
				damageReductionMultipliers = damageReductionMultipliers * multiplier
				end
			end
			if ConfigOptionCache.LogCombatMultipliers then
				lastAddedMultiplierName = data.Name or "Unknown"
				DebugPrint({Text = " Multiplicative Damage Reduction (" .. lastAddedMultiplierName .. "):" .. multiplier })
			end
		end
	end

	if triggerArgs.ProjectileAdditiveDamageMultiplier then
		damageMultipliers = damageMultipliers + triggerArgs.ProjectileAdditiveDamageMultiplier
	end

	if victim.IncomingDamageModifiers ~= nil then
		for i, modifierData in ipairs(victim.IncomingDamageModifiers) do
			if modifierData.GlobalMultiplier ~= nil then
				addDamageMultiplier( modifierData, modifierData.GlobalMultiplier)
			end
			
			local validWeapon = modifierData.ValidWeaponsLookup == nil or ( modifierData.ValidWeaponsLookup[ triggerArgs.SourceWeapon ] ~= nil and triggerArgs.EffectName == nil )

			if validWeapon and ( not triggerArgs.AttackerIsObstacle and ( attacker and attacker.DamageType ~= "Neutral" ) or modifierData.IncludeObstacleDamage or modifierData.TrapDamageTakenMultiplier ) then
				if modifierData.ZeroRangedWeaponAmmoMultiplier and RunWeaponMethod({ Id = victim.ObjectId, Weapon = "RangedWeapon", Method = "GetAmmo" }) == 0 then
					addDamageMultiplier( modifierData, modifierData.ZeroRangedWeaponAmmoMultiplier)
				end
				if modifierData.ValidWeaponMultiplier then
					addDamageMultiplier( modifierData, modifierData.ValidWeaponMultiplier)
				end
				if modifierData.ProjectileDeflectedMultiplier and triggerArgs.ProjectileDeflected then
					addDamageMultiplier( modifierData, modifierData.ProjectileDeflectedMultiplier)
				end

				if modifierData.BossDamageMultiplier and attacker and ( attacker.IsBoss or attacker.IsBossDamage ) then
					addDamageMultiplier( modifierData, modifierData.BossDamageMultiplier)
				end
				if modifierData.LowHealthDamageTakenMultiplier ~= nil and (victim.Health / victim.MaxHealth) <= modifierData.LowHealthThreshold then
					addDamageMultiplier( modifierData, modifierData.LowHealthDamageTakenMultiplier)
				end
				if modifierData.TrapDamageTakenMultiplier ~= nil and (( attacker ~= nil and attacker.DamageType == "Neutral" ) or (attacker == nil and triggerArgs.AttackerName ~= nil and EnemyData[triggerArgs.AttackerName] ~= nil and EnemyData[triggerArgs.AttackerName].DamageType == "Neutral" )) then
					addDamageMultiplier( modifierData, modifierData.TrapDamageTakenMultiplier)
				end
				if modifierData.DistanceMultiplier and triggerArgs.DistanceSquared ~= nil and triggerArgs.DistanceSquared ~= -1 and ( modifierData.DistanceThreshold * modifierData.DistanceThreshold ) <= triggerArgs.DistanceSquared then
					addDamageMultiplier( modifierData, modifierData.DistanceMultiplier)
				end
				if modifierData.ProximityMultiplier and triggerArgs.DistanceSquared ~= nil and triggerArgs.DistanceSquared ~= -1 and ( modifierData.ProximityThreshold * modifierData.ProximityThreshold ) >= triggerArgs.DistanceSquared then
					addDamageMultiplier( modifierData, modifierData.ProximityMultiplier)
				end
				if modifierData.NonTrapDamageTakenMultiplier ~= nil and (( attacker ~= nil and attacker.DamageType ~= "Neutral" ) or (attacker == nil and triggerArgs.AttackerName ~= nil and EnemyData[triggerArgs.AttackerName] ~= nil and EnemyData[triggerArgs.AttackerName].DamageType ~= "Neutral" )) then
					addDamageMultiplier( modifierData, modifierData.NonTrapDamageTakenMultiplier)
				end
				if modifierData.HitVulnerabilityMultiplier and triggerArgs.HitVulnerability then
					addDamageMultiplier( modifierData, modifierData.HitVulnerabilityMultiplier )
				end
				if modifierData.HitArmorMultiplier and triggerArgs.HitArmor then
					addDamageMultiplier( modifierData, modifierData.HitArmorMultiplier )
				end
				if modifierData.NonPlayerMultiplier and attacker ~= CurrentRun.Hero and attacker ~= nil and not HeroData.DefaultHero.HeroAlliedUnits[attacker.Name] then
					addDamageMultiplier( modifierData, modifierData.NonPlayerMultiplier)
				end
				if modifierData.SelfMultiplier and attacker == victim then
					addDamageMultiplier( modifierData, modifierData.SelfMultiplier)
				end
				if modifierData.PlayerMultiplier and attacker == CurrentRun.Hero then
					addDamageMultiplier( modifierData, modifierData.PlayerMultiplier )
				end
			end
		end
	end

	if attacker ~= nil and attacker.OutgoingDamageModifiers ~= nil and ( not weaponData or not weaponData.IgnoreOutgoingDamageModifiers ) then
		local appliedEffectTable = {}
		for i, modifierData in ipairs(attacker.OutgoingDamageModifiers) do
			if modifierData.GlobalMultiplier ~= nil then
				addDamageMultiplier( modifierData, modifierData.GlobalMultiplier)
			end

			local validEffect = modifierData.ValidEffects == nil or ( triggerArgs.EffectName ~= nil and Contains(modifierData.ValidEffects, triggerArgs.EffectName ))
			local validWeapon = modifierData.ValidWeaponsLookup == nil or ( modifierData.ValidWeaponsLookup[ triggerArgs.SourceWeapon ] ~= nil and triggerArgs.EffectName == nil )
			local validTrait = modifierData.RequiredTrait == nil or ( attacker == CurrentRun.Hero and HeroHasTrait( modifierData.RequiredTrait ) )
			local validUniqueness = modifierData.Unique == nil or not modifierData.Name or not appliedEffectTable[modifierData.Name]
			local validEnchantment = true
			if modifierData.ValidEnchantments and attacker == CurrentRun.Hero then
				validEnchantment = false
				if modifierData.ValidEnchantments.TraitDependentWeapons then
					for traitName, validWeapons in ipairs( modifierData.ValidEnchantments.TraitDependentWeapons ) do
						if Contains( validWeapons, triggerArgs.SourceWeapon) and HeroHasTrait( traitName ) then
							validEnchantment = true
							break
						end
					end
				end

				if not validEnchantment and modifierData.ValidEnchantments.ValidWeapons and Contains( modifierData.ValidEnchantments.ValidWeapons, triggerArgs.SourceWeapon ) then
					validEnchantment = true
				end
			end

			if validUniqueness and validWeapon and validEffect and validTrait and validEnchantment then
				if modifierData.Name then
					appliedEffectTable[ modifierData.Name] = true
				end
				if modifierData.HighHealthSourceMultiplierData and attacker.Health / attacker.MaxHealth > modifierData.HighHealthSourceMultiplierData.Threshold then
					addDamageMultiplier( modifierData, modifierData.HighHealthSourceMultiplierData.Multiplier )
				end
				if modifierData.PerUniqueGodMultiplier and attacker == CurrentRun.Hero then
					addDamageMultiplier( modifierData, 1 + ( modifierData.PerUniqueGodMultiplier - 1 ) * GetHeroUniqueGodCount( attacker ))
				end
				if modifierData.BossDamageMultiplier and victim.IsBoss then
					addDamageMultiplier( modifierData, modifierData.BossDamageMultiplier)
				end
				if modifierData.ZeroRangedWeaponAmmoMultiplier and RunWeaponMethod({ Id = attacker.ObjectId, Weapon = "RangedWeapon", Method = "GetAmmo" }) == 0 then
					addDamageMultiplier( modifierData, modifierData.ZeroRangedWeaponAmmoMultiplier)
				end
				if modifierData.EffectThresholdDamageMultiplier and triggerArgs.MeetsEffectDamageMultiplier then
					addDamageMultiplier( modifierData, modifierData.EffectThresholdDamageMultiplier)
				end
				if modifierData.PerfectChargeMultiplier and triggerArgs.IsPerfectCharge then
					addDamageMultiplier( modifierData, modifierData.PerfectChargeMultiplier)
				end

				if modifierData.UseTraitValue and attacker == CurrentRun.Hero then
					addDamageMultiplier( modifierData, GetTotalHeroTraitValue( modifierData.UseTraitValue, { IsMultiplier = modifierData.IsMultiplier }))
				end
				if modifierData.HitVulnerabilityMultiplier and triggerArgs.HitVulnerability then
					addDamageMultiplier( modifierData, modifierData.HitVulnerabilityMultiplier )
				end
				if modifierData.HitMaxHealthMultiplier and victim.Health == victim.MaxHealth and (victim.MaxHealthBuffer == nil or victim.HealthBuffer == victim.MaxHealthBuffer ) then
					addDamageMultiplier( modifierData, modifierData.HitMaxHealthMultiplier )
				end
				if modifierData.MinRequiredVulnerabilityEffects and victim.VulnerabilityEffects and TableLength( victim.VulnerabilityEffects ) >= modifierData.MinRequiredVulnerabilityEffects then
					--DebugPrint({Text = " min required vulnerability " .. modifierData.PerVulnerabilityEffectAboveMinMultiplier})
					addDamageMultiplier( modifierData, modifierData.PerVulnerabilityEffectAboveMinMultiplier)
				end
				if modifierData.HealthBufferDamageMultiplier and victim.HealthBuffer ~= nil and victim.HealthBuffer > 0 then
					addDamageMultiplier( modifierData, modifierData.HealthBufferDamageMultiplier)
				end
				if modifierData.StoredAmmoMultiplier and victim.StoredAmmo ~= nil and not IsEmpty( victim.StoredAmmo ) then
					local hasExternalStoredAmmo = false
					for i, storedAmmo in ipairs(victim.StoredAmmo) do
						if storedAmmo.WeaponName ~= "SelfLoadAmmoApplicator" then
							hasExternalStoredAmmo = true
						end
					end
					if hasExternalStoredAmmo then
						addDamageMultiplier( modifierData, modifierData.StoredAmmoMultiplier)
					end
				end
				if modifierData.UnstoredAmmoMultiplier and IsEmpty( victim.StoredAmmo ) then
					addDamageMultiplier( modifierData, modifierData.UnstoredAmmoMultiplier)
				end
				if modifierData.ValidWeaponMultiplier then
					addDamageMultiplier( modifierData, modifierData.ValidWeaponMultiplier)
				end
				if modifierData.RequiredSelfEffectsMultiplier and not IsEmpty(attacker.ActiveEffects) then
					local hasAllEffects = true
					for _, effectName in ipairs( modifierData.RequiredEffects ) do
						if not attacker.ActiveEffects[ effectName ] then
							hasAllEffects = false
						end
					end
					if hasAllEffects then
						addDamageMultiplier( modifierData, modifierData.RequiredSelfEffectsMultiplier)
					end
				end

				if modifierData.RequiredEffectsMultiplier and victim and not IsEmpty(victim.ActiveEffects) then
					local hasAllEffects = true
					for _, effectName in ipairs( modifierData.RequiredEffects ) do
						if not victim.ActiveEffects[ effectName ] then
							hasAllEffects = false
						end
					end
					if hasAllEffects then
						addDamageMultiplier( modifierData, modifierData.RequiredEffectsMultiplier)
					end
				end
				if modifierData.DistanceMultiplier and triggerArgs.DistanceSquared ~= nil and triggerArgs.DistanceSquared ~= -1 and ( modifierData.DistanceThreshold * modifierData.DistanceThreshold ) <= triggerArgs.DistanceSquared then
					addDamageMultiplier( modifierData, modifierData.DistanceMultiplier)
				end
				if modifierData.ProximityMultiplier and triggerArgs.DistanceSquared ~= nil and triggerArgs.DistanceSquared ~= -1 and ( modifierData.ProximityThreshold * modifierData.ProximityThreshold ) >= triggerArgs.DistanceSquared then
					addDamageMultiplier( modifierData, modifierData.ProximityMultiplier)
				end
				if modifierData.LowHealthDamageOutputMultiplier ~= nil and attacker.Health ~= nil and (attacker.Health / attacker.MaxHealth) <= modifierData.LowHealthThreshold then
					addDamageMultiplier( modifierData, modifierData.LowHealthDamageOutputMultiplier)
				end
				if modifierData.TargetHighHealthDamageOutputMultiplier ~= nil and (victim.Health / victim.MaxHealth) < modifierData.TargetHighHealthThreshold then
					addDamageMultiplier( modifierData, modifierData.TargetHighHealthDamageOutputMultiplier)
				end
				if modifierData.FriendMultiplier and ( victim == attacker or ( attacker.Charmed and victim == CurrentRun.Hero ) or ( not attacker.Charmed and victim ~= CurrentRun.Hero and not HeroData.DefaultHero.HeroAlliedUnits[victim.Name] )) then
					addDamageMultiplier( modifierData, modifierData.FriendMultiplier )
				end
				if modifierData.PlayerMultiplier and victim == CurrentRun.Hero then
					addDamageMultiplier( modifierData, modifierData.PlayerMultiplier )
				end
				if modifierData.NonPlayerMultiplier and victim ~= CurrentRun.Hero and not HeroData.DefaultHero.HeroAlliedUnits[victim.Name] then
					addDamageMultiplier( modifierData, modifierData.NonPlayerMultiplier )
				end
				if modifierData.FinalShotMultiplier and CurrentRun.CurrentRoom.ZeroAmmoVolley and CurrentRun.CurrentRoom.ZeroAmmoVolley[ triggerArgs.ProjectileVolley ] then
					addDamageMultiplier( modifierData, modifierData.FinalShotMultiplier)
				end
				if modifierData.LoadedAmmoMultiplier and CurrentRun.CurrentRoom.LoadedAmmo and CurrentRun.CurrentRoom.LoadedAmmo > 0 then
					addDamageMultiplier( modifierData, modifierData.LoadedAmmoMultiplier)
				end
				if modifierData.SpeedDamageMultiplier then
					local baseSpeed = GetBaseDataValue({ Type = "Unit", Name = "_PlayerUnit", Property = "Speed" })
					local speedModifier = CurrentRun.CurrentRoom.SpeedModifier or 1
					local currentSpeed = GetUnitDataValue({ Id = CurrentRun.Hero.ObjectId, Property = "Speed" }) * speedModifier
					if currentSpeed > baseSpeed then
						addDamageMultiplier( modifierData, 1 + modifierData.SpeedDamageMultiplier * ( currentSpeed/baseSpeed - 1 ))
					end
				end

				if modifierData.ActiveDashWeaponMultiplier and triggerArgs.BlinkWeaponActive then
					addDamageMultiplier( modifierData, modifierData.ActiveDashWeaponMultiplier )
				end

				if modifierData.EmptySlotMultiplier and modifierData.EmptySlotValidData then
					local filledSlots = {}

					for i, traitData in ipairs( attacker.Traits ) do
						if traitData.Slot then
							filledSlots[traitData.Slot] = true
						end
					end

					for key, weaponList in ipairs( modifierData.EmptySlotValidData ) do
						if not filledSlots[key] and Contains( weaponList, triggerArgs.SourceWeapon ) then
							addDamageMultiplier( modifierData, modifierData.EmptySlotMultiplier )
						end
					end
				end
			end
		end
	end

	if weaponData ~= nil then
		if attacker == victim and weaponData.SelfMultiplier then
			addDamageMultiplier( { Name = weaponData.Name, Multiplicative = true }, weaponData.SelfMultiplier)
		end

		if weaponData.OutgoingDamageModifiers ~= nil and not weaponData.IgnoreOutgoingDamageModifiers then
			for i, modifierData in ipairs(weaponData.OutgoingDamageModifiers) do
				if modifierData.NonPlayerMultiplier and victim ~= CurrentRun.Hero and not HeroData.DefaultHero.HeroAlliedUnits[victim.Name] then
					addDamageMultiplier( modifierData, modifierData.NonPlayerMultiplier)
				end
				if modifierData.PlayerMultiplier and ( victim == CurrentRun.Hero or HeroData.DefaultHero.HeroAlliedUnits[victim.Name] ) then
					addDamageMultiplier( modifierData, modifierData.PlayerMultiplier)
				end
				if modifierData.PlayerSummonMultiplier and HeroData.DefaultHero.HeroAlliedUnits[victim.Name] then
					addDamageMultiplier( modifierData, modifierData.PlayerSummonMultiplier)
				end
			end
		end
	end

	if ConfigOptionCache.LogCombatMultipliers and triggerArgs and triggerArgs.AttackerName and triggerArgs.DamageAmount then
		DebugPrint({Text = triggerArgs.AttackerName .. ": Base Damage : " .. triggerArgs.DamageAmount .. " Damage Bonus: " .. damageMultipliers .. ", Damage Reduction: " .. damageReductionMultipliers })
	end
	return damageMultipliers * damageReductionMultipliers
end, ChefCuisineMod)


OnAnyLoad{ function()
    if SelectedFish == nil or SelectedFish ~= "Fish_Tartarus_Common_01" then return end
    thread( function()
	local elapsedTime = 0
        while SelectedFish == "Fish_Tartarus_Common_01" do
		local speed = GetVelocity({ Id = currentRun.Hero.ObjectId })
		if speed ~= 0 then
			elapsedTime = 0
		else
			elapsedTime = elapsedTime + 0.2
		end
		if elapsedTime >= 1.5 then
		
		ApplyEffectFromWeapon({ Id = CurrentRun.Hero.ObjectId, DestinationId = CurrentRun.Hero.ObjectId, WeaponName = "StrudyChef", EffectName = "AspectHyperArmor" , AutoEquip = true})
		end
            wait(0.2)
        end
    end)
end}

ModUtil.WrapBaseFunction("AddTraitToHero", function (baseFunc, args)
	local returnValue = baseFunc(args)
	local traitData = args.TraitData
	if BoonsThisLevel == nil then
		BoonsThisLevel = 0
	end
	if SelectedFish == "StackUpgrade" and traitData ~= nil then
		if IsGodTrait(traitData.Name) and GetTraitNameCount(CurrentRun.Hero, traitData.Name) == 1 then
			BoonsThisLevel = BoonsThisLevel + 1
		end
	if BoonsThisLevel ~= nil and BoonsThisLevel == 5 then
			local leveledBoons = {}
			for k, currentTrait in ipairs( CurrentRun.Hero.Traits ) do 
				if not Contains(leveledBoons, currentTrait.Name) then
				table.insert(leveledBoons, currentTrait.Name)
				if IsGameStateEligible(CurrentRun, TraitData[currentTrait.Name]) and IsGodTrait(currentTrait.Name) then
					AddTraitToHeroChef({TraitData = currentTrait})
				end
				end
			end
			BoonsThisLevel = 0
			CompletedLevels = CompletedLevels + 1
		end

	end
	if SelectedFish == "RoomRewardHealDrop" then
		for i, god in ipairs(LootData) do
			if ( god.GodLoot or ( args.ForShop and god.TreatAsGodLootByShops )) and not god.DebugOnly and god.TraitIndex[traitData.Name] then
				GodBoonAmount[god.Name] = ( GodBoonAmount[god.Name] or 0 ) + 1
			end
			break
		end
		local highest = 0
		for k,v in ipairs(GodBoonAmount) do
			if v > highest then
				highest = v
			end
		end
		for i, traitData in ipairs( CurrentRun.Hero.Traits ) do
			if traitData.Name == "RoomRewardHealDrop_Trait" then
				traitData.AccumulatedDamageBonusFood = 1 + (highest * 0.05)
				break
			end
		end
	end
	return returnValue
end, ChefCuisineMod)


function AddTraitToHeroChef(args)
	local traitData = args.TraitData
	if traitData == nil then
		traitData = GetProcessedTraitData({ Unit = CurrentRun.Hero, TraitName = args.TraitName, Rarity = args.Rarity })
	end

	GameState.LastPickedTraitName = traitData.Name

	if not args.PreProcessedForDisplay then
		ExtractValues(CurrentRun.Hero, traitData, traitData)
	end

	if traitData.Slot and CurrentRun.CurrentRoom then
		CurrentRun.CurrentRoom.AcquiredSlot = traitData.Slot
	end
	-- traits may have information that acts on weapons, so we must first equip all associated weapons to the player
	EquipReferencedWeapons( traitData )
	AddTraitData( CurrentRun.Hero, traitData, args )

	EquipSpecialWeapons( CurrentRun.Hero, traitData )
	AddAssistWeapons( CurrentRun.Hero, traitData )
	for weaponName, v in ipairs( CurrentRun.Hero.Weapons ) do
		AddWallSlamWeapons( CurrentRun.Hero, traitData )
		AddOnDamageWeapons(CurrentRun.Hero, weaponName, traitData)
		AddOnFireWeapons(CurrentRun.Hero, weaponName, traitData)
		if traitData.UpgradeHeroWeapon ~= nil and Contains(traitData.UpgradeHeroWeapon.WeaponNames, weaponName) then
			AddHeroWeaponUpgrade(weaponName, traitData.UpgradeHeroWeapon.UpgradeName)
		end
	end

	if ( traitData.EnemyPropertyChanges or traitData.AddEnemyOnDeathWeapons ) and ActiveEnemies ~= nil then
		for enemyId, enemy in ipairs( ActiveEnemies ) do
			EquipReferencedEnemyWeapons( currentRun, traitData, enemy )
			ApplyEnemyTrait( CurrentRun, traitData, enemy )
		end
	end

	if traitData.AddShout then
		if traitData.AddShout.Cost then
			CurrentRun.Hero.SuperCost = traitData.AddShout.Cost
		else
			CurrentRun.Hero.SuperCost = 25
		end
		ShowSuperMeter()
	end
end


OnProjectileDeath{
	function( triggerArgs)
		local victimId = triggerArgs.triggeredById
		local victim = triggerArgs.TriggeredByTable
		local attacker = triggerArgs.AttackerTable
		local weaponData = GetWeaponData( attacker, triggerArgs.WeaponName)
		local projectileData = ProjectileData[triggerArgs.name]
		TryUnloadAmmo( triggerArgs.WeaponName, victim, attacker, triggerArgs )

		if weaponData ~= nil then
			local storeInUnit = victim
			local storeInUnitId = victimId
			if storeInUnit == nil and projectileData ~= nil and projectileData.StoreAmmoInLastHit and triggerArgs.LastHitUnitTable ~= nil then
				storeInUnit = triggerArgs.LastHitUnitTable
				storeInUnitId = storeInUnit.ObjectId
			end
			if storeInUnit ~= nil and storeInUnit.ObjectId == nil then
				storeInUnit.ObjectId = storeInUnitId
			end
			if weaponData.StoreAmmoOnHit ~= nil and weaponData.StoreAmmoOnHit > 0 and not triggerArgs.IsDeflected then
				if projectileData == nil or ( not projectileData.NeverStore and ( not projectileData.StoreInFirstHit and triggerArgs.FireIndex == 0 ) or ( projectileData.StoreInFirstHit and triggerArgs.LastProjectileDeath )) then
					if projectileData ~= nil and projectileData.StoreInFirstHit then
						storeInUnit = triggerArgs.FirstUnitInVolley
					end
					if storeInUnit ~= nil then
						if not storeInUnit.IsDead and (storeInUnit.CanStoreAmmo and not triggerArgs.InvulnerableImpact) and not ( weaponData.Name == "RangedWeapon" and HeroHasTrait("ShieldLoadAmmoTrait")) then
							if storeInUnit.ObjectId ~= CurrentRun.Hero.ObjectId then
								if SelectedFish == "GemDrop" then
									thread(function (desId)
									local offsetX = 0
									if CoinFlip() then
										offsetX = offsetX * -1
									end
									local offsetY = 0
									if CoinFlip() then
										offsetY = offsetY * -1
									end
								
									local obstacleName = "TartarusRubble02"
									local obstacleId = SpawnObstacle({ Name = obstacleName, DestinationId = desId, OffsetX = offsetX, OffsetY = offsetY, ForceToValidLocation = true, SkipIfBlocked = true, Group = "Standing", })
									AddToGroup({ Id = obstacleId, Name = "DestructibleGeo"})
								
									local obstacleData = ObstacleData[obstacleName] or {}
									local spawnScale = RandomFloat( 0.2, 0.4 )
									SetScale({ Id = obstacleId, Fraction = spawnScale })
								
									if CoinFlip() then
										FlipHorizontal({ Id = obstacleId })
									end
									AdjustZLocation({ Id = obstacleId, Distance = 1000 })
									ApplyUpwardForce({ Id = obstacleId, Speed = -3000 })
									wait(3)
									Destroy({id = obstacleId})
									end, victimId)
								end
							end
						end
					end
				end
			end
		end	
	end
}
OnAnyLoad{"A_PostBoss01", function ()
	if SelectedFish == "GemDrop" then
		AddTraitToHero({TraitName="GemDrop_Trait"})
	elseif SelectedFish == "Fish_Elysium_Legendary_01" then
		ChefResetKeepsakes()
	end
end}
OnAnyLoad{"B_PostBoss01", function ()
	if SelectedFish == "GemDrop" then
		AddTraitToHero({TraitName="GemDrop_Trait"})
	elseif SelectedFish == "Fish_Elysium_Legendary_01" then
		ChefResetKeepsakes()
	end
end}
OnAnyLoad{"C_PostBoss01", function ()
	if SelectedFish == "GemDrop" then
		AddTraitToHero({TraitName="GemDrop_Trait"})
	elseif SelectedFish == "Fish_Elysium_Legendary_01" then
		ChefResetKeepsakes()
	end
end}

ModUtil.BaseOverride("CreateRoom", function( roomData, args )
	if args == nil then
		args = {}
	end

	local room = DeepCopyTable( roomData )
	room.SpawnPoints = {}
	room.SpawnPointsUsed = {}
	room.EliteAttributes = {}
	room.VoiceLinesPlayed = {}
	room.TextLinesRecord = {}
	if args.RoomOverrides ~= nil then
		for key, value in ipairs( args.RoomOverrides ) do
			room[key] = value
		end
	end
	if not args.SkipChooseEncounter then
		room.Encounter = ChooseEncounter( CurrentRun, room )
		RecordEncounter( CurrentRun, room.Encounter )
	end

	if args.RewardStoreName == nil then

		local roomName = room.GenusName or room.Name
		if room.FirstClearRewardStore ~= nil and IsRoomFirstClearOverShrinePointThreshold( GetEquippedWeapon(), CurrentRun, roomName ) then
			args.RewardStoreName  = room.FirstClearRewardStore
		else
			args.RewardStoreName = room.ForcedRewardStore or "RunProgress"
		end
	end
	if not args.SkipChooseReward then
		room.RewardStoreName = args.RewardStoreName
		room.ChosenRewardType = ChooseRoomReward( CurrentRun, room, args.RewardStoreName, args.PreviouslyChosenRewards )
		SetupRoomReward( CurrentRun, room, args.PreviouslyChosenRewards )
	end

	local secretChance = room.SecretSpawnChance or RoomData.BaseRoom.SecretSpawnChance

	for k, mutator in ipairs( GameState.ActiveMutators ) do
		if mutator.SecretSpawnChanceMultiplier ~= nil then
			secretChance = secretChance * mutator.SecretSpawnChanceMultiplier
		end
	end
	if HeroHasTrait("BetterChaosGates_Trait") then
		secretChance = secretChance + 0.5
	end
	room.SecretChanceSuccess =  RandomChance( secretChance )

	local shrinePointDoorChance = room.ShrinePointDoorSpawnChance or RoomData.BaseRoom.ShrinePointDoorSpawnChance
	if HeroHasTrait("BetterShrinePoints_Trait") then
		shrinePointDoorChance = shrinePointDoorChance + 1
		DebugPrint({Text = shrinePointDoorChance})
	end
	room.ShrinePointDoorChanceSuccess =  RandomChance( shrinePointDoorChance )

	local challengeChance = room.ChallengeSpawnChance or RoomData.BaseRoom.ChallengeSpawnChance
	for k, mutator in ipairs( GameState.ActiveMutators ) do
		if mutator.ChallengeSpawnChanceMultiplier ~= nil then
			challengeChance = challengeChance * mutator.ChallengeSpawnChanceMultiplier
		end
	end

	room.ChallengeChanceSuccess = RandomChance( challengeChance )

	local wellShopChance = room.WellShopSpawnChance or RoomData.BaseRoom.WellShopSpawnChance
	for k, mutator in ipairs( GameState.ActiveMutators ) do
		if mutator.ChallengeSpawnChanceMultiplier ~= nil then
			wellShopChance = wellShopChance * mutator.WellShopSpawnChanceMultiplier
		end
	end
	room.WellShopChanceSuccess = RandomChance( wellShopChance )

	local sellTraitShopChance = room.SellTraitShopChance or RoomData.BaseRoom.SellTraitShopChance
	for k, mutator in ipairs( GameState.ActiveMutators ) do
		if mutator.ChallengeSpawnChanceMultiplier ~= nil then
			sellTraitShopChance = sellTraitShopChance * mutator.SellTraitShopChanceMultiplier
		end
	end
	room.SellTraitShopChanceSuccess = RandomChance( sellTraitShopChance )

	local fishingPointChance = room.FishingPointChance or RoomData.BaseRoom.FishingPointChance
	for k, mutator in ipairs( GameState.ActiveMutators ) do
		if mutator.FishingPointChanceMultiplier ~= nil then
			fishingPointChance = fishingPointChance * mutator.FishingPointChanceMultiplier
		end
	end
	room.FishingPointChanceSuccess =  RandomChance( fishingPointChance + GetTotalHeroTraitValue("FishingPointChanceBonus") )
	if CurrentRun.RoomCreations[room.Name] == nil then
		CurrentRun.RoomCreations[room.Name] = 0
	end
	CurrentRun.RoomCreations[room.Name] = CurrentRun.RoomCreations[room.Name] + 1

	return room
end, ChefCuisineMod)

ModUtil.BaseOverride( "HandleSecretSpawns", function( currentRun )

	local currentRoom = currentRun.CurrentRoom

	RandomSynchronize( 13 )

	local secretPointIds = GetIdsByType({ Name = "SecretPoint" })

	-- Secret Door
	if not IsEmpty( secretPointIds ) and IsSecretDoorEligible( currentRun, currentRoom ) then
		currentRoom.ForceSecretDoor = true
		UseHeroTraitsWithValue("ForceSecretDoor", true)
		local secretRoomData = ChooseNextRoomData( currentRun, { RoomDataSet = RoomSetData.Secrets } )
		if secretRoomData ~= nil then
			local secretPointId = RemoveRandomValue( secretPointIds )
			local secretDoor = DeepCopyTable( ObstacleData.SecretDoor )
			secretDoor.ObjectId = SpawnObstacle({ Name = "SecretDoor", Group = "FX_Terrain", DestinationId = secretPointId, AttachedTable = secretDoor })
			SetupObstacle( secretDoor )
			if HeroHasTrait("BetterChaosGates_Trait") then
				secretDoor.HealthCost = 1
			else
				secretDoor.HealthCost = GetSecretDoorCost()
			end
			
			local secretRoom = CreateRoom( secretRoomData )
			AssignRoomToExitDoor( secretDoor, secretRoom )
			secretDoor.OnUsedPresentationFunctionName = "SecretDoorUsedPresentation"
			currentRun.LastSecretDepth = GetRunDepth( currentRun )
		end
	end
	if not IsEmpty( secretPointIds ) and IsShrinePointDoorEligible( currentRun, currentRoom ) then
		currentRoom.ForceShrinePointDoor = true
		local shrinePointRoomOptions = currentRoom.ShrinePointRoomOptions or RoomSetData.Base.BaseRoom.ShrinePointRoomOptions
		local shrinePointRoomName = GetRandomValue(shrinePointRoomOptions)
		local shrinePointRoomData = RoomSetData.Base[shrinePointRoomName]
		if shrinePointRoomData ~= nil then
			local secretPointId = RemoveRandomValue( secretPointIds )
			local shrinePointDoor = DeepCopyTable( ObstacleData.ShrinePointDoor )
			shrinePointDoor.ObjectId = SpawnObstacle({ Name = "ShrinePointDoor", Group = "FX_Terrain", DestinationId = secretPointId, AttachedTable = shrinePointDoor })
			SetupObstacle( shrinePointDoor )
			if HeroHasTrait("BetterShrinePoints_Trait") then
				shrinePointDoor.ShrinePointReq = 1
			else
				shrinePointDoor.ShrinePointReq = currentRoom.ShrinePointDoorCost or ( shrinePointDoor.CostBase + ( shrinePointDoor.CostPerDepth * (currentRun.RunDepthCache - 1) ) )
			end
			local activeShrinePoints = GetTotalSpentShrinePoints()
			local costFontColor = Color.CostAffordable
			if shrinePointDoor.ShrinePointReq > activeShrinePoints then
				costFontColor = Color.CostUnaffordable
			end
			local shrinePointRoom = CreateRoom( shrinePointRoomData, { SkipChooseReward = true } )
			shrinePointRoom.NeedsReward = true
			AssignRoomToExitDoor( shrinePointDoor, shrinePointRoom )
			shrinePointDoor.OnUsedPresentationFunctionName = "ShrinePointDoorUsedPresentation"
			currentRun.LastShrinePointDoorDepth = GetRunDepth( currentRun )
		end
	end

	local challengeBaseIds = GetIdsByType({ Name = "ChallengeSwitchBase" })

	-- Challenge Switch
	if not IsEmpty( challengeBaseIds ) and IsChallengeSwitchEligible( currentRun, TableLength( challengeBaseIds )) then
		local hasForceTrait = HasHeroTraitValue("ForceChallengeSwitch")
		currentRoom.ForceChallengeSwitch = true
		UseHeroTraitsWithValue("ForceChallengeSwitch", true)
		local challengeBaseId = RemoveRandomValue( challengeBaseIds )
		local challengeOptions = {}
		for k, challengeName in ipairs( EncounterSets.ChallengeOptions ) do
			local challengeData = ObstacleData[challengeName]
			if challengeData.Requirements == nil or IsGameStateEligible( CurrentRun, challengeData, challengeData.Requirements ) then
				table.insert( challengeOptions, challengeName )
			end
		end
		if not IsEmpty( challengeOptions ) then
			local challengeType = GetRandomValue( challengeOptions )
			local challengeSwitch = DeepCopyTable( ObstacleData[challengeType] )
			currentRoom.ChallengeSwitch = challengeSwitch
			challengeSwitch.ObjectId = challengeBaseId
			local offsetX = challengeSwitch.TextAnchorIdOffsetX
			if IsHorizontallyFlipped({ Id = challengeSwitch.ObjectId }) then
				offsetX = offsetX * -1
			end
			challengeSwitch.TextAnchorId = SpawnObstacle({ Name = "BlankObstacle", Group = "Standing", DestinationId = challengeBaseId })
			Attach({ Id = challengeSwitch.TextAnchorId, DestinationId = challengeBaseId, OffsetX = offsetX, OffsetY = challengeSwitch.TextAnchorIdOffsetY, OffsetZ = challengeSwitch.TextAnchorIdOffsetZ })
			SetThingProperty({ Property = "SortMode", Value = "FromParent", DestinationId = challengeSwitch.TextAnchorId })

			local challengeEncounter = ChooseChallengeEncounter(currentRoom)
			currentRoom.ChallengeEncounter = challengeEncounter
			challengeEncounter.Switch = challengeSwitch
			challengeEncounter.SpawnNearId = challengeSwitch.ObjectId

			local rewardMultiplier = challengeSwitch.RewardMultiplier or 1
			local startingValue = rewardMultiplier * challengeEncounter.StartingValue * (1 + challengeEncounter.ValueDepthRamp * GetRunDepth(CurrentRun)) * GetTotalHeroTraitValue("ChallengeRewardIncrease", {IsMultiplier = true})
			challengeSwitch.StartingValue = round( startingValue )
			challengeSwitch.ValueTextAnchor = SpawnObstacle({ Name = "BlankObstacle", DestinationId = challengeSwitch.ObjectId })
			Attach({ Id = challengeSwitch.ValueTextAnchor, DestinationId = challengeSwitch.ObjectId })
			CreateTextBox({ Id = challengeSwitch.ValueTextAnchor, Text = challengeSwitch.ChallengeText, LuaKey = "Amount", OffsetX = -40 , OffsetY = -220, LuaValue = startingValue, Font = "FellType", FontSize = 40, Color = Color.White, OutlineThickness = 1, OutlineColor = {0.0, 0.0, 0.0,1}, TextSymbolScale = 0.5, })
			ModifyTextBox({ Id = challengeSwitch.ValueTextAnchor, FadeTarget = 0, FadeDuration = 0 })

			if challengeSwitch.KeyCost == nil and challengeSwitch.KeyCostMin ~= nil and challengeSwitch.KeyCostMax ~= nil then
				challengeSwitch.KeyCost = RandomInt(challengeSwitch.KeyCostMin, challengeSwitch.KeyCostMax)
			end
			SetupObstacle( challengeSwitch )
			SetAnimation({ DestinationId = challengeSwitch.ObjectId, Name = challengeSwitch.LockedAnimationName })
			UseableOn({ Id = challengeSwitch.ObjectId })
			if challengeSwitch.SpawnPropertyChanges ~= nil then
				ApplyUnitPropertyChanges( challengeSwitch, challengeSwitch.SpawnPropertyChanges, true )
			end
			currentRun.LastChallengeDepth = currentRun.RunDepthCache
			challengeBaseId = nil
		end
	end

	-- Well Shop
	if not IsEmpty( challengeBaseIds ) and IsWellShopEligible( currentRun, currentRoom ) then
		currentRoom.ForceWellShop = true
		local challengeBaseId = RemoveRandomValue( challengeBaseIds )
		currentRoom.WellShop = DeepCopyTable( ObstacleData.WellShop )
		currentRoom.WellShop.ObjectId = challengeBaseId
		SetupObstacle( currentRoom.WellShop )
		SetAnimation({ DestinationId = currentRoom.WellShop.ObjectId, Name = "WellShopLocked" })
		UseableOn({ Id = currentRoom.WellShop.ObjectId })
		if currentRoom.WellShop.SpawnPropertyChanges ~= nil then
			ApplyUnitPropertyChanges( currentRoom.WellShop, currentRoom.WellShop.SpawnPropertyChanges, true )
		end
		currentRun.LastWellShopDepth = currentRun.RunDepthCache
		challengeBaseId = nil
	end

	-- Sell Trait Shop
	if not IsEmpty( challengeBaseIds ) and IsSellTraitShopEligible( currentRun, currentRoom ) then
		currentRoom.ForceSellTraitShop = true
		local challengeBaseId = RemoveRandomValue( challengeBaseIds )
		currentRoom.SellTraitShop = DeepCopyTable( ObstacleData.SellTraitShop )
		currentRoom.SellTraitShop.ObjectId = challengeBaseId
		SetupObstacle( currentRoom.SellTraitShop)
		SetAnimation({ DestinationId = currentRoom.SellTraitShop.ObjectId, Name = "SellTraitShopLocked" })
		UseableOn({ Id = currentRoom.SellTraitShop.ObjectId })
		if currentRoom.SellTraitShop.SpawnPropertyChanges ~= nil then
			ApplyUnitPropertyChanges( currentRoom.SellTraitShop, currentRoom.SellTraitShop.SpawnPropertyChanges, true )
		end
		currentRun.LastSellTraitShopDepth = currentRun.RunDepthCache
		challengeBaseId = nil
		GenerateSellTraitShop( currentRun, currentRoom )
	end

	-- Fishing
	local fishingPoints = GetInactiveIdsByType({ Name = "FishingPoint" })
	if not IsEmpty( fishingPoints ) and IsFishingEligible( currentRun, currentRoom ) then
		currentRoom.ForceFishing = true
		UseHeroTraitsWithValue("ForceFishingPoint", true)
		CurrentRun.CurrentRoom.FishingPointId = GetRandomValue(fishingPoints)
		Activate({ Id = CurrentRun.CurrentRoom.FishingPointId })
		currentRun.LastFishingPointDepth = GetRunDepth( currentRun )
	end

end, ChefCuisineMod)

ModUtil.WrapBaseFunction("ChooseLoot", function ( baseFunc, newLootName, excludeLootNames, forceLootName )
	local returnValue = baseFunc(newLootName, excludeLootNames, forceLootName)
	local newlootData = LootData[newLootName]
	if CurrentRun.CurrentRoom ~= nil then
		local rewardType = CurrentRun.CurrentRoom.ChangeReward or  CurrentRun.CurrentRoom.ChosenRewardType
		for k, trait in ipairs( CurrentRun.Hero.Traits ) do
			if trait.ChefGodToForce ~= nil and rewardType ~= "Devotion" and rewardType ~= "TrialUpgrade" then
				if RandomChance(0.25) then
					newlootData = LootData[trait.ChefGodToForce]
				end
			end
		end
	end
	return returnValue

end, ChefCuisineMod)

function ChefChangeJanBoon()
	local janTraitData = GetProcessedTraitData({ Unit = CurrentRun.Hero, TraitName = "Fish_Chaos_Legendary_01_Trait", Rarity = "Legendary" })

	janTraitData.CurrentRoom = janTraitData.CurrentRoom + 1
	if janTraitData.CurrentRoom < janTraitData.RoomsPerUpgrade then
		return
	else
		janTraitData.CurrentRoom = 0
	end
	local numOldTrait = GetTraitNameCount( CurrentRun.Hero, currentJanTrait )

	RemoveTrait( CurrentRun.Hero, currentJanTrait )
	
	local n = #ChefJanTraitData
	local currentTrait = ChefJanTraitData[RandomInt(1,n)]
	DebugPrint({Text = currentTrait.Name or "Nil"})
	local processedData = GetProcessedTraitData({ Unit = CurrentRun.Hero, TraitName = currentTrait.Name, Rarity ="Common" }) 
	AddTraitToHero({ TraitData = processedData })
	currentJanTrait = processedData.Name
	for i=1, numOldTrait-1 do
		AddTraitToHero({ TraitName = currentTrait.Name })
	end
end
ModUtil.WrapBaseFunction("EndEncounterEffects", function(baseFunc, currentRun, currentRoom, currentEncounter)
	local returnValue = baseFunc(currentRun, currentRoom, currentEncounter)
	if SelectedFish == "Fish_Chaos_Legendary_01" then
		ChefChangeJanBoon()
	end
	return returnValue
end, ChefCuisineMod)

function ChefRetaliateBuffSetup()
	thread(function()
		local mult = 1.5
	for k,v in ipairs({"Aphrodite","Demeter","Athena"}) do
		local curValue = TraitData[v.. "RetaliateTrait"].PropertyChanges[1].BaseMin
		TraitData[v.. "RetaliateTrait"].PropertyChanges[1].BaseMin = curValue * mult
		TraitData[v.. "RetaliateTrait"].PropertyChanges[1].BaseMax = curValue * mult
	end
	local curValue = TraitData["RetaliateWeaponTrait"].PropertyChanges[1].BaseMin
	TraitData["RetaliateWeaponTrait"].PropertyChanges[1].BaseMin = curValue * mult
	TraitData["RetaliateWeaponTrait"].PropertyChanges[1].BaseMax = curValue * mult
	curValue = TraitData["AresRetaliateTrait"].PropertyChanges[2].BaseMin
	TraitData["AresRetaliateTrait"].PropertyChanges[2].BaseMin = curValue * mult
	TraitData["AresRetaliateTrait"].PropertyChanges[2].BaseMax = curValue * mult
	end)
end
function ChefRetaliateBufRevert()
	thread(function()
	TraitData["AthenaRetaliateTrait"].PropertyChanges[1].BaseMin = 30
	TraitData["AthenaRetaliateTrait"].PropertyChanges[1].BaseMax = 30

	TraitData["RetaliateWeaponTrait"].PropertyChanges[1].BaseMin = 80
	TraitData["RetaliateWeaponTrait"].PropertyChanges[1].BaseMax = 80

	TraitData["AphroditeRetaliateTrait"].PropertyChanges[1].BaseMin = 50
	TraitData["AphroditeRetaliateTrait"].PropertyChanges[1].BaseMax = 50

	TraitData["AresRetaliateTrait"].PropertyChanges[2].BaseMin = 100
	TraitData["AresRetaliateTrait"].PropertyChanges[2].BaseMax = 100

	TraitData["DemeterRetaliateTrait"].PropertyChanges[1].BaseMin = 10
	TraitData["DemeterRetaliateTrait"].PropertyChanges[1].BaseMax = 10
	end)
end

ModUtil.WrapBaseFunction( "CreateBoonLootButtons", function( baseFunc, lootData, reroll)
	local components = ScreenAnchors.ChoiceScreen.Components
	if SelectedFish == "Fish_Surface_Legendary_01" and lootData.GodLoot then
		components["SelectorConsumeButton"] = 
		CreateScreenComponent({ 
			Name = "BoonSlot1", 
			Group = "Combat_UI_World", 
			Scale = 0.3, 
			X = 1700,
			Y = 550
		})
		components["SelectorConsumeButton"].OnPressedFunctionName = "ChefConsumeBoon"
		CreateTextBox({ Id = components["SelectorConsumeButton"].Id, Text = "Consume the Boon",
		FontSize = 22, OffsetX = 0, OffsetY = 0, Width = 720, Color = {1,1,1,1}, Font = "AlegreyaSansSCLight",
		ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2}, Justification = "Center"
		})
	end
	local returnValue = baseFunc( lootData, reroll)
	return returnValue
end, ChefCuisineMod)

function ChefConsumeBoon(screen, button)
	thread(CloseUpgradeChoiceScreen, screen, button )
	AddTraitToHero({ TraitData = GetProcessedTraitData({ Unit = CurrentRun.Hero, TraitName = "Fish_Surface_Legendary_01_Trait", Rarity = "Legendary" }) })
	ChaosBassStop()
	CurrentRun.CurrentRoom.ReplacedTraitSource = nil
	wait( 0.2 )
	UnlockRoomExits( CurrentRun, CurrentRun.CurrentRoom )
end

ModUtil.WrapBaseFunction("CheckAmmoDrop", function ( baseFunc, currentRun, targetId, ammoDropData, numDrops )
	if SelectedFish == "Fish_Asphodel_Common_01" then
		for k,traitData in ipairs(CurrentRun.Hero.Traits) do
			if traitData.Name == "Fish_Asphodel_Common_01_Trait" then
				traitData.PropertyChanges[1].ChangeValue = traitData.PropertyChanges[1].ChangeValue -1 
			end
		end
		return
	else
		return baseFunc(currentRun, targetId, ammoDropData, numDrops)
	end
end, ChefCuisineMod)

local baseKeepsakeValues = {}

function ChefBuffKeepsakes(args)
	local keepsakeNames = {
	"MaxHealthKeepsakeTrait", -- cerberus
	"DirectionalArmorTrait", -- achilles
	"BackstabAlphaStrikeTrait", -- nyx
	"PerfectClearDamageBonusTrait", -- thanatos
	"ShopDurationTrait", -- charon
	"BonusMoneyTrait", -- hypnos
	"LowHealthDamageTrait", -- megaera
	"DistanceDamageTrait", -- orpheus
	"LifeOnUrnTrait", -- dusa
	"ReincarnationTrait", -- skelly
	"ForceZeusBoonTrait", -- zeus
	"ForcePoseidonBoonTrait", -- poseidon
	"ForceAthenaBoonTrait", -- athena
	"ForceAphroditeBoonTrait", -- aphrodite
	"ForceAresBoonTrait", -- ares
	"ForceArtemisBoonTrait", -- artemis
	"ForceDionysusBoonTrait", -- dionysus
	"FastClearDodgeBonusTrait", -- hermes
	"ForceDemeterBoonTrait", -- demeter
	"ChaosBoonTrait", -- primordial chaos
	"VanillaTrait", -- sisyphus
	"ShieldBossTrait", -- eurydice
	"ShieldAfterHitTrait", -- patroclus
	"ChamberStackTrait", -- persephone
	"HadesShoutKeepsake", -- hades
	}
	for k,v in ipairs(keepsakeNames) do
		if baseKeepsakeValues == nil or baseKeepsakeValues[v] == nil then
			baseKeepsakeValues[v] = TraitData[v]
			for i, PropertyChangeData in ipairs(TraitData[v].RarityLevels) do
				PropertyChangeData.Multiplier = PropertyChangeData.Multiplier * 2 
			end
		end
	end
end

function ChefResetKeepsakes(args)
	local keepsakeNames = {
		"MaxHealthKeepsakeTrait", -- cerberus
		"DirectionalArmorTrait", -- achilles
		"BackstabAlphaStrikeTrait", -- nyx
		"PerfectClearDamageBonusTrait", -- thanatos
		"ShopDurationTrait", -- charon
		"BonusMoneyTrait", -- hypnos
		"LowHealthDamageTrait", -- megaera
		"DistanceDamageTrait", -- orpheus
		"LifeOnUrnTrait", -- dusa
		"ReincarnationTrait", -- skelly
		"ForceZeusBoonTrait", -- zeus
		"ForcePoseidonBoonTrait", -- poseidon
		"ForceAthenaBoonTrait", -- athena
		"ForceAphroditeBoonTrait", -- aphrodite
		"ForceAresBoonTrait", -- ares
		"ForceArtemisBoonTrait", -- artemis
		"ForceDionysusBoonTrait", -- dionysus
		"FastClearDodgeBonusTrait", -- hermes
		"ForceDemeterBoonTrait", -- demeter
		"ChaosBoonTrait", -- primordial chaos
		"VanillaTrait", -- sisyphus
		"ShieldBossTrait", -- eurydice
		"ShieldAfterHitTrait", -- patroclus
		"ChamberStackTrait", -- persephone
		"HadesShoutKeepsake", -- hades
		}
		for k,v in ipairs(keepsakeNames) do
			if baseKeepsakeValues[v] ~= nil then
				baseKeepsakeValues[v] = nil
				for i, PropertyChangeData in ipairs(TraitData[v].RarityLevels) do
					PropertyChangeData.Multiplier = PropertyChangeData.Multiplier / 2
				end
			end
		end
end

ModUtil.WrapBaseFunction("EquipKeepsake", function(baseFunc, heroUnit, traitName, args)
	local returnValue = baseFunc(heroUnit, traitName, args)
	if SelectedFish == "Fish_Elysium_Legendary_01" then
		ChefBuffKeepsakes()
	end
	return returnValue
end, ChefCuisineMod)

if _G["GetExpMultiplier"] then
	DebugPrint({Text = "Chef Mod able to interact with Mastery_PonyWarrior"})
	ModUtil.WrapBaseFunction("Kill", function(baseFunc, victim, triggerArgs)
		local returnValue = baseFunc(victim, triggerArgs)
		if SelectedFish == "BetterWeaponMastery" then
			local multiplier = GetTotalSpentShrinePoints() + 1
			tempExp = tempExp + (1 * multiplier * 0.5)
		end
		return returnValue
	end, ChefCuisineMod)
end