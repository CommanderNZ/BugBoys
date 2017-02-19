AddCSLuaFile("puck_climber.lua")

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
	self.WallGrabTimer = 0
end





if !SERVER then return end
------------------------------------------------------------------------------------------------
--all server from now on
------------------------------------------------------------------------------------------------




-- ENT:Think - Do our controls & powerups here --
function ENT:Think()
	if self.EnabledInput != false then
		--ability functions
		//self:DoGrab()
		self:DoWallGrab()
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
			if (self.JumpTimer < CurTime()) and self.WallAttached == true then
				--stop being attached to the wall before jumping
				
				self.WallAttached = false
				
				//constraint.RemoveConstraints( self, "Weld" )
				local phys = self:GetPhysicsObject()
					phys:EnableMotion( true )
					phys:Wake()
				
				local Aim = Aim:Up()
				timer.Simple(0, function()
					MelonPhysObj:ApplyForceCenter( Aim * self.Ref.speed_jump )
					//MelonPhysObj:SetVelocity( Aim * self.Ref.speed_jump )
					self.JumpTimer = CurTime() + self.Ref.jump_cooldown
					
					self:EmitSound( SOUND_JUMP )
				end)
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
	
	--Previous position stuff
	self.PreviousPos = self:GetPos()
	
	
	
	
	-- Call the think every frame
	self.Entity:NextThink(CurTime())
	return true
end





--function which controls the weld self ability, this fuses to to a friend
function ENT:DoWallGrab()
	//if true then return end

	local function WeldToWorld()
		self.WallAttached = true
		
		--cancels an ongoing jumpslam
		self.SlamGround = false
		
		local phys = self:GetPhysicsObject()
			phys:EnableMotion( false )
			phys:Wake()
		
		--[[
		local Ent1 = self
		local Ent2 = game.GetWorld( ) --world
		local Bone1 = 0
		local Bone2 = 0
		local constraint, weld = constraint.Weld( Ent1, Ent2, Bone1, Bone2, 0, false )	
		]]--
	end
	
	local function CheckTraces()
	
		local function DoTraceTo(vec)
			local vecn = vec:GetNormal()
			local pos = self:GetPos()
			local tracedata = {}
			tracedata.start = pos
			tracedata.endpos = pos + (Vector(vecn.x, vecn.y, vecn.z) * self.Ref.radius_weld)
			tracedata.filter = self, self.Owner
			
			local trace = util.TraceLine(tracedata)
			
			--if it didnt hit anything, we have nothing to do
			local hit = trace.Hit
			if not hit then
				return false
			end
			
			--cannot attach to sky
			local hitsky = trace.HitSky
			if hitsky then
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
	
		local vec_list = 
		{
		Vector(1,0,0),
		Vector(-1,0,0),
		Vector(0,1,0),
		Vector(0,-1,0),
		
		Vector(1,1,0),
		Vector(-1,-1,0),
		Vector(1,-1,0),
		Vector(-1,1,0),
		}
	
		for _,vec in pairs(vec_list) do
			local tracer = DoTraceTo( vec )
			if tracer then
				WeldToWorld()
				return
			end
		end
	end

	
	if (self.Owner:KeyDown(IN_USE)) then
		if (self.WallGrabTimer < CurTime()) then
		
			
			if self.WallAttached == true then
			
				--
				--override normal stuff if grabbing tank currently
				if self.CurGrabbedEnt != nil and IsValid(self.CurGrabbedEnt) and self.CurGrabbedEnt:GetClass() == "puck_tank" then
					self:UnGrab_FromTank()
					
					self.WallGrabTimer = CurTime() + .5
					return
				end
				--
				
				
				local phys = self:GetPhysicsObject()
					phys:EnableMotion( true )
					
				self.WallAttached = false
				self.WallGrabTimer = CurTime() + .5
			else
				--
				--attempt grabbing onto tank, if near one, override the normal wall grab
				local orgin_ents = ents.FindInSphere( self:GetPos(), self.Ref.radius_weld )
				for k, ent in pairs( orgin_ents ) do
					--attach to the tank
					if ent:GetClass() == "puck_tank" and ent.BBTeam != enemyteam then
						if ent:AttachPuck( self ) == true then
							self.CurGrabbedEnt = ent
							self.Grabbing = true
							
							self.WallGrabTimer = CurTime() + .5
							return
						end
					end
				end
				--
			
				self:EmitSound( SOUND_FUSE )
				CheckTraces()
				self.WallGrabTimer = CurTime() + .5
			end
		end
	end
end





-- ENT:PhysicsCollide - We hit stuff, do custom damage functions --
function ENT:PhysicsCollide(Data, PhysObj)
	-- Play sound, depending on speed
	if ((Data.DeltaTime >= 0.8) and (Data.Speed > 100)) or (Data.Speed > 250) then
		self.Entity:EmitSound("physics/flesh/flesh_squishy_impact_hard"..math.random(1, 4)..".wav", 100, 100)
	end
	

	if self.SlamGround == true then
		local normalz = Data.HitNormal[3]
		if normalz < 0 then
			local speed = Data.Speed
			local dmg = 35
			
			if speed > 600 then
				dmg = speed * self.Ref.dropslam_damage
			end
			
			if speed > 800 then
				dmg = speed * self.Ref.dropslam_damage_high
			end
			self.Owner:BBChatPrint( dmg )
			
			--this explosion is just visual
			local explosion = ents.Create( "env_explosion" )
				explosion:SetPos( self:GetPos() )
				explosion:SetOwner( self.Owner )
				explosion:Spawn()
				explosion:SetKeyValue("spawnflags","81")
				explosion:Fire( "Explode", 0, 0 )
			
			
			--deal flat damage to an ent in the radius
			local function HurtEnt( ent )
				local dmginfo = DamageInfo()
					dmginfo:SetDamage( dmg )
					dmginfo:SetInflictor( self )
					dmginfo:SetAttacker( self.Owner )
				ent:TakeDamageInfo( dmginfo )
			end
			
			local orgin_ents = ents.FindInSphere( self:GetPos(), self.Ref.dropslam_radius )
			
			--hurt players and ents in the radius, except the directly hit one, we already hurt that one
			local hit = false
			for k, ent in pairs( orgin_ents ) do
				if ent:IsValidPuck() and ent.BBTeam == GetOppositeTeam( self.BBTeam ) then
					HurtEnt( ent )
				end
			end
			
			self:EmitSound( self.Ref.sound_dropslam )
				
			--bounce back up into the air
			local phys = self:GetPhysicsObject()
				phys:SetVelocity( Vector(0,0,1) * 400 )
				
			self.SlamGround = false
		end
	end
end
