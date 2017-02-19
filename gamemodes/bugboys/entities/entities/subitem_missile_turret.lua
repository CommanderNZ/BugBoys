AddCSLuaFile("subitem_missile_turret.lua")

ENT.Type 			= "anim"
ENT.Base 			= "base_bbentity"

if !SERVER then return end
------------------------------------------------------------------------------------------------
--all server from now on
------------------------------------------------------------------------------------------------


--used by structure_gainer item to increase damage
ENT.Gaining = false


function ENT:Initialize()
	//self.Ref = self:GetRef()
	self:SpecialInit()
	
	self:ChangePhysicsModel( self.Ref.model, COLLISION_GROUP_WEAPON, self.Ref.mass )
	
	//self:SetAngles( Angle(0, 0, 90))
	local phys = self:GetPhysicsObject()
		phys:SetMaterial("ice")
	

	self.Damage = self.Ref.damage
	self.Radius = self.Ref.radius
	
	//local phys = self:GetPhysicsObject()
		//phys:EnableGravity(false)
		
	--[[
	timer.Simple( 0, function()
		if not IsValid( self ) then return end
		ParticleEffectAttach("rockettrail",PATTACH_ABSORIGIN_FOLLOW,self,0)
		//ParticleEffectAttach("flamethrower",PATTACH_ABSORIGIN_FOLLOW,self,0)
	end)
	]]--
	
	self:Fuse()
end


function ENT:Fuse()
	timer.Simple( self.Ref.fuse, function()
		if not IsValid( self ) then return end
		self:StartEffect(  )
	end)
end



function ENT:PhysicsCollide(data, phys)
	if self.Hit == true then return end
	
	self:StartEffect( data.HitEntity )
	self.Hit = true
	
	phys:EnableMotion(false)
end
--


--does the affect at the pos position
function ENT:StartEffect( hitent )
	--this explosion is just visual
	local explosion = ents.Create( "env_explosion" )		--/create an explosion and delete the prop
		explosion:SetPos( self:GetPos() )
		explosion:SetOwner( self.Owner )
		explosion:Spawn()
		explosion:SetKeyValue("spawnflags","349")
		explosion:Fire( "Explode", 0, 0 )
	
	
	--deal flat damage to an ent in the radius
	local function HurtEnt( ent )
		local dmginfo = DamageInfo()
			dmginfo:SetDamage( self.Damage )
			dmginfo:SetInflictor( self )
			if IsValid( self.Creator ) then
				dmginfo:SetAttacker( self.Creator )
			end
		ent:TakeDamageInfo( dmginfo )
	end
	
	if hitent != nil then
		if hitent:IsValidPuck() and hitent.BBTeam != self.BBTeam then
			HurtEnt( hitent )
		end
	end

	local orgin_ents = ents.FindInSphere( self:GetPos(), self.Radius )
	--hurt players and ents in the radius
	for k, ent in pairs( orgin_ents ) do
		if ent:IsValidPuck() and ent.BBTeam != self.BBTeam and hitent != ent and ent != self then
			HurtEnt( ent )
		end
	end


	self:EmitSound(self.Ref.sound_explode)
	self:Remove()
end




