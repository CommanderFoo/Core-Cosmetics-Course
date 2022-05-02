local COSMETIC_CATEGORIES = require(script:GetCustomProperty("CosmeticCategories"))
local CONTAINER = script:GetCustomProperty("Container"):WaitForObject()
local CATEGORY_ENTRY = script:GetCustomProperty("CategoryEntry")
local HEADER_TEXT = script:GetCustomProperty("HeaderText"):WaitForObject()
local COSMETIC_PANEL = script:GetCustomProperty("CosmeticPanel"):WaitForObject()
local CLEAR_BUTTON = script:GetCustomProperty("ClearButton"):WaitForObject()
local ITEM_BUTTON = script:GetCustomProperty("ItemButton")

local activeButton = nil
local activeIndicator = nil
local activeCategoryIndex = 1
local cosmeticPlayerData = {}

local totalItemsPerRow = math.floor(COSMETIC_PANEL.parent.width / 65)

local function OnClearClicked()
	Events.BroadcastToServer("cosmetic.clear", activeCategoryIndex)
end

local function ClearCosmeticPanel()
	for index, child in ipairs(COSMETIC_PANEL:GetChildren()) do
		if index > 1 then
			child:Destroy()
		end
	end
end

local function OnCosmeticClicked(button, categoryIndex, cosmeticIndex)
	Events.BroadcastToServer("cosmetic.apply", categoryIndex, cosmeticIndex)
end

local function LoadCategoryCosmetics(cosmetics, categoryIndex)
	ClearCosmeticPanel()

	if cosmetics == nil then
		return
	end

	local xOffset = 65
	local yOffset = 0
	local counter = 1

	for index, row in ipairs(cosmetics) do
		local item = World.SpawnAsset(ITEM_BUTTON, { parent = COSMETIC_PANEL })

		item:FindChildByName("Item Text").text = tostring(index)
		item.x = xOffset
		item.y = yOffset
		xOffset = xOffset + 65

		item.clickedEvent:Connect(OnCosmeticClicked, categoryIndex, index)

		if counter == totalItemsPerRow then
			counter = 0
			yOffset = yOffset + 65
			xOffset = 0
		end

		counter = counter + 1
	end
end

local function ShowCategory(category, categoryIndex)
	activeCategoryIndex = categoryIndex
	HEADER_TEXT.text = string.upper(category.name .. " Style")
	LoadCategoryCosmetics(category.cosmetics, categoryIndex)
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
		local item = World.SpawnAsset(CATEGORY_ENTRY)
		local button = item:FindDescendantByName("Category Button")
		local indicator = item:FindDescendantByName("Indicator")

		item:FindDescendantByName("Category Name").text = string.upper(category.name)
		item.parent = CONTAINER

		item.y = offset
		offset = offset + 90

		button.clickedEvent:Connect(OnButtonPressed, indicator, category, index)

		if activeButton == nil then
			OnButtonPressed(button, indicator, category, index)
		end
	end
end

CreateCategories()

CLEAR_BUTTON.clickedEvent:Connect(OnClearClicked)