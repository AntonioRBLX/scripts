local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local SG = game:GetService("StarterGui")
local Players = game:GetService("Players")
local lplr = Players.LocalPlayer
local killerChar = lplr.Character or lplr.CharacterAdded:Wait()
local killerHum = killerChar:WaitForChild("Humanoid")
local killerHrp = killerChar:WaitForChild("HumanoidRootPart")

local MaxDist = 1000
local pivotAngle = 0
local pivotDirection = 1
local pivotDistance = 3
local prevtimer

local Controls = require(lplr:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")):GetControls()

lplr.CharacterAdded:Connect(function(char)
	killerChar = char
	killerHum = char:WaitForChild("Humanoid")
	killerHrp = char:WaitForChild("HumanoidRootPart")
end)

local enabled = false

function getClosest()
	local closest
	local dist
	for _, plr in pairs(Players:GetPlayers()) do
		local plrchar = plr.Character
		if plrchar and plrchar ~= killerChar then
			local NPCHum = plrchar:FindFirstChildOfClass("Humanoid")
			local NPCHrp = plrchar:FindFirstChild("HumanoidRootPart")
	
			if NPCHum and NPCHum.Health > 0 and NPCHrp and NPCHrp:IsA("BasePart") then
				local dist2 = (NPCHrp.Position - killerHrp.Position).Magnitude
				if (not closest or dist2 < dist) and dist2 <= MaxDist then
					closest = plrchar
					dist = dist2
				end
			end
		end
	end
	return closest
end
UIS.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.E then
		enabled = not enabled
		SG:SetCore("SendNotification", {
			Title = "Info",
			Text = "Auto-Strafe has been set to "..tostring(enabled),
		})
	end
end)
RS.Stepped:Connect(function(timer)
	if not enabled or not killerChar.Parent or not killerHum.Parent or killerHum.Health <= 0 or not killerHrp.Parent then Controls:Enable() return end
	local closest = getClosest()
	if math.random(1,21) == 1 then
		pivotDistance = math.random(32,75)/10
	end
	if closest and prevtimer then
		Controls:Enable()
		local enemyroot = closest.HumanoidRootPart
		local enemypos = enemyroot.Position
		local enemyvel = enemyroot.Velocity

		local killerhrppos = killerHrp.Position
		local killerhumvel = killerHrp.Velocity
		
		local dist = (killerhrppos - enemypos).Magnitude
		if dist <= 10 then
			Controls:Disable()
			local x,y,z = CFrame.new(enemypos,killerhrppos):ToEulerAnglesYXZ()
			local aim_target_look = Vector3.new(x,y,z)

			local x,y,z = CFrame.new(enemypos,enemypos + enemyroot.CFrame.LookVector):ToEulerAnglesYXZ()
			local aim_cframeunit_look = Vector3.new(x,y,z)

			local diff = aim_target_look - aim_cframeunit_look
			if math.deg(diff.X) <= 45 and math.deg(diff.X) >= -45 and math.deg(diff.Y) <= 45 and math.deg(diff.Y) >= -45 then
				local circumference = 2 * math.pi * pivotDistance
				local duration = circumference / killerHum.WalkSpeed
				pivotAngle += (1/duration * (timer - prevtimer)) * 360 * pivotDirection
				if pivotAngle >= 360 then
					pivotAngle = 0
				end

				local moveto = enemypos + CFrame.Angles(0,math.rad(pivotAngle),0).LookVector * pivotDistance
				killerHum:MoveTo(moveto)
				if killerHum:GetState() ~= Enum.HumanoidStateType.Freefall and math.random(1,7) then
					pivotDirection = -pivotDirection
					if math.random(1,2) == 1 then
						killerHum.Jump = true
					end
				elseif killerHum:GetState() == Enum.HumanoidStateType.Freefall and killerhumvel.Y >= -2 and killerhumvel.Y <= 2 and math.random(1,3) == 1 then
					pivotDirection = -pivotDirection
				end
			else
				killerHum:MoveTo(enemypos)
			end
			if enemypos.Y > killerhrppos.Y + 1 then
				killerHum.Jump = true
			end
			if math.random(1,21) == 1 then
				killerHum.Jump = true
			end
		elseif dist <= 60 then
			Controls:Disable()
			local prediction = enemypos + enemyvel * dist / killerHum.WalkSpeed
			killerHum:MoveTo(prediction)
		end
	end
	prevtimer = timer
end)
