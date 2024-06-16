-- {Services} --
local UIS = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local RS = game:GetService("RunService")
local Players = game:GetService("Players")

-- {LocalPlayer} --
local lplr = Players.LocalPlayer
local lplrchar = lplr.Character or lplr.CharacterAdded:Wait()
local lplrhum = lplrchar:WaitForChild("Humanoid")
local lplrhrp = lplrchar:WaitForChild("HumanoidRootPart")
local mouse = lplr:GetMouse()

local Controls = require(lplr:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")):GetControls()

-- {Combat} --
-- Main
local enabled = false

-- Tool
local Tool = lplrchar:WaitForChild("ClassicSword")

-- Combat Variables
local behavior = 1 -- 1: Attack, 2: Evade, 3: Counter
local pivotdistance = 3
local pivotangle = 0
local pivotdirection = 1

-- Sword Tip
local lplrswordtip

-- Zones
local evasionzone
local dangerzone
local safetoenter = false

-- Enemy Variables
local prevenemy
local enemy
local enemyhrp
local enemyhum
local enemyanimator
local enemyla
local enemyra
local enemyattack

-- Network
local ping = 0

-- Stepped Parameters
local timer
local prevtimer

-- {Functions} --
lplr.CharacterAdded:Connect(function(char)
	lplrchar = char
	lplrhum = lplrchar:WaitForChild("Humanoid")
	lplrhrp = lplrchar:WaitForChild("HumanoidRootPart")
end)
function attack()
	if enemy and enemyhrp and enemyla and enemyra and lplrswordtip then
		if mouse.Icon ~= "rbxasset://textures/GunWaitCursor.png" then
			local CFrameLook = CFrame.new(lplrswordtip.WorldPosition,enemyhrp.Position * Vector3.new(1,0,1) + lplrswordtip.WorldPosition * Vector3.new(0,1,0))
			lplrhrp.CFrame = CFrame.new(lplrhrp.Position,lplrhrp.Position + CFrameLook.LookVector)
			
			Tool:Activate()
			task.wait(0.01)
			Tool:Activate()
		end
	end
end
function changepivotangle()
	local circumference = 2 * math.pi * pivotdistance
	local duration = circumference / lplrhum.WalkSpeed
	pivotangle += (1/duration * (timer - prevtimer)) * 360 * pivotdirection
	if pivotangle >= 360 then
		pivotangle = 0
	end
end

-- {Loops} --
RS.Stepped:Connect(function(_, t)
	if not lplrchar or not lplrhrp or not lplrhrp.Parent or not lplrhum or not lplrhum.Parent or lplrhum.Health <= 0 then return end
	ping = lplr
	timer = t
	if enabled then
		local distance
		enemy = nil
		enemyhrp = nil
		enemyhum = nil
		enemyanimator = nil
		enemyla = nil
		enemyra = nil
		
		for _, plr in pairs(Players:GetPlayers()) do
			local char = plr.Character
			if char and char ~= lplrchar then
				local temphrp = char:FindFirstChild("Torso") or char:FindFirstChild("HumanoidRootPart")
				local temphum = char:FindFirstChildOfClass("Humanoid")
				local templa = char:FindFirstChild("Left Arm") or char:FindFirstChild("LeftUpperArm")
				local tempra = char:FindFirstChild("Right Arm") or char:FindFirstChild("RightUpperArm")
				if temphrp and temphum and temphum.Health > 0 and templa and tempra then
					local tempanimator = temphum:FindFirstChildOfClass("Animator")
					if tempanimator then
						local distancetemp = (tempra.Position - lplrhrp.Position).Magnitude
						if not enemy or distancetemp < distance then
							enemy = char
							distance = distancetemp
							enemyhrp = temphrp
							enemyhum = temphum
							enemyanimator = tempanimator
							enemyla = templa
							enemyra = tempra
						end
					end
				end
			end
		end
		if enemy then
			Controls:Disable()
			if enemy ~= prevenemy then enemyattack = nil end
			if enemyattack and tick() + ping - 0.8 > enemyattack then enemyattack = nil end
			if not enemyattack then safetoenter = true end
			behavior = 1
			
			local dist = (enemyhrp.Position - lplrhrp.Position).Magnitude
			
			if not lplrswordtip or not lplrswordtip.Parent then
				local temp = Instance.new("Attachment", lplrhrp)
				temp.Position = Vector3.new(1.5, 0.5, -5)
				lplrswordtip = temp
			end
			if not evasionzone or not evasionzone.Parent then
				local temp = Instance.new("Part", enemyhrp)
				temp.Size = Vector3.new(13,13,13)
				temp.Shape = Enum.PartType.Ball
				evasionzone = temp
			end
			if not dangerzone or not dangerzone.Parent then
				local temp = Instance.new("Part", enemyhrp)
				temp.Size = Vector3.new(7,7,7)
				temp.Shape = Enum.PartType.Ball
				dangerzone = temp
			end
			
			if not enemyattack then
				local anims = enemyanimator:GetPlayingAnimationTracks()
				for _, anim in pairs(anims) do
					if anim.Animation and (anim.Animation.AnimationId == "rbxassetid://522635514" or anim.Animation.AnimationId == "rbxassetid://522638767") then
						safetoenter = false
						enemyattack = tick()
						break
					end
				end
			end
			
			evasionzone.Size = Vector3.new(30+ping*2,30+ping*2,30+ping*2)
			dangerzone.Size = Vector3.new(15+ping*2,15+ping*2,15+ping*2)
			
			if not safetoenter then
				dangerzone.Position = Vector3.new(99999,99999,99999)
				evasionzone.Position = enemyhrp.Position
				local evasionzoneinterceptingparts = evasionzone:GetTouchingParts()
				for _, v in pairs(evasionzoneinterceptingparts) do
					local char = v:FindFirstAncestorOfClass("Model")
					if char and char == lplrchar then
						behavior = 2
						break
					end
				end
			end
			
			dangerzone.Position = enemyhrp.Position
			evasionzone.Position = Vector3.new(99999,99999,99999)
			local dangerzoneinterceptingparts = dangerzone:GetTouchingParts()
			dangerzone.Position = Vector3.new(99999,99999,99999)
			
			for _, v in pairs(dangerzoneinterceptingparts) do
				local char = v:FindFirstAncestorOfClass("Model")
				if char and char == lplrchar then
					behavior = 3
					break
				end
			end
			
			if behavior == 1 then
				lplrhum:MoveTo(enemyhrp.Position + enemyhrp.Velocity * dist / lplrhum.WalkSpeed)
				if dist <= 15 then
					coroutine.wrap(attack)(enemy)
				end
			elseif behavior == 2 then
				lplrhum.Jump = true
				lplrhum:MoveTo(lplrhrp.Position + (lplrhrp.Position - enemyhrp.Position))
			elseif behavior == 3 then
				local x,y,z = CFrame.new(enemyhrp.Position,lplrhrp.Position):ToEulerAnglesYXZ()
				local aim_target_look = Vector3.new(x,y,z)

				local x,y,z = CFrame.new(enemyhrp.Position,enemyhrp.Position + enemyhrp.CFrame.LookVector):ToEulerAnglesYXZ()
				local aim_cframelookvectorunit_look = Vector3.new(x,y,z)

				local diff = aim_target_look - aim_cframelookvectorunit_look

				if math.deg(diff.X) <= 60 and math.deg(diff.X) >= -60 and math.deg(diff.Y) <= 60 and math.deg(diff.Y) >= -60 or lplrhrp.Position.Y > enemyhrp.Position.Y + 1 then
					local backstab = enemyhrp.Position + -enemyhrp.CFrame.LookVector * 5
					local dist = (backstab - lplrhrp.Position).Magnitude
					if dist > 1.6 then
						lplrhum.Jump = true
					else
						coroutine.wrap(attack)(enemy)
					end
					lplrhum:MoveTo(backstab)
				else
					pivotdirection = -1
					pivotdistance = 2
					changepivotangle()
					lplrhum:MoveTo(enemyhrp.Position + CFrame.Angles(0,math.rad(pivotangle),0).LookVector * pivotdistance)
				end
			end
			print(behavior)
		else
			Controls:Enable()
		end
	else
		Controls:Enable()
	end
	prevtimer = t
	prevenemy = enemy
end)
