local CoreGui = game:GetService("CoreGui")
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
if not hookmetamethod or not setreadonly or not newcclosure or not getnamecallmethod then -- Checks if executor is supported
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
	Prediction = 50;
	AimbotMethod = "Murderer/Target";
	FOV = 350;
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

	Chams = false;
	ShowGunDrop = false;
	MurdererColor = Color3.fromRGB(255, 112, 112);
	HeroColor = Color3.fromRGB(255, 231, 112);
	InnocentColor = Color3.fromRGB(143, 255, 112);
	SheriffColor = Color3.fromRGB(112, 136, 255);
	GunDropColor = Color3.fromRGB(141, 112, 255);
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
	antilagalreadyexecuted = true;
	scriptactivated = true;
	executeonteleport = false;
	tpcheck = false;
	queueonteleport = syn and syn.queue_on_teleport or queue_on_teleport or fluxus and fluxus.queue_on_teleport;
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
						local characterroot = character:FindFirstChild("HumanoidRootPart")
						if characterroot and characterroot:IsA("BasePart") then
							local distance = (characterroot.Position - lplrhrp.Position).Magnitude
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

	local function Disconnect()
		if connections[b] then
			connections[b]:Disconnect()
		end
		if connections[b - 1] then
			connections[b - 1]:Disconnect()
		end
		if connections[b - 2] then
			connections[b - 2]:Disconnect()
		end
		if connections[b - 3] then
			connections[b - 3]:Disconnect()
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
			print(tostring(player),"has died.")
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
		local humanoid = char:WaitForChild("Humanoid")
		if humanoid.ClassName == "Humanoid" then
			HumanoidDiedEvent(humanoid)
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
		print(tostring(player).."'s character has been added.")
		CharacterAdded(character)
	end)
	connections[b - 3] = Players.PlayerRemoving:Connect(function(removedplayer)
		if removedplayer == player then
			players[player.Name] = nil
			Disconnect()
		end
		print(tostring(removedplayer),"has left the game")
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

	print("Initialized",tostring(player))
end

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
local AutoFarm = Window:CreateTab("Auto Farm", 12966420667) -- Title, Image
local Others = Window:CreateTab("Others", 11385220704) -- Title, Image

local Section = Main:CreateSection("Aimbot", true) -- The 2nd argument is to tell if its only a Title and doesnt contain element

local GunAimbot = Main:CreateToggle({
	Name = "Gun Aimbot";
	CurrentValue = false;
	Flag = "Gun Aimbot";
	Callback = function(value)
		configs.GunAimbot = value
		print("Gun Aimbot has been set to",value)
	end;
})
local KnifeAimbot = Main:CreateToggle({
	Name = "Knife Aimbot";
	CurrentValue = false;
	Flag = "Knife Aimbot";
	Callback = function(value)
		configs.KnifeAimbot = value
		print("Knife Aimbot has been set to",value)
	end;
})
local PingPrediction = Main:CreateSlider({
	Name = "Ping Prediction";
	Range = {0, 1000};
	Increment = 1;
	Suffix = "ms";
	CurrentValue = 50;
	Flag = "Ping Prediction";
	Callback = function(value)
		configs.Prediction = value
		print("Prediction has been set to",value)
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
		print("Aimbot Method has been set to",option)
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
		print("FOV has been set to",value)
	end;
})

local Section = Main:CreateSection("Kill Aura", true) -- The 2nd argument is to tell if its only a Title and doesnt contain element

local KillAura = Main:CreateToggle({
	Name = "Kill Aura";
	CurrentValue = false;
	Flag = "Kill Aura";
	Callback = function(value)
		configs.KillAura = value
		print("Kill Aura has been set to",value)
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
		print("Kill Aura Range has been set to",value)
	end;
})
local FaceTarget = Main:CreateToggle({
	Name = "Face Target";
	CurrentValue = false;
	Flag = "Face Target";
	Callback = function(value)
		configs.FaceTarget = value
		print("Face Target has been set to",value)
	end;
})
local WalkSpeedToggle = LocalPlayerTab:CreateToggle({
	Name = "Toggle WalkSpeed";
	CurrentValue = false;
	Flag = "Toggle WalkSpeed";
	Callback = function(value)
		configs.ToggleWalkSpeed = value
		if not configs.ToggleWalkSpeed and LocalPlayer.Character then
			local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
			if humanoid then
				humanoid.WalkSpeed = 16
			end
		end
		print("WalkSpeed Enabled has been set to",value)
	end;
})
local JumpPowerToggle = LocalPlayerTab:CreateToggle({
	Name = "Toggle JumpPower";
	CurrentValue = false;
	Flag = "Toggle JumpPower";
	Callback = function(value)
		configs.ToggleJumpPower = value
		if not configs.ToggleJumpPower and LocalPlayer.Character then
			local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
			if humanoid then
				humanoid.JumpPower = 50
			end
		end
		print("JumpPower Enabled has been set to",value)
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
			local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
			if humanoid then
				humanoid.WalkSpeed = configs.WalkSpeed
			end
		end
		print("WalkSpeed has been set to",value)
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
			local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
			if humanoid then
				humanoid.JumpPower = configs.JumpPower
			end
		end
		print("JumpPower has been set to",value)
	end;
})

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
		print("Player Chams has been set to",value)
	end;
})
local ShowGunDrop = Visuals:CreateToggle({
	Name = "Show Gun Drop";
	CurrentValue = false;
	Flag = "Show Gun Drop";
	Callback = function(value)
		configs.ShowGunDrop = value
		print("Show Gun Drop has been set to",value)
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
local HeroColor = Visuals:CreateColorPicker({
	Name = "Hero Color";
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
			print("Show FOV Circle has been set to",value)
		end;
	})
end

local Section = Visuals:CreateSection("World", true) -- The 2nd argument is to tell if its only a Title and doesnt contain element

local RemoveMapLag = Visuals:CreateButton({
	Name = "Remove Map Lag";
	Callback = function()
		if not scriptvariables.antilagalreadyexecuted then
			scriptvariables.antilagalreadyexecuted = true

			local Terrain = workspace.Terrain
			Terrain.WaterWaveSize = 0
			Terrain.WaterWaveSpeed = 0
			Terrain.WaterReflectance = 0
			Terrain.WaterTransparency = 0

			local Lighting = game.Lighting
			Lighting.GlobalShadows = false
			Lighting.FogEnd = 9e9
			settings().Rendering.QualityLevel = 1

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
			for _, child in pairs(Lighting:GetChildren()) do
				if child:IsA("BlurEffect") or child:IsA("SunRaysEffect") or child:IsA("ColorCorrectionEffect") or child:IsA("BloomEffect") or child:IsA("DepthOfFieldEffect") then
					child:Destroy()
				end
			end
			for _, descendant in pairs(workspace:GetDescendants()) do
				RemoveLagFromObject(descendant)
			end
			workspace.DescendantAdded:Connect(function(descendant)
				RemoveLagFromObject(descendant)
			end)
		end
		print("Remove Map Lag Activated")
	end;
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
		print("Remove Accessory Lag Activated")
	end;
})
local AutoRemoveLag = Visuals:CreateToggle({
	Name = "Auto Remove Lag";
	CurrentValue = false;
	Flag = "Auto Remove Lag";
	Callback = function(value)
		configs.AutoRemoveLag = value
		print("Auto Remove Lag has been set to",value)
	end;
})
local IncludeHats = Visuals:CreateToggle({
	Name = "Include Hats";
	CurrentValue = false;
	Flag = "Include Hats";
	Callback = function(value)
		configs.IncludeAccessories = value
		print("Include Hats has been set to",value)
	end;
})
local IncludeLocalPlayer = Visuals:CreateToggle({
	Name = "Include LocalPlayer";
	CurrentValue = false;
	Flag = "Include LocalPlayer";
	Callback = function(value)
		configs.IncludeLocalPlayer = value
		print("Include LocalPlayer has been set to",value)
	end;
})

local CoinFarm = AutoFarm:CreateToggle({
	Name = "Coin Farm";
	CurrentValue = false;
	Flag = "Coin Farm";
	Callback = function(value)
		configs.CoinFarm = value
		print("Coin Farm has been set to",value)
	end;
})
local XPFarm = AutoFarm:CreateToggle({
	Name = "XP Farm";
	CurrentValue = false;
	Flag = "XP Farm";
	Callback = function(value)
		configs.XPFarm = value
		print("XP Farm has been set to",value)
	end;
})
local AutoUnbox = AutoFarm:CreateToggle({
	Name = "Auto Unbox";
	CurrentValue = false;
	Flag = "Auto Unbox";
	Callback = function(value)
		configs.AutoUnbox = value
		print("Auto Unbox has been set to",value)
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
		print("Auto Unbox Crate has been set to",table.unpack(option))
	end,
})

local Dupe = Others:CreateButton({
	Name = "Dupe";
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
		})
		TeleportService:Teleport(game.PlaceId, LocalPlayer)
	end;
})
local Unload = Others:CreateButton({
	Name = "Unload";
	Callback = function()
		_G.mm2hacksalreadyloadedbyCITY512 = false
		scriptvariables.scriptactivated = false
		Library:Destroy()
	end;
})
local KeepGUI = Others:CreateToggle({
	Name = "Keep GUI";
	CurrentValue = false;
	Flag = "Keep GUI";
	Callback = function(value)
		if scriptvariables.queueonteleport then
			scriptvariables.executeonteleport = value
			print("Keep GUI has been set to",value)
		else
			Window:Notify({
				Title = "Error";
				Content = 'The function "queue_on_teleport" is not supported on this executor';
				Duration = 5;
				Image = "";
			})
		end
	end;
})

