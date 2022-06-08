local COSMETIC_CATEGORIES = require(script:GetCustomProperty("CosmeticCategories"))

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

		playerCosmetics[player][categoryIndex] = 0
	end
end

local function CosmeticIsAttached(player, categoryIndex, cosmeticIndex)
	return playerCosmetics[player][categoryIndex] == cosmeticIndex
end

local function ClearCosmetic(player, categoryIndex, cosmeticIndex)
	local cosmetics = playerCosmetics[player][categoryIndex]
	
	if cosmetics ~= nil then
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

		playerCosmetics[player][categoryIndex] = 0
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
				playerCosmetics[player][categoryIndex] = cosmeticIndex
			end
		end
	end
end

local function ApplyColor(player, color, index, categoryIndex, colorType)
	if playerCosmetics[player][categoryIndex] ~= nil and playerCosmetics[player][categoryIndex] ~= 0 then
		local cosmeticIndex = playerCosmetics[player][categoryIndex]
		
		for index, object in ipairs(player:GetAttachedObjects()) do
			if object.name == "Cosmetic Item - [Cat: " .. tostring(categoryIndex) .. ", Item: " .. tostring(cosmeticIndex) .. "]" then
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
		local playerCosmetic = playerCosmetics[player][categoryIndex]

		if playerCosmetic ~= 0 then
			local cosmetic = category.cosmetics[playerCosmetic]

			if cosmetic ~= nil then
				local cosmetic = World.SpawnAsset(cosmetic.template, { networkContext = NetworkContextType.NETWORKED })

				cosmetic.name = "Cosmetic Item - [Cat: " .. tostring(categoryIndex) .. ", Item: " .. tostring(playerCosmetic) .. "]"
				cosmetic:AttachToPlayer(player, category.socket)
			end
		end
	end
end

local function OnPlayerJoined(player)
	playerCosmetics[player] = {}

	for index, row in ipairs(COSMETIC_CATEGORIES) do
		playerCosmetics[player][index] = 0
	end

	local data = Storage.GetPlayerData(player)

	if data.cosmetics ~= nil then
		for cateogryIndex, cosmetic in ipairs(data.cosmetics) do
			if CategoryIsEnabled(cateogryIndex) and CosmeticIsEnabled(cateogryIndex, cosmetic) then
				playerCosmetics[player][cateogryIndex] = cosmetic
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