--[[---------------------------------------------------------
	Quick menu that opens when you hold Q
---------------------------------------------------------]]--

function ShowQuickMenu()
	local Ply = LocalPlayer()
	local panel_width = 500 --250
	local panel_height = 600
 
	local DermaPanel = vgui.Create( "DFrame" )
	DermaPanel:SetPos( (ScrW()/2)-panel_width/2, (ScrH()/2)-panel_height/2 )
	DermaPanel:SetSize( panel_width, panel_height )
	DermaPanel:SetTitle( "Quick Menu" ) -- Name of Fram
	DermaPanel:SetVisible( false )
	DermaPanel:SetDraggable( false ) --Can the player drag the frame /True/False
	DermaPanel:ShowCloseButton( false ) --Show the X (Close button) /True/False
	DermaPanel:SetDeleteOnClose(false)
	--DermaPanel:MakePopup()

	
	
	local CraftColumn = vgui.Create("DListView")
	CraftColumn:SetParent(DermaPanel)
	CraftColumn:SetPos(20, 40)
	CraftColumn:SetSize(panel_width-40, panel_height-200)
	CraftColumn:SetMultiSelect(false)
	CraftColumn:AddColumn("Structure")
	CraftColumn:AddColumn("Cost")
	CraftColumn.OnRowSelected = function( panel , line )
			local printname = panel:GetLine(line):GetValue(1)
			local craftname = ConvertToName_Craft( printname )
			local craftref = TableReference_Craft( craftname )
			
			if LocalPlayer():Team() != TEAM_SPEC then 
				RunConsoleCommand( "bb_setcraftent", craftref.name )
				//surface.PlaySound( "buttons/blip1.wav" )
			end
				
		end

		
	//the text that displays what tool is selected in the list
	local SelectedToolText = vgui.Create("DLabel", DermaPanel)
	SelectedToolText:SetPos(25, 450) // Position
	SelectedToolText:SetColor(Color(255,255,255,255)) // Color
	SelectedToolText:SetFont("CloseCaption_Bold")
	SelectedToolText:SetText("-") // Text
	
	//the text that displays what tool is selected in the list
	local DescriptionText = vgui.Create("DLabel", DermaPanel)
	DescriptionText:SetPos(25, 480) // Position
	DescriptionText:SetColor(Color(200,200,200,255)) // Color
	DescriptionText:SetFont("TargetID")
	DescriptionText:SetText("-") // Text
	
	
	
	--add all craftables to this collumn
	for _, craftable in pairs( CRAFT_TABLE ) do
		if craftable.not_in_shop != true then
			CraftColumn:AddLine( craftable.print_name, craftable.crystals_required )  
		end
	end
	--make alphabetical
	CraftColumn:SortByColumn( 1 )
	
	--sort by cost with highest costing stuff at bottom
	//CraftColumn:SortByColumn( 2 )
	
	--select what the player already has set as his craftable structure, if he has selected one before
	--[[
	local craftent = ply:GetCraft()
	if craftent != "none" then
		local craftent_ref = TableReference_Craft( craftent )
		local craftent_num = craftent_ref.num
		local line = CraftColumn:GetLine( craftent_num )
		CraftColumn:SelectItem( line )
	end
	]]--
	
	
	local PanelRecall = vgui.Create( "DFrame" )
	PanelRecall:SetPos( (ScrW()/2)+270, (ScrH()/2)-110/2 )
	PanelRecall:SetSize( 190, 110 )
	PanelRecall:SetTitle( "Recall - (teleport back home)" ) -- Name of Fram
	PanelRecall:SetVisible( false )
	PanelRecall:SetDraggable( false ) --Can the player drag the frame /True/False
	PanelRecall:ShowCloseButton( false ) --Show the X (Close button) /True/False
	PanelRecall:SetDeleteOnClose(false)
	
	local DermaButton = vgui.Create( "DButton" )
	DermaButton:SetParent( PanelRecall ) -- Set parent to our "DermaPanel"
	DermaButton:SetText( "Recall" )
	DermaButton:SetPos( 20, 40 )
	DermaButton:SetSize( 150, 50 )
	DermaButton.DoClick = function ()
		RunConsoleCommand( "bb_recall" )
	end 
	
	
	
	local function SetVisibility(bool)
		DermaPanel:SetVisible( bool )

		if LocalPlayer().Team == nil then return end
		
		if LocalPlayer():Team() == TEAM_SPEC then 
			PanelRecall:SetVisible( false )
		else
			PanelRecall:SetVisible( bool )
		end
	end
	
	
	local turned_on = false
	
	local function BuyMenuPress()
		local iskeydown = input.IsKeyDown(KEY_Q)
		
		
		
		-- change display of structure descriptions
		local have_a_selection = false
		local craftref = nil
		if CraftColumn:GetSelectedLine( ) != nil then 
			have_a_selection = true
			local linenumber = CraftColumn:GetSelectedLine( ); local toolline = CraftColumn:GetLine(linenumber)
			local printname = toolline:GetValue(1)
			
			local craftname = ConvertToName_Craft( printname )
			craftref = TableReference_Craft( craftname )
		end
		
		if have_a_selection then
			SelectedToolText:SetText( craftref.print_name )
			SelectedToolText:SizeToContents()
			DescriptionText:SetText( craftref.description )
			DescriptionText:SizeToContents()
		else

			SelectedToolText:SetText("-")
			SelectedToolText:SizeToContents()
			DescriptionText:SetText( "-" )
			DescriptionText:SizeToContents()
		end	
		
		
		
		
		if iskeydown then 
			//if Ply:GetIfTeamJoinMenuOpen() != true then
				gui.EnableScreenClicker( true )
				SetVisibility(true)
				turned_on = true
			//end
		else
			if turned_on == true then
				gui.EnableScreenClicker( false )
				turned_on = false
			end
			SetVisibility(false)
		end
	end
	hook.Add("Think","BuyMenuPress",BuyMenuPress)
	
	
	
	--closes the whole menu, for when the game restarts
	local function Close()
		SetVisibility(false)
	end
	usermessage.Hook( "QuickMenu_Clode", Close )

end
ShowQuickMenu()