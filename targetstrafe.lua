local closest
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local LPlrChar = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local LPlrRoot = LPlrChar:WaitForChild("HumanoidRootPart")
local LPlrHumanoid = LPlrChar:WaitForChild("Humanoid")

local Controls = require(LocalPlayer.PlayerScripts.PlayerModule):GetControls()

local rotationangle = 0
local rotationdirection = 1
local distance = math.random(8,20)

LocalPlayer.CharacterAdded:Connect(function(char)
	LPlrChar = char
	LPlrRoot = NPCChar:WaitForChild("HumanoidRootPart")
	LPlrHumanoid = NPCChar:WaitForChild("Humanoid")
end)
while true do
	closest = nil
	local part
	if LPlrChar and LPlrRoot and LPlrHumanoid then
		for _, NPC in pairs(Players:GetPlayers()) do
			if NPC ~= LocalPlayer and (not NPC.Team or NPC.Team ~= LocalPlayer.Team) then
				local NPCChar = NPC.Character
				if NPCChar then
					local NPCHum = NPCChar:FindFirstChildOfClass("Humanoid")
					local NPCRoot = NPCChar:FindFirstChild("HumanoidRootPart")
					if NPCHum and NPCHum.Health > 0 and NPCRoot and NPCRoot:IsA("BasePart") then
						local distance = (NPCRoot.Position - LPlrRoot.Position).Magnitude
						if not closest or distance < (closest.Position - LPlrRoot.Position).Magnitude then
							closest = NPCRoot
						end
					end
				end
			end
			if closest then
				local closestHumanoid = closest.Parent:FindFirstChildOfClass("Humanoid")
				if (closest.Position + closestHumanoid.MoveDirection * 3 - LPlrRoot.Position).Magnitude <= 10 then
					LPlrRoot.CFrame = CFrame.new(LPlrRoot.Position,closest.Position * Vector3.new(1,0,1) + LPlrRoot.Position * Vector3.new(0,1,0))
					walkpos = LPlrRoot.Position - closest.Position
				elseif (closest.Position - LPlrRoot.Position).Magnitude <= 32 then
					LPlrRoot.CFrame = CFrame.new(LPlrRoot.Position,closest.Position * Vector3.new(1,0,1) + LPlrRoot.Position * Vector3.new(0,1,0))
					walkpos = closest.Position + CFrame.Angles(0,math.rad(rotationangle),0).LookVector * distance
					LPlrHumanoid.Jump = true
					rotationangle += rotationdirection * 3
					if math.random(1,50) == 1 then
						rotationdirection = -rotationdirection -- Changes the pivot direction
					end
					if math.random(1,25) == 1 then
						distance = math.random(8,20) -- Changes the distance
					end
				end
				if walkpos then
					local raycastParams = RaycastParams.new()
					raycastParams.FilterDescendantsInstances = {closest.Parent}
					raycastParams.FilterType = Enum.RaycastFilterType.Exclude

					local raycast = workspace:Raycast(walkpos,Vector3.new(0,-10000,0),raycastParams)
					if raycast and raycast.Position then
						Controls:Disable()
						LPlrHumanoid.WalkToPoint = walkpos
					else
						Controls:Enable()
					end
				else
					Controls:Enable()
				end

				--part = Instance.new("Part", workspace)
				--part.Anchored = true
				--part.CanCollide = false
				--part.BrickColor = BrickColor.new("Really Really red")
				--part.Size = Vector3.new(1,1,1)
				--part.Shape = Enum.PartType.Ball
				--part.Position = walkpos
			else
				Controls:Enable()
			end
		end
		task.wait()
		--part:Destroy()
	end
end