-- Events

eventfunctions.WorkspaceChildAdded = workspace.ChildAdded:Connect(function(instance)
	if instance:IsA("BasePart") and instance.Name == "GunDrop" then
		AddChams(instance,false,{
			Color = configs.GunDropColor;
		})
	elseif instance:IsA("Model") and not instance:FindFirstChildOfClass("Humanoid") and instance.Name == "Normal" then
		match.SheriffDied = false
	end
end)
eventfunctions.WorkspaceChildRemoved = workspace.ChildRemoved:Connect(function(instance)
	if instance:IsA("Model") and not instance:FindFirstChildOfClass("Humanoid") and instance.Name == "Normal" then
		match.SheriffDied = false
	end
end)
eventfunctions.OnTeleport = LocalPlayer.OnTeleport:Connect(function()
	if scriptvariables.scriptactivated and not scriptvariables.tpcheck and scriptvariables.queueonteleport and scriptvariables.executeonteleport then
		scriptvariables.tpcheck = true
		scriptvariables.queueonteleport('loadstring(game:HttpGet("https://raw.githubusercontent.com/CITY512/scripts/main/mm2%20hack.lua"))()')
	end
end)
eventfunctions.PlayerAdded = Players.PlayerAdded:Connect(function(player)
	print(tostring(player),"has joined the game")
	eventfunctions.Initialize(player)
end)

