AddCSLuaFile("structure_radar.lua")

ENT.Type 			= "anim"
ENT.Base 			= "base_bbentity"
//ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

if !SERVER then return end
------------------------------------------------------------------------------------------------
--all server from now on
------------------------------------------------------------------------------------------------


--Everything for this entity is done in cl_init.lua or maybe Ive moved it to a separate file by now and havent changed this message yet
function ENT:Initialize()
	self:SpecialInit()
	
	self:SetEntTeamForClient()
	
	self:ChangeStaticModel( self.Ref.model, COLLISION_GROUP_WEAPON )
end


