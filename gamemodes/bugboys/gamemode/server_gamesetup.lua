--G_GamePhase:
	--"NoPlayers"
	--"PreGame"
	--"BegunGame"
	--"EndGame"



function Reset_Ents()
	--Remove all leftover player ents in the world.  (for example: barriers, invis reveal devices, etc)
	for k,ent in pairs(ents.GetAll()) do
		if CheckIfInEntTable(ent) then
			ent:Remove()
		end
		
		--probably dont need this, delete it
		if ent:GetClass() == "func_bb_capturezone_blue" or ent:GetClass() == "func_bb_capturezone_blue" then
			ent:EmptyTable()
		end
		
		--spawn in new bug brain objectives
		if ent:GetClass() == "ent_bugbrain_red" or ent:GetClass() == "ent_bugbrain_blue" then
			local obj = ents.Create( "structure_bugbrain" )
				local teamset = nil
				if ent:GetClass() == "ent_bugbrain_red" then
					teamset = TEAM_RED
				elseif ent:GetClass() == "ent_bugbrain_blue" then
					teamset = TEAM_BLUE
				end
			
				obj:SetPos( ent:GetPos() )
				obj.BBTeam = teamset
				obj:Spawn()
		end
		
		
		//if ent:GetClass() == "ent_token_spawn" then
			//ent.TokenQueue = 0
		//end
		
	end
end


	
--Redo this so it just triggers resetvarsbetweenrounds, and does extra stuff for the vars beyond that
function Reset_Vars()
	--Set both team's scores to be 0
	team.SetScore(TEAM_RED, 0)
	team.SetScore(TEAM_BLUE, 0)
	
	SetMaxScore( POINT_WINNING_AMOUNT )
	
	ResetWinningTeam()
	
	ResetDeathCounter()
	
	G_StartedCountDown = false
end

function Remove_RespawnTimers()
	for k,ply in pairs(player.GetAll()) do		
		timer.Remove("RespawnTimer_" .. ply:UniqueID())
		timer.Remove("RecallTimer_" .. ply:UniqueID())
		
		ply.RespawnTime = nil
	end
end



--Starts the whole game up and resets everything in the map to 0
--Also runs right when the game first starts in init.lua
--puts the game basically into a sandbox mode until enough players have joined to start the real game
function GameRestart()
	SetGamePhase("NoPlayers")

	--resets a lot of global vars to their default states
	Reset_Vars()
	Reset_Ents()
	
	--Clears the time and turns it off
	Clear_Timer()

	DisableGiantWall()

	--Set player to spectator, take away all their weapons, force them to respawn, reset their money, open the team setup menu
	for k,v in pairs(player.GetAll()) do		
		v:StripWeapons()
		v:SetTeam(TEAM_SPEC)
		v:SetTokens( 0 )
		
		if v:HasPuck() then
			v.Puck:Delete()
		end
		v:Spawn()
		
		v.FirstSpawn = false
		
		if IsValid(v.DeathSpotEnt) then
			v.DeathSpotEnt:Remove()
		end
		v.DeathSpotEnt = nil
		
		v:SetIfReady( false )
		v:SetFrags( 0 )
		
		v:RemoveSwepAbilities()
		
		--Open_TeamSetupMenu(v)
		v:TeamMenu_Open()
	end

	--this table remembers who has already spawned in the game, so it wont give them more tokens
	Already_Spawned_Plys = {}
	table.Empty( Already_Spawned_Plys )
	
	--spawn some crystals just so players can play around with them and see what they do before the game begins
	//SpawnCrystals_Initial()
	//for k,ent in pairs(ents.GetAll()) do
		//print( ent )
	//end
	
	End_TeamsLivesCheck()
	End_CheckMaxPoints()
	
	Remove_RespawnTimers()
	
	--[[
	if PUB_MODE == true then
		Start_CheckIfGameReady()
	end
	]]--
	
	
	//if DEV_MODE != true then
		//Start_CheckPlayersReady()
	//end
	
	
	//umsg.Start( "QuickMenu_Clode" )
	//umsg.End()
	
end







