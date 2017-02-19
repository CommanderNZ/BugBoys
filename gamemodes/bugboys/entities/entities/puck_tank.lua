AddCSLuaFile("puck_tank.lua")

ENT.Type 			= "anim"
ENT.Base 			= "base_puck"

if !SERVER then return end
------------------------------------------------------------------------------------------------
--all server from now on
------------------------------------------------------------------------------------------------



-- ENT:Initialize - Initialize stuff --
function ENT:Initialize()
	self:SpecialInit()
	
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
	
	--correct angles, tire on its side
	phys:SetAngles( Angle(0, 0, 90))
	
	--set to be slidy
	phys:SetMaterial("gmod_ice")
	
	--500
	phys:SetMass(500)
	
	if (phys:IsValid()) then
		phys:Wake()
	end
	
	
	self.AttachedPucks = {}
	
	
	self.PosTable = 
	{
	Pos1 ={ name = "Pos1", vector = Vector(40,30,40), puckat = nil,},
	Pos2 ={ name = "Pos2", vector = Vector(-40,30,-40), puckat = nil,},
	Pos3 ={ name = "Pos3", vector = Vector(40,30,-40), puckat = nil,},
	Pos4 ={ name = "Pos4", vector = Vector(-40,30,40), puckat = nil,},
	}
	
	self.CheckDir = 1
	self.Upsidedown_Frames = 0
end




-- ENT:Think - Do our controls & powerups here --
function ENT:Think()
	if self.EnabledInput != false then
		//self:DoTestGrab()
		self:DoGrab()
		self:DoCraft(true)
		//self:DoWeld()
		//self:DoTrigger()
		self:DoHealHurt()
	end

	local Owner = self:GetOwner()
	local MelonPhysObj = self:GetPhysicsObject()
	local Aim = Owner:EyeAngles()
	//Aim.r = 0
	//Aim.p = 0
	
	//local velo = self:GetVelocity( )
	//local veloxy = Vector(velo.x,velo.y,0)

	
	-- We need to update the player position at the puck
	Owner:SetPos(self.Entity:GetPos())
	self.CurrentPos = self:GetPos()
	
	
	
	local velo = self:GetVelocity( )
	local velonorm = self:GetVelocity( ):GetNormal()
	local veloxy = Vector(velo.x,velo.y,0)
	local veloxynorm = Vector(velo.x,velo.y,0):GetNormal()
	
	local input_thisframe = false
	
	--2000
	//self.Ref.force_add = 3500
	
	//local forwardvec = Aim:Forward()
	//local inertia = (veloxynorm - forwardvec) * 1000
	
	
	local force_add = self.Ref.force_add
	if self.Slowed == true then
		force_add = 0
	end
	
	
	local function Movement()
		//local inertia = self.Ref.inertia
		
		-- Check which key is pressed and move accordingly
		if (Owner:KeyDown(IN_FORWARD)) then
			local Aim = Aim:Forward()
			local Aimxy = Vector(Aim.x,Aim.y,0)
			local addforce = (Aimxy * force_add)
			//local inertia = (veloxynorm - Aimxy) * 1000
			
			//MelonPhysObj:ApplyForceCenter( addforce + inertia )
			MelonPhysObj:ApplyForceCenter( addforce )
			
			input_thisframe = true
		end
		
		if (Owner:KeyDown(IN_BACK)) then
			local Aim = Aim:Forward() * -1
				Aim = Vector(Aim.x,Aim.y,0)
			MelonPhysObj:ApplyForceCenter( Aim * force_add )
			
			input_thisframe = true
		end
		
		if (Owner:KeyDown(IN_MOVELEFT)) then
			local Aim = Aim:Right() * -1
			MelonPhysObj:ApplyForceCenter( Aim * force_add )

			input_thisframe = true
		end
		
		if (Owner:KeyDown(IN_MOVERIGHT)) then
			local Aim = Aim:Right()
			MelonPhysObj:ApplyForceCenter( Aim * force_add )
			
			input_thisframe = true
		end
		
		--[[
		if (Owner:KeyDown(IN_JUMP)) then
			local Aim = Aim:Up()
				Aim = Vector(0,0,Aim.z)
			MelonPhysObj:ApplyForceCenter( Aim * self.Ref.force_add )
			
			input_thisframe = true
		end
		]]--
	end
	
	if self.EnabledInput != false then
		Movement()
	end
	
	
	
	
	local speed = self:GetVelocity( ):Length()
	//---------------------------------------------------------------Owner:PrintMessage( HUD_PRINTCENTER, tostring(speed) )
	
	--Decay velocity to lessen momentum if theres no input being held
	if input_thisframe == false then
		if speed >= 1 then
			MelonPhysObj:ApplyForceCenter( -velonorm * 1000 )
		end
	end
	
	
	--add negative vector to prevent the puck from exceeding the maximum speed which is 300
	local movespeed = self.Ref.speed_max
	
	if self.Slowed == true then
		movespeed = self.Ref.slowed_speed
	end
	
	if speed > movespeed then
		//local normalized_velo = veloxy:GetNormal()
		//local neg_vec = -(veloxy - (normalized_velo))
		local neg_vec = -veloxy
		
		MelonPhysObj:ApplyForceCenter( neg_vec * 50 )
	end
	
	

	
	--code that makes the tank's open spot coordinates flip upside down, these are used for placing attached bugs
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
		
		if self.Upsidedown_Frames >= 25 then
			self:FlipPosTable()
			self.CheckDir = -self.CheckDir
		end
	else
		self.Upsidedown_Frames = 0
	end
	

	
	-- Call the think every frame
	self.Entity:NextThink(CurTime())
	return true
