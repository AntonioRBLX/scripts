-- Dev Notes
--[[
	When Activating "XP Farm" Deactivate "Steal Gun" and "Reset After Full Bag" Element
	Fix Auto Shoot Gun Not Working
	Complete functions TeleportToLobby() and TeleportToMap() and TeleportAboveMap()
	Complete LoadValueList (check if httprequest return tables to inspect <div class="itemhead"> in req.Body)
]]
local MM2MAINBYCITY512CURRENTLYUNDERMAINTENANCE = true
local debugaccounts = {571396351,7613990559,3528775757,7705187791,7761426924,7763687727,7808586275,7820205672,967814529,8565004006,8703124688,3532512637}
if MM2MAINBYCITY512 or MM2MAINBYCITY512CURRENTLYUNDERMAINTENANCE and not table.find(debugaccounts,game.Players.LocalPlayer.UserId) then return end -- Developer Mode
getgenv().MM2MAINBYCITY512 = true
-- Library
getgenv().FPSLibraryProtectGui = true
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/PhantomRBLX/PhantomX/refs/heads/main/InterfaceLibrary.lua", true))()
local MM2MainErrorNotification = function(notification)
	Library:Notify({
		Type = "error"; -- (Required) id0x1 = Error, id0x2 = Info, id0x3 = Success, set to nil for normal notification
		Title = "Error";
		Message = notification; -- (Required)
		Duration = 10; -- (Required)
		Sound = 5801257793;
		Actions = {}
	})
end
-- Exploit Functions
local httprequest = syn and syn.request or http and http.request or http_request or fluxus and fluxus.request or request
local queueonteleport = syn and syn.queue_on_teleport or queue_on_teleport or fluxus and fluxus.queue_on_teleport
local cloneref = cloneref or function(o) return o end
local Drawing = Drawing or function()
	local Drawing = {}
	function Drawing.new(shape)
		local drawing = {}
		drawing.Visible = true
		drawing.From = Vector2.new(0,0)
		drawing.To = Vector2.new(200,200)
		drawing.Color = Color3.fromRGB(255,255,255)
		drawing.Thickness = 2
		drawing.Transparency = 1
		drawing.Position = Vector2.new(0,0)
		function drawing:Remove() end
		return drawing
	end
	return Drawing
end
---------------------------------------------------------------------------
-- Services
local UIS = cloneref(game:GetService("UserInputService"))
local Players = cloneref(game:GetService("Players"))
local HttpService = cloneref(game:GetService("HttpService"))
local RF = cloneref(game:GetService("ReplicatedFirst"))
local CoreGui = cloneref(game:GetService("CoreGui"))
local RS = cloneref(game:GetService("RunService"))
local REPS = cloneref(game:GetService("ReplicatedStorage"))
local StarterGui = cloneref(game:GetService("StarterGui"))
local TeleportService = cloneref(game:GetService("TeleportService"))
local TextChatService = cloneref(game:GetService("TextChatService"))
local Lighting = cloneref(game:GetService("Lighting"))
local Debris = cloneref(game:GetService("Debris"))
---------------------------------------------------------------------------
-- Custom Loading Screen
local LoadingScreen = game:GetObjects("rbxassetid://73421491104719")[1]
TeleportService:SetTeleportGui(LoadingScreen)
LoadingScreen.Parent = RF
---------------------------------------------------------------------------
local SupportedGames = {
	Classic = 142823291;
	Assassin = 636649648;
	Disguised = 335132309;
	VampireHunt = 73210641948512;
}
local GameModes = {
	Classic = "Classic";
	Assassin = "Assassin";
	Disguised = "Disguised";
	Infection = "Infection";
}
if game.PlaceId ~= SupportedGames.Classic and game.PlaceId ~= SupportedGames.Assassin and game.PlaceId ~= SupportedGames.Disguised then -- Checks if they're playing the right game
	MM2MainErrorNotification("Unsupported Game!")
	return
end
-- Aimbot Module
local Aimbot = loadstring(game:HttpGet("https://raw.githubusercontent.com/CITY512/modules/main/Projectile%20Aimbot/Projectile%20Aimbot.lua"))()
---------------------------------------------------------------------------
-- ReplicatedStorage
local Database = REPS:WaitForChild("Database")
local DatabaseSync = Database:WaitForChild("Sync")
local RemotesFolder = REPS:WaitForChild("Remotes")
local MiscFolder = RemotesFolder:WaitForChild("Misc")
local PlayEmoteBindable = MiscFolder:WaitForChild("PlayEmote")
local InventoryFolder = RemotesFolder:WaitForChild("Inventory")
local GameplayFolder = RemotesFolder:WaitForChild("Gameplay")
local ExtrasFolder = RemotesFolder:WaitForChild("Extras")
local EquipItemEvent = InventoryFolder:WaitForChild("Equip")
local PrestigeEvent = InventoryFolder:WaitForChild("Prestige")
local ChangeTarget = GameplayFolder:WaitForChild("ChangeTarget")
local RoleSelectRemote = GameplayFolder:WaitForChild("RoleSelect")
local LoadingMap = GameplayFolder:WaitForChild("LoadingMap")
local Fade = GameplayFolder:WaitForChild("Fade")
local VictoryScreen = GameplayFolder:WaitForChild("VictoryScreen")
local GetFullInventoryRemote = ExtrasFolder:WaitForChild("GetFullInventory")
local GetPlayerDataRemote = ExtrasFolder:WaitForChild("GetPlayerData")
local ReplicateToyRemote = ExtrasFolder:WaitForChild("ReplicateToy")
local CustomGamesFolder = RemotesFolder:WaitForChild("CustomGames")
local DuelStartedRemote = CustomGamesFolder:WaitForChild("DuelStarted")
-- Game Modules
--local GameItems = require(DatabaseSync:WaitForChild("Item"))
---------------------------------------------------------------------------
-- LocalPlayer
while not Players.LocalPlayer do task.wait() end
local LocalPlayer = Players.LocalPlayer
if not LocalPlayer.Character then
	Library:Notify({
		Type = "info"; -- (Required) id0x1 = Error, id0x2 = Info, id0x3 = Success, set to nil for normal notification
		Title = "Info";
		Message = "Waiting For Character To Load."; -- (Required)
		Duration = 5; -- (Required)
	})
end
local LPlrChar = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local LPlrHum = LPlrChar:WaitForChild("Humanoid")
local LPlrHrp = LPlrChar:WaitForChild("HumanoidRootPart")
local Backpack = LocalPlayer:WaitForChild("Backpack")
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera
---------------------------------------------------------------------------
-- Mobile GUI
local MobileButtonGUI = Instance.new("ScreenGui", CoreGui)
local MobileButtonContainer = Instance.new("Frame", MobileButtonGUI)
MobileButtonContainer.BackgroundTransparency = 1
MobileButtonContainer.Position = UDim2.new(1, -95, 1, -90)
MobileButtonContainer.Size = UDim2.new(0, 70, 0, 70)
MobileButtonContainer.Visible = false
local FlyButton = Instance.new("ImageButton", MobileButtonContainer)
FlyButton.BackgroundTransparency = 1
FlyButton.Image = "rbxassetid://126043950347590"
FlyButton.Position = UDim2.new(-1.1, 26, 0, 12)
FlyButton.Size = UDim2.new(1, -25, 1, -25)
FlyButton.PressedImage = "rbxassetid://109444847951538"
FlyButton.Visible = false
local NoclipButton = Instance.new("ImageButton", MobileButtonContainer)
NoclipButton.BackgroundTransparency = 1
NoclipButton.Image = "rbxassetid://130972398264323"
NoclipButton.Position = UDim2.new(-1.1, 26, 0, 12)
NoclipButton.Size = UDim2.new(1, -25, 1, -25)
NoclipButton.PressedImage = "rbxassetid://108373759484173"
NoclipButton.Visible = false
---------------------------------------------------------------------------
-- MM2 Login Interface
local MM2MainLogin = Instance.new("ScreenGui")
local MM2MainLoginBackground = Instance.new("ImageLabel")
do
	local TextLabel = Instance.new("TextLabel")
	local Username = Instance.new("TextBox")
	local Password = Instance.new("TextBox")
	local HiddenLayer = Instance.new("TextLabel")
	local Login = Instance.new("TextButton")
	MM2MainLogin.Name = "MM2MainLogin"
	MM2MainLogin.Parent = CoreGui
	MM2MainLogin.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	MM2MainLoginBackground.Name = "MM2MainLoginBackground"
	MM2MainLoginBackground.Parent = MM2MainLogin
	MM2MainLoginBackground.AnchorPoint = Vector2.new(0.5, 0.5)
	MM2MainLoginBackground.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	MM2MainLoginBackground.BorderColor3 = Color3.fromRGB(0, 0, 0)
	MM2MainLoginBackground.BorderSizePixel = 0
	MM2MainLoginBackground.Position = UDim2.new(0.5, 0, 0.5, 0)
	MM2MainLoginBackground.Size = UDim2.new(0, 260, 0, 200)
	MM2MainLoginBackground.Visible = false
	MM2MainLoginBackground.Image = "rbxassetid://113775492295983"
	TextLabel.Parent = MM2MainLoginBackground
	TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.BackgroundTransparency = 1.000
	TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TextLabel.BorderSizePixel = 0
	TextLabel.Position = UDim2.new(0, 0, 0, 2)
	TextLabel.Size = UDim2.new(1, 0, 0, 13)
	TextLabel.Font = Enum.Font.SourceSansBold
	TextLabel.Text = "Membership Login"
	TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.TextScaled = true
	TextLabel.TextSize = 14.000
	TextLabel.TextWrapped = true
	Username.Name = "Username"
	Username.Parent = MM2MainLoginBackground
	Username.AnchorPoint = Vector2.new(0.5, 0)
	Username.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Username.BorderColor3 = Color3.fromRGB(255, 255, 255)
	Username.Position = UDim2.new(0.5, 0, 0, 50)
	Username.Size = UDim2.new(0, 200, 0, 25)
	Username.ClearTextOnFocus = false
	Username.Font = Enum.Font.SourceSans
	Username.PlaceholderText = "Enter Username (not roblox username)"
	Username.Text = ""
	Username.TextColor3 = Color3.fromRGB(255, 255, 255)
	Username.TextSize = 14.000
	Password.Name = "Password"
	Password.Parent = MM2MainLoginBackground
	Password.AnchorPoint = Vector2.new(0.5, 0)
	Password.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Password.BorderColor3 = Color3.fromRGB(255, 255, 255)
	Password.Position = UDim2.new(0.5, 0, 0, 80)
	Password.Size = UDim2.new(0, 200, 0, 25)
	Password.ClearTextOnFocus = false
	Password.Font = Enum.Font.SourceSans
	Password.PlaceholderText = "Enter Password"
	Password.Text = ""
	Password.TextColor3 = Color3.fromRGB(0, 0, 0)
	Password.TextSize = 14.000
	HiddenLayer.Name = "HiddenLayer"
	HiddenLayer.Parent = Password
	HiddenLayer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	HiddenLayer.BackgroundTransparency = 1.000
	HiddenLayer.BorderColor3 = Color3.fromRGB(0, 0, 0)
	HiddenLayer.BorderSizePixel = 0
	HiddenLayer.Size = UDim2.new(1, 0, 1, 0)
	HiddenLayer.Font = Enum.Font.SourceSans
	HiddenLayer.Text = ""
	HiddenLayer.TextColor3 = Color3.fromRGB(255, 255, 255)
	HiddenLayer.TextSize = 14.000
	Login.Name = "Login"
	Login.Parent = MM2MainLoginBackground
	Login.AnchorPoint = Vector2.new(0.5, 0)
	Login.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Login.BorderColor3 = Color3.fromRGB(255, 255, 255)
	Login.Position = UDim2.new(0.5, 0, 0, 130)
	Login.Size = UDim2.new(0, 150, 0, 35)
	Login.Style = Enum.ButtonStyle.RobloxRoundButton
	Login.Font = Enum.Font.SourceSans
	Login.Text = "Login"
	Login.TextColor3 = Color3.fromRGB(255, 255, 255)
	Login.TextSize = 14.000
	local function EZBDK_fake_script()
		local script = Instance.new('LocalScript', MM2MainLogin)
		local usernametextbox = script.Parent:WaitForChild("MM2MainLoginBackground"):WaitForChild("Username")
		local passwordtextbox = script.Parent:WaitForChild("MM2MainLoginBackground"):WaitForChild("Password")
		local hiddenlayer = passwordtextbox:WaitForChild("HiddenLayer")
		local login = script.Parent:WaitForChild("MM2MainLoginBackground"):WaitForChild("Login")
		local function Update()
			hiddenlayer.Text = ("•"):rep(#passwordtextbox.Text)
			if #passwordtextbox.Text <= 0 then
				passwordtextbox.TextTransparency = 0
			else
				passwordtextbox.TextTransparency = 1
			end
			if usernametextbox.Text ~= "" and passwordtextbox.Text ~= "" and #passwordtextbox.Text >= 8 then
				login.Style = Enum.ButtonStyle.RobloxRoundDefaultButton
			else
				login.Style = Enum.ButtonStyle.RobloxRoundButton
			end
		end
		usernametextbox:GetPropertyChangedSignal("Text"):Connect(Update)
		passwordtextbox:GetPropertyChangedSignal("Text"):Connect(Update)
	end
	coroutine.wrap(EZBDK_fake_script)()
	local dragging
	local startpos
	local lastmousepos
	local lastgoalpos
	local function Lerp(a, b, m)
		return a + (b - a) * m
	end
	MM2MainLoginBackground.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			startpos = MM2MainLoginBackground.Position
			lastmousepos = UIS:GetMouseLocation()
			local inputchanged
			inputchanged = input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
					inputchanged:Disconnect()
				end
			end)
		end
	end)
	RS.RenderStepped:Connect(function(dt)
		if not startpos then return end;
		if not dragging and lastgoalpos then
			MM2MainLoginBackground.Position = UDim2.new(startpos.X.Scale, Lerp(MM2MainLoginBackground.Position.X.Offset, lastgoalpos.X.Offset, dt * 8), startpos.Y.Scale, Lerp(MM2MainLoginBackground.Position.Y.Offset, lastgoalpos.Y.Offset, dt * 8))
			return 
		end
		local delta = lastmousepos - UIS:GetMouseLocation()
		local xGoal = startpos.X.Offset - delta.X
		local yGoal = startpos.Y.Offset - delta.Y
		lastgoalpos = UDim2.new(startpos.X.Scale, xGoal, startpos.Y.Scale, yGoal)
		MM2MainLoginBackground.Position = UDim2.new(startpos.X.Scale, Lerp(MM2MainLoginBackground.Position.X.Offset, xGoal, dt * 8), startpos.Y.Scale, Lerp(MM2MainLoginBackground.Position.Y.Offset, yGoal, dt * 8))
	end)
end
---------------------------------------------------------------------------
-- Safe Zone
local SafeZone = Instance.new("Part", workspace)
SafeZone.Size = Vector3.new(128,1,128)
SafeZone.Position = Vector3.new(10000,10000,10000)
SafeZone.Reflectance = 1
SafeZone.Anchored = true
local SafeZonePosition = SafeZone.Position + Vector3.new(0,3.5,0)
---------------------------------------------------------------------------
-- Variables
local FlagsIgnoreList = {"Callback","ActivatedColor","Flag","Options","CallbackOnSelect","MinOptions","MaxOptions","Name","ActivatedColor","IgnoreList","RichText","ScrollBarRichText","SliderColor","MinValue","MaxValue","Increment","FormatString","CallbackOnRelease","MinColor","MaxColor","SectionParent","BlendColors"}
local FOVSlider
local SpamSwitchInventoryLoop
local ManeuverLookVector
local FlingPrevCFrame
local VotepadIndexDropdown
local FlingPlayerDropdown
local KillPlayerDropdown
local PlayerTeleportDropdown
local GrabGunButton
local AutoGrabGunToggle
local StealGunButton
local AutoStealGunToggle
local ShootMurdererButton
local AutoShootMurdererToggle
local FlingSheriffButton
local AutoFlingSheriffToggle
local ConfigsDropdown
local LPlrLookAt
local GunTool
local GunHandle
local GunLocal
local GunRemoteFunction
local KnifeTool
local KnifeHandle
local KnifeLocal
local KnifeThrowEvent
local FakeBombTool
local FakeBombEvent
local FakeBombClient
local KeyboardEnabled = UIS.KeyboardEnabled
local flyKeyDown
local flyKeyUp
local mfly1
local mfly2
local Flying = false
local Noclipping = false
local ValueListLoading = false
local ValueListLoaded = false
local ReplicateToyDebounce = false
local ShootMurdererDebounce = false
local StealGunDebounce = false
local GunDropNotifyDebounce = false
local GrabGunDebounce = false
local TPCheck = false
local AntiLag = false
local RTXShadersAlreadyExecuted = false
local serverhopcooldownspawn = 0
local emotestep = 0
local AutoShootDebounce = false
local AutoThrowDebounce = false
local FOVCircleType = 1
local ID = 0
local itemvalueinfo = {}
local prevtargets = {}
local players = {}
local visuals = {}
local connections = {
	XRayParts = {};
	FlingLoop = nil;
	MapChildAdded = nil;
}
local match = {
	Map = nil;
	GameMode = nil;
	Duel = {
		CurrentTeam = nil
	};
	Assassin = {
		AssassinTarget = nil
	}
}
if game.PlaceId == SupportedGames.Classic then
	match.GameMode = GameModes.Classic
elseif game.PlaceId == SupportedGames.Assassin then
	match.GameMode = GameModes.Assassin
elseif game.PlaceId == SupportedGames.Disguised then
	match.GameMode = GameModes.Disguised
end
print("Current Gamemode: "..match.GameMode)
---------------------------------------------------------------------------
-- Drawing
local FOVCircleDrawing = Drawing.new("Circle")
FOVCircleDrawing.Color = Color3.fromRGB(255, 90, 90)
FOVCircleDrawing.Thickness = 1
FOVCircleDrawing.Visible = false
FOVCircleDrawing.Radius = 350
FOVCircleDrawing.Filled = false
---------------------------------------------------------------------------
-- Functions
function getRoot(player)
	local char = player.Character
	if char then
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if hrp then
			return hrp
		end
	end
	return nil
end
function getHumanoid(player)
	local char = player.Character
	if char then
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum then
			return hum
		end
	end
	return nil
end
function FindFirstChildOfClassWithName(object,name,classname)
	for i, v in object:GetChildren() do
		if v.Name == name and v.ClassName == classname then
			return v
		end
	end
	return nil
end
function GetTarget(type,sortmethod,smarttarget)
	local target
	if type == "Gun" and GunHandle then
		local targets
		if smarttarget then
			targets = {}
			if match.GameMode == GameModes.Classic then
				local murderer = GetRoles({"Murderer"},1,true)
				targets = murderer
			elseif match.GameMode == GameModes.Infection then
				local zombies = GetRoles({"Zombie"},1,true)
				targets = zombies
			end
		end
		if sortmethod == "ClosestPlayerToCursor" then
			local mousepos = UIS:GetMouseLocation()
			target = ClosestPlayerToScreenPoint(Vector2.new(mousepos.X,mousepos.Y),Library.Flags.AimbotUseFOV.CurrentValue and Library.Flags.AimbotFOV.CurrentValue,1000,targets)
		elseif sortmethod == "ClosestPlayerToScreenCenter" and Camera then
			target = ClosestPlayerToScreenPoint(Vector2.new(Camera.ViewportSize.X,Camera.ViewportSize.Y)/2,Library.Flags.AimbotUseFOV.CurrentValue and Library.Flags.AimbotFOV.CurrentValue,1000,targets)
		elseif sortmethod == "ClosestPlayerToCharacter" then
			target = ClosestPlayerToCharacter(1000,targets)
		end
	elseif type == "Knife" and KnifeHandle then
		local targets
		if smarttarget then
			targets = {}
			if match.GameMode == GameModes.Classic then
				targets = Players:GetChildren()
			elseif match.GameMode == GameModes.Assassin then
				if match.Assassin.AssassinTarget then
					local player = Players:FindFirstChild(match.Assassin.AssassinTarget)
					if player and players[player.Name].Role ~= "Dead" then
						local hrp = getRoot(player)
						local hum = getHumanoid(player)
						if hrp and hum and hum.Health > 0 then
							local dist = (hrp.Position - LPlrHrp.Position).Magnitude
							if dist <= 1000 then
								local params = RaycastParams.new()
								params.FilterType = Enum.RaycastFilterType.Blacklist
								params.FilterDescendantsInstances = {LPlrChar,player.Character}
								params.RespectCanCollide = true
								local predictedpos = hrp.Position + hum.MoveDirection * hum.WalkSpeed * Vector3.new(1,0,1) * dist / 95
								local wallcheck = workspace:Raycast(hrp.Position,predictedpos - hrp.Position,params)
								if wallcheck then
									predictedpos = wallcheck.Position + wallcheck.Normal
								end
								local wallcheck2 = workspace:Raycast(KnifeHandle.Position,predictedpos - KnifeHandle.Position,params)
								if not wallcheck2 then
									targets = {player}
								end
							end
						end
					end
				end
				if #targets <= 0 then
					targets = Players:GetChildren()
				end
			end
		end
		if sortmethod == "ClosestPlayerToCursor" then
			local mousepos = UIS:GetMouseLocation()
			target = ClosestPlayerToScreenPoint(Vector2.new(mousepos.X,mousepos.Y),Library.Flags.AimbotUseFOV.CurrentValue and Library.Flags.AimbotFOV.CurrentValue,1000,targets)
		elseif sortmethod == "ClosestPlayerToScreenCenter" and Camera then
			target = ClosestPlayerToScreenPoint(Vector2.new(Camera.ViewportSize.X,Camera.ViewportSize.Y)/2,Library.Flags.AimbotUseFOV.CurrentValue and Library.Flags.AimbotFOV.CurrentValue,1000,targets)
		elseif sortmethod == "ClosestPlayerToCharacter" then
			target = ClosestPlayerToCharacter(1000,targets)
		end
	end
	return target
end
function ClosestPlayerToScreenPoint(point,FOV,maxdist,whitelist)
	local closest
	local distance = math.huge
	for _, player in Players:GetChildren() do
		if player ~= LocalPlayer and players[player.Name].Role ~= "Dead" then
			local hrp = getRoot(player)
			if hrp then
				local viewportpoint, onscreen = Camera:WorldToScreenPoint(hrp.Position)
				local vpdistancetemp = (Vector2.new(viewportpoint.X,viewportpoint.Y) - point).Magnitude
				local distancefromplayer = (hrp.Position - LPlrHrp.Position).Magnitude
				if onscreen and (not FOV or vpdistancetemp <= FOV) and vpdistancetemp < distance and (not maxdist or distancefromplayer <= maxdist) and (not whitelist or table.find(whitelist,player)) then
					closest = player
					distance = vpdistancetemp
				end
			end
		end
	end
	return closest
end
function ClosestPlayerToCharacter(maxdist,whitelist)
	local closest
	local distance = math.huge
	for _, player in Players:GetChildren() do
		if player ~= LocalPlayer and players[player.Name].Role ~= "Dead" then
			local hrp = getRoot(player)
			if hrp then
				local distancetemp = (hrp.Position - LPlrHrp.Position).Magnitude
				if distancetemp < distance and (not maxdist or distancetemp <= maxdist) and (not whitelist or table.find(whitelist,player)) then
					closest = player
					distance = distancetemp
				end
			end
		end
	end
	return closest
end
function AimbotVisuals(startpos,endpos,path,color)
	Draw3D(startpos,endpos,color,5)
	local prevpos
	for _, v in path do
		if prevpos then
			Draw3D(prevpos,v,Color3.new(1,1,1),5)
		end
		prevpos = v
	end
end
function GetAimVector(weapon,target,showvisuals,predictjump,alwaysjumping)
	local targetchar = target.Character
	if not targetchar then return end
	local params = RaycastParams.new()
	params.FilterDescendantsInstances = {LPlrChar}
	params.FilterType = Enum.RaycastFilterType.Blacklist
	if weapon == "Gun" and GunHandle then
		local p = Library.Flags.AimbotAutoPrediction.CurrentValue and LocalPlayer:GetNetworkPing() * 1000 + 140 or Library.Flags.GunPrediction.CurrentValue
		local ws = 16
		if players[target.Name].Perk == "Haste" and targetchar:FindFirstChild("Knife") then
			ws = 17.6
		end
		local path, aimpos = Aimbot:Compute(GunHandle.Position,targetchar,95,0,{
			IgnoreList = nil;
			Ping = p;
			PredictJump = predictjump or false;
			AlwaysJumping = alwaysjumping or false;
			IsAGun = true;
			WalkSpeed = ws;
			PredictLag = true;
			AimHeight = 0;
			Gravity = 196.2
		})
		if showvisuals then
			AimbotVisuals(GunHandle.Position,aimpos,path,Color3.fromRGB(112, 145, 255))
		end
		return aimpos
	elseif weapon == "Knife" and KnifeHandle then
		local p = Library.Flags.AimbotAutoPrediction.CurrentValue and LocalPlayer:GetNetworkPing() * 1000 + 90 or Library.Flags.KnifePrediction.CurrentValue
		local ws = 16
		if players[target.Name].Perk == "Haste" and targetchar:FindFirstChild("Knife") then
			ws = 17.6
		end
		local path, aimpos = Aimbot:Compute(KnifeHandle.Position,targetchar,95,0,{
			IgnoreList = nil;
			Ping = p;
			PredictJump = predictjump or false;
			AlwaysJumping = alwaysjumping or false;
			IsAGun = false;
			WalkSpeed = ws;
			PredictLag = true;
			AimHeight = 0;
			Gravity = 196.2
		})
		if showvisuals and Drawing and aimpos then
			AimbotVisuals(KnifeHandle.Position,aimpos,path,Color3.fromRGB(255, 112, 112))
		end
		return aimpos
	end
