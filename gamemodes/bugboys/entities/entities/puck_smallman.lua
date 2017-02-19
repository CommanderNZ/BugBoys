AddCSLuaFile("puck_smallman.lua")

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
	self.NoiseTimer = 0
	self.FlipTimer = 0
	
	
	self.CheckDir = 1
	self.Upsidedown_Frames = 0
end





if !SERVER then return end
------------------------------------------------------------------------------------------------
--all server from now on
------------------------------------------------------------------------------------------------




-- ENT:Think - Do our controls & powerups here --
function ENT:Think()
	if not IsValid(self.Owner) then 
		self:Remove()
		return 
	end

	if self.EnabledInput != false then
		--ability functions
		
		--cant grab while attached to boat or blimp, jump is disabled when yourte attached, so this is a hacky way to do that
		//if self.JumpEnabled != false then
			self:DoGrab()
		//end
		
		//self:DoCraft()
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
	//---------------------------------------------------------------Owner:PrintMessage( HUD_PRINTCENTER, tostring(speed) )
	
	-- We need to update the player position at the melon or bad thing happens D:
	Owner:SetPos(self.Entity:GetPos())
	
	
	self.CurrentPos = self:GetPos()
	
	--Check if going up kill, amplify the force of the inputs if we are going up hill, dependent on how steep it is
	--[[
	if self.PreviousPos != nil then
		if (self.CurrentPos.z - self.PreviousPos.z) > .1 then
			print( self.CurrentPos.z .. "  >  " .. self.PreviousPos.z)
		end
	end
	]]--
	
	
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
			if (self.JumpTimer < CurTime()) and self.JumpEnabled != false then
				local Aim = Aim:Up()
				MelonPhysObj:ApplyForceCenter( Aim * self.Ref.speed_jump )
				self.JumpTimer = CurTime() + self.Ref.jump_cooldown
				
				self:EmitSound( SOUND_JUMP )
			end
		end
		
		
		--this bug can make noises when you press control, little easter egg fun thing
		if (Owner:KeyDown(IN_WALK)) then
			if (self.NoiseTimer < CurTime()) and self.JumpEnabled != false then
				
				local enemysqueal = false
				local orgin_ents = ents.FindInSphere( self:GetPos(), 1200 )
				for k, ent in pairs( orgin_ents ) do
					if ent:IsValidPlyBug() and ent.BBTeam == GetOppositeTeam( self.BBTeam ) then
						enemysqueal = true
					end
				end
				
				
				if enemysqueal == false then
					//self.Entity:EmitSound( "npc/headcrab_poison/ph_idle"..math.random(1, 3)..".wav", 100, 100)
					self.Entity:EmitSound( "npc/headcrab_poison/ph_talk"..math.random(1, 3)..".wav", 85, 130)
					self.NoiseTimer = CurTime() + self.Ref.noise_cooldown
				else
					self.Entity:EmitSound( "npc/headcrab_poison/ph_scream"..math.random(1, 3)..".wav", 85, 130)
					self.NoiseTimer = CurTime() + self.Ref.noise_cooldown_scream
				end	
				
			end
		end
	end
	if self.EnabledInput != false then
		Movement()
	end
	
	--Decay velocity to lessen momentum if theres no input being held
	if input_thisframe == false then
		if speed >= 1 then
			MelonPhysObj:ApplyForceCenter( -Vector(velo.x,velo.y,0)*7 )
		end
	end
	
	
	--add negative vector to prevent the puck from exceeding the maximum speed which is 300
	if speed > self.Ref.speed_max then
		local normalized_velo = veloxy:GetNormal()
		local neg_vec = -(veloxy - (normalized_velo * 50))

		MelonPhysObj:ApplyForceCenter( neg_vec * 10 )
	end
	
	
	
	//local speed = self:GetVelocity( ):Length()
	//Owner:PrintMessage( HUD_PRINTCENTER, tostring(speed) )

	
	
	
	--code that makes the tank's open spot coordinates flip upside down, these are used for placing attached bugs
	--[[
	local angle = self:GetAngles()
	local upsidedown = false
	
	if self.CheckDir >= 1 then
		if angle.z < 0 then
			upsidedown = true
		end
	elseif self.CheckDir < 1 then
		if angle.z > 0 then
			upsidedown = true
		end
	end
	
	if upsidedown == true then
		self.Upsidedown_Frames = self.Upsidedown_Frames + 1
		
		if self.Upsidedown_Frames >= 50 then
			//self:FlipPosTable()
			if self.CurGrabbedEnt != nil and IsValid( self.CurGrabbedEnt ) then
				print("flipping")
				self:SetAngles( -self:GetAngles() )
				self.CheckDir = -self.CheckDir
			end
		end
	else
		self.Upsidedown_Frames = 0
	end
	]]--
	
	--see if the ent is lower than self, if so, flip it over
	if (self.FlipTimer < CurTime()) and self.CurGrabbedEnt != nil and IsValid( self.CurGrabbedEnt ) and self:GetIfOnGround( 50, self ) then
		local entpos =  self.CurGrabbedEnt:GetPos()
		local selfpos = self:GetPos()
		
		if entpos.z < selfpos.z and (selfpos.z - entpos.z) > 20 then
			self:SetAngles( -self:GetAngles() )
			
			self.FlipTimer = CurTime() + 1
		end
		
	end
	
	
	
	
	-- Call the think every frame
	self.Entity:NextThink(CurTime())
	return true
end





--for when the player grabs something, it appears on top of them as a tiny box
function ENT:DisplayBox( ent )
	local box = ents.Create( "ent_displaybox" )
		box:SetPos( self:GetPos() + Vector(0,0,25) )
		box:SetAngles( self:GetAngles() )
		box:SetParent( self )
		box:SetModel( "models/bugboys/box01_tiny.mdl" )
		box:SetSkin( ent:GetSkin() )
		//ent:Transparency_Set( 130 ) --120
		box:Spawn()
	
	
	self.Box = box
end

function ENT:RemoveBox()
	if IsValid( self.DisplayBox ) then
		self.Box:Remove()
	end
end




--[[
-- ENT:Hurt - A simple function that handles the damage --
function ENT:Hurt(Dmg)
	-- Set HP
	self.HP = self.HP - Dmg
	
	-- Set it on the client
	umsg.Start("sent_melon RecieveHP", self:GetOwner())
		umsg.Entity(self:GetOwner())
		umsg.Float(self.HP)
	umsg.End()
	
	-- We're dead - break it
	if (self.HP <= 0) then
		self:Break()
	end
end
]]--


