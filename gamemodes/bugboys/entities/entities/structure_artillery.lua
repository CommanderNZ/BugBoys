AddCSLuaFile("structure_artillery.lua")

ENT.Type 			= "anim"
ENT.Base 			= "base_bbentity"
//ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

if !SERVER then return end
------------------------------------------------------------------------------------------------
--all server from now on
------------------------------------------------------------------------------------------------
ENT.SentryMode = "search"
ENT.SentryTarget = nil



function ENT:Initialize()
	self:SpecialInit()
	
	self:ChangeStaticModel( self.Ref.model, COLLISION_GROUP_WEAPON )
	//self:EmitSound( self.Ref.sound_collisionson )
end

--triggers the block to go unsolid for a moment, only possible while frozen
function ENT:RayTrigger( activator )
	if !SERVER then return end

end



------------------------------------------------------------------------------------------------
--Sentry stuff code
------------------------------------------------------------------------------------------------

--makes the visual muzzle flash effect
function ENT:DoShootEffect( forward )
	local effectdata = EffectData()
		effectdata:SetOrigin( self:GetPos() + Vector(0, 0, self.Ref.height_gun) )
		effectdata:SetStart( self.SentryTarget:GetPos() + Vector(0, 0, self.Ref.height_gun) )
		effectdata:SetScale( 8 )
		effectdata:SetAttachment( 1 )
		effectdata:SetEntity( self )
	util.Effect( "HelicopterMegaBomb", effectdata )
end


--shoots at the current target, (makes a bullet and fires it)
function ENT:Shoot( )
	if not IsValid( self.SentryTarget ) then return end

	//local self_vec = self:GetPos() + Vector(0, 0, self.Ref.height_gun)
	//local target_vec = self.SentryTarget:GetPos() + Vector(0, 0, 400)
	
	//local shoot_ang = ( target_vec - self_vec):GetNormal()
	
	
	
	
	//local rot = Angle(0, 0, 0)
	//shoot_ang:Rotate( rot )
	
	//bullet.Src 		= self:GetPos() + Vector(0, 0, self.Ref.height_gun)	// Source
	//bullet.Dir 		= shoot_ang	// Dir of bullet
	
	local newent = ents.Create( self.Ref.missile )
		newent:SetPos( self:GetPos() + Vector(0, 0, self.Ref.height_gun) )
		//newent:SetAngles( shoot_ang )
		if IsValid( self.Creator ) then
			newent.Creator = self.Creator
		end
		newent.BBTeam = self.BBTeam
		newent:Spawn()
		
		constraint.NoCollide( self, newent, 0, 0 )
	
	//local vec = self:WorldToLocal( self.SentryTarget:GetPos())
	//local vecnorm = vec:GetNormal()
	
	
	--nocollide with all structure_artillery
	for k,ent in pairs(ents.GetAll()) do
		if ent.BBTeam == self.BBTeam and ent:GetClass() == "structure_artillery" then
			constraint.NoCollide( newent, ent, 0, 0 )
		end
	end
	
	

	local tr_target = self.SentryTarget:GetPos() + Vector(0, 0, 32)
	local self_pos = (self:GetPos() + Vector(0, 0, self.Ref.height_gun) )
	local shoot_ang = ( self_pos - tr_target ):GetNormal()
		local rot = Angle(0, 0, 0)
		shoot_ang:Rotate( rot )
	local move_ang = -shoot_ang
	
	//ent:GetPhysicsObject():SetVelocity( Vector( move_ang.x, move_ang.y, 0 ) * self.Ref.force_phys )
	
	
	
	
	
	
	local phys = newent:GetPhysicsObject()
		//phys:ApplyForceCenter ( shoot_ang:GetNormalized() *  self.Ref.shoot_force )
		//phys:ApplyForceCenter ( self:WorldToLocal( self.SentryTarget:GetPos()) )//* self.Ref.shoot_force )
		phys:ApplyForceCenter ( move_ang * self.Ref.shoot_force )
		phys:EnableGravity(false) 
	
	self:EmitSound(self.Ref.sound_shoot)
	self:DoShootEffect(  )
end



--do a trace on the ent, return true if target still in sight and range
function ENT:CheckTargetTrace()
	if not IsValid(self.SentryTarget) then
		return false
	end

	--check if the ent is in sight of the sentry
	local Trace = {}
		Trace.start = self:GetPos() + Vector(0, 0, self.Ref.height_gun + 50)
		Trace.endpos = self.SentryTarget:GetPos() + Vector(0, 0, 32)
		Trace.filter = self
		Trace.mask = MASK_SOLID //- CONTENTS_GRATE
		Trace = util.TraceLine(Trace) 
	if (Trace.Entity) != self.SentryTarget then
		return false
	end
	
	
	--make sure the ent is also still within the radius of the guns range
	--[[
	local orgin_ents = ents.FindInSphere( self:GetPos(), self.Ref.radius )
	for k,thing in pairs( orgin_ents ) do
		if self.SentryTarget == thing then
			return true
		end
	end
	]]--
	
	return false
end


//function ENT:SearchForTarget()
//end



function ENT:Think()
	local orgin_ents = ents.FindInSphere( self:GetPos(), self.Ref.radius )
	
	if self.SentryMode == "search" then
		--look in the radius for pucks
		
		local reversed_origin_ents = table.Reverse( orgin_ents )
		for k,ent in pairs( reversed_origin_ents ) do
			if ent.BBTeam == GetOppositeTeam(self.BBTeam) and CheckIfInEntTable(ent) and ent:GetPhysicsObject():IsMotionEnabled() != true 
			and ent:GetClass() != "ent_intermediary_structure"
			and ent:GetClass() != "structure_bombtime"
			and ent:GetClass() != "structure_sapper"
			and ent:GetClass() != "structure_bugbrain"
			and ent:GetClass() != "structure_bugbrain_shield" then
				-- Make a trace to see if it can shoot this puck
				local Trace = {}
					Trace.start = self:GetPos() + Vector(0, 0, self.Ref.height_gun + 50)
					Trace.endpos = ent:GetPos() + Vector(0, 0, 32)
					Trace.filter = self
					Trace.mask = MASK_SOLID //- CONTENTS_GRATE
					Trace = util.TraceLine(Trace) 
				
				local hit = false
				
				--check if it hit the puck
				if (Trace.Entity) == ent then
					hit = true
				end

				
				if hit then
					--play beep sound to signify it sees an enemy
					self:EmitSound(self.Ref.sound_see)
					
					self.SentryMode = "shoot"
					self.SentryTarget = ent
					break
				end
			end
		end
		self:NextThink( CurTime() + self.Ref.fire_rate )
		return true
		
		
	
	elseif self.SentryMode == "shoot" then
		--shoot at the current target
		self:Shoot()
		
		--if the sentry can no longer see the target, then switch back to search mode begin looking for a new target
		if not self:CheckTargetTrace() then
			self.SentryMode = "search"
			self.SentryTarget = nil
		end
		self:NextThink( CurTime() + self.Ref.fire_rate )
		return true

	end
	
	
	
	self:NextThink( CurTime() + self.Ref.fire_rate )
	return true
end


