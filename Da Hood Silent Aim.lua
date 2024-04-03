local aimbot = loadstring(game:HttpGet("https://raw.githubusercontent.com/CITY512/modules/main/aimbot.lua"))()

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Ping
local FOV

local FOVCircle

if Drawing then
    FOVCircle = Drawing.new("Circle")
    FOVCircle.Transparency = 0
    FOVCircle.Thickness = 2
    FOVCircle.Radius = FOV
    FOVCircle.Filled = false
    FOVCircle.Visible = true
end

function GetClosestPlayer()
    local closest
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local lplrhrp = LocalPlayer.Character.HumanoidRootPart
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local character = player.Character
                if character then
                    local NPCRoot = character:FindFirstChild("HumanoidRootPart")
                    if NPCRoot then
                        local viewportpoint, onscreen = Camera:WorldToScreenPoint(NPCRoot.Position)
                        local distance = (Vector2.new(viewportpoint.X,viewportpoint.Y) - point).Magnitude
                        local distancefromplayer = (NPCRoot.Position - lplrhrp.Position).Magnitude

                        if onscreen and distance <= AimbotSettings.FOV then
                            if not closest or distance < (closest.HumanoidRootPart.Position - lplrhrp.Position).Magnitude and distancefromplayer <= maxdist then
                                closest = character
                            end
                        end
                    end
                end
            end
        end
    end
    return closest
end

UserInputService.InputChanged:Connect(function(input)
    if FOVCircle then
        local mouselocation = UserInputService:GetMouseLocation()
        FOVCircle.Position = mouselocation
    end
end)

local index
index = hookmetamethod(game, "__index", function(obj, idx)
    if obj:IsA("Mouse") and idx == "Hit" then 
        local target = GetClosestPlayer()
        return target and CFrame.new(aimbot:ComputePathAsync(LocalPlayer.Character.HumanoidRootPart.Position,target,0,0,{},true,AimbotSettings.Ping,0,true)) or index(obj, idx)
    end

    return index(obj, idx) 
end)
