local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local configs = {
	AimbotEnabled = true
	AimbotMethod = "ClosestPlayerToScreenCenter"
	PingPrediction = 50
	FOV = 500
}

function checkcharhaschildren(char)
	if char:FindFirstChild("HumanoidRootPart") and char:FindFirstChildOfClass("Humanoid") then
		return true
	else
		return false
	end
end
function GetClosestPlayer(FOV,maxdist)
	if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
	local lplrchar = LocalPlayer.Character
	local lplrhrp = lplrchar.HumanoidRootPart

	local camera = workspace.CurrentCamera
	local closest

	local function getclosestplayertoscreenpoint(point)
		for _, player in pairs(Players:GetChildren()) do
			local character = workspace:FindFirstChild(player.Name)
			if character and character ~= lplrchar then
				local NPCRoot = character:FindFirstChild("HumanoidRootPart")
				if NPCRoot then
					local viewportpoint, onscreen = camera:WorldToScreenPoint(NPCRoot.Position)
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
	if configs.AimbotMethod == "ClosestPlayerToCursor" and camera then
		getclosestplayertoscreenpoint(Vector2.new(mouse.X,mouse.Y))
		return closest
	elseif configs.AimbotMethod == "ClosestPlayerToCharacter" then
		for _, player in pairs(Players:GetChildren()) do
			local character = workspace:FindFirstChild(player.Name)
			if character and character ~= lplrchar and character:FindFirstChild("HumanoidRootPart") then
				local distance = (character.HumanoidRootPart.Position - lplrhrp.Position).Magnitude
				if not closest or distance < (closest.HumanoidRootPart.Position - lplrhrp.Position).Magnitude and distance <= maxdist then
					closest = character
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

local Aimbot = loadstring(game:HttpGet("https://raw.githubusercontent.com/CITY512/modules/main/aimbot.lua"))()

local index 
index = hookmetamethod(game, '__index', newcclosure(function(obj, idx)
	if configs.AimbotEnabled and idx:lower() == 'unitray' and LocalPlayer.Character and checkcharhaschildren(LocalPlayer.Character) then
		local closest = GetClosestPlayer(configs.FOV,1000)
		local HumanoidRootPart = LocalPlayer.Character.HumanoidRootPart

		if closest then
			local attachment = Instance.new("Attachment", HumanoidRootPart)
			attachment.Position = Vector3.new(1.6, 1.2, -3)

			local _, aimpos = Aimbot:ComputePathAsync(attachment.WorldPosition,closest,290,60,nil,true,configs.PingPrediction,nil,false)
			local origin = index(obj, idx)
			attachment:Destroy()

			return {
				Origin = origin.Origin,
				Direction = CFrame.new(origin.Origin,aimpos).LookVector
			}
		end
	end
	return index(obj, idx)
end))
game.StarterGui:SetCore("SendNotification", {
	Title = "Loaded";
	Text = "too lazy to make an interface. roblox: CITY512 / discord: Luc#9803"
})