end
function GunShotCooldown(amount)
	task.spawn(function()
		AutoShootDebounce = true
		task.wait(amount)
		AutoShootDebounce = false
	end)
end
function KnifeThrowCooldown(amount)
	task.spawn(function()
		AutoThrowDebounce = true
		task.wait(amount)
		AutoThrowDebounce = false
	end)
end
function ShootGun(aimpos)
	task.spawn(function()
		if not GunRemoteFunction or GunTool.Parent ~= LPlrChar then return end
		local args = {
			[1] = 1;
			[2] = aimpos;
			[3] = "AH2"
		}
		GunRemoteFunction:InvokeServer(table.unpack(args))
	end)
end
function ThrowKnife(aimpos)
	task.spawn(function()
		if not aimpos or not KnifeThrowEvent or not KnifeTool or KnifeTool.Parent ~= LPlrChar then return end
		local args = {
			[1] = CFrame.new(aimpos);
			[2] = KnifeHandle.Position
		}
		KnifeThrowEvent:FireServer(table.unpack(args))
	end)
end
function GetRoles(roles,type,hrpcheck) -- Type: 1 = Whitelist / Type: 2 = Blacklist
	local chosenplayers = {}
	for _, player in Players:GetChildren() do
		if type == 1 and table.find(roles,players[player.Name].Role) or type == 2 and not table.find(roles,players[player.Name].Role) then
			if hrpcheck then
				local hrp = getRoot(player)
				if hrp then
					table.insert(chosenplayers,player)
				end
			else
				table.insert(chosenplayers,player)
			end
		end
	end
	return chosenplayers
end
function NotifyRoles()
	if match.GameMode ~= "Classic" then return end
	local murderer = GetRoles({"Murderer"},1)[1]
	local sheriff = GetRoles({"Sheriff"},1)[1]
	murderer = murderer and murderer.Name or "nobody"
	sheriff = sheriff and sheriff.Name or "nobody"
	Library:Notify({
		Type = "info"; -- (Required) id0x1 = Error, id0x2 = Info, id0x3 = Success, set to nil for normal notification
		Title = "Info";
		Message = "The murderer is "..murderer.." and the sheriff is "..sheriff;
		Duration = 5; -- (Required)
	})
end
function AnnounceRoles()
	if match.GameMode ~= "Classic" then return end
	local murderer = GetRoles({"Murderer"},1)[1]
	local sheriff = GetRoles({"Sheriff"},1)[1]
	murderer = murderer and murderer.Name or "nobody"
	sheriff = sheriff and sheriff.Name or "nobody"
	local message = "The murderer is "..murderer.." and the sheriff is "..sheriff
	if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
		TextChatService.TextChannels.RBXGeneral:SendAsync(message)
	else
		REPS.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(message, "All")
	end
end
function RemoveLagFromObject(object)
	if not object:FindFirstAncestorOfClass("Model") or not object:FindFirstAncestorOfClass("Model"):FindFirstChildOfClass("Humanoid") then -- If it's not a character
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
function FindMap()
	if match.GameMode == GameModes.Classic then
		local function CheckIf(child)
			local CoinContainer = child:FindFirstChild("CoinContainer")
			if CoinContainer then
				return true
			else
				local CoinArea = child:FindFirstChild("CoinAreas")
				if CoinArea then
					return true
				end
			end
			return false
		end
		for i, v in workspace:GetChildren() do
			local ismap = CheckIf(v)
			if ismap then
				return v
			end
		end
	end
end
function FindLobby()
	for i, v in workspace:GetChildren() do
		if v.Name == "Lobby" and not v:FindFirstChildOfClass("Humanoid") then -- In case a person named "Lobby" joins the server
			return v
		end
	end
end
function MapEventFunctions(map)
	if not map then return end
	if connections.MapChildAdded then connections.MapChildAdded:Disconnect() end
	connections.MapChildAdded = map.ChildAdded:Connect(function(child)
		if child.Name == "GunDrop" then -- If the Sheriff Dropped the Gun
			if Library.Flags.NotifyGunDrop.CurrentValue then
				if not GunDropNotifyDebounce then
					GunDropNotifyDebounce = true
					Library:Notify({
						Type = "info"; -- (Required) id0x1 = Error, id0x2 = Info, id0x3 = Success, set to nil for normal notification
						Title = "Info";
						Message = "Gun dropped "..math.round((child.Position - LPlrHrp.Position).Magnitude).." studs away"; -- (Required)
						Duration = 5; -- (Required)
					})
					task.wait(0.25)
					GunDropNotifyDebounce = false
				end
			end
			ShowGunDrop(Library.Flags.ShowGunDrop.CurrentValue) -- Cham Gun Drop
			if Library.Flags.AutoGrabGun.CurrentValue then
				task.spawn(GrabGun)
			end
		end
	end)
