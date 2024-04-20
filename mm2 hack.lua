local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

function notify(title,msg)
	game:GetService("StarterGui"):SetCore("SendNotification" ,{
		Title = title;
		Text = msg;
	})
end
if not game:IsLoaded() then
	local message = Instance.new("Hint", CoreGui)
	message.Text = "Waiting For Game To Load..."
	game.Loaded:Wait()
	message:Destroy()
end
if not hookmetamethod or not setreadonly or not newcclosure or not getnamecallmethod or not getgenv then -- Checks if executor is supported
	notify("Error","Incompatible Executor! Functions are not supported by this executor.")
	return
end
if game.PlaceId ~= 142823291 and game.PlaceId ~= 636649648 then 
	notify("Error","Unsupported game. Supported Games: Murder Mystery 2 / MM2 Assassin")
	return
end

if _G.mm2hacksalreadyloadedbyCITY512 then
	notify("Error","Already Executed!")
	return
end -- Checks if the script is already executed
_G.mm2hacksalreadyloadedbyCITY512 = true

-- Modules

local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/UI-Interface/ArrayField/main/Source.lua'))()
local Aimbot = loadstring(game:HttpGet("https://raw.githubusercontent.com/CITY512/modules/main/aimbot.lua"))()

repeat task.wait() until game.Players.LocalPlayer -- Waits for LocalPlayer to load in.
-- Variables

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Mouse = LocalPlayer:GetMouse()

local configs = { -- Library Configurations
	GunAimbot = false;
	KnifeAimbot = false;
	GunPrediction = 150;
	KnifePrediction = 100;
	AimbotMethod = "Murderer/Target";
	FOV = 350;
	AutoEquip = true;
	AutoShoot = true;
	KillAura = false;
	KillAuraRange = 15;
	FaceTarget = false;

	AutoRemoveLag = false;
	IncludeAccessories = false;
	IncludeLocalPlayer = false;
	ToggleWalkSpeed = false;
	ToggleJumpPower = false;
	WalkSpeed = 16;
	JumpPower = 50;

	CoinFarm = false;
	XPFarm = false;
	AutoUnbox = false;
	AutoUnboxCrate = {};

	AutoGrabGun = false;
	FlingPlayer = false;

	Chams = false;
	ShowGunDrop = false;
	TrapESP = false;
	MurdererColor = Color3.fromRGB(255, 112, 112);
	TrapColor = Color3.fromRGB(255, 172, 112);
	HeroColor = Color3.fromRGB(255, 231, 112);
	InnocentColor = Color3.fromRGB(143, 255, 112);
	SheriffColor = Color3.fromRGB(112, 136, 255);
	GunDropColor = Color3.fromRGB(141, 112, 255);
	ShowAimbotVisuals = false;
}
local players = {} --[[
					Nikilis = {
						Role = "Murderer";
					}
					--]]
local weapons = {
	Knife = {
		Role = {"Murderer"};
		Speed = {
			Normal = 80;
			Sleight = 100;
		}
	};
	Gun = {
		Role = {"Sheriff","Hero"};
	}
}
local match = {
	SheriffDied = false;
}
local powers = {
	Sleight = false;
}
local eventfunctions = {}
local scriptvariables = {
	AlreadyFlinging = false;
	AntiLagAlreadyExecuted = false;
	ScriptActivated = true;
	ExecuteOnTeleport = false;
	TPCheck = false;
	QueueOnTeleport = syn and syn.queue_on_teleport or queue_on_teleport or fluxus and fluxus.queue_on_teleport;
}
local connections = {}
local a = 0

local Drawing1
local Drawing2

if Drawing then
	Drawing1 = Drawing.new("Circle")
	Drawing1.Color = Color3.fromRGB(255, 89, 89)
	Drawing1.Thickness = 2
	Drawing1.Visible = false
	Drawing1.Radius = configs.FOV
	Drawing1.Filled = false

	Drawing2 = Drawing.new("Circle")
	Drawing2.Thickness = 4
	Drawing2.Visible = false
	Drawing2.Radius = configs.FOV
	Drawing2.ZIndex = -1
	Drawing2.Filled = false
else
	notify("Info","Drawing is not supported on this executor, functions such as ShowFOVCircle will not work.")
end

---------------------------------------------------------------------------
-- Functions

function AddChams(object,isacharmodel,chamsettings) -- Adds ESP
	local function AddBoxHandleAdornment(part)
		local BHA = Instance.new("BoxHandleAdornment", part)
		BHA.Name = "MM2CHAMS"
		BHA.Adornee = part
		BHA.Color3 = chamsettings.Color
		BHA.ZIndex = 10
		BHA.AlwaysOnTop = true
		BHA.Size = part.Size
		BHA.Transparency = 0.3
	end
	if isacharmodel then
		if object.ClassName == "Model" and Players:FindFirstChild(object.Name) then
			for _, limb in pairs(object:GetChildren()) do
				if limb:IsA("BasePart") and limb.Name ~= "HumanoidRootPart" and not limb:FindFirstChild("MM2CHAMS") then
					AddBoxHandleAdornment(limb)
				end
			end
		end
	elseif object:IsA("BasePart") then
		AddBoxHandleAdornment(object)
	end
end
function UpdateChams(object,isacharmodel,chamsettings) -- Updates ESP
	local function changeadornment(BHA)
		BHA.Color3 = chamsettings.Color
	end
	if isacharmodel then
		if object.ClassName == "Model" and Players:FindFirstChild(object.Name) then
			for _, limb in pairs(object:GetChildren()) do
				local BHA = limb:FindFirstChild("MM2CHAMS")
				if BHA and BHA.ClassName == "BoxHandleAdornment" then
					changeadornment(BHA)
				end
			end
		end
	else
		local BHA = object:FindFirstChild("MM2CHAMS")
		if BHA and BHA.ClassName == "BoxHandleAdornment" then
			changeadornment(BHA)
		end
	end
