--[[---------------------------------------------------------
	Player Meta Tables
---------------------------------------------------------]]--
local BBPlayer = FindMetaTable("Player")

function BBPlayer:AddSwepAbility( abil )
	local ref = SwepabilityReference( abil )

	self:GetActiveWeapon( ):SetClip3( ref.clip )
	self:SetNetworkedString("SwepAbility", abil)
end

function BBPlayer:RemoveSwepAbilities()
	if IsValid( self:GetActiveWeapon( ) ) then
		self:GetActiveWeapon( ):SetClip3( 0 )
	end
	self:SetNetworkedString("SwepAbility", 0)
end

function BBPlayer:GetSwepAbility()
	return self:GetNetworkedString("SwepAbility", nil)
end

--[[
function BBPlayer:SetMaxHealth( amount )
	//print("setting gained damage to:  ")
	self:SetNetworkedInt("GainedDamage", amount)
end

function BBPlayer:GetMaxHealth()
	return self:GetNetworkedInt("GainedDamage", 0)
end
]]--

--[[
--this is the full amount of time
function BBPlayer:SetShownRespawnTime( bool )
	self:SetNetworkedInt( "ShowGhost", bool )
end

function BBPlayer:GetShownRespawnTime( )
	return self:GetNetworkedInt("ShowGhost", false)
end
]]--

--OBSOLETE
function BBPlayer:SetShowGhost( bool )
	self:SetNetworkedBool( "ShowGhost", bool )
end

function BBPlayer:GetShowGhost( )
	return self:GetNetworkedBool("ShowGhost", false)
end

function BBPlayer:SetRespawnTime( int )
	self:SetNetworkedInt( "RespawnTime", int )
end

function BBPlayer:GetRespawnTime( )
	return self:GetNetworkedInt("RespawnTime", 0)
end

--Whether or not the player is ready for the game to begin, game cant start until all players are ready
function BBPlayer:SetIfReady( bool )
	if self:Team() == TEAM_SPEC then return end

	if bool == true then
		for k,ply in pairs(player.GetAll()) do	
			ply:PlayLocalSound( "Sound_Successful" )
			ply:PrintMessage( HUD_PRINTTALK, self:Name() .." is ready!" )
		end
	end
	
	self:SetNetworkedBool( "Ready", bool )
end

function BBPlayer:GetIfReady()
	return self:GetNetworkedBool("Ready", false)
end

--Votes AGAINST this player trying to kick him out
function BBPlayer:SetVotesInt( int )
	self:SetNetworkedInt( "VotesInt", int )
end

function BBPlayer:GetVotesInt()
	return self:GetNetworkedInt("VotesInt", 0)
end

--if you want to add to the players slider damage
function BBPlayer:SetGainedDamage( amount )
	//print("setting gained damage to:  ")
	self:SetNetworkedInt("GainedDamage", amount)
end

function BBPlayer:GetGainedDamage()
	return self:GetNetworkedInt("GainedDamage", 0)
end

function BBPlayer:BBChatPrint( str )
	self:ChatPrint( str )
end

--plays a sound so only this player can hear it
function BBPlayer:PlayLocalSound( sound )
	umsg.Start( sound, self )
	umsg.End()
end

--[[---------------------------------------------------------
	Held ent - usually used to display info about ents certain classes can carry in inventory
---------------------------------------------------------]]--

function BBPlayer:SetHeldEnt( ent )
	self:SetNetworkedString("HeldEnt", ent)
end

function BBPlayer:GetHeldEnt()
	return self:GetNetworkedString("HeldEnt", 0)
end

--[[---------------------------------------------------------
	Tokens
---------------------------------------------------------]]--

function BBPlayer:SetTokens( amount )
	self:SetNetworkedInt("Tokens", amount)
end

function BBPlayer:GetTokens()
	return self:GetNetworkedInt("Tokens", 0)
end

function BBPlayer:AddTokens( amount )
	local curamount = self:GetNetworkedInt("Tokens", 0)
	self:SetNetworkedInt("Tokens", curamount + amount)
end

function BBPlayer:SubtractTokens( amount )
	local curamount = self:GetNetworkedInt("Tokens", 0)
	self:SetNetworkedInt("Tokens", curamount - amount)
end

--when a player changes teams, he drops all his tokens for his ex teammates to use
--or when he leaves the game
function BBPlayer:DropAllTokensInSpawn()
	local tokenshave = self:GetTokens()
	if tokenshave <= 0 then
		return
	end

	local entclass = nil
	if self:Team() == TEAM_RED then
		entclass = "info_player_red"
	elseif self:Team() == TEAM_BLUE then
		entclass = "info_player_blue"
	end
		
	local spawnspot = nil
	for k,ent in pairs(ents.GetAll()) do
		if ent:GetClass() == entclass then
			spawnspot= ent:GetPos()
			break
		end
	end
	
	local pos = ToGround( spawnspot )
	
	local newent = ents.Create( "structure_token" )
		newent:SetPos( pos + Vector(0,0,12) )
		if IsValid( self.Creator ) then
			newent.Creator = self.Creator
		end
		newent.Amount = tokenshave
		newent:Spawn()
	
	if IsValid( self ) then
		self:SetTokens( 0 )
	end
