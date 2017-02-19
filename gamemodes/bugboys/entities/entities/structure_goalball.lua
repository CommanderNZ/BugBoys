AddCSLuaFile("structure_goalball.lua")

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
	
	--set to be slidy
	//local phys = self.Entity:GetPhysicsObject()
		//phys:SetMaterial("gmod_ice")
end


//function ENT:Think()
//end

function ENT:PhysicsCollide( data, phys )

end


