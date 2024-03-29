local closest
local LocalPlayer = game.Players.LocalPlayer
local NPCChar = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local NPCRoot = NPCChar:WaitForChild("HumanoidRootPart")
local NPCHumanoid = NPCChar:WaitForChild("Humanoid")

local Controls = require(LocalPlayer.PlayerScripts.PlayerModule):GetControls()

local rotationangle = 0
local rotationdirection = 1
local distance = math.random(8,20)

LocalPlayer.CharacterAdded:Connect(function(char)
	print("character added")
	NPCChar = char
	NPCRoot = NPCChar:WaitForChild("HumanoidRootPart")
	NPCHumanoid = NPCChar:WaitForChild("Humanoid")
	print(NPCRoot,NPCHumanoid)
end)
while true do
	closest = nil
	local part
	if NPCChar and NPCRoot and NPCHumanoid then
		for _, v in pairs(workspace:GetChildren()) do
			if v.ClassName == "Model" and v ~= NPCChar then
				local TargetRoot = v:FindFirstChild("HumanoidRootPart")
				if TargetRoot and TargetRoot:IsA("BasePart") then
					local closestplayer = game.Players:GetPlayerFromCharacter(TargetRoot.Parent)
					if closestplayer and closestplayer.Team ~= LocalPlayer.Team then
						local distance = (TargetRoot.Position - NPCRoot.Position).Magnitude
						if not closest or distance < (closest.Position - NPCRoot.Position).Magnitude then
							closest = TargetRoot
						end
					end
				end
			end
		end
		if closest then
			local closestHumanoid = closest.Parent:FindFirstChildOfClass("Humanoid")
			if closestHumanoid and closestHumanoid.Health > 0 then
				if (closest.Position + closestHumanoid.MoveDirection * 3 - NPCRoot.Position).Magnitude <= 6 then
					NPCRoot.CFrame = CFrame.new(NPCRoot.Position,closest.Position * Vector3.new(1,0,1) + NPCRoot.Position * Vector3.new(0,1,0))
					walkpos = NPCRoot.Position - closest.Position
				elseif (closest.Position - NPCRoot.Position).Magnitude <= 32 then
					NPCRoot.CFrame = CFrame.new(NPCRoot.Position,closest.Position * Vector3.new(1,0,1) + NPCRoot.Position * Vector3.new(0,1,0))
					walkpos = closest.Position + CFrame.Angles(0,math.rad(rotationangle),0).LookVector * distance
					NPCHumanoid.Jump = true
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
						NPCHumanoid.WalkToPoint = walkpos
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
		else
			Controls:Enable()
		end
	end
	task.wait()
	--part:Destroy()
end
