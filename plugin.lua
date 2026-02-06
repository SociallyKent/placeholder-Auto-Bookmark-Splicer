function draw()
	--(min{x,y}, max{x,y})
	imgui.SetNextWindowSizeConstraints({200, 150}, {math.huge, math.huge})
--	functionpass: window_Shifter()--tell window to startup
	window_Shifter()---16
end
----table setups
	bookmark = {}--get start times for bookmarks
	local bookym = {}
	removebookmark = {}
	pharseobject = {}
	words = {}--get words for bookmarks
	tablet = {}--table-t or tablet, name not yet related to use
	game = {window = {}}
----
----varable setups
	local switch_Pharse = false
	local switch_Copy = false
	local counter = 0
	timing = 0
	local total = 0
	size_buttons = {60, 20}
----
-- UPPERCASING;FUNCTION_VARABLE, downcasing;global, Middlecasing;local
-- Shortening;UPPERCASING
function window_Shifter()
	stylystartup()
	--start window
	imgui.Begin("Placeholder.Shifter")
 ---shh
	drawing()
	;--clear button
	----create input auto resizeing
		Line, maxLine = 1, 0
		for _ in get("input", ""):gmatch("\n") do
			Line = Line + 1
		end
		for Line in get("input", ""):gmatch("[^\n]*") do
			maxLine = math.max(maxLine, #Line)
		end
		size_X = math.max(180, maxLine * 8);
		size_Y = math.max(20, Line * 10);
	----
	;--create input
	_, Asking = imgui.InputTextMultiline("", get("input", ""), 100000, {imgui.GetWindowWidth()-60, size_Y}, imgui_input_text_flags.AutoSelectAll)
	set("input", Asking)
	--enter button functions
	if button_Enter and #state.SelectedHitObjects > 0 then
		hallpass_section_0()
		hallpass_section_1()
		hallpass_section_2()
	end
	enterbutton_section()
		sameLine()
	pharsebutton_section()
		sameLine()
	clearbutton_section()
	deletebutton_section()
		sameLine()
	copy_section()
	resetbutton_section()
	---end window script
	imgui.End()
end


;--Buttons--
function enterbutton_section()
	---create button
	imgui.SetCursorPos({0, 25})
	button_Enter = imgui.Button("Enter", size_buttons)
end
function pharsebutton_section()
	---create button
	;--inharents delete's position
	button_Pharse = imgui.Button("Pharse", size_buttons)
	----pharse switch indicators
		sameLine();
		if pharseobject[1] ~= nil
		then imgui.Text("!")
		else imgui.TextDisabled("!") end
		sameLine();
		if switch_Pharse
		then imgui.Text("!") 
		else imgui.TextDisabled("!") end
	----
	---create button function
	if button_Pharse then
		if #state.SelectedHitObjects == 0 then
			if #pharseobject ~= 0
			then switch_Pharse = tflipflop("Pharse Switch", false) end
			return false
		end
		hitObject_minor = 1 ; pharseobject = {}
		total = #state.SelectedHitObjects
		for i = 1, total do
			hitObject = state.SelectedHitObjects[i].StartTime
			--if multiple hit objects are on the same time, skip all but one of them
			if hitObject ~= hitObject_minor
			then table.insert(pharseobject, hitObject) end
			hitObject_minor = hitObject
		end
	end
end
-- clear button
function clearbutton_section()
	if get("input", "") == "" then return false end
	button_Clear = imgui.Button("Clear", {size_buttons[1]*.75, size_buttons[2]*1})
	if button_Clear then
		set("input", "")
	end
end
-- delete Button
function deletebutton_section()
	if #map.Bookmarks == 0 then return false end
	---create buttons
	imgui.SetCursorPos({getWindow_Size(imgui.GetWindowSize())[1] - 132, 25})
	if #state.SelectedHitObjects == 0 then 
		button_DeleteAll = imgui.Button("Delete All", size_buttons)
	else
		button_Delete = imgui.Button("Delete", size_buttons)
	end
	---create buttons' functions
	if button_DeleteAll then
		notebookmark = {}
		local Start = map.Bookmarks[1].StartTime
		local End = map.Bookmarks[#map.Bookmarks].StartTime
		delete_bookmarks(Start, End)
	else
		if button_Delete then
			delete_bookmarks()
		end
	end
end
-- copy button
function copy_section()
	if #map.Bookmarks == 0 then return false end
	---create buttons
	;--inharents delete's position
	if #state.SelectedHitObjects == 0 then
		button_CopyAll = imgui.Button("Copy All", {60, 20})
	else
		button_Copy = imgui.Button("Copy", {60, 20})
	end
	---create buttons' functions
	if button_CopyAll then
		notebookmark = {} ; betweenselectednotes_bookmarks(0, map.Bookmarks[#map.Bookmarks].StartTime)
		if not bookmark_Data then return end
		for i = 1, #bookmark_Data do
			table.insert(notebookmark, #notebookmark+1, bookmark_Data[i].Note)
		end
		--print completion and copy to clipboard
		print("i!", #notebookmark .. ", Bookmarks copied")
		imgui.SetClipboardText(table.concat(notebookmark, " "))
	else
		if button_Copy then
			notebookmark = {} ; betweenselectednotes_bookmarks()
			if not bookmark_Data then return end
			for i = 1, #bookmark_Data do
				table.insert(notebookmark, #notebookmark+1, bookmark_Data[i].Note)
			end
			--print completion and copy to clipboard
			print("i!", #notebookmark .. ", Bookmarks copied")
			imgui.SetClipboardText(table.concat(notebookmark, " "))
		end
	end
end
-- reset button
function resetbutton_section()
	if table.concat(imgui.GetWindowSize(), ", ") == "400, 300" then return false end
	---create button
	imgui.SetCursorPos(getWindow_Size(imgui.GetWindowSize(), {-60, -30}))
	---create button's function
	if imgui.Button("Reset") then
		imgui.SetWindowSize({400, 300})
	end
end
----
function getWindow_Size(SIZE, XY)
	local Table = {}
	for k in string.gmatch(table.concat(SIZE, ", "), "%d+") do
		table.insert(Table, #Table+1, k)
	end
	if XY then
		return {Table[1]+XY[1], Table[2]+XY[2]}
	end
	return Table
end
--shortcuts
----State values
	function get(IDENTIFIER, DEFAULTVALUE)
		return state.GetValue(IDENTIFIER) or DEFAULTVALUE end
	function set(IDENTIFIER, DEFAULTVALUE)
		return state.SetValue(IDENTIFIER,  DEFAULTVALUE) end
----
----imgui.SameLine
	function sameLine(X, Y)
		if type(X) ~= "number" then
			return imgui.SameLine(0, 0)
		else
			return imgui.SameLine(X, Y)
		end
	end
----
;
--functions:
function tflipflop(ID, DEFAULT)
	local Current = get(ID)
	if Current == nil then
		Current = DEFAULT or false
	end
	local Current = not Current
	set(ID, Current)
	return Current
end

--game.getBetweenselected_Notes
function betweenselectednotes()
	notesbetween_table = {}
	if switch_Pharse then
		notesbetween_table =
			{
			pharseobject[1], 
			pharseobject[#pharseobject]
			}
	else
	notesbetween_table =
		{
		state.SelectedHitObjects[1].StartTime, 
		state.SelectedHitObjects[#state.SelectedHitObjects].StartTime
		}
	end
	return true
end
--game.getBetweenselected_Bookmarks
function game.getBookmarks_between(START, END)
	local Bookmark = {}
	for _, v in ipairs(map.Bookmarks) do
		local BookmarkInside = v.StartTime >= START and v.StartTime < END
		if BookmarkInside then Bookmark[#Bookmark + 1] = v end
	end
	if #Bookmark == 0 then return false end
	return sort(Bookmark, sort_starttimes)
end
--betweenselectedauto_Bookmarks
function betweenselectednotes_bookmarks(START, END)
	if not START
	or not END
	then 
		betweenselectednotes()
		START = notesbetween_table[1]
		END = notesbetween_table[2]
	end
	bookmark_Data = game.getBookmarks_between(START, END + 0.001)
end
----sort
	--sort_Starttimes
	function sort_starttimes(A, B)
		return A.StartTime < B.StartTime
	end
	--sort_Table
	function sort(TABLE, COMP)
		local Table = table.duplicate(TABLE)
		table.sort(Table, COMP)
		return Table
	end
----
----custom table.
if true then
	--table.create
	function table.create(VARA)
		local Table = {}
		for _, v in ipairs({VARA}) do
			Table[#Table + 1] = v
		end
		setmetatable(Table, {__index = table})
		return Table
	end
	--table.create_Keys
	function table.create_keys(TABLE)
		local Table = table.create()
		for i, _ in pairs(TABLE) do
			Table[#Table + 1] = i
		end
		return table.remove_duplicate(Table)
	end
	--table.duplicate
	function table.duplicate(TABLE)
		if not TABLE then return {} end
		local Table = {}
		if (TABLE[1]) then
			for i = 1, #TABLE do
				local Value = TABLE[i]
				Table[#Table + 1] = type(Value) == "table" and table.duplicate(Value) or Value
			end
		else
			for _, v in ipairs(table.create_keys(TABLE)) do
				local Value = TABLE[v]
				Table[v] = type(Value) == "table" and table.duplicate(Value) or Value
			end
		end
		return Table
	end
	--table.remove_Duplicate
	function table.remove_duplicate(TABLE)
		local Vara = {}
		local Table = {}
		for i = 1, #TABLE do
			local Value = TABLE[i]
			if (not Vara[Value]) then
				Table[#Table + 1] = Value
				Vara[Value] = true
			end
		end
		return Table
	end
end
----


----hallpass
function hallpass_section_0()
	Ready = false
	----reset
		words = {} 
	----
	----start making bookmark data
		for k in string.gmatch(Asking, "%g+") do
			table.insert(words, #words+1, k)
		end
	----
	Ready = true
end
--toadd_Bookmarks
function hallpass_section_1()
	----prepare
	bookmark = {} ; hitObject_minor, counter = 1, 0
	if switch_Pharse then
		total = #pharseobject else total = #state.SelectedHitObjects
	end
	----
	----finish making bookmark data
	for i = 1, total do
		if switch_Pharse then
			hitObject = pharseobject[i]
		else
			hitObject = state.SelectedHitObjects[i].StartTime
		end
		--if multiple hit objects are on the same time, skip all but one of them
		if hitObject ~= hitObject_minor then
			counter = counter + 1
			local text = words[counter] or ""
			table.insert(bookmark, utils.CreateBookmark(hitObject, text))
		end
		hitObject_minor = hitObject
	end
	----
	if Ready then
		delete_bookmarks()	
		if not DoDelete and #bookmark ~= 0 then
			----print, add bookmarks
			print("i!", #bookmark .. " bookmarks added")
			actions.Perform(utils.CreateEditorAction(action_type.AddBookmarkBatch, bookmark))
			----
		elseif #removebookmark + #bookmark ~= 0 then
			----print, remove and add bookmarks
			print("i!", #removebookmark .. " bookmarks removed")
			print("i!", #bookmark .. " bookmarks added")
			actions.PerformBatch
				({
				utils.CreateEditorAction(action_type.RemoveBookmarkBatch, removebookmark),
				utils.CreateEditorAction(action_type.AddBookmarkBatch, bookmark)
				})
		end
	end
end
--
function hallpass_section_2()
----reset
	for i = #bookmark, 1, -1 do
		bookmark[i] = nil
	end
	counter = 0 
----
	Ready = false
end
---- todelete_Bookmarks
function delete_bookmarks(START, END)
	if #map.Bookmarks == 0 then return false end
	----reset
		removebookmark = {}
	----
	betweenselectednotes_bookmarks(START, END)
	if not bookmark_Data then return false end
	for i = 1, #bookmark_Data do
		table.insert(removebookmark, #removebookmark+1, bookmark_Data[i])
	end 
	if Ready then DoDelete = true return end
	----print and remove bookmarks
		if #removebookmark ~= 0 then
			print("i!", #removebookmark .. " bookmarks removed")
			actions.Perform(utils.CreateEditorAction(action_type.RemoveBookmarkBatch, removebookmark))
		end
	----
end

--all visuals for plugin
function stylystartup()
	local stylyC = imgui.PushStyleColor
	local stylyV = imgui.PushStyleVar
	local color = imgui_col
	local variable = imgui_style_var
	--color stuff
	stylyC(color.Text, {1, 1, 1, 1})
	stylyC(color.Border, {.13, .07, .5, 1})
	stylyC(color.WindowBg, {0, 0, 0, .5})
	stylyC(color.FrameBg, {.09, .09, .09, 1})
	stylyC(color.FrameBgHovered, {0, .82, 1, .4})
	stylyC(color.FrameBgActive, {.26, .59, .98, .67})
	stylyC(color.TitleBg, {.13, .07, .5, 1})
	stylyC(color.TitleBgActive, {.14, 0.11, .36, 1})
	stylyC(color.TitleBgCollapsed, {0, 0, 0, .5})
	stylyC(color.ScrollbarBg, {.02, 0.02, 0.02, .5})
	stylyC(color.ScrollbarGrab, {.09, .09, .09, 1})
	stylyC(color.ScrollbarGrabHovered, {.13, .07, .5, 1})
	stylyC(color.ScrollbarGrabActive, {.34, .34, .34, 1})
	stylyC(color.Button, {.09, .09, .09, 1})
	stylyC(color.ButtonHovered, {.34, .34, .34, 1})
	stylyC(color.ButtonActive, {.14, .11, .36, 1})
	stylyC(color.ResizeGrip, {.13, .07, .5, 1})
	stylyC(color.ResizeGripHovered, {.09, .09, .09, 1})
	stylyC(color.ResizeGripActive, {.34, .34, .34, 1})
	--stylish stuff
	stylyV(variable.WindowPadding, {30, 30})
	stylyV(variable.WindowRounding, 6)
	stylyV(variable.WindowTitleAlign, {.5, .5})
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
