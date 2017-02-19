/*---------------------------------------------------------
	Restart Game
---------------------------------------------------------*/
--Command to restart the game completely, only admins can do it

function fStartGame( player, command, arguments )
	if not player:IsAdmin() then return end
	//if DEV_MODE != true then return end
	if GetGamePhase() != "NoPlayers" then return end
	
	StartCountdown()
end
concommand.Add( "bb_dev_startgame", fStartGame )







/*---------------------------------------------------------
	Restart Game
---------------------------------------------------------*/
--Command to restart the game completely, only admins can do it

function fRestart( player, command, arguments )
	if not player:IsAdmin() then return end
	
	GameRestart()
end
concommand.Add( "bb_restart", fRestart )




/*---------------------------------------------------------
	Recall
---------------------------------------------------------*/
--Command to restart the game completely, only admins can do it

function fRecall( ply, command, arguments )
	if ply:HasPuck() then
		ply.Puck:Abil_Recall()
	end
end
concommand.Add( "bb_recall", fRecall )






/*---------------------------------------------------------
	Join Team
---------------------------------------------------------*/
function JoinTeamAndSpawn(ply, teamnum, teamname)
	--only do something if the player is not already on the team he's switching to
	if ply:Team() != teamnum then
	
		if teamnum == TEAM_RED then
			ply:ChatPrint( "Joining:  Team Red" )
		elseif teamnum == TEAM_BLUE then
			ply:ChatPrint( "Joining:  Team Blue" )
		elseif teamnum == TEAM_SPEC then
			ply:ChatPrint( "Joining:  Spectators" )
		end
		
		--drop all the tokens
		if GetGamePhase() == "BegunGame" or GetGamePhase() == "SetupGame" then
			ply:DropAllTokensInSpawn()
		else
			ply:SetTokens( 0 )
		end
		
		
		ply:SetTeam(teamnum)

		--have to make sure this timer doesnt go off and cause the palyer to spawn
		Remove_RespawnTimers()
		
		--AddToNextRespawn is called in BreakPuck, so we want to avoid calling it twice if the player has a puck
		if ply:HasPuck() then
			ply.Puck:Delete( true )
		else
			ply:AddToNextRespawn()
			//print("adding to next respawn but does not have puck")
		end
	end
end



--Command to join a team during the Team Setup
function fJoinTeam( ply, command, arguments )

	ply:SetIfReady( false )

	local theteam = nil
	if arguments[1] == "TEAM_RED" then
		theteam = TEAM_RED
	elseif arguments[1] == "TEAM_BLUE" then
		theteam = TEAM_BLUE
	elseif arguments[1] == "TEAM_SPEC" then
		theteam = TEAM_SPEC
	end
	
	if theteam != TEAM_SPEC then
	
		--ply:SetTeam(theteam)
		JoinTeamAndSpawn(ply, theteam, arguments[1])

	elseif theteam == TEAM_SPEC then
		--ply:SetTeam(theteam)
		JoinTeamAndSpawn(ply, theteam, arguments[1])
	end
end
concommand.Add( "bb_jointeam", fJoinTeam )



--Command to join a team during the Team Setup
function fTeamMenuClose( ply, command, arguments )
	ply:TeamMenu_Close()
end
concommand.Add( "bb_teammenuclose", fTeamMenuClose )








--Command to join a team during the Team Setup
function fFakeBot( ply, command, arguments )
	local name = arguments[1]

	player.CreateNextBot( name )

end
concommand.Add( "bb_fakebot", fFakeBot )






/*---------------------------------------------------------
	Changing class - classes arent in the game anymore
---------------------------------------------------------*/

--[[
--Command to join a team during the Team Setup
function fSetClass( ply, command, arguments )
	local newclass = arguments[1]
	
	--if the player already is the class they selected, do nothing
	if ply:HasPuck() then
		if ply.Puck:GetClass() == newclass and ply:GetPuckClass() == newclass then
			ply:ChatPrint( "You already are:  " .. ConvertToPrintName_Puck(newclass) )
			return
		end
	end
	
	--set the players new class
	ply:SetPuckClass( newclass )
	
	--break the players current puck if they have one
	if ply:HasPuck() then
		if ply.Puck:IsInFountain() then
			ply.Puck:Delete()
			return
		elseif GetGamePhase() == "NoPlayers" or  GetGamePhase() == "PreGame" or GetGamePhase() == "SetupGame" then
			ply.Puck:Delete()
			return
		end
	end
	ply:ChatPrint( "You will respawn as:  " .. ConvertToPrintName_Puck(newclass) )
	
	
end
concommand.Add( "bb_setclass", fSetClass )



--Command to close out of the class menu
function fClassMenuClose( ply, command, arguments )
	ply:ClassMenu_Close()
end
concommand.Add( "bb_classmenuclose", fClassMenuClose )
]]--





