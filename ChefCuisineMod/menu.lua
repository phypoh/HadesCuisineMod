local SelectableMeals = {}
ThisRunFish = {}
hasBeenUsed = false
SelectedFish = nil

OnAnyLoad{ "DeathArea",
function( triggerArgs )

		DeathLoopData["DeathArea"]["ObstacleData"][423399]["OnUsedFunctionName"] = "ShowCuisineScreen"
		DeathLoopData["DeathArea"]["ObstacleData"][423399]["SetupFunctions"] =
		{
			{
			Name = "PlayStatusAnimation",
			Args = { Animation = "StatusIconWantsToTalk", },
			GameStateRequirements =
			{
				RequiredFalseFlags = { "InFlashback", },
			},
			},
		}
		if hasBeenUsed then
		DeathLoopData["DeathArea"]["ObstacleData"][423399]["SetupGameStateRequirements"] ={
			AreIdsNotAlive = {40000}
		}
		else
		SelectableMeals = {
				--Tartarus
			"Fish_Tartarus_Common_01",
			"Fish_Tartarus_Rare_01",
			"Fish_Tartarus_Legendary_01",
				--Asphodel
			"Fish_Asphodel_Common_01",
			"Fish_Asphodel_Rare_01",
			"Fish_Asphodel_Legendary_01",
				--Elysium
			"Fish_Elysium_Common_01",
			"Fish_Elysium_Rare_01",
			"Fish_Elysium_Legendary_01",
				--Styx
			"Fish_Styx_Common_01",
			"Fish_Styx_Rare_01",
			"Fish_Styx_Legendary_01",
				--Surface
			"Fish_Surface_Common_01",
			"Fish_Surface_Rare_01",
			"Fish_Surface_Legendary_01",
				--Chaos
			"Fish_Chaos_Common_01",
			"Fish_Chaos_Rare_01",
			"Fish_Chaos_Legendary_01",
				--Other
			"StackUpgrade",			
			"RoomRewardHealDrop",
			"GemDrop",
		}
		ThisRunFish = {}
		for i = 1, 3 do
		table.insert(ThisRunFish, RemoveRandomValue(SelectableMeals))
		end
		SelectedFish = nil
		DeathLoopData["DeathArea"]["ObstacleData"][423399]["SetupGameStateRequirements"] ={
		}
		CurrentlySelectedMealFish = {}
		end
	end
}
function ShowCuisineScreen(usee)
	local screen = { Components = {} }
	screen.Name = "Cuisine"

	if IsScreenOpen( screen.Name ) then
		return
	end
OnScreenOpened({ Flag = screen.Name, PersistCombatUI = true })
	FreezePlayerUnit()
	EnableShopGamepadCursor()
	SetConfigOption({ Name = "FreeFormSelectWrapY", Value = false })
	SetConfigOption({ Name = "FreeFormSelectStepDistance", Value = 8 })
	SetConfigOption({ Name = "FreeFormSelectSuccessDistanceStep", Value = 8 })
	SetConfigOption({ Name = "FreeFormSelectRepeatDelay", Value = 0.6 })
	SetConfigOption({ Name = "FreeFormSelectRepeatInterval", Value = 0.1 })
	SetConfigOption({ Name = "FreeFormSelecSearchFromId", Value = 0 })

	PlaySound({ Name = "/SFX/Menu Sounds/ContractorMenuOpen" })
	local components = screen.Components
	
	components.ShopBackgroundDim2 = CreateScreenComponent({ Name = "rectangle01", Group = "Combat_UI_World" })
	components.ShopBackground = CreateScreenComponent({ Name = "WellShopBackground", Group = "Combat_UI_World" })
	components.ShopBackgroundDim = CreateScreenComponent({ Name = "rectangle01", Group = "Combat_UI_World" })
	
	components.CloseButton = CreateScreenComponent({ Name = "ButtonClose", Group = "Combat_UI_Backing", Scale = 0.7 })
	Attach({ Id = components.CloseButton.Id, DestinationId = components.ShopBackground.Id, OffsetX = 0, OffsetY = 440 })
	components.CloseButton.OnPressedFunctionName = "CloseCuisineScreen"
	components.CloseButton.ControlHotkey = "Cancel"
	
	SetAlpha({ Id = components.ShopBackground.Id, Fraction = 1, Duration = 0 })
	SetScale({ Id = components.ShopBackgroundDim.Id, Fraction = 4 })
	SetColor({ Id = components.ShopBackgroundDim.Id, Color = {1, 1, 0, 0} })
	
	components.fishingTurnInButton = 
		CreateScreenComponent({ 
			Name = "BoonSlot1", 
			Group = "Combat_UI_World", 
			Scale = 0.3, 
		})
	components.fishingTurnInButton.usee = usee
	components.fishingTurnInButton.OnPressedFunctionName = "CuisineTurnInFish"
	components.fishingTurnInButton.X = 0
	components.fishingTurnInButton.Y = 0
	Attach({ Id = components.fishingTurnInButton.Id, DestinationId = components.ShopBackground.Id, OffsetX = 600, OffsetY = 0 })
	CreateTextBox(MergeTables({ Id = components.fishingTurnInButton.Id, Text = "ChefCuisineModTurnInFish",
		FontSize = 22, OffsetX = 0, OffsetY = 0, Width = 720, Color = color, Font = "AlegreyaSansSCLight",
		ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2}, Justification = "Center"
	}, LocalizationData.SellTraitScripts.ShopButton))
	
	components.recipeScreenButton = 
	CreateScreenComponent({ 
		Name = "BoonSlot1", 
		Group = "Combat_UI_World", 
		Scale = 0.3, 
	})
	components.recipeScreenButton.usee = usee
	components.recipeScreenButton.OnPressedFunctionName = "CuisineOpenRecipeMenu"
	components.recipeScreenButton.oldScreen = screen
	components.recipeScreenButton.X = 0
	components.recipeScreenButton.Y = 0
	Attach({ Id = components.recipeScreenButton.Id, DestinationId = components.ShopBackground.Id, OffsetX = -600, OffsetY = 0 })
	CreateTextBox(MergeTables({ Id = components.recipeScreenButton.Id, Text = "ChefCuisineModOpenCustomMealText",
	FontSize = 22, OffsetX = 0, OffsetY = 0, Width = 720, Color = color, Font = "AlegreyaSansSCLight",
	ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2}, Justification = "Center"
	}, LocalizationData.SellTraitScripts.ShopButton))
	wait(0.25)

	-- Title
	CreateTextBox(MergeTables({ Id = components.ShopBackground.Id, Text = "ChefCuisineModMainMenuTitle", FontSize = 32, OffsetX = 0, OffsetY = -445, Color = Color.White, Font = "SpectralSCLightTitling", ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 3}, Justification = "Center" }, LocalizationData.SellTraitScripts.ShopButton))
	local flavorTextOptions = { "ChefCuisineModMainMenuFlavorText1", "ChefCuisineModMainMenuFlavorText2", "ChefCuisineModMainMenuFlavorText3", "ChefCuisineModMainMenuFlavorText4"}
	local flavorText = GetRandomValue( flavorTextOptions )
	CreateTextBox(MergeTables({ Id = components.ShopBackground.Id, Text = flavorText,FontSize = 14, OffsetX = 0, OffsetY = 380, Width = 840, Color = Color.Gray, Font = "AlegreyaSansSCBold", ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2}, Justification = "Center" }, LocalizationData.SellTraitScripts.ShopButton))

	-- Flavor Text

	CreateTextBox(MergeTables({ Id = components.ShopBackground.Id, Text = "ChefCuisineModMainMenuSubheader",
			FontSize = 16,
			OffsetY = -385, Width = 840,
			Color = {0.698, 0.702, 0.514, 1.0},
			Font = "AlegreyaSansSCRegular",
			ShadowBlur = 0, ShadowColor = {0,0,0,0}, ShadowOffset={0, 3},
			Justification = "Center",
		}, LocalizationData.SellTraitScripts.ShopButton))
	CreateCuisineButtons(screen, usee)
		
	screen.KeepOpen = true
	thread( HandleWASDInput, screen )
	HandleScreenInput( screen )

