AddCSLuaFile("structure_blimp.lua")

ENT.Type 			= "anim"
ENT.Base 			= "base_bbentity"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

if !SERVER then return end
------------------------------------------------------------------------------------------------
--all server from now on
------------------------------------------------------------------------------------------------
local angle = Angle( 0, 0, 0 )


function ENT:Initialize()
	self:SpecialInit()
	
	self:ChangePhysicsModel( self.Ref.model, COLLISION_GROUP_WEAPON, self.Ref.mass )
	
	self:SetIfCanGrab( false )
	
	self:Transparency_Set( 160 )
	
	-- Wake our physics
	local phys = self.Entity:GetPhysicsObject()
	
	--correct angles, tire on its side
	phys:SetAngles( Angle(0, 0, 90))
	
	--set to be slidy
	//phys:SetMaterial("gmod_ice")
	
	--blimp has no gravity
	phys:EnableGravity(false)
	
	if (phys:IsValid()) then
		phys:Wake()
	end
	
	
	//self.AttachedPucks = {}
	self.PosTable = 
	{
	Pos1 ={ name = "Pos1", vector = Vector(40,60,40), puckat = nil, boxat = nil, boxvector = Vector(40,85,40),},
	Pos2 ={ name = "Pos2", vector = Vector(-40,60,-40), puckat = nil, boxat = nil, boxvector = Vector(-40,85,-40),},
	Pos3 ={ name = "Pos3", vector = Vector(40,60,-40), puckat = nil, boxat = nil, boxvector = Vector(40,85,-40),},
	Pos4 ={ name = "Pos4", vector = Vector(-40,60,40), puckat = nil, boxat = nil, boxvector = Vector(-40,85,40),},
	}
	
	self.CheckDir = 1
	self.Upsidedown_Frames = 0
	
	self.ShootTimer = 0
	self.GoDownCheckTimer = 0
	self.GoDown = true
end


function ENT:Shoot()
	local obj = ents.Create( "subitem_missile_destroyer" )

		obj:SetPos( self:GetPos() )//+ Vector(0,0,100) )	
		obj.BBTeam = self.BBTeam
		if IsValid( self.Creator ) then
			obj.Creator = self.Creator
		end
		obj:SetOwner( self.Creator )
		obj:SetAngles( Angle(0,0,0) )
		obj:Spawn()
		
		obj:NoCollideTeam()
		obj:NoCollideEnt( self )
	
	local down = Vector( 0, 0, -1 )
		
	local phys = obj:GetPhysicsObject()
		phys:SetVelocity( down * 3000 )

	self:EmitSound( SOUND_STARWARS_GUN )
end



--triggers the bug to attach to the boat
function ENT:RayTrigger( activator )
	if !SERVER then return end

	--if the puck isnt yet attached
	if self:PuckTable_HasThis( activator.Puck ) != true then
		
		--make sure the puck is in range to attach to the boat
		if GetIfInRange( self:GetPos(), self.Ref.radius_attach, activator.Puck ) then
			self:AttachPuck( activator.Puck )
		else
			activator:ChatPrint( "You must stand closer to get on!")
			activator:PlayLocalSound( "Sound_Failed" )
		end
		
		--start the sound if its not already started
		if self.LoopingSound_A == nil then
			self.LoopingSound_A = CreateSound( self, self.Ref.sound_jet )
			self.LoopingSound_A:Play()
		end
	
	--if the puck is already attached
	else
		self:DetachPuck( activator.Puck )

		
	end
end


--make sure the attached players havent died or something
--if they have, remove them from the table
function ENT:MakeSurePucksAlive()
	if self:PuckTable_HasPucks() == true then
		for _, pos in pairs( self.PosTable ) do
			if pos.puckat != nil then
				if IsValid( pos.puckat ) != true then
					pos.puckat = nil
				end
			end
		end
	end
end


