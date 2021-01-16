ModUtil.BaseOverride("FishingEndPresentation", function(fishingAnimationPointId)
	CreateAnimation({ Name = "FishingSplashB", DestinationId = fishingAnimationPointId })
	SetAlpha({ Id = fishingAnimationPointId, Fraction = 0, Duration = 0 })

	CurrentRun.Hero.FishingInput = true
	killTaggedThreads( "Fishing")
	local fishingState = CurrentRun.Hero.FishingState
	local fishName = nil
	local biomeName = CurrentRun.CurrentRoom.FishBiome or CurrentRun.CurrentRoom.RoomSetName or "None"
	fishName = GetFish( biomeName, fishingState )

    if HeroHasTrait( "Fish_Surface_Common_01_Trait" ) then
        -- ~25% chance
        if RandomChance(GetTotalHeroTraitValue("HigherFishLootChance")) then 
            -- shift rarity
			DebugPrint({Text=fishName})
            fishName = fishName:gsub("Rare", "Legendary"):gsub("Common", "Rare")
			DebugPrint({Text=fishName})
        end
    end
		local fishData = FishingData.FishValues[fishName]
	if fishName then
		thread( MarkObjectiveComplete, "Fishing" )
		thread( PlayVoiceLines, fishData.FishCaughtVoiceLines )

		--Shake({ Id = CurrentRun.Hero.ObjectId, Distance = 2, Speed = 200, Duration = 0.35 })
		PlaySound({ Name = "/SFX/CriticalHit" })
		PlaySound({ Name = "/VO/ZagreusEmotes/EmotePowerAttacking_Sword" })
		thread( DoRumble, { { ScreenPreWait = 0.04, RightFraction = 0.28, Duration = 0.4 }, } )
		wait(0.1)
		PlaySound({ Name = "/SFX/Player Sounds/ZagreusWhooshDropIn" })
		wait(0.2)
		--Shake({ Id = CurrentRun.Hero.ObjectId, Distance = 2, Speed = 200, Duration = 0.35 })
		PlaySound({ Name = "/SFX/Enemy Sounds/Megaera/MegDeathSplash", Id = fishingAnimationPointId })
		PlaySound({ Name = "/VO/ZagreusEmotes/EmoteRanged" })
		SetAnimation({ Name = "ZagreusInteractionFishing_PullSuccess", DestinationId = CurrentRun.Hero.ObjectId })
		thread( DoRumble, { { ScreenPreWait = 0.7, LeftFraction = 0.35, Duration = 0.4 }, } )

		RecordFish(fishName)

		PlaySound({ Name = "/Leftovers/SFX/VictoryScreenUpdateSFX", Delay = 1 })

		local fishingText = "Fishing_SuccessGoodTitle"
		if fishingState == "Perfect" then
			fishingText = "Fishing_SuccessPerfectTitle"
		end

		thread( PlayVoiceLines, fishData.FishIdentifiedVoiceLines )

		DisplayUnlockText({
			Icon = fishName,
			TitleText = fishingText,
			SubtitleText = "Fishing_SuccessSubtitle",
			SubtitleData = { LuaKey = "TempTextData", LuaValue = { Name = fishName }},
			IconOffsetY = 20,
			HighlightIcon = true,
			IconMoveSpeed = 0.1,
			IconScale = 0.64,
			AdditionalAnimation = "FishCatchPresentationSparkles",
			IconBacking = "FishCatchIconBacking",
			AnimationName = "LocationTextBGFish",
			AnimationOutName = "LocationTextBGFishOut",
		})

		CheckCodexUnlock( "Fish", fishName )

	else
		thread( MarkObjectiveFailed, "Fishing" )
		--Shake({ Id = CurrentRun.Hero.ObjectId, Distance = 2, Speed = 200, Duration = 0.35 })
		SetAnimation({ Name = "ZagreusInteractionFishing_PullFailure", DestinationId = CurrentRun.Hero.ObjectId })
		PlaySound({ Name = "/Leftovers/SFX/BigSplashRing", Delay = 0.3 })
		PlaySound({ Name = "/SFX/CrappyRewardDrop", Delay = 0.5 })

		PlaySound({ Name = "/Leftovers/SFX/ImpCrowdLaugh" })
		thread( DoRumble, { { ScreenPreWait = 0.02, RightFraction = 0.17, Duration = 0.7 }, } )

		if CurrentRun.Hero.FishingState == "TooEarly" then
			thread( PlayVoiceLines, HeroVoiceLines.FishNotCaughtVoiceLines, true )

			thread( DisplayUnlockText, {
			TitleText = "Fishing_FailedTitle",
			SubtitleText = "Fishing_FailedEarly",
			})

		else
			if CurrentRun.Hero.FishingState == "TooLate" then
				thread( PlayVoiceLines, HeroVoiceLines.FishNotCaughtVoiceLines, true )
			elseif CurrentRun.Hero.FishingState == "WayLate" then
				thread( PlayVoiceLines, HeroVoiceLines.FishNotCaughtTooLateVoiceLines, true )
			end

			thread( DisplayUnlockText, {
			TitleText = "Fishing_FailedTitle",
			SubtitleText = "Fishing_FailedLate",
			})
		end
		wait( 2 )
	end
	CurrentRun.CurrentRoom.CompletedFishing = true
	CurrentRun.Hero.FishingStarted = false
	RemoveTimerBlock( CurrentRun, "Fishing" )
	UnfreezePlayerUnit("Fishing")
	UnblockCombatUI("Fishing")

	if CurrentRun.CurrentRoom.ZoomFraction ~= nil then
		AdjustZoom({ Fraction = CurrentRun.CurrentRoom.ZoomFraction, LerpTime = 1.5 })
	else
		AdjustZoom({ Fraction = 1.0, LerpTime = 1.5 })
	end
end, ChefCuisineMod)

