AddCSLuaFile("structure_cloud.lua")

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
end


--trigger it to turn into the big platform
function ENT:RayTrigger( activator )
	if !SERVER then return end
	
	self:SetAngles( angle )
	
	self:ChangeStaticModel( self.Ref.model_platform, COLLISION_GROUP_WEAPON )
	self:Transparency_Set( 200 )
	
	self:EmitSound( self.Ref.sound_collisionson )
	
	self.TurnedStatic = true
end