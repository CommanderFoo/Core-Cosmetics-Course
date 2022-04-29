local CAMERA = script:GetCustomProperty("Camera"):WaitForObject()
local LOCAL_PLAYER = Game.GetLocalPlayer()

local function EnableOverrideCamera()
	LOCAL_PLAYER:SetOverrideCamera(CAMERA)
end

local function DisableOverrideCamera()
	LOCAL_PLAYER:ClearOverrideCamera()
end

Events.Connect("EnableOverrideCamera", EnableOverrideCamera)
Events.Connect("DisableOverrideCamera", DisableOverrideCamera)