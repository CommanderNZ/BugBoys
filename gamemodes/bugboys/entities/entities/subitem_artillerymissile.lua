AddCSLuaFile("subitem_artillerymissile.lua")

ENT.Type 			= "anim"
ENT.Base 			= "base_bbentity"

if !SERVER then return end
------------------------------------------------------------------------------------------------
--all server from now on
------------------------------------------------------------------------------------------------




function ENT:Initialize()
	//self.Ref = self:GetRef()
	self:SpecialInit()
	
	self:ChangePhysicsModel( self.Ref.model, COLLISION_GROUP_WEAPON, self.Ref.mass )
	
	//self:SetMaterial(MATERIAL_WHITE)
	
	--[[
	timer.Simple( 0, function()
		if not IsValid( self ) then return end
		ParticleEffectAttach("rockettrail",PATTACH_ABSORIGIN_FOLLOW,self,0)
	end)
	]]--
end


function ENT:PhysicsCollide(data, phys)
	--if it hit something friendly, do nothing
	if data.HitEntity.BBTeam == self.BBTeam then return end

	--this makes it so physics damage wont be taken
	phys:EnableMotion(false)
	
	self.HitPostion = data.HitPos
	self:StartEffect( data.HitEntity )
end



--does the affect at the pos position
function ENT:StartEffect( hitent )
	--this explosion is just visual
	local explosion = ents.Create( "env_explosion" )		--/create an explosion and delete the prop
		explosion:SetPos( self:GetPos() )
		explosion:SetOwner( self.Owner )
		explosion:Spawn()
		explosion:SetKeyValue("spawnflags","81")
		explosion:Fire( "Explode", 0, 0 )
	
	--deal flat damage to an ent in the radius
	local function HurtEnt( ent )
		if ent:GetClass() == "structure_bugbrain_shield" then return end
		if ent:GetClass() == "structure_bugbrain" then return end
		local dmginfo = DamageInfo()
			dmginfo:SetDamage( self.Ref.damage )
			dmginfo:SetInflictor( self )
			dmginfo:SetAttacker( self )
		ent:TakeDamageInfo( dmginfo )
	end
	
	HurtEnt( hitent )
	
	--doesnt do AOE damage, just hurts the hot ent and has a visual explosion
	--[[
	local orgin_ents = ents.FindInSphere( self.HitPostion, self.Var_Radius )
	
	--hurt players and ents in the radius, except the directly hit one, we already hurt that one
	local hit = false
	for k, ent in pairs( orgin_ents ) do
		if ent.BBTeam != self.BBTeam and ent != hitent then
			HurtEnt( ent )
		end
	end
	]]--
	
	self:EmitSound( self.Ref.sound_explode )
	self:Remove()
end