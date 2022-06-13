local PRIMARY_COLOR_PALETTE = require(script:GetCustomProperty("PrimaryColorPalette"))
local SECONDARY_COLOR_PALETTE = require(script:GetCustomProperty("SecondaryColorPalette"))
local TERTIARY_COLOR_PALETTE = require(script:GetCustomProperty("TertiaryColorPalette"))

local COLOR_BUTTON = script:GetCustomProperty("ColorButton")

local COSMETIC_PANEL = nil
local COSMETIC_CATEGORIES = nil
local PRIMARY_COLOR_PANEL = nil
local SECONDARY_COLOR_PANEL = nil
local TERTIARY_COLOR_PANEL = nil

local LOCAL_PLAYER = Game.GetLocalPlayer()

local activePrimaryColorButtons = {}
local activeSecondaryColorButtons = {}
local activeTertiaryColorButtons = {}

local ColorType = {

	["PRIMARY"] = 1,
	["SECONDARY"] = 2,
	["TERTIARY"] = 3

}

local activeCosmetics = {}
local itemsPerRow = 0
local activeCategoryIndex = 1

local ButtonColors = {}

function ButtonColors.Set(opts)
	COSMETIC_PANEL = opts.cosmeticPanel
	PRIMARY_COLOR_PANEL = opts.primary
	SECONDARY_COLOR_PANEL = opts.secondary
	TERTIARY_COLOR_PANEL = opts.tertiary
	COSMETIC_CATEGORIES = opts.cosmeticCategories
	activeCosmetics = opts.activeCosmetics
	itemsPerRow = opts.itemsPerRow
end

function ButtonColors.UpdateCategoryIndex(index)
	activeCategoryIndex = index
end

function ButtonColors.ClearActiveColors(categoryIndex)
	if activePrimaryColorButtons[categoryIndex] ~= nil and activePrimaryColorButtons[categoryIndex][PRIMARY_COLOR_PANEL] ~= nil then
		local button = activePrimaryColorButtons[categoryIndex][PRIMARY_COLOR_PANEL]

		if button ~= nil then
			button:SetButtonColor(button:GetDisabledColor())
		end
	end

	if activeSecondaryColorButtons[categoryIndex] ~= nil and activeSecondaryColorButtons[categoryIndex][SECONDARY_COLOR_PANEL] ~= nil then
		local button = activeSecondaryColorButtons[categoryIndex][SECONDARY_COLOR_PANEL]

		if button ~= nil then
			button:SetButtonColor(button:GetDisabledColor())
		end
	end

	if activeTertiaryColorButtons[categoryIndex] ~= nil and activeTertiaryColorButtons[categoryIndex][TERTIARY_COLOR_PANEL] ~= nil then
		local button = activeTertiaryColorButtons[categoryIndex][TERTIARY_COLOR_PANEL]

		if button ~= nil then
			button:SetButtonColor(button:GetDisabledColor())
		end
	end
end

function ButtonColors.EnableDisableColors(row)
	local primaryColors = PRIMARY_COLOR_PANEL:GetChildren()
	local secondaryColors = SECONDARY_COLOR_PANEL:GetChildren()
	local tertiaryColors = TERTIARY_COLOR_PANEL:GetChildren()
	local row = {

		has_primary = false,
		has_secondary = false,
		has_tertiary = false

	}

	if COSMETIC_CATEGORIES[activeCategoryIndex] ~= nil and activeCosmetics[activeCategoryIndex] ~= nil and COSMETIC_CATEGORIES[activeCategoryIndex].cosmetics ~= nil then
		if COSMETIC_CATEGORIES[activeCategoryIndex].cosmetics[activeCosmetics[activeCategoryIndex]] ~= nil then
			row = COSMETIC_CATEGORIES[activeCategoryIndex].cosmetics[activeCosmetics[activeCategoryIndex]]
		end
	end

	if row.has_primary then
		PRIMARY_COLOR_PANEL.opacity = 1
	else
		PRIMARY_COLOR_PANEL.opacity = .4
	end

	for c, color in ipairs(primaryColors) do
		if not row.has_primary then
			color.isInteractable = false
		else
			color.isInteractable = true
		end
	end

	if row.has_secondary then
		SECONDARY_COLOR_PANEL.opacity = 1
	else
		SECONDARY_COLOR_PANEL.opacity = .4
	end

	for c, color in ipairs(secondaryColors) do
		if not row.has_secondary then
			color.isInteractable = false
		else
			color.isInteractable = true
		end
	end

	if row.has_tertiary then
		TERTIARY_COLOR_PANEL.opacity = 1
	else
		TERTIARY_COLOR_PANEL.opacity = .4
	end

	for c, color in ipairs(tertiaryColors) do
		if not row.has_tertiary then
			color.isInteractable = false
		else
			color.isInteractable = true
		end
	end
