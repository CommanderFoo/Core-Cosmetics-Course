local COSMETIC_CATEGORIES = require(script:GetCustomProperty("CosmeticCategories"))
local CONTAINER = script:GetCustomProperty("Container"):WaitForObject()
local CATEGORY_ENTRY = script:GetCustomProperty("CategoryEntry")
local HEADER_TEXT = script:GetCustomProperty("HeaderText"):WaitForObject()
local COSMETIC_PANEL = script:GetCustomProperty("CosmeticPanel"):WaitForObject()
local CLEAR_BUTTON = script:GetCustomProperty("ClearButton"):WaitForObject()
local ITEM_BUTTON = script:GetCustomProperty("ItemButton")

local LOCAL_PLAYER = Game.GetLocalPlayer()

local activeButton = nil
local activeIndicator = nil
local activeCategoryIndex = 1
local cosmeticPlayerData = {}
local activeButtons = {}
local categoriesCreated = false
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

local function ClearActiveButton(button, categoryIndex, cosmeticIndex, stackable)
	local alreadyActive = false

	if activeButtons[categoryIndex] ~= nil then
		for index, item in ipairs(activeButtons[categoryIndex]) do
			local activeButton = COSMETIC_PANEL:FindChildByName(string.format("Category: %s Item: %s", categoryIndex, item.cosmeticIndex))

			if not stackable or cosmeticIndex == item.cosmeticIndex then
				activeButton:SetButtonColor(activeButton:GetDisabledColor())
				table.remove(activeButtons[categoryIndex], index)
				
				if cosmeticIndex == item.cosmeticIndex then
					alreadyActive = true
				end
			end
		end
	end

	return alreadyActive
end

local function AddActiveButton(button, categoryIndex, cosmeticIndex, stackable)
	if activeButtons[categoryIndex] == nil then
		activeButtons[categoryIndex] = {}
	end

	table.insert(activeButtons[categoryIndex], {


		cosmeticIndex = cosmeticIndex,
		stackable = stackable

	})

	button:SetButtonColor(button:GetPressedColor())
end

local function OnCosmeticClicked(button, categoryIndex, cosmeticIndex, stackable)
	local alreadyActive = ClearActiveButton(button, categoryIndex, cosmeticIndex, stackable)

	if not alreadyActive then
		AddActiveButton(button, categoryIndex, cosmeticIndex, stackable)
	end

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
		if row.enabled then
			local item = World.SpawnAsset(ITEM_BUTTON, { parent = COSMETIC_PANEL })

			item:FindChildByName("Item Text").text = tostring(index)
			item.x = xOffset
			item.y = yOffset
			xOffset = xOffset + 65

			item.name = string.format("Category: %s Item: %s", categoryIndex, index)
			item.clickedEvent:Connect(OnCosmeticClicked, categoryIndex, index, row.stackable)

			if activeButtons[categoryIndex] ~= nil then
				for _, activeItem in ipairs(activeButtons[categoryIndex]) do
					if(activeItem.cosmeticIndex == index) then
						item:SetButtonColor(item:GetPressedColor())
						break
					end
				end
			end

			if counter == totalItemsPerRow then
				counter = 0
				yOffset = yOffset + 65
				xOffset = 0
			end

			counter = counter + 1
		end
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
		if category.enabled then
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
end

local function CreateActiveButtonsTable()
	if cosmeticPlayerData ~= nil then
		for categoryIndex, cosmetics in ipairs(cosmeticPlayerData) do
			if activeButtons[categoryIndex] == nil then
				activeButtons[categoryIndex] = {}
			end

			for index, cosmeticIndex in ipairs(cosmetics) do
				table.insert(activeButtons[categoryIndex], {


					cosmeticIndex = cosmeticIndex,
					stackable = COSMETIC_CATEGORIES[categoryIndex].cosmetics[cosmeticIndex].stackable
			
				})
			end
		end
	end
end

local function OnPrivateDataChanged(player, key)
	if key == "cosmetics" then
		local data = player:GetPrivateNetworkedData(key)

		if data ~= nil then
			cosmeticPlayerData = data
			CreateActiveButtonsTable()
		end
	end
end

local function OnUIToggled()
	if not categoriesCreated then
		CreateCategories()
	end
end

OnPrivateDataChanged(LOCAL_PLAYER, "cosmetics")

CLEAR_BUTTON.clickedEvent:Connect(OnClearClicked)
LOCAL_PLAYER.privateNetworkedDataChangedEvent:Connect(OnPrivateDataChanged)

Events.Connect("CosmeticUIToggle", OnUIToggled)