end
function RemoveChams(object,isacharmodel) -- Destroys ESP
	if isacharmodel then
		if object.ClassName == "Model" and Players:FindFirstChild(object.Name) then
			for _, limb in pairs(object:GetChildren()) do
				local BHA = limb:FindFirstChild("MM2CHAMS")
				if BHA and BHA.ClassName == "BoxHandleAdornment" then
					BHA:Destroy()
				end
			end
		end
	else
		local BHA = object:FindFirstChild("MM2CHAMS")
		if BHA and BHA.ClassName == "BoxHandleAdornment" then
			BHA:Destroy()
		end
	end
end
function GetClosestPlayer(FOV,maxdist)
	local lplrchar = LocalPlayer.Character
	if lplrchar then
		local lplrhrp = lplrchar:FindFirstChild("HumanoidRootPart")
		if lplrhrp and lplrhrp:IsA("BasePart") then
			local camera = workspace.CurrentCamera
			local closest
			local function getclosestplayertoscreenpoint(point)
				for _, player in pairs(Players:GetPlayers()) do
					local character = player.Character
					if character and character ~= lplrchar then
						local NPCRoot = character:FindFirstChild("HumanoidRootPart")
						if NPCRoot and NPCRoot:IsA("BasePart") then
							local viewportpoint, onscreen = camera:WorldToScreenPoint(NPCRoot.Position)
							local distance = (Vector2.new(viewportpoint.X,viewportpoint.Y) - point).Magnitude
							local distancefromplayer = (NPCRoot.Position - lplrhrp.Position).Magnitude

							if onscreen and distance <= FOV then
								if not closest or distancefromplayer < (closest.HumanoidRootPart.Position - lplrhrp.Position).Magnitude and distancefromplayer <= maxdist then
									closest = character
								end
							end
						end
					end
				end
			end
			if configs.AimbotMethod == "ClosestPlayerToCursor" and camera then
				getclosestplayertoscreenpoint(Vector2.new(Mouse.X,Mouse.Y))
				return closest
			elseif configs.AimbotMethod == "ClosestPlayerToCharacter" then
				for _, player in pairs(Players:GetPlayers()) do
					local character = player.Character
					if character and character ~= lplrchar  then
						local NPCRoot = character:FindFirstChild("HumanoidRootPart")
						if NPCRoot and NPCRoot:IsA("BasePart") then
							local distance = (NPCRoot.Position - lplrhrp.Position).Magnitude
							if not closest or distance < (closest.HumanoidRootPart.Position - lplrhrp.Position).Magnitude and distance <= maxdist then
								closest = character
							end
						end
					end
				end
			elseif configs.AimbotMethod == "ClosestPlayerToScreenCenter" and camera then
				getclosestplayertoscreenpoint(Vector2.new(camera.ViewportSize.X,camera.ViewportSize.Y - 58)/2)
			elseif configs.AimbotMethod == "Murderer/Target" then
				if game.PlaceId == "636649648" then

				elseif players[LocalPlayer.Name] and players[LocalPlayer.Name].Role == weapons.Knife.Role[1] then
					getclosestplayertoscreenpoint(Vector2.new(Mouse.X,Mouse.Y))
				else
					for _, player in pairs(Players:GetPlayers()) do
						if players[player.Name] and players[player.Name].Role and players[player.Name].Role == weapons.Knife.Role[1] then
							local character = player.Character
							if character and character ~= lplrchar then
								local NPCRoot = character:FindFirstChild("HumanoidRootPart")
								if NPCRoot and NPCRoot:IsA("BasePart") then
									local distancefromplayer = (NPCRoot.Position - lplrhrp.Position).Magnitude

									if not closest or distancefromplayer < (closest.HumanoidRootPart.Position - lplrhrp.Position).Magnitude and distancefromplayer <= maxdist then
										closest = character
									end
								end
							end
						end
					end
				end
			end
			return closest
		end
	end
	return nil
end
function ChamPlayerRoles() -- Chams Player Using Colors Based On Their Role
	for _, player in pairs(Players:GetPlayers()) do
		local character = player.Character
		if character and players[player.Name] and player ~= LocalPlayer then
			local role = players[player.Name].Role
			if role then
				if role == weapons.Knife.Role[1] then
					AddChams(character,true,{
						Color = configs.MurdererColor;
					})
				elseif role == weapons.Gun.Role[1] then
					AddChams(character,true,{
						Color = configs.SheriffColor;
					})
				elseif role == weapons.Gun.Role[2] then
					AddChams(character,true,{
						Color = configs.HeroColor;
					})
				elseif role == "Innocent" then
					AddChams(character,true,{
						Color = configs.InnocentColor;
					})
				end
			end
		end
	end
end
function UnchamPlayers()
	for _, player in pairs(Players:GetPlayers()) do
		local character = player.Character
		if character then
			RemoveChams(character,true)
		end
	end
end
function UpdateAllChams()
	for _, child in pairs(workspace:GetChildren()) do
		local player = Players:GetPlayerFromCharacter(child)
		if player and players[player.Name] and player ~= LocalPlayer then
			local role = players[player.Name].Role
			if role then
				if role == weapons.Knife.Role[1] then
					UpdateChams(child,true,{
						Color = configs.MurdererColor;
					})
				elseif role == weapons.Gun.Role[1] then
					UpdateChams(child,true,{
						Color = configs.SheriffColor;
					})
				elseif role == weapons.Gun.Role[2] then
					UpdateChams(child,true,{
						Color = configs.HeroColor;
					})
				elseif role == "Innocent" then
					UpdateChams(child,true,{
						Color = configs.InnocentColor;
					})
				end
			end
		elseif child:IsA("BasePart") and child.Name == "GunDrop" then
			UpdateChams(child,false,{
				Color = configs.GunDropColor;
			})
		end
	end
