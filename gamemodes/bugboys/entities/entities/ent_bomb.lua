AddCSLuaFile("ent_bomb.lua")

ENT.Type 			= "anim"
ENT.Base 			= "base_ttgentity"

if !SERVER then return end
------------------------------------------------------------------------------------------------
--all server from now on
------------------------------------------------------------------------------------------------





--makes it so it has a reference table of all its attributes, to be set within the ent code
function ENT:SetBaseVars()
	self.Ref = self:GetRef()
	
	self.Model = self.Ref.model
	self.IMagnitude = self.Ref.imagnitude
	self.IRadiusOverride = self.Ref.iradiusoverride
end

function ENT:Initialize()
	self:SetBaseVars()

	self:SpecialEntInit()
	
	self:ChangePhysicsModel( self.Ref.model, COLLISION_GROUP_WEAPON )
	
	--this ent comes from a weapon tool so it does not collide with spawn doors
	self:AddSpawnDoorNoCollide()

	self.StartPosition =  self:GetPos()
	--print( "starting height:", self.StartPosition )
end


function ENT:PhysicsCollide(data, phys)
	local hitent = data.HitEntity
	--this makes it so physics damage wont be taken
	phys:EnableMotion(false)
	
	self.HitPostion = data.HitPos
	self:StartEffect()
	
	self:SetOwner(nil)
end



--does the affect at the pos position
function ENT:StartEffect(  )


	--set this variable dependent on the level of the gun which created this ent
	--[[
	local damage = self.Ref.damage_level1
	if self.CreatorSwep:GetNumGuns() == 1 then
		damage = self.Ref.damage_level1
	elseif self.CreatorSwep:GetNumGuns() == 2 then
		damage = self.Ref.damage_level2
	elseif self.CreatorSwep:GetNumGuns() == 3 then
		damage = self.Ref.damage_level3
	end
	--print( "this is damage", damage )
	]]--
	
	--local damage = self.Ref.damage
	
	
	--this explosion is just visual
	local explosion = ents.Create( "env_explosion" )		--/create an explosion and delete the prop
		explosion:SetPos( self:GetPos() )
		explosion:SetOwner( self.HitPostion )
		explosion:Spawn()
		explosion:SetKeyValue("spawnflags","349")
		explosion:Fire( "Explode", 0, 0 )
	
	
	
	--deal damage to an ent
	local function HurtEnt( ent )
		local start_height = self.StartPosition.z
		local end_height = self.HitPostion.z
		local distance = start_height - end_height
		
		local damage = 0
		if distance <= 100 then
			damage = self.Ref.damage_ground
		elseif distance > 100 then
			damage = distance * self.Ref.damage_multiplier
			damage = math.floor( damage + 0.5)
		end
		--print( "traveled this far:", distance )
		--print( "damage:", damage )
	
		local dmginfo = DamageInfo()
			dmginfo:SetDamage( damage )
			dmginfo:SetInflictor( self )
			dmginfo:SetAttacker( self.Creator )
		ent:TakeDamageInfo( dmginfo )
	end
	
	
	
	local orgin_ents = ents.FindInSphere( self.HitPostion, self.Ref.radius )
	
	--hurt players and ents in the radius
	local hit = false
	for k, ent in pairs( orgin_ents ) do
		if ent:IsValidGamePlayer() and ent:Team() != self.TTG_Team then
			--damage enemy player
			HurtEnt( ent )
			hit = true
		end
	end
	
	if hit == true then
		self.Owner:EmitSound(self.Ref.sound_hit)
	end
	
	
	
	self:EmitSound(self.Ref.sound_explode)
		
	self:Remove()
end


function ENT:Think()
	self:GetPhysicsObject():ApplyForceCenter( Vector( 0, 0, -self.Ref.gravity_force ) )
	
	self:NextThink( CurTime() + self.Ref.think_rate )
	return true
end