AddCSLuaFile("ent_building_ghost.lua")

ENT.Type 			= "anim"
ENT.Base 			= "base_bbentity"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT


if !CLIENT then return end

function ENT:Initialize()
	//self:SpecialInit()
	
	//self:ChangePhysicsModel( self.Ref.model, COLLISION_GROUP_WEAPON, self.Ref.mass )
end


