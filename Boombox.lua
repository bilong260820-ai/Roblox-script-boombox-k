-- ==== BOOMBOX GUI SCRIPT ==== --

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Tạo ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.Name = "BoomboxGUI"

-- Tạo Frame chính
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Auto Play Button
local AutoPlayBtn = Instance.new("TextButton")
AutoPlayBtn.Size = UDim2.new(0, 200, 0, 50)
AutoPlayBtn.Position = UDim2.new(0.5, -100, 0, 10)
AutoPlayBtn.Text = "Auto Play: OFF"
AutoPlayBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
AutoPlayBtn.TextColor3 = Color3.new(1,1,1)
AutoPlayBtn.Parent = MainFrame

local autoPlay = false
AutoPlayBtn.MouseButton1Click:Connect(function()
    autoPlay = not autoPlay
    AutoPlayBtn.Text = autoPlay and "Auto Play: ON" or "Auto Play: OFF"
end)

-- List nhạc mẫu
local musicList = {
    {Name="Song 1", Id=12345678},
    {Name="Song 2", Id=23456789},
    {Name="Song 3", Id=34567890},
}

-- ScrollFrame để chứa button nhạc
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -20, 1, -80)
ScrollFrame.Position = UDim2.new(0, 10, 0, 70)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, #musicList * 50)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.Parent = MainFrame

-- Tạo button nhạc
for i, music in ipairs(musicList) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Position = UDim2.new(0, 0, 0, (i-1)*45)
    btn.Text = music.Name
    btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Parent = ScrollFrame

    btn.MouseButton1Click:Connect(function()
        -- Dừng nhạc cũ
        if LocalPlayer:FindFirstChild("CurrentBoomboxSound") then
            LocalPlayer.CurrentBoomboxSound:Stop()
            LocalPlayer.CurrentBoomboxSound:Destroy()
        end
        -- Tạo nhạc mới
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://"..music.Id
        sound.Volume = 1
        sound.Looped = false
        sound.Parent = LocalPlayer
        sound:Play()
        LocalPlayer:SetAttribute("CurrentBoomboxSound", sound)
    end)
end

-- Auto Play logic
RunService.RenderStepped:Connect(function()
    if autoPlay and LocalPlayer:GetAttribute("CurrentBoomboxSound") then
        local sound = LocalPlayer:GetAttribute("CurrentBoomboxSound")
        if not sound.IsPlaying then
            sound:Play()
        end
    end
end)
