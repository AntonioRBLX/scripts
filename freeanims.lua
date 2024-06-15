local MarketplaceService = game:GetService("MarketplaceService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

repeat task.wait() until Players.LocalPlayer

local lplr = Players.LocalPlayer
local mouse = lplr:GetMouse()
local lplrchar = lplr.Character or lplr.CharacterAdded:Wait()

-- Gui to Lua
-- Version: 3.2

-- Instances:

local ScreenGui = Instance.new("ScreenGui")
local Title = Instance.new("TextLabel")
local Animations = Instance.new("Frame")
local Container = Instance.new("Frame")
local UIListLayout = Instance.new("UIListLayout")
local Superhero = Instance.new("TextButton")
local SuperheroUICorner = Instance.new("UICorner")
local SuperheroOutline = Instance.new("Frame")
local SuperheroOutlineUICorner = Instance.new("UICorner")
local Levitation = Instance.new("TextButton")
local LevitationUICorner = Instance.new("UICorner")
local LevitationOutline = Instance.new("Frame")
local LevitationOutlineUICorner = Instance.new("UICorner")
local Rthro = Instance.new("TextButton")
local RthroUICorner = Instance.new("UICorner")
local RthroOutline = Instance.new("Frame")
local RthroOutlineUICorner = Instance.new("UICorner")
local RBLXAnimationsSeparator = Instance.new("TextLabel")
local Toy = Instance.new("TextButton")
local ToyUICorner = Instance.new("UICorner")
local ToyOutline = Instance.new("Frame")
local ToyOutlineUICorner = Instance.new("UICorner")
local Vampire = Instance.new("TextButton")
local VampireUICorner = Instance.new("UICorner")
local VampireOutline = Instance.new("Frame")
local VampireOutlineUICorner = Instance.new("UICorner")
local Mage = Instance.new("TextButton")
local MageUICorner = Instance.new("UICorner")
local MageOutline = Instance.new("Frame")
local MageOutlineUICorner = Instance.new("UICorner")
local Bubbly = Instance.new("TextButton")
local BubblyUICorner = Instance.new("UICorner")
local BubblyOutline = Instance.new("Frame")
local BubblyOutlineUICorner = Instance.new("UICorner")
local Ninja = Instance.new("TextButton")
local NinjaUICorner = Instance.new("UICorner")
local NinjaOutline = Instance.new("Frame")
local NinjaOutlineUICorner = Instance.new("UICorner")
local Cartoony = Instance.new("TextButton")
local CartoonyUICorner = Instance.new("UICorner")
local CartoonyOutline = Instance.new("Frame")
local CartoonyOutlineUICorner = Instance.new("UICorner")
local Bold = Instance.new("TextButton")
local BoldUICorner = Instance.new("UICorner")
local BoldOutline = Instance.new("Frame")
local BoldOutlineUICorner = Instance.new("UICorner")
local Stylish = Instance.new("TextButton")
local StylishUICorner = Instance.new("UICorner")
local StylishOutline = Instance.new("Frame")
local StylishOutlineUICorner = Instance.new("UICorner")
local Zombie = Instance.new("TextButton")
local ZombieUICorner = Instance.new("UICorner")
local ZombieOutline = Instance.new("Frame")
local ZombieOutlineUICorner = Instance.new("UICorner")
local Elder = Instance.new("TextButton")
local ElderUICorner = Instance.new("UICorner")
local ElderOutline = Instance.new("Frame")
local ElderOutlineUICorner = Instance.new("UICorner")
local Pirate = Instance.new("TextButton")
local PirateUICorner = Instance.new("UICorner")
local PirateOutline = Instance.new("Frame")
local PirateOutlineUICorner = Instance.new("UICorner")
local Knight = Instance.new("TextButton")
local KnightUICorner = Instance.new("UICorner")
local KnightOutline = Instance.new("Frame")
local KnightOutlineUICorner = Instance.new("UICorner")
local FakeR6 = Instance.new("TextButton")
local FakeR6UICorner = Instance.new("UICorner")
local FakeR6Outline = Instance.new("Frame")
local FakeR6OutlineUICorner = Instance.new("UICorner")
local GirlCombo1 = Instance.new("TextButton")
local GirlCombo1UICorner = Instance.new("UICorner")
local GirlCombo1Outline = Instance.new("Frame")
local GirlCombo1OutlineUICorner = Instance.new("UICorner")
local Werewolf = Instance.new("TextButton")
local WerewolfUICorner = Instance.new("UICorner")
local WerewolfOutline = Instance.new("Frame")
local WerewolfOutlineUICorner = Instance.new("UICorner")
local OldSchool = Instance.new("TextButton")
local OldSchoolUICorner = Instance.new("UICorner")
local OldSchoolOutline = Instance.new("Frame")
local OldSchoolOutlineUICorner = Instance.new("UICorner")
local CombosSeparator = Instance.new("TextLabel")
local Astronaut = Instance.new("TextButton")
local AstronautUICorner = Instance.new("UICorner")
local AstronautOutline = Instance.new("Frame")
local AstronautOutlineUICorner = Instance.new("UICorner")
local BoyCombo = Instance.new("TextButton")
local BoyComboUICorner = Instance.new("UICorner")
local BoyComboOutline = Instance.new("Frame")
local BoyComboOutlineUICorner = Instance.new("UICorner")
local CombosSeparator_2 = Instance.new("TextLabel")
local TryhardCombo1 = Instance.new("TextButton")
local TryhardCombo1UICorner = Instance.new("UICorner")
local TryhardCombo1Outline = Instance.new("Frame")
local TryhardCombo1OutlineUICorner = Instance.new("UICorner")
local TryhardCombo3 = Instance.new("TextButton")
local TryhardCombo3UICorner = Instance.new("UICorner")
local TryhardCombo3Outline = Instance.new("Frame")
local TryhardCombo3OutlineUICorner = Instance.new("UICorner")
local TryhardCombo4 = Instance.new("TextButton")
local TryhardCombo4UICorner = Instance.new("UICorner")
local TryhardCombo4Outline = Instance.new("Frame")
local TryhardCombo4OutlineUICorner = Instance.new("UICorner")
local GirlCombo2 = Instance.new("TextButton")
local GirlCombo2UICorner = Instance.new("UICorner")
local GirlCombo2Outline = Instance.new("Frame")
local GirlCombo2OutlineUICorner = Instance.new("UICorner")
local TryhardCombo2 = Instance.new("TextButton")
local TryhardCombo2UICorner = Instance.new("UICorner")
local TryhardCombo2Outline = Instance.new("Frame")
local TryhardCombo2OutlineUICorner = Instance.new("UICorner")
local Walk = Instance.new("TextBox")
local WalkUICorner = Instance.new("UICorner")
local WalkOutline = Instance.new("Frame")
local WalkOutlineUICorner = Instance.new("UICorner")
local Run = Instance.new("TextBox")
local RunUICorner = Instance.new("UICorner")
local RunOutline = Instance.new("Frame")
local RunOutlineUICorner = Instance.new("UICorner")
local SwimIdle = Instance.new("TextBox")
local SwimIdleUICorner = Instance.new("UICorner")
local SwimIdleOutline = Instance.new("Frame")
local SwimIdleOutlineUICorner = Instance.new("UICorner")
local Idle1 = Instance.new("TextBox")
local Idle1UICorner = Instance.new("UICorner")
local Idle1Outline = Instance.new("Frame")
local Idle1OutlineUICorner = Instance.new("UICorner")
local Idle2 = Instance.new("TextBox")
local Idle2UICorner = Instance.new("UICorner")
local Idle2Outline = Instance.new("Frame")
local Idle2OutlineUICorner = Instance.new("UICorner")
local Fall = Instance.new("TextBox")
local FallUICorner = Instance.new("UICorner")
local FallOutline = Instance.new("Frame")
local FallOutlineUICorner = Instance.new("UICorner")
local Jump = Instance.new("TextBox")
local JumpUICorner = Instance.new("UICorner")
local JumpOutline = Instance.new("Frame")
local JumpOutlineUICorner = Instance.new("UICorner")
local Climb = Instance.new("TextBox")
local ClimbUICorner = Instance.new("UICorner")
local ClimbOutline = Instance.new("Frame")
local ClimbOutlineUICorner = Instance.new("UICorner")
local Swim = Instance.new("TextBox")
local SwimUICorner = Instance.new("UICorner")
local SwimOutline = Instance.new("Frame")
local SwimOutlineUICorner = Instance.new("UICorner")

--Properties:

ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

Title.Name = "Title"
Title.Parent = ScreenGui
Title.BackgroundColor3 = Color3.fromRGB(81, 81, 81)
Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
Title.BorderSizePixel = 0
Title.Position = UDim2.new(0, 15, 0, 15)
Title.Size = UDim2.new(0, 100, 0, 25)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "FE Free Animations <stroke color=\"#1F1F1F\"><font color=\"rgb(171,171,171)\">By CITY512</font></stroke>"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 13.000
Title.TextStrokeTransparency = 0.000
Title.TextWrapped = true
Title.TextYAlignment = Enum.TextYAlignment.Top
Title.RichText = true

Animations.Name = "Animations"
Animations.Parent = Title
Animations.BackgroundColor3 = Color3.fromRGB(81, 81, 81)
Animations.BorderColor3 = Color3.fromRGB(0, 0, 0)
Animations.BorderSizePixel = 0
Animations.Position = UDim2.new(0, 0, 1, 0)
Animations.Size = UDim2.new(0, 100, 0, 575)
Animations.ZIndex = 2

Container.Name = "Container"
Container.Parent = Animations
Container.AnchorPoint = Vector2.new(0.5, 0.5)
Container.BackgroundColor3 = Color3.fromRGB(81, 81, 81)
Container.BackgroundTransparency = 1.000
Container.BorderColor3 = Color3.fromRGB(0, 0, 0)
Container.BorderSizePixel = 0
Container.Position = UDim2.new(0.5, 0, 0.5, 0)
Container.Size = UDim2.new(1, -20, 1, -10)
Container.ZIndex = 3

UIListLayout.Parent = Container
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 3)

Superhero.Name = "Superhero"
Superhero.Parent = Container
Superhero.BackgroundColor3 = Color3.fromRGB(97, 97, 97)
Superhero.BorderColor3 = Color3.fromRGB(31, 31, 31)
Superhero.LayoutOrder = 2
Superhero.Position = UDim2.new(0, 0, 0.0903614461, 0)
Superhero.Size = UDim2.new(1, 0, 0, 12)
Superhero.ZIndex = 5
Superhero.AutoButtonColor = false
Superhero.Font = Enum.Font.SourceSansBold
Superhero.Text = "Superhero"
Superhero.TextColor3 = Color3.fromRGB(255, 255, 255)
Superhero.TextScaled = true
Superhero.TextSize = 13.000
Superhero.TextStrokeTransparency = 0.000
Superhero.TextWrapped = true

SuperheroUICorner.CornerRadius = UDim.new(0, 4)
SuperheroUICorner.Name = "Superhero UICorner"
SuperheroUICorner.Parent = Superhero

SuperheroOutline.Name = "Superhero Outline"
SuperheroOutline.Parent = Superhero
SuperheroOutline.AnchorPoint = Vector2.new(0.5, 0.5)
SuperheroOutline.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
SuperheroOutline.Position = UDim2.new(0.5, 0, 0.5, 0)
SuperheroOutline.Size = UDim2.new(1, 2, 1, 2)
SuperheroOutline.ZIndex = 4

