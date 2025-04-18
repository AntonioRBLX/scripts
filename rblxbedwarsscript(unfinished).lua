-- Variables --

local Configs = {
	ProjAimbot = {
		Enabled = false;
		OnlyBow = false;
	};
	AutoBedDefense = {
		CleanBedDefense = false;
		Layer1 = "";
		Layer2 = "";
		Layer3 = "";
		Layer4 = "";
		Layer5 = "";
		Layer6 = "";
		Layer7 = "";
	}
}
local blocks = {"","Wool","Obsidian","Ceramic","Wood Planks"}

------------------------------------------------
-- Functions --

function getbeddeflayers(layers)
	local count = 2 + 4 * layers
	local blocks = 0
	repeat
		blocks += count
		count -= 4
	until count < 2
	return blocks
end
function placeblock(blocktype,pos)
	
end

------------------------------------------------
-- Library --

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wizard"))()

local MainWindow = Library:NewWindow("Bedwars OP Cheats")

-- Aimbot Section
local AimbotSection = MainWindow:NewSection("Aimbot")
AimbotSection:CreateToggle("Projectile Aimbot", function(value)
	Configs.ProjAimbot.Enabled = value
end)
AimbotSection:CreateToggle("Bows Only", function(value)
	Configs.ProjAimbot.OnlyBow = value
end)

-- Build Section
local BuildSection = MainWindow:NewSection("Build")
BuildSection:CreateButton("Create Bed Defense", function()
	print(Configs.AutoBedDefense)
end)
BuildSection:CreateToggle("Clean Bed Defense", function(value)
	Configs.AutoBedDefense.CleanBedDefense = value
end)
BuildSection:CreateToggle("Auto Move", function(value)
	Configs.AutoBedDefense.CleanBedDefense = value
end)
BuildSection:CreateDropdown("Layer1 ("..getbeddeflayers(1).." Blocks)", blocks, 1, function(option)
	Configs.AutoBedDefense.Layer1 = option
end)
BuildSection:CreateDropdown("Layer2 ("..getbeddeflayers(2).." Blocks)", blocks, 1, function(option)
	Configs.AutoBedDefense.Layer2 = option
end)
BuildSection:CreateDropdown("Layer3 ("..getbeddeflayers(3).." Blocks)", blocks, 1, function(option)
	Configs.AutoBedDefense.Layer3 = option
end)
BuildSection:CreateDropdown("Layer4 ("..getbeddeflayers(4).." Blocks)", blocks, 1, function(option)
	Configs.AutoBedDefense.Layer4 = option
end)
BuildSection:CreateDropdown("Layer5 ("..getbeddeflayers(5).." Blocks)", blocks, 1, function(option)
	Configs.AutoBedDefense.Layer5 = option
end)
BuildSection:CreateDropdown("Layer6 ("..getbeddeflayers(6).." Blocks)", blocks, 1, function(option)
	Configs.AutoBedDefense.Layer6 = option
end)
BuildSection:CreateDropdown("Layer7 ("..getbeddeflayers(7).." Blocks)", blocks, 1, function(option)
	Configs.AutoBedDefense.Layer6 = option
end)
