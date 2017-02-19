local Ply = LocalPlayer()

--vars many of these functions share with each other
local CheckClientSay = false
local CurVoteCommand = nil
local Voting_ArgTable = {}


--Runs the console command sending a the players vote back to the server
local function VoteKey( num )
	--arg becomes whatever was put in the arg table with that key, a player, a map, a bool, etc..
	local arg = tostring( Voting_ArgTable[num] )
	RunConsoleCommand( "ttg_vote", CurVoteCommand, arg )
end


function Vote_ClientSay( ply, str, teamonly, isdead )
	if CheckClientSay != true then return end
	if ply != LocalPlayer() then return end
	
	--check if the number is valid, then do the votekey
	local tonum = tonumber(str)
	local choice = Voting_ArgTable[ tonum ]
	if choice != nil then
		VoteKey( tonum )
		CheckClientSay = false
	end
	
end
hook.Add("OnPlayerChat","Vote_ClientSay",Vote_ClientSay)


local function Vote_SetCurVoteCommand( cmd )
	CurVoteCommand = cmd
end






local function Vote_Panel( option, cmd )
	CheckClientSay = true
	Vote_SetCurVoteCommand( cmd )

	local Panel = vgui.Create( "DFrame" )
	Panel:SetPos( ScrW()-225, ScrH()-340 )
	Panel:SetSize( 200, 225 )
	//Panel:SetAlpha( 200 )
	Panel:SetTitle( "Enter number in chat to vote" ) 
	Panel:SetVisible( true )
	Panel:SetDraggable( false )
	Panel:ShowCloseButton( false )
	Panel:SetDeleteOnClose(true)

	
	local ChoiceList = vgui.Create( "DPanelList", Panel )
	ChoiceList:SetPos( 25,25 )
	ChoiceList:SetSize( 200, 500 )
	ChoiceList:SetSpacing( 5 )
	ChoiceList:EnableHorizontal( false )
	ChoiceList:EnableVerticalScrollbar( true )
	
	--play a sound alerting players of the vote
	surface.PlaySound( "buttons/button17.wav" )
	
	Voting_ArgTable = {}
	
	local function Update()
		ChoiceList:Clear()
	
		--timer
		local timeleft = GetGlobalInt( "CL_VoteTimerInt" )
		local InsertTitle = vgui.Create( "DLabel" )
		InsertTitle:SetText( "Vote" .. cmd .. "? - " .. timeleft )
		InsertTitle:SetColor( Color(255,255,255,255) )
		InsertTitle:SetFont( "Trebuchet24" )
		InsertTitle:SizeToContents()
		ChoiceList:AddItem( InsertTitle )
		
	
		local num = 1
		if option == "players" then
			for _, v in pairs(player.GetAll()) do
				Voting_ArgTable[num] = v:UniqueID()
				local votes = v:GetVotesInt()
				
				local Insert = vgui.Create( "DLabel" )
				Insert:SetText( num ..".  " .. v:Name() .. ":   " .. votes)
				Insert:SetColor( Color(255,255,255,255) )
				Insert:SetFont("TargetID")
				Insert:SizeToContents()
				ChoiceList:AddItem( Insert )
				
				num = num + 1
			end
			
		elseif option == "bool" then
			local var = true
			for i=1,2 do
				Voting_ArgTable[num] = var
				label = "No"
				if var == true then
					label = "Yes"
				end
				
				local votes = GetGlobalInt( "CL_BoolVotes_" .. tostring(var) )
				
				local Insert = vgui.Create( "DLabel" )
				Insert:SetText( num ..".  " .. label .. ":  " .. votes )
				Insert:SetColor( Color(255,255,255,255) )
				Insert:SetFont("TargetID")
				Insert:SizeToContents()
				ChoiceList:AddItem( Insert )
			
				var = false
				num = num + 1
			end
			
		elseif option == "maps" then
			for k, map in pairs( SERVER_MAPS ) do
				Voting_ArgTable[num] = map
				
				local votes = 0
				for _, v in pairs(player.GetAll()) do
					if v:GetChangeMap() == map then
						votes = votes + 1
					end
				end
				
				local Insert = vgui.Create( "DLabel" )
				Insert:SetText( num ..".  " .. map .. ":  " .. votes )
				Insert:SetColor( Color(255,255,255,255) )
				Insert:SetFont("TargetID")
				Insert:SizeToContents()
				ChoiceList:AddItem( Insert )
				
				num = num + 1
			end
			
			
		end
	end
	Update()
	
	
	local StopTimer = false
	local function DoTimer()
		timer.Simple( .2, function()
			if StopTimer then return end
			Update()
			DoTimer()
		end)
	end
	DoTimer()
	

	
	local function Close()
		//print("trying to close vote panel")
		Panel:Close()
		StopTimer = true
		CheckClientSay = false
	end
	usermessage.Hook( "Vote_End", Close )
end





local function VoteInitialize_Kick()
	Vote_Panel( "players", "kick" )
end
usermessage.Hook( "VoteInitialize_Kick", VoteInitialize_Kick )


local function VoteInitialize_Restart()
	Vote_Panel( "bool", "restart" )
end
usermessage.Hook( "VoteInitialize_Restart", VoteInitialize_Restart )


local function VoteInitialize_ChangeMap()
	Vote_Panel( "maps", "map" )
end
usermessage.Hook( "VoteInitialize_ChangeMap", VoteInitialize_ChangeMap )