SuperheroOutlineUICorner.CornerRadius = UDim.new(0, 4)
SuperheroOutlineUICorner.Name = "Superhero Outline UICorner"
SuperheroOutlineUICorner.Parent = SuperheroOutline

Levitation.Name = "Levitation"
Levitation.Parent = Container
Levitation.BackgroundColor3 = Color3.fromRGB(97, 97, 97)
Levitation.BorderColor3 = Color3.fromRGB(31, 31, 31)
Levitation.LayoutOrder = 3
Levitation.Position = UDim2.new(0, 0, 0.0903614461, 0)
Levitation.Size = UDim2.new(1, 0, 0, 12)
Levitation.ZIndex = 5
Levitation.AutoButtonColor = false
Levitation.Font = Enum.Font.SourceSansBold
Levitation.Text = "Levitation"
Levitation.TextColor3 = Color3.fromRGB(255, 255, 255)
Levitation.TextScaled = true
Levitation.TextSize = 13.000
Levitation.TextStrokeTransparency = 0.000
Levitation.TextWrapped = true

LevitationUICorner.CornerRadius = UDim.new(0, 4)
LevitationUICorner.Name = "Levitation UICorner"
LevitationUICorner.Parent = Levitation

LevitationOutline.Name = "Levitation Outline"
LevitationOutline.Parent = Levitation
LevitationOutline.AnchorPoint = Vector2.new(0.5, 0.5)
LevitationOutline.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
LevitationOutline.Position = UDim2.new(0.5, 0, 0.5, 0)
LevitationOutline.Size = UDim2.new(1, 2, 1, 2)
LevitationOutline.ZIndex = 4

LevitationOutlineUICorner.CornerRadius = UDim.new(0, 4)
LevitationOutlineUICorner.Name = "Levitation Outline UICorner"
LevitationOutlineUICorner.Parent = LevitationOutline

Rthro.Name = "Rthro"
Rthro.Parent = Container
Rthro.BackgroundColor3 = Color3.fromRGB(97, 97, 97)
Rthro.BorderColor3 = Color3.fromRGB(31, 31, 31)
Rthro.LayoutOrder = 1
Rthro.Position = UDim2.new(0, 0, 0.0903614461, 0)
Rthro.Size = UDim2.new(1, 0, 0, 12)
Rthro.ZIndex = 5
Rthro.AutoButtonColor = false
Rthro.Font = Enum.Font.SourceSansBold
Rthro.Text = "Rthro"
Rthro.TextColor3 = Color3.fromRGB(255, 255, 255)
Rthro.TextScaled = true
Rthro.TextSize = 13.000
Rthro.TextStrokeTransparency = 0.000
Rthro.TextWrapped = true

RthroUICorner.CornerRadius = UDim.new(0, 4)
RthroUICorner.Name = "Rthro UICorner"
RthroUICorner.Parent = Rthro

RthroOutline.Name = "Rthro Outline"
RthroOutline.Parent = Rthro
RthroOutline.AnchorPoint = Vector2.new(0.5, 0.5)
RthroOutline.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
RthroOutline.Position = UDim2.new(0.5, 0, 0.5, 0)
RthroOutline.Size = UDim2.new(1, 2, 1, 2)
RthroOutline.ZIndex = 4

RthroOutlineUICorner.CornerRadius = UDim.new(0, 4)
RthroOutlineUICorner.Name = "Rthro Outline UICorner"
RthroOutlineUICorner.Parent = RthroOutline

RBLXAnimationsSeparator.Name = "RBLX Animations Separator"
RBLXAnimationsSeparator.Parent = Container
RBLXAnimationsSeparator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
RBLXAnimationsSeparator.BackgroundTransparency = 1.000
RBLXAnimationsSeparator.BorderColor3 = Color3.fromRGB(0, 0, 0)
RBLXAnimationsSeparator.BorderSizePixel = 0
RBLXAnimationsSeparator.Size = UDim2.new(1, 0, 0, 15)
RBLXAnimationsSeparator.ZIndex = 5
RBLXAnimationsSeparator.Font = Enum.Font.SourceSansSemibold
RBLXAnimationsSeparator.Text = "Roblox Animations"
RBLXAnimationsSeparator.TextColor3 = Color3.fromRGB(255, 255, 255)
RBLXAnimationsSeparator.TextSize = 13.000
RBLXAnimationsSeparator.TextStrokeTransparency = 0.000

Toy.Name = "Toy"
Toy.Parent = Container
Toy.BackgroundColor3 = Color3.fromRGB(97, 97, 97)
Toy.BorderColor3 = Color3.fromRGB(31, 31, 31)
Toy.LayoutOrder = 4
Toy.Position = UDim2.new(0, 0, 0.0903614461, 0)
Toy.Size = UDim2.new(1, 0, 0, 12)
Toy.ZIndex = 5
Toy.AutoButtonColor = false
Toy.Font = Enum.Font.SourceSansBold
Toy.Text = "Toy"
Toy.TextColor3 = Color3.fromRGB(255, 255, 255)
Toy.TextScaled = true
Toy.TextSize = 13.000
Toy.TextStrokeTransparency = 0.000
Toy.TextWrapped = true

ToyUICorner.CornerRadius = UDim.new(0, 4)
ToyUICorner.Name = "Toy UICorner"
ToyUICorner.Parent = Toy

ToyOutline.Name = "Toy Outline"
ToyOutline.Parent = Toy
ToyOutline.AnchorPoint = Vector2.new(0.5, 0.5)
ToyOutline.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
ToyOutline.Position = UDim2.new(0.5, 0, 0.5, 0)
ToyOutline.Size = UDim2.new(1, 2, 1, 2)
ToyOutline.ZIndex = 4

ToyOutlineUICorner.CornerRadius = UDim.new(0, 4)
ToyOutlineUICorner.Name = "Toy Outline UICorner"
ToyOutlineUICorner.Parent = ToyOutline

Vampire.Name = "Vampire"
Vampire.Parent = Container
Vampire.BackgroundColor3 = Color3.fromRGB(97, 97, 97)
Vampire.BorderColor3 = Color3.fromRGB(31, 31, 31)
Vampire.LayoutOrder = 5
Vampire.Position = UDim2.new(0, 0, 0.0903614461, 0)
Vampire.Size = UDim2.new(1, 0, 0, 12)
Vampire.ZIndex = 5
Vampire.AutoButtonColor = false
Vampire.Font = Enum.Font.SourceSansBold
Vampire.Text = "Vampire"
Vampire.TextColor3 = Color3.fromRGB(255, 255, 255)
Vampire.TextScaled = true
Vampire.TextSize = 13.000
Vampire.TextStrokeTransparency = 0.000
Vampire.TextWrapped = true

VampireUICorner.CornerRadius = UDim.new(0, 4)
VampireUICorner.Name = "Vampire UICorner"
VampireUICorner.Parent = Vampire

VampireOutline.Name = "Vampire Outline"
VampireOutline.Parent = Vampire
VampireOutline.AnchorPoint = Vector2.new(0.5, 0.5)
VampireOutline.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
VampireOutline.Position = UDim2.new(0.5, 0, 0.5, 0)
VampireOutline.Size = UDim2.new(1, 2, 1, 2)
VampireOutline.ZIndex = 4

VampireOutlineUICorner.CornerRadius = UDim.new(0, 4)
VampireOutlineUICorner.Name = "Vampire Outline UICorner"
VampireOutlineUICorner.Parent = VampireOutline

Mage.Name = "Mage"
Mage.Parent = Container
Mage.BackgroundColor3 = Color3.fromRGB(97, 97, 97)
Mage.BorderColor3 = Color3.fromRGB(31, 31, 31)
Mage.LayoutOrder = 6
Mage.Position = UDim2.new(0, 0, 0.0903614461, 0)
Mage.Size = UDim2.new(1, 0, 0, 12)
Mage.ZIndex = 5
Mage.AutoButtonColor = false
Mage.Font = Enum.Font.SourceSansBold
Mage.Text = "Mage"
Mage.TextColor3 = Color3.fromRGB(255, 255, 255)
Mage.TextScaled = true
Mage.TextSize = 13.000
Mage.TextStrokeTransparency = 0.000
Mage.TextWrapped = true

MageUICorner.CornerRadius = UDim.new(0, 4)
MageUICorner.Name = "Mage UICorner"
MageUICorner.Parent = Mage

MageOutline.Name = "Mage Outline"
MageOutline.Parent = Mage
MageOutline.AnchorPoint = Vector2.new(0.5, 0.5)
MageOutline.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
MageOutline.Position = UDim2.new(0.5, 0, 0.5, 0)
MageOutline.Size = UDim2.new(1, 2, 1, 2)
MageOutline.ZIndex = 4

MageOutlineUICorner.CornerRadius = UDim.new(0, 4)
MageOutlineUICorner.Name = "Mage Outline UICorner"
MageOutlineUICorner.Parent = MageOutline

Bubbly.Name = "Bubbly"
Bubbly.Parent = Container
Bubbly.BackgroundColor3 = Color3.fromRGB(97, 97, 97)
Bubbly.BorderColor3 = Color3.fromRGB(31, 31, 31)
Bubbly.LayoutOrder = 7
Bubbly.Position = UDim2.new(0, 0, 0.0903614461, 0)
Bubbly.Size = UDim2.new(1, 0, 0, 12)
Bubbly.ZIndex = 5
Bubbly.AutoButtonColor = false
Bubbly.Font = Enum.Font.SourceSansBold
Bubbly.Text = "Bubbly"
Bubbly.TextColor3 = Color3.fromRGB(255, 255, 255)
Bubbly.TextScaled = true
Bubbly.TextSize = 13.000
Bubbly.TextStrokeTransparency = 0.000
Bubbly.TextWrapped = true

BubblyUICorner.CornerRadius = UDim.new(0, 4)
BubblyUICorner.Name = "Bubbly UICorner"
BubblyUICorner.Parent = Bubbly

BubblyOutline.Name = "Bubbly Outline"
BubblyOutline.Parent = Bubbly
BubblyOutline.AnchorPoint = Vector2.new(0.5, 0.5)
BubblyOutline.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
BubblyOutline.Position = UDim2.new(0.5, 0, 0.5, 0)
BubblyOutline.Size = UDim2.new(1, 2, 1, 2)
BubblyOutline.ZIndex = 4

BubblyOutlineUICorner.CornerRadius = UDim.new(0, 4)
BubblyOutlineUICorner.Name = "Bubbly Outline UICorner"
BubblyOutlineUICorner.Parent = BubblyOutline

Ninja.Name = "Ninja"
Ninja.Parent = Container
Ninja.BackgroundColor3 = Color3.fromRGB(97, 97, 97)
Ninja.BorderColor3 = Color3.fromRGB(31, 31, 31)
Ninja.LayoutOrder = 8
Ninja.Position = UDim2.new(0, 0, 0.0903614461, 0)
Ninja.Size = UDim2.new(1, 0, 0, 12)
Ninja.ZIndex = 5
Ninja.AutoButtonColor = false
Ninja.Font = Enum.Font.SourceSansBold
Ninja.Text = "Ninja"
Ninja.TextColor3 = Color3.fromRGB(255, 255, 255)
Ninja.TextScaled = true
Ninja.TextSize = 13.000
Ninja.TextStrokeTransparency = 0.000
Ninja.TextWrapped = true

