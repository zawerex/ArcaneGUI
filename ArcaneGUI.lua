local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/zawerex/Kavo-UI/refs/heads/main/shiro.lua"))()
local userInputService = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")
local runService = game:GetService("RunService")
local playersService = game:GetService("Players")
local Lighting = game:GetService("Lighting")

local RB = Color3.new(1, 0, 0)
local activationDistance = 22.5
local parryEnabled = false
local spamEnabled = false
local espEnabled = false
local lastBallPos
local ball
local rainbowTime = 0
local lastHitTime = 0
local hitCooldown = 0 -- 

local function Hit()
    local currentTime = tick()
    if currentTime - lastHitTime >= hitCooldown then
        game:GetService("VirtualInputManager"):SendKeyEvent(true, "F", false, game)
        lastHitTime = currentTime
    end
end

local function Spam()
    task.wait(0)
    local spamConnection
    spamConnection = runService.RenderStepped:Connect(function()
        if not ball or ball.Highlight.FillColor ~= RB then
            spamConnection:Disconnect()
            return
        end
        game:GetService("VirtualInputManager"):SendKeyEvent(true, "F", false, game)
    end)
end


local Window = Library.CreateLib("Arcane", "BloodTheme") 


local MainTab = Window:NewTab("Main")
local MainSection1 = MainTab:NewSection("Basic Functions")

MainSection1:NewToggle("AutoParry", "Automatically parries attacks", function(State)
    parryEnabled = State
    print("AutoParry:", State)
end)

MainSection1:NewToggle("ESP Ball", "Highlights the ball with rainbow colors", function(State)
    espEnabled = State
    print("ESP Ball:", State)
end)

MainSection1:NewToggle("AutoSpam", "Automatically spams attacks", function(State)
    spamEnabled = State
    print("AutoSpam:", State)
end)

MainSection1:NewButton("Teleport to spawn", "Returns you to start", function()
    game.Players.LocalPlayer.Character:MoveTo(Vector3.new(0, 10, 0))
end)


local AutoCurveSection = MainTab:NewSection("Automatic curve")

