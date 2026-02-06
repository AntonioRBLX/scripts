if PRISONLIFESILENTAIM then return end
getgenv().PRISONLIFESILENTAIM = truep
local cloneref = cloneref or function(...) return ... end
local RS = cloneref(game:GetService("RunService"))
local UIS = cloneref(game:GetService("UserInputService"))
local Players = cloneref(game:GetService("Players"))
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local LPlrChar
local LPlrHrp
local LPlrHum
local currentframe = 0
function CharAdded(char)
	LPlrChar = char
	LPlrHrp = char:WaitForChild("HumanoidRootPart", 10)
	LPlrHum = char:WaitForChild("Humanoid", 10)
end
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
function GetClosestToScreenCenter()
	local closest
	local distance = math.huge
	for _, player in Players:GetChildren() do
		if player ~= LocalPlayer then
			local hrp = getRoot(player)
			if hrp then
				local viewportpoint, onscreen = Camera:WorldToScreenPoint(hrp.Position)
				local vpdistancetemp = (Vector2.new(viewportpoint.X,viewportpoint.Y) - Vector2.new(Camera.ViewportSize.X,Camera.ViewportSize.Y)/2).Magnitude
				local distancefromplayer = (hrp.Position - LPlrHrp.Position).Magnitude
				if onscreen and vpdistancetemp < distance then
					closest = player
					distance = vpdistancetemp
				end
			end
		end
	end
	--print(closest)
	return closest
end
CharAdded(LocalPlayer.Character)
LocalPlayer.CharacterAdded:Connect(CharAdded)
local oldnamecall
oldnamecall = hookmetamethod(game, "__namecall", newcclosure(function(...)
	if not checkcaller() then
		local method = getnamecallmethod():lower()
		local args = {...}
		local self = args[1]
		--[[
		if method == "findpartonraywithignorelist" or method == "findpartonraywithwhitelist" or method == "findpartonray" then
			local A_Ray = args[2]
			local target = GetClosestToScreenCenter()
			if target then
				local origin = A_Ray.Origin
				local dir = (target.Character.HumanoidRootPart.Position - origin).Unit * 1000
				args[2] = Ray.new(origin, dir)
				return oldnamecall(unpack(args))
			end
		elseif method == "raycast" then
			local A_Origin = args[2]
			local target = GetClosestToScreenCenter()
			if target then
				args[3] = (target.Character.HumanoidRootPart.Position - A_Origin).Unit * 1000
				return oldnamecall(unpack(args))
			end
		elseif method == "getmouselocation" then
		if method == "getmouselocation" then
			local target = GetClosestToScreenCenter()
			if target then
				local pos = Camera:WorldToViewportPoint(target.Character.HumanoidRootPart.Position)
				args[2] = pos
				return oldnamecall(unpack(args))
			end
		end
		]]
	end
	return oldnamecall(...)
end))
local oldindex
oldindex = hookmetamethod(game, "__index", newcclosure(function(self,idx)
	if not checkcaller() then
		if self == Mouse then
			local target = GetClosestToScreenCenter()
			if target then
				local params = RaycastParams.new()
				params.FilterDescendantsInstances = {LPlrChar}
				params.FilterType = Enum.RaycastFilterType.Blacklist
				local idx = idx:lower()
				if idx == "target" then
					local raycast = workspace:Raycast(LPlrHrp.Position,target.Character.HumanoidRootPart - LPlrHrp.Position,params)
					if raycast then
						return raycast.Position
					end
				elseif idx == "hit" then
					local raycast = workspace:Raycast(LPlrHrp.Position,target.Character.HumanoidRootPart - LPlrHrp.Position,params)
					if raycast then
						return CFrame.new(raycast.Position,raycast.Normal)
					end
				elseif idx == "x" or idx == "y" then
					local pos = Camera:WorldToViewportPoint(target.Character.HumanoidRootPart.Position)
					return Vector2.new(pos.X,pos.Y)[idx:Upper()]
				elseif idx == "unitray" then 
					local raycast = workspace:Raycast(LPlrHrp.Position,target.Character.HumanoidRootPart - LPlrHrp.Position,params)
				--[[
				if #args > 1 then
					for i, v in args do
						local dist = (target.Character.HumanoidRootPart.Position - LPlrHrp.Position).Magnitude
						local aimpos = target.Character.HumanoidRootPart.Position + Vector3.new(math.random(-1000,1000)/1000,math.random(-1000,1000)/1000,math.random(-1000,1000)/1000) * dist / 4
						local raycast = workspace:Raycast(LPlrHrp.Position,aimpos - LPlrHrp.Position,params)
						if raycast then
							v[2] = raycast.Position
						end
					end
				else
					args[2] = target.Character.HumanoidRootPart.Position + Vector3.new(0,math.random(-1000,2500)/1000,0)
				end
				]]
					if raycast then
						return Ray.new(self.Origin, (raycast.Position - self.Origin).Unit)
					end
				end
			end
		end
	end
	return oldindex(self,idx)
end))
if typeof(Vector3) == Enum.KeyCode then
	
end