-- ENT:Think - Do our controls & powerups here --
function ENT:Think()
	local MelonPhysObj = self:GetPhysicsObject()

	
	local velo = self:GetVelocity( )
	local velonorm = self:GetVelocity( ):GetNormal()
	local veloxy = Vector(velo.x,velo.y,0)
	local veloxynorm = Vector(velo.x,velo.y,0):GetNormal()
	
	local input_thisframe = false
	

	
	self:MakeSurePucksAlive()
	
	
	local function MovementInput( ply )
		local Aim = ply:EyeAngles()
		
		-- Check which key is pressed and move accordingly
		if (ply:KeyDown(IN_FORWARD)) then
			local Aim = Aim:Forward():GetNormalized() 
				Aim = Vector(Aim.x,Aim.y,0)
			MelonPhysObj:ApplyForceCenter(Aim * self.Ref.force_add )

			input_thisframe = true
		end
		
		if (ply:KeyDown(IN_BACK)) then
			local Aim = Aim:Forward():GetNormalized() * -1
				Aim = Vector(Aim.x,Aim.y,0)
			MelonPhysObj:ApplyForceCenter( Aim * self.Ref.force_add )
			
			input_thisframe = true
		end
		
		if (ply:KeyDown(IN_MOVELEFT)) then
			local Aim = Aim:Right() * -1
			MelonPhysObj:ApplyForceCenter( Aim * self.Ref.force_add )
			
			input_thisframe = true
		end
		
		if (ply:KeyDown(IN_MOVERIGHT)) then
			local Aim = Aim:Right()
			MelonPhysObj:ApplyForceCenter( Aim * self.Ref.force_add )
			
			input_thisframe = true
		end
		
		
		if (ply:KeyDown(IN_JUMP)) then
			Aim = Vector(0,0,1)
			MelonPhysObj:ApplyForceCenter( Aim * self.Ref.force_add_vertical )
			
			input_thisframe = true
		end
		
		if (ply:KeyDown(IN_WALK)) then
			Aim = Vector(0,0,-1)
			MelonPhysObj:ApplyForceCenter( Aim * self.Ref.force_add_vertical )

			input_thisframe = true
		end
		
		--[[
		if (ply:KeyDown(IN_ATTACK)) then
			if self.ShootTimer != nil and CurTime() > self.ShootTimer then
				self:Shoot()
				self.ShootTimer = CurTime() + self.Ref.shoot_delay
			end
		end
		]]--
	end
	
	
	--calculate movement input for all bugs which are attached to the boat
	for _, pos in pairs( self.PosTable ) do
		if pos.puckat != nil then
			local ent = pos.puckat
			local ownerply = ent.Owner
			
			MovementInput( ownerply )
		end
	end
	
	
	
	
	
	
	local speed = self:GetVelocity( ):Length()
	
	--Decay velocity to lessen momentum if theres no input being held
	if input_thisframe == false then
		if speed >= 1 then
			if self:PuckTable_HasPucks() == true then
				//MelonPhysObj:ApplyForceCenter( -velonorm * 5 )
				MelonPhysObj:ApplyForceCenter( velonorm * 400  )
			else
				MelonPhysObj:ApplyForceCenter( -velonorm * 1000 )
			end
		end
	end
	
	

	
	
	
	--add negative vector to prevent the puck from exceeding the maximum speed which is 300
	local movespeed = self.Ref.speed_max
	
	if self:PuckTable_HasPucks() == true and speed > movespeed then
		//local normalized_velo = veloxy:GetNormal()
		//local neg_vec = -(veloxy - (normalized_velo))
		
		//local neg_vec = -veloxy
		local neg_vec = -velo
		
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
	
	
	
	--keep it upright
	//if self:PuckTable_HasPucks() == true then
	local phys = self.Entity:GetPhysicsObject()
		phys:AddAngleVelocity( -1 * phys:GetAngleVelocity( )) 
		//phys:SetAngles( Angle(0, 0, 0))
	//end
		
		
		
		
		
	--if no one is on the blimp, add force downward
	if self:PuckTable_HasPucks() != true then
		local Down = Vector(0,0,-1)
		MelonPhysObj:ApplyForceCenter( Down * 2000 )
		
		if self.LoopingSound_A != nil then
			self.LoopingSound_A:Stop()
			self.LoopingSound_A = nil
		end
	end	
		
		
	--if no one is on the blimp, add force downward, new version which freezes blimp mid air
	--[[
	if self:PuckTable_HasPucks() != true then
		MelonPhysObj:EnableMotion( false )	
		
		local function GoDownCheck()
			//print( "checking" )
			local orgin_ents = ents.FindInSphere( self:GetPos(), 400 )
			for k, ent in pairs( orgin_ents ) do
				if ent:IsValidPuck() and ent != self then
					//print(ent:GetClass())
					self.GoDown = false
					return
				end
			end
			self.GoDown = true
		end
		
		if CurTime() > self.GoDownCheckTimer then
			self.GoDownCheckTimer = CurTime() + 4
			GoDownCheck()
		end
		
		if self.GoDown == true then
			local Down = Vector(0,0,-1)
			MelonPhysObj:EnableMotion( true )
			MelonPhysObj:Wake()		
			MelonPhysObj:ApplyForceCenter( Down * 100000 )
			//MelonPhysObj:SetVelocity( Down * 30 )
		end
		
		--turn off the sound if no ones on it
		if self.LoopingSound_A != nil then
			self.LoopingSound_A:Stop()
			self.LoopingSound_A = nil
		end
		
	else
		MelonPhysObj:EnableMotion( true )	
	end
	]]--
	
	
	
	
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
		
		local oldboxvec = pos.boxvector
		local newboxvec = Vector( oldboxvec.x, -oldboxvec.y, oldboxvec.z )
		pos.boxvector = newboxvec
		
		if pos.puckat != nil then
			local puck = pos.puckat
			local phys = self:GetPhysicsObject()
			local vec = phys:LocalToWorld( newvec )
			
			puck:SetParent( nil )
			puck:SetPos( vec )
			puck:SetAngles( self:GetAngles() )
			
			puck:SetParent( self )
			
			--if the puck is holding a box, switch the boxes position
			if pos.boxat != nil then
				local box = pos.boxat
				local vecbox = phys:LocalToWorld( newboxvec )
				
				box:SetParent( nil )
				box:SetPos( vecbox )
				box:SetAngles( self:GetAngles() )
				
				box:SetParent( self )
			end
		end
	end
