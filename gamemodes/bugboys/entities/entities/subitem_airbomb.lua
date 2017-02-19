AddCSLuaFile("subitem_airbomb.lua")

ENT.Type 			= "anim"
ENT.Base 			= "base_bbentity"

if !SERVER then return end
------------------------------------------------------------------------------------------------
--all server from now on
------------------------------------------------------------------------------------------------




function ENT:Initialize()
	//self.Ref = self:GetRef()
	self:SpecialInit()
	
	
	--these are set up so certain ents can override all these vars
	self.Var_Model = self.Ref.model
	self.Var_Mass = self.Ref.mass
	self.Var_Damage = self.Ref.damage
	self.Var_Radius = self.Ref.radius
	self.Var_SoundExplode = self.Ref.sound_explode
	
	self.Var_Knockback = self.Ref.knockback
	self.Var_KnockbackForce = self.Ref.knockback_force
	
	self:ChangePhysicsModel( self.Var_Model, COLLISION_GROUP_WEAPON, self.Var_Mass )
end


function ENT:PhysicsCollide(data, phys)
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
		local dmginfo = DamageInfo()
			dmginfo:SetDamage( self.Var_Damage )
			dmginfo:SetInflictor( self )
			if IsValid( self.Creator ) then
				dmginfo:SetAttacker( self.Creator )
			end
			
		if self.Ref.hurts_only_players == true and not ent:IsValidPuck() then return end
		ent:TakeDamageInfo( dmginfo )
	end
	
	if hitent != nil then
		HurtEnt( hitent )
	end
	
	if self.HitPostion == nil then
		self.HitPostion = self:GetPos()
	end
	
	local orgin_ents = ents.FindInSphere( self.HitPostion, self.Var_Radius )
	--hurt players and ents in the radius, except the directly hit one, we already hurt that one
	local hit = false
	for k, ent in pairs( orgin_ents ) do
		if ent.BBTeam != self.BBTeam and ent != hitent then
			HurtEnt( ent )
		end
	end
	
	if self.Var_Knockback == true then
		self:KnockBackStuff()
	end
	
	self:EmitSound( self.Var_SoundExplode )
	self:Remove()
end


function ENT:Think()
	--high gravity for the climber version
	if self.Ref.version == "climber" then
		self:GetPhysicsObject():ApplyForceCenter( Vector( 0, 0, -self.Ref.gravity_force ) )
	
		//self:NextThink( CurTime() + self.Ref.think_rate )
		//return true
	end
	
	
	if self:WaterLevel() >= 1 then
		self.HitPostion = self:GetPos()
		self:StartEffect()
	end
end




function ENT:KnockBackStuff()
	local orgin_ents = ents.FindInSphere( self:GetPos(), self.Var_Radius )
	for k, ent in pairs( orgin_ents ) do
		local knock_ang = ( ent:GetPos() - self:GetPos() ):GetNormal()
		local rot = Angle(0, 0, 0)
		knock_ang:Rotate( rot )
	

		if ent:GetPhysicsObject():IsValid() and CheckIfInEntTable( ent ) then
			local phys = ent:GetPhysicsObject()
				phys:SetVelocity( knock_ang *  self.Var_KnockbackForce )
			
			//ent:Knockback( knock_ang, self.Ref.force_physics_blast )
		end
	end
end