/*---------------------------------------------------------
	Changing craftable
---------------------------------------------------------*/
function fSetCraftEnt( ply, command, arguments )
	local newcraft = arguments[1]
	
	--set the players new crafting ent
	//print(newcraft)
	ply:ChatPrint( "You will construct:    " .. ConvertToPrintName_Craft( newcraft ) )
	ply:SetCraft( newcraft )
end
concommand.Add( "bb_setcraftent", fSetCraftEnt )







/*---------------------------------------------------------
	Ready Up Toggle
---------------------------------------------------------*/
--Command to ready up during the Team Setup
--Takes 3 commands: "false", "true", nothing makes it do toggle

function fReady( player, command, arguments )
	local phase = GetGamePhase()
	if phase != "NoPlayers" and phase != "PreGame" then return end

	if arguments[1] == "false" then 
		player:SetIfReady(false)
		return
	end
		
	if arguments[1] == "true" then 
		player:SetIfReady(true)
		return
	end

	prev_ready = player:GetIfReady()
	if prev_ready == false then
		player:SetIfReady(true)
	elseif prev_ready == true then
		player:SetIfReady(false)
	end

end
concommand.Add( "bb_readytoggle", fReady )







/*---------------------------------------------------------
	Craft
---------------------------------------------------------*/
function fCraft( ply, command, arguments )
	local x = arguments[1]
	local y = arguments[2]
	local z = arguments[3]
	local location = Vector( x,y,z )
	
	local set_angles = arguments[4]
	
	local bug = ply.Puck	
	if IsValid(bug) then
		bug:Craft( location, set_angles )
	end
end
concommand.Add( "bb_craft", fCraft )





--[[

/*---------------------------------------------------------
	Vote
---------------------------------------------------------*/

function fVote( ply, command, arguments )
	if ply.Has_Voted == true then 
		ply:ChatPrint( "You have already voted." )
		return
	else
		ply.Has_Voted = true
	end

	
	
	local function VoteSuccessfulSound()
		umsg.Start("Buy_Successful", player)
		umsg.End()
	end
	
	--returns true if the player should be able to vote right now, depending on if hes spec
	local function CanVoteCheck( guy )
		if G_CurrentPhase == "GameSetup" then
			--everyone can vote in gamesetup
			return true
		else
			if guy:Team() == TEAM_SPEC then
				--spectators can vote if atleast one of the teams has only 1 player
				if team.NumPlayers( TEAM_RED ) <= 1 or team.NumPlayers( TEAM_BLUE ) <= 1 then
					return true
				end
				guy:ChatPrint( "Cant vote as a spectator during the game (except in cases of minimal players) " )
				return false
			else
				return true
			end
		end
	end
	
	
	local dothis = arguments[1]
	local arg = arguments[2]
	
	
	
	
	
	
	if dothis == "kick" then
		if CanVoteCheck( ply ) != true then return end
	
		local v = player.GetByUniqueID( arg )
		v:SetVotesInt( v:GetVotesInt() + 1 )

		VoteSuccessfulSound()

	elseif dothis == "restart" then	
		if CanVoteCheck( ply ) != true then return end
	
		local votesfalse = GetGlobalInt( "CL_BoolVotes_false" )
		local votestrue = GetGlobalInt( "CL_BoolVotes_true" )
		
		if arg == "false" then
			SetGlobalInt( "CL_BoolVotes_false", votesfalse + 1 )
		elseif arg == "true" then
			SetGlobalInt( "CL_BoolVotes_true", votestrue + 1 )
		end

		VoteSuccessfulSound()
		
	elseif dothis == "map" then	
		if CanVoteCheck( ply ) != true then return end
	
		ply:SetChangeMap( arg )
		VoteSuccessfulSound()
	end
end
concommand.Add( "ttg_vote", fVote )


]]--