end
function CloseCuisineScreen( screen, button )
	DisableShopGamepadCursor()
	SetConfigOption({ Name = "FreeFormSelectStepDistance", Value = 16 })
	SetConfigOption({ Name = "FreeFormSelectSuccessDistanceStep", Value = 8 })
	SetConfigOption({ Name = "FreeFormSelectRepeatDelay", Value = 0.0 })

	PlaySound({ Name = "/SFX/Menu Sounds/ContractorMenuClose" })
	CloseScreen( GetAllIds( screen.Components ) )

	UnfreezePlayerUnit()
	screen.KeepOpen = false
	OnScreenClosed({ Flag = screen.Name })

end

function CreateCuisineButtons(screen, usee)
	
	local itemLocationStartY = 340
	local itemLocationYSpacer = 220
	local itemLocationMaxY = itemLocationStartY + 4 * itemLocationYSpacer

	local itemLocationStartX = 1920/2
	local itemLocationXSpacer = 820
	local itemLocationMaxX = itemLocationStartX + 1 * itemLocationXSpacer

	local itemLocationTextBoxOffset = 380

	local itemLocationX = itemLocationStartX
	local itemLocationY = itemLocationStartY

	local components = screen.Components

	local numButtons = 3
	if numButtons == nil then
		numButtons = 0
		for i, groupData in pairs( StoreData.WorldShop.GroupsOf ) do
			numButtons = numButtons + groupData.Offers
		end
	end

	
	local firstUseable = false
	for itemIndex = 1, numButtons do
		local curFish = ThisRunFish[itemIndex]
		local purchaseButtonKey = "PurchaseButton"..itemIndex
		components[purchaseButtonKey] = CreateScreenComponent({ Name = "MarketSlot", Group = "Combat_Menu", Scale = 1, X = itemLocationX, Y = itemLocationY })
		SetInteractProperty({ DestinationId = components[purchaseButtonKey].Id, Property = "TooltipOffsetX", Value = 665 })
		
		SetScaleY({ Id = components[purchaseButtonKey].Id , Fraction = 2 })
		SetScaleX({ Id = components[purchaseButtonKey].Id , Fraction = 1.05 })
		components[purchaseButtonKey].usee = usee
		components[purchaseButtonKey].Boon = curFish
		components[purchaseButtonKey].OnPressedFunctionName = "GiveFishBoon"
			
		local iconKey = "Icon"..itemIndex
		components[iconKey] = CreateScreenComponent({ Name = "BlankObstacle", X = itemLocationX, Y = itemLocationY, Group = "Combat_Menu" })

		local itemBackingKey = "Backing"..itemIndex
		components[itemBackingKey] = CreateScreenComponent({ Name = "BlankObstacle", Group = "Combat_Menu", X = itemLocationX, Y = itemLocationY })

		local purchaseButtonTitleKey = "PurchaseButtonTitle"..itemIndex
		components[purchaseButtonTitleKey] = CreateScreenComponent({ Name = "BlankObstacle", Group = "Combat_Menu", Scale = 1, X = itemLocationX, Y = itemLocationY })
				CreateTextBoxWithFormat(MergeTables({
					Id = curFish .. "_Trait",
					OffsetX = -260,
					OffsetY = 0,
					Width = 665,
					Justification = "Left",
					VerticalJustification = "Top",
					LineSpacingBottom = 8,
					UseDescription = true,
					Format = "BaseFormat",
					VariableAutoFormat = "BoldFormatGraft",
					TextSymbolScale = 0.8,
				},LocalizationData.SellTraitScripts.ShopButton ))

		CreateTextBox(MergeTables({ Id = components[itemBackingKey].Id, Text = curFish .. "_Trait",
			FontSize = 25,
			OffsetX = -275, OffsetY = -50,
			Width = 720,
			Color = {0.988, 0.792, 0.247, 1},
			Font = "AlegreyaSansSCBold",
			ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2},
			Justification = "Left",
		},LocalizationData.SellTraitScripts.ShopButton))

		
		components[purchaseButtonTitleKey .. "Icon"] = CreateScreenComponent({ Name = "BlankObstacle", Group = "Combat_Menu", Scale = 1 })
		if curFish == "StackUpgrade" then
		SetAnimation({ Name = "Tilesets\\Gameplay\\Gameplay_StackUpgrade_01", DestinationId = components[purchaseButtonTitleKey .. "Icon"].Id, Scale = 0.7 })
		elseif curFish == "RoomRewardHealDrop" then
		SetAnimation({ Name = "Tilesets\\Gameplay\\Gameplay_HealthItem_02", DestinationId = components[purchaseButtonTitleKey .. "Icon"].Id, Scale = 0.7 })
		elseif curFish == "GemDrop" then
		SetAnimation({ Name = "Tilesets\\Gameplay\\Gameplay_Gemstones_01", DestinationId = components[purchaseButtonTitleKey .. "Icon"].Id, Scale = 0.7 })
		else
		SetAnimation({ Name = curFish, DestinationId = components[purchaseButtonTitleKey .. "Icon"].Id, Scale = 0.2 })
		end
		Attach({ Id = components[purchaseButtonTitleKey .. "Icon"].Id, DestinationId = components[purchaseButtonTitleKey].Id, OffsetX = -375, OffsetY = 0})
		
		components[purchaseButtonKey.."Frame"] = CreateScreenComponent({ Name = "BoonInfoTraitFrame", Group = "Combat_Menu_TraitTray", X = itemLocationX - 375, Y = itemLocationY, Scale = 0.8 })
		SetScale({ Id = components[purchaseButtonKey.."Frame"].Id, Fraction = 0.85 })
				CreateTextBoxWithFormat(MergeTables({ Id = components[purchaseButtonKey].Id, Text = curFish .. "_Trait",
					FontSize = 20,
					OffsetX = -275, OffsetY = -25,
					Width = 720,
					Color = Color.White,
					Justification = "Left",
					VerticalJustification = "Top",
					UseDescription = true,
					Format = "MarketScreenDescriptionFormat",
				}, LocalizationData.SellTraitScripts.ShopButton))
		itemLocationX = itemLocationX + itemLocationXSpacer
		if itemLocationX >= itemLocationMaxX then
			itemLocationX = itemLocationStartX
			itemLocationY = itemLocationY + itemLocationYSpacer
			local increment = 0

		end
	end
