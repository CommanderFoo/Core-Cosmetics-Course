local INTERACTION_TRIGGER = script:GetCustomProperty("InteractionTrigger"):WaitForObject()
local INTERACTION_LABEL = script:GetCustomProperty("InteractionLabel"):WaitForObject()
local UIPANEL = script:GetCustomProperty("UIPanel"):WaitForObject()
local EVENT = script:GetCustomProperty("Event")

local LOCAL_PLAYER = Game.GetLocalPlayer()
local isOpen = false
local isInsideArea = false

local function ToggleCursorAndUI(cursorValue, uiValue)
	UI.SetCursorVisible(cursorValue)
	UI.SetCanCursorInteractWithUI(cursorValue)
	INTERACTION_LABEL.visibility = uiValue and Visibility.FORCE_OFF or Visibility.FORCE_ON
	UIPANEL.visibility = uiValue and Visibility.FORCE_ON or Visibility.FORCE_OFF
	Events.Broadcast(EVENT, uiValue)
end

local function OnTriggerEnter(trigger, other)
	if other:IsA("Player") and other == LOCAL_PLAYER then
		INTERACTION_LABEL.visibility = Visibility.FORCE_ON
		isInsideArea = true
	end
end

local function OnTriggerExit(trigger, other)
	if other:IsA("Player") and other == LOCAL_PLAYER then
		INTERACTION_LABEL.visibility = Visibility.FORCE_OFF
		isInsideArea = false
		isOpen = false
		ToggleCursorAndUI(false, true)
	end
end

local function OnActionPressed(player, action)
	if action == "Open / Close Appearance Modifier" and isInsideArea then
		isOpen = not isOpen
		ToggleCursorAndUI(isOpen, isOpen)

		if isOpen then
			Events.BroadcastToServer("DisablePlayer")
			Events.Broadcast("EnableOverrideCamera")
		else
			Events.BroadcastToServer("EnablePlayer")
			Events.Broadcast("DisableOverrideCamera")
		end
	end
end

Input.actionPressedEvent:Connect(OnActionPressed)
INTERACTION_TRIGGER.beginOverlapEvent:Connect(OnTriggerEnter)
INTERACTION_TRIGGER.endOverlapEvent:Connect(OnTriggerExit)