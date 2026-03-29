local player = game.Players.LocalPlayer
local mouse = player:GetMouse()

-- GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "FlyGui"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 220, 0, 140)
Frame.Position = UDim2.new(0.4, 0, 0.4, 0)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

-- Заголовок
local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "FLY GUI"
Title.TextColor3 = Color3.new(1,1,1)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18

-- Кнопка полёта
local FlyButton = Instance.new("TextButton", Frame)
FlyButton.Size = UDim2.new(0.8, 0, 0, 30)
FlyButton.Position = UDim2.new(0.1, 0, 0.3, 0)
FlyButton.Text = "Fly: OFF"
FlyButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
FlyButton.TextColor3 = Color3.new(1,1,1)

-- Ползунок скорости
local SpeedBox = Instance.new("TextBox", Frame)
SpeedBox.Size = UDim2.new(0.8, 0, 0, 30)
SpeedBox.Position = UDim2.new(0.1, 0, 0.65, 0)
SpeedBox.Text = "Speed: 50"
SpeedBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
SpeedBox.TextColor3 = Color3.new(1,1,1)

-- Переменные
local flying = false
local speed = 50
local bodyVelocity
local bodyGyro

-- Функция полёта
local function startFly()
	local char = player.Character or player.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")

	bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
	bodyVelocity.Velocity = Vector3.new(0,0,0)
	bodyVelocity.Parent = hrp

	bodyGyro = Instance.new("BodyGyro")
	bodyGyro.MaxTorque = Vector3.new(1e9,1e9,1e9)
	bodyGyro.CFrame = hrp.CFrame
	bodyGyro.Parent = hrp

	while flying do
		local cam = workspace.CurrentCamera
		local moveDir = Vector3.new(0,0,0)

		if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
			moveDir = moveDir + cam.CFrame.LookVector
		end
		if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
			moveDir = moveDir - cam.CFrame.LookVector
		end
		if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
			moveDir = moveDir - cam.CFrame.RightVector
		end
		if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
			moveDir = moveDir + cam.CFrame.RightVector
		end

		bodyVelocity.Velocity = moveDir * speed
		bodyGyro.CFrame = cam.CFrame

		wait()
	end
end

local function stopFly()
	if bodyVelocity then bodyVelocity:Destroy() end
	if bodyGyro then bodyGyro:Destroy() end
end

-- Кнопка
FlyButton.MouseButton1Click:Connect(function()
	flying = not flying
	
	if flying then
		FlyButton.Text = "Fly: ON"
		startFly()
	else
		FlyButton.Text = "Fly: OFF"
		stopFly()
	end
end)

-- Изменение скорости
SpeedBox.FocusLost:Connect(function()
	local text = SpeedBox.Text
	local num = tonumber(string.match(text, "%d+"))
	if num then
		speed = num
		SpeedBox.Text = "Speed: "..speed
	else
		SpeedBox.Text = "Speed: "..speed
	end
end)
