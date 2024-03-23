repeat task.wait() until game.Players.LocalPlayer

local lplr = game.Players.LocalPlayer
local char = lplr.Character or lplr.CharacterAdded:Wait()

local anims = {
	idle1 = "http://www.roblox.com/asset/?id=910004836";
	idle2 = "http://www.roblox.com/asset/?id=910009958";
	walk = "http://www.roblox.com/asset/?id=910034870";
	run =  "http://www.roblox.com/asset/?id=910025107";
	swim = "http://www.roblox.com/asset/?id=910028158";
	swimidle = "http://www.roblox.com/asset/?id=910030921";
	jump = "http://www.roblox.com/asset/?id=5319841935";
	fall = "http://www.roblox.com/asset/?id=5319839762";
	climb = "http://www.roblox.com/asset/?id=5319816685";
}

function addanims(char)
	local char = lplr.Character
	if char then
		local animatescript = char:WaitForChild("Animate")
		if animatescript then
			local idle = animatescript:WaitForChild("idle")
			local walk = animatescript:WaitForChild("walk")
			local run = animatescript:WaitForChild("run")
			local swim = animatescript:WaitForChild("swim")
			local swimidle = animatescript:WaitForChild("swimidle")
			local jump = animatescript:WaitForChild("jump")
			local fall = animatescript:WaitForChild("fall")
			local climb = animatescript:WaitForChild("climb")

			if idle and walk and run and swim and swimidle and jump and fall and climb then
				local IdleAnim1 = idle:WaitForChild("Animation1")
				local IdleAnim2 = idle:WaitForChild("Animation2")
				if IdleAnim1 and IdleAnim2 then
					IdleAnim1.AnimationId = anims.idle1
					IdleAnim2.AnimationId = anims.idle2
				end
				local WalkAnim = walk:WaitForChild("WalkAnim")
				if WalkAnim then
					WalkAnim.AnimationId = anims.walk
				end
				local RunAnim = run:WaitForChild("RunAnim")
				if RunAnim then
					RunAnim.AnimationId = anims.run
				end
				local SwimAnim = swim:WaitForChild("Swim")
				if SwimAnim then
					SwimAnim.AnimationId = anims.swim
				end
				local SwimIdleAnim = swimidle:WaitForChild("SwimIdle")
				if SwimIdleAnim then
					SwimIdleAnim.AnimationId = anims.swimidle
				end
				local JumpAnim = jump:WaitForChild("JumpAnim")
				if JumpAnim then
					JumpAnim.AnimationId = anims.jump
				end
				local FallAnim = fall:WaitForChild("FallAnim")
				if FallAnim then
					FallAnim.AnimationId = anims.fall
				end
				local ClimbAnim = climb:WaitForChild("ClimbAnim")
				if ClimbAnim then
					ClimbAnim.AnimationId = anims.climb
				end
			end
		end
	end
end

addanims(char)

lplr.CharacterAdded:Connect(function(char)
	addanims(char)
end)
