--[[---------------------------------------------------------
	Team joining window
---------------------------------------------------------]]--

function ShowTeamMenu()
	local ply = LocalPlayer()
	local panel_width = 500
	local panel_height = 400
 
	local DermaPanel = vgui.Create( "DFrame" )
	DermaPanel:SetPos( (ScrW()/2)-panel_width/2, 250 )
	DermaPanel:SetSize( panel_width, panel_height )
	DermaPanel:SetTitle( "Choose a class" ) -- Name of Fram
	DermaPanel:SetVisible( true )
	DermaPanel:SetDraggable( false ) --Can the player drag the frame /True/False
	DermaPanel:ShowCloseButton( false ) --Show the X (Close button) /True/False
	DermaPanel:SetDeleteOnClose(true)
	--DermaPanel:MakePopup()

	local setclass = nil
	
	local ClassColumn = vgui.Create("DListView")
	ClassColumn:SetParent(DermaPanel)
	ClassColumn:SetPos(25, 50)
	ClassColumn:SetSize(150, panel_height-150)
	ClassColumn:SetMultiSelect(false)
	ClassColumn:AddColumn("Class")
	ClassColumn.OnRowSelected = function( panel , line )
			local printname = panel:GetLine(line):GetValue(1)
			local puckname = ConvertToName_Puck( printname )
			
			setclass = puckname
		end

	--add all craftables to this collumn
	for _, puckclass in pairs( PUCK_TABLE ) do
		ClassColumn:AddLine( puckclass.print_name )  
	end
	
	--make alphabetical
	ClassColumn:SortByColumn( 1 )

	--[[
	if setclass == nil then
		local line = ClassColumn:GetLine( 4 )
		ClassColumn:SelectItem( line )
	end
	]]--
	
	local SetClassButton = vgui.Create( "DButton" )
	SetClassButton:SetParent( DermaPanel ) -- Set parent to our "DermaPanel"
	SetClassButton:SetText( "Set Class" )
	SetClassButton:SetPos( 25, 315 )
	SetClassButton:SetSize( 150, 50 )
	SetClassButton.DoClick = function ()
		if setclass != nil then
			RunConsoleCommand( "bb_setclass", setclass )
			RunConsoleCommand( "bb_classmenuclose" )
		end
	end 
	
	
	
	
	local min = false
	
	local function Update()
		if min == false then
			gui.EnableScreenClicker(true)
		end
		
		--[[
		--Update whatever the player is selecting
		local have_a_selection = false
		if CraftColumn:GetSelectedLine( ) != nil then 
			have_a_selection = true

			local linenumber = CraftColumn:GetSelectedLine( ); local toolline = CraftColumn:GetLine(linenumber)
			local printname = toolline:GetValue(1)
			local craftname = ConvertToName_Craft( printname )
			
			local craftref = TableReference_Craft( craftname )
		end
		]]--
	end
	hook.Add("Think", "UpdateClassMenu", Update)


	--closes the whole menu
	local function Close()
		
		//if craft_changed == true then
			//local linenumber = CraftColumn:GetSelectedLine( ); local toolline = CraftColumn:GetLine(linenumber)
			//local printname = toolline:GetValue(1)
			//local craftname = ConvertToName_Craft( printname )
			//local craftref = TableReference_Craft( craftname )
		
			//RunConsoleCommand( "bb_setcraftent", craftref.ent )
		//end
	
		DermaPanel:Close()
		gui.EnableScreenClicker(false)
		hook.Remove( "Think", "UpdateClassMenu" )
	end
	usermessage.Hook( "ClassPanel_Close", Close )

 

end
usermessage.Hook( "ClassPanel_Open", ShowTeamMenu )