end
function RemoveDisplays(character)
	local KnifeDisplay = character:WaitForChild("KnifeDisplay", 10)
	local GunDisplay = character:WaitForChild("GunDisplay", 10)

	if KnifeDisplay then KnifeDisplay:Destroy() end
	if GunDisplay then GunDisplay:Destroy() end

	if configs.IncludeAccessories then
		for _, child in pairs(character:GetChildren()) do
			if child:IsA("Accessory") or child.Name == "Radio" or child.Name == "Pet" then
				child:Destroy()
			end
		end
	end
end
function eventfunctions.Initialize(player)
	players[player.Name] = {Role = "Innocent";}

	local backpack = player:WaitForChild("Backpack")
	local character = player.Character or player.CharacterAdded:Wait()

	a += 4
	local b = a

	players[player.Name].Disconnect = function()
		if connections[b] then
			connections[b]:Disconnect()
		end
		if connections[b - 1] then
			connections[b - 1]:Disconnect()
		end
		if connections[b - 2] then
			connections[b - 2]:Disconnect()
		end
	end
	local function HumanoidDiedEvent(humanoid)
		if connections[b] then
			connections[b]:Disconnect()
		end
		connections[b] = humanoid.Died:Connect(function()
			if players[player.Name].Role == weapons.Gun.Role[1] or players[player.Name].Role == weapons.Gun.Role[2] then
				match.SheriffDied = true
			end
			players[player.Name].Role = "Innocent"
		end)
	end
	local function AssignRole(Tool)
		if Tool.Name == "Knife" then
			players[player.Name].Role = weapons.Knife.Role[1]
			if configs.Chams and player ~= LocalPlayer then
				UpdateChams(character,true,{
					Color = configs.MurdererColor;
				})
			end
		elseif Tool.Name == "Gun" then
			if match.SheriffDied then
				players[player.Name].Role = weapons.Gun.Role[2]
				if configs.Chams and player ~= LocalPlayer then
					UpdateChams(character,true,{
						Color = configs.HeroColor;
					})
				end
			else
				players[player.Name].Role = weapons.Gun.Role[1]
				if configs.Chams and player ~= LocalPlayer then
					UpdateChams(character,true,{
						Color = configs.SheriffColor;
					})
				end
			end
		end
	end
	local function CharacterAdded(char)
		character = char
		players[player.Name].Role = "Innocent"

		local bp = player:WaitForChild("Backpack")
		backpack = bp
		local NPCHum = char:WaitForChild("Humanoid")
		if NPCHum.ClassName == "Humanoid" then
			if player == LocalPlayer then
				if configs.ToggleWalkSpeed then
					NPCHum.WalkSpeed = configs.WalkSpeed
				end
				if configs.ToggleJumpPower then
					NPCHum.JumpPower = configs.JumpPower
				end
			end
			HumanoidDiedEvent(NPCHum)
		end
		if configs.AutoRemoveLag and (configs.IncludeLocalPlayer or player ~= LocalPlayer) then
			RemoveDisplays(char)
		end
		if configs.Chams and player ~= LocalPlayer then
			AddChams(char,true,{
				Color = configs.InnocentColor;
			})
		end
		if connections[b - 1] then
			connections[b - 1]:Disconnect()
		end
		connections[b - 1] = bp.ChildAdded:Connect(function(child)
			if child.ClassName == "Tool" then
				AssignRole(child)
			end
		end)
	end

	connections[b - 2] = player.CharacterAdded:Connect(function(character)
		CharacterAdded(character)
	end)
	CharacterAdded(character)

	for _, child in pairs(backpack:GetChildren()) do
		if child.ClassName == "Tool" then
			AssignRole(child)
		end
	end
	for _, child in pairs(character:GetChildren()) do
		if child.ClassName == "Tool" then
			AssignRole(child)
		end
	end
end
local function RemoveLagFromObject(object)
	if not object:FindFirstAncestorOfClass("Model") or not object:FindFirstAncestorOfClass("Model"):FindFirstChildOfClass("Humanoid") then
		if object:IsA("MeshPart") then
			object.Material = Enum.Material.SmoothPlastic
			object.TextureID = ""
		elseif object:IsA("UnionOperation") then
			object.Material = Enum.Material.SmoothPlastic
		elseif object:IsA("Decal") then
			object:Destroy()
		elseif object.ClassName == "SpecialMesh" and object.MeshType == Enum.MeshType.FileMesh then
			object.TextureId = ""
		elseif object:IsA("ParticleEmitter") or object:IsA("Trail") then
			object:Destroy()
		elseif object:IsA("BasePart") then
			object.Material = Enum.Material.SmoothPlastic
			object.Reflectance = 0
			object.TopSurface = Enum.SurfaceType.Smooth
			object.BottomSurface = Enum.SurfaceType.Smooth
			object.FrontSurface = Enum.SurfaceType.Smooth
			object.BackSurface = Enum.SurfaceType.Smooth
			object.LeftSurface = Enum.SurfaceType.Smooth
			object.RightSurface = Enum.SurfaceType.Smooth
		end
	end
end
function AimbotVisuals(path)
	task.wait()
	local prevatt
	local hue = 0

	local container = Instance.new("Part", workspace)
	container.Anchored = true
	container.CanCollide = false
	container.Transparency = 1

	for _, i in path do
		local att = Instance.new("Attachment", container)
		att.WorldPosition = i

		if prevatt then
			local beam = Instance.new("Beam", container)
			beam.FaceCamera = true
			beam.Attachment0 = prevatt
			beam.Attachment1 = att
			beam.Color = ColorSequence.new(Color3.fromHSV(hue/360, 0.560784, 1),Color3.fromHSV((hue + 3)/360, 0.560784, 1))
			beam.Segments = 1
			beam.Width0 = 0.3
			beam.Width1 = 0.3
		end
		hue += 3
		if hue >= 360 then
			hue = 0
		end
		prevatt = att
	end
	task.wait(5)
	container:Destroy()
