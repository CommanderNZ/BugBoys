/*---------------------------------------------------------
	ENT Meta Table
---------------------------------------------------------*/

local TTGEnt = FindMetaTable("Entity")







--returns true if the ent is on the ground (a specified height from it)
function TTGEnt:GetIfOnGround( height, filter )
	local pos = self:GetPos()
	local tracedata = {}
		tracedata.start = pos
		tracedata.endpos = pos + (Vector(0, 0, -1) * height)
		tracedata.filter = self, filter
	
	local trace = util.TraceLine(tracedata)
	
	--if it didnt hit anything, we have nothing to do
	local hit = trace.Hit
	if not hit then
		return false
	end
	
	
	local hitnonworld = trace.HitNonWorld
	local hitworld = trace.HitWorld
	local ent = trace. Entity
	if hitnonworld then
		if CheckIfInEntTable( ent ) and ent:GetIfStatic() then
			return true
		else
			return false
		end
		
	elseif hitworld then
		return true
	end
	
	return false
end





--methods so the client can know what team an ent is, set this if client needs it for some reason
--this must be in meta ent
function TTGEnt:SetEntTeamForClient( teamnum )
	local x = self.BBTeam
	if teamnum != nil then
		x = teamnum
	end
	//print("setting ent team")
	self:SetNWInt( "IntTeam", x ) 
end

function TTGEnt:GetEntTeamForClient()
	return self:GetNWInt( "IntTeam", 5 ) 
end




--doesnt work for some reason
--[[
function TTGEnt:GetEntTeam()
	if not IsValid( self.BBTeam ) then
		return
	end
	return self.BBTeam
end
]]--


--returns whether or not this ent is a projectile
function TTGEnt:IsProjectile()
	if CheckIfInEntTable( self ) != true then return false end
	local entref = EntReference( self:GetClass() )
	if entref.is_projectile == true then
		return true
	else
		return false
	end
end







function TTGEnt:SetGrabber( grabber )
	self.Grabber = grabber
end

function TTGEnt:GetGrabber()
	if self.Grabber != nil then
		return self.Grabber 
	end
end








--this is set when the ent is grabbed, so 2 players cant grab the same ent at the same time
function TTGEnt:SetIfBeingGrabbed( x )
	local begrabbed = false
	if x != nil then
		begrabbed = x
	end
	self.BeingGrabbed = begrabbed
end

function TTGEnt:GetIfBeingGrabbed()
	local begrabbed = false
	if self.BeingGrabbed != nil then
		begrabbed = self.BeingGrabbed
	end
	return begrabbed
end




--sets whether or not players can grab this ent
function TTGEnt:SetIfCanGrab( x )
	local cando = true
	if x != nil then
		cando = x
	end
	self.CanGrab = cando
end

function TTGEnt:GetIfCanGrab()
	local cando = true
	if self.CanGrab != nil then
		cando = self.CanGrab
	end
	return cando
end





--uses "static" variable in the ent table
function TTGEnt:GetIfStatic()
	local ref = self:GetRef()
	if ref.static == true or self.TurnedStatic == true then 
		return true
	else
		return false
	end
end


--returns whether or not the puck is in its teams fountain
function TTGEnt:IsInFountain()
	local entclass = nil
	if self.BBTeam == TEAM_RED then
		entclass = "func_bb_healer_red"
	elseif self.BBTeam == TEAM_BLUE then
		entclass = "func_bb_healer_blue"
	end
	
	for k,ent in pairs(ents.GetAll()) do
		if ent:GetClass() == entclass then
			for _,puck in pairs( ent.TouchingPlyList ) do
				if self == puck then
					return true
				end
			end
		end
	end
	return false
end



--[[
function TTGEnt:IsInNobuild()
	for k,ent in pairs(ents.GetAll()) do
		if ent:GetClass() == "func_bb_nobuild" then
			for _, entin in pairs( ent.TouchingEntList ) do
				if self == entin then
					return true
				end
			end
		end
	end
	return false
end
]]--


--hurt the ent
function TTGEnt:HurtEnt( amount, inflictor, attacker )
	local dmginfo = DamageInfo()
		dmginfo:SetDamage( amount )
		dmginfo:SetDamageType( DMG_CRUSH )
		dmginfo:SetInflictor( inflictor )
		dmginfo:SetAttacker( attacker )
	self:TakeDamageInfo( dmginfo )
end


--gets the max hp of the puck or structure or ent
function TTGEnt:GetMaxHP()
	if CheckIfInPuckTable( self ) then 
		local ref = PuckReference( self:GetClass() )	
		return ref.health
	elseif CheckIfInEntTable( self ) then 
		local ref = EntReference( self:GetClass() )	
		//if IsValid(ref) != true then return false end
		if ref.health != nil then
			return ref.health
		end
	end
	return false
end



function TTGEnt:GetEnemyTeam()
	if self:IsPlayer() then
		if self:Team() == TEAM_RED then
			return TEAM_BLUE
		elseif self:Team() == TEAM_BLUE then
			return TEAM_RED
		end
	else
		if self.BBTeam == TEAM_RED then
			return TEAM_BLUE
		elseif self.BBTeam  == TEAM_BLUE then
			return TEAM_RED
		end
	end
