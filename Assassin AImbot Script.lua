if getgenv().AlreadyExecuted then return end
getgenv().AlreadyExecuted = true

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Aimbot = loadstring(game:HttpGet("https://raw.githubusercontent.com/CITY512/modules/main/Projectile%20Aimbot.lua"))()

local configs = {
	AimbotEnabled = true;
	AimbotMethod = "ClosestPlayerToCursor";
	PingPrediction = 75;
	FOV = 1500;
}

function GetClosestPlayer(FOV,maxdist)
	if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
	local lplrchar = LocalPlayer.Character
	local lplrhrp = lplrchar.HumanoidRootPart

	local camera = workspace.CurrentCamera
	local closest

	local function getclosestplayertoscreenpoint(point)
		for _, player in pairs(Players:GetPlayers()) do
			if player ~= LocalPlayer then
				local character = workspace:FindFirstChild(player.Name)
				if character then
					local NPCRoot = character:FindFirstChild("HumanoidRootPart")
					if NPCRoot then
						local viewportpoint, onscreen = camera:WorldToViewportPoint(NPCRoot.Position)
						local distance = (Vector2.new(viewportpoint.X,viewportpoint.Y) - point).Magnitude
						local distancefromplayer = (NPCRoot.Position - lplrhrp.Position).Magnitude
	
						if onscreen and distance <= FOV then
							if not closest or distance < (closest.HumanoidRootPart.Position - lplrhrp.Position).Magnitude and distancefromplayer <= maxdist then
								closest = character
							end
						end
					end
				end
			end
		end
	end
	if configs.AimbotMethod == "ClosestPlayerToCursor" and camera then
		getclosestplayertoscreenpoint(Vector2.new(mouse.X,mouse.Y))
		return closest
	elseif configs.AimbotMethod == "ClosestPlayerToCharacter" then
		for _, player in pairs(Players:GetPlayers()) do
			if player ~= LocalPlayer then
				local character = workspace:FindFirstChild(player.Name)
				if character and character:FindFirstChild("HumanoidRootPart") then
					local distance = (character.HumanoidRootPart.Position - lplrhrp.Position).Magnitude
					if not closest or distance < (closest.HumanoidRootPart.Position - lplrhrp.Position).Magnitude and distance <= maxdist then
						closest = character
					end
				end
			end
		end
		return closest
	elseif configs.AimbotMethod == "ClosestPlayerToScreenCenter" and camera then
		getclosestplayertoscreenpoint(Vector2.new(camera.ViewportSize.X,camera.ViewportSize.Y)/2)
		return closest
	end
	return nil
end

local index 
index = hookmetamethod(game, '__index', newcclosure(function(obj, idx)
	if configs.AimbotEnabled then
		if not checkcaller() and idx:lower() == "unitray" and LocalPlayer.Character then
			print("Knife Throw Index")
			local closest = GetClosestPlayer(configs.FOV,1000)
			if closest then
				local HumanoidRootPart = LocalPlayer.Character.HumanoidRootPart
				local attachment = Instance.new("Attachment", HumanoidRootPart)
				attachment.Position = Vector3.new(1.6, 1.2, -3)
	
				local _, aimpos = Aimbot:ComputePathAsync(attachment.WorldPosition,closest,290,60,{
					IgnoreList = nil;
					Ping = configs.PingPrediction;
					PredictSpamJump = true;
				})
					
				attachment:Destroy()
				
				if aimpos then
					local aimposPart = Instance.new("Part", workspace)
					aimposPart.Anchored = true
					aimposPart.CanCollide = false
					aimposPart.Position = aimpos
					aimposPart.Size = Vector3.new(0.25,0.25,0.25)
					
					return Ray.new(obj.Origin, (obj.Hit - obj.Origin).Unit)
				end
			else
				local sound = Instance.new("Sound", workspace)
				sound.SoundId = "rbxassetid://9082114925"
				sound.PlayOnRemove = true
				sound:Destroy()
			end
		end
	end
	return index(obj, idx)
end))
game:GetService("StarterGui"):SetCore("SendNotification",{
	Title = "Notification"; -- Required
	Text = "Aimbot Successfully Loaded"; -- Required
})
