local COSMETIC_COLOR = require(script:GetCustomProperty("CosmeticColor"))

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

COSMETIC_COLOR.Set({

	activeCosmetics = activeCosmetics,
	cosmeticPanel = COSMETIC_PANEL,
	primary = PRIMARY_COLOR_PANEL,
	secondary = SECONDARY_COLOR_PANEL,
	tertiary = TERTIARY_COLOR_PANEL,
	itemsPerRow = totalItemsPerRow,
	cosmeticCategories = COSMETIC_CATEGORIES

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
	COSMETIC_COLOR.ClearActiveColors(activeCategoryIndex)

	if activeCosmetics[activeCategoryIndex] ~= nil and activeCosmetics[activeCategoryIndex] ~= 0 then
		ClearActiveButton(activeCategoryIndex, activeCosmetics[activeCategoryIndex])
		COSMETIC_COLOR.EnableDisableColors()
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

local function OnCosmeticPressed(button, categoryIndex, cosmeticIndex)
	local alreadyActive = ClearActiveButton(categoryIndex, cosmeticIndex)

	if not alreadyActive then
		AddActiveButton(button, categoryIndex, cosmeticIndex)
	end

	COSMETIC_COLOR.EnableDisableColors()
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
	COSMETIC_COLOR.UpdatePalettes(categoryIndex)
	COSMETIC_COLOR.EnableDisableColors()

	if activeCosmetics[activeCategoryIndex] ~= nil then
		local activeCosmeticIndex = activeCosmetics[activeCategoryIndex].cosmetic

		if activeCosmeticIndex ~= nil and activeCosmeticIndex ~= 0 then
			activeButton = COSMETIC_PANEL:GetChildren()[activeCosmeticIndex + 1]

			AddActiveButton(activeButton, categoryIndex, activeCosmeticIndex)
		end
	end
end

local function OnCategoryPressed(button, indicator, category, categoryIndex)
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

			button.pressedEvent:Connect(OnCategoryPressed, indicator, category, index)

			COSMETIC_COLOR.AddCategory(index)

			if activeButton == nil then
				OnCategoryPressed(button, indicator, category, index)
			end
		end
	end
end

local function CreateActiveCosmeticsTable()
	if cosmeticPlayerData ~= nil then
		for categoryIndex, cosmetic in ipairs(cosmeticPlayerData) do
			activeCosmetics[categoryIndex] = cosmetic

			--print(cosmetic.primary)
			-- COSMETIC_COLOR.ApplyColorToCosmetic(cosmetic.primary, COSMETIC_COLOR.ColorType.PRIMARY)
			-- COSMETIC_COLOR.ApplyColorToCosmetic(cosmetic.secondary, COSMETIC_COLOR.ColorType.SECONDAY)
			-- COSMETIC_COLOR.ApplyColorToCosmetic(cosmetic.teritary, COSMETIC_COLOR.ColorType.TERTIARY)
		end
	end
end

local function OnPrivateDataChanged(player, key)
	if key == "cosmetics" then
		local data = player:GetPrivateNetworkedData(key)

		if data ~= nil then
			cosmeticPlayerData = data
			CreateActiveCosmeticsTable()
		end
	end
end

local function OnUIToggled(isOpened)
	if not categoriesCreated then
		CreateCategories()
		COSMETIC_COLOR.CreateColors()
		categoriesCreated = true
	end

	if isOpened then
		COSMETIC_COLOR.EnableDisableColors()
	end
end

local function UpdatePlayerCosmetic(obj)
	if obj ~= nil then
		local cosmeticObject = obj:GetObject()

		if Object.IsValid(cosmeticObject) then
			local meshes = cosmeticObject:FindDescendantsByType("StaticMesh")
	
			for m, mesh in ipairs(meshes) do
				if mesh:GetCustomProperty("Ignore") == nil or not mesh:GetCustomProperty("Ignore") then
					local materialSlots = mesh:GetMaterialSlots()

					for s, slot in ipairs(materialSlots) do
						if string.find(tostring(slot), "BaseMaterial") then
							slot:SetSlotColor(cosmeticObject:GetCustomProperty("PrimaryColor"))
						elseif string.find(tostring(slot), "Detail1") then
							slot:SetSlotColor(cosmeticObject:GetCustomProperty("SecondaryColor"))
						elseif string.find(tostring(slot), "Detail2") then
							slot:SetSlotColor(cosmeticObject:GetCustomProperty("TertiaryColor"))
						end
					end
				end
			end
		end
	end
end

OnPrivateDataChanged(LOCAL_PLAYER, "cosmetics")

LOCAL_PLAYER.privateNetworkedDataChangedEvent:Connect(OnPrivateDataChanged)

CLEAR_BUTTON.pressedEvent:Connect(OnClearPressed)

Events.Connect("CosmeticUIToggle", OnUIToggled)
Events.Connect("UpdatePlayerCostmetic", UpdatePlayerCosmetic)