end
function GiveFishBoon(screen, button)
	SelectedFish = button.Boon
	hasBeenUsed = true
	AddTraitToHero({ TraitData = GetProcessedTraitData({ Unit = CurrentRun.Hero, TraitName = button.Boon .."_Trait", Rarity = "Legendary" }) })
	local partner = button.usee
	partner.NextInteractLines = nil
	StopStatusAnimation( partner, StatusAnimations.WantsToTalk )
	RefreshUseButton( partner.ObjectId, partner )
	UseableOff({ Id = partner.ObjectId })
	CuisineTurnInFish(screen, button)
end
function CuisineTurnInFish( screen, button )
	local usee = button.usee
	
	CloseCuisineScreen(screen,button)
	wait(0.16)
	
	if not GameState.CaughtFish then
		return
	end

	FreezePlayerUnit( "Fishing" )
	thread( MarkObjectiveComplete, "FishPrompt" )

	PlayInteractAnimation( usee.ObjectId )

	StopStatusAnimation( usee )

	thread( PlayVoiceLines, HeroVoiceLines.FishTransactionStartVoiceLines, true )
	SetAnimation({ DestinationId = usee.ObjectId, Name = "ChefGhostChopOnion2_Start" })

	local earnedResources = {}
	local offsetY = 0
	for fishName, fishNum in pairs( GameState.CaughtFish ) do
		if fishNum > 1 then
			thread( InCombatTextArgs, { TargetId= CurrentRun.Hero.ObjectId, Text = "Fishing_TurnIn_Plural", SkipRise = false, SkipFlash = false, Duration = 1.5, OffsetY = offsetY, LuaKey = "TempTextData", LuaValue = { Name = fishName, Amount = fishNum }})
		else
			thread( InCombatTextArgs, { TargetId= CurrentRun.Hero.ObjectId, Text = "Fishing_TurnIn", SkipRise = false, SkipFlash = false, Duration = 1.5, OffsetY = offsetY, LuaKey = "TempTextData", LuaValue = { Name = fishName, Amount = fishNum }})
		end
		offsetY = offsetY - 60
		PlaySound({ Name = "/Leftovers/SFX/BallLandWet" })
		wait(0.75)
		for i = 1, fishNum do
			local ChefFishPositionTable = FishingData.FishValues[fishName]
			if ChefFishPositionTable and ChefFishPositionTable.Award then
				local reward = GetRandomValue( ChefFishPositionTable.Award )
				for resourceName, resourceAmount in pairs( reward ) do
					IncrementTableValue( earnedResources, resourceName, resourceAmount )
				end
			end
		end
	end
	wait(0.75)
	for resourceName, resourceAmount in pairs( earnedResources ) do
		AddResource( resourceName, resourceAmount, "Fishing" )
		PlaySound({ Name = "/SFX/Menu Sounds/SellTraitShopConfirm" })
		wait(0.75)
	end

	thread( PlayVoiceLines, HeroVoiceLines.FishTransactionEndVoiceLines, true )

	GameState.CaughtFish = {}
	UnfreezePlayerUnit("Fishing")
