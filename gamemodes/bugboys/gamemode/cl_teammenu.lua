--[[---------------------------------------------------------
	Team joining window
---------------------------------------------------------]]--

function ShowTeamMenu()
	local ply = LocalPlayer()
	local panel_width = 600
	local panel_height = 350
 
	local DermaPanel = vgui.Create( "DFrame" )
	DermaPanel:SetPos( (ScrW()/2)-panel_width/2, 350 )
	DermaPanel:SetSize( panel_width, panel_height )
	DermaPanel:SetTitle( "Choose a team" ) -- Name of Fram
	DermaPanel:SetVisible( true )
	DermaPanel:SetDraggable( false ) --Can the player drag the frame /True/False
	DermaPanel:ShowCloseButton( false ) --Show the X (Close button) /True/False
	DermaPanel:SetDeleteOnClose(true)
	--DermaPanel:MakePopup()




	local RedColumn = vgui.Create("DListView")
	RedColumn:SetParent(DermaPanel)
	RedColumn:SetPos(25, 125)
	RedColumn:SetSize((panel_width/3)-25, panel_height-180)
	RedColumn:SetMultiSelect(false)
	RedColumn:AddColumn("Red Team") -- Add column
	
	local BlueColumn = vgui.Create("DListView")
	BlueColumn:SetParent(DermaPanel)
	BlueColumn:SetPos(panel_width-200, 125)
	BlueColumn:SetSize((panel_width/3)-25, panel_height-180)
	BlueColumn:SetMultiSelect(false)
	BlueColumn:AddColumn("Blue Team") -- Add column
	
	
	local phase = GetGamePhase()
	if phase == "NoPlayers" or phase == "PreGame" or phase == "EndGame" then
		if GetGlobalBool("Pub_Mode", false) != true then 
		RedColumn:AddColumn("Ready?")
		BlueColumn:AddColumn("Ready?")
		end
	end
	
	local SpecColumn = vgui.Create("DListView")
	SpecColumn:SetParent(DermaPanel)
	SpecColumn:SetPos((panel_width/3) + 25, 125)
	SpecColumn:SetSize((panel_width/3)-50, panel_height-180)
	SpecColumn:SetMultiSelect(false)
	SpecColumn:AddColumn("Spectators")
	--SpecColumn:AddColumn("Ready?")
	
	
	local SpecButton = vgui.Create( "DButton" )
	SpecButton:SetParent( DermaPanel ) -- Set parent to our "DermaPanel"
	SpecButton:SetText( "Join Spectators" )
	SpecButton:SetPos( (panel_width/3) + 25, 50 )
	SpecButton:SetSize( 150, 50 )
	SpecButton.DoClick = function ()
		RunConsoleCommand( "bb_jointeam", "TEAM_SPEC" )
		RunConsoleCommand( "bb_teammenuclose" )
	end 

	
	local DermaButton = vgui.Create( "DButton" )
	DermaButton:SetParent( DermaPanel ) -- Set parent to our "DermaPanel"
	DermaButton:SetText( "Join Red Team" )
	DermaButton:SetPos( 25, 50 )
	DermaButton:SetSize( 150, 50 )
	DermaButton.DoClick = function ()
		RunConsoleCommand( "bb_jointeam", "TEAM_RED" ) -- What happens when you press the button
		local phase = GetGamePhase()
		if phase != "NoPlayers" and phase != "PreGame" then
			RunConsoleCommand( "bb_teammenuclose" )
		end

	end 
 
	local DermaButton2 = vgui.Create( "DButton" )
	DermaButton2:SetParent( DermaPanel ) -- Set parent to our "DermaPanel"
	DermaButton2:SetText( "Join Blue Team" )
	DermaButton2:SetPos( (panel_width - 175), 50 )
	DermaButton2:SetSize( 150, 50 )
	DermaButton2.DoClick = function ()
		RunConsoleCommand( "bb_jointeam", "TEAM_BLUE" )
		local phase = GetGamePhase()
		if phase != "NoPlayers" and phase != "PreGame" then
			RunConsoleCommand( "bb_teammenuclose" )
		end
	end 
	
	
	local PlayerCountRed = vgui.Create("DLabel", DermaPanel)
	PlayerCountRed :SetPos(100, 100) -- Position
	PlayerCountRed :SetColor(Color(255,150,150,255)) -- Color
	PlayerCountRed :SetFont("Trebuchet24")
	PlayerCountRed :SizeToContents() -- make the control the same size as the text.
	
	local PlayerCountBlue = vgui.Create("DLabel", DermaPanel)
	PlayerCountBlue:SetPos(panel_width-125, 100) -- Position
	PlayerCountBlue:SetColor(Color(150,150,255,255)) -- Color
	PlayerCountBlue:SetFont("Trebuchet24")
	PlayerCountBlue:SizeToContents() -- make the control the same size as the text.
	

	
	local StartingRound = vgui.Create("DLabel", DermaPanel)
	StartingRound:SetPos(150, (panel_height - 35)) -- Position
	StartingRound:SetColor(Color(0,255,0,0)) -- Color
	StartingRound:SetFont("DermaLarge")
	StartingRound:SetText("Starting game in " .. BEGINNING_COUNTDOWN .. " seconds...")
	StartingRound:SizeToContents() -- make the control the same size as the text.
	
	
	
	local ReadyButton = vgui.Create( "DButton" )
	ReadyButton:SetParent( DermaPanel ) -- Set parent to our "DermaPanel"
	ReadyButton:SetText( "Ready Up" )
	ReadyButton:SetPos( 25, panel_height - 40 )
	ReadyButton:SetSize( 100, 25 )
	ReadyButton:SetVisible(false)
	ReadyButton.DoClick = function ()
		RunConsoleCommand( "bb_readytoggle" )
		//RunConsoleCommand( "bb_readytoggle", "TEAM_SPEC" )
	end 
	
	
	
	local CloseButton = vgui.Create( "DButton" )
	CloseButton:SetParent( DermaPanel ) -- Set parent to our "DermaPanel"
	CloseButton:SetText( "Close" )
	CloseButton:SetPos( panel_width - 100, panel_height - 40 )
	CloseButton:SetSize( 75, 25 )
	CloseButton:SetVisible(true)
	CloseButton.DoClick = function ()
		RunConsoleCommand( "bb_teammenuclose" )
	end 
	
	
	
	local min = false
	
	local function Update()
		if min == false then
			gui.EnableScreenClicker(true)
		end
		PlayerCountBlue:SetText( team.NumPlayers(TEAM_BLUE) )
		PlayerCountRed:SetText( team.NumPlayers(TEAM_RED) ) 
		PlayerCountBlue:SizeToContents() -- make the control the same size as the text.
		PlayerCountRed:SizeToContents() -- make the control the same size as the text.
	
	
		RedColumn:Clear(true)
		BlueColumn:Clear(true)
		SpecColumn:Clear(true)
		for k,v in pairs(player.GetAll()) do
			local ready = v:GetIfReady()
			local display = "No"
			if ready == true then
				display = "Yes"
			end
		
			if v:Team() == TEAM_RED then
				RedColumn:AddLine(v:Nick(), display)
			elseif v:Team() == TEAM_BLUE then
				BlueColumn:AddLine(v:Nick(), display)
			elseif v:Team() == TEAM_SPEC then
				SpecColumn:AddLine(v:Nick())
			end
		end
		
		local phase = GetGamePhase()
		if phase != "NoPlayers" and phase != "PreGame" then
			ReadyButton:SetVisible(false)
		else
			ReadyButton:SetVisible(true)
		end
		
		
		if (GetGlobalBool("Pub_Mode", false) == true) then
			ReadyButton:SetVisible(false)
		end
		
	end
	hook.Add("Think", "UpdateTeamMenu", Update)


	local function Logo()
		draw.TexturedQuad
		{
		texture = surface.GetTextureID "bugboys/bugboys_logo",
		color = Color(255, 255, 255, 255),
		x = ScrW()/2 - 300,
		y = 75,
		w = 600,
		h = 300,
		}
	end
	hook.Add( "HUDPaint", "Logo", Logo )
	
	
	--closes the whole menu
	local function Close()
		DermaPanel:Close()
		gui.EnableScreenClicker(false)
		hook.Remove( "Think", "UpdateTeamMenu" )
		hook.Remove( "HUDPaint", "Logo" )
	end
	usermessage.Hook( "TeamsPanel_Close", Close )

 

end
usermessage.Hook( "TeamsPanel_Open", ShowTeamMenu )