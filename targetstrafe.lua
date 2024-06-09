local UIS = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local RS = game:GetService("RunService")
local Players = game:GetService("Players")

local lplr = Players.LocalPlayer
local lplrchar = lplr.Character or lplr.CharacterAdded:Wait()
local lplrhum = lplrchar:WaitForChild("Humanoid")
local lplrhrp = lplrchar:WaitForChild("HumanoidRootPart")

local Controls = require(lplr.PlayerScripts.PlayerModule):GetControls()
local enabled = false

lplr.CharacterAdded:Connect(function(char)
	lplrchar = char
	lplrhrp = lplrchar:WaitForChild("HumanoidRootPart")
	lplrhum = lplrchar:WaitForChild("Humanoid")
end)
UIS.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.E then
		enabled = not enabled
		StarterGui:SetCore("SendNotification", {
			Title = "Info";
			Text = "Auto-Strafe has been set to "..tostring(enabled);
		})
	end
end)
while true do
	local closest
	local closesthrp
	local closesthum
	local distance
	for _, plr in pairs(Players:GetPlayers()) do
		local char = plr.Character
		if char then
			local enemyhrp = char:FindFirstChild("HumanoidRootPart")
			local enemyhum = char:FindFirstChildOfClass("Humanoid")
			if enemyhrp and enemyhrp:IsA("BasePart") and enemyhum and enemyhum.Health > 0 then
				local distancetemp = (enemyhrp.Position - lplrhrp.Position).Magnitude
				if not closest or distancetemp < distance then
					closest = char
					closesthrp = enemyhrp
					closesthum = enemyhum
					distance = distancetemp
				end
			end
		end
	end
	if enabled and closest then
		Controls:Disable()
		local distance = (closesthrp.Position - lplrhrp.Position).Magnitude
		local leadvector = closesthrp.Position + (closesthum.MoveDirection * closesthum.WalkSpeed) * (distance / lplrhum.WalkSpeed)
		local leaddistance = (leadvector - lplrhrp.Position).Magnitude
		if leaddistance < 2 then
			lplrhum.WalkToPoint = lplrhrp.Position + (lplrhrp.Position - closesthrp.Position)
		else
			lplrhum.WalkToPoint = leadvector
		end
	else
		Controls:Enable()
	end
	task.wait()
end