end

---------------------------------------------------------------------------
-- GUI

local ScreenGui = Instance.new("ScreenGui")
local TextButton = Instance.new("TextButton")

ScreenGui.Parent = CoreGui
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

TextButton.Parent = ScreenGui
TextButton.AnchorPoint = Vector2.new(0.5, 0)
TextButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextButton.BackgroundTransparency = 0.500
TextButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextButton.BorderSizePixel = 0
TextButton.Position = UDim2.new(0.5, 0, 0, 0)
TextButton.Size = UDim2.new(0, 200, 0, 20)
TextButton.Font = Enum.Font.SourceSans
TextButton.Text = "Open GUI"
TextButton.TextColor3 = Color3.fromRGB(0, 0, 0)
TextButton.TextSize = 14.000

TextButton.MouseButton1Click:Connect(function()
	keypress(0xA1)
	task.wait()
	keyrelease(0xA1)
end)

---------------------------------------------------------------------------
-- Library

local Window = Library:CreateWindow({
	Name = "Murder Mystery 2";
	LoadingTitle = "Murder Mystery 2 Main";
	LoadingSubtitle = "by CITY512";
	ConfigurationSaving = {
		Enabled = true;
		FolderName = nil; -- Create a custom folder for your hub/game
		FileName = "MM2CHEATSBYCITY512"
	};
	Discord = {
		Enabled = false;
		Invite = "noinvitelink"; -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ABCD would be ABCD
		RememberJoins = true -- Set this to false to make them join the discord every time they load it up
	};
	KeySystem = false, -- Set this to true to use our key system
	KeySettings = {
		Title = "Untitled";
		Subtitle = "Key System";
		Note = "No method of obtaining the key is provided";
		FileName = "Key"; -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
		SaveKey = true; -- The user's key will be saved, but if you change the key, they will be unable to use your script
		GrabKeyFromSite = false; -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
		Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
	}
})

local Main = Window:CreateTab("Main", 10814531047) -- Title, Image
local LocalPlayerTab = Window:CreateTab("LocalPlayer", 4483362458) -- Title, Image
local Visuals = Window:CreateTab("Visuals", 13080349149) -- Title, Image
local Blatant = Window:CreateTab("Blatant", 10653372160) -- Title, Image
local AutoFarm = Window:CreateTab("Auto Farm", 12966420667) -- Title, Image
local Others = Window:CreateTab("Others", 11385220704) -- Title, Image

---------------------------------------------------------------------------
local Section = Main:CreateSection("Aimbot", true) -- The 2nd argument is to tell if its only a Title and doesnt contain element

local GunAimbot = Main:CreateToggle({
	Name = "Gun Aimbot";
	CurrentValue = false;
	Flag = "Gun Aimbot";
	Callback = function(value)
		configs.GunAimbot = value
	end;
})
local KnifeAimbot = Main:CreateToggle({
	Name = "Knife Aimbot";
	CurrentValue = false;
	Flag = "Knife Aimbot";
	Callback = function(value)
		configs.KnifeAimbot = value
	end;
})
local GunPrediction = Main:CreateSlider({
	Name = "Gun Prediction";
	Range = {0, 1000};
	Increment = 1;
	Suffix = "ms";
	CurrentValue = 150;
	Flag = "Ping Prediction";
	Callback = function(value)
		configs.GunPrediction = value
	end;
})
local KnifePrediction = Main:CreateSlider({
	Name = "Knife Prediction";
	Range = {0, 1000};
	Increment = 1;
	Suffix = "ms";
	CurrentValue = 100;
	Flag = "Knife Prediction";
	Callback = function(value)
		configs.KnifePrediction = value
	end;
})
local Dropdown = Main:CreateDropdown({
	Name = "Aimbot Method";
	Options = {"ClosestPlayerToCursor","ClosestPlayerToCharacter","ClosestPlayerToScreenCenter","Murderer/Target"};
	CurrentOption = "Murderer/Target";
	MultiSelection = false; -- If MultiSelections is allowed
	Flag = "Aimbot Method";
	Callback = function(option)
		configs.AimbotMethod = option
	end,
})
local FOV = Main:CreateSlider({
	Name = "FOV";
	Range = {0, 1000};
	Increment = 1;
	Suffix = "";
	CurrentValue = 350;
	Flag = "FOV";
	Callback = function(value)
		configs.FOV = value
		if Drawing then
			Drawing1.Radius = configs.FOV
			Drawing2.Radius = configs.FOV
		end
	end;
})

local Section = Main:CreateSection("Gun Mods", true) -- The 2nd argument is to tell if its only a Title and doesnt contain element

local AutoEquip = Main:CreateToggle({
	Name = "Auto Equip";
	CurrentValue = false;
	Flag = "Auto Equip";
	Callback = function(value)
		configs.AutoEquip = value
	end;
})
local AutoShoot = Main:CreateToggle({
	Name = "Auto Shoot";
	CurrentValue = false;
	Flag = "Auto Shoot";
	Callback = function(value)
		configs.AutoShoot = value
	end;
})

local Section = Main:CreateSection("Kill Aura", true) -- The 2nd argument is to tell if its only a Title and doesnt contain element

