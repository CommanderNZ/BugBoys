/*---------------------------------------------------------
	commands players can type in chat to initiate votes
---------------------------------------------------------*/






/*---------------------------------------------------------
	Vote Kick
---------------------------------------------------------*/

G_VoteInProgress = false
local VoteDirective = nil
local VoteSuccess = false
local VoteCancelled = false
local VotesMin = 0







--checks if a vote has succeeded, then deploys the results
local function VoteSuccessCheck()
	local finish = false
	
	if VoteDirective == "kick" then
		for _, v in pairs(player.GetAll()) do
			if v:GetVotesInt() > VotesMin then
				finish = true
				ChatPrintToAll( "Kicking:  " .. v:Name() )
				timer.Simple( 3, function()
					v:Kick("Server Vote")
				end)
			end
		end
		
		
	elseif VoteDirective == "restart" then
		local truevotes = GetGlobalInt( "CL_BoolVotes_true" )
		local falsevotes = GetGlobalInt( "CL_BoolVotes_false" )
		
		if truevotes > VotesMin then
			finish = true
			ChatPrintToAll( "Restarting game..." )
			timer.Simple( 3, function()
				GameRestart()
			end)
		elseif falsevotes > VotesMin then
			finish = true
			ChatPrintToAll( "Voting conclusion: No..." )
		end
		
		
		
		
	elseif VoteDirective == "map" then
		local maps_with_votes = {}
		for _, v in pairs( SERVER_MAPS ) do
			local addtbl = { name = v, votes = 0 }
			table.insert( maps_with_votes, addtbl )
		end
		
		for _, v in pairs(player.GetAll()) do
			for _, map in pairs( maps_with_votes ) do
				//print(map.name, changemap)
				//print(v:Name(), " changemap:", v:GetChangeMap())
				if map.name == v:GetChangeMap() then
					//print(map.name, "adding a vote from", v, "old amount:", map.votes)
					map.votes = map.votes + 1
				end
			end
		end
		
		for _, map in pairs( maps_with_votes ) do
			if map.votes > VotesMin then
				//print( map.name, map.votes ..">".. VotesMin)
				finish = true
				ChatPrintToAll( "Switching map to:  " .. map.name )
				timer.Simple( 3, function()
					RunConsoleCommand( "changelevel", map.name )
				end)
			end
		end
	end
	
	
	--if all players voted, then end the vote
	local allplysvoted = true
	for _, v in pairs(player.GetAll()) do
		if not v.Has_Voted == true then
			allplysvoted = false
		end
	end
	if allplysvoted then
		finish = true
		ChatPrintToAll( "Vote Finished" )
	end
	
	
	
	if finish == true then
		EndVote()
		
		--play a sound to everyone to signify the end of voting
		umsg.Start("Sound_VotingEnd")
		umsg.End()
	end
end


--ends all vote functions
function EndVote()
	

	G_VoteInProgress = false
	VoteDirective = nil
	VoteSuccess = false
	VoteCancelled = true
	VotesMin = 0
	
	
	umsg.Start( "Vote_End" )
	umsg.End()
	
	hook.Remove("Tick", "VoteSuccessCheck")
end



--starts a serverwide vote for something, makes voting menus come up for all players
function StartVote( str, ply )
	--clear all players voting booleans that say if theyve voted or not
	for _, v in pairs(player.GetAll()) do
		v.Has_Voted = false
		//v:SetChangeMap( 0 )	--reset the map they may have voted for in an earlier vote
	end
	
	
	if str == "kick" then
		umsg.Start("VoteInitialize_Kick")
		umsg.End()	
		ChatPrintToAll( ply:Name() .. " initiated a votekick..." )
	elseif str == "restart" then
		umsg.Start("VoteInitialize_Restart")
		umsg.End()
		ChatPrintToAll( ply:Name() .. " initiated a voterestart..." )
	elseif str == "map" then
		umsg.Start("VoteInitialize_ChangeMap")
		umsg.End()
		ChatPrintToAll( ply:Name() .. " initiated a vote to change maps..." )
	end
	
	
	SetGlobalInt( "CL_BoolVotes_true", 0 )
	SetGlobalInt( "CL_BoolVotes_false", 0 )
	
	
	--generate the minimum amount of votes to pass the current directive
	VotesMin = (table.Count( player.GetAll() ) * .6)
	
	VoteDirective = str
	G_VoteInProgress = true
	VoteSuccess = false
	VoteCancelled = false
	hook.Add("Tick", "VoteSuccessCheck", VoteSuccessCheck)
	
	
	--create a timer ent so the panel will display the countdown of time left
	CreateTimerEnt( VOTING_TIME, "CL_VoteTimerInt" )
	
	timer.Simple( VOTING_TIME, function()
		if VoteSuccess == true then return end
		if VoteCancelled == true then return end
		ChatPrintToAll( "Vote failed..." )
		EndVote()
	end)
end




local function GetIfCanVote()
	if G_VoteInProgress == true then
		return false
	else
		return true
	end
end



function Vote_ServerSay( ply, text, public )
	local function TryToStart( str )
		if GetIfCanVote() == true then
			--dont allow changing maps during the game
			--[[
			if str == "map" and G_CurrentPhase != "GameSetup" then
				ply:ChatPrint( "Cant change map during an active game..." )
				return
			end
			
			--dont allow vote kicking during game
			if str == "kick" and G_CurrentPhase != "GameSetup" then
				ply:ChatPrint( "Cant votekick during an active game..." )
				return
			end
			]]--
			
			StartVote( str, ply )
		else
			ply:ChatPrint( "A vote is already ongoing..." )
		end
	end
	
	
    if (string.sub(text, 1, 9) == "!votekick") then
		TryToStart( "kick", ply ) 
	//elseif (string.sub(text, 1, 12) == "!voterestart") then
		//TryToStart( "restart", ply )
	//elseif (string.sub(text, 1, 14) == "!votemap") then
		//if VOTE_CHANGEMAP_ENABLED == true then
			//TryToStart( "map", ply )
		//end
    end
end
hook.Add( "PlayerSay", "Vote_ServerSay", Vote_ServerSay )