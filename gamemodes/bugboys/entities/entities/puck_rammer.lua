AddCSLuaFile("puck_rammer.lua")

ENT.Type 			= "anim"
ENT.Base 			= "base_puck"





-- ENT:Initialize - Initialize stuff --
function ENT:Initialize()
	self:SpecialInit()
	
	if !SERVER then return end
	
	--give the player this class's SWEP
	self.Owner:Give( self.Ref.swep )
	

	-- Set model and physics
	self.Entity:SetModel(self.Ref.model)
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )

	--set team color
	if self.Owner:Team() == TEAM_RED then
		self:SetColor(Color(255, 0, 0, 255))
	else 
		self:SetColor(Color(0, 0, 255, 255))
	end


	-- Wake our physics
	local phys = self.Entity:GetPhysicsObject()
	
	--set to be slidy
	phys:SetMaterial("gmod_ice")
	
	--set mass
	phys:SetMass(self.Ref.mass)
	
	--correct angles, tire on its side
	phys:SetAngles( Angle(0, 0, 90))
	
	if (phys:IsValid()) then
		phys:Wake()
	end
	
	--enables physics simulate function
	--self:StartMotionController()
	
	-- Change the speeds depending on the tickrate (based on 33 tickrate)
	--local Tickrate = FrameTime() * 33
	--self.ForwardSpeed = math.Round(self.ForwardSpeed * Tickrate)
	--self.ReverseSpeed = math.Round(self.ReverseSpeed * Tickrate)
	--self.StrafeSpeed = math.Round(self.StrafeSpeed * Tickrate)
	
	-- Leave
	self.JumpTimer = 0
	self.SpeedMaxMod = self.Ref.speed_max 		
end




if !SERVER then return end
------------------------------------------------------------------------------------------------
--all server from now on
------------------------------------------------------------------------------------------------




-- ENT:Think - Do our controls & powerups here --
function ENT:Think()
	if self.EnabledInput != false then
		--ability functions
		self:DoGrab()
		self:DoCraft(true)
		//self:DoWeld()
		self:DoHealHurt()
	end

	local Owner = self:GetOwner()
	local MelonPhysObj = self:GetPhysicsObject()
	local Aim = Owner:EyeAngles()
	//local OwnerEyes = Owner:EyeAngles()
	Aim.r = 0
	Aim.p = 0
	
	//local max_velocity = 200
	local velo = self:GetVelocity( )
	local veloxy = Vector(velo.x,velo.y,0)
	
	
	local speed = Vector(velo.x,velo.y,0):Length()
	//Owner:PrintMessage( HUD_PRINTCENTER, tostring(speed) )
	
	-- We need to update the player position at the melon or bad thing happens D:
	Owner:SetPos(self.Entity:GetPos())
	

	
	local input_thisframe = false
	local force = self.Ref.force_add
	
	local function Movement()
		-- Check which key is pressed and move accordingly
		if (Owner:KeyDown(IN_FORWARD)) then
			local Aim = Aim:Forward()
			--if velo < max_velocity then
				--MelonPhysObj:ApplyForceCenter(Aim * ( self.Ref.speed_forward ))
				MelonPhysObj:ApplyForceCenter(Aim * ( force ))
			--end
			--MelonPhysObj:SetVelocity(Aim * (self.Ref.speed_forward) - (Vector(0,0,1)*100) )
			--MelonPhysObj:SetVelocity( self:GetVelocity( ) + (Aim * (self.Ref.speed_forward)) )
			input_thisframe = true
		end
		
		if (Owner:KeyDown(IN_BACK)) then
			local Aim = Aim:Forward() * -1
			--if velo < max_velocity then
				MelonPhysObj:ApplyForceCenter( Aim * force )
			--end
			input_thisframe = true
		end
		
		if (Owner:KeyDown(IN_MOVELEFT)) then
			local Aim = Aim:Right() * -1
			--if velo < max_velocity then
				MelonPhysObj:ApplyForceCenter( Aim * force )
			--end
			input_thisframe = true
		end
		
		if (Owner:KeyDown(IN_MOVERIGHT)) then
			-- Get the right vector
			local Aim = Aim:Right()
			--if velo < max_velocity then
				MelonPhysObj:ApplyForceCenter( Aim * force )
			--end
			input_thisframe = true
		end
		
		--this puck can jump, make this into its own function in puck base later
		if (Owner:KeyDown(IN_JUMP)) then
			if (self.JumpTimer < CurTime()) then
				local Aim = Aim:Up()
				MelonPhysObj:ApplyForceCenter( Aim * self.Ref.speed_jump )
				self.JumpTimer = CurTime() + 2
				
				self:EmitSound( SOUND_JUMP )
			end
		end
	end
	if self.EnabledInput != false then
		Movement()
	end
	
	--[[
	--Decay velocity to lessen momentum if theres no input being held
	if input_thisframe == false then
		if speed >= 1 then
			MelonPhysObj:ApplyForceCenter( -Vector(velo.x,velo.y,0)*7 )
		end
	end
	]]--
	
	if input_thisframe == false then
		if speed >= self.Ref.speed_max + 100 then
			local normalized_velo = veloxy:GetNormal()
			MelonPhysObj:ApplyForceCenter( normalized_velo * force )
		else
			MelonPhysObj:ApplyForceCenter( -Vector(velo.x,velo.y,0)*7 )
		end
	end
	
	--prevent it from going over the max speed, also scale up this speed over time since this class builds momentum
	if speed > self.SpeedMaxMod then
		local normalized_velo = veloxy:GetNormal()
		local neg_vec = -(veloxy - (normalized_velo * 50))
		MelonPhysObj:ApplyForceCenter( neg_vec * 10 )
		
		if self.SpeedMaxMod < self.Ref.speed_max_upper then
			self.SpeedMaxMod = self.SpeedMaxMod + 3
		end
		
	elseif speed < (self.SpeedMaxMod - 35) then
		if (self.SpeedMaxMod - 100) > self.Ref.speed_max then
			self.SpeedMaxMod = (self.SpeedMaxMod - 100)
		else
			self.SpeedMaxMod = self.Ref.speed_max
		end
	end
	

	
		
	--boosts the puck forward for this frame
	if self.Boosting == true then
		//local aim = self.Owner:GetForward()
		//local phys = self:GetPhysicsObject()
		
		//phys:SetVelocity( Vector(aim.x,aim.y,0):GetNormalized() *  self.Ref.force_boost )
	end
	
	
	-- Call the think every frame
	self.Entity:NextThink(CurTime())
	return true
