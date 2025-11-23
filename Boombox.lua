-- UNIVERSAL BOOMBOX GUI FULL: Playlist + Custom ID + Auto Replay + Draggable

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Xoá GUI cũ nếu có
local old = PlayerGui:FindFirstChild("UniversalBoomboxGUI")
if old then
    old:Destroy()
end

-- Playlist mẫu
local Playlist = {
    {"NCS - Fade", 279736812},
    {"NCS - Spectre", 276943716},
    {"NCS - Invincible", 298062207},
    {"Alan Walker - Force", 276008743},
    {"Alan Walker - Melody", 1446642325},
    {"Nightcore Remix 1", 145040965},
    {"Japan Type Beat", 1845554010},
    {"Phonk 1", 9025741301},
    {"Phonk 2", 6449184081},
}

local CurrentIndex = 1
local CurrentSound
local AutoPlay = false

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UniversalBoomboxGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 270, 0, 205)
Frame.Position = UDim2.new(0.5, -135, 0.5, -102)
Frame.BackgroundTransparency = 0.2
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Parent = ScreenGui

-- Kéo được
Frame.Active = true
Frame.Draggable = true

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 28)
Title.BackgroundTransparency = 1
Title.Text = "Universal Boombox"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = Frame

local TextBox = Instance.new("TextBox")
TextBox.Size = UDim2.new(1, -20, 0, 28)
TextBox.Position = UDim2.new(0, 10, 0, 35)
TextBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
TextBox.PlaceholderText = "Nhập SoundId / AssetId (bỏ trống = dùng playlist)"
TextBox.Text = ""
TextBox.TextColor3 = Color3.new(1, 1, 1)
TextBox.Font = Enum.Font.Gotham
TextBox.TextSize = 13
TextBox.ClearTextOnFocus = false
TextBox.Parent = Frame
Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0, 8)

local PlayButton = Instance.new("TextButton")
PlayButton.Size = UDim2.new(0.5, -15, 0, 28)
PlayButton.Position = UDim2.new(0, 10, 0, 70)
PlayButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
PlayButton.Text = "Play"
PlayButton.TextColor3 = Color3.new(1, 1, 1)
PlayButton.Font = Enum.Font.GothamBold
PlayButton.TextSize = 16
PlayButton.Parent = Frame
Instance.new("UICorner", PlayButton).CornerRadius = UDim.new(0, 8)

local StopButton = Instance.new("TextButton")
StopButton.Size = UDim2.new(0.5, -15, 0, 28)
StopButton.Position = UDim2.new(0.5, 5, 0, 70)
StopButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
StopButton.Text = "Stop"
StopButton.TextColor3 = Color3.new(1, 1, 1)
StopButton.Font = Enum.Font.GothamBold
StopButton.TextSize = 16
StopButton.Parent = Frame
Instance.new("UICorner", StopButton).CornerRadius = UDim.new(0, 8)

local NextButton = Instance.new("TextButton")
NextButton.Size = UDim2.new(0.5, -15, 0, 25)
NextButton.Position = UDim2.new(0, 10, 0, 105)
NextButton.BackgroundColor3 = Color3.fromRGB(50, 50, 120)
NextButton.Text = "Next (Playlist)"
NextButton.TextColor3 = Color3.new(1, 1, 1)
NextButton.Font = Enum.Font.GothamBold
NextButton.TextSize = 13
NextButton.Parent = Frame
Instance.new("UICorner", NextButton).CornerRadius = UDim.new(0, 8)

local RandomButton = Instance.new("TextButton")
RandomButton.Size = UDim2.new(0.5, -15, 0, 25)
RandomButton.Position = UDim2.new(0.5, 5, 0, 105)
RandomButton.BackgroundColor3 = Color3.fromRGB(120, 50, 50)
RandomButton.Text = "Random (Playlist)"
RandomButton.TextColor3 = Color3.new(1, 1, 1)
RandomButton.Font = Enum.Font.GothamBold
RandomButton.TextSize = 13
RandomButton.Parent = Frame
Instance.new("UICorner", RandomButton).CornerRadius = UDim.new(0, 8)

local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(1, -20, 0, 22)
InfoLabel.Position = UDim2.new(0, 10, 0, 135)
InfoLabel.BackgroundTransparency = 1
InfoLabel.Text = "Status: Idle"
InfoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
InfoLabel.Font = Enum.Font.Gotham
InfoLabel.TextSize = 12
InfoLabel.TextXAlignment = Enum.TextXAlignment.Left
InfoLabel.Parent = Frame