end
function CuisineOpenRecipeMenu(screen, button)
	CloseCuisineScreen(screen, button)
	local screen = { Components = {} }
	screen.Name = "Recipe"

	if IsScreenOpen( screen.Name ) then
		return
	end
OnScreenOpened({ Flag = screen.Name, PersistCombatUI = true })
	FreezePlayerUnit()
	EnableShopGamepadCursor()
	SetConfigOption({ Name = "FreeFormSelectWrapY", Value = false })
	SetConfigOption({ Name = "FreeFormSelectStepDistance", Value = 8 })
	SetConfigOption({ Name = "FreeFormSelectSuccessDistanceStep", Value = 8 })
	SetConfigOption({ Name = "FreeFormSelectRepeatDelay", Value = 0.6 })
	SetConfigOption({ Name = "FreeFormSelectRepeatInterval", Value = 0.1 })
	SetConfigOption({ Name = "FreeFormSelecSearchFromId", Value = 0 })

	PlaySound({ Name = "/SFX/Menu Sounds/ContractorMenuOpen" })
	local components = screen.Components
	
	components.ShopBackground = CreateScreenComponent({ Name = "SellShopBackground", Group = "Combat_UI_World"})
	components.ShopBackgroundDim = CreateScreenComponent({ Name = "rectangle01", Group = "Combat_UI_World" })
	
	components.CloseButton = CreateScreenComponent({ Name = "ButtonClose", Group = "Combat_UI_Backing", Scale = 0.7 })
	Attach({ Id = components.CloseButton.Id, DestinationId = components.ShopBackground.Id, OffsetX = 0, OffsetY = 440 })
	components.CloseButton.OnPressedFunctionName = "CloseCuisineScreen"

	
	components.cookMealButton = 
	CreateScreenComponent({ 
		Name = "BoonSlot1", 
		Group = "Combat_UI_World", 
		Scale = 0.3, 
	})
	components.cookMealButton.usee = button.usee
	components.cookMealButton.OnPressedFunctionName = "CuisineCookMealButton"
	components.cookMealButton.X = 0
	components.cookMealButton.Y = 0
	Attach({ Id = components.cookMealButton.Id, DestinationId = components.ShopBackground.Id, OffsetX = 350, OffsetY = 440 })
	CreateTextBox(MergeTables({ Id = components.cookMealButton.Id, Text = "ChefCuisineModRecipeMenuCookButton",
	FontSize = 22, OffsetX = 0, OffsetY = 0, Width = 720, Color = color, Font = "AlegreyaSansSCLight",
	ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2}, Justification = "Center"
	}, LocalizationData.SellTraitScripts.ShopButton))

	SetAlpha({ Id = components.ShopBackground.Id, Fraction = 1, Duration = 0 })
	SetScale({ Id = components.ShopBackground.Id, Fraction = 2 })
	SetScale({ Id = components.ShopBackgroundDim.Id, Fraction = 4 })
	SetColor({ Id = components.ShopBackgroundDim.Id, Color = {1, 1, 0, 0} })

	wait(0.25)

	-- Title
	CreateTextBox(MergeTables({ Id = components.ShopBackground.Id, Text = "ChefCuisineModRecipeMenuTitle", FontSize = 32, OffsetX = 0, OffsetY = -445, Color = Color.White, Font = "SpectralSCLightTitling", ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 3}, Justification = "Center" }, LocalizationData.SellTraitScripts.ShopButton))

	CreateTextBox(MergeTables({ Id = components.ShopBackground.Id, Text = "ChefCuisineModRecipeMenuFlavorText1",FontSize = 14, OffsetX = 0, OffsetY = 380, Width = 840, Color = Color.Gray, Font = "AlegreyaSansSCBold", ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2}, Justification = "Center" }, LocalizationData.SellTraitScripts.ShopButton))
	
	CreateTextBox(MergeTables({ Id = components.ShopBackground.Id, Text = "ChefCuisineModRecipeMenuSubheader",
			FontSize = 16,
			OffsetY = -385, Width = 840,
			Color = {0.698, 0.702, 0.514, 1.0},
			Font = "AlegreyaSansSCRegular",
			ShadowBlur = 0, ShadowColor = {0,0,0,0}, ShadowOffset={0, 3},
			Justification = "Center",
		}, LocalizationData.SellTraitScripts.FlavorText))

	components.DescriptorBG = CreateScreenComponent({ Name = "EndPanelBox",Scale = 0.7 })
	SetScaleX({ Id = components.DescriptorBG.Id, Fraction = 1.3})
	Attach({ Id = components.DescriptorBG.Id, DestinationId = components.ShopBackground.Id, OffsetX = 550, OffsetY = 0 })
	SetAnimation({ Name = "EndPanelBox_Heat", DestinationId = components.DescriptorBG.Id})
	CreateRecipeButtons(screen)
	screen.KeepOpen = true
	thread( HandleWASDInput, screen )
	HandleScreenInput( screen )

end
local ChefFishPositionTable = {}

local MealRecipes = {
    ["King's Yellow Shake"] = {
		{Name = "Fish_Tartarus_Legendary_01", Cost = 1},
		{Name = "Fish_Tartarus_Rare_01", Cost = 5},
		"BetterShrinePoints_Trait",
		{Name = "BetterShrinePointsIcon_Large", Scale = 0.33},
    },
    ["Cthulu Buffet"] = {
        {Name = "Fish_Tartarus_Legendary_01", Cost = 1},
		{Name = "Fish_Chaos_Rare_01", Cost = 1},
		"BetterChaosGates_Trait",
		{Name = "BetterChaosGatesIcon_Large", Scale = 0.5},
	},
	["Tartarus Weapon Sauce"] ={
		{Name = "Fish_Tartarus_Common_01", Cost = 3},
		{Name = "Fish_Asphodel_Common_01", Cost = 3},
		"BetterWeaponMastery_Trait",
		{Name = "BetterWeaponMasteryIcon_Large", Scale = 0.5},
		"GetExpMultiplier"
	},
	["Deathly Miracle Fruit"] ={
		{Name = "Fish_Styx_Legendary_01", Cost = 1},
		{Name = "Fish_Styx_Rare_01", Cost = 2},
		"BetterDualWielding_Trait",
		{Name = "BetterDualWieldingIcon_Large", Scale = 0.5},
		"SwitchWeapon"
	},
	["Titan Plasma"] ={
		{Name = "Fish_Styx_Common_01", Cost = 4},
		{Name = "Fish_Elysium_Common_01", Cost = 4},
		"BetterWeaponAspectRework_Trait",
		{Name = "BetterWeaponAspectReworkIcon_Large", Scale = 1.5},
		"SetupSpearAmmoLoad"
	}
}

