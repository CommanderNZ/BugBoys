ENT.Type 			= "brush"
ENT.Base 			= "base_anim"
ENT.PrintName		= ""



if !SERVER then return end
------------------------------------------------------------------------------------------------
--all server from now on
------------------------------------------------------------------------------------------------


function ENT:Initialize()
	self.TouchingPlyList = {}
	self.Capturing = false
	self.BBTeam = TEAM_BLUE
	
	self:CreateMarker()
end


function ENT:CreateMarker()
	local MarkerPos = self:OBBCenter( ) + Vector(0, 0, 80)
	local Marker = ents.Create( "marker_pointzone" )
		Marker:SetPos(MarkerPos) 
		Marker:Spawn()
		Marker:SetSkin( 1 )
		
	self.MarkerEnt = Marker
end


function ENT:EmptyTable()
	table.Empty( self.TouchingPlyList )
end


function ENT:StartTouch( entity )
	//if GetGamePhase() == "BegunGame" then return end
	if entity:IsValidPuck() then
		table.insert( self.TouchingPlyList, entity )
		self.Capturing = true
	end
	
	--add 2 points if the players get a goal
	if entity:GetClass() == "structure_goalball" and entity.BBTeam == GetOppositeTeam( self.BBTeam  ) then
		AddPoints( GetOppositeTeam( self.BBTeam  ), GOALBALL_POINTS )
		
		timer.Simple( 1, function()
			if not IsValid( entity ) then return end
			entity:EmitSound( SOUND_CHEER )
			entity:Remove()
		end)

		
		
		PlayGlobalSound( "Sound_TeamScoreAgainst", self.BBTeam )
		PlayGlobalSound( "Sound_TeamScore", GetOppositeTeam( self.BBTeam  ) )
	end
end

function ENT:EndTouch( entity )
	//if GetGamePhase() == "BegunGame" then return end
	if entity:IsValidPuck() then
		table.RemoveByValue( self.TouchingPlyList, entity )
		
		if table.Count( self.TouchingPlyList ) <= 0 then
			self.Capturing = false
		end
		//print("removing " .. entity:GetClass())
	end
end


function ENT:Think()
	--this is to make sure players who arent touching get removed from the table, (end touch doesnt always detect it)
	--[[
	if table.Count( self.TouchingPlyList ) > 0 then
		local mins = self:OBBMins()
		local maxs = self:OBBMaxs()
		
		local orgin_ents = ents.FindInBox( mins, maxs );
		
		for _, ply in pairs( self.TouchingPlyList ) do
			if not table.HasValue( orgin_ents, ply ) then
				table.RemoveByValue( self.TouchingPlyList, ply )
				print("removing SPECIALLY:" .. ply:GetClass())
			end
		end
	end
	]]--
	
	--see if a vehicle must be removed or added to the list depending on if it has players on it
	for k, ent in pairs( self.TouchingPlyList ) do
		if ent:IsValidPuck() and ent:IsValidPlyBug() != true then
			if ent:PuckTable_HasPucks() != true then
				table.RemoveByValue( self.TouchingPlyList, ent )
				
			elseif ent:PuckTable_HasPucks() == true then
				if not table.HasValue( self.TouchingPlyList, ent ) then
					table.insert( self.TouchingPlyList, ent )
				end
			end
		end
	end
	
	if GetGamePhase() != "BegunGame" then return end
	
	
	if table.Count( self.TouchingPlyList ) > 0 then
		local enemies = 0
		local allies = 0
	
		for _, puck in pairs( self.TouchingPlyList ) do
			if puck.BBTeam == GetOppositeTeam( self.BBTeam  ) then
				enemies = enemies + 1
			elseif puck.BBTeam == self.BBTeam then
				allies = allies + 1
			end
		end
		
		if allies > 0 and enemies == 0 then
			--do nothing, allies wont capture their own point
		elseif allies > 0 and enemies > 0 then
			--capture slower than if only enemies are there
			AddPoints( GetOppositeTeam( self.BBTeam  ), 1 )
			
			PlayGlobalSound( "Sound_TeamScoreAgainst", self.BBTeam )
			PlayGlobalSound( "Sound_TeamScore", GetOppositeTeam( self.BBTeam  ) )
			
			self:NextThink( CurTime() + TIME_CAP_SLOW )
			return true
		elseif allies == 0 and enemies > 0 then
			AddPoints( GetOppositeTeam( self.BBTeam  ), 1 )
			
			PlayGlobalSound( "Sound_TeamScoreAgainst", self.BBTeam )
			PlayGlobalSound( "Sound_TeamScore", GetOppositeTeam( self.BBTeam  ) )
		end
	end
	
	self:NextThink( CurTime() + TIME_CAP_FAST )
	return true
end



//for _, v in pairs(player.GetAll()) do
	//v:PrintMessage(HUD_PRINTTALK, entity:GetName().. " has entered the lua brush area.")
//end