end

--sets what the player's crafting ray will craft crystals into
--takes craft names EX. "craft_block"
function BBPlayer:SetCraft( craft )
	self.Craft = craft
	self:SetNetworkedString("Craft", craft)
end

function BBPlayer:GetCraft()
	--[[
	if SERVER then
		if self.Craft == nil then
			self.Craft = "craft_wall"
		end
		return self.Craft
	else
		--block is the default craftable structure
		return self:GetNetworkedString("Craft", "craft_wall")
	end
	]]--
	return self:GetNetworkedString("Craft", "craft_wall")
end

function BBPlayer:SetIfTeamJoinMenuOpen( bool )
	self:SetNetworkedBool( "TeamJoinMenuOpen", bool )
end

function BBPlayer:GetIfTeamJoinMenuOpen()
	return self:GetNetworkedBool("TeamJoinMenuOpen", false)
end

function BBPlayer:TeamMenu_Open()
	if self:GetIfTeamJoinMenuOpen() == true then
		self:TeamMenu_Close()
	end

	if self:GetIfClassMenuOpen() == true then
		self:ClassMenu_Close()
	end

	self:SetIfTeamJoinMenuOpen( true )

	umsg.Start( "QuickMenu_Clode", self )
	umsg.End()
	
	umsg.Start( "TeamsPanel_Open", self )
	umsg.End()
end

function BBPlayer:TeamMenu_Close()
	if self:GetIfTeamJoinMenuOpen() == true then
		umsg.Start( "TeamsPanel_Close", self )
		umsg.End()
		
		self:SetIfTeamJoinMenuOpen( false )
	end
end

function BBPlayer:SetIfClassMenuOpen( bool )
	self:SetNetworkedBool( "ClassMenuOpen", bool )
end

function BBPlayer:GetIfClassMenuOpen()
	return self:GetNetworkedBool("ClassMenuOpen", false)
end

function BBPlayer:ClassMenu_Open()
	if self:GetIfTeamJoinMenuOpen() == true then
		self:TeamMenu_Close()
	end

	if self:GetIfClassMenuOpen() == true then
		self:ClassMenu_Close()
	end

	self:SetIfClassMenuOpen( true )

	umsg.Start( "ClassPanel_Open", self )
	umsg.End()
end

function BBPlayer:ClassMenu_Close()
	if self:GetIfClassMenuOpen() == true then
		umsg.Start( "ClassPanel_Close", self )
		umsg.End()

		self:SetIfClassMenuOpen( false )
	end
end

--[[---------------------------------------------------------
	Puck code
---------------------------------------------------------]]--

function BBPlayer:SetPuckClass( newclass )
	self.Class = newclass
	self:SetNetworkedString("PuckClass", newclass)
end

function BBPlayer:GetPuckClass()
	if SERVER then
		return self.Class
	else
		return self:GetNetworkedString("PuckClass", "-")
	end
end

function BBPlayer:SpawnPuck(Pos)
	-- Make sure we have a valid/connected player
	if not (IsValid(self)) then return end
	
	-- Break the old Puck if we had one
	if self:HasPuck() then
		self.Puck:Break()
	end
	
	--if the player doesnt have a class, set his to be default
	if self.Class == nil then
		self:SetPuckClass( "puck_smallman" )
	end
	
	--raise the puck up depending on its spawn height
	local class = PuckReference( self.Class )
	Pos.z = Pos.z + class.height_spawn
	
	
	-- Create our new one
	local Puck = ents.Create( self.Class )
		Puck:SetPos(Pos)
		Puck:SetOwner(self)
		Puck:Spawn()
		Puck:Activate()
	
	
	-- If it's a checkpoint, set the eyeangles too
	//self:SetEyeAngles(Angle(0, 0, 0))
	
	-- Make the player follow the Puck
	--self:Spectate(OBS_MODE_CHASE)
	self:SpectateEntity(Puck)
	--self:SetViewOffset(Vector(0,0,0))
	
	-- Disable the crosshair, it's in the way
	--self:CrosshairDisable()

	-- Make it our Puck
	self.Puck = Puck
	self:SetNetPuck( Puck )

	self:SetMoveType( MOVETYPE_OBSERVER )
	self:Spectate(OBS_MODE_CHASE);
	return Puck
end

