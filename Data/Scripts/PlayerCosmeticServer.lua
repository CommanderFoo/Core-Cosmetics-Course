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

		playerCosmetics[player][categoryIndex] = {}
	end
end

local function CosmeticIsAttached(player, categoryIndex, cosmeticIndex)
	for index, cosmetic in ipairs(playerCosmetics[player][categoryIndex]) do
		if cosmetic == cosmeticIndex then
			return true
		end
	end

	return false
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
					for ci, c in ipairs(cosmetics) do
						if(c == cosmeticIndex) then
							table.remove(cosmetics, ci)
							break
						end
					end

					object:Destroy()
				end
			end
		end
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

				if not row.stackable then
					ClearCosmeticCategory(player, categoryIndex)
				end

				local cosmetic = World.SpawnAsset(row.template, { networkContext = NetworkContextType.NETWORKED })

				cosmetic.name = "Cosmetic Item - [Cat: " .. tostring(categoryIndex) .. ", Item: " .. tostring(cosmeticIndex) .. "]"
				cosmetic:AttachToPlayer(player, category.socket)
				table.insert(playerCosmetics[player][categoryIndex], cosmeticIndex)
			end
		end
	end
end

local function OnPlayerJoined(player)
	playerCosmetics[player] = {}

	for index, row in ipairs(COSMETIC_CATEGORIES) do
		playerCosmetics[player][index] = {}
	end
end

-- TODO: Destroy?
local function OnPlayerLeft(player)
	playerCosmetics[player] = nil
end

Events.ConnectForPlayer("cosmetic.apply", ApplyCosmetic)
Events.ConnectForPlayer("cosmetic.clear", ClearCosmeticCategory)

Game.playerJoinedEvent:Connect(OnPlayerJoined)
Game.playerLeftEvent:Connect(OnPlayerLeft)