AddCSLuaFile("structure_bomb.lua")

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
	
	self:ChangePhysicsModel( self.Ref.model, COLLISION_GROUP_NONE, self.Ref.mass )
	
	--set to be slidy
	//local phys = self.Entity:GetPhysicsObject()
		//phys:SetMaterial("gmod_ice")
end




--does the effect at the pos position
function ENT:StartEffect()
	--this explosion is just visual
	local explosion = ents.Create( "env_explosion" )		--/create an explosion and delete the prop
		explosion:SetPos( self:GetPos() )
		explosion:SetOwner( self.Owner )
		explosion:Spawn()
		explosion:SetKeyValue("spawnflags","81")
		explosion:Fire( "Explode", 0, 0 )
	
	--bring the ent to 20% hp
	local function HurtEntPercent( ent )
		local health = ent:Health()
		local max_hp = ent:GetMaxHP()
		local dmg = health * self.Ref.damage_percent
	
		ent:HurtEnt( dmg, self, self.Creator )
	end

	local orgin_ents = ents.FindInSphere( self:GetPos(), self.Ref.radius_damage )
	
	--hurt players in the radius
	for k, ent in pairs( orgin_ents ) do
		if ent:IsValidPuck() and ent.BBTeam == GetOppositeTeam( self.BBTeam ) then
			HurtEntPercent( ent )
		end
	end
	
	self:EmitSound( self.Ref.sound_explode )
	self:Remove()
end



function ENT:Think()
	--explode if there are enemies in the radius
	local orgin_ents = ents.FindInSphere( self:GetPos(), self.Ref.radius_activation )
	
	for k, ent in pairs( orgin_ents ) do
		if ent:IsValidPuck() and ent.BBTeam == GetOppositeTeam( self.BBTeam )then
			self:StartEffect()
		end
	end
end

function ENT:PhysicsCollide( data, phys )

end