-- Hooks

local namecall
namecall = hookmetamethod(game,"__namecall", function(self,...)
	local args = {...}
	local method = getnamecallmethod()
		
	if scriptvariables.scriptactivated and not checkcaller() and LocalPlayer.Character then
		local lplrchar = LocalPlayer.Character
		if configs.GunAimbot and tostring(self) == "ShootGun" and tostring(method) == "InvokeServer" then
			local closest = GetClosestPlayer(configs.FOV,500)

			if not closest then return self.InvokeServer(self,...) end

			local HumanoidRootPart = lplrchar.HumanoidRootPart
			local attachment = Instance.new("Attachment", HumanoidRootPart)
			attachment.Position = Vector3.new(1.6, 1.2, -3)

			local _, aimpos = Aimbot:ComputePathAsync(attachment.WorldPosition,closest,100,0,nil,true,configs.Prediction,nil,true)
			attachment:Destroy()

			args[2] = aimpos
			return aimpos and self.InvokeServer(self,table.unpack(args)) or self.InvokeServer(self,...)

		elseif configs.KnifeAimbot and tostring(self) == "Throw" and tostring(method) == "FireServer" then
			local closest = GetClosestPlayer(configs.FOV,500)

			if not closest then return self.FireServer(self,...) end

			local HumanoidRootPart = lplrchar.HumanoidRootPart
			local attachment = Instance.new("Attachment", HumanoidRootPart)
			attachment.Position = Vector3.new(1.5, 1.9, 1)
			local aimpos
			if powers.Sleight then
				_, aimpos = Aimbot:ComputePathAsync(attachment.WorldPosition,closest,100,0,nil,true,configs.Prediction,nil,false)
			else
				_, aimpos = Aimbot:ComputePathAsync(attachment.WorldPosition,closest,80,0,nil,true,configs.Prediction,nil,false)
			end
			powers.Sleight = false
			attachment:Destroy()

			args[1] = CFrame.new(aimpos,aimpos)
			return aimpos and self.FireServer(self,table.unpack(args)) or self.FireServer(self,...)
		elseif configs.KnifeAimbot and tostring(self) == "Sleight" and tostring(method) == "FireServer" then
			powers.Sleight = true
		end
	end
	return namecall(self,...)
end)

-- Loops
for _, player in pairs(Players:GetPlayers()) do
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
	if not scriptvariables.scriptactivated then break end
	
	if configs.KillAura then
		local lplrchar = LocalPlayer.Character
		if lplrchar then
			local HumanoidRootPart = lplrchar:FindFirstChild("HumanoidRootPart")
			local Knife = lplrchar:FindFirstChild("Knife")
			if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") and Knife and Knife.ClassName == "Tool" then
				local closest
				for _, player in pairs(Players:GetPlayers()) do
					local character = player.Character
					if character and character ~= lplrchar then
						local NPCRoot = character:FindFirstChild("HumanoidRootPart")
						if NPCRoot and NPCRoot:IsA("BasePart") then
							local distance = (NPCRoot.Position - HumanoidRootPart.Position).Magnitude
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
						HumanoidRootPart.CFrame = CFrame.new(HumanoidRootPart.Position,TargetRoot.Position * Vector3.new(1,0,1) + HumanoidRootPart.Position * Vector3.new(0,1,0))
					end
					TargetRoot.CanCollide = false
					TargetRoot.Size = Vector3.new(configs.KillAuraRange,configs.KillAuraRange,configs.KillAuraRange)
					Knife:Activate()
				end
			end
		end
	end
	task.wait()
end
