local COSMETIC_CATEGORIES = require(script:GetCustomProperty("CosmeticCategories"))

local PRIMARY_COLOR_PALETTE = require(script:GetCustomProperty("PrimaryColorPalette"))
local SECONDARY_COLOR_PALETTE = require(script:GetCustomProperty("SecondaryColorPalette"))
local TERTIARY_COLOR_PALETTE = require(script:GetCustomProperty("TertiaryColorPalette"))

local CONTAINER = script:GetCustomProperty("Container"):WaitForObject()
local CATEGORY_ENTRY = script:GetCustomProperty("CategoryEntry")
local HEADER_TEXT = script:GetCustomProperty("HeaderText"):WaitForObject()
local COSMETIC_PANEL = script:GetCustomProperty("CosmeticPanel"):WaitForObject()
local CLEAR_BUTTON = script:GetCustomProperty("ClearButton"):WaitForObject()
local ITEM_BUTTON = script:GetCustomProperty("ItemButton")
local COLOR_BUTTON = script:GetCustomProperty("ColorButton")

---@type UIPanel
local PRIMARY_COLOR_PANEL = script:GetCustomProperty("PrimaryColorPanel"):WaitForObject()

---@type UIPanel
local SECONDARY_COLOR_PANEL = script:GetCustomProperty("SecondaryColorPanel"):WaitForObject()

---@type UIPanel
local TERTIARY_COLOR_PANEL = script:GetCustomProperty("TertiaryColorPanel"):WaitForObject()

local LOCAL_PLAYER = Game.GetLocalPlayer()

local activeButton = nil
local activeIndicator = nil
local activeCategoryIndex = 1
local cosmeticPlayerData = {}
local activeCosmetics = {}
local categoriesCreated = false
local totalItemsPerRow = math.floor(COSMETIC_PANEL.parent.width / 65)
local activePrimaryColorButtons = {}
local activeSecondaryColorButtons = {}
local activeTertiaryColorButtons = {}

local ColorType = {

	["PRIMARY"] = 1,
	["SECONDARY"] = 2,
	["TERTIARY"] = 3

}

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
	local alreadyActive = ClearActiveButton(categoryIndex, cosmeticIndex)

	if not alreadyActive then
		AddActiveButton(button, categoryIndex, cosmeticIndex)
	end

	Events.BroadcastToServer("cosmetic.apply", categoryIndex, cosmeticIndex)
end

local function UpdatePalettes()
	PRIMARY_COLOR_PANEL.parent.y = COSMETIC_PANEL.y + COSMETIC_PANEL.height + 5
	SECONDARY_COLOR_PANEL.parent.y = PRIMARY_COLOR_PANEL.parent.y + PRIMARY_COLOR_PANEL.parent.height + 5
	TERTIARY_COLOR_PANEL.parent.y = SECONDARY_COLOR_PANEL.parent.y + SECONDARY_COLOR_PANEL.parent.height + 5
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
	UpdatePalettes()
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

			if activeButton == nil then
				OnButtonPressed(button, indicator, category, index)
			end
		end
	end
end

local function ApplyColorToCosmetic(color, colorType)
	if activeCosmetics[activeCategoryIndex] ~= nil and activeCosmetics[activeCategoryIndex] ~= 0 then
		for index, object in ipairs(LOCAL_PLAYER:GetAttachedObjects()) do
			if object.name == "Cosmetic Item - [Cat: " .. tostring(activeCategoryIndex) .. ", Item: " .. tostring(activeCosmetics[activeCategoryIndex]) .. "]" then
				local meshes = object:FindDescendantsByType("StaticMesh")

				for m, mesh in ipairs(meshes) do
					if mesh:GetCustomProperty("Ignore") == nil or not mesh:GetCustomProperty("Ignore") then
						-- local materialSlots = mesh:GetMaterialSlots()

						-- for mat, material in ipairs(materials) do
						-- 	print(material)
						-- end

						if color == nil then
							mesh:ResetColor()
						else
							mesh:SetColor(color)
						end
					end
				end
			end
		end
	end
end

local function OnColorPressed(button, color, index, panel, colorTable, colorType)
	if colorTable[panel] == nil then
		colorTable[panel] = button
		button:SetButtonColor(button:GetHoveredColor())
		ApplyColorToCosmetic(color, colorType)
		Events.BroadcastToServer("cosmetic.color", color, index, activeCategoryIndex, colorType)
		return
	end

	local removingColor = false

	if button == colorTable[panel] then
		if button:GetButtonColor() == colorTable[panel]:GetDisabledColor() then
			button:SetButtonColor(button:GetHoveredColor())
		else
			removingColor = true
			button:SetButtonColor(button:GetDisabledColor())
		end
	else
		button:SetButtonColor(button:GetHoveredColor())
		colorTable[panel]:SetButtonColor(colorTable[panel]:GetDisabledColor())
		colorTable[panel] = button
	end

	if removingColor then
		color = nil
	end

	ApplyColorToCosmetic(color, colorType)
	Events.BroadcastToServer("cosmetic.color", color, index, activeCategoryIndex, colorType)
end

local function SpawnColors(palette, panel, previous, colorTable, type)
	local xOffset = 0
	local yOffset = 0
	local rows = 1

	for index, row in ipairs(palette) do
		local button = World.SpawnAsset(COLOR_BUTTON, { parent = panel })

		button:GetChildren()[1]:SetColor(row.color)
		button.pressedEvent:Connect(OnColorPressed, row.color, index, panel, colorTable, type)
		
		button.x = xOffset
		button.y = yOffset

		xOffset = xOffset + 65

		if index % totalItemsPerRow == 0 and index ~= #palette then
			yOffset = yOffset + 65
			xOffset = 0
			rows = rows + 1
		end
	end

	panel.parent.height = 50 + (rows * 65)
	panel.parent.y = previous.y + previous.height + 5
end

local function CreateColors()
	SpawnColors(PRIMARY_COLOR_PALETTE, PRIMARY_COLOR_PANEL, COSMETIC_PANEL, activePrimaryColorButtons, ColorType.PRIMARY)
	SpawnColors(SECONDARY_COLOR_PALETTE, SECONDARY_COLOR_PANEL, PRIMARY_COLOR_PANEL.parent, activeSecondaryColorButtons, ColorType.SECONDARY)
	SpawnColors(TERTIARY_COLOR_PALETTE, TERTIARY_COLOR_PANEL, SECONDARY_COLOR_PANEL.parent, activeTertiaryColorButtons, ColorType.TERTIARY)
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
		CreateColors()
	end
end

OnPrivateDataChanged(LOCAL_PLAYER, "cosmetics")

LOCAL_PLAYER.privateNetworkedDataChangedEvent:Connect(OnPrivateDataChanged)

CLEAR_BUTTON.pressedEvent:Connect(OnClearPressed)

Events.Connect("CosmeticUIToggle", OnUIToggled)