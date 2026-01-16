function draw()
	--(min{x,y}, max{x,y})
		imgui.SetNextWindowSizeConstraints({400, 300}, {100000, 100000})
	--tell window to startup
	window_Shifter()
end

object = {}
words = {}
tablet = {}
settable = {}
-- UPPERCASING;FUNCTION_VARABLE, MiddleCasing;global_Varable, downcasing;local_varable/table
-- Shortening;UPPERCASING
function window_Shifter()
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
	--start window
	stylyV(imgui_style_var.WindowPadding, {0, 5})
	stylyV(imgui_style_var.WindowRounding, 6)
	stylyV(imgui_style_var.WindowTitleAlign, {.5, .5})
	imgui.Begin("Placeholder.Shifter")
	--give ID; get value
	local askID = get("input", "")
	--create button/s
	imgui.Dummy({100, 0})
	imgui.SameLine()
	button_Enter = imgui.Button("Enter", imgui_window_flags.Resize);
	--create button/s only once player has inputed a value
	if askID ~= "" then
		imgui.SameLine(); button_Delete = imgui.Button("Delete")
	end
	if utils.IsKeyDown(keys.J) then
		imgui.SameLine(); imgui.text("J")
		--1^Visual que
		--2^an askID located after inputed askID to override
		--
		if utils.IsKeyDown(keys.K) then
		--1
			imgui.SameLine(); imgui.text("K")
		--2
			askID = imgui.GetClipboardText()
		end
	end
	--an askID placed after all other askID to have final say
	if button_Delete then
		askID = ""
	end
	liness = 1
	for _ in askID:gmatch("\n") do
		liness = liness + 1
	end
	maxLine = 0
	for liness in askID:gmatch("[^\n]*") do
		maxLine = math.max(maxLine, #liness)
	end
		size_X = math.max(180, math.min(100000, (maxLine * 8)))
		size_Y = math.max(20, math.min(100000, (liness * 18)))
		_, Asking = imgui.InputTextMultiline("", askID, 100000, {size_X, size_Y})
		state.SetValue("input", Asking)
	--show everything player inputed
	--1^check if button is pressed
	--2^set to not ready to contiue
	--3^num_hitobjects = the # of selected notes
	--4^give hallpass #1 access
	--1
	if button_Enter then
		--if no notes are selected; cannot continue
		if #state.SelectedHitObjects == 0 then return end
		--1^remove all of table
		--2^Reset Varables
		--1
		repeat table.remove(words, #words) until (#words <= 0)
		--2
		Ready = "no"
		--find words player inputed
		for k in string.gmatch(Asking, "%g+") do
			table.insert(words, #words+1, k)
		end
		Ready = "yes"
	--3
		num_Hitobjects = #state.SelectedHitObjects
	--4
		Hallpass = 1
	end
	
	--1^add all selected notes to table
	--2^give hallpass #2 access
	--1
	if Hallpass == 1 then
		Fed = 1 ; Fed_minor = 1 ; phitObject = 1
		--1^insert to table, add bookmarks
		--2^cyle until varable = # selected notes
		--1
		repeat
			hitObject = state.SelectedHitObjects[Fed].StartTime
			--if multiple hit objects are on the same time, skip all but one of them
			if hitObject ~= phitObject then
				table.insert(object, utils.CreateBookmark(hitObject, words[Fed_minor]))
				Fed_minor = Fed_minor + 1
			end
			phitObject = state.SelectedHitObjects[Fed].StartTime
			Fed = Fed + 1
		--2
		until Fed == #state.SelectedHitObjects + 1
		--if condisions are set and ready, contiue and create bookmark
		if Ready == "yes" then
		print("i!", #state.SelectedHitObjects .. " bookmarks added")
			actions.Perform(utils.CreateEditorAction(action_type.AddBookmarkBatch, object))
		end
	--2
		Hallpass = 2
	end
	--1^delete all of table
	--2^set varable to table
	--3^reset hallpass
	--1
	if Hallpass == 2 then
	--2
		num_Us = table.unpack(object)
		--clear table
		repeat
		table.remove(object, #object)
		until (#object <= 0)
	--3
		Hallpass = 0
	end
	--reset table for infinate loop
	tablet = {}
		--strip visual region of menu(x, y); insert seperately into table
		for k in string.gmatch(table.concat(imgui.GetWindowSize(), ", "), "%d+") do
		table.insert(tablet, #tablet+1, k)
		end
	--manually adjust table for button position 1=x 2=y
	tablet = {tablet[1] - 60, tablet[2] - 40}
	--set button position to table(x, y)
	imgui.SetCursorPos(tablet)
	--if window size is different than default, show button
	if table.concat(imgui.GetWindowSize(), ", ") ~= "400, 300" then
		--useful reset button
		if imgui.Button("Reset") then
			imgui.SetWindowSize({400, 300})
		end
	end
	--end window script
	imgui.End()
end

--Get ID; Give value
function get(IDENTIFIER, DEFAULTVALUE)
    return state.GetValue(IDENTIFIER) or DEFAULTVALUE
end

function stylyC(IMG, TABLE)
		imgui.PushStyleColor(IMG, TABLE)
end
function stylyV(IMG, TABLE)
		imgui.PushStyleVar(IMG, TABLE)
end
