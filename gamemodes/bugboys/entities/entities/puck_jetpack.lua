AddCSLuaFile("puck_jetpack.lua")

ENT.Type 			= "anim"
ENT.Base 			= "base_puck"
//ENT.RenderGroup = RENDERGROUP_TRANSLUCENT




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
	

	--blimp has no gravity
	//phys:EnableGravity(false)
	
	--keepupright test
	//constraint.Keepupright( self, phys:GetAngles(), 0, 999999 )
	
	--set to be slidy
	phys:SetMaterial("gmod_ice")
	
	--2000
	--4000
	phys:SetMass(self.Ref.mass)
	
	
	if (phys:IsValid()) then
		phys:Wake()
	end
	
	self.JetpackOnTime = 0
	self.Jetpack_LowForce = false
	self.Jetpack_Started = false
	self.Jetpack_TargetSpeed = self.Ref.jetpack_multiplier1
	
	self.Jetpack_Disabled = false
	self.Jetpack_IsOn = false
end



if !SERVER then return end
------------------------------------------------------------------------------------------------
--all server from now on
------------------------------------------------------------------------------------------------






-- ENT:Think - Do our controls & powerups here --
function ENT:Think()
	if self.EnabledInput != false then
		self:DoGrab()
		//self:DoRope()
		self:DoCraft(true)
		//self:DoWeld()
		self:DoHealHurt()
	end
		
	local Owner = self:GetOwner()
	local MelonPhysObj = self:GetPhysicsObject()
	local Aim = Owner:EyeAngles()
	//Aim.r = 0
	//Aim.p = 0
	
	//local velo = self:GetVelocity( )
	//local veloxy = Vector(velo.x,velo.y,0)
	//local speed = Vector(velo.x,velo.y,0):Length()
	//Owner:PrintMessage( HUD_PRINTCENTER, tostring(speed) )
	
	
	-- We need to update the player position at the puck
	Owner:SetPos(self.Entity:GetPos())
	self.CurrentPos = self:GetPos()
	
	
	
	local input_thisframe = false
	local flying_input = false
	
	--2000
	
	local function Movement()
		-- Check which key is pressed and move accordingly
		if (Owner:KeyDown(IN_FORWARD)) then
			local Aim = Aim:Forward()
				Aim = Vector(Aim.x,Aim.y,0)
			MelonPhysObj:ApplyForceCenter(Aim * self.Ref.force_add )

			input_thisframe = true
		end
		
		if (Owner:KeyDown(IN_BACK)) then
			local Aim = Aim:Forward() * -1
				Aim = Vector(Aim.x,Aim.y,0)
			MelonPhysObj:ApplyForceCenter( Aim * self.Ref.force_add )
			
			input_thisframe = true
		end
		
		if (Owner:KeyDown(IN_MOVELEFT)) then
			local Aim = Aim:Right() * -1
			MelonPhysObj:ApplyForceCenter( Aim * self.Ref.force_add )
			
			input_thisframe = true
		end
		
		if (Owner:KeyDown(IN_MOVERIGHT)) then
			local Aim = Aim:Right()
			MelonPhysObj:ApplyForceCenter( Aim * self.Ref.force_add )
			
			input_thisframe = true
		end
	end
	
	if self.EnabledInput != false then
		Movement()
	end
	
	
	
	
	local speed = self:GetVelocity( ):Length()
	//Owner:PrintMessage( HUD_PRINTCENTER, tostring(speed) )
	
	local velo = self:GetVelocity( )
	local velonorm = self:GetVelocity( ):GetNormal()
	local veloxy = Vector(velo.x,velo.y,0)
	local veloxynorm = Vector(velo.x,velo.y,0):GetNormal()
	
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
	
	
	
	
	
	local vel = self:GetVelocity( )
	local veloz = Vector(0,0,vel.z)
	local vert_speed = veloz:Length()
	if veloz.z < 0 then
		vert_speed = -vert_speed
	end
	local max_speed_vert = 130
	
	
	--jetpack flying ability
	if (Owner:KeyDown(IN_JUMP)) then
		if self.Jetpack_Disabled != true then
	
			local Up = Vector(0,0,1)
			local force = self.Ref.force_add_vertical
			
			if self.Jetpack_LowerForce == true then 
				force = 1900
			end
			if self.Jetpack_LowestForce == true then 
				force = 1700
			end
			
			
			force = (self.Jetpack_TargetSpeed - vert_speed) * 16
			MelonPhysObj:ApplyForceCenter( Up * force )
			
			//Owner:PrintMessage( HUD_PRINTCENTER, force )
			//Owner:PrintMessage( HUD_PRINTCENTER, tostring(vert_speed) )
			//Owner:PrintMessage( HUD_PRINTCENTER, self.JetpackOnTime )
			
			flying_input = true
			self.Jetpack_Started = true
		end
	end
	
	//Owner:PrintMessage( HUD_PRINTCENTER, tostring(self.Jetpack_IsOn) )
	
	if flying_input and self.Jetpack_IsOn != true then
		self.Jetpack_IsOn = true
		
		--start the looping jet sound
		self.JetSound = CreateSound( self, self.Ref.sound_jet )
		self.JetSound:Play()
		
	elseif flying_input != true and self.Jetpack_IsOn then
		self.Jetpack_IsOn = false
		
		--end the sound of the jet
		self.JetSound:Stop()
	end
	
	
	if  self.JetpackOnTime == self.Ref.jetpack_frame_phase1 then
		self.Jetpack_TargetSpeed = self.Ref.jetpack_multiplier2
		self.JetSound:ChangePitch( 80, .1 )
		//self:EmitSound( SOUND_FUSE )
	end
	
	if  self.JetpackOnTime == self.Ref.jetpack_frame_phase2 then
		self.Jetpack_TargetSpeed = self.Ref.jetpack_multiplier3
		self.JetSound:ChangePitch( 50, .1 )
		//self:EmitSound( SOUND_FUSE )
	end
	
	--[[
	Owner:PrintMessage( HUD_PRINTCENTER, tostring(vert_speed) )
	//Owner:PrintMessage( HUD_PRINTCENTER, self.JetpackOnTime )
	if vert_speed > max_speed_vert and veloz.z > 0 and flying_input == true then
		local neg_vec = -veloz
		MelonPhysObj:ApplyForceCenter( neg_vec * 70 )
		
		//self.JetpackOnTime = self.JetpackOnTime + 1
	end
	]]--
	
	
	local phys = self.Entity:GetPhysicsObject()
		phys:AddAngleVelocity( -1 * phys:GetAngleVelocity( )) 

	

	local function GroundCheck(vec)
		local pos = self:GetPos()
		local tracedata = {}
		tracedata.start = pos
		tracedata.endpos = pos + (Vector(0, 0, -1) * 50)
		tracedata.filter = self, self.Owner
		
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
	
	

	if GroundCheck() then
		if self.JetpackOnTime > 40 then
			self.Jetpack_Disabled = true
			timer.Simple( self.Ref.jetpack_cooldown, function()
				if not IsValid(self) then return end
				self.Jetpack_Disabled = false
			end)
		end
		
		self.Jetpack_Started = false
		self.JetpackOnTime = 0
		self.Jetpack_LowerForce = false
		self.Jetpack_LowestForce = false
		self.Jetpack_TargetSpeed = self.Ref.jetpack_multiplier1

	elseif GroundCheck() != true and self.Jetpack_Started == true then
		self.JetpackOnTime = self.JetpackOnTime + 1
	end
	
	
	
	-- Call the think every frame
	self.Entity:NextThink(CurTime())
	return true
end




--[[

--duplicated from base_puck, make sure to reduplicate it if you ever modify the base one
--this just adds a stop sound for the jetpack
function ENT:OnRemove( )
	self:RemoveOwnerConnection()
	
	if self.RecallSound != nil then
		self.RecallSound:Stop()
	end
	
	if self.JetSound != nil then
		self.JetSound:Stop()
	end
end
]]--