local module = {}

function module.init(player, character, Config, VoiceLines)
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")

    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local dashCooldown = 0
    local canDash = false

    local function setPhase2(mult)
        Config.Dash._PhaseMultiplier = mult
    end

    local function dash()
        local now = tick()
        if now < dashCooldown then return end
        dashCooldown = now + Config.Dash.Cooldown

        local root = humanoidRootPart
        if not root then return end

        local dashTime = Config.Dash.Duration
        local totalDistance = Config.Dash.Distance * (Config.Dash._PhaseMultiplier or 1)
        local startTime = tick()

        VoiceLines.onDash()

        local connection
        connection = RunService.Heartbeat:Connect(function(dt)
            local elapsed = tick() - startTime
            if elapsed >= dashTime then
                connection:Disconnect()
                return
            end

            local forward = root.CFrame.LookVector
            local distancePerFrame = (totalDistance / dashTime) * dt
            root.CFrame = root.CFrame + forward * distancePerFrame
        end)
    end

    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if VoiceLines.canUsePostMonologueAbilities() then
                dash()
            end
        end
    end)

    module.setPhase2 = setPhase2
end

return module