end

function ButtonColors.ResetButtonColors(newCategoryIndex)
	for catIndex, category in pairs(activePrimaryColorButtons) do
		if category[PRIMARY_COLOR_PANEL] ~= nil then
			if catIndex ~= newCategoryIndex then
				category[PRIMARY_COLOR_PANEL]:SetButtonColor(category[PRIMARY_COLOR_PANEL]:GetDisabledColor())
			else
				category[PRIMARY_COLOR_PANEL]:SetButtonColor(category[PRIMARY_COLOR_PANEL]:GetHoveredColor())
			end
		end
	end

	for catIndex, category in pairs(activeSecondaryColorButtons) do
		if category[SECONDARY_COLOR_PANEL] ~= nil then
			if catIndex ~= newCategoryIndex then
				category[SECONDARY_COLOR_PANEL]:SetButtonColor(category[SECONDARY_COLOR_PANEL]:GetDisabledColor())
			else
				category[SECONDARY_COLOR_PANEL]:SetButtonColor(category[SECONDARY_COLOR_PANEL]:GetHoveredColor())
			end
		end
	end

	for catIndex, category in pairs(activeTertiaryColorButtons) do
		if category[TERTIARY_COLOR_PANEL] ~= nil then
			if catIndex ~= newCategoryIndex then
				category[TERTIARY_COLOR_PANEL]:SetButtonColor(category[TERTIARY_COLOR_PANEL]:GetDisabledColor())
			else
				category[TERTIARY_COLOR_PANEL]:SetButtonColor(category[TERTIARY_COLOR_PANEL]:GetHoveredColor())
			end
		end
	end
end

function ButtonColors.UpdatePalettes(newCategoryIndex)
	ButtonColors.ResetButtonColors(newCategoryIndex)

	activeCategoryIndex = newCategoryIndex
	PRIMARY_COLOR_PANEL.parent.y = COSMETIC_PANEL.y + COSMETIC_PANEL.height + 5
	SECONDARY_COLOR_PANEL.parent.y = PRIMARY_COLOR_PANEL.parent.y + PRIMARY_COLOR_PANEL.parent.height + 5
	TERTIARY_COLOR_PANEL.parent.y = SECONDARY_COLOR_PANEL.parent.y + SECONDARY_COLOR_PANEL.parent.height + 5
end

function ButtonColors.AddCategory(index)
	activePrimaryColorButtons[index] = {}
	activeSecondaryColorButtons[index] = {}
	activeTertiaryColorButtons[index] = {}
end

function ButtonColors.SetSlotColor(slot, color)
	if color == nil then
		slot:ResetColor()
	else
		slot:SetColor(color)
	end
end

