local imgui = require 'imgui'
require 'functions.functii'
require "functions.account"

status = false
activated = 0
listbox_array = {}

local title = "B-Hood Pin Bruteforce"
local winX = 700
local winY = 420
local loaded_pins = 0
local date_start = ""
local listbox_selected = imgui.ImInt(0)
local enable_clock = 0

input1 = imgui.ImInt(5)
input2 = imgui.ImInt(5)
input3 = imgui.ImInt(5)


-- Style
function apply_custom_style()
	local style = imgui.GetStyle()
	style.WindowRounding = 0
	style.WindowPadding = imgui.ImVec2(10, 10)
	local colors = style.Colors
	local st = imgui.Col
	colors[st.TitleBg] = imgui.ImVec4(255, 0, 0 ,1)
	colors[st.TitleBgActive] = imgui.ImVec4(255, 0, 0, 1)
	colors[st.WindowBg] = imgui.ImVec4(0.10, 0.10, 0.10, 1)
	colors[st.Button] = imgui.ImVec4(255, 0, 0, 1)
	colors[st.FrameBg] = imgui.ImVec4(0.18, 0.18, 0.18, 1) 
	colors[st.ScrollbarBg] = imgui.ImVec4(0.10, 0.10, 0.10, 1)
	colors[st.ScrollbarGrab] = imgui.ImVec4(255, 0, 0, 1)
	colors[st.ScrollbarGrabHovered] = imgui.ImVec4(255, 0, 0, 1)
	colors[st.ScrollbarGrabActive] = imgui.ImVec4(150, 0, 0, 1)
	colors[st.Border] = imgui.ImVec4(255, 0, 0, 1)
	colors[st.BorderShadow] = imgui.ImVec4(255, 0, 0, 1)
	colors[st.Separator] = imgui.ImVec4(255, 0, 0, 1)
	colors[st.Header] = imgui.ImVec4(255, 0, 0, 1) -- selected item listbox
	colors[st.HeaderHovered] = imgui.ImVec4(255, 0, 0, 1)
	colors[st.HeaderActive] = imgui.ImVec4(255, 0, 0, 1)
end

apply_custom_style()


function imgui.OnDrawFrame()
	imgui.SetNextWindowSize(imgui.ImVec2(20 + (winX / 2), 45 + ((winY / 2) * 2 ) ))
	imgui.Begin("B-HOOD Pin Bruteforce", _, imgui.WindowFlags.NoResize)

	imgui.BeginChild("List", imgui.ImVec2(winX / 2, 185), true)
	imgui.PushItemWidth(-1)
	imgui.ListBox("",  listbox_selected, listbox_array, 9)
	imgui.PopItemWidth()
	imgui.EndChild()

	imgui.BeginChild("Value", imgui.ImVec2(winX / 2, 90), true)
	
	if imgui.InputInt("Delay", input3) then 
		if (input3.v < 0) or (input3.v > 9999) then 
			input3.v = 1
			delay = 10
		else
			delay = input3.v
		end
	end
	if imgui.InputInt("De la", input1) then
		if (input1.v < 0) or (input1.v > 9999) then 
			input1.v = 0
			input2.v = 2
		end
		if input1.v >= input2.v then 
			input1.v = 0
		end
	end
	if imgui.InputInt("Pana la", input2) then 
		if input2.v < 0 or (input2.v > 9999) then
			input1.v = 0 
			input2.v = 2
		end

	end
	imgui.EndChild()
	imgui.BeginChild("Button", imgui.ImVec2(winX / 2, 70), true)
	if imgui.Button("Start Attack", imgui.ImVec2(161, 25)) then
		passed_date = ""
		passed_pin = ""

		if loaded_pins == 1 then
			log("{00ff00}", "Bruteforce Attack started...")
			activated = 1
			start = 1
			sampConnectToServer("rpg.b-hood.ro", 7777)
		else
			log("{ffff1a}", "Prima data apesi pe 'Load Pins'")
		end
	end
	imgui.SameLine()
	if imgui.Button("Stop Attack", imgui.ImVec2(161, 25)) then
		if activated == 1 then
			log("{00ff00}", "Bruteforce Attack stopped...")
			activated = 0
			sampConnectToServer("rpg.b-hood.ro", 7777)
			enable_clock = 0
			start = 1
		else
			log("{ffff1a}", "Nu poti opri un attack care inca nu a inceput'")
		end
	end
	if imgui.Button("Reconnect", imgui.ImVec2(161, 25)) then
		sampConnectToServer("rpg.b-hood.ro", 7777)
	end
	imgui.SameLine()
	if imgui.Button("Load Pins", imgui.ImVec2(161, 25)) then
		log("{00ff00}","Pins Loaded")
		date_start = string.format("%s", os.date("%c"))
		clean_array()
		generate_pins()
		loaded_pins = 1
		enable_clock = 1
	end
	imgui.EndChild()
	
	imgui.BeginChild("Text", imgui.ImVec2(winX / 2, 72), true)
	imgui.Text("Loaded at:")
	imgui.SameLine()
	imgui.TextColored(imgui.ImVec4(255.0, 0.0, 0.0, 1.0), date_start)
	imgui.Text("Current time:")
	if enable_clock == 1 then
		imgui.SameLine()
		imgui.TextColored(imgui.ImVec4(225.0, 255.0, 0.0, 1.0), os.date("%c"))
	end
	imgui.Text("Passed pin:")
	imgui.SameLine()
	imgui.TextColored(imgui.ImVec4(0.0, 255.0, 0.0, 1.0), passed_pin)

	imgui.EndChild()
	imgui.End()
end

function main()
	generate_pins()
	while true do
		wait(0)
		if wasKeyPressed(0x71) then
			status = not status
		end
		imgui.Process = status 
	end
end
