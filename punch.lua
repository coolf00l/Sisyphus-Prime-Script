local module = {}

function module.init(player, character, Config, VoiceLines)
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local Workspace = game:GetService("Workspace")

    local root = character:WaitForChild("HumanoidRootPart")

    -- EXACT 0.5s cooldown
    local cooldown = 0
    local COOLDOWN_TIME = 0.5

    local damageMultiplier = 1
    local dashMultiplier = 1

    -- Enemy detection
    local function getEnemiesInFront(range)
        local hits = {}
        for _, inst in ipairs(workspace:GetDescendants()) do
            if inst:IsA("Model") and inst ~= character then
                local hum = inst:FindFirstChildOfClass("Humanoid")
                local hrp = inst:FindFirstChild("HumanoidRootPart")
                if hum and hrp and hum.Health > 0 then
                    local dist = (hrp.Position - root.Position).Magnitude
                    if dist <= range then
                        hits[hum] = hrp
                    end
                end
            end
        end
        return hits
    end

    -- PRIME PUNCH DASH
    local function primePunchDash()
        local now = tick()
        if now < cooldown then return end
        cooldown = now + COOLDOWN_TIME

        VoiceLines.onPunch()

        local dashTime = Config.Dash.Duration
        local totalDistance = Config.Dash.Distance * dashMultiplier
        local startTime = tick()

        local flingActive = true

        local connection
        connection = RunService.Heartbeat:Connect(function(dt)
            local elapsed = tick() - startTime
            if elapsed >= dashTime then
                flingActive = false
                connection:Disconnect()
                return
            end

            local forward = root.CFrame.LookVector
            local distancePerFrame = (totalDistance / dashTime) * dt

            -- Collision raycast
            local ray = Ray.new(root.Position, forward * distancePerFrame)
            local hit, pos = Workspace:FindPartOnRay(ray, character)

            if hit then
                flingActive = false
                connection:Disconnect()
                return
            end

            -- Move forward
            root.CFrame = root.CFrame + forward * distancePerFrame

            -- Hitbox + walkfling-like knockback
            local enemies = getEnemiesInFront(8)
            for hum, hrp in pairs(enemies) do
                hum:TakeDamage(Config.Punch.Damage * damageMultiplier)

                if flingActive then
                    -- Safe walkfling-style velocity burst
                    hrp.AssemblyLinearVelocity = forward * 250
                end
            end
        end)
    end

    -- KEYBIND: M1
    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if VoiceLines.canUsePostMonologueAbilities() then
                primePunchDash()
            end
        end
    end)

    -- Phase 2 scaling
    function module.setPhase2(mult)
        damageMultiplier = mult
        dashMultiplier = mult
    end
end

return module
