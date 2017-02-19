AddCSLuaFile("ent_crystal.lua")

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
	
	self:ChangePhysicsModel( self.Ref.model, COLLISION_GROUP_WEAPON, self.Ref.mass )
	
	--set to be slidy
	//local phys = self.Entity:GetPhysicsObject()
		//phys:SetMaterial("gmod_ice")
	
	self.CraftToEnt = nil
	self.CraftEntRef = nil
	self.CraftPoints = 0
	self.CraftPoints_Max = self.Ref.craftpoints_max
end

--adds a point, when it reaches max points it transforms into the input ent
function ENT:AddCraftPoint( craft, othercrystals, crafter )
	self.CraftEntRef = TableReference_Craft( craft )
	self.CraftToEnt = self.CraftEntRef.ent
	
	self.CraftPoints = self.CraftPoints + 1
	self:EmitSound( self.Ref.sound_zap )
	
	if self.CraftPoints >= self.CraftPoints_Max then
		local myang = self:GetAngles()
	
		--create the ent at the position of the crystal
		local newent = ents.Create( self.CraftToEnt )
			newent:SetAngles( myang )
			newent:SetPos( self:GetPos() + Vector(0,0, self.CraftEntRef.spawn_height ) )
			newent.Creator = crafter
			newent:Spawn()
		
		--remove the other crystals that were being crafted
		for k, cryst in pairs(othercrystals) do
			cryst:Remove()
		end
		
		self:EmitSound( self.Ref.sound_craft )
		self:Remove()
	end
end

//function ENT:Think()
//end

function ENT:PhysicsCollide( data, phys )

end


