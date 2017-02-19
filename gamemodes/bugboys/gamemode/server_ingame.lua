--Phases:
	--"NoPlayers"
	--"PreGame"
	--"SetupGame"
	--"BegunGame"
	--"EndGame"

--Starts the actual gameplay game of bug boys, meaning the round starts

function StartCountdown()
	SetGamePhase("PreGame")

	print("counting down to game start")
	InitializeGameTimer(BEGINNING_COUNTDOWN, StartSetupPhase)
end



function StartCountdown_PubMode()
	SetGamePhase("PreGame")

	print("counting down to game start")
	InitializeGameTimer( PUBMODE_COUNTDOWN, StartSetupPhase )
end


--this would give a token to all players every X seconds, called by the gametimer in server_gametimer
--[[
function GiveTokensInterval()
	for k,ply in pairs(player.GetAll()) do		
		if ply:Team() != TEAM_SPEC then
			ply:AddTokens( TOKENS_PER_INTERVAL )
		end
	end
end
]]--


function SubtractPointsInterval()
	local redzone = nil
	local bluezone = nil
	for k,ent in pairs(ents.GetAll()) do
		if ent:GetClass() == "func_bb_capturezone_red" then
			redzone = ent
		end
		if ent:GetClass() == "func_bb_capturezone_blue" then
			bluezone = ent
		end
	end

	if GetPoints( TEAM_RED ) > POINT_SUBTRACTION_THRESHOLD and bluezone.Capturing == false then
		SubtractPoints( TEAM_RED, 1 )
	end
	
	if GetPoints( TEAM_BLUE ) > POINT_SUBTRACTION_THRESHOLD and redzone.Capturing == false then
		SubtractPoints( TEAM_BLUE, 1 )
	end
end






--these no longer function
function CheckMaxPoints( )
	if GetPoints( TEAM_RED ) >= POINT_WINNING_AMOUNT then
		ChooseWinner( TEAM_RED )
	elseif GetPoints( TEAM_BLUE ) >= POINT_WINNING_AMOUNT then
		ChooseWinner( TEAM_BLUE )
	end
end

function Start_CheckMaxPoints()
	hook.Add("Think", "CheckMaxPoints", CheckMaxPoints)
end

function End_CheckMaxPoints()
	hook.Remove( "Think", "CheckMaxPoints" )
end







--these no longer function
function CheckIfTeamsHaveLives( )
	if GetHowManyLives( TEAM_RED ) <= 0 then
		ChooseWinner( TEAM_BLUE )
	elseif GetHowManyLives( TEAM_BLUE ) <= 0 then
		ChooseWinner( TEAM_RED )
	end
end

//makes it constantly make sure atleast one person on each team is alive, otherwise end the round
function Start_TeamsLivesCheck()
	hook.Add("Think", "CheckIfTeamsHaveLives", CheckIfTeamsHaveLives)
end

//makes it stop checking if theres atleast one person on each team is alive
function End_TeamsLivesCheck()
	hook.Remove( "Think", "CheckIfTeamsHaveLives" )
end








--spawns crystals every 30 seconds at set marked positions and ents in the map, triggered by the gametimer
--soawbs at the 30 second marks 14:00, 13:30, 13:00, and on...
function SpawnTokens_Interval()
	--spawn one token at all of these hammer spawn point locations
	for k,ent in pairs(ents.GetAll()) do
		if ent:GetClass() == "ent_token_spawn" then
			ent:SpawnToken()
		end
	end
end





--[[

--spawns crystals every 60 seconds at set marked positions and ents in the map, triggered by the gametimer
--soawbs at the minute marks 14:00, 13:00, 12:00, etc...
function SpawnCrystals_Interval()
	--spawn one crystal at all of these hammer spawn point locations
	for k,ent in pairs(ents.GetAll()) do
		if ent:GetClass() == "ent_crystal_spawn" then
			--make sure theres not something in the way of this spawn position
			local canspawn = true
			local orgin_ents = ents.FindInSphere( ent:GetPos(), CRYSTAL_SPAWN_CANCEL_RADIUS )
			for k, nearent in pairs( orgin_ents ) do
				if nearent != ent then
					canspawn = false
				end
			end
			
			--create the crystal at the position
			if canspawn == true then
				ent:EmitSound( CRYSTAL_SPAWN_SOUND )
			
				local crystal = ents.Create("ent_crystal")
				crystal:SetPos( ent:GetPos() + Vector(0,0,CRYSTAL_SPAWN_HEIGHT) )
				crystal:Spawn()
			end
		end
	end
end

--spawns in a bunch of  crystals at each base right when the game starts so teams can build up a bit of a base
function SpawnCrystals_Initial()
	--spawn one crystal at all of these hammer spawn point locations
	for k,ent in pairs(ents.GetAll()) do
		if ent:GetClass() == "ent_crystal_spawnonce" then
			local crystal = ents.Create("ent_crystal")
			crystal:SetPos( ent:GetPos() + Vector(0,0,CRYSTAL_SPAWN_HEIGHT) )
			crystal:Spawn()
		end
	end
end
]]--


