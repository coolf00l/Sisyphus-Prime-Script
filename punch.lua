local module = {}

function module.init(player, character, Config, VoiceLines)
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")

    local root = character:WaitForChild("HumanoidRootPart")
    local cooldown = 0
    local damageMultiplier = 1
    local dashMultiplier = 1

    local function getEnemiesInFront(range, radius)
        local hits = {}
        for _, model in ipairs(workspace:GetChildren()) do
            local hum = model:FindFirstChildOfClass("Humanoid")
            local hrp = model:FindFirstChild("HumanoidRootPart")
            if hum and hrp and model ~= character then
                local dist = (hrp.Position - root.Position).Magnitude
                if dist <= range then
                    table.insert(hits, hum)
                end
            end
        end
        return hits
    end

    local function primePunchDash()
        local now = tick()
        if now < cooldown then return end
        cooldown = now + 0.5

        VoiceLines.onPunch()

        local dashTime = Config.Dash.Duration
        local totalDistance = Config.Dash.Distance * dashMultiplier
        local startTime = tick()

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

            local enemies = getEnemiesInFront(8, 6)
            for _, hum in ipairs(enemies) do
                hum:TakeDamage(Config.Punch.Damage * damageMultiplier)
                local hrp = hum.Parent:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.Velocity = forward * Config.Punch.Knockback
                end
            end
        end)
    end

    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if VoiceLines.canUsePostMonologueAbilities() then
                primePunchDash()
            end
        end
    end)

    function module.setPhase2(mult)
        damageMultiplier = mult
        dashMultiplier = mult
    end
end

return module
