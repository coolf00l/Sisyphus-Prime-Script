local module = {}

local monologueFinished = false
local getMonologueState

function module.init(player, character, Config)
    local TextChatService = game:GetService("TextChatService")
    local humanoid = character:WaitForChild("Humanoid")
    local halfHealthTriggered = false

    local function sendChat(msg)
        TextChatService.TextChannels.RBXGeneral:SendAsync(msg)
    end

    humanoid.HealthChanged:Connect(function(newHealth)
        if not halfHealthTriggered and newHealth <= humanoid.MaxHealth / 2 then
            halfHealthTriggered = true
            sendChat("YES! That's it!")
        end
    end)

    module._sendChat = sendChat
end

function module.registerMonologueState(fn)
    getMonologueState = fn
end

function module.onMonologueFinished()
    monologueFinished = true
end

function module.canUsePostMonologueAbilities()
    if not getMonologueState then return false end
    local playedOnce, active = getMonologueState()
    return playedOnce and not active
end

function module.onDash()
end

function module.onPunch()
end

function module.onShockwave()
end

function module.onPhase2()
    module._sendChat("YES! THAT'S IT! SHOW ME MORE!")
end

return module