end


function ENT:BoostForward()
	local aim = self.Owner:GetForward()
	local phys = self:GetPhysicsObject()
		phys:SetVelocity( Vector(aim.x,aim.y,0):GetNormalized() *  3000 )

	self.Boosting = true
	timer.Simple( .25, function()
		if not IsValid(self) then return end
		self.Boosting = false
		
		local phys = self:GetPhysicsObject()
			phys:SetVelocity( Vector(0,0,0) )
	end)
end

-- ENT:PhysicsCollide - We hit stuff, do custom damage functions --
function ENT:PhysicsCollide(Data, PhysObj)
	-- Play sound, depending on speed
	if ((Data.DeltaTime >= 0.8) and (Data.Speed > 100)) or (Data.Speed > 250) then
		self.Entity:EmitSound("physics/flesh/flesh_squishy_impact_hard"..math.random(1, 4)..".wav", 100, 100)
	end
	
	--do force or fall damage
	--[[
	-- Get the max/min damage range
	local MinDamageRange = self.MinDamageRangeOverride or self.MinDamageRange
	local MaxDamageRange = self.MaxDamageRangeOverride or self.MaxDamageRange
	
	-- Hurt the melon`
	if (Data.Speed > MinDamageRange) and (not self.GodMode) then
		self:Hurt(Data.Speed / MaxDamageRange)
	end
	]]--
	
	

	if not (Data.HitEntity:IsWorld()) and Data.HitEntity:GetClass() != "func_brush" then

		--dont do anything if its friendly
		if CheckIfInEntTable( Data.HitEntity ) and Data.HitEntity.BBTeam == self.BBTeam then return end
		if Data.HitEntity:IsValidPuck() and Data.HitEntity.BBTeam == self.BBTeam then return end
	
		--dont do anything if its a projectile
		if CheckIfInEntTable( Data.HitEntity ) then 
			local entref = EntReference( Data.HitEntity:GetClass() )
			if entref.is_projectile == true then 
				return 
			end
		end
	
		self.Boosting = false
		//self.Entity:GetOwner():PrintMessage( HUD_PRINTTALK, "bumping into something")
		
		//timer.Simple(0, function()
		if not (IsValid(Data.HitEntity)) then return end
		//local phys = Data.HitEntity:GetPhysicsObject()

		local hitent = Data.HitEntity
		local vel = Data.OurOldVelocity
		//print(Vel)
		
		VisualExplosion(self:GetPos(), self.Owner, 125)
		
		--bug damage
		local damage = self.Ref.damage_hit * (vel:Length() * self.Ref.damage_mul_player )
		
		--building damage override
		if CheckIfInEntTable( hitent ) then
			damage = self.Ref.damage_hit * (vel:Length() * self.Ref.damage_mul_structure)
		end
		
		--hurt the ent we hit
		self.Owner:PrintMessage( HUD_PRINTCENTER, damage )
		hitent:HurtEnt( damage, self, self.Owner )
		
		
		local self_phys = self.Entity:GetPhysicsObject()
		local hitent_phys = Data.HitEntity:GetPhysicsObject()
		local vel_norm = Data.OurOldVelocity:GetNormalized()
		hitent_phys:SetVelocity((vel_norm * 1000) )
		self_phys:SetVelocity(-(vel_norm * 1000) )
		//HitEnt:ApplyForceCenter((vel_norm * 1000))
		//SelfPhys:ApplyForceCenter(-(vel_norm * 500000))
		//end);
	end
end