local KillAura = Main:CreateToggle({
	Name = "Kill Aura";
	CurrentValue = false;
	Flag = "Kill Aura";
	Callback = function(value)
		configs.KillAura = value
	end;
})
local KillAuraRange = Main:CreateSlider({
	Name = "Kill Aura Range";
	Range = {0, 100};
	Increment = 0.1;
	Suffix = "studs";
	CurrentValue = 15;
	Flag = "FOV";
	Callback = function(value)
		configs.KillAuraRange = value
	end;
})
local FaceTarget = Main:CreateToggle({
	Name = "Face Target";
	CurrentValue = false;
	Flag = "Face Target";
	Callback = function(value)
		configs.FaceTarget = value
	end;
})

---------------------------------------------------------------------------
local WalkSpeedToggle = LocalPlayerTab:CreateToggle({
	Name = "Toggle WalkSpeed";
	CurrentValue = false;
	Flag = "Toggle WalkSpeed";
	Callback = function(value)
		configs.ToggleWalkSpeed = value
		if not configs.ToggleWalkSpeed and LocalPlayer.Character then
			local lplrhum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
			if lplrhum then
				lplrhum.WalkSpeed = 16
			end
		end
	end;
})
local JumpPowerToggle = LocalPlayerTab:CreateToggle({
	Name = "Toggle JumpPower";
	CurrentValue = false;
	Flag = "Toggle JumpPower";
	Callback = function(value)
		configs.ToggleJumpPower = value
		if not configs.ToggleJumpPower and LocalPlayer.Character then
			local lplrhum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
			if lplrhum then
				lplrhum.JumpPower = 50
			end
		end
	end;
})
local WalkSpeed = LocalPlayerTab:CreateSlider({
	Name = "WalkSpeed";
	Range = {0, 100};
	Increment = 1;
	Suffix = "";
	CurrentValue = 16;
	Flag = "WalkSpeed";
	Callback = function(value)
		configs.WalkSpeed = value
		if configs.ToggleWalkSpeed and LocalPlayer.Character then
			local lplrhum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
			if lplrhum then
				lplrhum.WalkSpeed = configs.WalkSpeed
			end
		end
	end;
})
local JumpPower = LocalPlayerTab:CreateSlider({
	Name = "JumpPower";
	Range = {0, 100};
	Increment = 1;
	Suffix = "";
	CurrentValue = 50;
	Flag = "JumpPower";
	Callback = function(value)
		configs.JumpPower = value
		if configs.ToggleJumpPower and LocalPlayer.Character then
			local lplrhum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
			if lplrhum then
				lplrhum.JumpPower = configs.JumpPower
			end
		end
	end;
})
---------------------------------------------------------------------------
local Section = Visuals:CreateSection("Chams", true) -- The 2nd argument is to tell if its only a Title and doesnt contain element

local PlayerChams = Visuals:CreateToggle({
	Name = "Player Chams";
	CurrentValue = false;
	Flag = "Player Chams";
	Callback = function(value)
		configs.Chams = value
		if value then
			ChamPlayerRoles()
		else
			UnchamPlayers()				
		end
	end;
})
local ShowGunDrop = Visuals:CreateToggle({
	Name = "Show Gun Drop";
	CurrentValue = false;
	Flag = "Show Gun Drop";
	Callback = function(value)
		configs.ShowGunDrop = value
		for _, child in pairs(workspace:GetChildren()) do
			if child:IsA("BasePart") and child.Name == "GunDrop" then
				if configs.ShowGunDrop then
					AddChams(child,false,{
						Color = configs.GunDropColor;
					})
				else
					RemoveChams(child,false)
				end
			end
		end
	end;
})
local ShowTraps = Visuals:CreateToggle({
	Name = "Show Traps";
	CurrentValue = false;
	Flag = "Show Traps";
	Callback = function(value)
		configs.TrapESP = value
		for _, descendant in pairs(workspace:GetDescendants()) do
			if descendant:IsA("BasePart") and descendant.Name == "Trap" then
				if configs.TrapESP then
					AddChams(descendant,false,{
						Color = configs.TrapColor;
					})
				else
					RemoveChams(descendant,false)
				end
			end
		end
	end;
})
local MurdererColor = Visuals:CreateColorPicker({
	Name = "Murderer Color";
	Color = configs.MurdererColor;
	Flag = "Murderer Color";
	Callback = function(value)
		configs.MurdererColor = value
		UpdateAllChams()
	end
})
local TrapColor = Visuals:CreateColorPicker({
	Name = "Trap Color";
	Color = configs.TrapColor;
	Flag = "Trap Color";
	Callback = function(value)
		configs.TrapColor = value
		UpdateAllChams()
	end
})
local HeroColor = Visuals:CreateColorPicker({
	Name = "Hero/Target Color";
	Color = configs.HeroColor;
	Flag = "Hero Color";
	Callback = function(value)
		configs.HeroColor = value
		UpdateAllChams()
	end
})
local InnocentColor = Visuals:CreateColorPicker({
	Name = "Innocent Color";
	Color = configs.InnocentColor;
	Flag = "Innocent Color";
	Callback = function(value)
		configs.InnocentColor = value
		UpdateAllChams()
	end
})
local SheriffColor = Visuals:CreateColorPicker({
	Name = "Sheriff Color";
	Color = configs.SheriffColor;
	Flag = "Sheriff Color";
	Callback = function(value)
		configs.SheriffColor = value
		UpdateAllChams()
	end
})
local GunDropColor = Visuals:CreateColorPicker({
	Name = "Gun Drop Color";
	Color = configs.GunDropColor;
	Flag = "Gun Drop Color";
	Callback = function(value)
		configs.GunDropColor = value
		UpdateAllChams()
	end
})
if Drawing then
	local ShowFOVCircle = Visuals:CreateToggle({
		Name = "Show FOV Circle";
		CurrentValue = false;
		Flag = "Show FOV Circle";
		Callback = function(value)
			Drawing1.Visible = value
			Drawing2.Visible = value
		end;
	})