--to
local FishCombinations = {
	
}

function ChefDecompressFishCombos()
	for k,v in pairs(MealRecipes) do
		if v[5] ~= nil then
			if _G[v[5]] then
				if FishCombinations[v[1].Name] == nil then
					FishCombinations[v[1].Name] = {}
				end
				local iconData = {Name = v[4].Name, Scale = v[4].Scale}
				FishCombinations[v[1].Name][v[2].Name] = {ParentAmount = v[1].Cost, Amount = v[2].Cost, Meal = k, Boon = v[3], Icon = iconData}
				if FishCombinations[v[2].Name] == nil then
					FishCombinations[v[2].Name] = {}
				end
				FishCombinations[v[2].Name][v[1].Name] = {ParentAmount = v[2].Cost, Amount = v[1].Cost, Meal = k, Boon = v[3], Icon = iconData}
			end
		else
			if FishCombinations[v[1].Name] == nil then
				FishCombinations[v[1].Name] = {}
			end
			local iconData = {Name = v[4].Name, Scale = v[4].Scale}
			FishCombinations[v[1].Name][v[2].Name] = {ParentAmount = v[1].Cost, Amount = v[2].Cost, Meal = k, Boon = v[3], Icon = iconData}
			if FishCombinations[v[2].Name] == nil then
				FishCombinations[v[2].Name] = {}
			end
			FishCombinations[v[2].Name][v[1].Name] = {ParentAmount = v[2].Cost, Amount = v[1].Cost, Meal = k, Boon = v[3], Icon = iconData}
		end
	end
end

function CreateRecipeButtons(screen)
	ChefDecompressFishCombos()
	local itemLocationStartY = -125
	local itemLocationYSpacer = 320

	local itemLocationStartX = -775
	local itemLocationXSpacer = 105
	local itemLocationMaxX = 70

	local itemLocationX = itemLocationStartX
	local itemLocationY = itemLocationStartY

	local components = screen.Components

	for k,v in pairs(GameState.TotalCaughtFish) do
		if FishCombinations[k] ~= nil then
			local itemBackingKey = "Backing"..k
			components[itemBackingKey] = CreateScreenComponent({ Name = "BoonSlot1", Group = "Combat_Menu", X = itemLocationX, Y = itemLocationY })
			components[itemBackingKey].OnPressedFunctionName = "ChefFishSelected"
			components[itemBackingKey].FishName = k

			local scale = 0.65
			SetScaleX({ Id = components[itemBackingKey].Id, Fraction = 0.22 * (scale / 1.2)})
			SetScaleY({ Id = components[itemBackingKey].Id, Fraction = 2.8 * (scale / 1.2)})
			local purchaseButtonKey = "PurchaseButton".. k
			local imageName = "Codex_Portrait_"..k
			
			components[purchaseButtonKey] = CreateScreenComponent({ Name = "BlankObstacle", Group = "Combat_Menu",Ambient = 0,Scale = scale, X = itemLocationX, Y = itemLocationY })
			SetAnimation({ DestinationId = components[purchaseButtonKey].Id, Name = imageName })
			Attach({ Id = components[purchaseButtonKey].Id, DestinationId = components.ShopBackground.Id, OffsetX = itemLocationX, OffsetY = itemLocationY })
			Attach({ Id = components[itemBackingKey].Id, DestinationId = components.ShopBackground.Id, OffsetX = itemLocationX, OffsetY = itemLocationY })
			
			CreateTextBox(MergeTables({ Id = components[itemBackingKey].Id, Text = v,
				FontSize = 20,
				OffsetX = -25, OffsetY = -100,
				Width = 60,
				Color = {1,0,0,1},
				Font = "AlegreyaSansSCBold",
				Ambient = 0,
				ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2},
				Justification = "Left",
			}, LocalizationData.SellTraitScripts.ShopButton))
			
			ChefFishPositionTable[k] = {
				Name = k,
				Amount = v,
				Position = {X = itemLocationX, Y = itemLocationY}
			}
			itemLocationX = itemLocationX + itemLocationXSpacer
			if itemLocationX >= itemLocationMaxX then
				itemLocationX = itemLocationStartX
				itemLocationY = itemLocationY + itemLocationYSpacer
			end
		end
	end
end
local CurrentlySelectedMealFish = {}
local CreatedCheckMarksIds = {}

