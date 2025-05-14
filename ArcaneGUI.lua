-- Создаем окно
local Window = LuxtLib.CreateWindow("Arcane", "3926305904")

-- Добавляем вкладку
local MainTab = Window:Tab("Main")

-- Добавляем секцию
local PlayerSection = MainTab:Section("Player")

-- Добавляем элементы
PlayerSection:Button("Fly", function()
    print("Fly activated!")
end)

PlayerSection:Toggle("God Mode", false, function(state)
    print("God Mode:", state)
end)

PlayerSection:Slider("Walk Speed", 16, 100, 16, function(value)
    print("Walk Speed set to:", value)
end)

-- Добавляем другую вкладку
local SettingsTab = Window:Tab("Settings")

local ConfigSection = SettingsTab:Section("Configuration")

ConfigSection:KeyBind("Toggle GUI", "LeftAlt", function(key)
    print("GUI toggle key set to:", key)
end)
