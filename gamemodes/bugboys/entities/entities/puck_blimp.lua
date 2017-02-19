AddCSLuaFile("puck_blimp.lua")

ENT.Type 			= "anim"
ENT.Base 			= "base_puck"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT




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
	phys:EnableGravity(false)
	
	--keepupright test
	//constraint.Keepupright( self, phys:GetAngles(), 0, 999999 )
	
	--set to be slidy
	--phys:SetMaterial("gmod_ice")
	
	--2000
	--4000
	phys:SetMass(self.Ref.mass)
	
	
	if (phys:IsValid()) then
		phys:Wake()
	end
end



if !SERVER then return end
------------------------------------------------------------------------------------------------
--all server from now on
------------------------------------------------------------------------------------------------






-- ENT:Think - Do our controls & powerups here --
function ENT:Think()
	if self.EnabledInput != false then
		self:DoRope()
		self:DoCraft(true)
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
		
		
		if (Owner:KeyDown(IN_JUMP)) then
			local Aim = Aim:Up()
				Aim = Vector(0,0,Aim.z)
			MelonPhysObj:ApplyForceCenter( Aim * self.Ref.force_add_vertical )
			
			input_thisframe = true
		end
		
		if (Owner:KeyDown(IN_DUCK)) then
			local Aim = -Aim:Up()
				Aim = Vector(0,0,Aim.z)
			MelonPhysObj:ApplyForceCenter( Aim * self.Ref.force_add_vertical )

			input_thisframe = true
		end
	end
	if self.EnabledInput != false then
		Movement()
	end
	
	
	local speed = self:GetVelocity( ):Length()
	//---------------------------------------------------------------Owner:PrintMessage( HUD_PRINTCENTER, tostring(speed) )
	
	local velo = self:GetVelocity( )
	local velonorm = self:GetVelocity( ):GetNormal()
	local veloxy = Vector(velo.x,velo.y,0)
	local veloxynorm = Vector(velo.x,velo.y,0):GetNormal()
	
	--Decay velocity to lessen momentum if theres no input being held
	if input_thisframe == false then
		if speed >= 1 then
			MelonPhysObj:ApplyForceCenter( -velonorm * 10 )
		end
	end
	
	
	--add negative vector to prevent the puck from exceeding the maximum speed which is 300
	//self.Ref.speed_max = 200
	if speed > self.Ref.speed_max then
		//local normalized_velo = veloxy:GetNormal()
		//local neg_vec = -(veloxy - (normalized_velo))
		local neg_vec = -veloxy
		
		MelonPhysObj:ApplyForceCenter( neg_vec * 50 )
	end
	
	
	local phys = self.Entity:GetPhysicsObject()
		phys:AddAngleVelocity( -1 * phys:GetAngleVelocity( )) 


	
	-- Call the think every frame
	self.Entity:NextThink(CurTime())
	return true
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


