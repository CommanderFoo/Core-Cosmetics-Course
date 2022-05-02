local PLAYER_POSITION = script:GetCustomProperty("PlayerPosition"):WaitForObject()
local OVERRIDE_PLAYER_SETTINGS = script:GetCustomProperty("OverridePlayerSettings"):WaitForObject()
local DEFAULT_PLAYER_SETTINGS = script:GetCustomProperty("DefaultPlayerSettings"):WaitForObject()

local function EnablePlayer(player)
	DEFAULT_PLAYER_SETTINGS:ApplyToPlayer(player)
end

local function DisablePlayer(player)
	OVERRIDE_PLAYER_SETTINGS:ApplyToPlayer(player)
	player:SetWorldRotation(PLAYER_POSITION:GetWorldRotation())
	player:SetWorldPosition(Vector3.New(PLAYER_POSITION:GetWorldPosition().x, PLAYER_POSITION:GetWorldPosition().y, 132))
	
end

Events.ConnectForPlayer("EnablePlayer", EnablePlayer)
Events.ConnectForPlayer("DisablePlayer", DisablePlayer)