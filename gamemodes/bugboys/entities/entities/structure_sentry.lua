AddCSLuaFile("structure_sentry.lua")

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
	
	--start looping sound
	//self.LoopingSound_A = CreateSound( self, self.Ref.sound_loop )
	//self.LoopingSound_A:Play()
	
	self.BeepTimer = 0
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

	
	local self_vec = self:GetPos() + Vector(0, 0, self.Ref.height_gun)
	local target_vec = self.SentryTarget:GetPos() //+ Vector(0, 0, self.Ref.height_gun)
	
	local shoot_ang = ( target_vec - self_vec):GetNormal()
	local rot = Angle(0, 0, 0)
	shoot_ang:Rotate( rot )
	
	
	local bullet = {}
		bullet.Num 		= 1
		bullet.Src 		= self:GetPos() + Vector(0, 0, self.Ref.height_gun)	// Source
		bullet.Dir 		= shoot_ang	// Dir of bullet
		bullet.Spread 	= Vector( self.Ref.aim_cone, self.Ref.aim_cone, 0 )		// Aim Cone
		bullet.Tracer	= 1	// Show a tracer on every x bullets 
		bullet.TracerName = "Tracer" // what Tracer Effect should be used
		bullet.Force	= 0	// Amount of force to give to phys objects
		bullet.Damage	= self.Ref.bullet_damage
		bullet.AmmoType = "Pistol"
	
	self:FireBullets( bullet )
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
		Trace.start = self:GetPos() + Vector(0, 0, self.Ref.height_gun)
		Trace.endpos = self.SentryTarget:GetPos()
		Trace.filter = self
		Trace.mask = MASK_SOLID //- CONTENTS_GRATE
		Trace = util.TraceLine(Trace) 
	if (Trace.Entity) != self.SentryTarget then
		return false
	end
	
	--make sure the ent is also still within the radius of the guns range
	local orgin_ents = ents.FindInSphere( self:GetPos(), self.Ref.radius )
	for k,thing in pairs( orgin_ents ) do
		local entpos = thing:GetPos()
		local selfpos = self:GetPos()
		local heightdif = (entpos.z - (selfpos.z + self.Ref.height_gun))
	
		if self.SentryTarget == thing and heightdif < self.Ref.max_target_height then
			return true
		end
	end
	
	return false
end




function ENT:Think()
	local orgin_ents = ents.FindInSphere( self:GetPos(), self.Ref.radius )
	
	if self.SentryMode == "search" then
		--look in the radius for pucks
		for k,ent in pairs( orgin_ents ) do
			local entpos = ent:GetPos()
			local selfpos = self:GetPos()
			local heightdif = (entpos.z - (selfpos.z + self.Ref.height_gun))
			if ent:IsValidPuck() and ent.BBTeam == GetOppositeTeam(self.BBTeam) and heightdif < self.Ref.max_target_height then
				-- Make a trace to see if it can shoot this puck
				local Trace = {}
					Trace.start = self:GetPos() + Vector(0, 0, self.Ref.height_gun)
					Trace.endpos = ent:GetPos()
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
					
					self.SentryMode = "chargeup"
					self.SentryTarget = ent
					self.TimeToShoot = CurTime() + self.Ref.charge_time
					break
				end
			end
		end
		
		
		
	elseif self.SentryMode == "chargeup" then
		--if the sentry can no longer see the target, then switch back to search mode begin looking for a new target
		--[[
		if not self:CheckTargetTrace() then
			self.SentryMode = "search"
			self.SentryTarget = nil
			
		--if the chargeup time has eclapsed, then start shooting the target on the next think
		elseif CurTime() >= self.TimeToShoot then
			self.SentryMode = "shoot"
		end
		]]--
		
		if CurTime() >= self.TimeToShoot then
			self.SentryMode = "shoot"
		end
		
	
	elseif self.SentryMode == "shoot" then
		--shoot at the current target
		self:Shoot()
		
		--if the sentry can no longer see the target, then switch back to search mode begin looking for a new target
		if not self:CheckTargetTrace() then
			self.SentryMode = "search"
			self.SentryTarget = nil
		end
		
		
		
		
	end
	
	
	if CurTime() > self.BeepTimer then
		self:EmitSound( self.Ref.sound_repeat )
		self.BeepTimer = CurTime() + self.Ref.repeat_rate
	end
	
	self:NextThink( CurTime() + .2 )
	return true
end