end





function ENT:AttachPuck( puck )
	--detach them from their current vehicle, if theyre already on one
	puck:DetachSelfFromVehicle()


	local function SetupPos( puck )
		local spot = nil
		local spot_box = nil
		for _, pos in pairs( self.PosTable ) do
			if pos.puckat == nil then
				pos.puckat = puck
				spot = pos.vector
				
				if IsValid( puck.CurGrabbedEnt ) then
					pos.boxat = puck.CurGrabbedEnt
					spot_box = pos.boxvector
				end
				
				break
			end
		end
		
		if spot == nil then
			return false
		end
	
		local phys = self:GetPhysicsObject()
		local vec = phys:LocalToWorld( spot )
		//local vec_attachments = phys:LocalToWorld( spot + Vector(0,25,0) )
		//local vec_box = phys:LocalToWorld( spot + Vector(0,25,0) )
		
		
		puck:SetJumpEnabled( false )
		//puck:SetShootingEnabled( false )
		
		
		--parent whatever is parented to the puck, to the blimp
		if IsValid( puck.CurGrabbedEnt ) then
			local vecbox = phys:LocalToWorld( spot_box )
			puck.CurGrabbedEnt:SetParent( nil )
			puck.CurGrabbedEnt:SetAngles( self:GetAngles() )
			puck.CurGrabbedEnt:SetPos( vecbox )
			puck.CurGrabbedEnt:SetParent( self )
		end
		
		
		puck:SetPos( vec )
		puck:SetAngles( self:GetAngles() )
		puck:SetParent( self )
		//puck:Transparency_Set( 70 )
		
		--make the attached puck immune to damage while attached
		puck.CurTakeDamage = false
		puck.Vehicle = self
	end
	
	
	
	if SetupPos( puck ) == false then
		return false
	else
		return true
	end
end





function ENT:DetachAllPucks()
	for _, pos in pairs( self.PosTable ) do
		if pos.puckat != nil then
			local ent = pos.puckat
			
			self:DetachPuck( ent )
		end
	end
end



function ENT:DetachPuck( puck )
	for _, pos in pairs( self.PosTable ) do
		if pos.puckat == puck then
			local ent = pos.puckat
		
			if IsValid( ent.CurGrabbedEnt ) then
				ent.CurGrabbedEnt:SetParent( ent )
			end
		
			ent:SetParent( nil )
			ent:SetPos( ent:GetPos() )
			
			ent:SetJumpEnabled( true )
			ent:SetShootingEnabled( true )
			

			local phys = ent:GetPhysicsObject()
				if IsValid( phys ) then
					phys:Wake()
				end
				//phys:SetVelocity( Vector(0,0,1) * 300 )
			
			ent.CurTakeDamage = true
			ent.Vehicle = nil
				
			pos.puckat = nil
			pos.boxat = nil
			return
		end
	end
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


--returns true if there is currently a puck attached
function ENT:PuckTable_HasPucks()
	for _, pos in pairs( self.PosTable ) do
		if pos.puckat != nil then
			return true
		end
	end
	return false
end


function ENT:OnRemove( )
	if !SERVER then return end

	if self.LoopingSound_A != nil then
		self.LoopingSound_A:Stop()
	end
	
	if self.LoopingSound_B != nil then
		self.LoopingSound_B:Stop()
	end
	
	if self:GetClass() == "structure_boat" or self:GetClass() == "structure_blimp" then
		self:DetachAllPucks()
	end
end