function BBPlayer:SetNetPuck( puck )
	self:SetNetworkedEntity("Puck", puck)
end

function BBPlayer:GetNetPuck()
	return self:GetNetworkedEntity("Puck", false)
end

function BBPlayer:HasNetPuck()
	return IsValid( self:GetNetworkedEntity("Puck", false) )
end

function BBPlayer:HasPuck()
	return IsValid(self.Puck)
end

function BBPlayer:GetPuck()
	if SERVER then
		if IsValid(self.Puck) then
			return self.Puck
		end
	else
		return self:GetNetPuck()
	end
end

function BBPlayer:GetPuckPos()
	if IsValid(self.Puck) then
		return self.Puck:GetPos()
	end
end

--[[

/*******************************************
********************************************/
function BBPlayer:BreakPuck()
	-- Make sure we have a Puck
	if (self:HasPuck()) then
		-- Break the Puck
		self.Puck:Break()
		self.Puck = nil
	end
end


/*******************************************
********************************************/
function BBPlayer:DeletePuck()
	-- Make sure we have a Puck
	if (self:HasPuck()) then
		-- delete the Puck
		self.Puck:Delete()
		self.Puck = nil
	end
end




function BBPlayer:HasMadeChoices()
	if self.Choice_Class == nil then return false end
	if self.Choice_AbilA == nil then return false end
	if self.Choice_AbilB == nil then return false end
	return true
end


--this function loops if the player has not set his class
function BBPlayer:AttemptSpawnAfterDelay()
	timer.Create("RespawnTimer_" .. self:UniqueID(), 10, 1, function()
			if not IsValid(self) then return end
			--self:End_SpectateMates()
			if self:HasMadeChoices() then
				self:Spawn()
			else
				self:AttemptSpawnAfterDelay()
				self:ChatPrint( "Set your class and abilities (press F1)... Attemping respawn again in 10 seconds..." )
			end

		end)
end

]]--

function BBPlayer:SpectateDeathSpot()
	if self:Team() == TEAM_SPEC then return end
	if self.DeathSpot == nil then return end
	local oldeyeangs = self:EyeAngles()
	
	local spot = ents.Create( "ent_deathspot" )
		spot:SetPos( self.DeathSpot )
		spot:SetOwner( self )
		spot:Spawn()
		//spot:Activate()
		
	self.DeathSpotEnt = spot
		
	self:SpectateEntity( spot )
	self:SetMoveType( MOVETYPE_OBSERVER )
	self:Spectate(OBS_MODE_CHASE)
	
	self:SetEyeAngles( oldeyeangs )
end

--handles respawning based on what stage of the game we're in right now
function BBPlayer:AddToNextRespawn( x )
	if self.Disconnected == true then return end
	
	self:Spectate( OBS_MODE_ROAMING )
	self:SpectateDeathSpot()
	
	--allows instant respawn
	--[[
	if GetGamePhase() == "NoPlayers" or  GetGamePhase() == "PreGame"  or GetGamePhase() == "SetupGame"  then
		--respawn instantly because the game hasnt started
		if IsValid( self ) then
			//self:ChatPrint( "Respawning..." )
			self:Spawn()
		end
		
	elseif GetGamePhase() == "BegunGame" then
	]]--
		
	if GetGamePhase() == "NoPlayers" or  GetGamePhase() == "PreGame"  or GetGamePhase() == "SetupGame"  then
		if x == "instant" then
			if IsValid( self ) then
				self:Spawn()
			end
			return
		end
	
		self:Spawn()

	
	elseif GetGamePhase() == "BegunGame" then
		if x == "instant" then
			if IsValid( self ) then
				self:Spawn()
			end
			return
		end
		
		local respawn = 5
		if team.NumPlayers( self:Team() ) == 1 then
			respawn = RESPAWN_TIME_1_PLY
		elseif team.NumPlayers( self:Team() ) == 2 then
			respawn = RESPAWN_TIME_2_PLY
		elseif team.NumPlayers( self:Team() ) == 3 then
			respawn = RESPAWN_TIME_3_PLY
		elseif team.NumPlayers( self:Team() ) <= 4 then
			respawn = RESPAWN_TIME_4_PLY
		end
	
		self:ChatPrint( "Spawning in ".. respawn .. " seconds..." )

		--shows the time on the hud
		self:SetRespawnTime( CurTime() + respawn )
		self.RespawnTime = CurTime() + respawn
		
		--[[
		timer.Create("RespawnTimer_" .. self:UniqueID(), respawn, 1, function()
			if not IsValid(self) then return end
			self:Spawn()
		end)
		]]--
		
		
	elseif GetGamePhase() == "EndGame" then
		--Do nothing, the games over, theres no point to respawning
		--spectate other players on your team
		--self:Start_SpectateMates()
	end
end