end


--Checks if the ent is a player OR a vehicle
function TTGEnt:IsValidPuck()
	if self:GetClass() == "structure_blimp" or self:GetClass() == "structure_boat" or self:GetClass() == "structure_chopper" 
	 or self:GetClass() == "structure_scout" or self:GetClass() == "structure_destroyer" or self:GetClass() == "structure_plane"
	 or self:GetClass() == "structure_dropship"  then
		return true
	end
	
	if not CheckIfInPuckTable( self ) then return false end
	return true
end



--Checks if the ent is a player whos alive playing the game currently
function TTGEnt:IsValidPlyBug()
	if not CheckIfInPuckTable( self ) then return false end
	return true
end



--Checks if the ent is a a vehicle
function TTGEnt:IsValidVehicle()
	if self:GetClass() == "structure_blimp" or self:GetClass() == "structure_boat" or self:GetClass() == "structure_chopper" 
	or self:GetClass() == "structure_scout" or self:GetClass() == "structure_destroyer" or self:GetClass() == "structure_plane" 
	or self:GetClass() == "structure_turret_vehicle" or self:GetClass() == "structure_dropship" then
		return true
	end
	return false
end




--takes a table of strings naming types of pucks to check for
--checks if this puck is in the table of pucks
function TTGEnt:IsThisPuckType( tbl )
	for k,ent in pairs( tbl ) do
		if self:GetClass() == ent then
			return true
		end
	end
	return false
end

--sets the ent to not collide with its own team
function TTGEnt:NoCollideTeam()
	for k,ent in pairs(ents.GetAll()) do
		if ent:IsValidPlyBug() and ent.BBTeam == self.BBTeam then
			constraint.NoCollide( self, ent, 0, 0 )
			
		--gibs dont collide with projectiles
		elseif ent.IsGib then
			constraint.NoCollide( self, ent, 0, 0 )
		end
	end
end



function TTGEnt:NoCollideSlider()
	for k,ent in pairs(ents.GetAll()) do
		if ent:GetClass() == "subitem_slider" then
			constraint.NoCollide( self, ent, 0, 0 )
		end
	end
end


--[[
--sets the ent to not collide with its own team
function TTGEnt:NoCollideGibs()
	for k,ent in pairs(ents.GetAll()) do
		if ent:IsValidPuck() or ent:IsProjectile() then
			constraint.NoCollide( self, ent, 0, 0 )
		end
	end
end
]]--



--sets the ent to not collide with an ent
function TTGEnt:NoCollideEnt( ent )
	constraint.NoCollide( self, ent, 0, 0 )
end





--Gets what team the ent is on, doesnt matter if its a player or entity
--SERVER only
function TTGEnt:GetTeam()
	if self:IsPlayer() then
		return self:Team()
	elseif CheckIfInEntTable( self ) then
		return self.TTG_Team
	end
	print("error, ent has no team")
end



--takes a direction, a horizontal force and an optional vertical force
--pushes the ent in that direction
function TTGEnt:Knockback( dir, horforce, vertforce )
	--this var can be applied to certain entities to disable kbockack effects for a time
	if self.CanKnockback == false then return end

	if vertforce == nil then
		vertforce = 0
	end

	if self:IsPlayer() then
		local hunker = 0
		if self:HowManyOfThisBuff( "Buff_Hunker" ) > 0 then
			hunker = 1
		elseif self:HowManyOfThisBuff( "Buff_HunkerSuper" ) > 0 then
			hunker = 2
		end
		
		if hunker == 1 then
			--lessen the knockback by a lot because they have hunker
			self:SetVelocity( Vector( dir.x, dir.y, 0 ) * (horforce*.2) + Vector( 0, 0, (vertforce*.2) ) )
			return 
		elseif hunker == 2 then
			--do nothing because they have super hunker
			return 
		end
		
		self:SetVelocity( Vector( dir.x, dir.y, 0 ) * horforce + Vector( 0, 0, vertforce ) )

			
	elseif self:GetPhysicsObject():IsValid() then
		self:GetPhysicsObject():SetVelocity( Vector( dir.x, dir.y, 0 ) * horforce + Vector( 0, 0, vertforce ) )
		
	end
	
	
	--when the boulder is knocked back, it makes the player in control of it unable to control it for a short period
	if self:GetClass() == "ent_boulder" then
		self:BreakControl()
	end
end






--Used by barrier
function TTGEnt:AddTeamBarrierNoCollide()
	for k,ent in pairs(ents.GetAll()) do
		if ent:GetClass() == "ent_barrier" and self.TTG_Team == ent.TTG_Team then
			constraint.NoCollide( self, ent, 0, 0 )
		end
	end
end


--[[
function TTGEnt:AddSpawnDoorNoCollide()
	--if the creator is not on attacker, this will not run
	if GetTeamRole( self.Creator:Team() ) != "Attacking" then return end

	for k,ent in pairs(ents.GetAll()) do
		if ent:GetClass() == "func_brush" and ent:GetName() == BRUSH_DOOR_NAME then
			constraint.NoCollide( self, ent, 0, 0 )
		end
	end
end
]]--