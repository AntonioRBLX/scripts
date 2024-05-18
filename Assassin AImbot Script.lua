local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")

local isexecutorclosure = is_synapse_function or isexecutorclosure
local hooked

if not isexecutorclosure or not hookmetamethod or not newcclosure or not getgc or not getreg or not checkcaller then
	StarterGui:SetCore("SendNotification", {
        Title = "Error";
        Text = "Your Executor Is Not Supported";
    })
    return
end

function HookAnticheat(v)
    if type(v) == "function" and islclosure(v) and not isexecutorclosure(v) then
        local source = getinfo(v).source
        local anticheat = string.find(source, "BAC") or string.find(source, "ReplicatedFirst.Animator") or string.find(source, "PlayerScripts.reeeee") then
	
        if anticheat then
            hookfunction(v, function()
               
            end)
            hooked = true
            print("Hooked!")
        end
    end
end
for _, v in next, getgc() do
    HookAnticheat(v)
end
for _, v in next, getreg() do
    HookAnticheat(v)
end
if not hooked then
	StarterGui:SetCore("SendNotification", {
		Title = "Error";
		Text = "Failed to Find Anticheat";
	})
	return
end

if getgenv().AlreadyExecuted then return end
getgenv().AlreadyExecuted = true

local Aimbot = loadstring(game:HttpGet("https://raw.githubusercontent.com/CITY512/modules/main/Projectile%20Aimbot.lua"))()
local LocalPlayer = Players.LocalPlayer

local configs = {
	AimbotEnabled = true;
	AimbotMethod = "ClosestPlayerToCharacter";
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
	if configs.AimbotEnabled and not checkcaller() and idx:lower() == "unitray" and LocalPlayer then
		print("Knife Thrown")
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
	return index(obj, idx)
end))
StarterGui:SetCore("SendNotification", {
	Title = "Notification";
	Text = "Aimbot Successfully Loaded";
})
