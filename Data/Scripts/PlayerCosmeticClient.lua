local BUTTON_COLORS = require(script:GetCustomProperty("ButtonColors"))

local COSMETIC_CATEGORIES = require(script:GetCustomProperty("CosmeticCategories"))

local CONTAINER = script:GetCustomProperty("Container"):WaitForObject()
local CATEGORY_ENTRY = script:GetCustomProperty("CategoryEntry")
local HEADER_TEXT = script:GetCustomProperty("HeaderText"):WaitForObject()
local COSMETIC_PANEL = script:GetCustomProperty("CosmeticPanel"):WaitForObject()
local CLEAR_BUTTON = script:GetCustomProperty("ClearButton"):WaitForObject()
local ITEM_BUTTON = script:GetCustomProperty("ItemButton")

local PRIMARY_COLOR_PANEL = script:GetCustomProperty("PrimaryColorPanel"):WaitForObject()
local SECONDARY_COLOR_PANEL = script:GetCustomProperty("SecondaryColorPanel"):WaitForObject()
local TERTIARY_COLOR_PANEL = script:GetCustomProperty("TertiaryColorPanel"):WaitForObject()

local LOCAL_PLAYER = Game.GetLocalPlayer()

local activeButton = nil
local activeIndicator = nil
local activeCategoryIndex = 1
local cosmeticPlayerData = {}
local activeCosmetics = {}
local categoriesCreated = false
local totalItemsPerRow = math.floor(COSMETIC_PANEL.parent.width / 65)

BUTTON_COLORS.Set({

	activeCosmetics = activeCosmetics,
	cosmeticPanel = COSMETIC_PANEL,
	primary = PRIMARY_COLOR_PANEL,
	secondary = SECONDARY_COLOR_PANEL,
	tertiary = TERTIARY_COLOR_PANEL,
	itemsPerRow = totalItemsPerRow

})

local function ClearCosmeticPanel()
	for index, child in ipairs(COSMETIC_PANEL:GetChildren()) do
		if index > 1 then
			child:Destroy()
		end
	end
end

local function ClearActiveButton(categoryIndex, cosmeticIndex)
	local alreadyActive = false

	if activeCosmetics[categoryIndex] ~= nil and activeCosmetics[categoryIndex] ~= 0 then
		local activeButton = COSMETIC_PANEL:FindChildByName(string.format("Category: %s Item: %s", categoryIndex, activeCosmetics[categoryIndex]))

		if(Object.IsValid(activeButton)) then
			activeButton:SetButtonColor(activeButton:GetDisabledColor())
		end
		
		if cosmeticIndex == activeCosmetics[categoryIndex] then
			alreadyActive = true
		end

		activeCosmetics[categoryIndex] = 0
	end

	return alreadyActive
end

local function OnClearPressed()
	BUTTON_COLORS.ClearActiveColors(activeCategoryIndex)

	if activeCosmetics[activeCategoryIndex] ~= nil and activeCosmetics[activeCategoryIndex] ~= 0 then
		ClearActiveButton(activeCategoryIndex, activeCosmetics[activeCategoryIndex])
		
		Events.BroadcastToServer("cosmetic.clear", activeCategoryIndex)
	end
end

local function AddActiveButton(button, categoryIndex, cosmeticIndex)
	if activeCosmetics[categoryIndex] == nil then
		activeCosmetics[categoryIndex] = 0
	end

	activeCosmetics[categoryIndex] = cosmeticIndex
	button:SetButtonColor(button:GetPressedColor())
end

local function OnCosmeticPressed(button, categoryIndex, cosmeticIndex, row)
	BUTTON_COLORS.EnableDisableColors(row)

	local alreadyActive = ClearActiveButton(categoryIndex, cosmeticIndex)

	if not alreadyActive then
		AddActiveButton(button, categoryIndex, cosmeticIndex)
	end

	Events.BroadcastToServer("cosmetic.apply", categoryIndex, cosmeticIndex)