end
local ShowAimbotVisuals = Visuals:CreateToggle({
	Name = "Show Aimbot Visuals";
	CurrentValue = false;
	Flag = "Show Aimbot Visuals";
	Callback = function(value)
		configs.ShowAimbotVisuals = value
	end;
})

local Section = Visuals:CreateSection("World", true) -- The 2nd argument is to tell if its only a Title and doesnt contain element

local RemoveMapLag = Visuals:CreateButton({
	Name = "Remove Map Lag";
	Callback = function()
		if not scriptvariables.AntiLagAlreadyExecuted then
			scriptvariables.AntiLagAlreadyExecuted = true

			local Terrain = workspace.Terrain
			Terrain.WaterWaveSize = 0
			Terrain.WaterWaveSpeed = 0
			Terrain.WaterReflectance = 0
			Terrain.WaterTransparency = 0

			local Lighting = game.Lighting
			Lighting.GlobalShadows = false
			Lighting.FogEnd = 9e9
			settings().Rendering.QualityLevel = 1

			for _, child in pairs(Lighting:GetChildren()) do
				if child:IsA("BlurEffect") or child:IsA("SunRaysEffect") or child:IsA("ColorCorrectionEffect") or child:IsA("BloomEffect") or child:IsA("DepthOfFieldEffect") then
					child:Destroy()
				end
			end
			for _, descendant in pairs(workspace:GetDescendants()) do
				RemoveLagFromObject(descendant)
			end
		end
	end
})
local RemoveAccessoryLag = Visuals:CreateButton({
	Name = "Remove Accessory Lag";
	Callback = function()
		local lplrchar = LocalPlayer.Character
		for _, player in pairs(Players:GetPlayers()) do
			local character = player.Character
			if character and (configs.IncludeLocalPlayer or character ~= lplrchar) then
				RemoveDisplays(character)
			end
		end
	end;
})
local AutoRemoveLag = Visuals:CreateToggle({
	Name = "Auto Remove Lag";
	CurrentValue = false;
	Flag = "Auto Remove Lag";
	Callback = function(value)
		configs.AutoRemoveLag = value
	end;
})
local IncludeHats = Visuals:CreateToggle({
	Name = "Include Hats";
	CurrentValue = false;
	Flag = "Include Hats";
	Callback = function(value)
		configs.IncludeAccessories = value
	end;
})
local IncludeLocalPlayer = Visuals:CreateToggle({
	Name = "Include LocalPlayer";
	CurrentValue = false;
	Flag = "Include LocalPlayer";
	Callback = function(value)
		configs.IncludeLocalPlayer = value
	end;
})
---------------------------------------------------------------------------
local AnnounceRoles = Blatant:CreateButton({
	Name = "Announce Roles";
	Callback = function()
		local murderer = "nobody"
		local sheriff = "nobody"
		for _, player in pairs(Players:GetPlayers()) do
			if players[player.Name] then
				if players[player.Name].Role == "Murderer" then
					murderer = player.Name
				elseif players[player.Name].Role == "Sheriff" or players[player.Name].Role == "Hero" then
					sheriff = player.Name
				end
			end
		end
		local args = {
			[1] = "The murderer is "..murderer.." and the sheriff is "..sheriff;
			[2] = "normalchat"
		}
		ReplicatedStorage:WaitForChild("DefaultChatSystemEvents"):WaitForChild("SayMessageRequest"):FireServer(table.unpack(args))
	end,
})
local GrabGun = Blatant:CreateButton({
	Name = "Grab Gun",
	Callback = function()
		-- The function that takes place when the keybind is pressed
		-- The variable (Keybind) is a boolean for whether the keybind is being held or not (HoldToInteract needs to be true)
	end,
})
local AutoGrabGun = Blatant:CreateToggle({
	Name = "Auto Grab Gun";
	CurrentValue = false;
	Flag = "Auto Grab Gun";
	Callback = function(value)
		configs.AutoGrabGun = value
	end;
})
local KillAll = Blatant:CreateButton({
	Name = "Kill All";
	Callback = function()
		-- The function that takes place when the keybind is pressed
		-- The variable (Keybind) is a boolean for whether the keybind is being held or not (HoldToInteract needs to be true)
	end;
})

local Section = Blatant:CreateSection("Fling", true)

