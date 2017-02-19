AddCSLuaFile("subitem_missile_rope.lua")

ENT.Type 			= "anim"
ENT.Base 			= "base_bbentity"

if !SERVER then return end
------------------------------------------------------------------------------------------------
--all server from now on
------------------------------------------------------------------------------------------------

function ENT:Initialize()
	self:SpecialInit()
	
	self:ChangePhysicsModel( self.Ref.model, COLLISION_GROUP_WEAPON, self.Ref.mass )
	
	local phys = self:GetPhysicsObject()
		phys:EnableGravity(false)
		
	
	self:Fuse()
end


function ENT:Fuse()
	timer.Simple( self.Ref.fuse, function()
		if not IsValid( self ) then return end
		self:Remove()
	end)
end



function ENT:PhysicsCollide(data, phys)
	if self.Hit == true then return end
	if data.HitEntity:IsWorld() then
		local pos = data.HitPos
	
		self:CreateRopePlatform( pos )
		self.Hit = true
		
		phys:EnableMotion(false)
		
	elseif data.HitEntity:GetPhysicsObject():IsMotionEnabled() != true then
		local pos = data.HitPos
	
		self:CreateRopePlatform( pos )
		self.Hit = true
		
		phys:EnableMotion(false)
		
		
	//elseif data.HitEntity:GetPhysicsObject():IsMotionEnabled() then
		//self:RopeToEnt( data.HitEntity, data.HitPos )
		//self.Hit = true
		
	end
end


function ENT:CreateRopePlatform( hitpos )
	local obj = ents.Create( "subitem_platform_rope" )
		obj.BBTeam = self.Owner:Team()
		if IsValid( self.Creator ) then
			obj.Creator = self.Creator
		end
		obj:SetPos( hitpos )
		obj:Spawn()
		
	
	--[[
	local function RopeTo( ent )
		--Rope setup code--
		local forcelimit = 0;
		local addlength     = 0;
		local material      = "cable/cable2"
		local width      = 3;
		local rigid         = false;
					 
		local Ent1 = self.Creator.Puck
		local Ent2 = ent
		local Bone1, Bone2 = 0, 0
		local WPos1, WPos2 = self.Creator.Puck:GetPos(), obj:GetPos()
		local LPos1, LPos2 = self:WorldToLocal(WPos1), ent:WorldToLocal(WPos2)
		local length = (WPos2 - WPos1):Length()
		
		local constraint, rope = constraint.Rope( Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, length, addlength, forcelimit, width, material, rigid )	
	end

	
	if IsValid( self.Creator.Puck ) then
		print( "creator valid" )
		RopeTo( obj )
	end
	]]--

	self:Remove()
end


function ENT:RopeToEnt( hitent, hitpos )

	local function RopeTo( ent, pos, physbone )
		--Rope setup code--
		local forcelimit = 0;
		local addlength     = 0;
		local material      = "cable/cable2"
		local width      = 3;
		local rigid         = false;
					 
		local Ent1 = self.Creator.Puck
		local Ent2 = ent
		local Bone1, Bone2 = 0, 0
		local WPos1, WPos2 = self:GetPos(), hitpos
		local LPos1, LPos2 = self:WorldToLocal(WPos1), ent:WorldToLocal(WPos2)
		local length = (WPos2 - WPos1):Length()
		
		local constraint, rope = constraint.Rope( Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, length, addlength, forcelimit, width, material, rigid )	
		
		//self:EmitSound( SOUND_ROPE_MAKE )
	end

	
	if IsValid( self.Creator.Puck ) then
		RopeTo( hitent, hitpos )
	end
	
	
	self:EmitSound(self.Ref.sound_explode)
	self:Remove()
end