--Returns true if both teams have enough players and all players are ready to start
function CheckIfAllReady()
	--If theres not atleast 1 player in the server then return false, if no one is there no one is ready
	if table.Count(player.GetAll()) < 1 then 
		return false 
	end
	
	
	--Make sure both teams have enough players
	--if dev mode is on, playercounts for each team dont matter, so skip this
	--[[
	if MUST_HAVE_FULL_TEAMS == true then
		if team.NumPlayers(TEAM_RED) < PLAYERS_PER_TEAM or team.NumPlayers(TEAM_BLUE) < PLAYERS_PER_TEAM then
			return false
		end
	end
	]]--
	
	if MUST_HAVE_ATEAST_1PLAYER_PERTEAM == true then
		if team.NumPlayers( TEAM_RED ) < 1 then return false end
		if team.NumPlayers( TEAM_BLUE ) < 1 then return false end
	end
	
	--if both of the teams have no players, then we cannot start yet, this is mostly for dev mode so it wont auto start with 1 ply on spec
	if team.NumPlayers( TEAM_RED ) < 1 and team.NumPlayers( TEAM_BLUE ) < 1 then return false end
	
	--Make sure no blue or red team players are not ready
	for k,ply in pairs(player.GetAll()) do
		if ply:GetIfReady() == false and ply:Team() != TEAM_SPEC then
			return false
		end
	end

	return true --if past all checks
end


--only runs for pubmode, makes sure theres atleast 1 person on each team
function CheckOneOnEachTeam()
	if team.NumPlayers( TEAM_RED ) < 1 then return false end
	if team.NumPlayers( TEAM_BLUE ) < 1 then return false end
	
	return true
end


//Checks if all players are ready every Think, if they are it triggers the countdown to beginning the round.
function ReadyChecker()


	--pub mode
	
	if PUB_MODE == true then 
		local phase = GetGamePhase()
		if phase != "NoPlayers" and phase != "PreGame" then return end
		
		if CheckOneOnEachTeam() == true then
			if G_StartedCountDown == false then
				StartCountdown_PubMode()
				G_StartedCountDown = true
			end
		else
			if G_StartedCountDown == true then
				CancelCountdown()
			end
		end
	
		return 
	end

	
	
	
	
	
	--non pub mode
	
	local phase = GetGamePhase()
	if phase != "NoPlayers" and phase != "PreGame" then return end
	
	//if everyones ready and the countdown hasnt started, start it
	if CheckIfAllReady() == true then
		if G_StartedCountDown == false then
			StartCountdown()
			G_StartedCountDown = true
		end
	else
		//if players suddenly become unready when the countdown is started, cancel it
		if G_StartedCountDown == true then
			CancelCountdown()
		end
	end
end
hook.Add("Think", "ReadyChecker", ReadyChecker)




function CancelCountdown()
	local phase = GetGamePhase()
	if phase != "PreGame" then return end
	print("cancelling")
	
	G_StartedCountDown = false
	SetGamePhase("NoPlayers")
	Clear_Timer()
end



--this stuff starts the game if theres at least 1 player on each team
--[[
--Returns true if both teams have enough players
function GameReady()
	--If theres not atleast 1 player in the server then return false, if no one is there no one is ready
	if table.Count(player.GetAll()) < 1 then 
		return false 
	end
	
	
	--allows game to start with 1 player on 1 of the teams, for dev mode
	if MUST_HAVE_ATEAST_1PLAYER_PERTEAM == true then
		if team.NumPlayers( TEAM_RED ) < 1 then 
			return false 
		end
		if team.NumPlayers( TEAM_BLUE ) < 1 then
			return false 
		end
	else
		if team.NumPlayers( TEAM_RED ) < 1 and team.NumPlayers( TEAM_BLUE ) < 1 then 
			return false 
		end
	end
	

	return true --if past all checks
end


function CheckIfGameReady()
	if GameReady() then
		End_CheckIfGameReady()
		StartCountdown()
	end
end


function Start_CheckIfGameReady()
	hook.Add("Think", "CheckIfGameReady", CheckIfGameReady)
end

function End_CheckIfGameReady()
	hook.Remove("Think", "CheckIfGameReady")
end
]]--





--make sure the crystals spawn for the first players
--
local function OnMapLoad()
	GameRestart()
end
hook.Add( "InitPostEntity", "OnMapLoad", OnMapLoad )
--
