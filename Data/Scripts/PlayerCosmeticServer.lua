local COSMETIC_CATEGORIES = require(script:GetCustomProperty("CosmeticCategories"))

local PRIMARY_COLOR_PALETTE = require(script:GetCustomProperty("PrimaryColorPalette"))
local SECONDARY_COLOR_PALETTE = require(script:GetCustomProperty("SecondaryColorPalette"))
local TERTIARY_COLOR_PALETTE = require(script:GetCustomProperty("TertiaryColorPalette"))

local playerCosmetics = {}

local ColorType = {

	["PRIMARY"] = 1,
	["SECONDARY"] = 2,
	["TERTIARY"] = 3

}

local function ClearCosmeticCategory(player, categoryIndex)
	local category = COSMETIC_CATEGORIES[categoryIndex]

	if category ~= nil then
		local attachedObjects = player:GetAttachedObjects()

		for index, object in ipairs(attachedObjects) do
			if object:GetAttachedToSocketName() == category.socket then
				object:Destroy()
			end
		end

		playerCosmetics[player][categoryIndex] = {}
	end
end

local function CosmeticIsAttached(player, categoryIndex, cosmeticIndex)
	if playerCosmetics[player][categoryIndex] ~= nil and playerCosmetics[player][categoryIndex].cosmetic == cosmeticIndex then
		return true
	end
	
	return false
end

local function ClearCosmetic(player, categoryIndex, cosmeticIndex)
	local cosmetic = playerCosmetics[player][categoryIndex]
	
	if cosmetic ~= nil then
		local attachedObjects = player:GetAttachedObjects()
		local category = COSMETIC_CATEGORIES[categoryIndex]
		local cosmetic = category.cosmetics[cosmeticIndex]

		for index, object in ipairs(attachedObjects) do
			if object:GetAttachedToSocketName() == category.socket then
				local muid, name = CoreString.Split(cosmetic.template, ":")

				if muid == object.sourceTemplateId then
					object:Destroy()
				end
			end
		end

		playerCosmetics[player][categoryIndex] = {}
	end
end

local function ApplyCosmetic(player, categoryIndex, cosmeticIndex)
	local category = COSMETIC_CATEGORIES[categoryIndex]

	if category ~= nil then
		local cosmetics = category.cosmetics

		if cosmetics ~= nil then
			local row = cosmetics[cosmeticIndex]

			if row ~= nil then
				if CosmeticIsAttached(player, categoryIndex, cosmeticIndex) then
					ClearCosmetic(player, categoryIndex, cosmeticIndex)
					return
				end

				ClearCosmeticCategory(player, categoryIndex)
				
				local cosmetic = World.SpawnAsset(row.template, { networkContext = NetworkContextType.NETWORKED })

				cosmetic.name = "Cosmetic Item - [Cat: " .. tostring(categoryIndex) .. ", Item: " .. tostring(cosmeticIndex) .. "]"
				cosmetic:AttachToPlayer(player, category.socket)
				playerCosmetics[player][categoryIndex].cosmetic = cosmeticIndex
			end
		end
	end
end

local function FetchColor(index, colorType)
	local palette = PRIMARY_COLOR_PALETTE

	if colorType == ColorType.SECONDARY then
		palette = SECONDARY_COLOR_PALETTE
	elseif colorType == ColorType.TERTIARY then
		palette = TERTIARY_COLOR_PALETTE
	end

	if palette[index] ~= nil and not palette[index].disabled then
		return palette[index].color
	end

	return nil
end

local function UpdateColorProps(object, colorIndex, colorType)
	local color = FetchColor(colorIndex, colorType)
	local prop = "PrimaryColor"

	if colorType == ColorType.SECONDARY then
		prop = "SecondaryColor"
	elseif colorType == ColorType.TERTIARY then
		prop = "TertiaryColor"
	end

	if color == nil then
		object:SetCustomProperty(prop, Color.New(0, 0, 0, 0))
	else
		object:SetCustomProperty(prop, color)
	end