local FlingPlayerType = Blatant:CreateDropdown({
	Name = "Player",
	Options = "",
	CurrentOption = "";
	MultiSelection = false; -- If MultiSelections is allowed
	Flag = "Fling Player"; -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Option)
		configs.FlingPlayer = Option
	end;
})
local FlingPlayer = Blatant:CreateButton({
	Name = "Fling Player";
	Callback = function()
		local lplrchar = LocalPlayer.Character
		if not scriptvariables.AlreadyFlinging and configs.FlingPlayer and lplrchar then
			local player = Players:FindFirstChild(configs.FlingPlayer)
			local lplrhrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
			if player and lplrhrp then
				local NPCRoot = player:FindFirstChild("HumanoidRootPart")
				if NPCRoot then
					scriptvariables.AlreadyFlinging = true

					local bav = Instance.new("BodyAngularVelocity", lplrhrp)
					bav.AngularVelocity = Vector3.new(0,500000,0)
					bav.MaxTorque = Vector3.new(0,math.huge,0)
					bav.P = math.huge	

					while true do
						if not NPCRoot.Parent then scriptvariables.AlreadyFlinging = false break end

						lplrhrp.Position = NPCRoot.Position
						lplrhrp.Velocity = Vector3.new(0,0,0)
						task.wait()
					end
				end
			end
		end
	end;
})
---------------------------------------------------------------------------
local CoinFarm = AutoFarm:CreateToggle({
	Name = "Coin Farm";
	CurrentValue = false;
	Flag = "Coin Farm";
	Callback = function(value)
		configs.CoinFarm = value
	end;
})
local XPFarm = AutoFarm:CreateToggle({
	Name = "XP Farm";
	CurrentValue = false;
	Flag = "XP Farm";
	Callback = function(value)
		configs.XPFarm = value
	end;
})
local AutoUnbox = AutoFarm:CreateToggle({
	Name = "Auto Unbox";
	CurrentValue = false;
	Flag = "Auto Unbox";
	Callback = function(value)
		configs.AutoUnbox = value
	end;
})
local AutoUnboxCrate = AutoFarm:CreateDropdown({
	Name = "Auto Unbox Crate";
	Options = {"Crate #1","Crate #2","Crate #3"};
	CurrentOption = "Crate #1";
	MultiSelection = true; -- If MultiSelections is allowed
	Flag = "Auto Unbox Crate";
	Callback = function(option)
		configs.AutoUnboxCrate = option
	end,
})
---------------------------------------------------------------------------
local Dupe = Others:CreateButton({
	Name = "Dupe V2";
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/CITY512/scripts/main/mm2%20dupe"))()
	end;
})
local Rejoin = Others:CreateButton({
	Name = "Rejoin";
	Callback = function()
		Window:Notify({
			Title = "Info";
			Content = "Rejoining";
			Duration = 5;
			Image = "";
			Actions = {};
		})
		TeleportService:Teleport(game.PlaceId, LocalPlayer)
	end;
})
local Unload = Others:CreateButton({
	Name = "Unload";
	Callback = function()
		_G.mm2hacksalreadyloadedbyCITY512 = false
		scriptvariables.ScriptActivated = false
		Library:Destroy()
	end;
})
local KeepGUI = Others:CreateToggle({
	Name = "Keep GUI";
	CurrentValue = false;
	Flag = "Keep GUI";
	Callback = function(value)
		if scriptvariables.QueueOnTeleport then
			scriptvariables.ExecuteOnTeleport = value
		else
			Window:Notify({
				Title = "Error";
				Content = 'The function "queue_on_teleport" is not supported on this executor';
				Duration = 5;
				Image = "";
				Actions = {};
			})
		end
	end;
})

---------------------------------------------------------------------------
-- Events

eventfunctions.WorkspaceChildAdded = workspace.ChildAdded:Connect(function(instance)
	if instance:IsA("BasePart") and instance.Name == "GunDrop" then
		AddChams(instance,false,{
			Color = configs.GunDropColor;
		})
		if configs.AutoGrabGun then
			local lplrchar = LocalPlayer.Character
			if lplrchar then
				local lplrhrp = lplrchar:FindFirstChild("HumanoidRootPart")
				if lplrhrp then
					local prevCFrame = lplrhrp.CFrame
					lplrhrp.CFrame = instance.Position
					task.wait(0.5)
					lplrhrp.CFrame = prevCFrame
				end
			end
		end
	elseif instance:IsA("Model") and not instance:FindFirstChildOfClass("Humanoid") and instance.Name == "Normal" then
		match.SheriffDied = false
	end
end)
eventfunctions.WorkspaceChildRemoved = workspace.ChildRemoved:Connect(function(instance)
	if instance:IsA("Model") and not instance:FindFirstChildOfClass("Humanoid") and instance.Name == "Normal" then
		match.SheriffDied = false
	end
end)
eventfunctions.DescendantAdded = workspace.DescendantAdded:Connect(function(descendant)
	if descendant:IsA("BasePart") and descendant.Name == "Trap" then
		UpdateChams(descendant,false,{
			Color = configs.TrapColor;
		})
	elseif scriptvariables.AntiLagAlreadyExecuted then
		RemoveLagFromObject(descendant)
	end
end)
eventfunctions.OnTeleport = LocalPlayer.OnTeleport:Connect(function()
	if scriptvariables.ScriptActivated and not scriptvariables.TPCheck and scriptvariables.QueueOnTeleport and scriptvariables.ExecuteOnTeleport then
		scriptvariables.TPCheck = true
		scriptvariables.QueueOnTeleport('loadstring(game:HttpGet("https://raw.githubusercontent.com/CITY512/scripts/main/mm2%20hack.lua"))()')
	end
end)
eventfunctions.PlayerAdded = Players.PlayerAdded:Connect(function(player)
	FlingPlayerType:Add(player.Name)
	eventfunctions.Initialize(player)
end)
eventfunctions.PlayerRemoved = Players.PlayerRemoving:Connect(function(removedplayer)
	if players[removedplayer.Name] then
		players[removedplayer.Name].Disconnect()
		players[removedplayer.Name] = nil
	end
	FlingPlayerType:Remove(removedplayer.Name)
end)

---------------------------------------------------------------------------
-- Hooks

