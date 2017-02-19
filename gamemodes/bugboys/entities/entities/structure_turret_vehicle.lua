AddCSLuaFile("structure_turret_vehicle.lua")

ENT.Type 			= "anim"
ENT.Base 			= "base_bbentity"
//ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

if !SERVER then return end
------------------------------------------------------------------------------------------------
--all server from now on
------------------------------------------------------------------------------------------------
local angle = Angle( 0, 0, 0 )


function ENT:Initialize()
	self:SpecialInit()
	
	self:ChangeStaticModel( self.Ref.model, COLLISION_GROUP_WEAPON )
	
	self:SetIfCanGrab( false )
	
	-- Wake our physics
	local phys = self.Entity:GetPhysicsObject()
	
	--correct angles, tire on its side
	//phys:SetAngles( Angle(0, 0, 90))
	
	--set to be slidy
	//phys:SetMaterial("gmod_ice")
	
	--blimp has no gravity
	//phys:EnableGravity(false)
	
	if (phys:IsValid()) then
		phys:Wake()
	end
	
	
	//self.AttachedPucks = {}
	self.PosTable = 
	{
	Pos1 ={ name = "Pos1", vector = Vector(0,0,55), puckat = nil, boxat = nil, boxvector = Vector(0,0,80),},
	}
end




function ENT:Shoot( aim, pos )
	local obj = ents.Create( "subitem_missile_turret" )

		obj:SetPos( pos )	
		obj.BBTeam = self.BBTeam
		if IsValid( self.Creator ) then
			obj.Creator = self.Creator
			obj:SetOwner( self.Creator )
		end
		obj:SetAngles( Angle(0,0,0) )
		obj:Spawn()
		
		obj:NoCollideTeam()
		obj:NoCollideEnt( self )
	
		--cant shoot that high
		--[[
		if aim.z > .3 then
			aim = Vector(aim.x,aim.y,.3)
			//newaim = Vector(aim.x,aim.y,aim.z)
		end
		]]--
		local multiplier = (1-aim.z) * 4000
		if multiplier > 1700 then
			multiplier = 1700
		end
		if multiplier < 700 then
			multiplier = 700
		end
		
		
		//local realang = Vector( finalang.x, finalang.y, multiply.z )
		
		local phys = obj:GetPhysicsObject()
			//phys:SetVelocity(aim * 2000 )
			phys:SetVelocity(aim * multiplier )
	
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
			activator:ChatPrint( "You must stand closer!")
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
	
	
	
	self:MakeSurePucksAlive()
	
	
	local function MovementInput( ply )
		local Aim = ply:EyeAngles()
		
		if (ply:KeyDown(IN_JUMP)) then
		end
		
		
		if (ply:KeyDown(IN_ATTACK)) then
			if self.ShootTimer != nil and CurTime() > self.ShootTimer then
				local aim = ply:GetAimVector():GetNormalized() 
				local pos = ply.Puck:GetPos() + Vector(0,0,60)
				self:Shoot( aim, pos )
				self.ShootTimer = CurTime() + self.Ref.shoot_delay
			end
		end
		
		if (ply:KeyDown(IN_WALK)) then
			--need to wait a moment before checking if the player wants to get off
			if self.DetachDetectTimer != nil and CurTime() > self.DetachDetectTimer then
				self:DetachAllPucks()
			end
		end
	end
	
	
	--calculate movement input for all bugs which are attached to the boat
	for _, pos in pairs( self.PosTable ) do
		if pos.puckat != nil then
			local ent = pos.puckat
			local ownerply = ent.Owner
			
			MovementInput( ownerply )
		end
	end
	
	
	
	--keep it upright
	if turning == false then
		local phys = self:GetPhysicsObject()
			phys:AddAngleVelocity( -.02 * phys:GetAngleVelocity( )) 
	end
	

	
	if self:PuckTable_HasPucks() != true then
		if self.LoopingSound_A != nil then
			self.LoopingSound_A:Stop()
			self.LoopingSound_A = nil
		end
	end
	
	-- Call the think every frame
	self.Entity:NextThink(CurTime())
	return true
end



function ENT:AttachPuck( puck )
	self.ShootTimer = CurTime() + 2
	self.DetachDetectTimer = CurTime() + 2
	
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
		puck:SetShootingEnabled( false )
		
		
		--parent whatever is parented to the puck, to the blimp
		if IsValid( puck.CurGrabbedEnt ) then
			local vecbox = phys:LocalToWorld( spot_box )
			puck.CurGrabbedEnt:SetParent( nil )
			puck.CurGrabbedEnt:SetAngles( Angle(0,0,90) )
			puck.CurGrabbedEnt:SetPos( vecbox )
			puck.CurGrabbedEnt:SetParent( self )
		end
		
		
		puck:SetPos( vec )
		puck:SetAngles( Angle(0,0,90) )
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
			
			self.DetachDetectTimer = nil
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
	
	self:DetachAllPucks()
end