NinjaUICorner.CornerRadius = UDim.new(0, 4)
NinjaUICorner.Name = "Ninja UICorner"
NinjaUICorner.Parent = Ninja

NinjaOutline.Name = "Ninja Outline"
NinjaOutline.Parent = Ninja
NinjaOutline.AnchorPoint = Vector2.new(0.5, 0.5)
NinjaOutline.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
NinjaOutline.Position = UDim2.new(0.5, 0, 0.5, 0)
NinjaOutline.Size = UDim2.new(1, 2, 1, 2)
NinjaOutline.ZIndex = 4

NinjaOutlineUICorner.CornerRadius = UDim.new(0, 4)
NinjaOutlineUICorner.Name = "Ninja Outline UICorner"
NinjaOutlineUICorner.Parent = NinjaOutline

Cartoony.Name = "Cartoony"
Cartoony.Parent = Container
Cartoony.BackgroundColor3 = Color3.fromRGB(97, 97, 97)
Cartoony.BorderColor3 = Color3.fromRGB(31, 31, 31)
Cartoony.LayoutOrder = 9
Cartoony.Position = UDim2.new(0, 0, 0.0903614461, 0)
Cartoony.Size = UDim2.new(1, 0, 0, 12)
Cartoony.ZIndex = 5
Cartoony.AutoButtonColor = false
Cartoony.Font = Enum.Font.SourceSansBold
Cartoony.Text = "Cartoony"
Cartoony.TextColor3 = Color3.fromRGB(255, 255, 255)
Cartoony.TextScaled = true
Cartoony.TextSize = 13.000
Cartoony.TextStrokeTransparency = 0.000
Cartoony.TextWrapped = true

CartoonyUICorner.CornerRadius = UDim.new(0, 4)
CartoonyUICorner.Name = "Cartoony UICorner"
CartoonyUICorner.Parent = Cartoony

CartoonyOutline.Name = "Cartoony Outline"
CartoonyOutline.Parent = Cartoony
CartoonyOutline.AnchorPoint = Vector2.new(0.5, 0.5)
CartoonyOutline.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
CartoonyOutline.Position = UDim2.new(0.5, 0, 0.5, 0)
CartoonyOutline.Size = UDim2.new(1, 2, 1, 2)
CartoonyOutline.ZIndex = 4

CartoonyOutlineUICorner.CornerRadius = UDim.new(0, 4)
CartoonyOutlineUICorner.Name = "Cartoony Outline UICorner"
CartoonyOutlineUICorner.Parent = CartoonyOutline

Bold.Name = "Bold"
Bold.Parent = Container
Bold.BackgroundColor3 = Color3.fromRGB(97, 97, 97)
Bold.BorderColor3 = Color3.fromRGB(31, 31, 31)
Bold.LayoutOrder = 10
Bold.Position = UDim2.new(0, 0, 0.0903614461, 0)
Bold.Size = UDim2.new(1, 0, 0, 12)
Bold.ZIndex = 5
Bold.AutoButtonColor = false
Bold.Font = Enum.Font.SourceSansBold
Bold.Text = "Bold"
Bold.TextColor3 = Color3.fromRGB(255, 255, 255)
Bold.TextScaled = true
Bold.TextSize = 13.000
Bold.TextStrokeTransparency = 0.000
Bold.TextWrapped = true

BoldUICorner.CornerRadius = UDim.new(0, 4)
BoldUICorner.Name = "Bold UICorner"
BoldUICorner.Parent = Bold

BoldOutline.Name = "Bold Outline"
BoldOutline.Parent = Bold
BoldOutline.AnchorPoint = Vector2.new(0.5, 0.5)
BoldOutline.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
BoldOutline.Position = UDim2.new(0.5, 0, 0.5, 0)
BoldOutline.Size = UDim2.new(1, 2, 1, 2)
BoldOutline.ZIndex = 4

BoldOutlineUICorner.CornerRadius = UDim.new(0, 4)
BoldOutlineUICorner.Name = "Bold Outline UICorner"
BoldOutlineUICorner.Parent = BoldOutline

Stylish.Name = "Stylish"
Stylish.Parent = Container
Stylish.BackgroundColor3 = Color3.fromRGB(97, 97, 97)
Stylish.BorderColor3 = Color3.fromRGB(31, 31, 31)
Stylish.LayoutOrder = 11
Stylish.Position = UDim2.new(0, 0, 0.0903614461, 0)
Stylish.Size = UDim2.new(1, 0, 0, 12)
Stylish.ZIndex = 5
Stylish.AutoButtonColor = false
Stylish.Font = Enum.Font.SourceSansBold
Stylish.Text = "Stylish"
Stylish.TextColor3 = Color3.fromRGB(255, 255, 255)
Stylish.TextScaled = true
Stylish.TextSize = 13.000
Stylish.TextStrokeTransparency = 0.000
Stylish.TextWrapped = true

StylishUICorner.CornerRadius = UDim.new(0, 4)
StylishUICorner.Name = "Stylish UICorner"
StylishUICorner.Parent = Stylish

StylishOutline.Name = "Stylish Outline"
StylishOutline.Parent = Stylish
StylishOutline.AnchorPoint = Vector2.new(0.5, 0.5)
StylishOutline.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
StylishOutline.Position = UDim2.new(0.5, 0, 0.5, 0)
StylishOutline.Size = UDim2.new(1, 2, 1, 2)
StylishOutline.ZIndex = 4

StylishOutlineUICorner.CornerRadius = UDim.new(0, 4)
StylishOutlineUICorner.Name = "Stylish Outline UICorner"
StylishOutlineUICorner.Parent = StylishOutline

Zombie.Name = "Zombie"
Zombie.Parent = Container
Zombie.BackgroundColor3 = Color3.fromRGB(97, 97, 97)
Zombie.BorderColor3 = Color3.fromRGB(31, 31, 31)
Zombie.LayoutOrder = 12
Zombie.Position = UDim2.new(0, 0, 0.0903614461, 0)
Zombie.Size = UDim2.new(1, 0, 0, 12)
Zombie.ZIndex = 5
Zombie.AutoButtonColor = false
Zombie.Font = Enum.Font.SourceSansBold
Zombie.Text = "Zombie"
Zombie.TextColor3 = Color3.fromRGB(255, 255, 255)
Zombie.TextScaled = true
Zombie.TextSize = 13.000
Zombie.TextStrokeTransparency = 0.000
Zombie.TextWrapped = true

ZombieUICorner.CornerRadius = UDim.new(0, 4)
ZombieUICorner.Name = "Zombie UICorner"
ZombieUICorner.Parent = Zombie

ZombieOutline.Name = "Zombie Outline"
ZombieOutline.Parent = Zombie
ZombieOutline.AnchorPoint = Vector2.new(0.5, 0.5)
ZombieOutline.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
ZombieOutline.Position = UDim2.new(0.5, 0, 0.5, 0)
ZombieOutline.Size = UDim2.new(1, 2, 1, 2)
ZombieOutline.ZIndex = 4

ZombieOutlineUICorner.CornerRadius = UDim.new(0, 4)
ZombieOutlineUICorner.Name = "Zombie Outline UICorner"
ZombieOutlineUICorner.Parent = ZombieOutline

Elder.Name = "Elder"
Elder.Parent = Container
Elder.BackgroundColor3 = Color3.fromRGB(97, 97, 97)
Elder.BorderColor3 = Color3.fromRGB(31, 31, 31)
Elder.LayoutOrder = 13
Elder.Position = UDim2.new(0, 0, 0.0903614461, 0)
Elder.Size = UDim2.new(1, 0, 0, 12)
Elder.ZIndex = 5
Elder.AutoButtonColor = false
Elder.Font = Enum.Font.SourceSansBold
Elder.Text = "Elder"
Elder.TextColor3 = Color3.fromRGB(255, 255, 255)
Elder.TextScaled = true
Elder.TextSize = 13.000
Elder.TextStrokeTransparency = 0.000
Elder.TextWrapped = true

ElderUICorner.CornerRadius = UDim.new(0, 4)
ElderUICorner.Name = "Elder UICorner"
ElderUICorner.Parent = Elder

ElderOutline.Name = "Elder Outline"
ElderOutline.Parent = Elder
ElderOutline.AnchorPoint = Vector2.new(0.5, 0.5)
ElderOutline.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
ElderOutline.Position = UDim2.new(0.5, 0, 0.5, 0)
ElderOutline.Size = UDim2.new(1, 2, 1, 2)
ElderOutline.ZIndex = 4

ElderOutlineUICorner.CornerRadius = UDim.new(0, 4)
ElderOutlineUICorner.Name = "Elder Outline UICorner"
ElderOutlineUICorner.Parent = ElderOutline

Pirate.Name = "Pirate"
Pirate.Parent = Container
Pirate.BackgroundColor3 = Color3.fromRGB(97, 97, 97)
Pirate.BorderColor3 = Color3.fromRGB(31, 31, 31)
Pirate.LayoutOrder = 14
Pirate.Position = UDim2.new(0, 0, 0.0903614461, 0)
Pirate.Size = UDim2.new(1, 0, 0, 12)
Pirate.ZIndex = 5
Pirate.AutoButtonColor = false
Pirate.Font = Enum.Font.SourceSansBold
Pirate.Text = "Pirate"
Pirate.TextColor3 = Color3.fromRGB(255, 255, 255)
Pirate.TextScaled = true
Pirate.TextSize = 13.000
Pirate.TextStrokeTransparency = 0.000
Pirate.TextWrapped = true

PirateUICorner.CornerRadius = UDim.new(0, 4)
PirateUICorner.Name = "Pirate UICorner"
PirateUICorner.Parent = Pirate

PirateOutline.Name = "Pirate Outline"
PirateOutline.Parent = Pirate
PirateOutline.AnchorPoint = Vector2.new(0.5, 0.5)
PirateOutline.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
PirateOutline.Position = UDim2.new(0.5, 0, 0.5, 0)
PirateOutline.Size = UDim2.new(1, 2, 1, 2)
PirateOutline.ZIndex = 4

PirateOutlineUICorner.CornerRadius = UDim.new(0, 4)
PirateOutlineUICorner.Name = "Pirate Outline UICorner"
PirateOutlineUICorner.Parent = PirateOutline

Knight.Name = "Knight"
Knight.Parent = Container
Knight.BackgroundColor3 = Color3.fromRGB(97, 97, 97)
Knight.BorderColor3 = Color3.fromRGB(31, 31, 31)
Knight.LayoutOrder = 15
Knight.Position = UDim2.new(0, 0, 0.0903614461, 0)
Knight.Size = UDim2.new(1, 0, 0, 12)
Knight.ZIndex = 5
Knight.AutoButtonColor = false
Knight.Font = Enum.Font.SourceSansBold
Knight.Text = "Knight"
Knight.TextColor3 = Color3.fromRGB(255, 255, 255)
Knight.TextScaled = true
Knight.TextSize = 13.000
Knight.TextStrokeTransparency = 0.000
Knight.TextWrapped = true

KnightUICorner.CornerRadius = UDim.new(0, 4)
KnightUICorner.Name = "Knight UICorner"
KnightUICorner.Parent = Knight

