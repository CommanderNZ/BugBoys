AddCSLuaFile("structure_bridge.lua")

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
	
	
	//self:Transparency_Set( 200 )
	self:ChangeStaticModel( self.Ref.model, COLLISION_GROUP_WEAPON )
	self:EmitSound( self.Ref.sound_collisionson )
end