function ChefFishSelected(screen, button)
	local components = screen.Components
	local FishName = button.FishName
	if (CurrentlySelectedMealFish == nil or #CurrentlySelectedMealFish == 0) and FishCombinations[FishName] ~= nil then
		table.insert(CurrentlySelectedMealFish, FishName)
		for k,v in pairs(components) do
			if string.match(k, "RecipeText") then
				Destroy({Id = v.Id})
			end
		end
		ChefCreateRecipeText(screen, false)
		ChefCreateRecipeChecks(screen, false)
	elseif  CurrentlySelectedMealFish ~= nil and not Contains(CurrentlySelectedMealFish, FishName) and #CurrentlySelectedMealFish == 1 then
		local compatibleFish = {}
		for k,v in pairs(FishCombinations[CurrentlySelectedMealFish[1]]) do
			table.insert(compatibleFish, k)
		end
		if Contains(compatibleFish, FishName) then
			table.insert(CurrentlySelectedMealFish, FishName)
			for k,v in pairs(components) do
				if string.match(k, "RecipeText") then
					Destroy({Id = v.Id})
				end
			end
			ChefCreateRecipeText(screen, true)
			ChefCreateRecipeChecks(screen, true)
		end
	elseif CurrentlySelectedMealFish ~= nil and Contains(CurrentlySelectedMealFish, FishName) and CurrentlySelectedMealFish ~= 2 then
		for i = 1, #CurrentlySelectedMealFish do
			if CurrentlySelectedMealFish[i] == FishName then
				table.remove(CurrentlySelectedMealFish, i)
			end
		end
		for i = 1, #CreatedCheckMarksIds do
			if CreatedCheckMarksIds[i] == FishName then
				table.remove(CreatedCheckMarksIds, i)
			end
		end
		for k,v in pairs(components) do
			if string.match(k, "RecipeText") then
				Destroy({Id = v.Id})
			end
		end
		ChefCreateRecipeText(screen, false)
		ChefCreateRecipeChecks(screen, false)

	end
end

function ChefCreateRecipeText(screen, showOnlyOneRecipe) 
	local components = screen.Components
	for i = 1, #CurrentlySelectedMealFish do
		if i == 1 then
			local itemLocationX = 1515
			local itemLocationY = 390
			local curFish = CurrentlySelectedMealFish[1]

			components.topFishRecipeTextBackground = CreateScreenComponent({ Name = "MarketSlot", Group = "Combat_Menu_CheftopFishRecipeText", Scale = 1, X = itemLocationX , Y = itemLocationY })
			
			SetScaleY({ Id = components.topFishRecipeTextBackground.Id , Fraction = 1.33 })
			SetScaleX({ Id = components.topFishRecipeTextBackground.Id , Fraction = 0.56 })
				
			components.topFishRecipeTextIcon = CreateScreenComponent({ Name = "BlankObstacle", X = itemLocationX, Y = itemLocationY, Group = "Combat_Menu_CheftopFishRecipeText" })
	
			components.topFishRecipeTextBacking = CreateScreenComponent({ Name = "BlankObstacle", Group = "Combat_Menu_CheftopFishRecipeText", X = itemLocationX, Y = itemLocationY })
	
			components.topFishRecipeTextTitleKey = CreateScreenComponent({ Name = "BlankObstacle", Group = "Combat_Menu_CheftopFishRecipeText", Scale = 1, X = itemLocationX, Y = itemLocationY })
	
			CreateTextBox(MergeTables({ Id = components.topFishRecipeTextBacking.Id, Text = curFish,
				FontSize = 25,
				OffsetX = -125, OffsetY = -40,
				Width = 720,
				Color = {0.988, 0.792, 0.247, 1},
				Font = "AlegreyaSansSCBold",
				ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2},
				Justification = "Left",
			}, LocalizationData.SellTraitScripts.ShopButton))
	
			
			components.topFishRecipeTextKey = CreateScreenComponent({ Name = "BlankObstacle", Group = "Combat_Menu_CheftopFishRecipeText", Scale = 1 })
			SetAnimation({ Name = curFish, DestinationId = components.topFishRecipeTextKey.Id, Scale = 0.17 })
			Attach({ Id = components.topFishRecipeTextKey.Id, DestinationId = components.topFishRecipeTextTitleKey.Id, OffsetX = -175, OffsetY = 0})
			
			components.topFishRecipeTextFrame = CreateScreenComponent({ Name = "BoonInfoTraitFrame", Group = "Combat_Menu_CheftopFishRecipeText", X = itemLocationX - 175, Y = itemLocationY, Scale = 0.8 })
			SetScale({ Id = components.topFishRecipeTextFrame.Id, Fraction = 0.55 })
			local descriptionText = GetDisplayName({ Text = "CodexData_"..curFish:gsub("_", "").."_01" })
			CreateTextBoxWithFormat(MergeTables({ Id = components.topFishRecipeTextBacking.Id, Text = ChefCreateNiceEllipses(descriptionText, 133) .. "...",
				FontSize = 15,
				OffsetX = -115, OffsetY = -15,
				Width = 350,
				Color = Color.White,
				Justification = "Left",
				VerticalJustification = "Top",
				Format = "MarketScreenDescriptionFormat",
			}, LocalizationData.SellTraitScripts.ShopButton))
		elseif i == 2 then
			--#region Bottom Text creator
			local itemLocationX = 1515
			local itemLocationY = 785
			local curFish = CurrentlySelectedMealFish[2]

			components.bottomFishRecipeTextBackground = CreateScreenComponent({ Name = "MarketSlot", Group = "Combat_Menu_ChefbottomFishRecipeText", Scale = 1, X = itemLocationX , Y = itemLocationY })
			
			SetScaleY({ Id = components.bottomFishRecipeTextBackground.Id , Fraction = 1.33 })
			SetScaleX({ Id = components.bottomFishRecipeTextBackground.Id , Fraction = 0.56 })
				
			components.bottomFishRecipeTextIcon = CreateScreenComponent({ Name = "BlankObstacle", X = itemLocationX, Y = itemLocationY, Group = "Combat_Menu_ChefbottomFishRecipeText" })
		
			components.bottomFishRecipeTextBacking = CreateScreenComponent({ Name = "BlankObstacle", Group = "Combat_Menu_ChefbottomFishRecipeText", X = itemLocationX, Y = itemLocationY })
		
			components.bottomFishRecipeTextTitleKey = CreateScreenComponent({ Name = "BlankObstacle", Group = "Combat_Menu_ChefbottomFishRecipeText", Scale = 1, X = itemLocationX, Y = itemLocationY })
		
			CreateTextBox(MergeTables({ Id = components.bottomFishRecipeTextBacking.Id, Text = curFish,
				FontSize = 25,
				OffsetX = -125, OffsetY = -40,
				Width = 720,
				Color = {0.988, 0.792, 0.247, 1},
				Font = "AlegreyaSansSCBold",
				ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2},
				Justification = "Left",
			}, LocalizationData.SellTraitScripts.ShopButton))
		
			
			components.bottomFishRecipeTextKey = CreateScreenComponent({ Name = "BlankObstacle", Group = "Combat_Menu_ChefbottomFishRecipeText", Scale = 1 })
			SetAnimation({ Name = curFish, DestinationId = components.bottomFishRecipeTextKey.Id, Scale = 0.17 })
			Attach({ Id = components.bottomFishRecipeTextKey.Id, DestinationId = components.bottomFishRecipeTextTitleKey.Id, OffsetX = -175, OffsetY = 0})
			
			components.bottomFishRecipeTextFrame = CreateScreenComponent({ Name = "BoonInfoTraitFrame", Group = "Combat_Menu_ChefbottomFishRecipeText", X = itemLocationX - 175, Y = itemLocationY, Scale = 0.8 })
			SetScale({ Id = components.bottomFishRecipeTextFrame.Id, Fraction = 0.55 })
			local descriptionText = GetDisplayName({ Text = "CodexData_"..curFish:gsub("_", "").."_01" })

			CreateTextBoxWithFormat(MergeTables({ Id = components.bottomFishRecipeTextBacking.Id, Text = ChefCreateNiceEllipses(descriptionText, 133) .. "...",
				FontSize = 15,
				OffsetX = -115, OffsetY = -15,
				Width = 350,
				Color = Color.White,
				Justification = "Left",
				VerticalJustification = "Top",
				Format = "MarketScreenDescriptionFormat",
			}, LocalizationData.SellTraitScripts.ShopButton))
			--#endregion
			--#region Middle Text creator
			itemLocationX = 1515
			itemLocationY = 590
			curFish = FishCombinations[CurrentlySelectedMealFish[1]][CurrentlySelectedMealFish[2]]

			components.MiddleFishRecipeTextBackground = CreateScreenComponent({ Name = "MarketSlot", Group = "Combat_Menu_ChefMiddleFishRecipeText", Scale = 1, X = itemLocationX , Y = itemLocationY })
			
			SetScaleY({ Id = components.MiddleFishRecipeTextBackground.Id , Fraction = 2.3 })
			SetScaleX({ Id = components.MiddleFishRecipeTextBackground.Id , Fraction = 0.56 })
				
			components.MiddleFishRecipeTextIcon = CreateScreenComponent({ Name = "BlankObstacle", X = itemLocationX, Y = itemLocationY, Group = "Combat_Menu_ChefMiddleFishRecipeText" })
		
			components.MiddleFishRecipeTextBacking = CreateScreenComponent({ Name = "BlankObstacle", Group = "Combat_Menu_ChefMiddleFishRecipeText", X = itemLocationX, Y = itemLocationY })
		
			components.MiddleFishRecipeTextTitleKey = CreateScreenComponent({ Name = "BlankObstacle", Group = "Combat_Menu_ChefMiddleFishRecipeText", Scale = 1, X = itemLocationX, Y = itemLocationY })
			CreateTextBox(MergeTables({ Id = components.MiddleFishRecipeTextBacking.Id, Text = curFish.ParentAmount,
				FontSize = 25,
				OffsetX = 0, OffsetY = -75,
				Width = 720,
				Color = Color.Red,
				Font = "AlegreyaSansSCBold",
				ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2},
				Justification = "Left",
			}, LocalizationData.SellTraitScripts.ShopButton))
		
			CreateTextBox(MergeTables({ Id = components.MiddleFishRecipeTextBacking.Id, Text = "ChefCuisineModRecipeMeal" .. curFish.Meal,
				FontSize = 25,
				OffsetX = -125, OffsetY = -40,
				Width = 720,
				Color = {0.988, 0.792, 0.247, 1},
				Font = "AlegreyaSansSCBold",
				ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2},
				Justification = "Left",
			}, LocalizationData.SellTraitScripts.ShopButton))
		
			
			components.MiddleFishRecipeTextKey = CreateScreenComponent({ Name = "BlankObstacle", Group = "Combat_Menu_ChefMiddleFishRecipeText", Scale = 1 })
			SetAnimation({ Name = curFish.Icon.Name, DestinationId = components.MiddleFishRecipeTextKey.Id, Scale = curFish.Icon.Scale })
			Attach({ Id = components.MiddleFishRecipeTextKey.Id, DestinationId = components.MiddleFishRecipeTextTitleKey.Id, OffsetX = -175, OffsetY = 0})
			
			components.MiddleFishRecipeTextFrame = CreateScreenComponent({ Name = "BoonInfoTraitFrame", Group = "Combat_Menu_ChefMiddleFishRecipeText", X = itemLocationX - 175, Y = itemLocationY, Scale = 0.8 })
			SetScale({ Id = components.MiddleFishRecipeTextFrame.Id, Fraction = 0.55 })
			CreateTextBoxWithFormat(MergeTables({ Id = components.MiddleFishRecipeTextBacking.Id, Text = curFish.Boon .. "_CookingMenu",
				FontSize = 15,
				OffsetX = -115, OffsetY = -15,
				Width = 360,
				Color = Color.White,
				Justification = "Left",
				UseDescription = true,
				VerticalJustification = "Top",
				Format = "MarketScreenDescriptionFormat",
			}, LocalizationData.SellTraitScripts.ShopButton))
			CreateTextBox(MergeTables({ Id = components.MiddleFishRecipeTextBacking.Id, Text = curFish.Amount,
			FontSize = 25,
			OffsetX = 0, OffsetY = 80,
			Width = 720,
			Color = Color.Red,
			Font = "AlegreyaSansSCBold",
			ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2},
			Justification = "Left",
			}, LocalizationData.SellTraitScripts.ShopButton))
			--#endregion
		end
	end