end

local function ApplyColor(player, colorIndex, categoryIndex, colorType)
	local item = playerCosmetics[player][categoryIndex]

	if item and item.cosmetic ~= nil and item.cosmetic ~= 0 then
		local cosmeticIndex = item.cosmetic

		if colorType == ColorType.PRIMARY then
			item.primary = colorIndex
		elseif colorType == ColorType.SECONDARY then
			item.secondary = colorIndex
		elseif colorType == ColorType.TERTIARY then
			item.tertiary = colorIndex
		end

		for index, object in ipairs(player:GetAttachedObjects()) do
			if object.name == "Cosmetic Item - [Cat: " .. tostring(categoryIndex) .. ", Item: " .. tostring(cosmeticIndex) .. "]" then
				UpdateColorProps(object, colorIndex, colorType)

				break
			end
		end
	end
end

local function CategoryIsEnabled(categoryIndex)
	return not COSMETIC_CATEGORIES[categoryIndex].disabled
end

local function CosmeticIsEnabled(categoryIndex, cosmeticIndex)
	if cosmeticIndex == 0 then
		return
	end

	return not COSMETIC_CATEGORIES[categoryIndex].cosmetics[cosmeticIndex].disabled
end

local function EquipPlayerCosmetics(player)
	for categoryIndex, category in ipairs(COSMETIC_CATEGORIES) do
		local cosmeticItem = playerCosmetics[player][categoryIndex]

		if cosmeticItem ~= nil and cosmeticItem.cosmetic ~= 0 then
			local cosmetic = category.cosmetics[cosmeticItem.cosmetic]

			if cosmetic ~= nil then
				local cosmetic = World.SpawnAsset(cosmetic.template, { networkContext = NetworkContextType.NETWORKED })

				cosmetic.name = "Cosmetic Item - [Cat: " .. tostring(categoryIndex) .. ", Item: " .. tostring(cosmeticItem.cosmetic) .. "]"
				cosmetic:AttachToPlayer(player, category.socket)

				UpdateColorProps(cosmetic, cosmeticItem.primary, ColorType.PRIMARY)
				UpdateColorProps(cosmetic, cosmeticItem.secondary, ColorType.SECONDARY)
				UpdateColorProps(cosmetic, cosmeticItem.tertiary, ColorType.TERTIARY)
			end
		end
	end
end

local function OnPlayerJoined(player)
	playerCosmetics[player] = {}

	local data = Storage.GetPlayerData(player)

	if data.cosmetics ~= nil then
		for categoryIndex, entry in ipairs(data.cosmetics) do
			if CategoryIsEnabled(categoryIndex) and CosmeticIsEnabled(categoryIndex, entry.cosmetic) then
				playerCosmetics[player][categoryIndex] = { cosmetic = entry.cosmetic }
			end

			if playerCosmetics[player][categoryIndex] ~= nil then
				playerCosmetics[player][categoryIndex].primary = entry.primary or 0
				playerCosmetics[player][categoryIndex].secondary = entry.secondary or 0
				playerCosmetics[player][categoryIndex].tertiary = entry.tertiary or 0
			end
		end

		EquipPlayerCosmetics(player)
		player:SetPrivateNetworkedData("cosmetics", data.cosmetics)
	end
end

local function OnPlayerLeft(player)
	local data = Storage.GetPlayerData(player)

	data.cosmetics = playerCosmetics[player]
	Storage.SetPlayerData(player, data)
	playerCosmetics[player] = nil
end

Events.ConnectForPlayer("cosmetic.apply", ApplyCosmetic)
Events.ConnectForPlayer("cosmetic.clear", ClearCosmeticCategory)
Events.ConnectForPlayer("cosmetic.color", ApplyColor)

Game.playerJoinedEvent:Connect(OnPlayerJoined)
Game.playerLeftEvent:Connect(OnPlayerLeft)