function EnableGiantWall()
	for k,ent in pairs(ents.GetAll()) do
		if ent:GetClass() == "func_brush" and ent:GetName() == "BB_DividingWall" then
			ent:Fire( "Enable", 0, 0 )
		end
	end
end

function DisableGiantWall()
	for k,ent in pairs(ents.GetAll()) do
		if ent:GetClass() == "func_brush" and ent:GetName() == "BB_DividingWall" then
			ent:Fire( "Disable", 0, 0 )
		end
	end
end





--should probably redo this to get an average between the 2 teams player counts
function SetTeamLives()
	local bluecount = 0
	local redcount = 0
	for k,ply in pairs(player.GetAll()) do	
		if ply:Team() == TEAM_RED then
			redcount = redcount + 1
		elseif ply:Team() == TEAM_BLUE then
			bluecount = bluecount + 1
		end
	end
	
	--set the lives pool to be equal to the team with the most players player count
	local decidedcount = 1
	if bluecount > redcount then
		decidedcount = bluecount
	else
		decidedcount = redcount
	end
	
	//print("SETTING LIVES TO " .. (decidedcount * STARTING_LIVES_PER_PLAYER) )
	SetLives( TEAM_BLUE, (decidedcount * STARTING_LIVES_PER_PLAYER) )
	SetLives( TEAM_RED, (decidedcount * STARTING_LIVES_PER_PLAYER) )
end





function StartSetupPhase()
	SetGamePhase("SetupGame")

	print("Starting game!")
	SetTeamStartingTokens()

	
	Start_CheckTeamsHavePlayers()
	
	
	--respawn all players who arent spectators
	for k,ply in pairs(player.GetAll()) do		
		if ply:Team() != TEAM_SPEC then
			ply:StripWeapons()
			ply:Spawn()
			ply:SetTokens( GetTeamStartingTokens( ply:Team() ) )
			ply:TeamMenu_Close()
			
			--unready them, they dont need to be ready anymore
			ply:SetIfReady( false )
		end
	end

	--resets all game ents and vars
	Reset_Vars()
	Reset_Ents()
	
	--turn on the giant wall
	EnableGiantWall()

	InitializeGameTimer(SETUP_TIME, BeginCombat)
end



function BeginCombat()
	SetGamePhase("BegunGame")
	
	//SetTeamLives()
	//Start_TeamsLivesCheck()
	//Start_CheckMaxPoints()
	
	--turn off the giant wall
	DisableGiantWall()
	
	InitializeGameTimer(GAME_DURATION, ChooseWinner)
end


function GetBrainHp( teamnum )
	for k,ent in pairs(ents.GetAll()) do
		--spawn in new bug brain objectives
		if ent:GetClass() == "structure_bugbrain" and ent.BBTeam == teamnum then
			return ent:Health()
		end
	end
end




function ChooseWinner( winner )
	SetGamePhase("EndGame")
	
	//End_TeamsLivesCheck()
	//End_CheckMaxPoints()
	
	Remove_RespawnTimers()
	
	local result = nil

	if winner == nil then
		--set the winner based on whos brain has more HP
		if GetBrainHp( TEAM_BLUE ) >  GetBrainHp( TEAM_RED ) then
			result = "blue"
		elseif GetBrainHp( TEAM_BLUE ) < GetBrainHp( TEAM_RED ) then
			result = "red"
		elseif GetBrainHp( TEAM_BLUE ) == GetBrainHp( TEAM_RED ) then
			result = "draw"
		end

		
		--if it was a draw in terms of points, check how many deaths each team had, make the one with the least the winner
		--[[
		if result == "draw" then
			local reddeaths = GetHowManyDeaths( TEAM_RED )
			local bluedeaths = GetHowManyDeaths( TEAM_BLUE )
			
			if reddeaths > bluedeaths then
				result = "blue"
			elseif reddeaths < bluedeaths then
				result = "red"
			elseif reddeaths == bluedeaths then
				result = "draw"
			end
		end
		]]--
		
		--if both or one of the teams has no players then override the score results
		if team.NumPlayers( TEAM_RED ) < 1 and team.NumPlayers( TEAM_BLUE) < 1 then
			result = "draw"
		elseif team.NumPlayers( TEAM_RED ) < 1 then
			result = "blue"
		elseif team.NumPlayers( TEAM_BLUE ) < 1 then
			result = "red"
		end
	else
		if winner == TEAM_RED then
			result = "red"
		elseif winner == TEAM_BLUE then
			result = "blue"
		end
	end


	--print the result to all players on their screens
		if result == "red" then
			SetWinningTeam( TEAM_RED )
			ExplodeBrain( TEAM_BLUE )
			
			
		elseif result == "blue" then
			SetWinningTeam( TEAM_BLUE )
			ExplodeBrain( TEAM_RED )
			
			
		elseif result == "draw" then
			SetWinningTeam( 3 )
		end

		
		
	--allow one team to massacre the other by disabling the losers from shooting
	--[[
	if winner == nil then
		if result == "red" then
			winner = TEAM_RED
		elseif result == "blue" then
			winner = TEAM_BLUE
		end
	end
	
	if winner != nil then
		for k,ply in pairs(player.GetAll()) do		
			if ply:Team() != TEAM_SPEC then	
			end
		end	
	end
	]]--
	
	for k,v in pairs(player.GetAll()) do		
		v:SetIfReady( false )
	end
	
	InitializeGameTimer(20, GameRestart)