KnightOutline.Name = "Knight Outline"
KnightOutline.Parent = Knight
KnightOutline.AnchorPoint = Vector2.new(0.5, 0.5)
KnightOutline.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
KnightOutline.Position = UDim2.new(0.5, 0, 0.5, 0)
KnightOutline.Size = UDim2.new(1, 2, 1, 2)
KnightOutline.ZIndex = 4

KnightOutlineUICorner.CornerRadius = UDim.new(0, 4)
KnightOutlineUICorner.Name = "Knight Outline UICorner"
KnightOutlineUICorner.Parent = KnightOutline

FakeR6.Name = "FakeR6"
FakeR6.Parent = Container
FakeR6.BackgroundColor3 = Color3.fromRGB(97, 97, 97)
FakeR6.BorderColor3 = Color3.fromRGB(31, 31, 31)
FakeR6.LayoutOrder = 12
FakeR6.Position = UDim2.new(0, 0, 0.0903614461, 0)
FakeR6.Size = UDim2.new(1, 0, 0, 12)
FakeR6.ZIndex = 5
FakeR6.AutoButtonColor = false
FakeR6.Font = Enum.Font.SourceSansBold
FakeR6.Text = "FakeR6"
FakeR6.TextColor3 = Color3.fromRGB(255, 255, 255)
FakeR6.TextScaled = true
FakeR6.TextSize = 13.000
FakeR6.TextStrokeTransparency = 0.000
FakeR6.TextWrapped = true

FakeR6UICorner.CornerRadius = UDim.new(0, 4)
FakeR6UICorner.Name = "FakeR6 UICorner"
FakeR6UICorner.Parent = FakeR6

FakeR6Outline.Name = "FakeR6 Outline"
FakeR6Outline.Parent = FakeR6
FakeR6Outline.AnchorPoint = Vector2.new(0.5, 0.5)
FakeR6Outline.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
FakeR6Outline.Position = UDim2.new(0.5, 0, 0.5, 0)
FakeR6Outline.Size = UDim2.new(1, 2, 1, 2)
FakeR6Outline.ZIndex = 4

FakeR6OutlineUICorner.CornerRadius = UDim.new(0, 4)
FakeR6OutlineUICorner.Name = "FakeR6 Outline UICorner"
FakeR6OutlineUICorner.Parent = FakeR6Outline

GirlCombo1.Name = "Girl Combo #1"
GirlCombo1.Parent = Container
GirlCombo1.BackgroundColor3 = Color3.fromRGB(97, 97, 97)
GirlCombo1.BorderColor3 = Color3.fromRGB(31, 31, 31)
GirlCombo1.LayoutOrder = 21
GirlCombo1.Position = UDim2.new(0, 0, 0.0903614461, 0)
GirlCombo1.Size = UDim2.new(1, 0, 0, 12)
GirlCombo1.ZIndex = 5
GirlCombo1.AutoButtonColor = false
GirlCombo1.Font = Enum.Font.SourceSansBold
GirlCombo1.Text = "Girl Combo #1"
GirlCombo1.TextColor3 = Color3.fromRGB(255, 255, 255)
GirlCombo1.TextScaled = true
GirlCombo1.TextSize = 13.000
GirlCombo1.TextStrokeTransparency = 0.000
GirlCombo1.TextWrapped = true

GirlCombo1UICorner.CornerRadius = UDim.new(0, 4)
GirlCombo1UICorner.Name = "Girl Combo #1 UICorner"
GirlCombo1UICorner.Parent = GirlCombo1

GirlCombo1Outline.Name = "Girl Combo #1 Outline"
GirlCombo1Outline.Parent = GirlCombo1
GirlCombo1Outline.AnchorPoint = Vector2.new(0.5, 0.5)
GirlCombo1Outline.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
GirlCombo1Outline.Position = UDim2.new(0.5, 0, 0.5, 0)
GirlCombo1Outline.Size = UDim2.new(1, 2, 1, 2)
GirlCombo1Outline.ZIndex = 4

GirlCombo1OutlineUICorner.CornerRadius = UDim.new(0, 4)
GirlCombo1OutlineUICorner.Name = "Girl Combo #1 Outline UICorner"
GirlCombo1OutlineUICorner.Parent = GirlCombo1Outline

Werewolf.Name = "Werewolf"
Werewolf.Parent = Container
Werewolf.BackgroundColor3 = Color3.fromRGB(97, 97, 97)
Werewolf.BorderColor3 = Color3.fromRGB(31, 31, 31)
Werewolf.LayoutOrder = 17
Werewolf.Position = UDim2.new(0, 0, 0.0903614461, 0)
Werewolf.Size = UDim2.new(1, 0, 0, 12)
Werewolf.ZIndex = 5
Werewolf.AutoButtonColor = false
Werewolf.Font = Enum.Font.SourceSansBold
Werewolf.Text = "Werewolf"
Werewolf.TextColor3 = Color3.fromRGB(255, 255, 255)
Werewolf.TextScaled = true
Werewolf.TextSize = 13.000
Werewolf.TextStrokeTransparency = 0.000
Werewolf.TextWrapped = true

WerewolfUICorner.CornerRadius = UDim.new(0, 4)
WerewolfUICorner.Name = "Werewolf UICorner"
WerewolfUICorner.Parent = Werewolf

WerewolfOutline.Name = "Werewolf Outline"
WerewolfOutline.Parent = Werewolf
WerewolfOutline.AnchorPoint = Vector2.new(0.5, 0.5)
WerewolfOutline.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
WerewolfOutline.Position = UDim2.new(0.5, 0, 0.5, 0)
WerewolfOutline.Size = UDim2.new(1, 2, 1, 2)
WerewolfOutline.ZIndex = 4

WerewolfOutlineUICorner.CornerRadius = UDim.new(0, 4)
WerewolfOutlineUICorner.Name = "Werewolf Outline UICorner"
WerewolfOutlineUICorner.Parent = WerewolfOutline

OldSchool.Name = "Old School"
OldSchool.Parent = Container
OldSchool.BackgroundColor3 = Color3.fromRGB(97, 97, 97)
OldSchool.BorderColor3 = Color3.fromRGB(31, 31, 31)
OldSchool.LayoutOrder = 18
OldSchool.Position = UDim2.new(0, 0, 0.0903614461, 0)
OldSchool.Size = UDim2.new(1, 0, 0, 12)
OldSchool.ZIndex = 5
OldSchool.AutoButtonColor = false
OldSchool.Font = Enum.Font.SourceSansBold
OldSchool.Text = "Old School"
OldSchool.TextColor3 = Color3.fromRGB(255, 255, 255)
OldSchool.TextScaled = true
OldSchool.TextSize = 13.000
OldSchool.TextStrokeTransparency = 0.000
OldSchool.TextWrapped = true

OldSchoolUICorner.CornerRadius = UDim.new(0, 4)
OldSchoolUICorner.Name = "Old School UICorner"
OldSchoolUICorner.Parent = OldSchool

OldSchoolOutline.Name = "Old School Outline"
OldSchoolOutline.Parent = OldSchool
OldSchoolOutline.AnchorPoint = Vector2.new(0.5, 0.5)
OldSchoolOutline.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
OldSchoolOutline.Position = UDim2.new(0.5, 0, 0.5, 0)
OldSchoolOutline.Size = UDim2.new(1, 2, 1, 2)
OldSchoolOutline.ZIndex = 4

OldSchoolOutlineUICorner.CornerRadius = UDim.new(0, 4)
OldSchoolOutlineUICorner.Name = "Old School Outline UICorner"
OldSchoolOutlineUICorner.Parent = OldSchoolOutline

CombosSeparator.Name = "Combos Separator"
CombosSeparator.Parent = Container
CombosSeparator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CombosSeparator.BackgroundTransparency = 1.000
CombosSeparator.BorderColor3 = Color3.fromRGB(0, 0, 0)
CombosSeparator.BorderSizePixel = 0
CombosSeparator.LayoutOrder = 19
CombosSeparator.Size = UDim2.new(1, 0, 0, 15)
CombosSeparator.ZIndex = 5
CombosSeparator.Font = Enum.Font.SourceSansSemibold
CombosSeparator.Text = "Combos"
CombosSeparator.TextColor3 = Color3.fromRGB(255, 255, 255)
CombosSeparator.TextSize = 13.000
CombosSeparator.TextStrokeTransparency = 0.000

Astronaut.Name = "Astronaut"
Astronaut.Parent = Container
Astronaut.BackgroundColor3 = Color3.fromRGB(97, 97, 97)
Astronaut.BorderColor3 = Color3.fromRGB(31, 31, 31)
Astronaut.LayoutOrder = 16
Astronaut.Position = UDim2.new(0, 0, 0.0903614461, 0)
Astronaut.Size = UDim2.new(1, 0, 0, 12)
Astronaut.ZIndex = 5
Astronaut.AutoButtonColor = false
Astronaut.Font = Enum.Font.SourceSansBold
Astronaut.Text = "Astronaut"
Astronaut.TextColor3 = Color3.fromRGB(255, 255, 255)
Astronaut.TextScaled = true
Astronaut.TextSize = 13.000
Astronaut.TextStrokeTransparency = 0.000
Astronaut.TextWrapped = true

AstronautUICorner.CornerRadius = UDim.new(0, 4)
AstronautUICorner.Name = "Astronaut UICorner"
AstronautUICorner.Parent = Astronaut

AstronautOutline.Name = "Astronaut Outline"
AstronautOutline.Parent = Astronaut
AstronautOutline.AnchorPoint = Vector2.new(0.5, 0.5)
AstronautOutline.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
AstronautOutline.Position = UDim2.new(0.5, 0, 0.5, 0)
AstronautOutline.Size = UDim2.new(1, 2, 1, 2)
AstronautOutline.ZIndex = 4

AstronautOutlineUICorner.CornerRadius = UDim.new(0, 4)
AstronautOutlineUICorner.Name = "Astronaut Outline UICorner"
AstronautOutlineUICorner.Parent = AstronautOutline

BoyCombo.Name = "Boy Combo"
BoyCombo.Parent = Container
BoyCombo.BackgroundColor3 = Color3.fromRGB(97, 97, 97)
BoyCombo.BorderColor3 = Color3.fromRGB(31, 31, 31)
BoyCombo.LayoutOrder = 20
BoyCombo.Position = UDim2.new(0, 0, 0.0903614461, 0)
BoyCombo.Size = UDim2.new(1, 0, 0, 12)
BoyCombo.ZIndex = 5
BoyCombo.AutoButtonColor = false
BoyCombo.Font = Enum.Font.SourceSansBold
BoyCombo.Text = "Boy Combo"
BoyCombo.TextColor3 = Color3.fromRGB(255, 255, 255)
BoyCombo.TextScaled = true
BoyCombo.TextSize = 13.000
BoyCombo.TextStrokeTransparency = 0.000
BoyCombo.TextWrapped = true

BoyComboUICorner.CornerRadius = UDim.new(0, 4)
BoyComboUICorner.Name = "Boy Combo UICorner"
BoyComboUICorner.Parent = BoyCombo

BoyComboOutline.Name = "Boy Combo Outline"
BoyComboOutline.Parent = BoyCombo
BoyComboOutline.AnchorPoint = Vector2.new(0.5, 0.5)
BoyComboOutline.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
BoyComboOutline.Position = UDim2.new(0.5, 0, 0.5, 0)
BoyComboOutline.Size = UDim2.new(1, 2, 1, 2)
BoyComboOutline.ZIndex = 4

