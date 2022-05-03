local COSMETIC_CATEGORIES = require(script:GetCustomProperty("CosmeticCategories"))

local playerCosmetics = {}

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

local function CategoryIsEnabled(categoryIndex)
	return COSMETIC_CATEGORIES[categoryIndex].enabled
end

local function CosmeticIsEnabled(categoryIndex, cosmeticIndex)
	if cosmeticIndex == 0 then
		return
	end

	return COSMETIC_CATEGORIES[categoryIndex].cosmetics[cosmeticIndex].enabled
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

Game.playerJoinedEvent:Connect(OnPlayerJoined)
Game.playerLeftEvent:Connect(OnPlayerLeft)