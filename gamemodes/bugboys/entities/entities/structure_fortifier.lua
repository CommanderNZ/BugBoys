AddCSLuaFile("structure_fortifier.lua")

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
	
	self:ChangeStaticModel( self.Ref.model, COLLISION_GROUP_WEAPON )
end



function ENT:Think()
	--deal flat damage to an ent
	local function HealEnt( ent, num )
		local dmginfo = DamageInfo()
			dmginfo:SetDamage( -num )
			dmginfo:SetInflictor( self )
			dmginfo:SetAttacker( self )
		ent:TakeDamageInfo( dmginfo )
		
		self:Puff( self:GetPos() + Vector(0,0,30), .3, "134 255 128", 15, 70 )	
	end

	--heal ents in the radius
	local orgin_ents = ents.FindInSphere( self:GetPos(), self.Ref.radius )
	
	for k, ent in pairs( orgin_ents ) do
		if CheckIfInEntTable(ent) and ent.BBTeam == self.BBTeam and ent:GetPhysicsObject():IsMotionEnabled() != true 
		and ent:GetClass() != "structure_fortifier" and ent != self and ent:IsProjectile() != true 
		and ent:GetClass() != "structure_bugbrain" and ent:GetClass() != "structure_bugbrain_shield" then
		
			local health = ent:Health()
			local max_hp = ent:GetMaxHP()
			if health <= max_hp then
				if (health + self.Ref.heal_amount) > max_hp then
					ent:SetHealth( max_hp )
				else
					HealEnt( ent, self.Ref.heal_amount )
				end
			end
		end
	end
	
	self:NextThink( CurTime() + self.Ref.heal_rate )
	return true
end

function ENT:PhysicsCollide( data, phys )

end