end

function ChefCreateRecipeChecks(screen, showOnlyOneRecipe)
	local components = screen.Components
	if #CurrentlySelectedMealFish > 0 then
		local FishName = CurrentlySelectedMealFish[1]
		local itemLocationX = ChefFishPositionTable[FishName].Position.X
		local itemLocationY = ChefFishPositionTable[FishName].Position.Y
		local itemBackingKeyBaseItem = "Backing" .. FishName .. "RecipeTextBaseItem"
		components[itemBackingKeyBaseItem] = CreateScreenComponent({ Name = "BlankObstacle", Group = "Combat_Menu", X = itemLocationX, Y = itemLocationY })
		Attach({ Id = components[itemBackingKeyBaseItem].Id, DestinationId = components.ShopBackground.Id, OffsetX = itemLocationX, OffsetY = itemLocationY })
		components["Backing" .. FishName .. "RecipeTextCheckMarkIcon"] = CreateScreenComponent({ Name = "ButtonConfirm", Group = "Combat_UI_Backing_CheckMark", Scale = 0.525 })
		Attach({ Id = components["Backing" .. FishName .. "RecipeTextCheckMarkIcon"].Id, DestinationId = components[itemBackingKeyBaseItem].Id, OffsetX = 0 , OffsetY = 100 })
		local CurCombination = FishCombinations[FishName]
		if CurCombination ~= nil then
			for k,v in pairs(CurCombination) do
				if showOnlyOneRecipe then
					if  Contains(CurrentlySelectedMealFish, k) then
						local itemLocationX = ChefFishPositionTable[k].Position.X
						local itemLocationY = ChefFishPositionTable[k].Position.Y
						local checkMarkBacking = "Backing" .. FishName .. "RecipeTextBaseItem2"
						components[checkMarkBacking] = CreateScreenComponent({ Name = "BlankObstacle", Group = "Combat_Menu", X = itemLocationX, Y = itemLocationY })
						Attach({ Id = components[checkMarkBacking].Id, DestinationId = components.ShopBackground.Id, OffsetX = itemLocationX, OffsetY = itemLocationY })
						components["Backing" .. FishName .. "RecipeTextCheckMarkIcon2"] = CreateScreenComponent({ Name = "ButtonConfirm", Group = "Combat_UI_Backing_CheckMark", Scale = 0.525 })
						Attach({ Id = components["Backing" .. FishName .. "RecipeTextCheckMarkIcon2"].Id, DestinationId = components[checkMarkBacking].Id, OffsetX = 0 , OffsetY = 100 })
					end
				else
					local itemLocationX = ChefFishPositionTable[k].Position.X
					local itemLocationY = ChefFishPositionTable[k].Position.Y
					
					local checkMarkBacking = "Backing" .. FishName .. "RecipeTextBaseItem" .. k
					components[checkMarkBacking] = CreateScreenComponent({ Name = "BlankObstacle", Group = "Combat_Menu", X = itemLocationX, Y = itemLocationY })
					Attach({ Id = components[checkMarkBacking].Id, DestinationId = components.ShopBackground.Id, OffsetX = itemLocationX, OffsetY = itemLocationY })
					components["Backing" .. FishName .. "RecipeTextCheckMarkIcon" .. k] = CreateScreenComponent({ Name = "BlankObstacle", Group = "Combat_UI_Backing_CheckMark",Ambient = 0,Scale = 0.525})
					SetAnimation({ DestinationId = components["Backing" .. FishName .. "RecipeTextCheckMarkIcon" .. k].Id, Name = "StatusIconWantsToTalk", })
					Attach({ Id = components["Backing" .. FishName .. "RecipeTextCheckMarkIcon" .. k].Id, DestinationId =components[checkMarkBacking].Id, OffsetY = 100 })
				end
			end
		end
	end