local CurrentTrackLabel = Instance.new("TextLabel")
CurrentTrackLabel.Size = UDim2.new(1, -20, 0, 22)
CurrentTrackLabel.Position = UDim2.new(0, 10, 0, 155)
CurrentTrackLabel.BackgroundTransparency = 1
CurrentTrackLabel.Text = "Track: None"
CurrentTrackLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
CurrentTrackLabel.Font = Enum.Font.Gotham
CurrentTrackLabel.TextSize = 12
CurrentTrackLabel.TextXAlignment = Enum.TextXAlignment.Left
CurrentTrackLabel.Parent = Frame

local AutoPlayButton = Instance.new("TextButton")
AutoPlayButton.Size = UDim2.new(1, -20, 0, 22)
AutoPlayButton.Position = UDim2.new(0, 10, 0, 180)
AutoPlayButton.BackgroundColor3 = Color3.fromRGB(80, 80, 20)
AutoPlayButton.Text = "Auto Play: OFF"
AutoPlayButton.TextColor3 = Color3.new(1, 1, 1)
AutoPlayButton.Font = Enum.Font.GothamBold
AutoPlayButton.TextSize = 12
AutoPlayButton.Parent = Frame
Instance.new("UICorner", AutoPlayButton).CornerRadius = UDim.new(0, 8)

-- ===== Functions =====

local function stopSound()
    if CurrentSound and CurrentSound.Parent then
        CurrentSound:Stop()
        CurrentSound:Destroy()
    end
    CurrentSound = nil
end

local function playSoundWithInfo(name, id)
    stopSound()
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://" .. id
    sound.Volume = 5
    sound.Looped = false
    sound.Parent = workspace

    sound.Ended:Connect(function()
        InfoLabel.Text = "Status: Ended"
        if AutoPlay then
            task.delay(0.2, function()
                if name then
                    playSoundWithInfo(name, id)
                else
                    playSoundWithInfo(nil, id)
                end
            end)
        end
    end)

    sound.Loaded:Connect(function()
        InfoLabel.Text = "Status: Playing"
    end)

    sound:Play()
    CurrentSound = sound

    if name then
        CurrentTrackLabel.Text = "Track: " .. name .. " (" .. id .. ")"
    else
        CurrentTrackLabel.Text = "Track: Custom ID (" .. id .. ")"
    end

    InfoLabel.Text = "Status: Loading..."
end

local function playByIndex(i)
    if #Playlist == 0 then
        InfoLabel.Text = "Status: Playlist rỗng"
        return
    end
    if i < 1 then i = #Playlist end
    if i > #Playlist then i = 1 end
    CurrentIndex = i

    local name = Playlist[CurrentIndex][1]
    local id = Playlist[CurrentIndex][2]
    playSoundWithInfo(name, id)
end

-- ===== Button Events =====

PlayButton.MouseButton1Click:Connect(function()
    local text = TextBox.Text:match("%S+")
    if not text or text == "" then
        playByIndex(CurrentIndex)
        return
    end

    local id = tonumber(text)
    if not id then
        local num = text:match("(%d+)")
        if num then
            id = tonumber(num)
        end
    end

    if not id then
        InfoLabel.Text = "Status: Id xàm"
        return
    end

    playSoundWithInfo(nil, id)
end)

StopButton.MouseButton1Click:Connect(function()
    if CurrentSound then
        stopSound()
        InfoLabel.Text = "Status: Stopped"
    else
        InfoLabel.Text = "Status: Không có gì để stop"
    end
end)

NextButton.MouseButton1Click:Connect(function()
    playByIndex(CurrentIndex + 1)
end)

RandomButton.MouseButton1Click:Connect(function()
    if #Playlist == 0 then
        InfoLabel.Text = "Status: Playlist rỗng"
        return
    end
    local randomIndex = math.random(1, #Playlist)
    playByIndex(randomIndex)
end)

AutoPlayButton.MouseButton1Click:Connect(function()
    AutoPlay = not AutoPlay
    if AutoPlay then
        AutoPlayButton.Text = "Auto Play: ON"
        InfoLabel.Text = "Status: Auto replay bật"
    else
        AutoPlayButton.Text = "Auto Play: OFF"
        InfoLabel.Text = "Status: Auto replay tắt"
    end
end)