BoyComboOutlineUICorner.CornerRadius = UDim.new(0, 4)
BoyComboOutlineUICorner.Name = "Boy Combo Outline UICorner"
BoyComboOutlineUICorner.Parent = BoyComboOutline

CombosSeparator_2.Name = "Combos Separator"
CombosSeparator_2.Parent = Container
CombosSeparator_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CombosSeparator_2.BackgroundTransparency = 1.000
CombosSeparator_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
CombosSeparator_2.BorderSizePixel = 0
CombosSeparator_2.LayoutOrder = 27
CombosSeparator_2.Size = UDim2.new(1, 0, 0, 15)
CombosSeparator_2.ZIndex = 5
CombosSeparator_2.Font = Enum.Font.SourceSansSemibold
CombosSeparator_2.Text = "Customize"
CombosSeparator_2.TextColor3 = Color3.fromRGB(255, 255, 255)
CombosSeparator_2.TextSize = 13.000
CombosSeparator_2.TextStrokeTransparency = 0.000

TryhardCombo1.Name = "Tryhard Combo #1"
TryhardCombo1.Parent = Container
TryhardCombo1.BackgroundColor3 = Color3.fromRGB(97, 97, 97)
TryhardCombo1.BorderColor3 = Color3.fromRGB(31, 31, 31)
TryhardCombo1.LayoutOrder = 23
TryhardCombo1.Position = UDim2.new(0, 0, 0.0903614461, 0)
TryhardCombo1.Size = UDim2.new(1, 0, 0, 12)
TryhardCombo1.ZIndex = 5
TryhardCombo1.AutoButtonColor = false
TryhardCombo1.Font = Enum.Font.SourceSansBold
TryhardCombo1.Text = "Tryhard Combo #1"
TryhardCombo1.TextColor3 = Color3.fromRGB(255, 255, 255)
TryhardCombo1.TextScaled = true
TryhardCombo1.TextSize = 13.000
TryhardCombo1.TextStrokeTransparency = 0.000
TryhardCombo1.TextWrapped = true

TryhardCombo1UICorner.CornerRadius = UDim.new(0, 4)
TryhardCombo1UICorner.Name = "Tryhard Combo #1 UICorner"
TryhardCombo1UICorner.Parent = TryhardCombo1

TryhardCombo1Outline.Name = "Tryhard Combo #1 Outline"
TryhardCombo1Outline.Parent = TryhardCombo1
TryhardCombo1Outline.AnchorPoint = Vector2.new(0.5, 0.5)
TryhardCombo1Outline.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
TryhardCombo1Outline.Position = UDim2.new(0.5, 0, 0.5, 0)
TryhardCombo1Outline.Size = UDim2.new(1, 2, 1, 2)
TryhardCombo1Outline.ZIndex = 4

TryhardCombo1OutlineUICorner.CornerRadius = UDim.new(0, 4)
TryhardCombo1OutlineUICorner.Name = "Tryhard Combo #1 Outline UICorner"
TryhardCombo1OutlineUICorner.Parent = TryhardCombo1Outline

TryhardCombo3.Name = "Tryhard Combo #3"
TryhardCombo3.Parent = Container
TryhardCombo3.BackgroundColor3 = Color3.fromRGB(97, 97, 97)
TryhardCombo3.BorderColor3 = Color3.fromRGB(31, 31, 31)
TryhardCombo3.LayoutOrder = 25
TryhardCombo3.Position = UDim2.new(0, 0, 0.0903614461, 0)
TryhardCombo3.Size = UDim2.new(1, 0, 0, 12)
TryhardCombo3.ZIndex = 5
TryhardCombo3.AutoButtonColor = false
TryhardCombo3.Font = Enum.Font.SourceSansBold
TryhardCombo3.Text = "Tryhard Combo #3"
TryhardCombo3.TextColor3 = Color3.fromRGB(255, 255, 255)
TryhardCombo3.TextScaled = true
TryhardCombo3.TextSize = 13.000
TryhardCombo3.TextStrokeTransparency = 0.000
TryhardCombo3.TextWrapped = true

TryhardCombo3UICorner.CornerRadius = UDim.new(0, 4)
TryhardCombo3UICorner.Name = "Tryhard Combo #3 UICorner"
TryhardCombo3UICorner.Parent = TryhardCombo3

TryhardCombo3Outline.Name = "Tryhard Combo #3 Outline"
TryhardCombo3Outline.Parent = TryhardCombo3
TryhardCombo3Outline.AnchorPoint = Vector2.new(0.5, 0.5)
TryhardCombo3Outline.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
TryhardCombo3Outline.Position = UDim2.new(0.5, 0, 0.5, 0)
TryhardCombo3Outline.Size = UDim2.new(1, 2, 1, 2)
TryhardCombo3Outline.ZIndex = 4

TryhardCombo3OutlineUICorner.CornerRadius = UDim.new(0, 4)
TryhardCombo3OutlineUICorner.Name = "Tryhard Combo #3 Outline UICorner"
TryhardCombo3OutlineUICorner.Parent = TryhardCombo3Outline

TryhardCombo4.Name = "Tryhard Combo #4"
TryhardCombo4.Parent = Container
TryhardCombo4.BackgroundColor3 = Color3.fromRGB(97, 97, 97)
TryhardCombo4.BorderColor3 = Color3.fromRGB(31, 31, 31)
TryhardCombo4.LayoutOrder = 26
TryhardCombo4.Position = UDim2.new(0, 0, 0.0903614461, 0)
TryhardCombo4.Size = UDim2.new(1, 0, 0, 12)
TryhardCombo4.ZIndex = 5
TryhardCombo4.AutoButtonColor = false
TryhardCombo4.Font = Enum.Font.SourceSansBold
TryhardCombo4.Text = "Tryhard Combo #4"
TryhardCombo4.TextColor3 = Color3.fromRGB(255, 255, 255)
TryhardCombo4.TextScaled = true
TryhardCombo4.TextSize = 13.000
TryhardCombo4.TextStrokeTransparency = 0.000
TryhardCombo4.TextWrapped = true

TryhardCombo4UICorner.CornerRadius = UDim.new(0, 4)
TryhardCombo4UICorner.Name = "Tryhard Combo #4 UICorner"
TryhardCombo4UICorner.Parent = TryhardCombo4

TryhardCombo4Outline.Name = "Tryhard Combo #4 Outline"
TryhardCombo4Outline.Parent = TryhardCombo4
TryhardCombo4Outline.AnchorPoint = Vector2.new(0.5, 0.5)
TryhardCombo4Outline.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
TryhardCombo4Outline.Position = UDim2.new(0.5, 0, 0.5, 0)
TryhardCombo4Outline.Size = UDim2.new(1, 2, 1, 2)
TryhardCombo4Outline.ZIndex = 4

TryhardCombo4OutlineUICorner.CornerRadius = UDim.new(0, 4)
TryhardCombo4OutlineUICorner.Name = "Tryhard Combo #4 Outline UICorner"
TryhardCombo4OutlineUICorner.Parent = TryhardCombo4Outline

GirlCombo2.Name = "Girl Combo #2"
GirlCombo2.Parent = Container
GirlCombo2.BackgroundColor3 = Color3.fromRGB(97, 97, 97)
GirlCombo2.BorderColor3 = Color3.fromRGB(31, 31, 31)
GirlCombo2.LayoutOrder = 22
GirlCombo2.Position = UDim2.new(0, 0, 0.0903614461, 0)
GirlCombo2.Size = UDim2.new(1, 0, 0, 12)
GirlCombo2.ZIndex = 5
GirlCombo2.AutoButtonColor = false
GirlCombo2.Font = Enum.Font.SourceSansBold
GirlCombo2.Text = "Girl Combo #2"
GirlCombo2.TextColor3 = Color3.fromRGB(255, 255, 255)
GirlCombo2.TextScaled = true
GirlCombo2.TextSize = 13.000
GirlCombo2.TextStrokeTransparency = 0.000
GirlCombo2.TextWrapped = true

GirlCombo2UICorner.CornerRadius = UDim.new(0, 4)
GirlCombo2UICorner.Name = "Girl Combo #2 UICorner"
GirlCombo2UICorner.Parent = GirlCombo2

GirlCombo2Outline.Name = "Girl Combo #2 Outline"
GirlCombo2Outline.Parent = GirlCombo2
GirlCombo2Outline.AnchorPoint = Vector2.new(0.5, 0.5)
GirlCombo2Outline.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
GirlCombo2Outline.Position = UDim2.new(0.5, 0, 0.5, 0)
GirlCombo2Outline.Size = UDim2.new(1, 2, 1, 2)
GirlCombo2Outline.ZIndex = 4

GirlCombo2OutlineUICorner.CornerRadius = UDim.new(0, 4)
GirlCombo2OutlineUICorner.Name = "Girl Combo #2 Outline UICorner"
GirlCombo2OutlineUICorner.Parent = GirlCombo2Outline

TryhardCombo2.Name = "Tryhard Combo #2"
TryhardCombo2.Parent = Container
TryhardCombo2.BackgroundColor3 = Color3.fromRGB(97, 97, 97)
TryhardCombo2.BorderColor3 = Color3.fromRGB(31, 31, 31)
TryhardCombo2.LayoutOrder = 24
TryhardCombo2.Position = UDim2.new(0, 0, 0.0903614461, 0)
TryhardCombo2.Size = UDim2.new(1, 0, 0, 12)
TryhardCombo2.ZIndex = 5
TryhardCombo2.AutoButtonColor = false
TryhardCombo2.Font = Enum.Font.SourceSansBold
TryhardCombo2.Text = "Tryhard Combo #2"
TryhardCombo2.TextColor3 = Color3.fromRGB(255, 255, 255)
TryhardCombo2.TextScaled = true
TryhardCombo2.TextSize = 13.000
TryhardCombo2.TextStrokeTransparency = 0.000
TryhardCombo2.TextWrapped = true

TryhardCombo2UICorner.CornerRadius = UDim.new(0, 4)
TryhardCombo2UICorner.Name = "Tryhard Combo #2 UICorner"
TryhardCombo2UICorner.Parent = TryhardCombo2

TryhardCombo2Outline.Name = "Tryhard Combo #2 Outline"
TryhardCombo2Outline.Parent = TryhardCombo2
TryhardCombo2Outline.AnchorPoint = Vector2.new(0.5, 0.5)
TryhardCombo2Outline.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
TryhardCombo2Outline.Position = UDim2.new(0.5, 0, 0.5, 0)
TryhardCombo2Outline.Size = UDim2.new(1, 2, 1, 2)
TryhardCombo2Outline.ZIndex = 4

TryhardCombo2OutlineUICorner.CornerRadius = UDim.new(0, 4)
TryhardCombo2OutlineUICorner.Name = "Tryhard Combo #2 Outline UICorner"
TryhardCombo2OutlineUICorner.Parent = TryhardCombo2Outline

Walk.Name = "Walk"
Walk.Parent = Container
Walk.BackgroundColor3 = Color3.fromRGB(58, 58, 58)
Walk.BorderColor3 = Color3.fromRGB(31, 31, 31)
Walk.LayoutOrder = 30
Walk.Size = UDim2.new(1, 0, 0, 12)
Walk.ZIndex = 5
Walk.Font = Enum.Font.SourceSansBold
Walk.PlaceholderColor3 = Color3.fromRGB(17, 17, 17)
Walk.PlaceholderText = "Walk"
Walk.Text = ""
Walk.TextColor3 = Color3.fromRGB(255, 255, 255)
Walk.TextScaled = true
Walk.TextSize = 14.000
Walk.TextStrokeTransparency = 4.000
Walk.TextWrapped = true

