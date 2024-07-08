local RS = game:GetService("RunService")
local Players = game:GetService("Players")
local lplr = Players.LocalPlayer
local mouse = lplr:GetMouse()
local playermodule = require(game.Players.LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"))
local controls = playermodule:GetControls()
local char = lplr.Character or lplr.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")
local pivotangle = 0
local pivotdirection = 1
local pivotdistance = 5
local slashing = false
lplr.CharacterAdded:Connect(function(newchar)
	char = newchar
	hum = newchar:WaitForChild("Humanoid")
	hrp = newchar:WaitForChild("HumanoidRootPart")
end)
function slash(tool)
	if not slashing then
        slashing = true
		tool:Activate()
		task.wait(0.01)
		tool:Activate()
		task.wait(0.049)
        slashing = false
	end
end
function getClosest()
	local closest
	local closestdistance = math.huge
	for i, v in ipairs(Players:GetPlayers()) do
		local enemychar = v.Character
		if v ~= lplr and enemychar then
			local enemyhrp = enemychar:FindFirstChild("HumanoidRootPart")
			local enemyhum = enemychar:FindFirstChildOfClass("Humanoid")
			if enemyhum and enemyhum.Health > 0 and enemyhrp then
				enemyhrp.Size = Vector3.new(9,9,9)
				enemyhrp.Transparency = 0.5
				enemyhrp.BrickColor = BrickColor.new("Bright red")
				local distance = (enemyhrp.Position - hrp.Position).Magnitude
				if distance < closestdistance then
					closest = enemychar
					closestdistance = distance
				end
			end
		end
	end
	return closest
end
RS.Stepped:Connect(function(_,delta)
	local target = getClosest()
	if target then
		controls:Disable()
		local targethrp = target.HumanoidRootPart
		local targethum = target.Humanoid
		local att = Instance.new("Attachment", hrp)
		att.Position = Vector3.new(1.49,0,0)
		local Look = CFrame.new(att.WorldPosition,targethrp.Position * Vector3.new(1,0,1) + att.WorldPosition * Vector3.new(0,1,0))
		hrp.CFrame = CFrame.new(hrp.Position,hrp.Position + Look.LookVector)
		if math.random(1,20) == 1 then
			pivotdistance = math.random(690,6250)/1000
		end
		if math.random(1,2) == 1 then
			pivotdirection = -pivotdirection
		end
		local params = RaycastParams.new()
		params.FilterDescendantsInstances = {char}
		params.FilterType = Enum.RaycastFilterType.Exclude
		local raycastresult = workspace:Raycast(hrp.Position,Vector3.new(0,-5,0),params)
		if not raycastresult then
			pivotdirection = -pivotdirection
		end
		local circumference = 2 * math.pi * pivotdistance
		pivotangle += 360 / (circumference / hum.WalkSpeed) * delta * pivotdirection
		if pivotangle >= 360 or pivotangle <= -360 then
			pivotangle = 0
		end
		local distance = (targethrp.Position - hrp.Position).Magnitude
		local chaseprediction = targethrp.Position + targethrp.Velocity * (distance / hum.WalkSpeed)
		local movementprediction = targethrp.Position + targethrp.Velocity * (2.5 + lplr:GetNetworkPing() * targethum.WalkSpeed)
		local movementpredictiondist = (movementprediction - hrp.Position).Magnitude
	        if distance <= 6.25 then
	            if slashing then
	                hum.Jump = true
	                hum:MoveTo(hrp.Position + ((hrp.Position * Vector3.new(1,0,1) - targethrp.Position * Vector3.new(1,0,1)) * 999))
	            else
	                if movementpredictiondist <= 3 or distance <= 5.5 then
	                    hum.Jump = true
	                    local tool = char:FindFirstChildOfClass("Tool")
	                    if tool then
	                        coroutine.wrap(slash)(tool)
	                    end
	                end
	                hum:MoveTo(chaseprediction + CFrame.Angles(0,math.rad(pivotangle),0).LookVector * pivotdistance)
	            end
		elseif distance <= 100 then
			hum:MoveTo(chaseprediction)
		end
	else
		controls:Enable()
	end
end)