end


--turns the slow on or off
function ENT:TankSlow( x )
	self.Slowed = x
end


function ENT:FlipPosTable()
	for _, pos in pairs( self.PosTable ) do
		local oldvec = pos.vector
		local newvec = Vector( oldvec.x, -oldvec.y, oldvec.z )
		pos.vector = newvec
		
		if pos.puckat != nil then
			local puck = pos.puckat
			local phys = self:GetPhysicsObject()
			local vec = phys:LocalToWorld( newvec )
			
			puck:SetParent( nil )
			puck:SetPos( vec )
			puck:SetAngles( self:GetAngles() )
			
			puck:SetParent( self )
		end
	end
end





function ENT:AttachPuck( puck )

	local function SetupPos( puck )
		local spot = nil
		for _, pos in pairs( self.PosTable ) do
			if pos.puckat == nil then
				pos.puckat = puck
				spot = pos.vector
				break
			end
		end
		
		if spot == nil then
			return false
		end
	
		local phys = self:GetPhysicsObject()
		local vec = phys:LocalToWorld( spot )
	
		puck:SetPos( vec )
		puck:SetAngles( self:GetAngles() )
		puck:SetParent( self )
		//puck:Transparency_Set( 70 )
		
		--make the attached puck immune to damage while attached
		puck.CurTakeDamage = false
	end
	
	
	local angle = self:GetAngles()
	local upsidedown = false
	if angle.z > 0 then
		upsidedown = true
	end
	
	local updown = -40
	if upsidedown == true then
		updown = 40
	end
	
	
	
	if SetupPos( puck ) == false then
		return false
	else
		return true
	end

	
	
	
	--[[
	if table.Count( self.AttachedPucks ) <= 0 then	
		SetupPos( Vector(40,updown,40) )
	elseif table.Count( self.AttachedPucks ) <= 1 then
		SetupPos(  Vector(-40,updown,-40) )
	elseif table.Count( self.AttachedPucks ) <= 2 then
		SetupPos(  Vector(40,updown,-40) )
	elseif table.Count( self.AttachedPucks ) <= 3 then
		SetupPos(  Vector(-40,updown,40) )
	else
		return false
	end
	
	
	
	
	
	if table.Count( self.AttachedPucks ) <= 0 then
		SetupPos( Vector(-40,-40,20) )
	elseif table.Count( self.AttachedPucks ) <= 1 then
		SetupPos( Vector(40,40,20) )
	elseif table.Count( self.AttachedPucks ) <= 2 then
		SetupPos( Vector(-40,40,20) )
	elseif table.Count( self.AttachedPucks ) <= 3 then
		SetupPos( Vector(40,-40,20) )
	else
		return false
	end
	
	]]--
	
	//table.insert( self.AttachedPucks, puck )
end



function ENT:DetachAllPucks()
	for _, pos in pairs( self.PosTable ) do
		if pos.puckat != nil then
			local ent = pos.puckat
			
			ent:SetParent( nil )
			ent:SetPos( ent:GetPos() )
			//ent:Transparency_Set( 255 )
			local phys = ent:GetPhysicsObject()
				phys:Wake()
				
			ent.CurTakeDamage = true
				
			pos.puckat = nil
		end
	end
end



function ENT:DetachPuck( puck )
	--future way of working
	--
	for _, pos in pairs( self.PosTable ) do
		if pos.puckat == puck then
			local ent = pos.puckat
		
			ent:SetParent( nil )
			ent:SetPos( ent:GetPos() )
			//ent:Transparency_Set( 255 )
			local phys = ent:GetPhysicsObject()
				phys:Wake()
				phys:SetVelocity( Vector(0,0,1) * 300 )
			
			ent.CurTakeDamage = true
				
			pos.puckat = nil
			return
		end
	end
	--
	
	--past final version
	--[[
	for _, pos in pairs( self.PosTable ) do
		if pos.puckat != nil then
			local ent = pos.puckat
			
			ent:SetParent( nil )
			ent:SetPos( ent:GetPos() )
			//ent:Transparency_Set( 255 )
			local phys = ent:GetPhysicsObject()
				phys:Wake()
				
			pos.puckat = nil
			return
		end
	end
	]]--
	
	
	--past
	--[[
	for _, ent in pairs( self.AttachedPucks ) do
		ent:SetParent( nil )
		ent:SetPos( ent:GetPos() )
		
		local phys = ent:GetPhysicsObject()
			phys:Wake()
			
		//ent:Transparency_Set( 255 )
		
		table.RemoveByValue( self.AttachedPucks, ent )
		return
	end
	]]--
end


--returns true if the table has this puck already
function ENT:PuckTable_HasThis( puck )
	for _, pos in pairs( self.PosTable ) do
		if pos.puckat == puck then
			return true
		end
	end
	return false
end