WalkUICorner.CornerRadius = UDim.new(0, 4)
WalkUICorner.Name = "Walk UICorner"
WalkUICorner.Parent = Walk

WalkOutline.Name = "Walk Outline"
WalkOutline.Parent = Walk
WalkOutline.AnchorPoint = Vector2.new(0.5, 0.5)
WalkOutline.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
WalkOutline.Position = UDim2.new(0.5, 0, 0.5, 0)
WalkOutline.Size = UDim2.new(1, 2, 1, 2)
WalkOutline.ZIndex = 4

WalkOutlineUICorner.CornerRadius = UDim.new(0, 4)
WalkOutlineUICorner.Name = "Walk Outline UICorner"
WalkOutlineUICorner.Parent = WalkOutline

Run.Name = "Run"
Run.Parent = Container
Run.BackgroundColor3 = Color3.fromRGB(58, 58, 58)
Run.BorderColor3 = Color3.fromRGB(31, 31, 31)
Run.LayoutOrder = 31
Run.Size = UDim2.new(1, 0, 0, 12)
Run.ZIndex = 5
Run.Font = Enum.Font.SourceSansBold
Run.PlaceholderColor3 = Color3.fromRGB(17, 17, 17)
Run.PlaceholderText = "Run"
Run.Text = ""
Run.TextColor3 = Color3.fromRGB(255, 255, 255)
Run.TextScaled = true
Run.TextSize = 14.000
Run.TextStrokeTransparency = 4.000
Run.TextWrapped = true

RunUICorner.CornerRadius = UDim.new(0, 4)
RunUICorner.Name = "Run UICorner"
RunUICorner.Parent = Run

RunOutline.Name = "Run Outline"
RunOutline.Parent = Run
RunOutline.AnchorPoint = Vector2.new(0.5, 0.5)
RunOutline.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
RunOutline.Position = UDim2.new(0.5, 0, 0.5, 0)
RunOutline.Size = UDim2.new(1, 2, 1, 2)
RunOutline.ZIndex = 4

RunOutlineUICorner.CornerRadius = UDim.new(0, 4)
RunOutlineUICorner.Name = "Run Outline UICorner"
RunOutlineUICorner.Parent = RunOutline

SwimIdle.Name = "SwimIdle"
SwimIdle.Parent = Container
SwimIdle.BackgroundColor3 = Color3.fromRGB(58, 58, 58)
SwimIdle.BorderColor3 = Color3.fromRGB(31, 31, 31)
SwimIdle.LayoutOrder = 32
SwimIdle.Size = UDim2.new(1, 0, 0, 12)
SwimIdle.ZIndex = 5
SwimIdle.Font = Enum.Font.SourceSansBold
SwimIdle.PlaceholderColor3 = Color3.fromRGB(17, 17, 17)
SwimIdle.PlaceholderText = "SwimIdle"
SwimIdle.Text = ""
SwimIdle.TextColor3 = Color3.fromRGB(255, 255, 255)
SwimIdle.TextScaled = true
SwimIdle.TextSize = 14.000
SwimIdle.TextStrokeTransparency = 4.000
SwimIdle.TextWrapped = true

SwimIdleUICorner.CornerRadius = UDim.new(0, 4)
SwimIdleUICorner.Name = "SwimIdle UICorner"
SwimIdleUICorner.Parent = SwimIdle

SwimIdleOutline.Name = "SwimIdle Outline"
SwimIdleOutline.Parent = SwimIdle
SwimIdleOutline.AnchorPoint = Vector2.new(0.5, 0.5)
SwimIdleOutline.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
SwimIdleOutline.Position = UDim2.new(0.5, 0, 0.5, 0)
SwimIdleOutline.Size = UDim2.new(1, 2, 1, 2)
SwimIdleOutline.ZIndex = 4

SwimIdleOutlineUICorner.CornerRadius = UDim.new(0, 4)
SwimIdleOutlineUICorner.Name = "SwimIdle Outline UICorner"
SwimIdleOutlineUICorner.Parent = SwimIdleOutline

Idle1.Name = "Idle #1"
Idle1.Parent = Container
Idle1.BackgroundColor3 = Color3.fromRGB(58, 58, 58)
Idle1.BorderColor3 = Color3.fromRGB(31, 31, 31)
Idle1.LayoutOrder = 28
Idle1.Size = UDim2.new(1, 0, 0, 12)
Idle1.ZIndex = 5
Idle1.Font = Enum.Font.SourceSansBold
Idle1.PlaceholderColor3 = Color3.fromRGB(17, 17, 17)
Idle1.PlaceholderText = "Idle #1"
Idle1.Text = ""
Idle1.TextColor3 = Color3.fromRGB(255, 255, 255)
Idle1.TextScaled = true
Idle1.TextSize = 14.000
Idle1.TextStrokeTransparency = 4.000
Idle1.TextWrapped = true

Idle1UICorner.CornerRadius = UDim.new(0, 4)
Idle1UICorner.Name = "Idle #1 UICorner"
Idle1UICorner.Parent = Idle1

Idle1Outline.Name = "Idle #1 Outline"
Idle1Outline.Parent = Idle1
Idle1Outline.AnchorPoint = Vector2.new(0.5, 0.5)
Idle1Outline.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
Idle1Outline.Position = UDim2.new(0.5, 0, 0.5, 0)
Idle1Outline.Size = UDim2.new(1, 2, 1, 2)
Idle1Outline.ZIndex = 4

Idle1OutlineUICorner.CornerRadius = UDim.new(0, 4)
Idle1OutlineUICorner.Name = "Idle #1 Outline UICorner"
Idle1OutlineUICorner.Parent = Idle1Outline

Idle2.Name = "Idle #2"
Idle2.Parent = Container
Idle2.BackgroundColor3 = Color3.fromRGB(58, 58, 58)
Idle2.BorderColor3 = Color3.fromRGB(31, 31, 31)
Idle2.LayoutOrder = 29
Idle2.Size = UDim2.new(1, 0, 0, 12)
Idle2.ZIndex = 5
Idle2.Font = Enum.Font.SourceSansBold
Idle2.PlaceholderColor3 = Color3.fromRGB(17, 17, 17)
Idle2.PlaceholderText = "Idle #2"
Idle2.Text = ""
Idle2.TextColor3 = Color3.fromRGB(255, 255, 255)
Idle2.TextScaled = true
Idle2.TextSize = 14.000
Idle2.TextStrokeTransparency = 4.000
Idle2.TextWrapped = true

Idle2UICorner.CornerRadius = UDim.new(0, 4)
Idle2UICorner.Name = "Idle #2 UICorner"
Idle2UICorner.Parent = Idle2

Idle2Outline.Name = "Idle #2 Outline"
Idle2Outline.Parent = Idle2
Idle2Outline.AnchorPoint = Vector2.new(0.5, 0.5)
Idle2Outline.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
Idle2Outline.Position = UDim2.new(0.5, 0, 0.5, 0)
Idle2Outline.Size = UDim2.new(1, 2, 1, 2)
Idle2Outline.ZIndex = 4

Idle2OutlineUICorner.CornerRadius = UDim.new(0, 4)
Idle2OutlineUICorner.Name = "Idle #2 Outline UICorner"
Idle2OutlineUICorner.Parent = Idle2Outline

Fall.Name = "Fall"
Fall.Parent = Container
Fall.BackgroundColor3 = Color3.fromRGB(58, 58, 58)
Fall.BorderColor3 = Color3.fromRGB(31, 31, 31)
Fall.LayoutOrder = 32
Fall.Size = UDim2.new(1, 0, 0, 12)
Fall.ZIndex = 5
Fall.Font = Enum.Font.SourceSansBold
Fall.PlaceholderColor3 = Color3.fromRGB(17, 17, 17)
Fall.PlaceholderText = "Fall"
Fall.Text = ""
Fall.TextColor3 = Color3.fromRGB(255, 255, 255)
Fall.TextScaled = true
Fall.TextSize = 14.000
Fall.TextStrokeTransparency = 4.000
Fall.TextWrapped = true

FallUICorner.CornerRadius = UDim.new(0, 4)
FallUICorner.Name = "Fall UICorner"
FallUICorner.Parent = Fall

FallOutline.Name = "Fall Outline"
FallOutline.Parent = Fall
FallOutline.AnchorPoint = Vector2.new(0.5, 0.5)
FallOutline.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
FallOutline.Position = UDim2.new(0.5, 0, 0.5, 0)
FallOutline.Size = UDim2.new(1, 2, 1, 2)
FallOutline.ZIndex = 4

FallOutlineUICorner.CornerRadius = UDim.new(0, 4)
FallOutlineUICorner.Name = "Fall Outline UICorner"
FallOutlineUICorner.Parent = FallOutline

Jump.Name = "Jump"
Jump.Parent = Container
Jump.BackgroundColor3 = Color3.fromRGB(58, 58, 58)
Jump.BorderColor3 = Color3.fromRGB(31, 31, 31)
Jump.LayoutOrder = 32
Jump.Size = UDim2.new(1, 0, 0, 12)
Jump.ZIndex = 5
Jump.Font = Enum.Font.SourceSansBold
Jump.PlaceholderColor3 = Color3.fromRGB(17, 17, 17)
Jump.PlaceholderText = "Jump"
Jump.Text = ""
Jump.TextColor3 = Color3.fromRGB(255, 255, 255)
Jump.TextScaled = true
Jump.TextSize = 14.000
Jump.TextStrokeTransparency = 4.000
Jump.TextWrapped = true

JumpUICorner.CornerRadius = UDim.new(0, 4)
JumpUICorner.Name = "Jump UICorner"
JumpUICorner.Parent = Jump

JumpOutline.Name = "Jump Outline"
JumpOutline.Parent = Jump
JumpOutline.AnchorPoint = Vector2.new(0.5, 0.5)
JumpOutline.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
JumpOutline.Position = UDim2.new(0.5, 0, 0.5, 0)
JumpOutline.Size = UDim2.new(1, 2, 1, 2)
JumpOutline.ZIndex = 4

JumpOutlineUICorner.CornerRadius = UDim.new(0, 4)
JumpOutlineUICorner.Name = "Jump Outline UICorner"
JumpOutlineUICorner.Parent = JumpOutline

Climb.Name = "Climb"
Climb.Parent = Container
Climb.BackgroundColor3 = Color3.fromRGB(58, 58, 58)
Climb.BorderColor3 = Color3.fromRGB(31, 31, 31)
Climb.LayoutOrder = 32
Climb.Size = UDim2.new(1, 0, 0, 12)
Climb.ZIndex = 5
Climb.Font = Enum.Font.SourceSansBold
Climb.PlaceholderColor3 = Color3.fromRGB(17, 17, 17)
Climb.PlaceholderText = "Climb"
Climb.Text = ""
Climb.TextColor3 = Color3.fromRGB(255, 255, 255)
Climb.TextScaled = true
Climb.TextSize = 14.000
Climb.TextStrokeTransparency = 4.000
Climb.TextWrapped = true