end


function ExplodeBrain( teamnum )
	for k,ent in pairs(ents.GetAll()) do
		--spawn in new bug brain objectives
		if ent:GetClass() == "structure_bugbrain" and ent.BBTeam == teamnum then
			ent:Break()
		end
	end
end

--------------------------------------------------------------------------------------------------------------------------------------
--Code checks if theres still active players in the game, ends the game if not
--------------------------------------------------------------------------------------------------------------------------------------

--returns true if on
function TeamsDontHavePlayers()
	--If theres not atleast 1 player in the server then return false, if no one is there no one is playing
	if table.Count(player.GetAll()) < 1 then 
		return true 
	end
	
	
	--allows game to continue with 1 player on 1 of the teams, for dev mode
	if MUST_HAVE_ATEAST_1PLAYER_PERTEAM == true then
		if team.NumPlayers( TEAM_RED ) < 1 then 
			return true 
		end
		if team.NumPlayers( TEAM_BLUE ) < 1 then
			return true 
		end
	else
		if team.NumPlayers( TEAM_RED ) < 1 and team.NumPlayers( TEAM_BLUE ) < 1 then 
			return true 
		end
	end
	

	return false --if passed all checks
end


function Check_TeamsHavePlayers()
	if TeamsDontHavePlayers() then

		End_CheckTeamsHavePlayers()
		if GetGamePhase() == "BegunGame" then
			ChooseWinner()
		else
			GameRestart()
		end

	end
end


function Start_CheckTeamsHavePlayers()
	hook.Add("Think", "Check_TeamsHavePlayers", Check_TeamsHavePlayers)
end

function End_CheckTeamsHavePlayers()
	hook.Remove("Think", "Check_TeamsHavePlayers")
end






function CreateTimerEnt( time_amount, globalint_name )
	local obj = ents.Create("bb_timer")
		obj.Time = time_amount
		obj.GlobalIntName = globalint_name
		obj:Spawn()
	return obj
end


--plays the specified sound for all players
function PlayGlobalSound( sound, forteam )
	for k,ply in pairs(player.GetAll()) do	
		if forteam != nil then
			if ply:Team() == forteam then
				umsg.Start( sound, ply )
				umsg.End()
			end
		else
			umsg.Start( sound, ply )
			umsg.End()
		end
	end
end



--announces the bugs death on the hug of everyone
--gives the attacking player a frag if they exist
--called by base_puck when the puck dies
function DeathAnnounce( ply, inflictor, attacker )
	local plyname = ply:GetName()
	local message = ( plyname .. " died" )

	if not IsValid( inflictor ) and not IsValid( attacker ) then
		message = ( plyname .. " died" )
		
	elseif IsValid(inflictor) and inflictor:GetClass() == "func_bb_lava" then
		message = ( plyname .. " drowned" )
		
	elseif IsValid(inflictor) and inflictor:GetClass() == "subitem_slider" then
		local attacker_ply = attacker.Creator
		if IsValid( attacker_ply ) then
			--play a sound for the guy who got a kill, and give him a point
			//attacker_ply:PlayLocalSound( "Sound_Frag" )
			attacker_ply:AddFrags( 1 )
			
			message = ( attacker_ply:GetName() .. "  killed  " .. plyname )
		else
			message = ( plyname .. " was killed" )
		end
		
	elseif IsValid(inflictor) and CheckIfInEntTable( inflictor ) then
		local inf_class = inflictor:GetClass()
		local inf_ref = EntReference( inf_class )

		local creator = inflictor.Creator
		if IsValid( creator ) and creator.BBTeam == inflictor.BBTeam then
			--play a sound for the guy who got a kill, and give him a point
			creator:PlayLocalSound( "Sound_Frag" )
			creator:AddFrags( 1 )
			
			message = ( creator:GetName() .. "  killed  " .. plyname .. "  with his  " .. inf_ref.print_name )
		else
			message = ( plyname .. " was killed by a " .. inf_ref.print_name )
		end
	
	end
	
	
	for k,ply in pairs(player.GetAll()) do	
		ply:PrintMessage( HUD_PRINTTALK , message )
	end
end


--[[
function CheckKey()
	for k,ply in pairs(player.GetAll()) do	
		if ply:KeyReleased( IN_FORWARD ) then 
			ply:BBChatPrint( "RELEASED FORWARD" ) 
		end
	end
end
hook.Add( "Tick", "CheckPlayer1Forward", CheckKey)
]]--