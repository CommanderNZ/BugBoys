AddCSLuaFile("structure_deconstructor.lua")

ENT.Type 			= "anim"
ENT.Base 			= "base_bbentity"
//ENT.RenderGroup = RENDERGROUP_TRANSLUCENT


if !SERVER then return end
------------------------------------------------------------------------------------------------
--all server from now on
------------------------------------------------------------------------------------------------

function ENT:Initialize()
	self:SpecialInit()
	
	self:ChangeStaticModel( self.Ref.model, COLLISION_GROUP_WEAPON )
end





function ENT:OnGrab( ply )
	ply:AddSwepAbility( self.Ref.swep_ability )
	self.Holder = ply
end

function ENT:OnUnGrab()
	if IsValid( self.Holder ) then
		self.Holder:RemoveSwepAbilities()
	end
end