end

local function LoadCategory(cosmetics, categoryIndex)
	ClearCosmeticPanel()

	if cosmetics == nil then
		COSMETIC_PANEL.height = 65
		return
	end

	local xOffset = 65
	local yOffset = 0
	local counter = 2
	local rows = 0
	local totalCreated = 0

	for index, row in ipairs(cosmetics) do
		if not row.disabled then
			local item = World.SpawnAsset(ITEM_BUTTON, { parent = COSMETIC_PANEL })

			item:FindChildByName("Item Text").text = tostring(index)
			item.x = xOffset
			item.y = yOffset
			xOffset = xOffset + 65

			item.name = string.format("Category: %s Item: %s", categoryIndex, index)
			item.pressedEvent:Connect(OnCosmeticPressed, categoryIndex, index, row)

			if activeCosmetics[categoryIndex] ~= nil and activeCosmetics[categoryIndex] == index then
				item:SetButtonColor(item:GetPressedColor())
			end

			if counter == totalItemsPerRow then
				counter = 0
				yOffset = yOffset + 65
				xOffset = 0
				rows = rows + 1
			end

			counter = counter + 1
			totalCreated = totalCreated + 1
		end
	end

	COSMETIC_PANEL.height = (rows == 0 and 1 or (rows + 1)) * 65
end

local function ShowCategory(category, categoryIndex)
	activeCategoryIndex = categoryIndex
	HEADER_TEXT.text = string.upper(category.name .. " Style")
	LoadCategory(category.cosmetics, categoryIndex)
	BUTTON_COLORS.UpdatePalettes(activeCategoryIndex)
end

local function OnButtonPressed(button, indicator, category, categoryIndex)
	if button ~= activeButton then
		if activeButton ~= nil then
			activeButton:SetButtonColor(button:GetDisabledColor())
			activeIndicator.visibility = Visibility.FORCE_OFF
		end

		button:SetButtonColor(button:GetHoveredColor())
		indicator.visibility = Visibility.INHERIT

		ShowCategory(category, categoryIndex)

		activeButton = button
		activeIndicator = indicator
	end
end

local function CreateCategories()
	local offset = 0

	for index, category in ipairs(COSMETIC_CATEGORIES) do
		if not category.disabled then
			local item = World.SpawnAsset(CATEGORY_ENTRY)
			local button = item:FindDescendantByName("Category Button")
			local indicator = item:FindDescendantByName("Indicator")

			item:FindDescendantByName("Category Name").text = string.upper(category.name)
			item.parent = CONTAINER

			item.y = offset
			offset = offset + 90

			button.pressedEvent:Connect(OnButtonPressed, indicator, category, index)

			BUTTON_COLORS.AddCategory(index)

			if activeButton == nil then
				OnButtonPressed(button, indicator, category, index)
			end
		end
	end
end

local function CreateactiveCosmeticsTable()
	if cosmeticPlayerData ~= nil then
		for categoryIndex, cosmetic in ipairs(cosmeticPlayerData) do
			activeCosmetics[categoryIndex] = cosmetic
		end
	end
end

local function OnPrivateDataChanged(player, key)
	if key == "cosmetics" then
		local data = player:GetPrivateNetworkedData(key)

		if data ~= nil then
			cosmeticPlayerData = data
			CreateactiveCosmeticsTable()
		end
	end
end

local function OnUIToggled()
	if not categoriesCreated then
		CreateCategories()
		BUTTON_COLORS.CreateColors()
	end
end

OnPrivateDataChanged(LOCAL_PLAYER, "cosmetics")

LOCAL_PLAYER.privateNetworkedDataChangedEvent:Connect(OnPrivateDataChanged)

CLEAR_BUTTON.pressedEvent:Connect(OnClearPressed)

Events.Connect("CosmeticUIToggle", OnUIToggled)