ClimbUICorner.CornerRadius = UDim.new(0, 4)
ClimbUICorner.Name = "Climb UICorner"
ClimbUICorner.Parent = Climb

ClimbOutline.Name = "Climb Outline"
ClimbOutline.Parent = Climb
ClimbOutline.AnchorPoint = Vector2.new(0.5, 0.5)
ClimbOutline.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
ClimbOutline.Position = UDim2.new(0.5, 0, 0.5, 0)
ClimbOutline.Size = UDim2.new(1, 2, 1, 2)
ClimbOutline.ZIndex = 4

ClimbOutlineUICorner.CornerRadius = UDim.new(0, 4)
ClimbOutlineUICorner.Name = "Climb Outline UICorner"
ClimbOutlineUICorner.Parent = ClimbOutline

Swim.Name = "Swim"
Swim.Parent = Container
Swim.BackgroundColor3 = Color3.fromRGB(58, 58, 58)
Swim.BorderColor3 = Color3.fromRGB(31, 31, 31)
Swim.LayoutOrder = 32
Swim.Size = UDim2.new(1, 0, 0, 12)
Swim.ZIndex = 5
Swim.Font = Enum.Font.SourceSansBold
Swim.PlaceholderColor3 = Color3.fromRGB(17, 17, 17)
Swim.PlaceholderText = "Swim"
Swim.Text = ""
Swim.TextColor3 = Color3.fromRGB(255, 255, 255)
Swim.TextScaled = true
Swim.TextSize = 14.000
Swim.TextStrokeTransparency = 4.000
Swim.TextWrapped = true

SwimUICorner.CornerRadius = UDim.new(0, 4)
SwimUICorner.Name = "Swim UICorner"
SwimUICorner.Parent = Swim

SwimOutline.Name = "Swim Outline"
SwimOutline.Parent = Swim
SwimOutline.AnchorPoint = Vector2.new(0.5, 0.5)
SwimOutline.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
SwimOutline.Position = UDim2.new(0.5, 0, 0.5, 0)
SwimOutline.Size = UDim2.new(1, 2, 1, 2)
SwimOutline.ZIndex = 4

SwimOutlineUICorner.CornerRadius = UDim.new(0, 4)
SwimOutlineUICorner.Name = "Swim Outline UICorner"
SwimOutlineUICorner.Parent = SwimOutline

local dragging
local draginput
local dragstart
local startpos

local lastmousepos
local lastgoalpos

local connections = {}
local a = 0

local currentanims = {}

local anims = {
	astronaut = {
		Button = Astronaut;
		Idle1 = "rbxassetid://891621366";
		Idle2 = "rbxassetid://891633237";
		Walk = "rbxassetid://891636393";
		Run = "rbxassetid://891636393";
		Fall = "rbxassetid://891617961";
		Jump = "rbxassetid://891627522";
		Climb = "rbxassetid://891609353";
		Swim = "rbxassetid://891639666";
		SwimIdle = "rbxassetid://891663592"
	};
	bold = {
		Button = Bold;
		Idle1 = "rbxassetid://16738333868";
		Idle2 = "rbxassetid://16738334710";
		Walk = "rbxassetid://16738340646";
		Run = "rbxassetid://16738337225";
		Fall = "rbxassetid://16738333171";
		Jump = "rbxassetid://16738336650";
		Climb = "rbxassetid://16738332169";
		Swim = "rbxassetid://16738339158";
		SwimIdle = "rbxassetid://16738339817"
	};
	bubbly = {
		Button = Bubbly;
		Idle1 = "rbxassetid://910004836";
		Idle2 = "rbxassetid://910009958";
		Walk = "rbxassetid://910034870";
		Run = "rbxassetid://910025107";
		Fall = "rbxassetid://910001910";
		Jump = "rbxassetid://910016857";
		Climb = "rbxassetid://909997997";
		Swim = "rbxassetid://910028158";
		SwimIdle = "rbxassetid://910030921"
	};
	cartoony = {
		Button = Cartoony;
		Idle1 = "rbxassetid://742637544";
		Idle2 = "rbxassetid://742638445";
		Walk = "rbxassetid://742640026";
		Run = "rbxassetid://742638842";
		Fall = "rbxassetid://742637151";
		Jump = "rbxassetid://742637942";
		Climb = "rbxassetid://742636889";
		Swim = "rbxassetid://742639220";
		SwimIdle = "rbxassetid://742639812"
	};
	elder = {
		Button = Elder;
		Idle1 = "rbxassetid://845397899";
		Idle2 = "rbxassetid://8454005";
		Walk = "rbxassetid://845403856";
		Run = "rbxassetid://845386501";
		Fall = "rbxassetid://616005863";
		Jump = "rbxassetid://845398858";
		Climb = "rbxassetid://656114359";
		Swim = "rbxassetid://845401742";
		SwimIdle = "rbxassetid://845403127"
	};
	knight = {
		Button = Knight;
		Idle1 = "rbxassetid://657595757";
		Idle2 = "rbxassetid://657568135";
		Walk = "rbxassetid://657552124";
		Run = "rbxassetid://657564596";
		Fall = "rbxassetid://657600338";
		Jump = "rbxassetid://658409194";
		Climb = "rbxassetid://658360781";
		Swim = "rbxassetid://657560551";
		SwimIdle = "rbxassetid://657557095"
	};
	levitation = {
		Button = Levitation;
		Idle1 = "rbxassetid://616006778";
		Idle2 = "rbxassetid://616008087";
		Walk = "rbxassetid://616013216";
		Run = "rbxassetid://616010382";
		Fall = "rbxassetid://616005863";
		Jump = "rbxassetid://616008936";
		Climb = "rbxassetid://616003713";
		Swim = "rbxassetid://616011509";
		SwimIdle = "rbxassetid://616012453"
	};
	mage = {
		Button = Mage;
		Idle1 = "rbxassetid://707742142";
		Idle2 = "rbxassetid://707855907";
		Walk = "rbxassetid://707897309";
		Run = "rbxassetid://707861613";
		Fall = "rbxassetid://707829716";
		Jump = "rbxassetid://707853694";
		Climb = "rbxassetid://707826056";
		Swim = "rbxassetid://707876443";
		SwimIdle = "rbxassetid://707894699"
	};
	ninja = {
		Button = Ninja;
		Idle1 = "rbxassetid://656117400";
		Idle2 = "rbxassetid://656118341";
		Walk = "rbxassetid://656121766";
		Run = "rbxassetid://656118852";
		Fall = "rbxassetid://656115606";
		Jump = "rbxassetid://656117878";
		Climb = "rbxassetid://656114359";
		Swim = "rbxassetid://656119721";
		SwimIdle = "rbxassetid://656121397"
	};
	oldschool = {
		Button = OldSchool;
		Idle1 = "rbxassetid://5319828216";
		Idle2 = "rbxassetid://5319831086";
		Walk = "rbxassetid://5319847204";
		Run = "rbxassetid://5319844329";
		Fall = "rbxassetid://5319839762";
		Jump = "rbxassetid://5319841935";
		Climb = "rbxassetid://5319816685";
		Swim = "rbxassetid://5319850266";
		SwimIdle = "rbxassetid://5319852613"
	};
	pirate = {
		Button = Pirate;
		Idle1 = "rbxassetid://750781874";
		Idle2 = "rbxassetid://750782770";
		Walk = "rbxassetid://750785693";
		Run = "rbxassetid://750783738";
		Fall = "rbxassetid://750780242";
		Jump = "rbxassetid://750782230";
		Climb = "rbxassetid://750779899";
		Swim = "rbxassetid://750784579";
		SwimIdle = "rbxassetid://750785176"
	};
	rthro = {
		Button = Rthro;
		Idle1 = "rbxassetid://2510196951";
		Idle2 = "rbxassetid://2510197257";
		Walk = "rbxassetid://2510202577";
		Run = "rbxassetid://2510198475";
		Fall = "rbxassetid://656115606";
		Jump = "rbxassetid://656117878";
		Climb = "rbxassetid://2510192778";
		Swim = "rbxassetid://2510199791";
		SwimIdle = "rbxassetid://2510201162"
	};
	stylish = {
		Button = Stylish;
		Idle1 = "rbxassetid://616136790";
		Idle2 = "rbxassetid://616138447";
		Walk = "rbxassetid://616146177";
		Run = "rbxassetid://616140816";
		Fall = "rbxassetid://616134815";
		Jump = "rbxassetid://616139451";
		Climb = "rbxassetid://616133594";
		Swim = "rbxassetid://616143378";
		SwimIdle = "rbxassetid://616144772"
	};
	superhero = {
		Button = Superhero;
		Idle1 = "rbxassetid://616111295";
		Idle2 = "rbxassetid://616113536";
		Walk = "rbxassetid://616122287";
		Run = "rbxassetid://616117076";
		Fall = "rbxassetid://616108001";
		Jump = "rbxassetid://616115533";
		Climb = "rbxassetid://616104706";
		Swim = "rbxassetid://616119360";
		SwimIdle = "rbxassetid://616120861"
	};
	toy = {
		Button = Toy;
		Idle1 = "rbxassetid://782841498";
		Idle2 = "rbxassetid://782845736";
		Walk = "rbxassetid://782843345";
		Run = "rbxassetid://782842708";
		Fall = "rbxassetid://782846423";
		Jump = "rbxassetid://782847020";
		Climb = "rbxassetid://782843869";
		Swim = "rbxassetid://782844582";
		SwimIdle = "rbxassetid://782845186"
	};
	vampire = {
		Button = Vampire;
		Idle1 = "rbxassetid://1083445855";
		Idle2 = "rbxassetid://1083450166";
		Walk = "rbxassetid://1083473930";
		Run = "rbxassetid://1083462077";
		Fall = "rbxassetid://1083443587";
		Jump = "rbxassetid://1083455352";
		Climb = "rbxassetid://1083439238";
		Swim = "rbxassetid://1083464683";
		SwimIdle = "rbxassetid://1083467779"
	};
	werewolf = {
		Button = Werewolf;
		Idle1 = "rbxassetid://1083195517";
		Idle2 = "rbxassetid://1083214717";
		Walk = "rbxassetid://1083178339";
		Run = "rbxassetid://1083216690";
		Fall = "rbxassetid://1083189019";
		Jump = "rbxassetid://1083218792";
		Climb = "rbxassetid://1083182000";
		Swim = "rbxassetid://1083222527";
		SwimIdle = "rbxassetid://1083222527"
	};
	zombie = {
		Button = Zombie;
		Idle1 = "rbxassetid://616158929";
		Idle2 = "rbxassetid://616160636";
		Walk = "rbxassetid://616168032";
		Run = "rbxassetid://616163682";
		Fall = "rbxassetid://616157476";
		Jump = "rbxassetid://616161997";
		Climb = "rbxassetid://616156119";
		Swim = "rbxassetid://616165109";
		SwimIdle = "rbxassetid://616166655"
	};
	faker6 = {
		Button = FakeR6;
		Idle1 = "rbxassetid://12521158637";
		Idle2 = "rbxassetid://12521162526";
		Walk = "rbxassetid://12518152696";
		Run = "rbxassetid://12518152696";
		Fall = "rbxassetid://12520972571";
		Jump = "rbxassetid://12520880485";
		Climb = "rbxassetid://12520982150";
		Swim = "rbxassetid://12520993168";
		SwimIdle = "rbxassetid://2510201162"
	}
	girlcombo1 = {
		Button = GirlCombo1;
		Idle1 = "rbxassetid://16738333868";
		Idle2 = "rbxassetid://16738334710";
		Walk = "rbxassetid://910034870";
		Run = "rbxassetid://910025107";
		Fall = "rbxassetid://5319839762";
		Jump = "rbxassetid://5319841935";
		Climb = "rbxassetid://5319816685";
		Swim = "rbxassetid://2510199791";
		SwimIdle = "rbxassetid://5319852613"
	};
	girlcombo2 = {
		Button = GirlCombo2;
		Idle1 = "rbxassetid://616136790";
		Idle2 = "rbxassetid://616138447";
		Walk = "rbxassetid://910034870";
		Run = "rbxassetid://910025107";
		Fall = "rbxassetid://5319839762";
		Jump = "rbxassetid://5319841935";
		Climb = "rbxassetid://5319816685";
		Swim = "rbxassetid://5319850266";
		SwimIdle = "rbxassetid://5319852613"
	};
	tryhardcombo1 = {
		Button = TryhardCombo1;
		Idle1 = "rbxassetid://5319828216";
		Idle2 = "rbxassetid://5319831086";
		Walk = "rbxassetid://707897309";
		Run = "rbxassetid://707861613";
		Fall = "rbxassetid://5319839762";
		Jump = "rbxassetid://5319841935";
		Climb = "rbxassetid://5319816685";
		Swim = "rbxassetid://5319850266";
		SwimIdle = "rbxassetid://5319852613"
	};
	tryhardcombo2 = {
		Button = TryhardCombo2;
		Idle1 = "rbxassetid://782841498";
		Idle2 = "rbxassetid://782845736";
		Walk = "rbxassetid://782843345";
		Run = "rbxassetid://782842708";
		Fall = "rbxassetid://616005863";
		Jump = "rbxassetid://782847020";
		Climb = "rbxassetid://707826056";
		Swim = "rbxassetid://707876443";
		SwimIdle = "rbxassetid://707894699"
	};
	tryhardcombo3 = {
		Button = TryhardCombo3;
		Idle1 = "rbxassetid://4417977954";
		Idle2 = "rbxassetid://4417978624";
		Walk = "rbxassetid://656121766";
		Run = "rbxassetid://656118852";
		Fall = "rbxassetid://616005863";
		Jump = "rbxassetid://5319841935";
		Climb = "rbxassetid://5319816685";
		Swim = "rbxassetid://5319850266";
		SwimIdle = "rbxassetid://5319852613"
	};
	tryhardcombo4 = {
		Button = TryhardCombo4;
		Idle1 = "rbxassetid://616111295";
		Idle2 = "rbxassetid://616113536";
		Walk = "rbxassetid://782843345";
		Run = "rbxassetid://782842708";
		Fall = "rbxassetid://5319839762";
		Jump = "rbxassetid://5319841935";
		Climb = "rbxassetid://5319816685";
		Swim = "rbxassetid://5319850266";
		SwimIdle = "rbxassetid://5319852613"
	};
}
local customanims = {
	Idle1 = {
		TextBox = Idle1;
		PlaceholderText = Idle1.PlaceholderText;
	};
	Idle2 = {
		TextBox = Idle2;
		PlaceholderText = Idle2.PlaceholderText;
	};
	Walk = {
		TextBox = Walk;
		PlaceholderText = Walk.PlaceholderText;
	};
	Run = {
		TextBox = Run;
		PlaceholderText = Run.PlaceholderText;
	};
	Fall = {
		TextBox = Fall;
		PlaceholderText = Fall.PlaceholderText;
	};
	Jump = {
		TextBox = Jump;
		PlaceholderText = Jump.PlaceholderText;
	};
	Climb = {
		TextBox = Climb;
		PlaceholderText = Climb.PlaceholderText;
	};
	Swim = {
		TextBox = Swim;
		PlaceholderText = Swim.PlaceholderText;
	};
	SwimIdle = {
		TextBox = SwimIdle;
		PlaceholderText = SwimIdle.PlaceholderText;
	};
}

