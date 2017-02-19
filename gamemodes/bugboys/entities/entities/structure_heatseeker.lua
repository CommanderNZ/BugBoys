AddCSLuaFile("structure_heatseeker.lua")

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
	self.ShootTimer = 0
	
	self.TraceFilterTable = {}
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
	if CurTime() < self.ShootTimer then
		return
	end
	
	if not IsValid( self.SentryTarget ) then 
		self.SentryMode = "search"
		self.SentryTarget = nil
		return
	end

	
	local obj = ents.Create( self.Ref.ent_shoot )

		obj:SetPos( self:GetPos() + Vector(0,0,self.Ref.height_gun))
		obj.BBTeam = self.BBTeam
		if IsValid( self.Creator ) then
			obj.Creator = self.Creator
		end
		obj.CreatorSwep = self
		
		obj:SetOwner(self.Creator)
		//obj:SetAngles( self.Owner:EyeAngles() )
		obj:Spawn()
		obj:NoCollideTeam()
	
	
	self:EmitSound(self.Ref.sound_shoot)
	self:DoShootEffect(  )
	
	self.ShootTimer = CurTime() + self.Ref.shoot_rate
end



--do a trace on the ent, return true if target still in sight and range
function ENT:CheckTargetTrace()
	if not IsValid(self.SentryTarget) then
		return false
	end

	--check if the ent is in sight of the sentry
	local Trace = {}
		Trace.start = self:GetPos() + Vector(0, 0, 80)
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
	
		if self.SentryTarget == thing then//and heightdif < self.Ref.max_target_height then
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
			if ent:IsValidVehicle() and ent.BBTeam == GetOppositeTeam(self.BBTeam) then
			//if ent:IsValidPuck() and ent.BBTeam == GetOppositeTeam(self.BBTeam) then
				-- Make a trace to see if it can shoot this puck
				local Trace = {}
					Trace.start = self:GetPos() + Vector(0, 0, 80)
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
					
					self.SentryMode = "shoot"
					self.SentryTarget = ent
					//self.TimeToShoot = CurTime() + self.Ref.charge_time
					break
				end
			end
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

	self:NextThink( CurTime() + .3 )
	return true
end


