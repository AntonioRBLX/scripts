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
		Text = "Failed to Find Anticheat";
	})
end
if getgenv().AlreadyExecuted then return end
getgenv().AlreadyExecuted = true
local Aimbot = loadstring(game:HttpGet("https://raw.githubusercontent.com/CITY512/modules/main/Projectile%20Aimbot.lua"))()
local LocalPlayer = Players.LocalPlayer
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Frame_2 = Instance.new("Frame")
local _1 = Instance.new("TextButton")
local UIListLayout = Instance.new("UIListLayout")
local _2 = Instance.new("TextBox")
local _3 = Instance.new("TextBox")
local Name1 = Instance.new("StringValue")
local Name2 = Instance.new("StringValue")
local Name3 = Instance.new("StringValue")
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.Enabled = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.Position = UDim2.new(0.017681729, 0, 0.0284280945, 0)
Frame.Size = UDim2.new(0, 100, 0, 100)
Frame_2.Parent = Frame
Frame_2.AnchorPoint = Vector2.new(0.5, 0.5)
Frame_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Frame_2.BackgroundTransparency = 1.000
Frame_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame_2.Position = UDim2.new(0.5, 0, 0.5, 0)
Frame_2.Size = UDim2.new(1, -20, 1, -20)
UIListLayout.Parent = Frame_2
_1.Name = "1"
_1.Parent = Frame_2
_1.BackgroundColor3 = Color3.fromRGB(255, 151, 151)
_1.BorderColor3 = Color3.fromRGB(0, 0, 0)
_1.Size = UDim2.new(1, 0, 0, 27)
_1.AutoButtonColor = false
_1.Font = Enum.Font.SourceSans
_1.Text = "Aimbot: OFF"
_1.TextColor3 = Color3.fromRGB(0, 0, 0)
_1.TextSize = 14.000
Name1.Parent = _1
Name1.Name = "Name"
Name1.Value = "Aimbot"
_2.Name = "2"
_2.Parent = Frame_2
_2.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
_2.ClipsDescendants = true
_2.Size = UDim2.new(1, 0, 0, 27)
_2.Font = Enum.Font.SourceSans
_2.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
_2.PlaceholderText = "Prediction"
_2.Text = ""
_2.TextColor3 = Color3.fromRGB(0, 0, 0)
_2.TextSize = 14.000
_2.TextWrapped = true
Name2.Parent = _2
Name2.Name = "Name"
Name2.Value = "Prediction"
_3.Name = "3"
_3.Parent = Frame_2
_3.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
_3.BorderColor3 = Color3.fromRGB(0, 0, 0)
_3.ClipsDescendants = true
_3.Size = UDim2.new(1, 0, 0, 26)
_3.Font = Enum.Font.SourceSans
_3.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
_3.PlaceholderText = "FOV"
_3.Text = ""
_3.TextColor3 = Color3.fromRGB(0, 0, 0)
_3.TextSize = 14.000
_3.TextWrapped = true
Name3.Parent = _3
Name3.Name = "Name"
Name3.Value = "FOV"
local configs = {
	Aimbot = false;
	Prediction = 100;
	FOV = 500;
}
function toggle(toggle,callback)
	if not toggle then return end
	local name = toggle:FindFirstChild("Name")
	if not name then return end
	local activated = false
	toggle.MouseButton1Click:Connect(function()
		if activated then
			activated = false
			toggle.Text = name.Value..": OFF"
			toggle.BackgroundColor3 = Color3.fromRGB(255, 151, 151)
			callback(false)
		else
			activated = true
			toggle.Text = name.Value..": ON"
			toggle.BackgroundColor3 = Color3.fromRGB(151, 255, 151)
			callback(true)
		end
	end)
end
function textbox(textbox,callback)
	if not textbox then return end
	local name = textbox:FindFirstChild("Name")
	if not name then return end
	textbox.FocusLost:Connect(function()
		textbox.Interactable = false
		local text = textbox.Text
		if tonumber(text) then
			textbox.Text = name.Value..": "..tonumber(text)
			callback(text)
		else
			textbox.Text = ""
			textbox.PlaceholderText = "Not A Number"
			task.wait(1.25)
			textbox.PlaceholderText = name.Value
		end
		textbox.Interactable = true
	end)
end
toggle(_1,function(value)
	configs.Aimbot = value
	print("Aimbot Set To",tostring(value))
end)
textbox(_2,function(value)
	configs.Prediction = value
	print("Prediction Set To",tostring(value))
end)
textbox(_3,function(value)
	configs.FOV = value
	print("FOV Set To",tostring(value))
end)
function GetClosestPlayer(FOV,maxdist)
	if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
	local lplrchar = LocalPlayer.Character
	local lplrhrp = lplrchar.HumanoidRootPart
	local camera = workspace.CurrentCamera
	local closest
	local distance = math.huge
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			local character = workspace:FindFirstChild(player.Name)
			if character then
				local NPCRoot = character:FindFirstChild("HumanoidRootPart")
				if NPCRoot then
					local viewportpoint, onscreen = camera:WorldToViewportPoint(NPCRoot.Position)
					local distance = (Vector2.new(viewportpoint.X,viewportpoint.Y) - point).Magnitude
					local distancefromplayer = (NPCRoot.Position - lplrhrp.Position).Magnitude
					if onscreen and distance <= FOV and distancetemp < distance and distancefromplayer <= maxdist then
						closest = character
						distance = distancetemp
					end
				end
			end
		end
	end
	return closest
end
local namecall
namecall = hookmetamethod(game, "__namecall", newcclosure(function(self,...)
	local method = getnamecallmethod()
	if not checkcaller() and tostring(method) == "FireServer" and tostring(self) == "ThrowKnife" then
		local lplrchar = LocalPlayer.Character
		if lplrchar then
			local closest = GetClosestPlayer(configs.FOV,1000)
			if closest then
				local args = {...}
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
				return aimpos and self.FireServer(self,table.unpack(args)) or self.FireServer(self,...)
			end
		end
	end
	return namecall(self,...)
end))
StarterGui:SetCore("SendNotification", {
	Title = "Notification";
	Text = "Aimbot Successfully Loaded";
})