function ButtonColors.ApplyColorToCosmetic(color, colorType)
	if activeCosmetics[activeCategoryIndex] ~= nil and activeCosmetics[activeCategoryIndex] ~= 0 then
		for index, object in ipairs(LOCAL_PLAYER:GetAttachedObjects()) do
			if object.name == "Cosmetic Item - [Cat: " .. tostring(activeCategoryIndex) .. ", Item: " .. tostring(activeCosmetics[activeCategoryIndex]) .. "]" then
				local meshes = object:FindDescendantsByType("StaticMesh")

				for m, mesh in ipairs(meshes) do
					if mesh:GetCustomProperty("Ignore") == nil or not mesh:GetCustomProperty("Ignore") then
						local materialSlots = mesh:GetMaterialSlots()

						for s, slot in ipairs(materialSlots) do
							local condition = (
								colorType == ColorType.PRIMARY and string.find(tostring(slot), "BaseMaterial")

								or

								colorType == ColorType.SECONDARY and string.find(tostring(slot), "Detail1")

								or

								colorType == ColorType.TERTIARY and string.find(tostring(slot), "Detail2")
							)

							if condition then
								ButtonColors.SetSlotColor(slot, color)
							end
						end
					end
				end
			end
		end
	end
end

function ButtonColors.OnColorPressed(button, color, index, panel, colorTable, colorType)
	if colorTable[activeCategoryIndex][panel] == nil then
		colorTable[activeCategoryIndex][panel] = button
		button:SetButtonColor(button:GetHoveredColor())
		ButtonColors.ApplyColorToCosmetic(color, colorType)
		Events.BroadcastToServer("cosmetic.color", color, index, activeCategoryIndex, colorType)
		return
	end

	local removingColor = false

	if button == colorTable[activeCategoryIndex][panel] then
		if button:GetButtonColor() == colorTable[activeCategoryIndex][panel]:GetDisabledColor() then
			button:SetButtonColor(button:GetHoveredColor())
		else
			removingColor = true
			button:SetButtonColor(button:GetDisabledColor())
		end
	else
		button:SetButtonColor(button:GetHoveredColor())
		colorTable[activeCategoryIndex][panel]:SetButtonColor(colorTable[activeCategoryIndex][panel]:GetDisabledColor())
		colorTable[activeCategoryIndex][panel] = button
	end

	if removingColor then
		color = nil
	end

	ButtonColors.ApplyColorToCosmetic(color, colorType)
	Events.BroadcastToServer("cosmetic.color", color, index, activeCategoryIndex, colorType)
end

local function SpawnColors(type)
	local xOffset = 0
	local yOffset = 0
	local rows = 1
	local previous = COSMETIC_PANEL
	local palette = PRIMARY_COLOR_PALETTE
	local panel = PRIMARY_COLOR_PANEL
	local colorTable = activePrimaryColorButtons

	if type == ColorType.SECONDARY then
		previous = PRIMARY_COLOR_PANEL.parent
		palette = SECONDARY_COLOR_PALETTE
		panel = SECONDARY_COLOR_PANEL
		colorTable = activeSecondaryColorButtons
	elseif type == ColorType.TERTIARY then
		previous = SECONDARY_COLOR_PANEL.parent
		palette = TERTIARY_COLOR_PALETTE
		panel = TERTIARY_COLOR_PANEL
		colorTable = activeTertiaryColorButtons
	end

	for index, row in ipairs(palette) do
		local button = World.SpawnAsset(COLOR_BUTTON, { parent = panel })

		button:GetChildren()[1]:SetColor(row.color)
		button.pressedEvent:Connect(ButtonColors.OnColorPressed, row.color, index, panel, colorTable, type)
		
		button.x = xOffset
		button.y = yOffset

		xOffset = xOffset + 65

		if index % itemsPerRow == 0 and index ~= #palette then
			yOffset = yOffset + 65
			xOffset = 0
			rows = rows + 1
		end
	end

	panel.parent.height = 50 + (rows * 65)
	panel.parent.y = previous.y + previous.height + 5
end

function ButtonColors.CreateColors()
	SpawnColors(ColorType.PRIMARY)
	SpawnColors(ColorType.SECONDARY)
	SpawnColors(ColorType.TERTIARY)
end

return ButtonColors