local namecall
namecall = hookmetamethod(game,"__namecall", function(self,...)
	local args = {...}
	local method = getnamecallmethod()

	if scriptvariables.ScriptActivated and not checkcaller() and LocalPlayer.Character then
		local lplrchar = LocalPlayer.Character
		if (configs.GunAimbot or configs.AutoShoot) and tostring(self) == "ShootGun" and tostring(method) == "InvokeServer" then
			local closest = GetClosestPlayer(configs.FOV,500)

			if not closest then return self.InvokeServer(self,...) end

			local lplrhrp = lplrchar.HumanoidRootPart
			local attachment = Instance.new("Attachment", lplrhrp)
			attachment.Position = Vector3.new(1.6, 1.2, -3)

			local path, aimpos = Aimbot:ComputePathAsync(attachment.WorldPosition,closest,100,0,{
				IgnoreList = nil;
				Ping = configs.GunPrediction;
				PredictSpamJump = true;
				IsAGun = true;
			})
			if configs.ShowAimbotVisuals then
				coroutine.wrap(AimbotVisuals)(path)
			end
			attachment:Destroy()

			args[2] = aimpos
			return aimpos and self.InvokeServer(self,table.unpack(args)) or self.InvokeServer(self,...)

		elseif configs.KnifeAimbot and tostring(self) == "Throw" and tostring(method) == "FireServer" then
			local closest = GetClosestPlayer(configs.FOV,500)

			if not closest then return self.FireServer(self,...) end

			local lplrhrp = lplrchar.HumanoidRootPart
			local attachment = Instance.new("Attachment", lplrhrp)
			attachment.Position = Vector3.new(1.5, 1.9, 1)
			local path, aimpos
			if powers.Sleight then
				path, aimpos = Aimbot:ComputePathAsync(attachment.WorldPosition,closest,weapons.Knife.Speed.Normal,0,{
					IgnoreList = nil;
					Ping = configs.KnifePrediction;
					PredictSpamJump = true;
				})
			else
				path, aimpos = Aimbot:ComputePathAsync(attachment.WorldPosition,closest,weapons.Knife.Speed.Sleight,0,{
					IgnoreList = nil;
					Ping = configs.KnifePrediction;
					PredictSpamJump = true;
				})
			end
			if configs.ShowAimbotVisuals then
				coroutine.wrap(AimbotVisuals)(path)
			end

			powers.Sleight = false
			attachment:Destroy()

			args[1] = CFrame.new(aimpos)
			return aimpos and self.FireServer(self,table.unpack(args)) or self.FireServer(self,...)
		end
	end
	return namecall(self,...)
end)

---------------------------------------------------------------------------
-- Loops

for _, player in pairs(Players:GetPlayers()) do
	FlingPlayerType:Add(player.Name)
	eventfunctions.Initialize(player)
end

local prevtarget
while true do
	if prevtarget then
		local PrevTargetRoot = prevtarget:FindFirstChild("HumanoidRootPart")
		if PrevTargetRoot and PrevTargetRoot:IsA("BasePart") then
			local PrevTargetRoot = prevtarget.HumanoidRootPart
			PrevTargetRoot.Size = Vector3.new(2,2,1)
		end
		prevtarget = nil
	end
	if Drawing and configs.ShowFOVCircle then
		local mousepos = Vector2.new(Mouse.X,Mouse.Y)
		Drawing1.Position = mousepos
		Drawing2.Position = mousepos
	end
	if not scriptvariables.ScriptActivated then break end

	local lplrchar = LocalPlayer.Character
	if lplrchar then
		local lplrhrp = lplrchar:FindFirstChild("HumanoidRootPart")
		local lplrhum = lplrchar:FindFirstChildOfClass("Humanoid")
		if lplrhum and lplrhrp and lplrhum.Health > 0 and lplrhrp:IsA("BasePart") then
			if configs.KillAura then
				local Knife = lplrchar:FindFirstChild("Knife")
				if Knife and Knife.ClassName == "Tool" then
					local closest
					for _, player in pairs(Players:GetPlayers()) do
						local character = player.Character
						if character and character ~= lplrchar then
							local NPCRoot = character:FindFirstChild("HumanoidRootPart")
							if NPCRoot and NPCRoot:IsA("BasePart") then
								local distance = (NPCRoot.Position - lplrhrp.Position).Magnitude
								if distance < configs.KillAuraRange then
									if not closest or distance < closest[2] then
										closest = {character,distance}
									end
								end
							end
						end
					end
					if closest then
						prevtarget = closest[1]

						local TargetRoot = prevtarget.HumanoidRootPart
						if configs.FaceTarget then
							lplrhrp.CFrame = CFrame.new(lplrhrp.Position,TargetRoot.Position * Vector3.new(1,0,1) + lplrhrp.Position * Vector3.new(0,1,0))
						end
						TargetRoot.CanCollide = false
						TargetRoot.Size = Vector3.new(configs.KillAuraRange,configs.KillAuraRange,configs.KillAuraRange)
						Knife:Activate()
					end
				end
			end
			if players[LocalPlayer.Name] and (players[LocalPlayer.Name].Role == "Sheriff" or players[LocalPlayer.Name].Role == "Hero") and not lplrchar:FindFirstChild("Gun") then
				local Gun = lplrchar:FindFirstChild("Gun")
				if configs.AutoEquip and (not Gun or Gun.ClassName ~= "Tool") then
					local bp = LocalPlayer:FindFirstChild("Backpack")
					if bp then
						for _, child in pairs(bp:GetChildren()) do
							if child.ClassName == "Tool" and child.Name == "Gun" then
								lplrhum:EquipTool(child)
							end
						end
					end
				end
				if configs.AutoShoot and Gun and Gun.ClassName == "Tool" and Gun:FindFirstChild("Handle") and Gun:FindFirstChild("KnifeServer") and Gun.KnifeServer:FindFirstChild("ShootGun") then
					for _, player in pairs(Players:GetPlayers()) do
						local character = player.Character
						if character then
							local NPCRoot = character:FindFirstChild("HumanoidRootPart") 
							if NPCRoot and NPCRoot:IsA("BasePart") and players[player.Name] and players[player.Name].Role == "Murderer" then
								local startpos = lplrchar.Gun.Handle.Position

								local params = RaycastParams.new()
								params.FilterDescendantsInstances = {character,lplrchar}
								params.FilterType = Enum.RaycastFilterType.Exclude

								local raycast = workspace:Raycast(startpos, NPCRoot.Position - startpos, params)
								if not raycast or not raycast.Position then
									lplrchar.Gun.KnifeServer.ShootGun:InvokeServer()
								end
							end
						end
					end
				end
			end
		end
	end
	task.wait()
end
