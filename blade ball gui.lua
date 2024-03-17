repeat task.wait() until game.Players.LocalPlayer

local replicatedstorage = game:GetService("ReplicatedStorage")

local remotes = replicatedstorage:WaitForChild("Remotes")
local parrybuttonpress = remotes:WaitForChild("ParryButtonPress")
local abilitybuttonpress = remotes:WaitForChild("AbilityButtonPress")

local ballsfolder = workspace:WaitForChild("Balls")
local alivefolder = workspace:WaitForChild("Alive")

local configs = {
	AutoParry = false;
	RagingAndRaptures = false;
	MaxAngle = 135;
	ShowCalculations = false;
}

local lplr = game.Players.LocalPlayer
local char = lplr.Character or lplr.CharacterAdded:Wait()
local balls = {}
local closestball

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wizard"))()

local BladeBallWindow = library:NewWindow("Blade Ball")
local MainSection = BladeBallWindow:NewSection("Main")

MainSection:CreateToggle("Auto Parry", function(value)
	configs.AutoParry = value
end)
MainSection:CreateToggle("Raging & Raptures", function(value)
	configs.RagingAndRaptures = value
end)
MainSection:CreateSlider("Slider", 0, 360, configs.MaxAngle, false, function(value)
	configs.MaxAngle = value
end)
MainSection:CreateToggle("Show Calculations", function(value)
	configs.ShowCalculations = value
end)
while true do
	table.clear(balls)
	closestball = nil
	local playergui = lplr:FindFirstChild("PlayerGui")
	
	local char = lplr.Character
	if char and char.Parent == alivefolder then
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if hrp then
			for _, child in pairs(ballsfolder:GetChildren()) do
				if closestball:IsA("Part") and child:GetAttribute("realBall") and closestball:FindFirstChildOfClass("Highlight") then
					table.insert(balls,child)
					local dist = (child.Position - hrp.Position).Magnitude
					if not closestball or dist < (hrp.Position - closestball.Position).Magnitude then
						closestball = child
					end
				end
			end
			if closestball then
				if configs.AutoParry and closestball.Highlight then
					local parrysize = closestball.Velocity.Magnitude * stats().PerformanceStats.Ping:GetValue() / 1000
					
					if (hrp.Position - closestball.Position).Magnitude >= parrysize then
						local x,y,z = CFrame.new(closestball.Position,hrp.Position):ToEulerAnglesYXZ()
						local aim_target_look = Vector3.new(x,y,z)
						
						local x,y,z = CFrame.new(closestball.Position,closestball.Position + closestball.Velocity.Unit):ToEulerAnglesYXZ()
						local aim_velocityunit_look = Vector3.new(x,y,z)

						local diff = aim_target_look - aim_velocityunit_look
						
						if math.deg(diff.X) <= configs.MaxAngle and math.deg(diff.X) >= -configs.MaxAngle and math.deg(diff.Y) <= configs.MaxAngle and math.deg(diff.Y) >= -configs.MaxAngle then
							local hotbar = playergui:FindFirstChild("Hotbar")
							
							if hotbar then
								if configs.RagingAndRaptures then
									local Ability = hotbar:FindFirstChild("Ability")
									local Abilities = char:FindFirstChild("Abilities")
									
									if Ability and Abilities then
										local RagingDeflection = Abilities:FindFirstChild("Raging Deflection")
										local Raptures = Abilities:FindFirstChild("Raptures")
										
										if RagingDeflection and RagingDeflection.Enabled or Raptures and Raptures.Enabled then
											local AbilityUIGradient = Ability:FindFirstChildOfClass("UIGradient")
											
											if AbilityUIGradient and AbilityUIGradient.Offset.Y <= 0.5 then
												abilitybuttonpress:Fire()
											end
										end
									end
								else
									local Block = hotbar:FindFirstChild("Block")
									if Block then
										local BlockUIGradient = Block:FindFirstChildOfClass("UIGradient")
										
										if BlockUIGradient and BlockUIGradient.Offset.Y <= 0.5 then
											parrybuttonpress:Fire()
										end
									end
								end
							end
						end
					end
				end
				if configs.ShowCalculations then
					
				end
			end
		end
	end
	task.wait()
end