AutoCurveSection:NewToggle("Auto Curve", "Creates dynamic camera movements", function(State)
    if State then

        local originalCamera = workspace.CurrentCamera
        originalCamera.Name = "OriginalCamera_Backup"


        local fakeCamera = originalCamera:Clone()
        fakeCamera.Name = "Camera"
        fakeCamera.Parent = workspace

        workspace.CurrentCamera = fakeCamera


        local MOVEMENT_RANGE = 25
        local HEIGHT_VARIATION = 25
        local CHANGE_INTERVAL = 1


        local directions = {
            Vector3.new(0, 1, 0),   -- Вверх
            Vector3.new(1, 0, 0),   -- Вправо
            Vector3.new(-1, 0, 0),  -- Влево
            Vector3.new(0, 0, -1),   -- Назад
            Vector3.new(0, 0, 1),   -- Вперёд
        }

        local function getRandomPosition(basePos)
            return basePos + Vector3.new(
                math.random(-MOVEMENT_RANGE, MOVEMENT_RANGE),
                math.random(-HEIGHT_VARIATION, HEIGHT_VARIATION),
                math.random(-MOVEMENT_RANGE, MOVEMENT_RANGE)
            )
        end

        coroutine.wrap(function()
            while State and workspace:FindFirstChild("OriginalCamera_Backup") do
                local player = playersService.LocalPlayer
                if player then
                    local character = player.Character
                    if character and character:FindFirstChild("HumanoidRootPart") then
                        local charPos = character.HumanoidRootPart.Position
                      
                        local randomDir = directions[math.random(1, #directions)]
                        
                        originalCamera.CFrame = CFrame.new(
                            getRandomPosition(charPos),
                            charPos + randomDir
                        )
                    end
                end
                wait(CHANGE_INTERVAL)
            end
            
            if not State then
                if workspace:FindFirstChild("OriginalCamera_Backup") then
                    workspace.CurrentCamera = workspace.OriginalCamera_Backup
                    workspace.OriginalCamera_Backup.Name = "Camera"
                    if fakeCamera then fakeCamera:Destroy() end
                end
            end
        end)()
    else

        if workspace:FindFirstChild("OriginalCamera_Backup") then
            workspace.CurrentCamera = workspace.OriginalCamera_Backup
            workspace.OriginalCamera_Backup.Name = "Camera"
            if workspace:FindFirstChild("Camera") and workspace.Camera ~= workspace.OriginalCamera_Backup then
                workspace.Camera:Destroy()
            end
        end
    end
end)


local VisualTab = Window:NewTab("Visual")
local VisualSection = VisualTab:NewSection("Changing the sky and atmosphere")

local currentSkyTheme = nil
local skyLoopConnections = {}

local function stopCurrentSkyTheme()
    if currentSkyTheme then
       
        for _, connection in pairs(skyLoopConnections) do
            connection:Disconnect()
        end
        skyLoopConnections = {}
        currentSkyTheme = nil
    end
end

VisualSection:NewButton("Pink Sky", "Changes sky to pink theme", function()
    stopCurrentSkyTheme()
    currentSkyTheme = "Pink"
    
    local CONFIG = {
       Atmosphere = {
              Density = 0.500,
              Color = Color3.fromRGB(255, 180, 220),
              Decay = Color3.fromRGB(255, 180, 220),
              Glare = 0,
              Haze = 0,
              Offset = 0,
        },
        Sky = {
            SkyboxBk = "rbxassetid://12635309703",
            SkyboxDn = "rbxassetid://12635311686",
            SkyboxFt = "rbxassetid://12635312870",
            SkyboxLf = "rbxassetid://12635313718",
            SkyboxRt = "rbxassetid://12635315817",
            SkyboxUp = "rbxassetid://12635316856",
            StarCount = 1334,
            SunAngularSize = 15,
            MoonTextureId = "rbxassetid://1345054856",
            SunTextureId = "rbxassetid://1345009717"
        }
      
    }

    local function applySettings()
      -- Atmosphere
        local atmo = Lighting:FindFirstChildOfClass("Atmosphere") or Instance.new("Atmosphere")
        for prop, val in pairs(CONFIG.Atmosphere) do
            pcall(function() atmo[prop] = val end)
        end
        atmo.Parent = Lighting
        
        -- skyyy ebat 
        local sky = Lighting:FindFirstChildOfClass("Sky") or Instance.new("Sky")
        for prop, val in pairs(CONFIG.Sky) do
            if prop ~= "MoonTextureId" and prop ~= "SunTextureId" then
                pcall(function() sky[prop] = val end)
            end
        end
        

        if not sky:FindFirstChild("MoonTexture") then
            local moonTex = Instance.new("Texture")
            moonTex.Name = "MoonTexture"
            moonTex.Parent = sky
        end
        sky.MoonTexture.Texture = CONFIG.Sky.MoonTextureId
        

        if not sky:FindFirstChild("SunTexture") then
            local sunTex = Instance.new("Texture")
            sunTex.Name = "SunTexture"
            sunTex.Parent = sky
        end
        sky.SunTexture.Texture = CONFIG.Sky.SunTextureId
        
        sky.Parent = Lighting
    end

    applySettings()
    table.insert(skyLoopConnections, runService.RenderStepped:Connect(function()
        applySettings()
    end))
end)


VisualSection:NewButton("Red Sky", "Changes sky to red theme", function()
    stopCurrentSkyTheme()
    currentSkyTheme = "Red"
    
    local CONFIG = {
        Atmosphere = {
            Density = 0.526,
            Color = Color3.fromRGB(0.6, 0.1, 0.1),
            Decay = Color3.fromRGB(0.6, 0.1, 0.1),
            Glare = 0,
            Haze = 0,
            Offset = 0,
        },
        Sky = {
            SkyboxBk = "rbxassetid://17861496775",
            SkyboxDn = "rbxassetid://17861498383",
            SkyboxFt = "rbxassetid://17861500598",
            SkyboxLf = "rbxassetid://17861502862",
            SkyboxRt = "rbxassetid://17861504389",
            SkyboxUp = "rbxassetid://17861505772",
            StarCount = 2000,
            SunAngularSize = 21,
            MoonTextureId = "rbxasset://sky/moon.jpg",
            SunTextureId = "rbxasset://sky/sun.jpg"
        }
    }

    local function applySettings()
     
        local atmo = Lighting:FindFirstChildOfClass("Atmosphere") or Instance.new("Atmosphere")
        for prop, val in pairs(CONFIG.Atmosphere) do
            pcall(function() atmo[prop] = val end)
        end
        atmo.Parent = Lighting
        
        -- Sky
        local sky = Lighting:FindFirstChildOfClass("Sky") or Instance.new("Sky")
        for prop, val in pairs(CONFIG.Sky) do
            if prop ~= "MoonTextureId" and prop ~= "SunTextureId" then
                pcall(function() sky[prop] = val end)
            end
        end
        

        if not sky:FindFirstChild("MoonTexture") then
            local moonTex = Instance.new("Texture")
            moonTex.Name = "MoonTexture"
            moonTex.Parent = sky
        end
        sky.MoonTexture.Texture = CONFIG.Sky.MoonTextureId
        

        if not sky:FindFirstChild("SunTexture") then
            local sunTex = Instance.new("Texture")
            sunTex.Name = "SunTexture"
            sunTex.Parent = sky
        end
        sky.SunTexture.Texture = CONFIG.Sky.SunTextureId
        
        sky.Parent = Lighting
    end

    applySettings()
    table.insert(skyLoopConnections, runService.RenderStepped:Connect(function()
        applySettings()
    end))
end)


VisualSection:NewButton("Bloody Atmosphere", "Changes to bloody red theme", function()
    stopCurrentSkyTheme()
    currentSkyTheme = "Bloody"
    
    local CONFIG = {
        Atmosphere = {
            Density = 0.526,
            Color = Color3.fromRGB(1, 0, 0),
            Decay = Color3.fromRGB(1, 0, 0),
            Glare = 0,
            Haze = 0,
            Offset = 0,
        },
        Sky = {
            SkyboxBk = "rbxassetid://15832429892",
            SkyboxDn = "rbxassetid://15832430998",
            SkyboxFt = "rbxassetid://15832430998",
            SkyboxLf = "rbxassetid://15832430671",
            SkyboxRt = "rbxassetid://15832431198",
            SkyboxUp = "rbxassetid://15832429401",
            StarCount = 3000,
            SunAngularSize = 21,
            MoonTextureId = "rbxasset://sky/moon.jpg",
            SunTextureId = "rbxasset://sky/sun.jpg"
        }
    }

    local function applySettings()
          -- Atmosphere
        local atmo = Lighting:FindFirstChildOfClass("Atmosphere") or Instance.new("Atmosphere")
        for prop, val in pairs(CONFIG.Atmosphere) do
            pcall(function() atmo[prop] = val end)
        end
        atmo.Parent = Lighting
        
     
        local sky = Lighting:FindFirstChildOfClass("Sky") or Instance.new("Sky")
        for prop, val in pairs(CONFIG.Sky) do
            if prop ~= "MoonTextureId" and prop ~= "SunTextureId" then
                pcall(function() sky[prop] = val end)
            end
        end
    
        if not sky:FindFirstChild("MoonTexture") then
            local moonTex = Instance.new("Texture")
            moonTex.Name = "MoonTexture"
            moonTex.Parent = sky
        end
        sky.MoonTexture.Texture = CONFIG.Sky.MoonTextureId
        
  
        if not sky:FindFirstChild("SunTexture") then
            local sunTex = Instance.new("Texture")
            sunTex.Name = "SunTexture"
            sunTex.Parent = sky
        end
        sky.SunTexture.Texture = CONFIG.Sky.SunTextureId
        
        sky.Parent = Lighting
    end

    applySettings()
    table.insert(skyLoopConnections, runService.RenderStepped:Connect(function()
        applySettings()
    end))
end)

VisualSection:NewButton("Reset Sky", "Resets sky to default", function()
    stopCurrentSkyTheme()
 
    local sky = Lighting:FindFirstChildOfClass("Sky")
    if sky then
        sky:Destroy()
    end
    local atmo = Lighting:FindFirstChildOfClass("Atmosphere")
    if atmo then
        atmo:Destroy()
    end
end)


local ConfigTab = Window:NewTab("Configuration")
local InvisSection = ConfigTab:NewSection("Invisibility Settings")

local invisibilityEnabled = false
local invisibilitySettings = {
    Keybind = "E",
    Transparency = true,
    NoClip = false,
    FollowDistance = 10,
    FollowHeight = 1000
}


local function InitInvisibilitySystem()
    local Player = game:GetService("Players").LocalPlayer
    local RealCharacter = Player.Character or Player.CharacterAdded:Wait()
    local IsInvisible = false
    local CanInvis = true

    RealCharacter.Archivable = true
    local FakeCharacter = RealCharacter:Clone()

  
    local Part = Instance.new("Part", workspace)
    Part.Anchored = true
    Part.Size = Vector3.new(4, 1, 4)
    Part.Transparency = 1
    Part.CanCollide = true

    
    local function UpdateFakePosition()
        if RealCharacter and RealCharacter:FindFirstChild("HumanoidRootPart") then
            local targetCFrame = RealCharacter.HumanoidRootPart.CFrame * CFrame.new(0, invisibilitySettings.FollowHeight, invisibilitySettings.FollowDistance)
            FakeCharacter.HumanoidRootPart.CFrame = targetCFrame
            Part.CFrame = targetCFrame * CFrame.new(0, -3, 0)
        end
    end

    local function UpdateRealPosition()
        if FakeCharacter and FakeCharacter:FindFirstChild("HumanoidRootPart") then
            local targetCFrame = FakeCharacter.HumanoidRootPart.CFrame * CFrame.new(0, -invisibilitySettings.FollowHeight, -invisibilitySettings.FollowDistance)
            RealCharacter.HumanoidRootPart.CFrame = targetCFrame
        end
    end

    FakeCharacter.Parent = workspace
    UpdateFakePosition()

    for i, v in pairs(RealCharacter:GetChildren()) do
        if v:IsA("LocalScript") then
            local clone = v:Clone()
            clone.Disabled = true
            clone.Parent = FakeCharacter
        end
    end

    if invisibilitySettings.Transparency then
        for i, v in pairs(FakeCharacter:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Transparency = 0.8
            end
        end
    end

    local function RealCharacterDied()
        CanInvis = false
        RealCharacter:Destroy()
        RealCharacter = Player.Character or Player.CharacterAdded:Wait()
        CanInvis = true
        IsInvisible = false
        
        FakeCharacter:Destroy()
        workspace.CurrentCamera.CameraSubject = RealCharacter.Humanoid

        RealCharacter.Archivable = true
        FakeCharacter = RealCharacter:Clone()
        
        Part:Destroy()
        Part = Instance.new("Part", workspace)
        Part.Anchored = true
        Part.Size = Vector3.new(4, 1, 4)
        Part.Transparency = 1
        Part.CanCollide = true
        
        FakeCharacter.Parent = workspace
        UpdateFakePosition()

        for i, v in pairs(RealCharacter:GetChildren()) do
            if v:IsA("LocalScript") then
                local clone = v:Clone()
                clone.Disabled = true
                clone.Parent = FakeCharacter
            end
        end
        
        if invisibilitySettings.Transparency then
            for i, v in pairs(FakeCharacter:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.Transparency = 0.8
                end
            end
        end
        
        RealCharacter.Humanoid.Died:Connect(function()
            RealCharacter:Destroy()
            FakeCharacter:Destroy()
        end)
        
        Player.CharacterAppearanceLoaded:Connect(RealCharacterDied)
    end

    RealCharacter.Humanoid.Died:Connect(function()
        RealCharacter:Destroy()
        FakeCharacter:Destroy()
    end)

    Player.CharacterAppearanceLoaded:Connect(RealCharacterDied)

    local invisRenderConnection = game:GetService("RunService").RenderStepped:Connect(function()
        if IsInvisible then
    
            UpdateRealPosition()
        else
      
            UpdateFakePosition()
        end
        
        if invisibilitySettings.NoClip and FakeCharacter:FindFirstChild("Humanoid") then
            FakeCharacter.Humanoid:ChangeState(11)
        end
    end)

    local function Invisible()
        if IsInvisible == false then
         
            local StoredCF = RealCharacter.HumanoidRootPart.CFrame
    
            RealCharacter.HumanoidRootPart.CFrame = FakeCharacter.HumanoidRootPart.CFrame
         
            FakeCharacter.HumanoidRootPart.CFrame = StoredCF
            RealCharacter.Humanoid:UnequipTools()
            Player.Character = FakeCharacter
            workspace.CurrentCamera.CameraSubject = FakeCharacter.Humanoid
            
            for i, v in pairs(FakeCharacter:GetChildren()) do
                if v:IsA("LocalScript") then
                    v.Disabled = false
                end
            end

            IsInvisible = true
        else
    
            local StoredCF = FakeCharacter.HumanoidRootPart.CFrame

            FakeCharacter.HumanoidRootPart.CFrame = RealCharacter.HumanoidRootPart.CFrame
         
            RealCharacter.HumanoidRootPart.CFrame = StoredCF
            FakeCharacter.Humanoid:UnequipTools()
            Player.Character = RealCharacter
            workspace.CurrentCamera.CameraSubject = RealCharacter.Humanoid
            
            for i, v in pairs(FakeCharacter:GetChildren()) do
                if v:IsA("LocalScript") then
                    v.Disabled = true
                end
            end
            
            IsInvisible = false
        end
    end

    local invisInputConnection = game:GetService("UserInputService").InputBegan:Connect(function(key, gamep)
        if gamep then return end
        if key.KeyCode.Name:lower() == invisibilitySettings.Keybind:lower() and CanInvis and RealCharacter and FakeCharacter then
            if RealCharacter:FindFirstChild("HumanoidRootPart") and FakeCharacter:FindFirstChild("HumanoidRootPart") then
                Invisible()
            end
        end
    end)

    return {
        Destroy = function()
            invisRenderConnection:Disconnect()
            invisInputConnection:Disconnect()
            if FakeCharacter then FakeCharacter:Destroy() end
            if Part then Part:Destroy() end
        end,
        UpdateSettings = function(newSettings)
            invisibilitySettings = newSettings
        end
    }
end

local invisibilitySystem = nil


InvisSection:NewToggle("Enable Invisibility", "Toggles invisibility system", function(State)
    invisibilityEnabled = State
    if State then
        invisibilitySystem = InitInvisibilitySystem()
    else
        if invisibilitySystem then
            invisibilitySystem.Destroy()
            invisibilitySystem = nil
        end
    end
end)


InvisSection:NewKeybind("Set Keybind", "Sets the key to toggle invisibility", Enum.KeyCode[invisibilitySettings.Keybind], function(Key)
    invisibilitySettings.Keybind = Key.Name
    if invisibilitySystem then
        invisibilitySystem.UpdateSettings(invisibilitySettings)
    end
end)

InvisSection:NewToggle("Transparency", "Makes fake character transparent", invisibilitySettings.Transparency, function(State)
    invisibilitySettings.Transparency = State
    if invisibilitySystem then
        invisibilitySystem.UpdateSettings(invisibilitySettings)
    end
end)

InvisSection:NewToggle("NoClip", "Enables NoClip for fake character", invisibilitySettings.NoClip, function(State)
    invisibilitySettings.NoClip = State
    if invisibilitySystem then
        invisibilitySystem.UpdateSettings(invisibilitySettings)
    end
end)

InvisSection:NewSlider("Follow Distance", "Distance behind original character", 50, 5, invisibilitySettings.FollowDistance, function(Value)
    invisibilitySettings.FollowDistance = Value
    if invisibilitySystem then
        invisibilitySystem.UpdateSettings(invisibilitySettings)
    end
end)

InvisSection:NewSlider("Follow Height", "Height above original character", 2000, 0, invisibilitySettings.FollowHeight, function(Value)
    invisibilitySettings.FollowHeight = Value
    if invisibilitySystem then
        invisibilitySystem.UpdateSettings(invisibilitySettings)
    end
end)

local InfoTab = Window:NewTab("Information")
local AboutSection = InfoTab:NewSection("About")

AboutSection:NewLabel("v1.0.0")
AboutSection:NewLabel("By Shrio")
AboutSection:NewButton("Copy Discord", "Copies invite link", function()
    setclipboard("gggg")
    print("Link copied!")
end)

local FunTab = Window:NewTab("Fun")
local FunSection = FunTab:NewSection("Entertainment Functions")

FunSection:NewButton("Random Teleport", "Teleports to random location", function()
    local Char = game.Players.LocalPlayer.Character
    if Char then
        local RandomPos = Vector3.new(
            math.random(-100, 100),
            math.random(10, 50),
            math.random(-100, 100))
        Char:MoveTo(RandomPos)
    end
end)

FunSection:NewToggle("Infinite Jump", "Allows jumping mid-air", function(State)
    if State then
        
    else
       
    end
end)

runService.RenderStepped:Connect(function()
    wait(0.031)
    
    if espEnabled then
        rainbowTime = rainbowTime + 0.01
        if rainbowTime > 1 then rainbowTime = 0 end
        
        local rainbowColor = Color3.fromHSV(rainbowTime, 1, 1)
        ball = game.Workspace:FindFirstChild("Part")
        if ball and ball:IsDescendantOf(game.Workspace) then
            ball.Color = rainbowColor
        end
    end

    ball = game.Workspace:FindFirstChild("Part")
    if not ball or not ball:IsDescendantOf(game.Workspace) then return end

    if ball.Highlight.FillColor == RB then
        local playerPos = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
        local ballPos = ball.Position

        if lastBallPos then
            local velocity = (ballPos - lastBallPos) / 0.3
            local futurePos = ballPos + velocity * 1.8
            local futureDist = (playerPos - futurePos).Magnitude
            
            if parryEnabled and futureDist <= activationDistance and (velocity.Magnitude > 1) then
                Hit()
                if spamEnabled then
                    Spam()
                end
            end
        end

        lastBallPos = ballPos
    end
end)
