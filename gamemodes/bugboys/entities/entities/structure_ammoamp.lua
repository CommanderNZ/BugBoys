AddCSLuaFile("structure_ammoamp.lua")

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
	
	//self:ChangePhysicsModel( self.Ref.model, COLLISION_GROUP_WEAPON, self.Ref.mass )
	self:ChangeStaticModel( self.Ref.model, COLLISION_GROUP_WEAPON )
	
	--set to be slidy
	//local phys = self.Entity:GetPhysicsObject()
		//phys:SetMaterial("gmod_ice")
	
	self.TouchingPlyList = {}
	self.Active = true
end


function ENT:OnUnGrab()
	timer.Create( tostring(self) .. "_Timer", self.Ref.time_activate, 1, function() 
		if not IsValid( self ) then return end
		self.Active = true
	end )
end


function ENT:OnGrab()
	self.Active = false
	timer.Destroy( tostring(self) .. "_Timer" )
end


function ENT:Think()
	if self.Active != true then return end

	--deal flat damage to an ent
	local function IncreaseAmmo( puck )
		local wep = puck.Owner:GetActiveWeapon()
		local wepref = SwepReference( wep:GetClass() )	
		
		if wep:Clip1() < wepref.primary_clip then
			self:EmitSound( self.Ref.sound_give )
		
			wep:SetClip1( wep:Clip1() + 1 )
		end
	end
	
	
	--heal ents in the radius
	local orgin_ents = ents.FindInSphere( self:GetPos(), self.Ref.radius )
	
	for k, ent in pairs( orgin_ents ) do
		if ent:IsValidPlyBug() and ent.BBTeam == self.BBTeam then
			IncreaseAmmo( ent )
		end
	end
	
	self:NextThink( CurTime() + self.Ref.think_rate )
	return true
end