function Lerp(a, b, m)
	return a + (b - a) * m
end
function assignButtonFunctions(button,callback)
	local ripplecontainer = Instance.new("Frame", button)
	ripplecontainer.Name = "RippleContainer"
	ripplecontainer.ZIndex = button.ZIndex + 1
	ripplecontainer.Size = UDim2.new(1,0,1,0)
	ripplecontainer.Transparency = 1
	ripplecontainer.ClipsDescendants = true

	local function tweenInRipple(rippleeffect)
		spawn(function()
			local Info = TweenInfo.new(0.9,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut,0,false,0)
			local Goals = {Size = UDim2.new(0, 200, 0, 200)}
			local Tween = TweenService:Create(rippleeffect, Info, Goals)
			Tween:Play()
		end)
	end

	local function fadeOutRipple(rippleeffect)
		spawn(function()
			local Info = TweenInfo.new(0.6,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut,0,false,0)
			local goal = {ImageTransparency = 1}
			local Tween = TweenService:Create(rippleeffect, Info, goal)
			Tween:Play()
			task.wait(1)
			rippleeffect:Destroy()
		end)
	end

	button.MouseButton1Down:Connect(function()
		spawn(callback)
		
		a += 1
		local b = a

		local done = false

		local rippleeffect = Instance.new("ImageLabel", ripplecontainer)
		rippleeffect.Name = "RippleEffect"
		rippleeffect.Position = UDim2.new(0,mouse.X - button.AbsolutePosition.X,0,mouse.Y - button.AbsolutePosition.Y)
		rippleeffect.ZIndex = ripplecontainer.ZIndex + 1
		rippleeffect.AnchorPoint = Vector2.new(0.5, 0.5)
		rippleeffect.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		rippleeffect.BackgroundTransparency = 1
		rippleeffect.Image = "rbxassetid://266543268"
		rippleeffect.ImageColor3 = Color3.fromRGB(0, 0, 0)
		rippleeffect.ImageTransparency = 0.8

		tweenInRipple(rippleeffect)
		connections[b] = button.MouseButton1Up:Connect(function()
			if not done then
				done = true
				fadeOutRipple(rippleeffect)
			end
		end)
		task.wait(4)
		connections[b]:Disconnect()
		done = true
		fadeOutRipple(rippleeffect)
	end)
end
function setAnimations(char)
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
				if currentanims.Idle1 and IdleAnim1 then
					IdleAnim1.AnimationId = currentanims.Idle1
				end
				local IdleAnim2 = idle:WaitForChild("Animation2")
				if currentanims.Idle2 and IdleAnim2 then
					IdleAnim2.AnimationId = currentanims.Idle2
				end
				local WalkAnim = walk:WaitForChild("WalkAnim")
				if currentanims.Walk and WalkAnim then
					WalkAnim.AnimationId = currentanims.Walk
				end
				local RunAnim = run:WaitForChild("RunAnim")
				if currentanims.Run and RunAnim then
					RunAnim.AnimationId = currentanims.Run
				end
				local SwimAnim = swim:WaitForChild("Swim")
				if currentanims.Swim and SwimAnim then
					SwimAnim.AnimationId = currentanims.Swim
				end
				local SwimIdleAnim = swimidle:WaitForChild("SwimIdle")
				if currentanims.SwimIdle and SwimIdleAnim then
					SwimIdleAnim.AnimationId = currentanims.SwimIdle
				end
				local JumpAnim = jump:WaitForChild("JumpAnim")
				if currentanims.Jump and JumpAnim then
					JumpAnim.AnimationId = currentanims.Jump
				end
				local FallAnim = fall:WaitForChild("FallAnim")
				if currentanims.Fall and FallAnim then
					FallAnim.AnimationId = currentanims.Fall
				end
				local ClimbAnim = climb:WaitForChild("ClimbAnim")
				if currentanims.Climb and ClimbAnim then
					ClimbAnim.AnimationId = currentanims.Climb
				end
			end
		end
	end
end
function changeAnimations(anims)
	currentanims.Idle1 = anims.Idle1
	currentanims.Idle2 = anims.Idle2
	currentanims.Walk = anims.Walk
	currentanims.Run = anims.Run
	currentanims.Fall = anims.Fall
	currentanims.Jump = anims.Jump
	currentanims.Climb = anims.Climb
	currentanims.Swim = anims.Swim
	currentanims.SwimIdle = anims.SwimIdle
	setAnimations(lplrchar)
	print("animations changed")
end
workspace.ChildAdded:Connect(function(char)
	if char:IsA("Model") and char.Name == lplr.Name then
		lplrchar = char
		setAnimations(lplrchar)
	end
end)
for _, v in pairs(anims) do
	assignButtonFunctions(v.Button,function()
		print(v.Button.Name.." callback")
		changeAnimations({
			Idle1 = v.Idle1;
			Idle2 = v.Idle2;
			Walk = v.Walk;
			Run = v.Run;
			Fall = v.Fall;
			Jump = v.Jump;
			Climb = v.Climb;
			Swim = v.Swim;
			SwimIdle = v.SwimIdle;
		})
	end)
end
for i, v in pairs(customanims) do
	local ticket = 0
	local TextBox = v.TextBox
	local function textBoxErrorMessage(Text)
		ticket += 1
		local currentticket = ticket
		TextBox.Text = ""
		TextBox.PlaceholderText = Text
		task.wait(1.25)
		if currentticket == ticket then
			TextBox.PlaceholderText = v.PlaceholderText
		end
	end
	TextBox.FocusLost:Connect(function()
		TextBox.Interactable = false
		local ID = tonumber(TextBox.Text)
		if ID then
			local suc, err = pcall(function()
				local asset = MarketplaceService:GetProductInfo(ID)
				if asset.AssetTypeId ~= 24 then error("") end
			end)
			if suc then
				currentanims[i] = "rbxassetid://"..tostring(ID)
				if lplrchar then
					coroutine.wrap(setAnimations)(lplrchar)
				end
			end
			if err then
				textBoxErrorMessage("Invalid ID")
			end
		else
			if anims[ID:lower()] then
				currentanims[i] = "rbxassetid://"..anims[ID:lower()][i]
			else
				textBoxErrorMessage("ID Must Be A Number or Animation Name")
			end
		end
		TextBox.Interactable = true
	end)
end

Title.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragstart = input.Position
		startpos = Title.Position
		lastmousepos = UserInputService:GetMouseLocation()
		
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

Title.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		draginput = input
	end
end)
RunService.Heartbeat:Connect(function(dt)
	if not startpos then return end;
	if not dragging and lastgoalpos then
		Title.Position = UDim2.new(startpos.X.Scale, Lerp(Title.Position.X.Offset, lastgoalpos.X.Offset, dt * 8), startpos.Y.Scale, Lerp(Title.Position.Y.Offset, lastgoalpos.Y.Offset, dt * 8))
		return 
	end

	local delta = lastmousepos - UserInputService:GetMouseLocation()
	local xGoal = startpos.X.Offset - delta.X
	local yGoal = startpos.Y.Offset - delta.Y
	lastgoalpos = UDim2.new(startpos.X.Scale, xGoal, startpos.Y.Scale, yGoal)
	Title.Position = UDim2.new(startpos.X.Scale, Lerp(Title.Position.X.Offset, xGoal, dt * 8), startpos.Y.Scale, Lerp(Title.Position.Y.Offset, yGoal, dt * 8))
end)
