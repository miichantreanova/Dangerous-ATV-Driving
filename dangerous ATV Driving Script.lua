-- [[ Rscripts Risk Notice ]]
-- This script is not verified by rscripts.net. Deal with caution.
--
-- Stay safe:
--   • Never log in on unofficial Roblox sites or lookalike domains.
--   • Real Roblox links use roblox.com (check the .com ending).
--   • Treat fake Roblox login / "claim reward" pages as phishing.
-- [[ End Rscripts Risk Notice ]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Dangerous ATV Driving | Antigravity",
    LoadingTitle = "Antigravity Script",
    LoadingSubtitle = "by Google Deepmind",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "Antigravity_ATV_WinFarm",
        FileName = "Config"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false,
})

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
end)

-- Variables
local VehicleFlyEnabled = false
local VehicleSpeed = 50
local AutofarmWinEnabled = false

-- Functions
local function GetVehicle()
    local Seat = Humanoid.SeatPart
    if Seat and Seat:IsA("VehicleSeat") then
        return Seat.Parent
    end
    return nil
end

local function TeleportTo(cframe)
    local Vehicle = GetVehicle()
    if Vehicle then
        Vehicle:PivotTo(cframe)
    elseif Character and Character.PrimaryPart then
        Character:PivotTo(cframe)
    end
end

-- Teleport Logic
local function FindAndTeleportWins()
    -- Specific check for known path from debug matches
    local finishLine = Workspace:FindFirstChild("Finish Line")
    if finishLine then
        local part = finishLine:FindFirstChild("Part") or finishLine:FindFirstChildWhichIsA("BasePart")
        if part then
            TeleportTo(part.CFrame)
            return
        end
    end

    -- Fallback search if main path changes
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj.Name == "Finish Line" and obj:IsA("Model") then
             local part = obj:FindFirstChild("Part") or obj:FindFirstChildWhichIsA("BasePart")
             if part then
                 TeleportTo(part.CFrame)
                 return
             end
        end
    end
end

-- Tabs
local AutofarmTab = Window:CreateTab("Autofarm", 4483345998)
local VehicleTab = Window:CreateTab("Vehicle", 4483345998)
local MiscTab = Window:CreateTab("Misc", 4483345998)

-- Autofarm Tab
AutofarmTab:CreateParagraph({Title = "WARNING: HIGH BAN RISK", Content = "Autofarm can lead to a BAN. Use sparingly or on an ALT account. We are not responsible for bans."})

AutofarmTab:CreateToggle({
    Name = "Autofarm Win (Loop)",
    CurrentValue = false,
    Flag = "AutoWin",
    Callback = function(Value)
        AutofarmWinEnabled = Value
        if Value then
            task.spawn(function()
                while AutofarmWinEnabled do
                    FindAndTeleportWins()
                    task.wait(1) -- Delay to prevent instant detection issues
                end
            end)
        end
    end,
})

-- Vehicle Tab
VehicleTab:CreateParagraph({Title = "Instructions", Content = "Sit in a vehicle to use these features."})

VehicleTab:CreateSlider({
    Name = "Boost Speed",
    Range = {0, 500},
    Increment = 5,
    Suffix = "Velocity",
    CurrentValue = 50,
    Flag = "VehicleSpeed",
    Callback = function(Value)
        VehicleSpeed = Value
    end,
})

VehicleTab:CreateButton({
    Name = "Boost Forward",
    Callback = function()
        local Vehicle = GetVehicle()
        if Vehicle and Vehicle.PrimaryPart then
            Vehicle.PrimaryPart.AssemblyLinearVelocity = Vehicle.PrimaryPart.CFrame.LookVector * VehicleSpeed * 5
        elseif Vehicle then
             local Base = Vehicle:FindFirstChild("Chassis") or Vehicle:FindFirstChild("Body") or Vehicle:FindFirstChildWhichIsA("BasePart")
             if Base then
                 Base.AssemblyLinearVelocity = Base.CFrame.LookVector * VehicleSpeed * 5
             end
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "You are not in a vehicle!",
                Duration = 5,
                Image = 4483345998,
            })
        end
    end,
})

VehicleTab:CreateButton({
    Name = "Flip Vehicle",
    Callback = function()
        local Vehicle = GetVehicle()
        if Vehicle then
            local Pivot = Vehicle:GetPivot()
            Vehicle:PivotTo(CFrame.new(Pivot.Position) * CFrame.Angles(0, 0, 0))
        end
    end,
})

VehicleTab:CreateButton({
    Name = "Force Brake",
    Callback = function()
        local Vehicle = GetVehicle()
        if Vehicle then
            for _, part in pairs(Vehicle:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.AssemblyLinearVelocity = Vector3.new(0,0,0)
                    part.AssemblyAngularVelocity = Vector3.new(0,0,0)
                end
            end
        end
    end,
})

VehicleTab:CreateToggle({
    Name = "Vehicle Fly",
    CurrentValue = false,
    Flag = "VehicleFly",
    Callback = function(Value)
        VehicleFlyEnabled = Value
        if Value then
            task.spawn(function()
                while VehicleFlyEnabled do
                    local Vehicle = GetVehicle()
                    if Vehicle and Vehicle.PrimaryPart then
                        local Cam = Workspace.CurrentCamera
                        Vehicle.PrimaryPart.AssemblyLinearVelocity = Vector3.new(0,0,0) -- Anti Gravity
                        
                        local Speed = VehicleSpeed
                        local Velocity = Vector3.new(0,0,0)
                        
                        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                            Velocity = Velocity + Cam.CFrame.LookVector * Speed
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                            Velocity = Velocity - Cam.CFrame.LookVector * Speed
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                            Velocity = Velocity - Cam.CFrame.RightVector * Speed
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                            Velocity = Velocity + Cam.CFrame.RightVector * Speed
                        end
                         if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                            Velocity = Velocity + Vector3.new(0, Speed, 0)
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                            Velocity = Velocity - Vector3.new(0, Speed, 0)
                        end
                        
                        Vehicle.PrimaryPart.AssemblyLinearVelocity = Velocity
                        Vehicle:PivotTo(CFrame.new(Vehicle:GetPivot().Position, Vehicle:GetPivot().Position + Cam.CFrame.LookVector))
                    end
                    RunService.Heartbeat:Wait()
                end
            end)
        end
    end,
})

-- Misc Tab
MiscTab:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end,
})

Rayfield:LoadConfiguration()