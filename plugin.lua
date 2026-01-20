function draw()
	--if unknown, don't start; fixing nil startup errors
    if window_Shifter then
		--(min{x,y}, max{x,y})
		imgui.SetNextWindowSizeConstraints({200, 150}, {math.huge, math.huge})
--		functionpass--tell window to startup
		window_Shifter()---16
    end
end
--table setups
object = {}--get start times for bookmarks
pharseobject = {}
words = {}--get words for bookmarks
tablet = {}--table-t or tablet, name not yet related to use
--varable setups
local pharse_Switch = false
-- UPPERCASING;FUNCTION_VARABLE, MiddleCasing;global_Varable, downcasing;local_varable/table
-- Shortening;UPPERCASING
function window_Shifter()
--	function pass--create styles for window
	stylystartup()---94
	--start window
	imgui.Begin("Placeholder.Shifter")
 ---shhhh
	drawing()
	--give ID; get value
	---add visual buffer({x, y})
	imgui.Dummy({100, 0})
	--create button/s
	button_Enter = imgui.Button("Enter", imgui_window_flags.Resize);
	imgui.SameLine(0, 0);
	local button_Clear = false
	if get("input", "") ~= "" then 
		--create clear button
		button_Clear = imgui.Button("Clear")
	end
	imgui.SameLine(0, 0);
	button_Pharse = imgui.Button("Pharse")
	imgui.SameLine(0, 0);
	if pharseobject[1] ~= nil then
		imgui.Text("!")
	else
		imgui.TextDisabled("!")
	end
	imgui.SameLine(0, 0);
	if pharse_Switch then
		imgui.Text("!")
	else
		imgui.TextDisabled("!")
	end

	--create input auto resizeing:
	liness = 1;
	for _ in get("input", ""):gmatch("\n") do
		liness = liness + 1
	end
	---confused on how these mean, but do work quite well
	maxLine = 0;
	for liness in get("input", ""):gmatch("[^\n]*") do
		maxLine = math.max(maxLine, #liness)
	end
	size_X = math.max(180, maxLine * 8);
	size_Y = math.max(20, liness * 18);
	_, Asking = imgui.InputTextMultiline("", get("input", ""), 100000, {size_X, size_Y})
	--:create input auto resizing
	
	if button_Pharse then
		if #state.SelectedHitObjects ~= 0 then
			Fed = 1 ; Fed_minor = 1 ; hitObject_minor = 1 ; pharseobject = {}
			repeat
			hitObject = state.SelectedHitObjects[Fed].StartTime
			--if multiple hit objects are on the same time, skip all but one of them
			if hitObject ~= hitObject_minor then
				table.insert(pharseobject, hitObject)
				Fed_minor = Fed_minor + 1
			end
	--2
			hitObject_minor = state.SelectedHitObjects[Fed].StartTime
	--3	
			Fed = Fed + 1
			until Fed == #state.SelectedHitObjects + 1
			else
			if #pharseobject ~= 0 then
				pharse_Switch = tflipflop("Pharse Switch", false)
			end
		end
	end

	--set ID to input, give varable Asking as value
	if button_Clear then state.SetValue("input", "") 
	else state.SetValue("input", Asking) end
	state.SetValue("Pharse Switch", pharse_Switch)
	--askInput placed after all other askInput to have final say
	
	--:create input auto resizeing
	--check if button is pressed
	if button_Enter then
		---if no notes are selected; cannot continue
		if #state.SelectedHitObjects == 0 then return end
--		function pass
		hallpass_section_0()---121
	end
	
	--check inventory for hallpass #1
	if Hallpass == 1 then
--		function pass
		hallpass_section_1()---136
	end
	--check inventory for hallpass #2
	if Hallpass == 2 then
--		function pass
		hallpass_section_2()---162
	end
	
--	function pass
	resetbutton_section()---172
	---end window script
	imgui.End()
end


--functions:
function tflipflop(ID, DEFAULT)
	local current = state.GetValue(ID)
	if current == nil then
		current = DEFAULT or false
	end
	local next = not current
	state.SetValue(ID, next)
	return next
end
---Get ID; Give value
function get(IDENTIFIER, DEFAULTVALUE)
	return state.GetValue(IDENTIFIER) or DEFAULTVALUE
end
--Shortcuts
---styly shortcut:
function stylyC(IMG, TABLE)
		imgui.PushStyleColor(IMG, TABLE)
end
function stylyV(IMG, TABLE)
		imgui.PushStyleVar(IMG, TABLE)
end
---:styly shortcut

--functions to make main easier on the eyes
function stylystartup()
	--color stuff
	stylyC(imgui_col.Text, {1, 1, 1, 1})
	stylyC(imgui_col.Border, {.13, .07, .5, 1})
	stylyC(imgui_col.WindowBg, {0, 0, 0, .5})
	stylyC(imgui_col.FrameBg, {.09, .09, .09, 1})
	stylyC(imgui_col.FrameBgHovered, {0, .82, 1, .4})
	stylyC(imgui_col.FrameBgActive, {.26, .59, .98, .67})
	stylyC(imgui_col.TitleBg, {.13, .07, .5, 1})
	stylyC(imgui_col.TitleBgActive, {.14, 0.11, .36, 1})
	stylyC(imgui_col.TitleBgCollapsed, {0, 0, 0, .5})
	stylyC(imgui_col.ScrollbarBg, {.02, 0.02, 0.02, .5})
	stylyC(imgui_col.ScrollbarGrab, {.09, .09, .09, 1})
	stylyC(imgui_col.ScrollbarGrabHovered, {.13, .07, .5, 1})
	stylyC(imgui_col.ScrollbarGrabActive, {.34, .34, .34, 1})
	stylyC(imgui_col.Button, {.09, .09, .09, 1})
	stylyC(imgui_col.ButtonHovered, {.34, .34, .34, 1})
	stylyC(imgui_col.ButtonActive, {.14, .11, .36, 1})
	stylyC(imgui_col.ResizeGrip, {.13, .07, .5, 1})
	stylyC(imgui_col.ResizeGripHovered, {.09, .09, .09, 1})
	stylyC(imgui_col.ResizeGripActive, {.34, .34, .34, 1})
	--stylish stuff
	stylyV(imgui_style_var.WindowPadding, {0, 5})
	stylyV(imgui_style_var.WindowRounding, 6)
	stylyV(imgui_style_var.WindowTitleAlign, {.5, .5})
end
---hallpass sections:
function hallpass_section_0()
	--remove all of table
	words = {}
	--set to not ready for other scripts
	Ready = "no"
	--find words player inputed
	for k in string.gmatch(Asking, "%g+") do
		table.insert(words, #words+1, k)
	end
	Ready = "yes"
	--give hallpass #1 access
	Hallpass = 1
end
function hallpass_section_1()
	--reset varables
	Fed = 1 ; Fed_minor = 1 ; hitObject_minor = 1 ; table_num = 0
	--1^insert to table, add bookmarks
	--2^-set p-hitObject 1 note behind Fed
	--2^cyle until varable = # selected notes
	--1
		repeat
			if pharse_Switch then
			pharsehitObject = pharseobject[Fed]
			else pharsehitObject = state.SelectedHitObjects[Fed].StartTime end
			hitObject = pharsehitObject
			--if multiple hit objects are on the same time, skip all but one of them
			if hitObject ~= hitObject_minor then
				table.insert(object, utils.CreateBookmark(hitObject, words[Fed_minor]))
				Fed_minor = Fed_minor + 1
			end
	--2
			hitObject_minor = pharsehitObject
	--3
			Fed = Fed + 1
			if pharse_Switch then table_num = #pharseobject else table_num = #pharseobject end
		until Fed == table_num + 1
	--if condisions are set and ready, contiue and create bookmark
	if Ready == "yes" then
		print("i!", Fed_minor-1 .. " bookmarks added")
		actions.Perform(utils.CreateEditorAction(action_type.AddBookmarkBatch, object))
	end
	--give hallpass #2 access
	Hallpass = 2
end
function hallpass_section_2()
	--set varable to table
	num_Us = table.unpack(object)
	--clear all of table
	object = {}
	--reset hallpass
	Hallpass = 0
end
---:hallpass sections
---create reset button
function resetbutton_section()
	--reset table for infinate loop
	tablet = {}
	--strip visual region of menu(x, y); insert seperately into tablet
	for k in string.gmatch(table.concat(imgui.GetWindowSize(), ", "), "%d+") do
		table.insert(tablet, #tablet+1, k)
	end
	--manually adjust table for button position(x, y)
	tablet = {tablet[1] - 60, tablet[2] - 40}
	--set button position to tablet({x, y})
	imgui.SetCursorPos(tablet)
	--only if window size is different than default, show button
	if table.concat(imgui.GetWindowSize(), ", ") ~= "400, 300" then
		--useful reset button
		if imgui.Button("Reset") then
			imgui.SetWindowSize({400, 300})
		end
	end
end




----------	shhhh
function drawing()
	local drawlist = imgui.GetWindowDrawList()
	local position = {100, 100}
	local position2 = {200, 200}
	local position3 = {300, 300}
	local radius = 6
	local whiteColor = 16 ^ 8 - 1
	local numV = 500
	drawlist.AddLine({numV-29, numV-19}, {numV-12, numV-18.5}, whiteColor, 3)
	drawlist.AddLine({numV+29, numV-19}, {numV+12, numV-18.5}, whiteColor, 3)
	drawlist.AddCircleFilled({numV+20, numV-15}, radius, whiteColor)
	drawlist.AddCircleFilled({numV-20, numV-15}, radius, whiteColor)
	drawlist.AddLine({numV-10, numV+6}, {numV, numV}, whiteColor, 3)
	drawlist.AddLine({numV-20, numV+7}, {numV-10, numV+6}, whiteColor, 3)
	drawlist.AddLine({numV-20, numV+7}, {numV-25, numV+3}, whiteColor, 3)
	drawlist.AddLine({numV+10, numV+6}, {numV, numV}, whiteColor, 3)
	drawlist.AddLine({numV+20, numV+7}, {numV+10, numV+6}, whiteColor, 3)
	drawlist.AddLine({numV+20, numV+7}, {numV+25, numV+3}, whiteColor, 3)
end
