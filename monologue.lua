local module = {}

function module.init(player, character, Config, VoiceLines)
    local TextChatService = game:GetService("TextChatService")
    local UserInputService = game:GetService("UserInputService")

    local lines = {
        "A visitor? Hmm… Indeed, I have slept long enough.",
        "The kingdom of heaven has long since forgotten my name, and I am EAGER to make them remember.",
        "However, the blood of Minos stains your hands, and I must admit… I'm curious about your skills, Weapon.",
        "And so, before I tear down the cities and CRUSH the armies of heaven…",
        "You shall do as an appetizer.",
        "Come forth, Child of Man…",
        "And DIE."
    }

    local secondsPerCharacter = 0.06
    local monologueActive = false
    local playedOnce = false

    local function sendChat(msg)
        TextChatService.TextChannels.RBXGeneral:SendAsync(msg)
    end

    local function playMonologue()
        if playedOnce or monologueActive then return end
        monologueActive = true

        task.spawn(function()
            local previousLength = 0

            for i, text in ipairs(lines) do
                if i > 1 then
                    local delayTime = (previousLength * secondsPerCharacter) * 1.40
                    task.wait(delayTime)
                end

                sendChat(text)
                previousLength = #text
            end

            monologueActive = false
            playedOnce = true
            VoiceLines.onMonologueFinished()
        end)
    end

    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == Enum.KeyCode.T then
            playMonologue()
        end
    end)

    VoiceLines.registerMonologueState(function()
        return playedOnce, monologueActive
    end)
end

return module
