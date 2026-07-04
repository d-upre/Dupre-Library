local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/d-upre/Dupre-Library/refs/heads/main/library.lua"))()

local Root = Library:Init("Universal")

local Tab1 = Root:Tab("Tab1")

local Section = Tab1:Section("Section Test")
local Section2 = Tab1:Section("Section Test 2")

Section:Toggle("Toggle Test", function(Bool)
	print(Bool)
end)

Section:TextBox("Text Box Test", "Placeholder", function(Text)
	print(Text)
end)

Root:Tab("Tab2")

task.wait(10)
Root.Screen:Destroy()
