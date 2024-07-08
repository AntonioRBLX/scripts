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
			pivotdistance = math.random(4,11)
		end
		if math.random(1,8) == 1 then
			pivotdirection = -pivotdirection
		end
		local circumference = 2 * math.pi * pivotdistance
		pivotangle += 360 / (circumference / hum.WalkSpeed) * delta * pivotdirection
		if pivotangle >= 360 or pivotangle <= -360 then
			pivotangle = 0
		end
		local distance = (targethrp.Position - hrp.Position).Magnitude
		local predictedpos = targethrp.Position + targethrp.Velocity * (distance / hum.WalkSpeed)
		if distance <= 11 then
			hum:MoveTo(predictedpos + CFrame.Angles(0,math.rad(pivotangle),0).LookVector * pivotdistance)
			if distance <= 5.5 then
		                local tool = char:FindFirstChildOfClass("Tool")
		                if tool then
		                    coroutine.wrap(slash)(tool)
		                end
				if distance <= 5.4 and targethrp.Position.Y - 1 > hrp.Position.Y then
				    hum.Jump = true
				end
			end
		elseif distance <= 35 then
			hum:MoveTo(predictedpos)
		end
	else
		controls:Enable()
	end
end)