end
function CuisineCookMealButton(screen,button)
	
	if CurrentlySelectedMealFish ~= nil and #CurrentlySelectedMealFish == 2 then
		MealData = FishCombinations[CurrentlySelectedMealFish[1]][CurrentlySelectedMealFish[2]]
		if GameState.TotalCaughtFish[CurrentlySelectedMealFish[1]] >= MealData.ParentAmount and GameState.TotalCaughtFish[CurrentlySelectedMealFish[2]] >= MealData.Amount  then
			CuisineTurnInFish(screen, button)
			AddTraitToHero({ TraitData = GetProcessedTraitData({ Unit = CurrentRun.Hero, TraitName = MealData.Boon, Rarity = "Legendary" }) })
			SelectedFish = MealData.Boon:gsub("_Trait", "")
			GameState.TotalCaughtFish[CurrentlySelectedMealFish[1]] = GameState.TotalCaughtFish[CurrentlySelectedMealFish[1]] - MealData.ParentAmount
			GameState.TotalCaughtFish[CurrentlySelectedMealFish[2]] = GameState.TotalCaughtFish[CurrentlySelectedMealFish[1]] - MealData.Amount
			thread( InCombatText, CurrentRun.Hero.ObjectId, MealData.Boon, 1.8, { ShadowScale = 0.8 } )
			hasBeenUsed = true
			local partner = button.usee
			partner.NextInteractLines = nil
			StopStatusAnimation( partner, StatusAnimations.WantsToTalk )
			RefreshUseButton( partner.ObjectId, partner )
			UseableOff({ Id = partner.ObjectId })
		end
	end
end

function ChefCreateNiceEllipses(originalString, endPoint)
	local afterEndString = string.sub(originalString, endPoint, #originalString)
	local endIndex = endPoint
	for i = 1, #originalString - endPoint do
		if string.sub(afterEndString,i,i) == " " then
			break
		end
	endIndex = endIndex + 1
	end
	return string.sub(originalString, 1, endIndex)
end