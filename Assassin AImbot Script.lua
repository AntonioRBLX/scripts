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
--[[
function HookFunction(v)
	if type(v) == "function" and islclosure(v) and not isexecutorclosure(v) then
		local funcinfo = getinfo(v)
		local source = funcinfo.source:lower()

		local anticheat = source:find("bac") or source:find("replicatedfirst.animator") or source:find("playerscripts.reeeee")

		if anticheat then
			hookfunction(funcinfo.func, function() return end)
			hooked = true
			warn("Hooked!")
		end
	end
end
for _, v in next, getgc() do
	HookFunction(v)
end
for _, v in next, getreg() do
	HookFunction(v)
end
if not hooked then
	StarterGui:SetCore("SendNotification", {
		Title = "Error";
		Text = "Failed to Bypass Anticheat";
	})
	return
end
--]]
if getgenv().AlreadyExecuted then return end
getgenv().AlreadyExecuted = true

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wall%20v3"))()
local Aimbot = loadstring(game:HttpGet("https://raw.githubusercontent.com/CITY512/modules/main/Projectile%20Aimbot.lua"))()
local LocalPlayer = Players.LocalPlayer

local configs = {
	AimbotEnabled = true;
	AimbotMethod = "ClosestPlayerToCharacter";
	PingPrediction = 150;
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

local Window = Library:CreateWindow("Aimbot")
local AimbotFolder = Window:CreateFolder("Aimbot")
AimbotFolder:Toggle("Aimbot", function(bool)
    configs.AimbotEnabled = bool
end)
local AimbotConfigsFolder = Window:CreateFolder("Aimbot Configs")
AimbotConfigsFolder:Dropdown("Aimbot Method",{"ClosestPlayerToCursor","ClosestPlayerToCharacter","ClosestPlayerToScreenCenter"},true,function(mob)
    configs.AimbotMethod = mob
end)
AimbotConfigsFolder:Slider("Ping Prediction",{min = 0;max = 500;precise = true},function(value)
    configs.PingPrediction = value
end)
AimbotConfigsFolder:Slider("FOV",{min = 50;max = 1000;precise = true},function(value)
    configs.FOV = value
end)

local namecall
namecall = hookmetamethod(game, "__namecall", function(self,...)
	local method = getnamecallmethod()
	local args = {...}
	if not checkcaller() and tostring(method) == "FireServer" and tostring(self) == "ThrowKnife" then
		local lplrchar = LocalPlayer.Character
		if lplrchar then
			local closest = GetClosestPlayer(configs.FOV,1000)
			if closest then
				local lplrhrp = lplrchar.HumanoidRootPart

				local attachment = Instance.new("Attachment", lplrhrp)
				attachment.Position = Vector3.new(1.6, 1.2, -3)

				local _, aimpos = Aimbot:ComputePathAsync(attachment.WorldPosition,closest,290,60,{
					IgnoreList = nil;
					Ping = configs.PingPrediction;
					PredictSpamJump = true;
					IsAGun = false;
				})

				attachment:Destroy()
				if aimpos then
					args[1] = aimpos
				end
				return self.FireServer(self,table.unpack(args))
			end
		end
	end
	return namecall(self,...)
end)
StarterGui:SetCore("SendNotification", {
	Title = "Notification";
	Text = "Aimbot Successfully Loaded";
})