end
function TeleportToMap()
	if not match.Map then return end
	local spawns = match.Map:FindFirstChild("Spawns")
	if not spawns then return end
	local spawnlocations = spawns:GetChildren()
	LPlrHrp.CFrame = CFrame.new(spawnlocations[math.random(1,#spawnlocations)].Position + Vector3.yAxis * 3)
end
function TeleportAboveMap()
	if not match.Map then return end
	local highest
	local height = -math.huge
	for i, v in match.Map:GetDescendants() do
		if v.CanCollide and v.Position.Y > height then
			highest = v
			height = v.Position.Y
		end
	end
end
function TeleportToLobby()
	local lobby = FindLobby()
	if not lobby then return end
	local spawns = lobby:FindFirstChild("Spawns")
	if not spawns then return end
	local spawnlocations = spawns:GetChildren()
	LPlrHrp.CFrame = CFrame.new(spawnlocations[math.random(1,#spawnlocations)].Position + Vector3.yAxis * 3)
end
function TeleportToVotingArea()
	local lobby = FindLobby()
	if not lobby then return end
	local pad = lobby.VotePad2.Pad
	LPlrHrp.CFrame = CFrame.new(pad.Position)
end
function FlingPlayer(player,power,offset,deadcheck,ondeath,onleave)
	if not LPlrChar then return end
	if connections.FlingLoop and connections.FlingLoop.Connected then return end
	local dead
	if player and player ~= LocalPlayer then
		FlingPrevCFrame = LPlrHrp.Position
		connections.FlingLoop = RS.RenderStepped:Connect(function()
			if player.Parent then
				for _, v in LPlrChar:GetDescendants() do
					if v:IsA("BasePart") then
						v.CanCollide = false
						v.Massless = true
						v.Velocity = Vector3.new(0,0,0)
					end
				end
				local targethrp = getRoot(player)
				local targethum = getHumanoid(player)
				if targethrp and targethum then
					if LPlrHrp.Position.Y > workspace.FallenPartsDestroyHeight + 150 then
						local predictedpos = targethrp.Velocity * Vector3.new(1,0,1) * (LocalPlayer:GetNetworkPing() + 0.1)
						if predictedpos ~= predictedpos then
							predictedpos = Vector3.zero
						end
						LPlrHrp.CFrame = targethrp.CFrame + predictedpos + Vector3.yAxis * offset
						LPlrHrp.AssemblyAngularVelocity = Vector3.yAxis * power
					else
						LPlrHrp.CFrame = SafeZonePosition
						LPlrHrp.AssemblyAngularVelocity = Vector3.zero
						LPlrHrp.Velocity = Vector3.zero
					end
					if not dead or not dead.Connected then
						dead = targethum.Died:Connect(function()
							if deadcheck then
								StopFlinging()
							end
							if ondeath then
								task.spawn(ondeath)
							end
						end)
					end
				else
					LPlrHrp.AssemblyAngularVelocity = Vector3.zero
					LPlrHrp.Velocity = Vector3.zero
					LPlrHrp.CFrame = SafeZonePosition
				end
			else
				StopFlinging()
				if onleave then
					task.spawn(onleave)
				end
			end
		end)
	end
end
function StopFlinging()
	if connections.FlingLoop then
		connections.FlingLoop:Disconnect()
	end
	if match.Map and FlingPrevCFrame then
		LPlrHrp.CFrame = FlingPrevCFrame
	else
		TeleportToLobby()
	end
	LPlrHrp.AssemblyAngularVelocity = Vector3.zero
	LPlrHrp.Velocity = Vector3.zero
end
function AntiAimFrom(position)
	local random = math.random(1,2)
	if random == 1 then
		LPlrLookAt = LPlrHrp.Position + (CFrame.new(LPlrHrp.Position,position) * CFrame.Angles(0,math.pi/2,0)).LookVector
	elseif random == 2 then
		LPlrLookAt = LPlrHrp.Position + (CFrame.new(LPlrHrp.Position,position) * CFrame.Angles(0,-math.pi/2,0)).LookVector
	end
end
function ShowGunDrop(show)
	if not match.Map then return end
	for i, v in match.Map:GetChildren() do -- Find Gun Drop
		if v.Name == "GunDrop" then
			if show then
				-- ESP Gun Drop
				UpdateChams(v,false,{
					Enabled = true;
					Color = Library.Flags.GunDropColor.CurrentColor;
				})
				UpdateNameTags(v,false,Library.Flags.GunDropColor.CurrentColor,{[1] = {Name = "GunDrop"}})
			else
				-- Un-ESP Gun Drop
				UpdateChams(v,false,{})
				UpdateNameTags(v,false,Library.Flags.GunDropColor.CurrentColor,{})
			end
		end
	end
end
function FindNearestGunDrop()
	if not match.Map then return end
	local closest
	local distance = math.huge
	for i, v in match.Map:GetChildren() do -- Find Nearest Gun Drop
		if v.Name == "GunDrop" then
			local distancetemp = (v.Position - LPlrHrp.Position).Magnitude
			if distancetemp < distance then
				closest = v
				distance = distancetemp
			end
		end
	end
	return closest
end
function GrabGun(gundrop)
	if GrabGunDebounce or GunTool or not match.Map or players[LocalPlayer.Name].Role == "Murderer" then return end
	GrabGunDebounce = true
	local GunDrop = gundrop or FindNearestGunDrop()
	if GunDrop then
		if Library.Flags.GrabGunSafeMode.CurrentValue then
			while true do
				local isneargun = false
				local murderer = GetRoles({"Murderer"},1,true)[1]
				if match.GameMode == GameModes.Classic then
					local hrp = murderer.Character.HumanoidRootPart
					local dist = (GunDrop.Position - hrp.Position).Magnitude
					if dist <= 6 then
						isneargun = true
					end
				end
				if not isneargun then break end
				task.wait()
			end
		end
		local prevCFrame = LPlrHrp.CFrame
		local grabGunLoop = RS.RenderStepped:Connect(function()
			LPlrHrp.CFrame = GunDrop.CFrame
		end)
		GunDrop:GetPropertyChangedSignal("Parent"):Once(function()
			if not grabGunLoop.Connected then return end
			grabGunLoop:Disconnect()
			LPlrHrp.CFrame = prevCFrame
		end)
		task.wait(1)
		if not grabGunLoop.Connected then return end
		grabGunLoop:Disconnect()
		LPlrHrp.CFrame = prevCFrame
	end
	GrabGunDebounce = false
end
function StealGun()
	if StealGunDebounce then return end
	StealGunDebounce = true
	local function FlingPlayerAndGrabGun(player)
		local spawn = tick()
		StopFlinging()
		FlingPlayer(player,99999,2,true,function()
			if spawn + 5 < tick() then return end
			local NearestGun
			while spawn + 1 >= tick() do
				NearestGun = FindNearestGunDrop()
				if NearestGun then break end
				task.wait()
			end
			GrabGun(NearestGun)
		end)
		task.wait(1)
		StopFlinging()
	end
	local GunDrop = FindNearestGunDrop()
	if GunDrop then
		GrabGun(GunDrop)
	else
		if match.GameMode == GameModes.Classic and players[LocalPlayer.Name].Role ~= "Murderer" then
			local sheriff = GetRoles({"Sheriff"},1,true)[1]
			if sheriff then
				FlingPlayerAndGrabGun(sheriff)
			end
		end
	end
	StealGunDebounce = false
end
function TeleportToPlayer(player,distance)
	if not player then return end
	local hrp = getRoot(player)
	if hrp then
		LPlrHrp.CFrame = hrp.CFrame + hrp.LookVector * distance
	else
		return false
	end
end
function TPShootPlayer(player)
	local teleportbackdebounce = false
	local prevCFrame = LPlrHrp.CFrame
	local renderstepped
	renderstepped = RS.RenderStepped:Connect(function()
		if not GunTool then return end
		LPlrHum:EquipTool(GunTool)
		local suc = TeleportToPlayer(player,-2)
		if not suc then
			if not teleportbackdebounce then
				teleportbackdebounce = true
				LPlrHrp.CFrame = prevCFrame
			end
		else
			teleportbackdebounce = false
		end
	end)
	task.wait(0.25)
	task.spawn(function()
		if not AutoShootDebounce and GunTool and GunTool.Parent == LPlrChar then
			local suc, aimpos = pcall(GetAimVector,"Gun",player)
			if suc and aimpos then
				ShootGun(aimpos)
			end
			GunShotCooldown(3.5)
		end
	end)
	task.wait(0.25)
	renderstepped:Disconnect()
	LPlrHum:UnequipTools()
	LPlrHrp.CFrame = prevCFrame
end
function ShootMurderer()
	if not ShootMurdererDebounce or not GunTool or AutoShootDebounce then return end
	ShootMurdererDebounce = true
	if match.GameMode == GameModes.Classic then
		local murderer = GetRoles({"Murderer"},1,true)[1]
		if murderer then
			TPShootPlayer(murderer)
		end
	end
	ShootMurdererDebounce = false
end
function UpdateRoleESP(player,type,dictionary)
	local character = player.Character
	if character then
		if players[player.Name].Role == "Murderer" then
			if type == 1 then
				UpdateChams(character,true,{
					Enabled = dictionary.PlayerChams;
					Color = Library.Flags.MurdererColor.CurrentColor;
				})
			elseif type == 2 then
				UpdateNameTags(character,true,Library.Flags.MurdererColor.CurrentColor,dictionary.NameTags)
			elseif type == 3 then
				UpdateTracers(character,true,Library.Flags.MurdererColor.CurrentColor,true)
			end
		elseif players[player.Name].Role == "Assassin" then
			if player.Name == match.Assassin.AssassinTarget then
				if type == 1 then
					UpdateChams(character,true,{
						Enabled = dictionary.PlayerChams;
						Color = Library.Flags.HeroColor.CurrentColor;
					})
				elseif type == 2 then
					UpdateNameTags(character,true,Library.Flags.HeroColor.CurrentColor,dictionary.NameTags)
				elseif type == 3 then
					UpdateTracers(character,true,Library.Flags.HeroColor.CurrentColor,true)
				end
			else
				if type == 1 then
					UpdateChams(character,true,{
						Enabled = dictionary.PlayerChams;
						Color = Library.Flags.MurdererColor.CurrentColor;
					})
				elseif type == 2 then
					UpdateNameTags(character,true,Library.Flags.MurdererColor.CurrentColor,dictionary.NameTags)
				elseif type == 3 then
					UpdateTracers(character,true,Library.Flags.MurdererColor.CurrentColor,true)
				end
			end
		elseif players[player.Name].Role == "Sheriff" then
			if type == 1 then
				UpdateChams(character,true,{
					Enabled = dictionary.PlayerChams;
					Color = Library.Flags.SheriffColor.CurrentColor;
				})
			elseif type == 2 then
				UpdateNameTags(character,true,Library.Flags.SheriffColor.CurrentColor,dictionary.NameTags)
			elseif type == 3 then
				UpdateTracers(character,true,Library.Flags.SheriffColor.CurrentColor,true)
			end
		elseif players[player.Name].Role == "Innocent" then
			if type == 1 then
				UpdateChams(character,true,{
					Enabled = dictionary.PlayerChams;
					Color = Library.Flags.InnocentColor.CurrentColor;
				})
			elseif type == 2 then
				UpdateNameTags(character,true,Library.Flags.InnocentColor.CurrentColor,dictionary.NameTags)
			elseif type == 3 then
				UpdateTracers(character,true,Library.Flags.InnocentColor.CurrentColor,true)
			end
		elseif players[player.Name].Role == "Hero" then
			if type == 1 then
				UpdateChams(character,true,{
					Enabled = dictionary.PlayerChams;
					Color = Library.Flags.HeroColor.CurrentColor;
				})
			elseif type == 2 then
				UpdateNameTags(character,true,Library.Flags.HeroColor.CurrentColor,dictionary.NameTags)
			elseif type == 3 then
				UpdateTracers(character,true,Library.Flags.HeroColor.CurrentColor,true)
			end
		elseif players[player.Name].Role == "Dead" then
			if type == 1 then
				UpdateChams(character,true,{
					Enabled = dictionary.PlayerChams;
					Color = Library.Flags.DeadColor.CurrentColor;
				})
			elseif type == 2 then
				UpdateNameTags(character,true,Library.Flags.DeadColor.CurrentColor,dictionary.NameTags)
			elseif type == 3 then
				UpdateTracers(character,true,Library.Flags.DeadColor.CurrentColor,true)
			end
		elseif players[player.Name].Role == "Team1" or players[player.Name].Role == "Team2" then
			if players[player.Name].Role == match.Duel.CurrentTeam then
				if type == 1 then
					UpdateChams(character,true,{
						Enabled = dictionary.PlayerChams;
						Color = Library.Flags.SheriffColor.CurrentColor;
					})
				elseif type == 2 then
					UpdateNameTags(character,true,Library.Flags.SheriffColor.CurrentColor,dictionary.NameTags)
				elseif type == 3 then
					UpdateTracers(character,true,Library.Flags.SheriffColor.CurrentColor,true)
				end
			else
				if type == 1 then
					UpdateChams(character,true,{
						Enabled = dictionary.PlayerChams;
						Color = Library.Flags.MurdererColor.CurrentColor;
					})
				elseif type == 2 then
					UpdateNameTags(character,true,Library.Flags.MurdererColor.CurrentColor,dictionary.NameTags)
				elseif type == 3 then
					UpdateTracers(character,true,Library.Flags.MurdererColor.CurrentColor,true)
				end
			end
		elseif players[player.Name].Role == "Survivor" then
			if type == 1 then
				UpdateChams(character,true,{
					Enabled = dictionary.PlayerChams;
					Color = Library.Flags.SheriffColor.CurrentColor;
				})
			elseif type == 2 then
				UpdateNameTags(character,true,Library.Flags.SheriffColor.CurrentColor,dictionary.NameTags)
			elseif type == 3 then
				UpdateTracers(character,true,Library.Flags.SheriffColor.CurrentColor,true)
			end
		elseif players[player.Name].Role == "Zombie" then
			if type == 1 then
				UpdateChams(character,true,{
					Enabled = dictionary.PlayerChams;
					Color = Library.Flags.InnocentColor.CurrentColor;
				})
			elseif type == 2 then
				UpdateNameTags(character,true,Library.Flags.InnocentColor.CurrentColor,dictionary.NameTags)
			elseif type == 3 then
				UpdateTracers(character,true,Library.Flags.InnocentColor.CurrentColor,true)
			end
		end
	end
end
function XRayPart(part)
	if not part:IsA("BasePart") or part.Transparency == 1 then return end
	local model = part:FindFirstAncestorOfClass("Model")
	if model and Players:GetPlayerFromCharacter(model) then return end
	local oldtransparency = part.Transparency
	part.Transparency = 0.5
	local cID = #connections.XRayParts + 1
	local transparencychanged = part:GetPropertyChangedSignal("Transparency"):Connect(function()
		connections.XRayParts[cID][2] = part.Transparency
		part.Transparency = 0.5
	end)
	connections.XRayParts[cID] = {part,oldtransparency,transparencychanged}
end
function UnXRayParts()
	for i in connections.XRayParts do
		connections.XRayParts[i][3]:Disconnect()
		local part = connections.XRayParts[i][1]
		part.Transparency = connections.XRayParts[i][2] or 0
		connections.XRayParts[i] = nil
	end
end
function Initialize(player)
	-- Initialize Player
	players[player.Name] = {}
	local updatenametagspawn = tick()
	-- Variables
	local renderstepped
	local charadded
	local prevrole = players[player.Name].Role
	local character
	-- Global Functions
	players[player.Name].Disconnect = function()
		if renderstepped then
			renderstepped:Disconnect()
		end
		if charadded then
			charadded:Disconnect()
		end
		players[player.Name] = nil
	end
	players[player.Name].UpdateChams = function()
		if player ~= LocalPlayer then
			UpdateRoleESP(player,1,{PlayerChams = Library.Flags.PlayerChams.CurrentValue})
		end
	end
	-- Connections
	renderstepped = RS.RenderStepped:Connect(function()
		-- Update NameTags
		if updatenametagspawn + 0.1 < tick() then -- prevent lag/stuttering
			if player ~= LocalPlayer then
				local nametags = {}
				if Library.Flags.NameTags.CurrentValue then
					nametags[#nametags+1] = {Name = player.Name}
				end
				if Library.Flags.ShowPerks.CurrentValue then
					local perk = "n/a"
					if players[player.Name].Perk then
						perk = players[player.Name].Perk
					end
					nametags[#nametags+1] = {Name = "Perk: <font color='#FFFFFF'>"..tostring(perk).."</font>"}
				end
				if Library.Flags.ShowDistance.CurrentValue and LPlrHrp then
					local hrp = getRoot(player)
					if hrp then
						nametags[#nametags+1] = {Name = "Distance: <font color='#FFFFFF'>"..tostring(math.round((hrp.Position - LPlrHrp.Position).Magnitude)).."</font>"}
					end
				end
				UpdateRoleESP(player,2,{NameTags = nametags})
			end
			updatenametagspawn = tick()
		end
		-- Weapon ESP
		if player ~= LocalPlayer and character then
			local knife = character:FindFirstChild("Knife")
			if knife then
				local handle = knife:FindFirstChild("Handle")
				if handle then
					if Library.Flags.WeaponESP.CurrentValue then
						UpdateChams(handle,false,{
							Enabled = true;
							Color = Library.Flags.WeaponColor.CurrentColor;
						})
						UpdateNameTags(handle,false,Library.Flags.WeaponColor.CurrentColor,{[1] = {Name = "Knife"}})
					else
						UpdateChams(handle,false,{})
						UpdateNameTags(handle,false,nil,{})
					end
				end
			end
			local gun = character:FindFirstChild("Gun")
			if gun then
				local handle = gun:FindFirstChild("Handle")
				if handle then
					if Library.Flags.WeaponESP.CurrentValue then
						UpdateChams(handle,false,{
							Enabled = true;
							Color = Library.Flags.WeaponColor.CurrentColor;
						})
						UpdateNameTags(handle,false,Library.Flags.WeaponColor.CurrentColor,{[1] = {Name = "Gun"}})
					else
						UpdateChams(handle,false,{})
						UpdateNameTags(handle,false,nil,{})
					end
				end
			end
		end
		-- Update Tracers
		if Library.Flags.PlayerTracers.CurrentValue then
			UpdateRoleESP(player,3)
		end
		-- Update Role Chams
		if prevrole ~= players[player.Name].Role then
			players[player.Name].UpdateChams()
			if Library.Flags.InstaRoleNotify.CurrentValue and player == LocalPlayer and match.GameMode == GameModes.Classic and players[player.Name].Role ~= "Dead" then
				Library:Notify({
					Type = "info"; -- (Required) id0x1 = Error, id0x2 = Info, id0x3 = Success, set to nil for normal notification
					Title = "Info";
					Message = "You are "..tostring(players[player.Name].Role); -- (Required)
					Duration = 5; -- (Required)
				})
			end
			if Library.Flags.NotifyGunCollected.CurrentValue and player ~= LocalPlayer and players[player.Name].Role == "Hero" then
				Library:Notify({
					Type = "info"; -- (Required) id0x1 = Error, id0x2 = Info, id0x3 = Success, set to nil for normal notification
					Title = "Info";
					Message = player.Name.." grabbed the gun"; -- (Required)
					Duration = 5; -- (Required)
				})
			end
		end
		prevrole = players[player.Name].Role
	end)
	-- Character
	character = player.Character or player.CharacterAdded:Wait()
	charadded = player.CharacterAppearanceLoaded:Connect(function(char)
		character = char
		players[player.Name].UpdateChams()
	end)
	if character then
		players[player.Name].UpdateChams()
	end
	players[player.Name].UpdateChams()
end
function UpdatePlayerList()
	for _, player in Players:GetChildren() do
		if not players[player.Name] then
			coroutine.wrap(Initialize)(player)
			print(player.Name.." has been initialized.")
		end
	end
	for player in players do
		if not Players:FindFirstChild(player) then
			players[player].Disconnect()
			print(player.." has disconnected.")
		end
	end
end
function UpdateConfigsDropdown()
	ConfigsDropdown.Options = Library:ListConfigurationFiles()
end
function Rejoin()
	Library:Notify({
		Type = "info"; -- (Required) id0x1 = Error, id0x2 = Info, id0x3 = Success, set to nil for normal notification
		Title = "Info";
		Message = "Rejoining!"; -- (Required)
		Duration = 5; -- (Required)
	})
	local suc = pcall(function() 
		TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
	end)
	if not suc then
		Library:Notify({
			Type = "error"; -- (Required) id0x1 = Error, id0x2 = Info, id0x3 = Success, set to nil for normal notification
			Title = "Error";
			Message = "Error occured while rejoining. Please try again."; -- (Required)
			Duration = 5; -- (Required)
		})
	end
end
function ServerHop()
	serverhopcooldownspawn = tick()
	if httprequest then
		Library:Notify({
			Type = "info"; -- (Required) id0x1 = Error, id0x2 = Info, id0x3 = Success, set to nil for normal notification
			Title = "Info";
			Message = "Server Hopping"; -- (Required)
			Duration = 5; -- (Required)
			Actions = {}
		})
		task.spawn(function()
			local servers = {}
			local req = httprequest({Url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true", game.PlaceId)})
			local suc, body = pcall(function()
				return HttpService:JSONDecode(req.Body) 
			end)
			if suc and body then
				if body.data then
					for _, v in body.data do
						if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.id ~= game.JobId then
							table.insert(servers, {ID = v.id,Playing = v.playing,Ping = v.ping})
						end
					end
					if #servers > 0 then
						if Library.Flags.PrioritizeServerPing.CurrentValue then
							local bestserver
							local range = math.huge
							for _, v in servers do
								local serverping = v.Ping
								if serverping then
									local rangetemp = math.abs(Library.Flags.DesiredPing.CurrentValue - serverping)
									if Library.Flags.PrioritizeServerPing.CurrentValue and rangetemp < range then
										bestserver = v
										range = rangetemp
									end
								end
							end
							if bestserver then
								pcall(function() 
									TeleportService:TeleportToPlaceInstance(game.PlaceId, bestserver.ID, Players.LocalPlayer) 
								end)
							end
						else
							TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)].ID, Players.LocalPlayer)
						end
					else
						Library:Notify({
							Type = "error"; -- (Required) id0x1 = Error, id0x2 = Info, id0x3 = Success, set to nil for normal notification
							Title = "Error"; -- (Required) id0x1 = Error, id0x2 = Info, id0x3 = Success, set to nil for normal notification
							Message = "Failed to find server. Wait 5 seconds and try again."; -- (Required)
							Duration = 5; -- (Required)
							Actions = {}
						})
					end
				elseif body.errors then
					Library:Notify({
						Type = "error"; -- (Required) id0x1 = Error, id0x2 = Info, id0x3 = Success, set to nil for normal notification
						Title = "Error"; -- (Required) id0x1 = Error, id0x2 = Info, id0x3 = Success, set to nil for normal notification
						Message = "Failed to find server. Wait 5 seconds and try again."; -- (Required)
						Duration = 5; -- (Required)
						Actions = {}
					})
				end
			else
				Library:Notify({
					Type = "error"; -- (Required) id0x1 = Error, id0x2 = Info, id0x3 = Success, set to nil for normal notification
					Title = "Error"; -- (Required) id0x1 = Error, id0x2 = Info, id0x3 = Success, set to nil for normal notification
					Message = "Unexpected error while server hopping. Wait 5 seconds and try again."; -- (Required)
					Duration = 5; -- (Required)
					Actions = {}
				})
			end
		end)
	else
		MM2MainErrorNotification("Your executor does not support this exploit (missing 'httprequest')")
	end
end
function LoadValueList() -- powered by Supreme Values
	local suc = pcall(function()
		if ValueListLoading then return end
		ValueListLoading = true
		local Uniques = httprequest({Url = "https://supremevaluelist.com/mm2/uniques.html"})
		local Ancients = httprequest({Url = "https://supremevaluelist.com/mm2/ancients.html"})
		local Vintages = httprequest({Url = "https://supremevaluelist.com/mm2/vintages.html"})
		local Chromas = httprequest({Url = "https://supremevaluelist.com/mm2/chromas.html"})
		local Godlies = httprequest({Url = "https://supremevaluelist.com/mm2/godlies.html"})
		local Legendaries = httprequest({Url = "https://supremevaluelist.com/mm2/legendaries.html"})
		local Rares = httprequest({Url = "https://supremevaluelist.com/mm2/rares.html"})
		local Uncommons = httprequest({Url = "https://supremevaluelist.com/mm2/uncommons.html"})
		local Commons = httprequest({Url = "https://supremevaluelist.com/mm2/commons.html"})
		local Pets = httprequest({Url = "https://supremevaluelist.com/mm2/pets.html"})
		ValueListLoading = false
	end)
	if not suc then
		ValueListLoading = false
		Library:Notify({
			Type = "error"; -- (Required) id0x1 = Error, id0x2 = Info, id0x3 = Success, set to nil for normal notification
			Title = "Error";
			Message = "Failed To Fetch API Please Try Again.";
			Duration = 5;
		})
	end
end
function EnableFly() -- stolen from Infinite Yield
	if KeyboardEnabled then
		Flying = true
		local hrp = LPlrHrp
		local camera = workspace.CurrentCamera
		local v3none = Vector3.new()
		local v3zero = Vector3.new(0, 0, 0)
		local v3inf = Vector3.new(9e9, 9e9, 9e9)
		local controlModule = require(LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule"))
		local bv = Instance.new("BodyVelocity")
		bv.Name = "MM2MainBodyVelocity"
		bv.Parent = hrp
		bv.MaxForce = v3zero
		bv.Velocity = v3zero
		local bg = Instance.new("BodyGyro")
		bg.Name = "MM2MainBodyGyro"
		bg.Parent = hrp
		bg.MaxTorque = v3inf
		bg.P = 1000
		bg.D = 50
		mfly1 = LocalPlayer.CharacterAdded:Connect(function(char)
			hrp = char:WaitForChild("HumanoidRootPart")
			bv = Instance.new("BodyVelocity")
			bv.Name = "MM2MainBodyVelocity"
			bv.Parent = hrp
			bv.MaxForce = v3zero
			bv.Velocity = v3zero
			bg = Instance.new("BodyGyro")
			bg.Name = "MM2MainBodyGyro"
			bg.Parent = hrp
			bg.MaxTorque = v3inf
			bg.P = 1000
			bg.D = 50
		end)
		mfly2 = RS.RenderStepped:Connect(function()
			hrp = LPlrHrp
			camera = workspace.CurrentCamera
			if hrp:FindFirstChild("MM2MainBodyVelocity") and hrp:FindFirstChild("MM2MainBodyGyro") then
				local humanoid = LPlrHum
				local VelocityHandler = hrp:FindFirstChild("MM2MainBodyVelocity")
				local GyroHandler = hrp:FindFirstChild("MM2MainBodyGyro")
				VelocityHandler.MaxForce = v3inf
				GyroHandler.MaxTorque = v3inf
				humanoid.PlatformStand = true
				GyroHandler.CFrame = camera.CoordinateFrame
				VelocityHandler.Velocity = v3none

				local direction = controlModule:GetMoveVector()
				if direction.X > 0 then
					VelocityHandler.Velocity = VelocityHandler.Velocity + camera.CFrame.RightVector * (direction.X * Library.Flags.FlySpeed.CurrentValue * 5)
				end
				if direction.X < 0 then
					VelocityHandler.Velocity = VelocityHandler.Velocity + camera.CFrame.RightVector * (direction.X * Library.Flags.FlySpeed.CurrentValue * 5)
				end
				if direction.Z > 0 then
					VelocityHandler.Velocity = VelocityHandler.Velocity - camera.CFrame.LookVector * (direction.Z * Library.Flags.FlySpeed.CurrentValue * 5)
				end
				if direction.Z < 0 then
					VelocityHandler.Velocity = VelocityHandler.Velocity - camera.CFrame.LookVector * (direction.Z * Library.Flags.FlySpeed.CurrentValue * 5)
				end
			end
		end)
	else
		if flyKeyDown or flyKeyUp then flyKeyDown:Disconnect() flyKeyUp:Disconnect() end
		local T = LPlrHrp
		local CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
		local lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
		local SPEED = 0
		local function FLY()
			Flying = true
			local BG = Instance.new('BodyGyro')
			local BV = Instance.new('BodyVelocity')
			BG.P = 9e4
			BG.Parent = T
			BV.Parent = T
			BG.maxTorque = Vector3.new(9e9, 9e9, 9e9)
			BG.cframe = T.CFrame
			BV.velocity = Vector3.new(0, 0, 0)
			BV.maxForce = Vector3.new(9e9, 9e9, 9e9)
			mfly1 = LocalPlayer.CharacterAdded:Connect(function(char)
				T = char:WaitForChild("HumanoidRootPart")
				BV = Instance.new("BodyVelocity")
				BV.Name = "MM2MainBodyVelocity"
				BV.Parent = T
				BV.velocity = Vector3.new(0, 0, 0)
				BV.maxForce = Vector3.new(9e9, 9e9, 9e9)
				BG = Instance.new("BodyGyro")
				BG.Name = "MM2MainBodyGyro"
				BG.Parent = T
				BG.maxTorque = Vector3.new(9e9, 9e9, 9e9)
				BG.cframe = T.CFrame
				BG.P = 9e4
			end)
			task.spawn(function()
				while Flying do
					LPlrHum.PlatformStand = true
					if CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0 then
						SPEED = 50
					elseif not (CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0) and SPEED ~= 0 then
						SPEED = 0
					end
					if (CONTROL.L + CONTROL.R) ~= 0 or (CONTROL.F + CONTROL.B) ~= 0 or (CONTROL.Q + CONTROL.E) ~= 0 then
						BV.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (CONTROL.F + CONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(CONTROL.L + CONTROL.R, (CONTROL.F + CONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
						lCONTROL = {F = CONTROL.F, B = CONTROL.B, L = CONTROL.L, R = CONTROL.R}
					elseif (CONTROL.L + CONTROL.R) == 0 and (CONTROL.F + CONTROL.B) == 0 and (CONTROL.Q + CONTROL.E) == 0 and SPEED ~= 0 then
						BV.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (lCONTROL.F + lCONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(lCONTROL.L + lCONTROL.R, (lCONTROL.F + lCONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
					else
						BV.velocity = Vector3.new(0, 0, 0)
					end
					BG.cframe = workspace.CurrentCamera.CoordinateFrame
					task.wait()
				end
				CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
				lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
				SPEED = 0
				mfly1:Disconnect()
				BG:Destroy()
				BV:Destroy()
				LPlrHum.PlatformStand = false
			end)
		end
		flyKeyDown = Mouse.KeyDown:Connect(function(KEY)
			if KEY:lower() == 'w' then
				CONTROL.F = Library.Flags.FlySpeed.CurrentValue
			elseif KEY:lower() == 's' then
				CONTROL.B = - Library.Flags.FlySpeed.CurrentValue
			elseif KEY:lower() == 'a' then
				CONTROL.L = - Library.Flags.FlySpeed.CurrentValue
			elseif KEY:lower() == 'd' then 
				CONTROL.R = Library.Flags.FlySpeed.CurrentValue
			elseif KEY:lower() == 'e' then
				CONTROL.Q = Library.Flags.FlySpeed.CurrentValue
			elseif KEY:lower() == 'q' then
				CONTROL.E = -Library.Flags.FlySpeed.CurrentValue
			end
			pcall(function() workspace.CurrentCamera.CameraType = Enum.CameraType.Track end)
		end)
		flyKeyUp = Mouse.KeyUp:Connect(function(KEY)
			if KEY:lower() == 'w' then
				CONTROL.F = 0
			elseif KEY:lower() == 's' then
				CONTROL.B = 0
			elseif KEY:lower() == 'a' then
				CONTROL.L = 0
			elseif KEY:lower() == 'd' then
				CONTROL.R = 0
			elseif KEY:lower() == 'e' then
				CONTROL.Q = 0
			elseif KEY:lower() == 'q' then
				CONTROL.E = 0
			end
		end)
		FLY()
	end
end
function DisableFly()
	if KeyboardEnabled then
		pcall(function()
			Flying = false
			local hrp = LPlrHrp
			hrp:FindFirstChild("MM2MainBodyVelocity"):Destroy()
			hrp:FindFirstChild("MM2MainBodyGyro"):Destroy()
			LPlrHum.PlatformStand = false
			mfly1:Disconnect()
			mfly2:Disconnect()
		end)
	else
		Flying = false
		if flyKeyDown or flyKeyUp then flyKeyDown:Disconnect() flyKeyUp:Disconnect() end
		LPlrHum.PlatformStand = false
		pcall(function() workspace.CurrentCamera.CameraType = Enum.CameraType.Custom end)
	end
end
function AddBHA(object,type,size,cframe,color,transparency,alwaysontop)
	local BHA = object:FindFirstChild("MM2MAIN CHAMBOX "..type)
	if BHA then
		BHA.CFrame = cframe or BHA.CFrame
		BHA.Color3 = color or BHA.Color3
		BHA.AlwaysOnTop = alwaysontop or BHA.AlwaysOnTop
		BHA.Size = size or BHA.Size
		BHA.Transparency = transparency or BHA.Transparency
		return
	end
	local newBHA = Instance.new("BoxHandleAdornment", object)
	newBHA.Adornee = object
	newBHA.CFrame = cframe or CFrame.identity
	newBHA.Color3 = color or Color3.new(1,1,1)
	newBHA.ZIndex = 10
	newBHA.AlwaysOnTop = alwaysontop ~= nil and alwaysontop
	newBHA.Size = size or object.Size
	newBHA.Transparency = transparency or 0.5
	newBHA.Name = "MM2MAIN CHAMBOX "..type
	newBHA:SetAttribute("ChamBoxType",type)
end
function RemoveBHA(object,type)
	if type then
		local BHA = object:FindFirstChild("MM2MAIN CHAMBOX "..type)
		if BHA then
			BHA:Destroy()
		end
	else
		for i, v in object:GetChildren() do
			if v:GetAttribute("MM2MAINCHAMBOX") then
				v:Destroy()
			end
		end
	end
end
function UpdateNameTagLayout(object)
	local order = {}
	for i, v in object:GetChildren() do
		local level = v:GetAttribute("NameTagLevel")
		if v.ClassName == "BillboardGui" and level then
			table.insert(order,{v,level})
		end
	end
	table.sort(order,function(a,b)
		return a[2] < b[2]
	end)
	for i, v in order do
		v[1].StudsOffset = Vector3.yAxis * 1.2 * i
	end
end
function AddNameTag(object,level,text,color)
	local nametag = object:FindFirstChild("MM2MAIN NAMETAG "..level)
	if nametag then
		local nametagtextlabel = nametag:FindFirstChildOfClass("TextLabel")
		if nametagtextlabel then
			nametagtextlabel.Text = text or nametagtextlabel.Text
			nametagtextlabel.TextColor3 = color or nametagtextlabel.TextColor3
		end
		return
	end
	local BillboardGui = Instance.new("BillboardGui", object)
	local Name = Instance.new("TextLabel", BillboardGui)
	BillboardGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	BillboardGui.Active = true
	BillboardGui.AlwaysOnTop = true
	BillboardGui.LightInfluence = 1
	BillboardGui.Size = UDim2.new(100, 0, 1.2, 0)
	BillboardGui.Name = "MM2MAIN NAMETAG "..level
	BillboardGui:SetAttribute("NameTagLevel",level)
	Name.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Name.BackgroundTransparency = 1
	Name.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Name.BorderSizePixel = 0
	Name.Size = UDim2.new(1, 0, 1, 0)
	Name.Font = Enum.Font.SourceSansBold
	Name.RichText = true
	Name.Text = text or "NameTag"
	Name.TextColor3 = color
	Name.TextScaled = true
	Name.TextSize = 19
	Name.TextStrokeTransparency = 0
	Name.TextWrapped = true
	UpdateNameTagLayout(object)
end
function RemoveNameTag(object,level)
	if level then
		local nametag = object:FindFirstChild("MM2MAIN NAMETAG "..level)
		if nametag then
			nametag:Destroy()
		end
	else
		for i, v in object:GetChildren() do
			if v:GetAttribute("NameTagLevel") then
				v:Destroy()
			end
		end
	end
	UpdateNameTagLayout(object)
end
function AddTracer(object,color,humanoid)
	local tracer = object:FindFirstChild("MM2MAIN TRACER")
	local dist = (object.Position - LPlrHrp.Position).Magnitude
	if tracer then
		tracer.Color3 = color or tracer.Color
		tracer.Humanoid = humanoid or tracer.Humanoid
		return
	end
	local newTracer = Instance.new("SelectionPartLasso",object)
	newTracer.Name = "MM2MAIN TRACER"
	newTracer.Color3 = color or Color3.new(1,1,1)
	newTracer.Humanoid = humanoid or nil
	newTracer.Part = object
	newTracer:SetAttribute("Tracer",true)
end
function RemoveTracer(object)
	local tracer = object:FindFirstChild("MM2MAIN TRACER")
	if tracer then
		tracer:Destroy()
	end
end
function UpdateChams(object,isacharmodel,chamsettings)
	if isacharmodel then
		if Players:GetPlayerFromCharacter(object) then
			for _, limb in object:GetChildren() do
				if limb:IsA("BasePart") and limb.Name ~= "HumanoidRootPart" then
					if chamsettings.Enabled then
						AddBHA(limb,chamsettings.Type or 1,chamsettings.Size or limb.Size,chamsettings.CFrame or CFrame.identity,chamsettings.Color or Color3.new(1,1,1),0.3,true)
					else
						RemoveBHA(limb,chamsettings.Type or 1)
					end
				end
			end
		end
	elseif object:IsA("BasePart") then
		if chamsettings.Enabled then
			AddBHA(object,chamsettings.Type or 1,chamsettings.Size or object.Size,chamsettings.CFrame or CFrame.identity,chamsettings.Color or Color3.new(1,1,1),0.3,true)
		else
			RemoveBHA(object,chamsettings.Type or 1)
		end
	end
end
function UpdateNameTags(object,isacharmodel,color,nametags)
	local currentnametags = {}
	if isacharmodel then
		if Players:GetPlayerFromCharacter(object) then
			local head = object:FindFirstChild("Head")
			if head then
				if nametags and #nametags > 0 then
					-- Constructed this way to reduce lag
					for i, v in nametags do
						AddNameTag(head,i,v.Name or object.Name,v.Color or color or Color3.new(1,1,1))
						table.insert(currentnametags,"MM2MAIN NAMETAG "..i)
					end
					for i, v in head:GetChildren() do
						if v:GetAttribute("NameTagLevel") and not table.find(currentnametags,v.Name) then
							v:Destroy()
						end
					end
				else
					RemoveNameTag(head)
				end
			end
		end
	elseif object:IsA("BasePart") then
		if nametags and #nametags > 0 then
			-- Constructed this way to reduce lag
			for i, v in nametags do
				AddNameTag(object,i,v.Name or object.Name,v.Color or color or Color3.new(1,1,1))
				table.insert(currentnametags,"MM2MAIN NAMETAG "..i)
			end
			for i, v in object:GetChildren() do
				if v:GetAttribute("NameTagLevel") and not table.find(currentnametags,v.Name) then
					v:Destroy()
				end
			end
		else
			RemoveNameTag(object,1)
		end
	end
end
function UpdateTracers(object,isacharmodel,color,enabled)
	if isacharmodel then
		if Players:GetPlayerFromCharacter(object) then
			local hrp = object:FindFirstChild("HumanoidRootPart")
			if hrp then
				if enabled then
					AddTracer(hrp,color,Camera.CameraSubject)
				else
					RemoveTracer(hrp)
				end
			end
		end
	elseif object:IsA("BasePart") then
		if enabled then
			AddTracer(object,color,Camera.CameraSubject)
		else
			RemoveTracer(object)
		end
	end
end
function Draw3D(startp,endp,color,lifetime) -- dictionary = {StartPoint = (), EndPoint = (), Color = (), LifeTime = ()}
	ID += 1
	local index = ID
	local properties = {
		CurrentID = index;
		StartPoint = startp;
		EndPoint = endp;
		Color = color or Color3.fromRGB(0,0,0);
		Line = nil;
		LifeTime = lifetime or 5;
		Spawn = tick()
	}
	table.insert(visuals, properties)
	local mt = {}
	mt.__newindex = function(_,idx,value)
		if visuals[index] then
			if idx == "Color" then
				visuals[index].Color = value
			elseif idx == "StartPoint" then
				visuals[index].StartPoint = value
			elseif idx == "EndPoint" then
				visuals[index].EndPoint = value
			elseif idx == "LifeTime" then
				visuals[index].LifeTime = value
			end
		end
	end
	local Drawing3D = setmetatable({},mt)
	function Drawing3D:Destroy()
		for i, v in visuals do
			if v.CurrentID == properties.CurrentID then
				visuals[i] = "nil"
			end
		end
	end
	return Drawing3D
end
function UpdateMobileGUI()
	local lastInput = UIS:GetLastInputType()
	if lastInput == Enum.UserInputType.Focus then return end -- ignore if the player focuses on the app
	MobileButtonContainer.Visible = lastInput == Enum.UserInputType.Touch -- makes the frame visible if the user touched the screen
end
---------------------------------------------------------------------------
-- Interface
local Window = Library:BootWindow({
	LoadingTitle = "🎃 Murder Mystery 2 Main 🎃";
	WindowVisible = true;
	ToggleGUIKeybind = Enum.KeyCode.RightShift;
	ConfigurationSaving = {
		Enabled = true;
		FolderName = "MM2MainConfigurations"; -- Must keep it unique, otherwise other scripts using FPSLibrary may overwrite your file
		PlaceId = true -- Only saves configs for a certain PlaceId
	};
	Discord = {
        Enabled = false;
		InviteLink = ""; -- discord invite link (eg. discord.gg/ABCD)
		RememberJoins = true
	};
	ToggleInterface = {
		Enabled = true;
		KeyboardCheck = false; -- Automatically Hides Button When Keyboard is Enabled
		Title = "MM2 Main";
		UseIcon = true;
		Icon = 116105434235522; -- Shows a small icon that toggles GUI appearance
		Position = UDim2.new(0.5,0,0,18);
		AnchorPoint = Vector2.new(0.5,0.5);
		Draggable = true;
		ShowAfterKeySystem = false;
	};
	KeySystem = {
		Enabled = false; -- The thread will yield until key is validated
		Keys = {"key1","key2","key3"}; -- An array of valid keys. Will not apply if GrabKeyFromSite is true
		EncryptKey = false; -- Applies AES-256 encryption to key file (currently not working)
		CypherKey = ""; -- cypher key length must be 16 or more. https://catonmat.net/tools/generate-random-ascii
		FileName = "Key"; -- Must keep it unique, otherwise other scripts using FPSLibrary may overwrite your file
		RememberKey = false; -- Will not ask for the key unless key has changed or expired
		KeyTimeLimit = 86400; -- in seconds
		GrabKeyFromSite = false; -- Gets key from a website
		WebsiteURL = ""; -- website you will be directed to for the key (eg. https://linkvertise.com/<link>)
		KeyRAWURL = ""; -- website where the RAW key is checked for (eg. https://raw.githubusercontent.com/<username>/<directory> or https://pastebin.com/raw/<paste>)
		JSONDecode = false; -- If RAW key is in json format (eg. ["key1","key2","key3"])
	}
})
---------------------------------------------------------------------------
-- Tabs
local MainTab = Window:CreateTab({
	Title = "Main"; -- Title of the Tab
	Subtitle = "Aimbot & Combat"; -- Second title under the title
	Opened = false; -- If the tab is open
	TitleRichText = false; -- Enables RichText for the Title
	SubtitleRichText = false; -- Enables RichText for the Subtitle
	SizeY = 290; -- Length of the tab dropdown, SizeY must be 100 or more
	MaxSizeY = 290; -- Maximum length of the tab dropdown, SizeY must be 100 or more
	Position = UDim2.new(0,20,0,20); -- Position of the Tab on Window
	Flag = ""; -- Identifier for the configuration file (cannot be changed)
	IgnoreList = FlagsIgnoreList -- The properties the flag will blacklist/not saved
})
local VisualsTab = Window:CreateTab({
	Title = "Visuals"; -- Title of the Tab
	Subtitle = "ESP & Render"; -- Second title under the title
	Opened = false; -- If the tab is open
	TitleRichText = false; -- Enables RichText for the Title
	SubtitleRichText = false; -- Enables RichText for the Subtitle
	SizeY = 290; -- Length of the tab dropdown, SizeY must be 100 or more
	MaxSizeY = 290; -- Maximum length of the tab dropdown, SizeY must be 100 or more
	Position = UDim2.new(0,20,0,20); -- Position of the Tab on Window
	Flag = ""; -- Identifier for the configuration file (cannot be changed)
	IgnoreList = FlagsIgnoreList -- The properties the flag will blacklist/not saved
})
local MiscellaneousTab = Window:CreateTab({
	Title = "Miscellaneous"; -- Title of the Tab
	Subtitle = "Blatant & Fun"; -- Second title under the title
	Opened = false; -- If the tab is open
	TitleRichText = false; -- Enables RichText for the Title
	SubtitleRichText = false; -- Enables RichText for the Subtitle
	SizeY = 290; -- Length of the tab dropdown, SizeY must be 100 or more
	MaxSizeY = 290; -- Maximum length of the tab dropdown, SizeY must be 100 or more
	Position = UDim2.new(0,20,0,20); -- Position of the Tab on Window
	Flag = ""; -- Identifier for the configuration file (cannot be changed)
	IgnoreList = FlagsIgnoreList -- The properties the flag will blacklist/not saved
})
local EconomyTab = Window:CreateTab({
	Title = "Economy"; -- Title of the Tab
	Subtitle = "Trading & AutoFarm"; -- Second title under the title
	Opened = false; -- If the tab is open
	TitleRichText = false; -- Enables RichText for the Title
	SubtitleRichText = false; -- Enables RichText for the Subtitle
	SizeY = 290; -- Length of the tab dropdown, SizeY must be 100 or more
	MaxSizeY = 290; -- Maximum length of the tab dropdown, SizeY must be 100 or more
	Position = UDim2.new(0,20,0,20); -- Position of the Tab on Window
	Flag = ""; -- Identifier for the configuration file (cannot be changed)
	IgnoreList = FlagsIgnoreList -- The properties the flag will blacklist/not saved
})
local OthersTab = Window:CreateTab({
	Title = "Others"; -- Title of the Tab
	Subtitle = "Configs & More Scripts"; -- Second title under the title
	Opened = false; -- If the tab is open
	TitleRichText = false; -- Enables RichText for the Title
	SubtitleRichText = false; -- Enables RichText for the Subtitle
	SizeY = 290; -- Length of the tab dropdown, SizeY must be 100 or more
	MaxSizeY = 290; -- Maximum length of the tab dropdown, SizeY must be 100 or more
	Position = UDim2.new(0,20,0,20); -- Position of the Tab on Window
	Flag = ""; -- Identifier for the configuration file (cannot be changed)
	IgnoreList = FlagsIgnoreList -- The properties the flag will blacklist/not saved
})
Window:OrganizeTabs(19,19,0)
---------------------------------------------------------------------------
-- Aimbot
local AimbotSection = MainTab:CreateSection("Aimbot",120,true) -- Name, DropdownSizeY, Opened
MainTab:CreateToggle({ -- DONE
	Name = "Gun Aimbot";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = AimbotSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "GunAimbot"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
	end
})
MainTab:CreateToggle({ -- DONE
	Name = "Knife Aimbot";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = AimbotSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "KnifeAimbot"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
	end
})
MainTab:CreateSeparator("Aimbot Settings",AimbotSection) -- Text, SectionParent
local GunPredictionSlider = MainTab:CreateSlider({ -- DONE
	Name = "Gun Prediction";
	RichText = false; -- Enables RichText for the Name
	ScrollBarRichText = false; -- Enables RichText for the Value Display
	SliderColor = Color3.fromRGB(255, 231, 112); -- Color of the slider bar
	BlendColors = false; -- Blends MinColor & MaxColor depending on CurrentValue
	MinColor = Color3.fromRGB(255, 112, 112); -- Color of the slider bar at minimum value
	MaxColor = Color3.fromRGB(255, 231, 112); -- Color of the slider bar at maximum value
	SectionParent = AimbotSection; -- The SectionTab the button is parented to
	MinValue = 0; -- Minimum value of the slider
	MaxValue = 500; -- Maximum value of the slider
	CurrentValue = 160; -- The current value of the slider
	Increment = 1; -- The amount the value increases by when sliding. Increment cannot be 0 or negative
	FormatString = "%dms"; -- "%d" represents the CurrentValue
	CallbackOnRelease = true; -- Callback only when mouse is released
	Flag = "GunPrediction"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after slider is changed
	end
})
local KnifePredictionSlider = MainTab:CreateSlider({ -- DONE
	Name = "Knife Prediction";
	RichText = false; -- Enables RichText for the Name
	ScrollBarRichText = false; -- Enables RichText for the Value Display
	SliderColor = Color3.fromRGB(255, 231, 112); -- Color of the slider bar
	BlendColors = false; -- Blends MinColor & MaxColor depending on CurrentValue
	MinColor = Color3.fromRGB(255, 112, 112); -- Color of the slider bar at minimum value
	MaxColor = Color3.fromRGB(255, 231, 112); -- Color of the slider bar at maximum value
	SectionParent = AimbotSection; -- The SectionTab the button is parented to
	MinValue = 0; -- Minimum value of the slider
	MaxValue = 500; -- Maximum value of the slider
	CurrentValue = 144; -- The current value of the slider
	Increment = 1; -- The amount the value increases by when sliding. Increment cannot be 0 or negative
	FormatString = "%dms"; -- "%d" represents the CurrentValue
	CallbackOnRelease = true; -- Callback only when mouse is released
	Flag = "KnifePrediction"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after slider is changed
	end
})
MainTab:CreateToggle({ -- DONE
	Name = "Use FOV";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = AimbotSection; -- The SectionTab the button is parented to
	CurrentValue = true; -- If the toggle is on/off
	Flag = "AimbotUseFOV"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
		if value then
			Window:ActivateElement(FOVSlider)
		else
			Window:DeactivateElement(FOVSlider)
		end
	end
})
FOVSlider = MainTab:CreateSlider({ -- DONE
	Name = "FOV";
	RichText = false; -- Enables RichText for the Name
	ScrollBarRichText = false; -- Enables RichText for the Value Display
	SliderColor = Color3.fromRGB(255, 231, 112); -- Color of the slider bar
	BlendColors = false; -- Blends MinColor & MaxColor depending on CurrentValue
	MinColor = Color3.fromRGB(255, 112, 112); -- Color of the slider bar at minimum value
	MaxColor = Color3.fromRGB(255, 231, 112); -- Color of the slider bar at maximum value
	SectionParent = AimbotSection; -- The SectionTab the button is parented to
	MinValue = 0; -- Minimum value of the slider
	MaxValue = 1000; -- Maximum value of the slider
	CurrentValue = 350; -- The current value of the slider
	Increment = 1; -- The amount the value increases by when sliding. Increment cannot be 0 or negative
	FormatString = "%d"; -- "%d" represents the CurrentValue
	CallbackOnRelease = true; -- Callback only when mouse is released
	Flag = "AimbotFOV"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after slider is changed
	end
})
MainTab:CreateSeparator("Target",AimbotSection) -- Text, SectionParent
MainTab:CreateDropdown({ -- DONE
	Name = "Sheriff Target";
	RichText = false; -- Enables RichText for the Name
	Options = {"ClosestPlayerToCursor","ClosestPlayerToCharacter","ClosestPlayerToScreenCenter"};
	CurrentOption = {"ClosestPlayerToCursor"};
	SelectedColor = Color3.fromRGB(121, 152, 255); -- Color of the slider bar
	MinOptions = 1; -- Minimum amount of options the user can select
	MaxOptions = 1; -- Maximum amount of options the user can select
	CallbackOnSelect = true; -- Callback anytime an option is selected
	SectionParent = AimbotSection; -- The SectionTab the element is parented to
	Flag = "SheriffTargetMethod"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(options) -- options will always return a table
	end
})
MainTab:CreateDropdown({ -- DONE
	Name = "Murderer Target";
	RichText = false; -- Enables RichText for the Name
	Options = {"ClosestPlayerToCursor","ClosestPlayerToCharacter","ClosestPlayerToScreenCenter"};
	CurrentOption = {"ClosestPlayerToCursor"};
	SelectedColor = Color3.fromRGB(121, 152, 255); -- Color of the slider bar
	MinOptions = 1; -- Minimum amount of options the user can select
	MaxOptions = 1; -- Maximum amount of options the user can select
	CallbackOnSelect = true; -- Callback anytime an option is selected
	SectionParent = AimbotSection; -- The SectionTab the element is parented to
	Flag = "MurdererTargetMethod"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(options) -- options will always return a table
	end
})
MainTab:CreateToggle({ -- DONE
	Name = "Smart Target";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = AimbotSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "SmartTarget"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
	end
})
MainTab:CreateSeparator("Prediction",AimbotSection) -- Text, SectionParent
MainTab:CreateDropdown({ -- DONE
	Name = "Prediction Method";
	RichText = false; -- Enables RichText for the Name
	Options = {"Simulated","AI"};
	CurrentOption = {"Simulated"};
	SelectedColor = Color3.fromRGB(121, 152, 255); -- Color of the slider bar
	MinOptions = 1; -- Minimum amount of options the user can select
	MaxOptions = 1; -- Maximum amount of options the user can select
	CallbackOnSelect = true; -- Callback anytime an option is selected
	SectionParent = AimbotSection; -- The SectionTab the element is parented to
	Flag = "AimbotPredictionMethod"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(options) -- options will always return a table
		if options[1] == "AI" then
			Library:Notify({
				Type = "info"; -- (Required) id0x1 = Error, id0x2 = Info, id0x3 = Success, set to nil for normal notification
				Title = "Info";
				Message = "AI Aimbot is under development.";
				Duration = 5;
			})
		end
	end
})
Window:AddElementTip(MainTab:CreateToggle({ -- DONE
	Name = "Automatic Prediction";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = AimbotSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "AimbotAutoPrediction"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
		if value then
			Window:DeactivateElement(GunPredictionSlider)
			Window:DeactivateElement(KnifePredictionSlider)
		else
			Window:ActivateElement(GunPredictionSlider)
			Window:ActivateElement(KnifePredictionSlider)
		end
	end
}),"Automatically Controls Gun and Knife (ms) prediction depending on ping.",5)
MainTab:CreateToggle({ -- DONE
	Name = "Predict Jump";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = AimbotSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "AimbotPredictJump"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
	end
})
MainTab:CreateToggle({ -- DONE
	Name = "Always Jumping";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = AimbotSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "AimbotAlwaysJumping"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
	end
})
---------------------------------------------------------------------------
local CombatSection = MainTab:CreateSection("Combat",120,true) -- Name, DropdownSizeY, Opened
MainTab:CreateToggle({ -- DONE
	Name = "Auto Dodge";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = CombatSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "AutoDodge"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
	end
})
MainTab:CreateToggle({ -- DONE
	Name = "Show Knife Barrier";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = CombatSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "AutoDodgeShowKnifeBarrier"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
	end
})
MainTab:CreateToggle({ -- DONE
	Name = "Anti Aim";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = CombatSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "AntiAim"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
	end
})
Window:AddElementTip(MainTab:CreateToggle({
	Name = "Anti Stab";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = CombatSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "AntiStab"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
	end
}),"Decreases your chances of getting stabbed.",5) -- Shows a tip under your mouse cursor (ElementName,Tip,Duration)
Window:AddElementTip(MainTab:CreateToggle({
	Name = "Anti Trap";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = CombatSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "AntiTrap"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
	end
}),"Stops you from slowing down when trapped.",5) -- Shows a tip under your mouse cursor (ElementName,Tip,Duration)
Window:AddElementTip(MainTab:CreateToggle({
	Name = "Gun Trap";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = CombatSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "GunTrap"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
	end
}),"Automatically melee kills anybody who grabs the gun.",5) -- Shows a tip under your mouse cursor (ElementName,Tip,Duration)
MainTab:CreateToggle({ -- DONE
	Name = "Fake Bomb Jump";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = CombatSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "FakeBombJump"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
	end
})
MainTab:CreateToggle({ -- DONE
	Name = "Auto Equip Knife";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = CombatSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "AutoEquipKnife"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
	end
})
MainTab:CreateToggle({ -- DONE
	Name = "Auto Equip Gun";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = CombatSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "AutoEquipGun"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
	end
})
MainTab:CreateToggle({ -- UNDER MAINTENANCE
	Name = "Auto Shoot";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = CombatSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "AutoShoot"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
	end
})
Window:AddElementTip(MainTab:CreateToggle({ -- UNDER MAINTENANCE
	Name = "Legit Mode";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = CombatSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "AutoShootLegitMode"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
	end
}),"Only shoots when the target holds out their knife.",5)
MainTab:CreateToggle({
	Name = "Auto Throw";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = CombatSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "AutoThrow"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
	end
})
MainTab:CreateToggle({
	Name = "Use Throw Animation";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = CombatSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "AutoThrowUseThrowAnimation"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
	end
})
Window:AddElementTip(MainTab:CreateToggle({ -- UNDER MAINTENANCE
	Name = "Face Target";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = CombatSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "KnifeFaceTarget"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
	end
}),"Forces the character to face directly at the target.",5)
---------------------------------------------------------------------------
local KillAuraSection = MainTab:CreateSection("Kill Aura",72,true) -- Name, DropdownSizeY, Opened
MainTab:CreateToggle({ -- DONE
	Name = "Kill Aura";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = KillAuraSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "KillAura"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
		if value and not firetouchinterest then
			MM2MainErrorNotification("Your executor does not support this exploit (missing 'firetouchinterest')")
		end
	end
})
MainTab:CreateToggle({ -- DONE
	Name = "Multi Aura";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = KillAuraSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "MultiAura"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
	end
})
MainTab:CreateSlider({ -- DONE
	Name = "Kill Aura Range";
	RichText = false; -- Enables RichText for the Name
	ScrollBarRichText = false; -- Enables RichText for the Value Display
	SliderColor = Color3.fromRGB(255, 231, 112); -- Color of the slider bar
	BlendColors = false; -- Blends MinColor & MaxColor depending on CurrentValue
	MinColor = Color3.fromRGB(255, 112, 112); -- Color of the slider bar at minimum value
	SectionParent = KillAuraSection; -- The SectionTab the button is parented to
	MinValue = 0; -- Minimum value of the slider
	MaxValue = 20; -- Maximum value of the slider
	CurrentValue = 15; -- The current value of the slider
	Increment = 0.1; -- The amount the value increases by when sliding. Increment cannot be 0 or negative
	FormatString = "%d"; -- "%d" represents the CurrentValue
	CallbackOnRelease = true; -- Callback only when mouse is released
	Flag = "KillAuraRange"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after slider is changed
	end
})
Window:AddElementTip(MainTab:CreateToggle({ -- DONE
	Name = "Face Target";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = KillAuraSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "KillAuraFaceTarget"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
	end
}),"Forces the character to face directly at the target.",5)
Window:AddElementTip(MainTab:CreateToggle({ -- DONE
	Name = "Highlight Target";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = KillAuraSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "KillAuraTargetHighlight"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
		print("Toggle set to "..tostring(value))
	end
}),"Shows a highlighted box around the target using 'TargetColor'",5)
---------------------------------------------------------------------------
local AntiFlingSection = MainTab:CreateSection("Anti Fling",12,true) -- Name, DropdownSizeY, Opened
Window:AddElementTip(MainTab:CreateToggle({ -- DONE
	Name = "Anti Fling";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = AntiFlingSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "AntiFling"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
		print("Toggle set to "..tostring(value))
	end
}),"Prevents potential exploiters from flinging you.",5)
---------------------------------------------------------------------------
local LocalPlayerSection = MainTab:CreateSection("LocalPlayer",120,true) -- Name, DropdownSizeY, Opened
MainTab:CreateToggle({ -- DONE
	Name = "Noclip";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = LocalPlayerSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "Noclip"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
		print("Toggle set to "..tostring(value))
	end
})
MainTab:CreateKeybind({ -- UNDER TESTING
	Name = "Noclip Keybind";
	RichText = false; -- Enables RichText for the Name
	CurrentKeybind = Enum.KeyCode.N;
   	HoldToInteract = false;
	SectionParent = LocalPlayerSection; -- The SectionTab the element is parented to
	Callback = function(keybind) -- The function that is called after button is activated
		Noclipping = not Noclipping
		if not Noclipping then
			for i, v in LPlrChar:GetDescendants() do
				if v:IsA("BasePart") then
					v.CanCollide = true
				end
			end
		end
	end
})
MainTab:CreateToggle({ -- DONE
	Name = "Fly";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = LocalPlayerSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "Fly"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
		print("Toggle set to "..tostring(value))
	end
})
MainTab:CreateKeybind({ -- UNDER TESTING
	Name = "Fly Keybind";
	RichText = false; -- Enables RichText for the Name
	CurrentKeybind = Enum.KeyCode.X;
   	HoldToInteract = false;
	SectionParent = LocalPlayerSection; -- The SectionTab the element is parented to
	Callback = function(keybind) -- The function that is called after button is activated
		if Library.Flags.Fly.CurrentValue then
			if Flying then
				DisableFly()
			else
				DisableFly()
				EnableFly()
			end
		end
	end
})
MainTab:CreateSlider({ -- DONE
	Name = "Fly Speed";
	RichText = false; -- Enables RichText for the Name
	ScrollBarRichText = false; -- Enables RichText for the Value Display
	SliderColor = Color3.fromRGB(255, 231, 112); -- Color of the slider bar
	BlendColors = false; -- Blends MinColor & MaxColor depending on CurrentValue
	MinColor = Color3.fromRGB(255, 112, 112); -- Color of the slider bar at minimum value
	MaxColor = Color3.fromRGB(255, 231, 112); -- Color of the slider bar at maximum value
	SectionParent = LocalPlayerSection; -- The SectionTab the button is parented to
	MinValue = 1; -- Minimum value of the slider
	MaxValue = 100; -- Maximum value of the slider
	CurrentValue = 10; -- The current value of the slider
	Increment = 1; -- The amount the value increases by when sliding. Increment cannot be 0 or negative
	FormatString = "%d"; -- "%d" represents the CurrentValue
	CallbackOnRelease = true; -- Callback only when mouse is released
	Flag = "FlySpeed"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after slider is changed
	end
})
MainTab:CreateToggle({ -- DONE
	Name = "Toggle WalkSpeed";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = LocalPlayerSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "ToggleWalkSpeed"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
		if not value then
			LPlrHum.WalkSpeed = 16
		end
	end
})
MainTab:CreateSlider({ -- DONE
	Name = "WalkSpeed";
	RichText = false; -- Enables RichText for the Name
	ScrollBarRichText = false; -- Enables RichText for the Value Display
	SliderColor = Color3.fromRGB(255, 231, 112); -- Color of the slider bar
	BlendColors = false; -- Blends MinColor & MaxColor depending on CurrentValue
	MinColor = Color3.fromRGB(255, 112, 112); -- Color of the slider bar at minimum value
	MaxColor = Color3.fromRGB(255, 231, 112); -- Color of the slider bar at maximum value
	SectionParent = LocalPlayerSection; -- The SectionTab the button is parented to
	MinValue = 0; -- Minimum value of the slider
	MaxValue = 100; -- Maximum value of the slider
	CurrentValue = 16; -- The current value of the slider
	Increment = 1; -- The amount the value increases by when sliding. Increment cannot be 0 or negative
	FormatString = "%d"; -- "%d" represents the CurrentValue
	CallbackOnRelease = true; -- Callback only when mouse is released
	Flag = "WalkSpeed"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after slider is changed
	end
})
MainTab:CreateToggle({ -- DONE
	Name = "Toggle JumpPower";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = LocalPlayerSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "ToggleJumpPower"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
		if not value then
			LPlrHum.JumpPower = 50
		end
	end
})
MainTab:CreateSlider({ -- DONE
	Name = "JumpPower";
	RichText = false; -- Enables RichText for the Name
	ScrollBarRichText = false; -- Enables RichText for the Value Display
	SliderColor = Color3.fromRGB(255, 231, 112); -- Color of the slider bar
	BlendColors = false; -- Blends MinColor & MaxColor depending on CurrentValue
	MinColor = Color3.fromRGB(255, 112, 112); -- Color of the slider bar at minimum value
	MaxColor = Color3.fromRGB(255, 231, 112); -- Color of the slider bar at maximum value
	SectionParent = LocalPlayerSection; -- The SectionTab the button is parented to
	MinValue = 0; -- Minimum value of the slider
	MaxValue = 100; -- Maximum value of the slider
	CurrentValue = 50; -- The current value of the slider
	Increment = 1; -- The amount the value increases by when sliding. Increment cannot be 0 or negative
	FormatString = "%d"; -- "%d" represents the CurrentValue
	CallbackOnRelease = true; -- Callback only when mouse is released
	Flag = "JumpPower"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after slider is changed
	end
})
MainTab:CreateSlider({ -- UNDER TESTING
	Name = "Gravity";
	RichText = false; -- Enables RichText for the Name
	ScrollBarRichText = false; -- Enables RichText for the Value Display
	SliderColor = Color3.fromRGB(255, 231, 112); -- Color of the slider bar
	BlendColors = false; -- Blends MinColor & MaxColor depending on CurrentValue
	MinColor = Color3.fromRGB(255, 112, 112); -- Color of the slider bar at minimum value
	MaxColor = Color3.fromRGB(255, 231, 112); -- Color of the slider bar at maximum value
	SectionParent = LocalPlayerSection; -- The SectionTab the button is parented to
	MinValue = 0; -- Minimum value of the slider
	MaxValue = 500; -- Maximum value of the slider
	CurrentValue = 196.2; -- The current value of the slider
	Increment = 0.1; -- The amount the value increases by when sliding. Increment cannot be 0 or negative
	FormatString = "%d"; -- "%d" represents the CurrentValue
	CallbackOnRelease = true; -- Callback only when mouse is released
	Flag = "Gravity"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after slider is changed
		workspace.Gravity = value
	end
})
Window:AddElementTip(MainTab:CreateToggle({
	Name = "BHop";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = LocalPlayerSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "BHop"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
		print("Toggle set to "..tostring(value))
	end
}),"Makes you hover up and down making you harder to hit.",5)
Window:AddElementTip(MainTab:CreateToggle({
	Name = "Real Jump";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = LocalPlayerSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "BHopRealJump"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
		print("Toggle set to "..tostring(value))
	end
}),"Use legitimate jumping mode.",5)
MainTab:CreateToggle({
	Name = "Infinite Swim";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = LocalPlayerSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "InfiniteSwim"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
		print("Toggle set to "..tostring(value))
	end
})
MainTab:CreateToggle({
	Name = "Infinite Jump";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = LocalPlayerSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "InfiniteJump"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
		print("Toggle set to "..tostring(value))
	end
})
---------------------------------------------------------------------------
-- Visuals
local ChamsSection = VisualsTab:CreateSection("Chams",120,true) -- Name, DropdownSizeY, Opened
VisualsTab:CreateToggle({ -- DONE
	Name = "Player Chams";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = ChamsSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "PlayerChams"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
		for player in players do
			players[player].UpdateChams()
		end
	end
})
VisualsTab:CreateToggle({ -- DONE
	Name = "Player Tracers";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = ChamsSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "PlayerTracers"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
		for _, player in Players:GetChildren() do
			local char = player.Character
			if char then
				UpdateTracers(char,true,nil,false)
			end
		end
	end
})
VisualsTab:CreateToggle({ -- DONE
	Name = "NameTags";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = ChamsSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "NameTags"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
		--[[
		for _, player in Players:GetChildren() do
			local char = player.Character
			if char then
				UpdateNameTags(char,true,nil,{})
			end
		end
		]]
	end
})
VisualsTab:CreateToggle({ -- DONE
	Name = "Show Distance";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = ChamsSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "ShowDistance"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
		--[[
		for _, player in Players:GetChildren() do
			local char = player.Character
			if char then
				UpdateNameTags(char,true,nil,{})
			end
		end
		]]
	end
})
VisualsTab:CreateToggle({ -- DONE
	Name = "Show Perks";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = ChamsSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "ShowPerks"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
		for _, player in Players:GetChildren() do
			local char = player.Character
			if char then
				UpdateNameTags(char,true,nil,{})
			end
		end
	end
})
VisualsTab:CreateToggle({
	Name = "Show Traps";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = ChamsSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "ShowTraps"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
		print("Toggle set to "..tostring(value))
	end
})
local ShowGunDropToggle = VisualsTab:CreateToggle({ -- DONE
	Name = "Show Gun Drop";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = ChamsSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "ShowGunDrop"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
		ShowGunDrop(value)
	end
})
Window:AddElementTip(VisualsTab:CreateToggle({ -- DONE
	Name = "Knife Traces";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = ChamsSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "ShowKnifeTraces"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
		print("Toggle set to "..tostring(value))
	end
}),"Purple = Far Away, Red = Close Knife",5) -- Shows a tip under your mouse cursor (ElementName,Tip,Duration)
Window:AddElementTip(VisualsTab:CreateToggle({ -- DONE
	Name = "Weapon ESP";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = ChamsSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "WeaponESP"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
		print("Toggle set to "..tostring(value))
	end
}),"Shows player's equipped weapons",5) -- Shows a tip under your mouse cursor (ElementName,Tip,Duration)
Window:AddElementTip(VisualsTab:CreateToggle({ -- DONE
	Name = "Inventory ESP";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = ChamsSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "InventoryESP"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
		print("Toggle set to "..tostring(value))
	end
}),"Shows player's inventory of items.",5) -- Shows a tip under your mouse cursor (ElementName,Tip,Duration)
VisualsTab:CreateColorPicker({
	Name = "Murderer Color";
	RichText = false; -- Enables RichText for the Name
	CurrentColor = Color3.fromRGB(255, 112, 112);
	CallbackOnRelease = false; -- Callback only when mouse is released
	EnableRainbowMode = true; -- Allows the user to switch between rainbow mode
	Rainbow = false;
	RainbowSpeed = 1; -- Cycles per second
	RainbowSaturation = 163; -- (0 - 255)
	RainbowBrightness = 255; -- (0 - 255)
	RainbowCallback = true; -- Callback every rainbow step
	SectionParent = ChamsSection; -- The SectionTab the element is parented to
	Flag = "MurdererColor"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(color) -- The function that is called after button is activated
		for player in players do
			players[player].UpdateChams()
		end
	end
})
VisualsTab:CreateColorPicker({
	Name = "Trap Color";
	RichText = false; -- Enables RichText for the Name
	CurrentColor = Color3.fromRGB(255, 172, 112);
	CallbackOnRelease = false; -- Callback only when mouse is released
	EnableRainbowMode = true; -- Allows the user to switch between rainbow mode
	Rainbow = false;
	RainbowSpeed = 1; -- Cycles per second
	RainbowSaturation = 163; -- (0 - 255)
	RainbowBrightness = 255; -- (0 - 255)
	RainbowCallback = true; -- Callback every rainbow step
	SectionParent = ChamsSection; -- The SectionTab the element is parented to
	Flag = "TrapColor"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(color) -- The function that is called after button is activated
		for player in players do
			players[player].UpdateChams()
		end
	end
})
VisualsTab:CreateColorPicker({
	Name = "Hero Color";
	RichText = false; -- Enables RichText for the Name
	CurrentColor = Color3.fromRGB(255, 231, 112);
	CallbackOnRelease = false; -- Callback only when mouse is released
	EnableRainbowMode = true; -- Allows the user to switch between rainbow mode
	Rainbow = false;
	RainbowSpeed = 1; -- Cycles per second
	RainbowSaturation = 163; -- (0 - 255)
	RainbowBrightness = 255; -- (0 - 255)
	RainbowCallback = true; -- Callback every rainbow step
	SectionParent = ChamsSection; -- The SectionTab the element is parented to
	Flag = "HeroColor"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(color) -- The function that is called after button is activated
		for player in players do
			players[player].UpdateChams()
		end
	end
})
VisualsTab:CreateColorPicker({
	Name = "Innocent Color";
	RichText = false; -- Enables RichText for the Name
	CurrentColor = Color3.fromRGB(143, 255, 112);
	CallbackOnRelease = false; -- Callback only when mouse is released
	EnableRainbowMode = true; -- Allows the user to switch between rainbow mode
	Rainbow = false;
	RainbowSpeed = 1; -- Cycles per second
	RainbowSaturation = 163; -- (0 - 255)
	RainbowBrightness = 255; -- (0 - 255)
	RainbowCallback = true; -- Callback every rainbow step
	SectionParent = ChamsSection; -- The SectionTab the element is parented to
	Flag = "InnocentColor"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(color) -- The function that is called after button is activated
		for player in players do
			players[player].UpdateChams()
		end
	end
})
VisualsTab:CreateColorPicker({
	Name = "Target Color";
	RichText = false; -- Enables RichText for the Name
	CurrentColor = Color3.fromRGB(112, 222, 255);
	CallbackOnRelease = false; -- Callback only when mouse is released
	EnableRainbowMode = true; -- Allows the user to switch between rainbow mode
	Rainbow = false;
	RainbowSpeed = 1; -- Cycles per second
	RainbowSaturation = 163; -- (0 - 255)
	RainbowBrightness = 255; -- (0 - 255)
	RainbowCallback = true; -- Callback every rainbow step
	SectionParent = ChamsSection; -- The SectionTab the element is parented to
	Flag = "TargetColor"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(color) -- The function that is called after button is activated
	end
})
VisualsTab:CreateColorPicker({
	Name = "Sheriff Color";
	RichText = false; -- Enables RichText for the Name
	CurrentColor = Color3.fromRGB(112, 145, 255);
	CallbackOnRelease = false; -- Callback only when mouse is released
	EnableRainbowMode = true; -- Allows the user to switch between rainbow mode
	Rainbow = false;
	RainbowSpeed = 1; -- Cycles per second
	RainbowSaturation = 163; -- (0 - 255)
	RainbowBrightness = 255; -- (0 - 255)
	RainbowCallback = true; -- Callback every rainbow step
	SectionParent = ChamsSection; -- The SectionTab the element is parented to
	Flag = "SheriffColor"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(color) -- The function that is called after button is activated
		for player in players do
			players[player].UpdateChams()
		end
	end
})
VisualsTab:CreateColorPicker({
	Name = "Gun Drop Color";
	RichText = false; -- Enables RichText for the Name
	CurrentColor = Color3.fromRGB(141, 112, 255);
	CallbackOnRelease = false; -- Callback only when mouse is released
	EnableRainbowMode = true; -- Allows the user to switch between rainbow mode
	Rainbow = false;
	RainbowSpeed = 1; -- Cycles per second
	RainbowSaturation = 163; -- (0 - 255)
	RainbowBrightness = 255; -- (0 - 255)
	RainbowCallback = true; -- Callback every rainbow step
	SectionParent = ChamsSection; -- The SectionTab the element is parented to
	Flag = "GunDropColor"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(color) -- The function that is called after button is activated
		ShowGunDrop(Library.Flags.ShowGunDrop.CurrentValue)
	end
})
VisualsTab:CreateColorPicker({
	Name = "Weapon ESP Color";
	RichText = false; -- Enables RichText for the Name
	CurrentColor = Color3.fromRGB(255, 112, 174);
	CallbackOnRelease = false; -- Callback only when mouse is released
	EnableRainbowMode = true; -- Allows the user to switch between rainbow mode
	Rainbow = false;
	RainbowSpeed = 1; -- Cycles per second
	RainbowSaturation = 163; -- (0 - 255)
	RainbowBrightness = 255; -- (0 - 255)
	RainbowCallback = true; -- Callback every rainbow step
	SectionParent = ChamsSection; -- The SectionTab the element is parented to
	Flag = "WeaponColor"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(color) -- The function that is called after button is activated
		ShowGunDrop(Library.Flags.ShowGunDrop.CurrentValue)
	end
})
VisualsTab:CreateColorPicker({
	Name = "Dead Color";
	RichText = false; -- Enables RichText for the Name
	CurrentColor = Color3.fromRGB(148, 148, 148);
	CallbackOnRelease = false; -- Callback only when mouse is released
	EnableRainbowMode = true; -- Allows the user to switch between rainbow mode
	Rainbow = false;
	RainbowSpeed = 1; -- Cycles per second
	RainbowSaturation = 163; -- (0 - 255)
	RainbowBrightness = 255; -- (0 - 255)
	RainbowCallback = true; -- Callback every rainbow step
	SectionParent = ChamsSection; -- The SectionTab the element is parented to
	Flag = "DeadColor"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(color) -- The function that is called after button is activated
		for player in players do
			players[player].UpdateChams()
		end
	end
})
local AimbotVisualsSection = VisualsTab:CreateSection("Aimbot Visuals",24,true) -- Name, DropdownSizeY, Opened
VisualsTab:CreateToggle({ -- DONE
	Name = "Show FOV Circle";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = AimbotVisualsSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "ShowFOVCircle"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
	end
})
VisualsTab:CreateToggle({ -- DONE
	Name = "Show Aimbot Visuals";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = AimbotVisualsSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "ShowAimbotVisuals"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
	end
})
local AntiLagSection = VisualsTab:CreateSection("Anti Lag",48,true) -- Name, DropdownSizeY, Opened
VisualsTab:CreateButton({ -- DONE
	Name = "Remove Map Lag";
	RichText = false; -- Enables RichText for the Name
	SectionParent = AntiLagSection; -- The SectionTab the element is parented to
	Callback = function() -- The function that is called after button is activated
		if not AntiLag then
			AntiLag = true
			-- Change Terrain
			local Terrain = workspace.Terrain
			Terrain.WaterWaveSize = 0
			Terrain.WaterWaveSpeed = 0
			Terrain.WaterReflectance = 0
			Terrain.WaterTransparency = 0
			-- Change Lighting
			local Lighting = game.Lighting
			Lighting.GlobalShadows = false
			Lighting.FogEnd = 9000000000
			-- Change Graphics Level
			settings().Rendering.QualityLevel = 1
			-- Remove Effects
			for i, v in Lighting:GetChildren() do
				if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") then
					v:Destroy()
				end
			end
			-- Remove Lag From Objects
			for i, v in workspace:GetDescendants() do
				RemoveLagFromObject(v)
			end
		end
	end
})
VisualsTab:CreateToggle({ -- DONE
	Name = "Remove Weapon Lag";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = AntiLagSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "RemoveWeaponLag"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
	end
})
VisualsTab:CreateToggle({ -- DONE
	Name = "Remove Pet Lag";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = AntiLagSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "RemovePetLag"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed=
	end
})
VisualsTab:CreateToggle({ -- DONE
	Name = "Remove Coin Lag";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = AntiLagSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "RemoveCoinLag"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
	end
})
local RenderSection = VisualsTab:CreateSection("Render",48,true) -- Name, DropdownSizeY, Opened
VisualsTab:CreateToggle({ -- DONE
	Name = "X-Ray";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = RenderSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "XRay"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
		if value then
			for i, v in workspace:GetDescendants() do
				XRayPart(v)
			end
		else
			UnXRayParts()
		end
	end
})
MiscellaneousTab:CreateSlider({ -- DONE
	Name = "Camera FOV";
	RichText = false; -- Enables RichText for the Name
	ScrollBarRichText = false; -- Enables RichText for the Value Display
	SliderColor = Color3.fromRGB(255, 231, 112); -- Color of the slider bar
	BlendColors = false; -- Blends MinColor & MaxColor depending on CurrentValue
	MinColor = Color3.fromRGB(255, 112, 112); -- Color of the slider bar at minimum value
	MaxColor = Color3.fromRGB(255, 231, 112); -- Color of the slider bar at maximum value
	SectionParent = RenderSection; -- The SectionTab the button is parented to
	MinValue = 1; -- Minimum value of the slider
	MaxValue = 120; -- Maximum value of the slider
	CurrentValue = 69+1; -- The current value of the slider
	Increment = 1; -- The amount the value increases by when sliding. Increment cannot be 0 or negative
	FormatString = "%d"; -- "%d" represents the CurrentValue
	CallbackOnRelease = false; -- Callback only when mouse is released
	Flag = "CameraFOV"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after slider is changed
		Camera.FieldOfView = value
	end
})
VisualsTab:CreateToggle({
	Name = "Freecam";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = RenderSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "Freecam"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
	end
})
VisualsTab:CreateToggle({ -- DONE
	Name = "Full Bright";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = RenderSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "FullBright"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
	end
})
VisualsTab:CreateButton({ -- DONE
	Name = "RTX Shaders";
	RichText = false; -- Enables RichText for the Name
	SectionParent = RenderSection; -- The SectionTab the element is parented to
	Callback = function() -- The function that is called after button is activated
		if RTXShadersAlreadyExecuted then return end
		RTXShadersAlreadyExecuted = true
		Library:Notify({
			Type = "info"; -- (Required) id0x1 = Error, id0x2 = Info, id0x3 = Success, set to nil for normal notification
			Title = "Info";
			Message = "Made by @Im_Patrick On YouTube"; -- (Required)
			Duration = 5; -- (Required)
			Actions = {}
		})
		loadstring(game:HttpGet('https://pastefy.app/xXkUxA0P/raw',true))()
	end
})
local InterfaceSection = VisualsTab:CreateSection("Interface",48,true) -- Name, DropdownSizeY, Opened
VisualsTab:CreateToggle({ -- DONE
	Name = "Hide Item Claim GUI";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = InterfaceSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "HideItemClaimGUI"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
	end
})
---------------------------------------------------------------------------
-- Miscellaneous
local FakeLagSection = MiscellaneousTab:CreateSection("Fake Lag",108,true) -- Name, DropdownSizeY, Opened
MiscellaneousTab:CreateToggle({
	Name = "Fake Lag";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = FakeLagSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "FakeLag"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
		print("Toggle set to "..tostring(value))
	end
})
MiscellaneousTab:CreateSlider({
	Name = "Delta Time";
	RichText = false; -- Enables RichText for the Name
	ScrollBarRichText = false; -- Enables RichText for the Value Display
	SliderColor = Color3.fromRGB(255, 231, 112); -- Color of the slider bar
	BlendColors = false; -- Blends MinColor & MaxColor depending on CurrentValue
	MinColor = Color3.fromRGB(255, 112, 112); -- Color of the slider bar at minimum value
	MaxColor = Color3.fromRGB(255, 231, 112); -- Color of the slider bar at maximum value
	SectionParent = FakeLagSection; -- The SectionTab the button is parented to
	MinValue = 0; -- Minimum value of the slider
	MaxValue = 10; -- Maximum value of the slider
	CurrentValue = 1; -- The current value of the slider
	Increment = 0.1; -- The amount the value increases by when sliding. Increment cannot be 0 or negative
	FormatString = "%d"; -- "%d" represents the CurrentValue
	CallbackOnRelease = true; -- Callback only when mouse is released
	Flag = "FakeLagDeltaTime"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after slider is changed
		print("Slider set to "..tostring(value))
	end
})
MiscellaneousTab:CreateSlider({
	Name = "DeltaTime Randomness";
	RichText = false; -- Enables RichText for the Name
	ScrollBarRichText = false; -- Enables RichText for the Value Display
	SliderColor = Color3.fromRGB(255, 231, 112); -- Color of the slider bar
	BlendColors = false; -- Blends MinColor & MaxColor depending on CurrentValue
	MinColor = Color3.fromRGB(255, 112, 112); -- Color of the slider bar at minimum value
	MaxColor = Color3.fromRGB(255, 231, 112); -- Color of the slider bar at maximum value
	SectionParent = FakeLagSection; -- The SectionTab the button is parented to
	MinValue = 0; -- Minimum value of the slider
	MaxValue = 100; -- Maximum value of the slider
	CurrentValue = 0; -- The current value of the slider
	Increment = 1; -- The amount the value increases by when sliding. Increment cannot be 0 or negative
	FormatString = "%d"; -- "%d" represents the CurrentValue
	CallbackOnRelease = true; -- Callback only when mouse is released
	Flag = "FakeLagDeltaTimeRandomness"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after slider is changed
		print("Slider set to "..tostring(value))
	end
})
MiscellaneousTab:CreateSlider({
	Name = "Threshold";
	RichText = false; -- Enables RichText for the Name
	ScrollBarRichText = false; -- Enables RichText for the Value Display
	SliderColor = Color3.fromRGB(255, 231, 112); -- Color of the slider bar
	BlendColors = false; -- Blends MinColor & MaxColor depending on CurrentValue
	MinColor = Color3.fromRGB(255, 112, 112); -- Color of the slider bar at minimum value
	MaxColor = Color3.fromRGB(255, 231, 112); -- Color of the slider bar at maximum value
	SectionParent = FakeLagSection; -- The SectionTab the button is parented to
	MinValue = 0; -- Minimum value of the slider
	MaxValue = 3; -- Maximum value of the slider
	CurrentValue = 1; -- The current value of the slider
	Increment = 0.1; -- The amount the value increases by when sliding. Increment cannot be 0 or negative
	FormatString = "%d"; -- "%d" represents the CurrentValue
	CallbackOnRelease = true; -- Callback only when mouse is released
	Flag = "FakeLagThreshold"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after slider is changed
		print("Slider set to "..tostring(value))
	end
})
MiscellaneousTab:CreateSlider({
	Name = "Threshold Randomness";
	RichText = false; -- Enables RichText for the Name
	ScrollBarRichText = false; -- Enables RichText for the Value Display
	SliderColor = Color3.fromRGB(255, 231, 112); -- Color of the slider bar
	BlendColors = false; -- Blends MinColor & MaxColor depending on CurrentValue
	MinColor = Color3.fromRGB(255, 112, 112); -- Color of the slider bar at minimum value
	MaxColor = Color3.fromRGB(255, 231, 112); -- Color of the slider bar at maximum value
	SectionParent = FakeLagSection; -- The SectionTab the button is parented to
	MinValue = 0; -- Minimum value of the slider
	MaxValue = 100; -- Maximum value of the slider
	CurrentValue = 0; -- The current value of the slider
	Increment = 1; -- The amount the value increases by when sliding. Increment cannot be 0 or negative
	FormatString = "%d"; -- "%d" represents the CurrentValue
	CallbackOnRelease = true; -- Callback only when mouse is released
	Flag = "FakeLagThresholdRandomness"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after slider is changed
		print("Slider set to "..tostring(value))
	end
})
local FreeEmotesSection = MiscellaneousTab:CreateSection("Free Emotes",84,true) -- Name, DropdownSizeY, Opened
MiscellaneousTab:CreateButton({ -- DONE
	Name = "Sit";
	RichText = false; -- Enables RichText for the Name
	SectionParent = FreeEmotesSection; -- The SectionTab the element is parented to
	Callback = function() -- The function that is called after button is activated
		PlayEmoteBindable:Fire("sit")
	end
})
MiscellaneousTab:CreateButton({ -- DONE
	Name = "Zombie";
	RichText = false; -- Enables RichText for the Name
	SectionParent = FreeEmotesSection; -- The SectionTab the element is parented to
	Callback = function() -- The function that is called after button is activated
		PlayEmoteBindable:Fire("zombie")
	end
})
MiscellaneousTab:CreateButton({ -- DONE
	Name = "Dab";
	RichText = false; -- Enables RichText for the Name
	SectionParent = FreeEmotesSection; -- The SectionTab the element is parented to
	Callback = function() -- The function that is called after button is activated
		PlayEmoteBindable:Fire("dab")
	end
})
MiscellaneousTab:CreateButton({ -- DONE
	Name = "Floss";
	RichText = false; -- Enables RichText for the Name
	SectionParent = FreeEmotesSection; -- The SectionTab the element is parented to
	Callback = function() -- The function that is called after button is activated
		PlayEmoteBindable:Fire("floss")
	end
})
MiscellaneousTab:CreateButton({ -- DONE
	Name = "Zen";
	RichText = false; -- Enables RichText for the Name
	SectionParent = FreeEmotesSection; -- The SectionTab the element is parented to
	Callback = function() -- The function that is called after button is activated
		PlayEmoteBindable:Fire("zen")
	end
})
MiscellaneousTab:CreateButton({ -- DONE
	Name = "Ninja";
	RichText = false; -- Enables RichText for the Name
	SectionParent = FreeEmotesSection; -- The SectionTab the element is parented to
	Callback = function() -- The function that is called after button is activated
		PlayEmoteBindable:Fire("ninja")
	end
})
MiscellaneousTab:CreateButton({ -- DONE
	Name = "Headless";
	RichText = false; -- Enables RichText for the Name
	SectionParent = FreeEmotesSection; -- The SectionTab the element is parented to
	Callback = function() -- The function that is called after button is activated
		PlayEmoteBindable:Fire("headless")
	end
})
MiscellaneousTab:CreateToggle({ -- DONE
	Name = "Breakdance";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = FreeEmotesSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "EmoteBreakdance"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
	end
})
local GameSection = MiscellaneousTab:CreateSection("Game",120,true) -- Name, DropdownSizeY, Opened
Window:AddElementTip(MiscellaneousTab:CreateToggle({ -- DONE
	Name = "Insta Role Notify";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = GameSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "InstaRoleNotify"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
	end
}),"Notifies your role before round begins",5)
Window:AddElementTip(MiscellaneousTab:CreateButton({ -- DONE
	Name = "Notify Roles";
	RichText = false; -- Enables RichText for the Name
	SectionParent = GameSection; -- The SectionTab the element is parented to
	Callback = function() -- The function that is called after button is activated
		NotifyRoles()
	end
}),"Notifies you player's roles (on client)",5)
MiscellaneousTab:CreateToggle({ -- DONE
	Name = "Auto Notify Roles";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = GameSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "AutoNotifyRoles"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
	end
})
Window:AddElementTip(MiscellaneousTab:CreateButton({ -- DONE
	Name = "Announce Roles";
	RichText = false; -- Enables RichText for the Name
	SectionParent = GameSection; -- The SectionTab the element is parented to
	Callback = function() -- The function that is called after button is activated
		AnnounceRoles()
	end
}),"Notifies player's roles (in chat)",5)
MiscellaneousTab:CreateToggle({ -- DONE
	Name = "Auto Announce Roles";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = GameSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "AutoAnnounceRoles"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
	end
})
MiscellaneousTab:CreateToggle({ -- UNDER MAINTENANCE
	Name = "Show Game Status";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = GameSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "ShowGameStatus"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
	end
})
MainTab:CreateToggle({
	Name = "See Dead Chat";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = GameSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "SeeDeadChat"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
	end
})
MiscellaneousTab:CreateToggle({ -- DONE
	Name = "Notify Gun Drop";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = GameSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "NotifyGunDrop"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
	end
})
MiscellaneousTab:CreateToggle({ -- DONE
	Name = "Notify Gun Collected";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = GameSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "NotifyGunCollected"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
	end
})
MiscellaneousTab:CreateToggle({ -- DONE
	Name = "Auto Prestige";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = GameSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "AutoPrestige"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
	end
})
MiscellaneousTab:CreateToggle({
	Name = "Fake Haste Trail";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = GameSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "FakeHasteTrail"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
		print("Toggle set to "..tostring(value))
	end
})
Window:AddElementTip(MiscellaneousTab:CreateToggle({
	Name = "Loop Equip All Emotes";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = GameSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "LoopEquipAllEmotes"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
		print("Toggle set to "..tostring(value))
	end
}),"working but broken for other players.",5)
MiscellaneousTab:CreateToggle({ -- DONE
	Name = "Spam Switch Inventory";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = GameSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "SpamSwitchInventory"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
		if SpamSwitchInventoryLoop then
			SpamSwitchInventoryLoop:Disconnect()
		end
		if value then
			local inventory = GetFullInventoryRemote:InvokeServer(LocalPlayer.Name)
			local owneditems = inventory.Weapons.Owned
			local itemstoequip = {}
			for item in owneditems do
				table.insert(itemstoequip,item)
			end
			print(table.unpack(itemstoequip))
			local spawn = tick()
			SpamSwitchInventoryLoop = RS.RenderStepped:Connect(function()
				if spawn + 0.2 < tick() then
					EquipItemEvent:FireServer(itemstoequip[math.random(1,#itemstoequip)],"Weapons")
					spawn = tick()
				end
			end)
		end
	end
})
MiscellaneousTab:CreateToggle({ -- DONE
	Name = "Spam Switch Pets";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = GameSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "SpamSwitchPets"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
	end
})
MiscellaneousTab:CreateToggle({ -- DONE
	Name = "Spam Switch Radios";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = GameSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "SpamSwitchRadios"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
	end
})
Window:AddElementTip(MiscellaneousTab:CreateButton({ -- DONE
	Name = "Get 13 Max Players";
	RichText = false; -- Enables RichText for the Name
	SectionParent = GameSection; -- The SectionTab the element is parented to
	Callback = function() -- The function that is called after button is activated
		if game.PlaceId == SupportedGames.Classic or game.PlaceId == SupportedGames.Assassin or game.PlaceId == SupportedGames.Disguised then
			Library:Notify({
				Type = "info"; -- (Required) id0x1 = Error, id0x2 = Info, id0x3 = Success, set to nil for normal notification
				Title = "Info";
				Message = "Are you sure? This will make you rejoin and lose all progress."; -- (Required)
				Duration = 5; -- (Required)
				Actions = {
					Yes = {
						Name = "Yes",
						CloseOnClick = true;
						Callback = function()
							if #Players:GetChildren() == 12 then
								Rejoin()
							else
								Library:Notify({
									Type = "error"; -- (Required) id0x1 = Error, id0x2 = Info, id0x3 = Success, set to nil for normal notification
									Title = "Error";
									Message = "There Must Be At Least 12 Players";
									Duration = 5;
								})
							end
						end
					};
					No = {
						Name = "No",
						CloseOnClick = true;
						Callback = function()
						end
					}
				}
			})
		end
	end
}),"There Must Be At Least 12 Players",5) -- Shows a tip under your mouse cursor (ElementName,Tip,Duration)
GrabGunButton = MiscellaneousTab:CreateButton({
	Name = "Grab Gun";
	RichText = false; -- Enables RichText for the Name
	SectionParent = GameSection; -- The SectionTab the element is parented to
	Callback = function() -- The function that is called after button is activated
		GrabGun()
	end
})
AutoGrabGunToggle = MiscellaneousTab:CreateToggle({
	Name = "Auto Grab Gun";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = GameSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "AutoGrabGun"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
	end
})
Window:AddElementTip(MiscellaneousTab:CreateToggle({
	Name = "Safe Mode";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = GameSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "GrabGunSafeMode"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
		print("Toggle set to "..tostring(value))
	end
}),"Doesn't grab gun when Murderer is in range")
StealGunButton = MiscellaneousTab:CreateButton({ -- UNDER MAINTENANCE
	Name = "Steal Gun";
	RichText = false; -- Enables RichText for the Name
	SectionParent = GameSection; -- The SectionTab the element is parented to
	Callback = function() -- The function that is called after button is activated
		StealGun()
	end
})
Window:AddElementTip(StealGunButton,"Kills the sheriff as innocent and auto-grabs gun (unreliable)",5) -- Shows a tip under your mouse cursor (ElementName,Tip,Duration)
AutoStealGunToggle = MiscellaneousTab:CreateToggle({ -- UNDER MAINTENANCE
	Name = "Auto Steal Gun";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = GameSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "AutoStealGun"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
		if value then
			Window:DeactivateElement(GrabGunButton) -- Makes the element uninteractable
			Window:DeactivateElement(AutoGrabGunToggle) -- Makes the element uninteractable
			Window:DeactivateElement(FlingSheriffButton) -- Makes the element uninteractable
			Window:DeactivateElement(AutoFlingSheriffToggle) -- Makes the element uninteractable
			AutoGrabGunToggle.CurrentValue = false
			AutoFlingSheriffToggle.CurrentValue = false
		else
			Window:ActivateElement(GrabGunButton) -- Makes the element clickable
			Window:ActivateElement(AutoGrabGunToggle) -- Makes the element clickable
			Window:ActivateElement(FlingSheriffButton) -- Makes the element clickable
			Window:ActivateElement(AutoFlingSheriffToggle) -- Makes the element clickable
		end
	end
})
Window:AddElementTip(MiscellaneousTab:CreateButton({ -- UNDER TESTING
	Name = "Shoot Murderer";
	RichText = false; -- Enables RichText for the Name
	SectionParent = GameSection; -- The SectionTab the element is parented to
	Callback = function() -- The function that is called after button is activated
		ShootMurderer()
	end
}),"Teleports to murderer and shoots them.",5) -- Shows a tip under your mouse cursor (ElementName,Tip,Duration)
AutoShootMurdererToggle = MiscellaneousTab:CreateToggle({ -- UNDER TESTING
	Name = "Auto Shoot Murderer";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = GameSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "AutoShootMurderer"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
	end
})
MiscellaneousTab:CreateButton({
	Name = "Fling Murderer";
	RichText = false; -- Enables RichText for the Name
	SectionParent = GameSection; -- The SectionTab the element is parented to
	Callback = function() -- The function that is called after button is activated
		print("Button Clicked!")
	end
})
MiscellaneousTab:CreateToggle({
	Name = "Auto Fling Murderer";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = GameSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "AutoFlingMurderer"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
		print("Toggle set to "..tostring(value))
	end
})
Window:AddElementTip(MiscellaneousTab:CreateButton({
	Name = "Kill Sheriff";
	RichText = false; -- Enables RichText for the Name
	SectionParent = GameSection; -- The SectionTab the element is parented to
	Callback = function() -- The function that is called after button is activated
		print("Button Clicked!")
	end
}),"Melee kills the sheriff. (knife is required)",5) -- Shows a tip under your mouse cursor (ElementName,Tip,Duration)
MiscellaneousTab:CreateToggle({
	Name = "Auto Kill Sheriff";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = GameSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "AutoKillSheriff"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
		print("Toggle set to "..tostring(value))
	end
})
FlingSheriffButton = MiscellaneousTab:CreateButton({
	Name = "Fling Sheriff";
	RichText = false; -- Enables RichText for the Name
	SectionParent = GameSection; -- The SectionTab the element is parented to
	Callback = function() -- The function that is called after button is activated
		print("Button Clicked!")
	end
})
AutoFlingSheriffToggle = MiscellaneousTab:CreateToggle({
	Name = "Auto Fling Sheriff";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = GameSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "AutoFlingSheriff"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
		print("Toggle set to "..tostring(value))
	end
})
MiscellaneousTab:CreateSeparator("Voting System",GameSection) -- Text, SectionParent
VotepadIndexDropdown = MiscellaneousTab:CreateDropdown({
	Name = "Votepad Index";
	RichText = false; -- Enables RichText for the Name
	Options = {1,2,3};
	CurrentOption = {2};
	SelectedColor = Color3.fromRGB(121, 152, 255); -- Color of the slider bar
	MinOptions = 1; -- Minimum amount of options the user can select
	MaxOptions = 1; -- Maximum amount of options the user can select
	CallbackOnSelect = true; -- Callback anytime an option is selected
	SectionParent = GameSection; -- The SectionTab the element is parented to
	Flag = "VotepadIndex"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = {}; -- The properties the flag will blacklist/not saved
	Callback = function(options) -- options will always return a table
		print("Options Selected:",table.unpack(options))
	end
})
MiscellaneousTab:CreateToggle({ -- TP Select a map, reset character and TP Select again.
	Name = "Infinite Vote Map";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = GameSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "InfiniteVoteMap"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
	end
})
MiscellaneousTab:CreateButton({
	Name = "Break Voting Pads";
	RichText = false; -- Enables RichText for the Name
	SectionParent = GameSection; -- The SectionTab the element is parented to
	Callback = function() -- The function that is called after button is activated
	end
})
MiscellaneousTab:CreateSeparator("Fling",GameSection) -- Text, SectionParent
FlingPlayerDropdown = MiscellaneousTab:CreateDropdown({
	Name = "Fling Target";
	RichText = false; -- Enables RichText for the Name
	Options = {};
	CurrentOption = {};
	SelectedColor = Color3.fromRGB(121, 152, 255); -- Color of the slider bar
	MinOptions = 0; -- Minimum amount of options the user can select
	MaxOptions = math.huge; -- Maximum amount of options the user can select
	CallbackOnSelect = true; -- Callback anytime an option is selected
	SectionParent = GameSection; -- The SectionTab the element is parented to
	Flag = ""; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = {}; -- The properties the flag will blacklist/not saved
	Callback = function(options) -- options will always return a table
		print("Options Selected:",table.unpack(options))
	end
})
MiscellaneousTab:CreateButton({
	Name = "Fling Target";
	RichText = false; -- Enables RichText for the Name
	SectionParent = GameSection; -- The SectionTab the element is parented to
	Callback = function() -- The function that is called after button is activated
		print("Button Clicked!")
	end
})
MiscellaneousTab:CreateSlider({
	Name = "Fling Intensity";
	RichText = false; -- Enables RichText for the Name
	ScrollBarRichText = false; -- Enables RichText for the Value Display
	SliderColor = Color3.fromRGB(255, 231, 112); -- Color of the slider bar
	BlendColors = true; -- Blends MinColor & MaxColor depending on CurrentValue
	MinColor = Color3.fromRGB(255, 112, 112); -- Color of the slider bar at minimum value
	MaxColor = Color3.fromRGB(255, 231, 112); -- Color of the slider bar at maximum value
	SectionParent = GameSection; -- The SectionTab the button is parented to
	MinValue = 0; -- Minimum value of the slider
	MaxValue = 1000000; -- Maximum value of the slider
	CurrentValue = 1000000; -- The current value of the slider
	Increment = 1; -- The amount the value increases by when sliding. Increment cannot be 0 or negative
	FormatString = "%d"; -- "%d" represents the CurrentValue
	CallbackOnRelease = true; -- Callback only when mouse is released
	Flag = "FlingIntensity"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after slider is changed
		print("Slider set to "..tostring(value))
	end
})
MiscellaneousTab:CreateButton({
	Name = "Fling All";
	RichText = false; -- Enables RichText for the Name
	SectionParent = GameSection; -- The SectionTab the element is parented to
	Callback = function() -- The function that is called after button is activated
	end
})
Window:AddElementTip(MiscellaneousTab:CreateToggle({
	Name = "Loop Fling All";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = GameSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "LoopFlingAll"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
		print("Toggle set to "..tostring(value))
	end
}),"Very annoying!",5) -- Shows a tip under your mouse cursor (ElementName,Tip,Duration)
MiscellaneousTab:CreateToggle({
	Name = "Dead Check";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = GameSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "Dead Check"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
		print("Toggle set to "..tostring(value))
	end
})
MiscellaneousTab:CreateSlider({
	Name = "Stop Flinging";
	RichText = false; -- Enables RichText for the Name
	ScrollBarRichText = false; -- Enables RichText for the Value Display
	SliderColor = Color3.fromRGB(255, 231, 112); -- Color of the slider bar
	BlendColors = false; -- Blends MinColor & MaxColor depending on CurrentValue
	MinColor = Color3.fromRGB(255, 112, 112); -- Color of the slider bar at minimum value
	MaxColor = Color3.fromRGB(255, 231, 112); -- Color of the slider bar at maximum value
	SectionParent = GameSection; -- The SectionTab the button is parented to
	MinValue = 0; -- Minimum value of the slider
	MaxValue = 10; -- Maximum value of the slider
	CurrentValue = 0; -- The current value of the slider
	Increment = 0.1; -- The amount the value increases by when sliding. Increment cannot be 0 or negative
	FormatString = "%ds"; -- "%d" represents the CurrentValue
	CallbackOnRelease = true; -- Callback only when mouse is released
	Flag = "AutoToxicMessageSendDelay"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after slider is changed
		print("Slider set to "..tostring(value))
	end
})
MiscellaneousTab:CreateSeparator("Kill",GameSection) -- Text, SectionParent
KillPlayerDropdown = MiscellaneousTab:CreateDropdown({
	Name = "Kill Target";
	RichText = false; -- Enables RichText for the Name
	Options = {};
	CurrentOption = {};
	SelectedColor = Color3.fromRGB(121, 152, 255); -- Color of the slider bar
	MinOptions = 0; -- Minimum amount of options the user can select
	MaxOptions = math.huge; -- Maximum amount of options the user can select
	CallbackOnSelect = true; -- Callback anytime an option is selected
	SectionParent = GameSection; -- The SectionTab the element is parented to
	Flag = ""; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = {}; -- The properties the flag will blacklist/not saved
	Callback = function(options) -- options will always return a table
		print("Options Selected:",table.unpack(options))
	end
})
Window:AddElementTip(MiscellaneousTab:CreateButton({
	Name = "Kill Target";
	RichText = false; -- Enables RichText for the Name
	SectionParent = GameSection; -- The SectionTab the element is parented to
	Callback = function() -- The function that is called after button is activated
		print("Button Clicked!")
	end
}),"You need a knife tool for this",5) -- Shows a tip under your mouse cursor (ElementName,Tip,Duration)
Window:AddElementTip(MiscellaneousTab:CreateButton({
	Name = "Kill All";
	RichText = false; -- Enables RichText for the Name
	SectionParent = GameSection; -- The SectionTab the element is parented to
	Callback = function() -- The function that is called after button is activated
		print("Button Clicked!")
	end
}),"You need a knife tool for this",5) -- Shows a tip under your mouse cursor (ElementName,Tip,Duration)
MiscellaneousTab:CreateToggle({
	Name = "Auto Kill All";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = GameSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "AutoKillAll"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
		print("Toggle set to "..tostring(value))
	end
})
local TeleportSection = MiscellaneousTab:CreateSection("Teleports",120,true) -- Name, DropdownSizeY, Opened
MiscellaneousTab:CreateSeparator("Players",TeleportSection) -- Text, SectionParent
MiscellaneousTab:CreateButton({
	Name = "Teleport To Murderer";
	RichText = false; -- Enables RichText for the Name
	SectionParent = TeleportSection; -- The SectionTab the element is parented to
	Callback = function() -- The function that is called after button is activated
		print("Button Clicked!")
	end
})
MiscellaneousTab:CreateButton({
	Name = "Teleport To Sheriff";
	RichText = false; -- Enables RichText for the Name
	SectionParent = TeleportSection; -- The SectionTab the element is parented to
	Callback = function() -- The function that is called after button is activated
		print("Button Clicked!")
	end
})
MiscellaneousTab:CreateButton({
	Name = "Teleport To Random";
	RichText = false; -- Enables RichText for the Name
	SectionParent = TeleportSection; -- The SectionTab the element is parented to
	Callback = function() -- The function that is called after button is activated
		print("Button Clicked!")
	end
})
PlayerTeleportDropdown = MiscellaneousTab:CreateDropdown({
	Name = "Teleport To Player";
	RichText = false; -- Enables RichText for the Name
	Options = {};
	CurrentOption = {};
	SelectedColor = Color3.fromRGB(121, 152, 255); -- Color of the slider bar
	MinOptions = 0; -- Minimum amount of options the user can select
	MaxOptions = 1; -- Maximum amount of options the user can select
	CallbackOnSelect = true; -- Callback anytime an option is selected
	SectionParent = TeleportSection; -- The SectionTab the element is parented to
	Flag = ""; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(options) -- options will always return a table
	end
})
MiscellaneousTab:CreateButton({
	Name = "Teleport To Player";
	RichText = false; -- Enables RichText for the Name
	SectionParent = TeleportSection; -- The SectionTab the element is parented to
	Callback = function() -- The function that is called after button is activated
		print("Button Clicked!")
	end
})
MiscellaneousTab:CreateSeparator("World",TeleportSection) -- Text, SectionParent
MiscellaneousTab:CreateButton({ -- UNDER TESTING
	Name = "Teleport To Voting Area";
	RichText = false; -- Enables RichText for the Name
	SectionParent = TeleportSection; -- The SectionTab the element is parented to
	Callback = function() -- The function that is called after button is activated
		TeleportToVotingArea()
	end
})
MiscellaneousTab:CreateButton({ -- UNDER TESTING
	Name = "Teleport To Lobby";
	RichText = false; -- Enables RichText for the Name
	SectionParent = TeleportSection; -- The SectionTab the element is parented to
	Callback = function() -- The function that is called after button is activated
		TeleportToLobby()
	end
})
MiscellaneousTab:CreateButton({ -- UNDER MAINTENANCE
	Name = "Teleport Above Lobby";
	RichText = false; -- Enables RichText for the Name
	SectionParent = TeleportSection; -- The SectionTab the element is parented to
	Callback = function() -- The function that is called after button is activated
		TeleportAboveLobby()
	end
})
MiscellaneousTab:CreateButton({ -- UNDER TESTING
	Name = "Teleport To Map";
	RichText = false; -- Enables RichText for the Name
	SectionParent = TeleportSection; -- The SectionTab the element is parented to
	Callback = function() -- The function that is called after button is activated
		TeleportToMap()
	end
})
MiscellaneousTab:CreateButton({ -- UNDER MAINTENANCE
	Name = "Teleport Above Map";
	RichText = false; -- Enables RichText for the Name
	SectionParent = TeleportSection; -- The SectionTab the element is parented to
	Callback = function() -- The function that is called after button is activated
		TeleportAboveMap()
	end
})
MiscellaneousTab:CreateButton({ -- UNDER TESTING
	Name = "Teleport To Safe Zone";
	RichText = false; -- Enables RichText for the Name
	SectionParent = TeleportSection; -- The SectionTab the element is parented to
	Callback = function() -- The function that is called after button is activated
		LPlrHrp.CFrame = CFrame.new(SafeZonePosition)
	end
})
MiscellaneousTab:CreateButton({ -- UNDER MAINTENANCE
	Name = "Remove Glitch Proof Barriers";
	RichText = false; -- Enables RichText for the Name
	SectionParent = TeleportSection; -- The SectionTab the element is parented to
	Callback = function() -- The function that is called after button is activated
	end
})
local ChatTrollSection = MiscellaneousTab:CreateSection("Chat Troll",120,true) -- Name, DropdownSizeY, Opened
MiscellaneousTab:CreateSeparator("Auto Spam",ChatTrollSection) -- Text, SectionParent
Window:AddElementTip(MiscellaneousTab:CreateToggle({
	Name = "Chat Spam";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = ChatTrollSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "Chat Spam"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
		print("Toggle set to "..tostring(value))
	end
}),"Yes, this is also bannable.",5) -- Shows a tip under your mouse cursor (ElementName,Tip,Duration)
Window:AddElementTip(MiscellaneousTab:CreateInput({
	Name = "Message";
	PlaceholderText = "Type anything here!";
	NumbersOnly = false;
	RichText = false; -- Enables RichText for the Name
	CharacterLimit = 200;
	ClearTextOnFocus = false;
	SectionParent = ChatTrollSection; -- The SectionTab the button is parented to
	CurrentValue = "Murder Mystery Main on top! 🔥🙏"; -- The text of the textbox
	Flag = "ChatSpamMessage"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
		print("Input: "..tostring(value))
	end
}),"Sends a message prompt when you kill somebody (with a knife)",5) -- Shows a tip under your mouse cursor (ElementName,Tip,Duration)
MiscellaneousTab:CreateSlider({
	Name = "Message Send Delay";
	RichText = false; -- Enables RichText for the Name
	ScrollBarRichText = false; -- Enables RichText for the Value Display
	SliderColor = Color3.fromRGB(255, 231, 112); -- Color of the slider bar
	BlendColors = false; -- Blends MinColor & MaxColor depending on CurrentValue
	MinColor = Color3.fromRGB(255, 112, 112); -- Color of the slider bar at minimum value
	MaxColor = Color3.fromRGB(255, 231, 112); -- Color of the slider bar at maximum value
	SectionParent = ChatTrollSection; -- The SectionTab the button is parented to
	MinValue = 0; -- Minimum value of the slider
	MaxValue = 10; -- Maximum value of the slider
	CurrentValue = 1; -- The current value of the slider
	Increment = 0.1; -- The amount the value increases by when sliding. Increment cannot be 0 or negative
	FormatString = "%ds"; -- "%d" represents the CurrentValue
	CallbackOnRelease = true; -- Callback only when mouse is released
	Flag = "ChatSpamMessageSendDelay"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after slider is changed
		print("Slider set to "..tostring(value))
	end
})
MiscellaneousTab:CreateSeparator("Auto Toxic",ChatTrollSection) -- Text, SectionParent
MiscellaneousTab:CreateParagraph("Chat Troll Format","%s = player",ChatTrollSection) -- Title, Content, SectionParent
Window:AddElementTip(MiscellaneousTab:CreateToggle({
	Name = "Auto Toxic";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = ChatTrollSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "AutoToxic"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
		print("Toggle set to "..tostring(value))
	end
}),"WARNING! Bannable. Use at your own risk!",5) -- Shows a tip under your mouse cursor (ElementName,Tip,Duration)
MiscellaneousTab:CreateSlider({
	Name = "Message Send Delay";
	RichText = false; -- Enables RichText for the Name
	ScrollBarRichText = false; -- Enables RichText for the Value Display
	SliderColor = Color3.fromRGB(255, 231, 112); -- Color of the slider bar
	BlendColors = false; -- Blends MinColor & MaxColor depending on CurrentValue
	MinColor = Color3.fromRGB(255, 112, 112); -- Color of the slider bar at minimum value
	MaxColor = Color3.fromRGB(255, 231, 112); -- Color of the slider bar at maximum value
	SectionParent = ChatTrollSection; -- The SectionTab the button is parented to
	MinValue = 0; -- Minimum value of the slider
	MaxValue = 10; -- Maximum value of the slider
	CurrentValue = 0; -- The current value of the slider
	Increment = 0.1; -- The amount the value increases by when sliding. Increment cannot be 0 or negative
	FormatString = "%ds"; -- "%d" represents the CurrentValue
	CallbackOnRelease = true; -- Callback only when mouse is released
	Flag = "AutoToxicMessageSendDelay"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after slider is changed
		print("Slider set to "..tostring(value))
	end
})
Window:AddElementTip(MiscellaneousTab:CreateToggle({
	Name = "Match Message Length";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = ChatTrollSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "AutoToxicMatchMessageLength"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
		print("Toggle set to "..tostring(value))
	end
}),"Delays The Message At The Average Typing Speed.",5) -- Shows a tip under your mouse cursor (ElementName,Tip,Duration)
Window:AddElementTip(MiscellaneousTab:CreateToggle({
	Name = "Custom GameModes";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = ChatTrollSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "AutoToxicCustomGameModes"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
		print("Toggle set to "..tostring(value))
	end
}),"Use auto-toxic in custom gamemodes.",5) -- Shows a tip under your mouse cursor (ElementName,Tip,Duration)
Window:AddElementTip(MiscellaneousTab:CreateInput({
	Name = "Kill Message";
	PlaceholderText = "Type anything here!";
	NumbersOnly = false;
	RichText = false; -- Enables RichText for the Name
	CharacterLimit = 200;
	ClearTextOnFocus = false;
	SectionParent = ChatTrollSection; -- The SectionTab the button is parented to
	CurrentValue = "L %s"; -- The text of the textbox
	Flag = "KillMessage"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
		print("Input: "..tostring(value))
	end
}),"Sends a message prompt when you kill somebody (with a knife)",5) -- Shows a tip under your mouse cursor (ElementName,Tip,Duration)
Window:AddElementTip(MiscellaneousTab:CreateInput({
	Name = "Shot Message";
	PlaceholderText = "Type anything here!";
	NumbersOnly = false;
	RichText = false; -- Enables RichText for the Name
	CharacterLimit = 200;
	ClearTextOnFocus = false;
	SectionParent = ChatTrollSection; -- The SectionTab the button is parented to
	CurrentValue = "ez snipe %s"; -- The text of the textbox
	Flag = "ShotMessage"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
		print("Input: "..tostring(value))
	end
}),"Sends a message prompt when you shoot somebody",5) -- Shows a tip under your mouse cursor (ElementName,Tip,Duration)
Window:AddElementTip(MiscellaneousTab:CreateInput({
	Name = "Victory Message";
	PlaceholderText = "Type anything here!";
	NumbersOnly = false;
	RichText = false; -- Enables RichText for the Name
	CharacterLimit = 200;
	ClearTextOnFocus = false;
	SectionParent = ChatTrollSection; -- The SectionTab the button is parented to
	CurrentValue = "imagine losing in a lego game. yall suck fr 💀"; -- The text of the textbox
	Flag = "VictoryMessage"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
		print("Input: "..tostring(value))
	end
}),"Sends a message prompt when you win the game (as murderer)",5) -- Shows a tip under your mouse cursor (ElementName,Tip,Duration)
Window:AddElementTip(MiscellaneousTab:CreateInput({
	Name = "Dead Message";
	PlaceholderText = "Type anything here!";
	NumbersOnly = false;
	RichText = false; -- Enables RichText for the Name
	CharacterLimit = 200;
	ClearTextOnFocus = false;
	SectionParent = ChatTrollSection; -- The SectionTab the button is parented to
	CurrentValue = "I would've won but my gaming chair expired mid round."; -- The text of the textbox
	Flag = "DeadMessage"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
		print("Input: "..tostring(value))
	end
}),"Sends a message prompt when you die",5) -- Shows a tip under your mouse cursor (ElementName,Tip,Duration)
Window:AddElementTip(MiscellaneousTab:CreateInput({
	Name = "Comeback Message";
	PlaceholderText = "Type anything here!";
	NumbersOnly = false;
	RichText = false; -- Enables RichText for the Name
	CharacterLimit = 200;
	ClearTextOnFocus = false;
	SectionParent = ChatTrollSection; -- The SectionTab the button is parented to
	CurrentValue = "ur just mad u ain't got my script. L %s"; -- The text of the textbox
	Flag = "ComebackMessage"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
		print("Input: "..tostring(value))
	end
}),"Sends a message prompt when someone either calls you a 'hacker', 'cheater', 'trash', 'bro needs hacks to win' etc..",5) -- Shows a tip under your mouse cursor (ElementName,Tip,Duration)
---------------------------------------------------------------------------
-- Economy
local AutoFarmSection = EconomyTab:CreateSection("Auto Farm",120,true) -- Name, DropdownSizeY, Opened
Window:AddElementTip(EconomyTab:CreateToggle({
	Name = "Coin Farm";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = AutoFarmSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "CoinFarm"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
		print("Toggle set to "..tostring(value))
	end
}),"Please do use this on an alt.",5)
Window:AddElementTip(EconomyTab:CreateToggle({
	Name = "TP Farm";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = AutoFarmSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "AutoFarmTPFarm"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
	end
}),"Teleports to the nearest coin instead of gliding towards it")
EconomyTab:CreateToggle({
	Name = "XP Farm";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = AutoFarmSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "XPFarm"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
	end
})
Window:AddElementTip(EconomyTab:CreateToggle({
	Name = "Auto Farm God Mode";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = AutoFarmSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "AutoFarmGodMode"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
		print("Toggle set to "..tostring(value))
	end
}),"Prevents you from dying during autofarming",5)
EconomyTab:CreateToggle({
	Name = "Reset After Full Bag";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = AutoFarmSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "AutoFarmResetAfterFullBag"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
	end
})
EconomyTab:CreateToggle({
	Name = "Coin Aura";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = AutoFarmSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "CoinAura"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
		if value and not firetouchinterest then
			MM2MainErrorNotification("Your executor does not support this exploit (missing 'firetouchinterest')")
		end
	end
})
EconomyTab:CreateSeparator("Auto Farm Settings",AutoFarmSection) -- Text, SectionParent
EconomyTab:CreateDropdown({
	Name = "Autofarm Method";
	RichText = false; -- Enables RichText for the Name
	Options = {"Closest","Random","Priority"};
	CurrentOption = {"Closest"};
	MinOptions = 0; -- Minimum amount of options the user can select
	MaxOptions = 1; -- Maximum amount of options the user can select
	CallbackOnSelect = true; -- Callback anytime an option is selected
	SectionParent = AutoFarmSection; -- The SectionTab the element is parented to
	Flag = "AutoFarmMethod"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	Callback = function(options) -- options will always return a table
	end
})
EconomyTab:CreateSlider({
	Name = "Auto Farm Speed";
	RichText = false; -- Enables RichText for the Name
	ScrollBarRichText = false; -- Enables RichText for the Value Display
	SliderColor = Color3.fromRGB(255, 231, 112); -- Color of the slider bar
	BlendColors = false; -- Blends MinColor & MaxColor depending on CurrentValue
	MinColor = Color3.fromRGB(255, 112, 112); -- Color of the slider bar at minimum value
	MaxColor = Color3.fromRGB(255, 231, 112); -- Color of the slider bar at maximum value
	SectionParent = AutoFarmSection; -- The SectionTab the button is parented to
	MinValue = 0; -- Minimum value of the slider
	MaxValue = 10; -- Maximum value of the slider
	CurrentValue = 1; -- The current value of the slider
	Increment = 0.1; -- The amount the value increases by when sliding. Increment cannot be 0 or negative
	FormatString = "%ds"; -- "%d" represents the CurrentValue
	CallbackOnRelease = true; -- Callback only when mouse is released
	Flag = "AutoFarmSpeed"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after slider is changed
	end
})
EconomyTab:CreateSlider({
	Name = "Auto Farm Delay";
	RichText = false; -- Enables RichText for the Name
	ScrollBarRichText = false; -- Enables RichText for the Value Display
	SliderColor = Color3.fromRGB(255, 231, 112); -- Color of the slider bar
	BlendColors = false; -- Blends MinColor & MaxColor depending on CurrentValue
	MinColor = Color3.fromRGB(255, 112, 112); -- Color of the slider bar at minimum value
	MaxColor = Color3.fromRGB(255, 231, 112); -- Color of the slider bar at maximum value
	SectionParent = AutoFarmSection; -- The SectionTab the button is parented to
	MinValue = 0.5; -- Minimum value of the slider
	MaxValue = 10; -- Maximum value of the slider
	CurrentValue = 1; -- The current value of the slider
	Increment = 0.1; -- The amount the value increases by when sliding. Increment cannot be 0 or negative
	FormatString = "%ds"; -- "%d" represents the CurrentValue
	CallbackOnRelease = true; -- Callback only when mouse is released
	Flag = "AutoFarmDelay"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after slider is changed
		print("Slider set to "..tostring(value))
	end
})
EconomyTab:CreateSeparator("Anti AFK",AutoFarmSection) -- Text, SectionParent
EconomyTab:CreateButton({
	Name = "Anti AFK";
	RichText = false; -- Enables RichText for the Name
	SectionParent = AutoFarmSection; -- The SectionTab the element is parented to
	Callback = function() -- The function that is called after button is activated
		print("Button Clicked!")
	end
})
EconomyTab:CreateSeparator("Crates",AutoFarmSection) -- Text, SectionParent
EconomyTab:CreateToggle({
	Name = "Auto Unbox";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = AutoFarmSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "AutoUnbox"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
	end
})
EconomyTab:CreateDropdown({
	Name = "Unbox Crate";
	RichText = false; -- Enables RichText for the Name
	Options = {"Knife Box #1", "Knife Box #2"};
	CurrentOption = {"Knife Box #1"};
	SelectedColor = Color3.fromRGB(121, 152, 255); -- Color of the slider bar
	MinOptions = 0; -- Minimum amount of options the user can select
	MaxOptions = 1; -- Maximum amount of options the user can select
	CallbackOnSelect = true; -- Callback anytime an option is selected
	SectionParent = AutoFarmSection; -- The SectionTab the element is parented to
	Flag = "UnboxCrate"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(options) -- options will always return a table
	end
})
EconomyTab:CreateSeparator("Server Hop",AutoFarmSection) -- Text, SectionParent
EconomyTab:CreateButton({ -- DONE
	Name = "Server Hop";
	RichText = false; -- Enables RichText for the Name
	SectionParent = AutoFarmSection; -- The SectionTab the element is parented to
	Callback = function() -- The function that is called after button is activated
		if serverhopcooldownspawn + 5 < tick() then
			ServerHop()
		end
	end
})
EconomyTab:CreateToggle({
	Name = "Auto Server Hop";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = AutoFarmSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "AutoServerHop"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
		print("Toggle set to "..tostring(value))
	end
})
EconomyTab:CreateToggle({
	Name = "Server Hop After Game";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = AutoFarmSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "ServerHopAfterGame"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
		print("Toggle set to "..tostring(value))
	end
})
EconomyTab:CreateSlider({
	Name = "Server Hop Delay";
	RichText = false; -- Enables RichText for the Name
	ScrollBarRichText = false; -- Enables RichText for the Value Display
	SliderColor = Color3.fromRGB(255, 231, 112); -- Color of the slider bar
	BlendColors = false; -- Blends MinColor & MaxColor depending on CurrentValue
	MinColor = Color3.fromRGB(255, 112, 112); -- Color of the slider bar at minimum value
	MaxColor = Color3.fromRGB(255, 231, 112); -- Color of the slider bar at maximum value
	SectionParent = AutoFarmSection; -- The SectionTab the button is parented to
	MinValue = 0; -- Minimum value of the slider
	MaxValue = 360; -- Maximum value of the slider
	CurrentValue = 1; -- The current value of the slider
	Increment = 1; -- The amount the value increases by when sliding. Increment cannot be 0 or negative
	FormatString = "%dmins"; -- "%d" represents the CurrentValue
	CallbackOnRelease = true; -- Callback only when mouse is released
	Flag = "ServerHopDelay"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after slider is changed
		print("Slider set to "..tostring(value))
	end
})
EconomyTab:CreateToggle({
	Name = "Prioritize Server Ping";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = AutoFarmSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "PrioritizeServerPing"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
		print("Toggle set to "..tostring(value))
	end
})
EconomyTab:CreateSlider({
	Name = "Desired Ping";
	RichText = false; -- Enables RichText for the Name
	ScrollBarRichText = false; -- Enables RichText for the Value Display
	SliderColor = Color3.fromRGB(255, 231, 112); -- Color of the slider bar
	BlendColors = false; -- Blends MinColor & MaxColor depending on CurrentValue
	MinColor = Color3.fromRGB(255, 112, 112); -- Color of the slider bar at minimum value
	MaxColor = Color3.fromRGB(255, 231, 112); -- Color of the slider bar at maximum value
	SectionParent = AutoFarmSection; -- The SectionTab the button is parented to
	MinValue = 1; -- Minimum value of the slider
	MaxValue = 1000; -- Maximum value of the slider
	CurrentValue = 1; -- The current value of the slider
	Increment = 1; -- The amount the value increases by when sliding. Increment cannot be 0 or negative
	FormatString = "%dms"; -- "%d" represents the CurrentValue
	CallbackOnRelease = true; -- Callback only when mouse is released
	Flag = "DesiredPing"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after slider is changed
		print("Slider set to "..tostring(value))
	end
})
EconomyTab:CreateToggle({
	Name = "Auto Hop On Player Count";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = AutoFarmSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "AutoHopOnPlayerCount"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
		print("Toggle set to "..tostring(value))
	end
})
EconomyTab:CreateSlider({
	Name = "Minimum Player Count";
	RichText = false; -- Enables RichText for the Name
	ScrollBarRichText = false; -- Enables RichText for the Value Display
	SliderColor = Color3.fromRGB(255, 231, 112); -- Color of the slider bar
	BlendColors = false; -- Blends MinColor & MaxColor depending on CurrentValue
	MinColor = Color3.fromRGB(255, 112, 112); -- Color of the slider bar at minimum value
	MaxColor = Color3.fromRGB(255, 231, 112); -- Color of the slider bar at maximum value
	SectionParent = AutoFarmSection; -- The SectionTab the button is parented to
	MinValue = 1; -- Minimum value of the slider
	MaxValue = 12; -- Maximum value of the slider
	CurrentValue = 1; -- The current value of the slider
	Increment = 1; -- The amount the value increases by when sliding. Increment cannot be 0 or negative
	FormatString = "%d"; -- "%d" represents the CurrentValue
	CallbackOnRelease = true; -- Callback only when mouse is released
	Flag = "MinimumPlayerCount"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after slider is changed
		print("Slider set to "..tostring(value))
	end
})
local TradingSection = EconomyTab:CreateSection("Trading",120,true) -- Name, DropdownSizeY, Opened
EconomyTab:CreateButton({
	Name = "Load Module";
	RichText = false; -- Enables RichText for the Name
	SectionParent = TradingSection; -- The SectionTab the element is parented to
	Callback = function() -- The function that is called after button is activated
		if httprequest then
			LoadValueList()
		else
			MM2MainErrorNotification("Your executor does not support this exploit (missing 'httprequest')")
		end
	end
})
EconomyTab:CreateSeparator("Inventory",TradingSection) -- Text, SectionParent
EconomyTab:CreateToggle({
	Name = "Show Item Values";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = TradingSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "ShowItemVaues"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
		if value and not ValueListLoaded then
			Library:Notify({
				Type = "error"; -- (Required) id0x1 = Error, id0x2 = Info, id0x3 = Success, set to nil for normal notification
				Title = "Error";
				Message = 'Failed to find Module. To Load the Module, Press The "Load Module" Button Above.'; -- (Required)
				Duration = 5; -- (Required)
			})
		end
	end
})
EconomyTab:CreateButton({
	Name = "Inventory Calculator";
	RichText = false; -- Enables RichText for the Name
	SectionParent = TradingSection; -- The SectionTab the element is parented to
	Callback = function() -- The function that is called after button is activated
		if not ValueListLoaded then
			Library:Notify({
				Type = "error"; -- (Required) id0x1 = Error, id0x2 = Info, id0x3 = Success, set to nil for normal notification
				Title = "Error";
				Message = 'Failed to find Module. To Load the Module, Press The "Load Module" Button Above.'; -- (Required)
				Duration = 5; -- (Required)
			})
		end
	end
})
EconomyTab:CreateSeparator("Trading",TradingSection) -- Text, SectionParent
EconomyTab:CreateToggle({
	Name = "Show Trade Values";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = TradingSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "ShowTradeValue"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
		if value and not ValueListLoaded then
			Library:Notify({
				Type = "error"; -- (Required) id0x1 = Error, id0x2 = Info, id0x3 = Success, set to nil for normal notification
				Title = "Error";
				Message = 'Failed to find Module. To Load the Module, Press The "Load Module" Button Above.'; -- (Required)
				Duration = 5; -- (Required)
			})
		end
	end
})
EconomyTab:CreateToggle({
	Name = "Show Trade Status";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = TradingSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "ShowTradeStatus"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
		if value and not ValueListLoaded then
			Library:Notify({
				Type = "error"; -- (Required) id0x1 = Error, id0x2 = Info, id0x3 = Success, set to nil for normal notification
				Title = "Error";
				Message = 'Failed to find Module. To Load the Module, Press The "Load Module" Button Above.'; -- (Required)
				Duration = 5; -- (Required)
			})
		end
	end
})
EconomyTab:CreateSeparator("Trade Bot",TradingSection) -- Text, SectionParent
Window:AddElementTip(EconomyTab:CreateToggle({
	Name = "Auto Trade";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = TradingSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "TradeBotAutoTrade"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
		if value and not ValueListLoaded then
			Library:Notify({
				Type = "error"; -- (Required) id0x1 = Error, id0x2 = Info, id0x3 = Success, set to nil for normal notification
				Title = "Error";
				Message = 'Failed to find Module. To Load the Module, Press The "Load Module" Button Above.'; -- (Required)
				Duration = 5; -- (Required)
			})
		end
	end
}),"Trade Bot that automatically trades (if it underpays, it means the bot cannot trade anymore as overpaying is not allowed)",5) -- Shows a tip under your mouse cursor (ElementName,Tip,Duration)
Window:AddElementTip(EconomyTab:CreateDropdown({
	Name = "Blacklist Items";
	RichText = false; -- Enables RichText for the Name
	Options = {"Ancients","Vintages","Chromas","Godlies","Legendaries","Rares","Uncommons","Commons","Misc"};
	CurrentOption = {};
	MinOptions = 0; -- Minimum amount of options the user can select
	MaxOptions = 8; -- Maximum amount of options the user can select
	CallbackOnSelect = true; -- Callback anytime an option is selected
	SectionParent = TradingSection; -- The SectionTab the element is parented to
	Flag = "TradeBotBlacklistItems"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	Callback = function(options) -- options will always return a table
	end
}),"List of items the bot is not allowed to trade with",5)
Window:AddElementTip(EconomyTab:CreateToggle({
	Name = "Auto Decline";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = TradingSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "TradeBotAutoDecline"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
		if value and not ValueListLoaded then
			Library:Notify({
				Type = "error"; -- (Required) id0x1 = Error, id0x2 = Info, id0x3 = Success, set to nil for normal notification
				Title = "Error";
				Message = 'Failed to find Module. To Load the Module, Press The "Load Module" Button Above.'; -- (Required)
				Duration = 5; -- (Required)
			})
		end
	end
}),"Auto Declines when the trade bot cannot offer.",5)
EconomyTab:CreateSeparator("Trade Exploits",TradingSection) -- Text, SectionParent
Window:AddElementTip(EconomyTab:CreateToggle({
	Name = "Dupe Items";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = TradingSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "DupeItems"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
		if value then
			Library:Notify({
				Type = "error"; -- (Required) id0x1 = Error, id0x2 = Info, id0x3 = Success, set to nil for normal notification
				Title = "Error";
				Message = "Under Maintenance or patched."; -- (Required)
				Duration = 5; -- (Required)
			})
		end
	end
}),"Duplicates 2x the items sent to the other player by trade.",5) -- Shows a tip under your mouse cursor (ElementName,Tip,Duration)
Window:AddElementTip(EconomyTab:CreateToggle({
	Name = "Trade Scam";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = TradingSection; -- The SectionTab the button is parented to
	CurrentValue = false; -- If the toggle is on/off
	Flag = "TradeScam"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
		if value then
			Library:Notify({
				Type = "error"; -- (Required) id0x1 = Error, id0x2 = Info, id0x3 = Success, set to nil for normal notification
				Title = "Error";
				Message = "Under Maintenance or patched."; -- (Required)
				Duration = 5; -- (Required)
			})
		end
	end
}),"Shows your offer to the other player but they do not retrieve your items.",5) -- Shows a tip under your mouse cursor (ElementName,Tip,Duration)
Window:AddElementTip(EconomyTab:CreateButton({
	Name = "Force Complete Trade";
	RichText = false; -- Enables RichText for the Name
	SectionParent = TradingSection; -- The SectionTab the element is parented to
	Callback = function() -- The function that is called after button is activated
		Library:Notify({
			Type = "error"; -- (Required) id0x1 = Error, id0x2 = Info, id0x3 = Success, set to nil for normal notification
			Title = "Error";
			Message = "Under Maintenance or patched."; -- (Required)
			Duration = 5; -- (Required)
		})
	end
}),"Forces the server to complete the trade regardless of wait times (server-sided only).",5) -- Shows a tip under your mouse cursor (ElementName,Tip,Duration)
---------------------------------------------------------------------------
-- Others
local PaddingSection = OthersTab:CreateSection("Padding",36,true) -- Name, DropdownSizeY, Opened
local Padding
OthersTab:CreateButton({
	Name = "Organize Tabs";
	RichText = false; -- Enables RichText for the Name
	SectionParent = PaddingSection; -- The SectionTab the element is parented to
	Callback = function() -- The function that is called after button is activated
		Window:OrganizeTabs(19,19,Padding.CurrentValue)
	end
})
Padding = OthersTab:CreateSlider({
	Name = "Padding";
	RichText = false; -- Enables RichText for the Name
	ScrollBarRichText = false; -- Enables RichText for the Value Display
	SliderBackgroundColor = Color3.fromRGB(58, 58, 58); -- Color of the slider bar's background
	SliderColor = Color3.fromRGB(255, 231, 112); -- Color of the slider bar
	BlendColors = false; -- Blends MinColor & MaxColor depending on CurrentValue
	MinColor = Color3.fromRGB(255, 112, 112); -- Color of the slider bar at minimum value
	MaxColor = Color3.fromRGB(255, 231, 112); -- Color of the slider bar at maximum value
	SectionParent = PaddingSection; -- The SectionTab the button is parented to
	MinValue = 0; -- Minimum value of the slider
	MaxValue = 20; -- Maximum value of the slider
	CurrentValue = 0; -- The current value of the slider
	Increment = 1; -- The amount the value increases by when sliding. Increment cannot be 0 or negative
	FormatString = "%d"; -- "%d" represents the CurrentValue
	CallbackOnRelease = true; -- Callback only when mouse is released
	Flag = ""; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	Callback = function(value) -- The function that is called after slider is changed
		print("Padding set to "..tostring(value))
	end
})
local ConfigsSection = OthersTab:CreateSection("Config Save",80,true) -- Name, DropdownSizeY, Opened
ConfigsDropdown = OthersTab:CreateDropdown({
	Name = "Configs";
	RichText = false; -- Enables RichText for the Name
	Options = {};
	CurrentOption = {};
	MinOptions = 0; -- Minimum amount of options the user can select
	MaxOptions = 1; -- Maximum amount of options the user can select
	CallbackOnSelect = true; -- Callback anytime an option is selected
	SectionParent = ConfigsSection; -- The SectionTab the element is parented to
	Flag = ""; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	Callback = function(options) -- options will always return a table
		print("Options Selected:",table.unpack(options))
	end
})
local FileNameTextBox = OthersTab:CreateInput({
	Name = "Name";
	PlaceholderText = "Enter File Name.";
	NumbersOnly = false;
	RichText = false; -- Enables RichText for the Name
	CharacterLimit = 50;
	ClearTextOnFocus = false;
	SectionParent = ConfigsSection; -- The SectionTab the button is parented to
	CurrentValue = ""; -- The text of the textbox
	Flag = ""; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	Callback = function(value) -- The function that is called after toggle is pressed
		print("Toggle set to "..tostring(value))
	end
})
OthersTab:CreateButton({
	Name = "Save File";
	RichText = false; -- Enables RichText for the Name
	SectionParent = ConfigsSection; -- The SectionTab the element is parented to
	Callback = function() -- The function that is called after button is activated
		Library:SaveConfiguration(FileNameTextBox.CurrentValue)
		UpdateConfigsDropdown()
	end
})
OthersTab:CreateButton({
	Name = "Load File";
	RichText = false; -- Enables RichText for the Name
	SectionParent = ConfigsSection; -- The SectionTab the element is parented to
	Callback = function() -- The function that is called after button is activated
		Library:LoadConfiguration(ConfigsDropdown.CurrentOption[1],true)
	end
})
OthersTab:CreateButton({
	Name = "Delete File";
	RichText = false; -- Enables RichText for the Name
	SectionParent = ConfigsSection; -- The SectionTab the element is parented to
	Callback = function() -- The function that is called after button is activated
		Library:DeleteConfiguration(ConfigsDropdown.CurrentOption[1])
		UpdateConfigsDropdown()
		if not table.find(ConfigsDropdown.Options,ConfigsDropdown.CurrentOption) then
			ConfigsDropdown.CurrentOption = {}
		end
	end
})
local OthersSection = OthersTab:CreateSection("Others",120,true) -- Name, DropdownSizeY, Opened
OthersTab:CreateToggle({
	Name = "Keep GUI";
	RichText = false; -- Enables RichText for the Name
	ActivatedColor = Color3.fromRGB(255, 231, 112); -- Color of the toggle when activated
	SectionParent = OthersSection; -- The SectionTab the button is parented to
	CurrentValue = true; -- If the toggle is on/off
	Flag = "KeepGUI"; -- Identifier for the configuration file. Recommended to keep it unique otherwise other elements can override.
	IgnoreList = FlagsIgnoreList; -- The properties the flag will blacklist/not saved
	Callback = function(value) -- The function that is called after toggle is pressed
		if value then
			TeleportService:SetTeleportGui(LoadingScreen)
			if not queueonteleport then
				MM2MainErrorNotification("Your executor does not support this exploit (missing 'queueonteleport')")
			end
		else
			TeleportService:SetTeleportGui(nil)
		end
	end
})
OthersTab:CreateButton({
	Name = "Better Movement";
	RichText = false; -- Enables RichText for the Name
	SectionParent = OthersSection; -- The SectionTab the element is parented to
	Callback = function() -- The function that is called after button is activated
		loadstring(game:HttpGet("https://pastebin.com/raw/NJpXWFy1"))()
	end
})
OthersTab:CreateButton({
	Name = "Free Animations";
	RichText = false; -- Enables RichText for the Name
	SectionParent = OthersSection; -- The SectionTab the element is parented to
	Callback = function() -- The function that is called after button is activated
		loadstring(game:HttpGet("https://raw.githubusercontent.com/CITY512/scripts/main/freeanims.lua"))()
	end
})
OthersTab:CreateButton({
	Name = "MM2 ProMode GUI";
	RichText = false; -- Enables RichText for the Name
	SectionParent = OthersSection; -- The SectionTab the element is parented to
	Callback = function() -- The function that is called after button is activated
		loadstring(game:HttpGet("https://pastebin.com/raw/TZ2BYv3H"))()
	end
})
OthersTab:CreateButton({
	Name = "Rejoin";
	RichText = false; -- Enables RichText for the Name
	SectionParent = OthersSection; -- The SectionTab the element is parented to
	Callback = function() -- The function that is called after button is activated
		Rejoin()
	end
})
---------------------------------------------------------------------------
-- Event Functions
LocalPlayer.OnTeleport:Connect(function()
	if not TPCheck and queueonteleport and Library.Flags.KeepGUI.CurrentValue then
		TPCheck = true
		queueonteleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/CITY512/scripts/main/mm2%20hack.lua'))()")
	end
end)
LoadingMap.OnClientEvent:Connect(function(gamemode)
	match.GameMode = gamemode
	print("Current Gamemode: "..gamemode)
end)
Fade.OnClientEvent:Connect(function()
	task.wait(1)
	if Library.Flags.AutoNotifyRoles.CurrentValue then
		NotifyRoles()
	end
	if Library.Flags.AutoAnnounceRoles.CurrentValue then
		AnnounceRoles()
	end
end)
ChangeTarget.OnClientEvent:Connect(function(target)
	if match.GameMode == GameModes.Assassin then
		match.Assassin.AssassinTarget = target
		print("Target Changed: "..target)
		for player in players do
			players[player].UpdateChams()
		end
	end
end)
workspace.ChildAdded:Connect(function(child)
	if child:IsA("Model") and not child:FindFirstChildOfClass("Humanoid") then
		-- Check If Throwing Knife
		if child.Name == "ThrowingKnife" then
			local blade = child:WaitForChild("BladePosition", 10)
			local dir = child:WaitForChild("Vector3Value", 10) -- 2nd argument to prevent infinite yield
			-- Check If The Blade and Vector3Value Exists
			if not blade or not dir then return end
			-- Variables
			local protectionBarrierThickness = 2.5
			local dirUnit = dir.Value.Unit
			local protectionBarrier
			local knifeTraceBeam
			local renderstepped
			local pb1
			local pb2
			-- Check If Direction Unit is NaN
			if dirUnit ~= dirUnit then
				dirUnit = Vector3.xAxis.Unit
			end
			-- Auto Dodge
			if Library.Flags.AutoDodge.CurrentValue and players[LocalPlayer.Name].Role ~= "Murderer" then
				protectionBarrier = Instance.new("Part", blade)
				protectionBarrier.Name = "KnifeProtectionBarrier"
				protectionBarrier.Anchored = true
				protectionBarrier.Size = Vector3.new(protectionBarrierThickness,2048,95 * (LocalPlayer:GetNetworkPing() * 2 + 0.3))
				protectionBarrier.Color = Color3.fromRGB(255, 40, 40)
				protectionBarrier.Transparency = Library.Flags.AutoDodgeShowKnifeBarrier.CurrentValue and 0.5 or 1
				protectionBarrier.TopSurface = Enum.SurfaceType.Smooth
				protectionBarrier.BottomSurface = Enum.SurfaceType.Smooth
				pb1 = Instance.new("Part", blade)
				pb1.Name = "KnifeProtectionBarrier"
				pb1.Anchored = true
				pb1.Size = Vector3.new(2048,2,95/LPlrHum.WalkSpeed)
				pb1.Color = Color3.fromRGB(255, 40, 40)
				pb1.Transparency = Library.Flags.AutoDodgeShowKnifeBarrier.CurrentValue and 0.5 or 1
				pb1.TopSurface = Enum.SurfaceType.Smooth
				pb1.BottomSurface = Enum.SurfaceType.Smooth
				pb1.Shape = Enum.PartType.Wedge
				pb2 = Instance.new("Part", blade)
				pb2.Name = "KnifeProtectionBarrier"
				pb2.Anchored = true
				pb2.Size = Vector3.new(2048,2,95/LPlrHum.WalkSpeed)
				pb2.Color = Color3.fromRGB(255, 40, 40)
				pb2.Transparency = Library.Flags.AutoDodgeShowKnifeBarrier.CurrentValue and 0.5 or 1
				pb2.TopSurface = Enum.SurfaceType.Smooth
				pb2.BottomSurface = Enum.SurfaceType.Smooth
				pb2.Shape = Enum.PartType.Wedge
				Debris:AddItem(protectionBarrier,4)
				Debris:AddItem(pb1,4)
				Debris:AddItem(pb2,4)
			end
			-- Show Knife Traces
			if Library.Flags.WeaponESP.CurrentValue then
				UpdateChams(blade,false,{
					Enabled = true;
					Color = Library.Flags.WeaponColor.CurrentColor;
				})
				UpdateNameTags(blade,false,Library.Flags.WeaponColor.CurrentColor,{[1] = {Name = "Projectile"}})
			end
			if Library.Flags.ShowKnifeTraces.CurrentValue then
				-- IgnoreList for the raycast blacklist
				local ignoreList = {child}
				for _, player in Players:GetChildren() do
					local char = player.Character
					if char then
						table.insert(ignoreList,char)
					end
				end
				-- Raycast Params
				local params = RaycastParams.new()
				params.FilterDescendantsInstances = ignoreList
				params.FilterType = Enum.RaycastFilterType.Blacklist
				params.RespectCanCollide = true
				-- Raycast
				local raycastresult = workspace:Raycast(blade.Position,dir.Value * 999,params)
				if raycastresult then -- Wall Check
					local A0 = Instance.new("Attachment", blade)
					local A1 = Instance.new("Attachment", raycastresult.Instance)
					A1.WorldCFrame = CFrame.new(raycastresult.Position)
					knifeTraceBeam = Instance.new("Beam", blade)
					knifeTraceBeam.Name = "KnifeTraces"
					knifeTraceBeam.Attachment0 = A0
					knifeTraceBeam.Attachment1 = A1
					knifeTraceBeam.Transparency = NumberSequence.new(0)
					knifeTraceBeam.FaceCamera = true
					Debris:AddItem(knifeTraceBeam,4)
				end
			end
			renderstepped = RS.RenderStepped:Connect(function()
				if not blade.Parent then
					renderstepped:Disconnect()
					return
				end
				if knifeTraceBeam then
					local hue = math.clamp((blade.Position - LPlrHrp.Position).Magnitude / 75,0,7/9)
					knifeTraceBeam.Color = ColorSequence.new(Color3.fromHSV(hue,0.6,1)) -- Update Knife Trace Color
				end
				if protectionBarrier and pb1 and pb2 then
					protectionBarrier.Size = Vector3.new(protectionBarrierThickness,2048,95 * (LocalPlayer:GetNetworkPing() * 2 + 0.3))
					if math.abs(blade.Position.Y - LPlrHrp.Position.Y) < 95 * math.abs(dirUnit.Y) * (LocalPlayer:GetNetworkPing() * 2 + 0.3) + 6 then
						protectionBarrier.CFrame = CFrame.new(blade.Position + dirUnit * Vector3.new(1,0,1) * protectionBarrier.Size.Z/2,blade.Position)
						protectionBarrier.Position += Vector3.new(0,LPlrHrp.Position.Y - blade.Position.Y,0)
						ManeuverLookVector = (protectionBarrier.CFrame * CFrame.Angles(0,math.pi/2,0)).LookVector
					else
						protectionBarrier.CFrame = CFrame.new(99999,99999,99999)
						ManeuverLookVector = nil
					end
					pb1.Size = Vector3.new(2048,2,95/LPlrHum.WalkSpeed)
					pb1.CFrame = CFrame.new(protectionBarrier.Position + -protectionBarrier.CFrame.LookVector * (protectionBarrier.Size.Z/2 + pb1.Size.Z/2),blade.Position) * CFrame.Angles(0,math.pi,math.pi/2) - (protectionBarrier.CFrame * CFrame.Angles(0,math.pi/2,0)).LookVector * protectionBarrierThickness / 4
					pb2.Size = Vector3.new(2048,2,95/LPlrHum.WalkSpeed)
					pb2.CFrame = CFrame.new(protectionBarrier.Position + -protectionBarrier.CFrame.LookVector * (protectionBarrier.Size.Z/2 + pb1.Size.Z/2),blade.Position) * CFrame.Angles(0,math.pi,-math.pi/2) + (protectionBarrier.CFrame * CFrame.Angles(0,math.pi/2,0)).LookVector * protectionBarrierThickness / 4
				end
			end)
			task.wait(4)
			renderstepped:Disconnect()
			ManeuverLookVector = nil
		end
	end
end)
workspace.DescendantAdded:Connect(function(descendant)
	if AntiLag then
		RemoveLagFromObject(descendant)
	end
	if Library.Flags.XRay.CurrentValue then
		XRayPart(descendant)
	end
end)
Players.ChildAdded:Connect(UpdatePlayerList)
Players.ChildRemoved:Connect(UpdatePlayerList)
NoclipButton.MouseButton1Click:Connect(function()
	Noclipping = not Noclipping
	if not Noclipping then
		for i, v in LPlrChar:GetDescendants() do
			if v:IsA("BasePart") then
				v.CanCollide = true
			end
		end
	end
end)
FlyButton.MouseButton1Click:Connect(function()
	if Flying then
		DisableFly()
	else
		DisableFly()
		EnableFly()
	end
end)
UIS.LastInputTypeChanged:Connect(UpdateMobileGUI)
---------------------------------------------------------------------------
-- Hooks
local namecall
namecall = hookmetamethod(game, "__namecall", newcclosure(function(self,...)
	local args = {...}
	local method = getnamecallmethod()
	if not checkcaller() then
		if Library.Flags.GunAimbot.CurrentValue and tostring(self) == "RemoteFunction" and tostring(method) == "InvokeServer" then
			local script = rawget(getfenv(2), "script")
			if script and script == GunLocal then
				local target = GetTarget("Gun",Library.Flags.SheriffTargetMethod.CurrentOption[1],Library.Flags.SmartTarget.CurrentValue)
				if target then
					local suc, aimpos = pcall(GetAimVector,"Gun",target,Library.Flags.ShowAimbotVisuals.CurrentValue,Library.Flags.AimbotPredictJump.CurrentValue,Library.Flags.AimbotAlwaysJumping.CurrentValue)
					args[2] = suc and aimpos or args[2]
					if not suc then
						print("Gun Aimbot Error: "..aimpos)
					end
				end
			end
			return self.InvokeServer(self,table.unpack(args))
		elseif Library.Flags.KnifeAimbot.CurrentValue and tostring(self) == "Throw" and tostring(method) == "FireServer" then
			local script = rawget(getfenv(2), "script")
			if script and script == KnifeLocal then
				local target = GetTarget("Knife",Library.Flags.MurdererTargetMethod.CurrentOption[1],Library.Flags.SmartTarget.CurrentValue)
				if target then
					local suc, aimpos = pcall(GetAimVector,"Knife",target,Library.Flags.ShowAimbotVisuals.CurrentValue,Library.Flags.AimbotPredictJump.CurrentValue,Library.Flags.AimbotAlwaysJumping.CurrentValue)
					args[1] = suc and CFrame.new(aimpos) or args[1]
					if not suc then
						print("Knife Aimbot Error: "..aimpos)
					end
				end
			end
			return self.FireServer(self,table.unpack(args))
		elseif Library.Flags.FakeBombJump.CurrentValue and tostring(self) == "Remote" and tostring(method) == "FireServer" then
			local script = rawget(getfenv(2), "script")
			if script and script == FakeBombClient then
				local params = RaycastParams.new()
				params.FilterType = Enum.RaycastFilterType.Blacklist
				params.FilterDescendantsInstances = {LPlrChar}
				local floorcheck = workspace:Raycast(LPlrHrp.Position,Vector3.new(0,-3.5,0),params)
				if not floorcheck then
					LPlrHum:ChangeState(Enum.HumanoidStateType.Jumping)
					args[1] = CFrame.new(args[1].Position) * CFrame.Angles(math.pi/2,0,0)
				end
				return self.FireServer(self,table.unpack(args))
			end
		end
	end
	return namecall(self,...)
end))
---------------------------------------------------------------------------
-- Loops
UpdatePlayerList()
UpdateMobileGUI()
task.spawn(function()
	while true do
		UpdateConfigsDropdown()
		if Library.Flags.AutoPrestige.CurrentValue then
			PrestigeEvent:FireServer()
		end
		task.wait(1)
	end
end)
task.spawn(function()
	while true do
		local PlayerData = GetPlayerDataRemote:InvokeServer()
		for player in players do
			if PlayerData[player] then
				players[player].Perk = PlayerData[player].Perk
				if not PlayerData[player].Dead then
					players[player].Role = PlayerData[player].Role
				else
					players[player].Role = "Dead"
				end
			else
				players[player].Role = "Dead"
			end
		end
		task.wait()
	end
end)
task.spawn(function()
	while true do
		-- Breakdance
		if Library.Flags.EmoteBreakdance.CurrentValue then
			emotestep += 1
			if emotestep > 7 then
				emotestep = 1
			end
			if emotestep == 1 then
				PlayEmoteBindable:Fire("sit")
			elseif emotestep == 2 then
				PlayEmoteBindable:Fire("zombie")
			elseif emotestep == 3 then
				PlayEmoteBindable:Fire("dab")
			elseif emotestep == 4 then
				PlayEmoteBindable:Fire("floss")
			elseif emotestep == 5 then
				PlayEmoteBindable:Fire("zen")
			elseif emotestep == 6 then
				PlayEmoteBindable:Fire("ninja")
			elseif emotestep == 7 then
				PlayEmoteBindable:Fire("headless")
			end
		end
		task.wait(0.1)
	end
end)
RS.Stepped:Connect(function()
	local KillAuraInRange = {}
	local playerlist = Players:GetChildren()
	-- Loop Through Player Instances
	for _, player in playerlist do
		local char = player.Character
		local hrp = getRoot(player)
		local hum = getHumanoid(player)
		if char then
			-- Kill Aura In Range
			if Library.Flags.KillAura.CurrentValue and firetouchinterest and player ~= LocalPlayer and hrp and KnifeTool and KnifeTool.Parent == LPlrChar then
				local distance = (hrp.Position - LPlrHrp.Position).Magnitude
				if distance <= Library.Flags.KillAuraRange.CurrentValue then
					table.insert(KillAuraInRange,{char,distance})
				end
			end
			-- Anti Fling & Noclip
			if Library.Flags.AntiFling.CurrentValue and player ~= LocalPlayer or Library.Flags.Noclip.CurrentValue and Noclipping and player == LocalPlayer then
				for i, v in char:GetDescendants() do
					if v:IsA("BasePart") then
						v.CanCollide = false
					end
				end
			end
		end
	end
	-- Kill Aura
	if KnifeTool and #KillAuraInRange > 0 then
		KnifeTool:Activate()
		table.sort(KillAuraInRange,function(a, b)
			return a[2] < b[2]
		end)
		local closestchar = KillAuraInRange[1][1]
		local closesthrp = closestchar.HumanoidRootPart
		if Library.Flags.MultiAura.CurrentValue then
			for i, v in KillAuraInRange do
				local hrp = v[1].HumanoidRootPart
				if Library.Flags.KillAuraTargetHighlight.CurrentValue then
					UpdateChams(hrp,false,{
						Type = 2;
						Enabled = true;
						Color = Library.Flags.TargetColor.CurrentColor;
						Size = Vector3.new(5,6,2);
						CFrame = CFrame.new(0,-0.5,0);
					})
				end
				pcall(function()
					firetouchinterest(KnifeHandle,hrp,1)
					firetouchinterest(KnifeHandle,hrp,0)
				end)
			end
		else
			if Library.Flags.KillAuraTargetHighlight.CurrentValue then
				UpdateChams(closesthrp,false,{
					Type = 2;
					Enabled = true;
					Color = Library.Flags.TargetColor.CurrentColor;
					Size = Vector3.new(5,6,2);
					CFrame = CFrame.new(0,-0.5,0);
				})
			end
			pcall(function()
				firetouchinterest(KnifeHandle,closesthrp,1)
				firetouchinterest(KnifeHandle,closesthrp,0)
			end)
		end
		if Library.Flags.KillAuraFaceTarget.CurrentValue then
			LPlrLookAt = closesthrp.Position
		end
	end
	prevtargets = KillAuraInRange
end)
RS.RenderStepped:Connect(function()
	-- Tick
	local t = tick()
	-- Update Dropdowns
	local playerlist = Players:GetChildren()
	FlingPlayerDropdown.Options = playerlist
	KillPlayerDropdown.Options = playerlist
	PlayerTeleportDropdown.Options = playerlist
	-- Set LocalPlayer Character Variables
	LPlrLookAt = nil
	LPlrChar = LocalPlayer.Character or LPlrChar
	LPlrHrp = getRoot(LocalPlayer) or LPlrHrp
	LPlrHum = getHumanoid(LocalPlayer) or LPlrHum
	Backpack = LocalPlayer:FindFirstChild("Backpack") or Backpack
	-- Find Map
	match.Map = FindMap()
	if match.Map then
		MapEventFunctions(match.Map)
	end
	-- Update Variables
	KeyboardEnabled = UIS.KeyboardEnabled
	GunTool = nil
	GunHandle = nil
	GunLocal = nil
	GunRemoteFunction = nil
	KnifeTool = nil
	KnifeHandle = nil
	KnifeLocal = nil
	KnifeThrowEvent = nil
	FakeBombTool = nil
	FakeBombEvent = nil
	FakeBombClient = nil
	local function CheckIf(tool)
		if tool.Name == "Gun" and tool:FindFirstChild("Handle") and tool:FindFirstChild("KnifeLocal") then
			GunTool = tool
			GunHandle = tool.Handle
			GunLocal = tool.KnifeLocal
		elseif tool.Name == "Knife" and tool:FindFirstChild("Handle") and tool:FindFirstChild("KnifeClient") and tool:FindFirstChild("Throw") then
			KnifeTool = tool
			KnifeHandle = tool.Handle
			KnifeLocal = tool.KnifeClient
			KnifeThrowEvent = tool.Throw
		elseif tool.Name == "FakeBomb" and tool:FindFirstChild("Remote") and tool:FindFirstChild("Client") then
			FakeBombTool = tool
			FakeBombEvent = tool.Remote
			FakeBombClient = tool.Client
		end
	end
	for i, v in Backpack:GetChildren() do
		CheckIf(v)
	end
	for i, v in LPlrChar:GetChildren() do
		CheckIf(v)
	end
	-- Previous Targets
	for _, char in prevtargets do
		local hrp = char[1]:FindFirstChild("HumanoidRootPart")
		if hrp then
			UpdateChams(hrp,false,{
				Type = 2;
				Enabled = false;
			})
		end
	end
	-- Loop Through Player Instances
	local AntiAimClosestTarget
	local AntiAimClosestDistance = math.huge
	for _, player in playerlist do
		local char = player.Character
		local hrp = getRoot(player)
		local hum = getHumanoid(player)
		if char then
			-- Anti Aim Target
			if Library.Flags.AntiAim.CurrentValue and player ~= LocalPlayer and hrp then
				local distancetemp = (hrp.Position - LPlrHrp.Position).Magnitude
				if match.GameMode == GameModes.Classic then
					if distancetemp < AntiAimClosestDistance and (players[LocalPlayer.Name].Role ~= "Murderer" and players[player.Name].Role == "Murderer" or players[LocalPlayer.Name].Role == "Murderer" and players[player.Name].Role == "Sheriff") then
						AntiAimClosestTarget = player
						AntiAimClosestDistance = distancetemp
					end
				elseif match.GameMode == GameModes.Assassin then
					if distancetemp < AntiAimClosestDistance then
						AntiAimClosestTarget = player
						AntiAimClosestDistance = distancetemp
					end
				end
			end
		end
	end
	-- Anti Aim
	if Library.Flags.AntiAim.CurrentValue and AntiAimClosestTarget then
		AntiAimFrom(AntiAimClosestTarget.Character.HumanoidRootPart.Position)
	end
	-- Auto Steal Gun
	if Library.Flags.AutoStealGun.CurrentValue then
		task.spawn(StealGun)
	end
	-- Change WalkSpeed and JumpPower
	if Library.Flags.ToggleWalkSpeed.CurrentValue then
		LPlrHum.WalkSpeed = Library.Flags.WalkSpeed.CurrentValue
	end
	if Library.Flags.ToggleJumpPower.CurrentValue then
		LPlrHum.JumpPower = Library.Flags.JumpPower.CurrentValue
	end
	-- Loop Equip All Emotes
	if Library.Flags.LoopEquipAllEmotes.CurrentValue and Backpack then
		local toys = Backpack:FindFirstChild("Toys")
		if toys and not ReplicateToyDebounce then
			task.spawn(function()
				ReplicateToyDebounce = true
				task.wait(2)
				ReplicateToyDebounce = false
			end)
			for _, toy in toys:GetChildren() do
				if not Backpack:FindFirstChild(toy.Name) and not LPlrChar:FindFirstChild(toy.Name) then
					task.spawn(function()
						ReplicateToyRemote:InvokeServer(toy.Name)
					end)
				end
			end
		end
		for i, v in Backpack:GetChildren() do
			if v.ClassName == "Tool" and v.Name ~= "Gun" and v.Name ~= "Knife" and v.Name ~= "Emotes" then
				LPlrHum:EquipTool(v)
			end
		end
	end
	-- Auto Equip Gun & Knife
	if Library.Flags.AutoEquipKnife.CurrentValue and KnifeTool and KnifeTool.Parent == Backpack then
		LPlrHum:EquipTool(KnifeTool)
	end
	if Library.Flags.AutoEquipGun.CurrentValue and GunTool and GunTool.Parent == Backpack then
		LPlrHum:EquipTool(GunTool)
	end
	-- Auto Shoot Murderer
	if Library.Flags.AutoShootMurderer.CurrentValue then
		task.spawn(ShootMurderer)
	end
	-- Auto Shoot Gun
	if not AutoShootDebounce and Library.Flags.AutoShoot.CurrentValue and GunTool and GunTool.Parent == LPlrChar then
		local target = GetTarget("Gun","ClosestPlayerToCharacter",true)
		if target then
			local char = target.Character
			local hrp = char.HumanoidRootPart
			if not Library.Flags.AutoShootLegitMode.CurrentValue or char:FindFirstChild("Knife") then
				local params = RaycastParams.new()
				params.FilterType = Enum.FilterType.Blacklist
				params.FilterDescendantsInstances = {char,LPlrChar}
				local raycast = workspace:Raycast(GunHandle.Position,hrp.Position - GunHandle.Position,params)
				if not raycast then
					local suc, aimpos = pcall(GetAimVector,"Gun",target,false)
					if suc and aimpos then
						ShootGun(aimpos)
					end
					GunShotCooldown(3.5)
				end
			end
		end
	end
	-- Auto Throw Knife
	if not AutoThrowDebounce and Library.Flags.AutoThrow.CurrentValue and KnifeTool and KnifeTool.Parent == LPlrChar then
		task.spawn(function()
			if Library.Flags.AutoThrowUseThrowAnimation.CurrentValue then
				KnifeThrowCooldown(2.125)
				local Animation = Instance.new("Animation")
				Animation.AnimationId = "rbxassetid://1957618848"
				LPlrHum:LoadAnimation(Animation):Play()
				Animation:Destroy()
				task.wait(1)
			else
				KnifeThrowCooldown(1.125)
			end
			local target = GetTarget("Knife","ClosestPlayerToCharacter",true)
			if target then
				local char = target.Character
				local hrp = char.HumanoidRootPart
				local raycast = workspace:Raycast(KnifeHandle.Position,hrp.Position - KnifeHandle.Position)
				if not raycast then
					local suc, aimpos = pcall(GetAimVector,"Knife",target,false)
					if suc and aimpos then
						ThrowKnife(aimpos)
					end
				end
			end
		end)
	end
	-- Face Target While Throwing
	if Library.Flags.KnifeFaceTarget.CurrentValue then
		local isThrowing = false
		for _, v in LPlrHum:GetPlayingAnimationTracks() do
			if v.Animation and v.Animation.AnimationId == "rbxassetid://1957618848" then
				isThrowing = true
			end
		end
		if isThrowing then
			local target = GetTarget("Knife","ClosestPlayerToCursor",true)
			if target then
				local hrp = target.Character.HumanoidRootPart
				local dist = (hrp.Position - LPlrHrp.Position).Magnitude
				LPlrLookAt = hrp.Position + hrp.Velocity * Vector3.new(1,0,1) * dist / 95
			end
		end
	end
	-- Auto Dodge Maneuver
	if ManeuverLookVector then
		LPlrLookAt = LPlrHrp.Position + ManeuverLookVector
	end
	-- LocalPlayer LookAt
	if LPlrLookAt then
		LPlrHrp.CFrame = CFrame.new(LPlrHrp.Position,LPlrLookAt * Vector3.new(1,0,1) + LPlrHrp.Position * Vector3.yAxis)
	end
	-- Change FOV Circle Type
	if GunTool and GunTool.Parent == LPlrChar then
		if Library.Flags.SheriffTargetMethod.CurrentValue == "ClosestPlayerToScreenCenter" then
			FOVCircleType = 2
		elseif Library.Flags.SheriffTargetMethod.CurrentValue == "ClosestPlayerToCursor" then
			FOVCircleType = 1
		end
	elseif KnifeTool and KnifeTool.Parent == LPlrChar then
		if Library.Flags.MurdererTargetMethod.CurrentValue == "ClosestPlayerToScreenCenter" then
			FOVCircleType = 2
		elseif Library.Flags.MurdererTargetMethod.CurrentValue == "ClosestPlayerToCursor" then
			FOVCircleType = 1
		else
			FOVCircleType = 0
		end
	else
		FOVCircleType = 0
	end
	-- Show FOV Circle
	if Library.Flags.ShowFOVCircle.CurrentValue and FOVCircleType ~= 0 then
		FOVCircleDrawing.Visible = true
		FOVCircleDrawing.Radius = Library.Flags.AimbotFOV.CurrentValue
		if FOVCircleType == 1 then
			local mousepos = UIS:GetMouseLocation()
			FOVCircleDrawing.Position = Vector2.new(mousepos.X,mousepos.Y)
		elseif FOVCircleType == 2 then
			FOVCircleDrawing.Position = Vector2.new(Camera.ViewportSize.X,Camera.ViewportSize.Y)/2
		end
	else
		FOVCircleDrawing.Visible = false
	end
	-- Mobile GUI Manager
	if MobileButtonContainer.Visible then
		local screenSize = Camera.ViewportSize -- Absolute Size of the screen.
		local minAxis = math.min(screenSize.X, screenSize.Y)
		local isSmallScreen = minAxis <= 500 -- Is the screen to small for big mobile buttons?
		local jumpButtonSize = isSmallScreen and 70 or 120 -- Gets the size of the jump button.
		MobileButtonContainer.Size = UDim2.new(0, jumpButtonSize, 0, jumpButtonSize)
		MobileButtonContainer.Position = isSmallScreen and UDim2.new(1, -(jumpButtonSize*1.5-10), 1, -jumpButtonSize - 20) or UDim2.new(1, -(jumpButtonSize*1.5-10), 1, -jumpButtonSize * 1.75)
	end
	FlyButton.Visible = Library.Flags.Fly.CurrentValue
	FlyButton.Image = Flying and "rbxassetid://109444847951538" or "rbxassetid://126043950347590"
	FlyButton.Position = UDim2.new(-1.1, 26, 0, 12)
	NoclipButton.Visible = Library.Flags.Noclip.CurrentValue
	NoclipButton.Image = Noclipping and "rbxassetid://108373759484173" or "rbxassetid://130972398264323"
	NoclipButton.Position = FlyButton.Visible and UDim2.new(-1.1,FlyButton.Position.X.Offset - 48,0,12) or UDim2.new(-1.1, 26, 0, 12)
	-- Full Bright
	if Library.Flags.FullBright.CurrentValue then
		Lighting.Brightness = 2
		Lighting.ClockTime = 14
		Lighting.FogEnd = 100000
		Lighting.GlobalShadows = false
		Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
	end
	-- Remove Weapon & Pet Displays
	if Library.Flags.RemoveWeaponLag.CurrentValue then
		local weapondisplays = FindFirstChildOfClassWithName(workspace,"WeaponDisplays","Folder")
		if weapondisplays then
			for i, v in weapondisplays:GetChildren() do
				v:Destroy()
			end
		end
	end
	if Library.Flags.RemovePetLag.CurrentValue then
		local petcontainer = FindFirstChildOfClassWithName(workspace,"PetContainer","Folder")
		if petcontainer then
			for i, v in petcontainer:GetChildren() do
				v:Destroy()
			end
		end
	end
	-- Remove Coin Visuals
	if match.Map then
		local coincontainer = match.Map:FindFirstChild("CoinContainer")
		if coincontainer then
			for i, v in coincontainer:GetChildren() do
				if v.Name == "Coin_Server" then
					if firetouchinterest and Library.Flags.CoinAura.CurrentValue then
						if (v.Position - LPlrHrp.Position).Magnitude <= 20 then
							pcall(function()
								firetouchinterest(LPlrHrp, v, 1)
								firetouchinterest(LPlrHrp, v, 0)
							end)
						end
					end
					if Library.Flags.RemoveCoinLag.CurrentValue then
						local coinvisual = v:FindFirstChild("CoinVisual")
						if coinvisual then
							v.Transparency = 0
							coinvisual:Destroy()
						end
					end
				end
			end
		end
	end
	-- 3D Drawing Handler
	for i, v in visuals do
		local spawn = v.Spawn
		local line = v.Line
		if Drawing then
			if not v.Line then
				line = Drawing.new("Line")
				line.Color = v.Color
				line.Thickness = 1
				line.Transparency = 1
				visuals[i].Line = line
			end
			local pos1, onscreen1 = Camera:WorldToViewportPoint(v.StartPoint)
			local pos2, onscreen2 = Camera:WorldToViewportPoint(v.EndPoint)
			if onscreen1 and onscreen2 then
				line.Visible = true
				line.From = Vector2.new(pos1.X,pos1.Y)
				line.To = Vector2.new(pos2.X,pos2.Y)
			else
				line.Visible = false
			end
			line.Color = v.Color
		end
		if spawn + v.LifeTime < t then
			if line then line:Remove() end
			visuals[i] = nil
		end
	end
end)
Library:Notify({
	Type = "success"; -- (Required) id0x1 = Error, id0x2 = Info, id0x3 = Success, set to nil for normal notification
	Title = "Success";
	Message = "MM2 Main Successfully Loaded!"; -- (Required)
	Duration = 10; -- (Required)
	Actions = {}
})
