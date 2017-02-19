/*---------------------------------------------------------
	all server files that have to do with players spawning
---------------------------------------------------------*/




--called when a player first enters the server
function GM:PlayerInitialSpawn( ply )
	ply:SetTeam(TEAM_SPEC)
	ply:PrintMessage( HUD_PRINTTALK, "Welcome, " .. ply:Name() .. "!" )
	ply:TeamMenu_Open()

	--this data is stored even inbetween game rounds, its only reset when the player leaves the server
	ply.Choice_Class = nil
	ply.Choice_AbilA = nil
	ply.Choice_AbilB = nil
end


--called whenever a player spawns
function GM:PlayerSpawn( ply )
	ply:GodEnable()

	//print("spawning")
	ply:Spectate( OBS_MODE_ROAMING )
	
	if IsValid(self.DeathSpotEnt) then
		self.DeathSpotEnt:Remove()
	end
	
	if (ply:Team() == TEAM_SPEC) then
		//ply:Spectate( OBS_MODE_ROAMING )
		--ply:SetViewOffset(Vector(0,0,700))
	return 
	end

	if ply:HasPuck() then
		ply.Puck:Delete_NoRespawn()
	end
	
	ply:DrawWorldModel(false)
	
	--so the player can play around with constructing stuff if he wants
	if GetGamePhase() == "NoPlayers" then
		ply:SetTokens( STARTING_TOKENS_NOPLAYERS )
	end
	
	
	-- Trace down and set the position at ground level
	local SpawnPoint = self:PlayerSelectSpawn(ply)
	local PuckPos = SpawnPoint:GetPos()
	
	PuckPos.z = PuckPos.z + 50 -- So the puck doesn't spawn in ground
	
	-- Spawn the puck at this pos
	local Puck = ply:SpawnPuck( PuckPos )
	
	
	local vec1 = Vector(0,0,0) -- Where we're looking at
	local vec2 = ply:GetShootPos() -- The player's eye pos
	ply:SetEyeAngles((vec1 - vec2):Angle()) -- Sets to the angle between the two vectors
end








function RespawnPlayersCheck( )
	for k,ply in pairs(player.GetAll()) do		
		if ply:Team() != TEAM_SPEC then
			if ply.RespawnTime != nil and CurTime() >= ply.RespawnTime then
				ply:Spawn()
				ply:ChatPrint( "Spawning NOW!" )
				ply.RespawnTime = nil
			end
		end
	end
end
hook.Add("Think", "RespawnPlayersCheck", RespawnPlayersCheck)







--Sets default vars a player should spawn with
function SetSpawnStuff( ply )
end




function GM:PlayerSelectSpawn( ply )
	self.SpawnTable = {}

	--Set the players spawn table to be his team's spawn table
	if (ply:Team() == TEAM_SPEC) then
		self.SpawnTable  = ents.FindByClass( "info_player_start" )
	
	elseif (ply:Team() == TEAM_RED) then
		self.SpawnTable = ents.FindByClass( "info_player_red" )

	elseif (ply:Team() == TEAM_BLUE) then
		self.SpawnTable = ents.FindByClass( "info_player_blue" )
	end
	
	
	--If there are no spawn points availible for this player's team, add any old kind of spawn to the table
	local Count = table.Count( self.SpawnTable  )
	if ( Count == 0 ) then
		Msg("Error! Incorrect spawn points for:  ".. ConvertToTeamName(ply:Team()) .. "\n")
		self.SpawnTable = table.Add( self.SpawnTable, ents.FindByClass( "info_player_terrorist" ) )
		self.SpawnTable = table.Add( self.SpawnTable, ents.FindByClass( "info_player_start" ) )
		self.SpawnTable = table.Add( self.SpawnTable, ents.FindByClass( "info_player_allies" ) )
		self.SpawnTable = table.Add( self.SpawnTable, ents.FindByClass( "info_player_counterterrorist" ) )
		self.SpawnTable = table.Add( self.SpawnTable, ents.FindByClass( "info_player_rebel" ) )
		self.SpawnTable = table.Add( self.SpawnTable, ents.FindByClass( "info_player_combine" ) )
		self.SpawnTable = table.Add( self.SpawnTable, ents.FindByClass( "info_player_deathmatch" ) )
		self.SpawnTable = table.Add( self.SpawnTable, ents.FindByClass( "info_player_teamspawn" ) )
		self.SpawnTable = table.Add( self.SpawnTable, ents.FindByClass( "info_player_red" ) )
		self.SpawnTable = table.Add( self.SpawnTable, ents.FindByClass( "info_player_blue" ) )
	end

	
	--if the player is on spec, we can just return one of the spawns in the table at random right now, dont need to check if stuff is in the way
	if (ply:Team() == TEAM_SPEC) then
		local ChosenSpawnPoint = nil
		ChosenSpawnPoint = self.SpawnTable[ math.random( 1, Count ) ]
		return ChosenSpawnPoint
	end


	--go through spawns until we find one that doesnt have some ent in the way
	for k,spawn in pairs(self.SpawnTable) do
		local suitable = true

		local orgin_ents = ents.FindInSphere( spawn:GetPos(), 48 )
		for k, ent in pairs( orgin_ents ) do

			--redo this to go through a list of game ents that could possibly block spawn
			if IsValid(ent) then
				if ent:GetClass() != "info_player_teamspawn" then
					suitable = false
				end
			end
		end

		if suitable == true then
			return spawn
		end
	end	


	--if we didnt find a suitable spawn, attempt to spawn at a random one anyway
	local ChosenSpawnPoint = nil
	ChosenSpawnPoint = self.SpawnTable[ math.random( 1, Count ) ]
	return ChosenSpawnPoint
end

