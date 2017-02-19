AddCSLuaFile("subitem_missile_heatseeker.lua")

ENT.Type 			= "anim"
ENT.Base 			= "base_bbentity"

if !SERVER then return end
------------------------------------------------------------------------------------------------
--all server from now on
------------------------------------------------------------------------------------------------

ENT.SentryMode = "search"
ENT.SentryTarget = nil


function ENT:Initialize()
	//self.Ref = self:GetRef()
	self:SpecialInit()
	
	self:ChangePhysicsModel( self.Ref.model, COLLISION_GROUP_WEAPON, self.Ref.mass )
	
	self:SetAngles( Angle(0, 0, 90))
	local phys = self:GetPhysicsObject()
		phys:SetMaterial("ice")
	
	
	self:Fuse()
	self.BeepTimer = 0
	
	self.ChaseSpeed = self.Ref.force_chase
end


function ENT:Fuse()
	timer.Simple( self.Ref.fuse, function()
		if not IsValid( self ) then return end
		self:StartEffect(  )
	end)
end


--[[
function ENT:PhysicsCollide(data, phys)
	--this makes it so physics damage wont be taken
	phys:EnableMotion(false)
	
	self.HitPostion = data.HitPos
	self:StartEffect( data.HitEntity )
end
]]--



function ENT:PhysicsCollide(data, phys)
	//print( data.HitEntity:IsWorld() )

	--if data.HitWorld then return end
	if data.HitEntity:IsWorld() or CheckIfInEntTable( data.HitEntity ) and data.HitEntity.BBTeam != self.BBTeam then 
		if self.Hit == true then return end
		self.Hit = true
		
		phys:EnableMotion(false)
		self:StartEffect( )
	end
	
	
	--check if it hit something thats going to make it explode
	if data.HitEntity:IsValidVehicle() then//or CheckIfInEntTable( data.HitEntity ) then
		--doesnt explode if it hits another slider
		if data.HitEntity:IsProjectile() then return end
		if data.HitEntity.BBTeam != self.BBTeam then
			--can only call this once
			if self.Hit == true then return end
			self.Hit = true
			
			phys:EnableMotion(false)
			self:StartEffect( data.HitEntity )
		end
	end
end



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
			dmginfo:SetDamage( self.Ref.damage )
			dmginfo:SetInflictor( self )
			dmginfo:SetAttacker( self )
		ent:TakeDamageInfo( dmginfo )
	end
	
	if hitent != nil then
		HurtEnt( hitent )
	end

	local orgin_ents = ents.FindInSphere( self:GetPos(), self.Ref.radius )
	--hurt players and ents in the radius
	for k, ent in pairs( orgin_ents ) do
		if ent.BBTeam != self.BBTeam and ent:IsValidVehicle() then
			HurtEnt( ent )
		end
	end

	
	self:EmitSound(self.Ref.sound_explode)
	self:Remove()
end





function ENT:Think()

	local orgin_ents = ents.FindInSphere( self:GetPos(), self.Ref.radius_search )
	
	if self.SentryMode == "search" then
		--find an enemy in the radius
		for k, ent in pairs( orgin_ents ) do
			if ent:IsValidVehicle() and ent.BBTeam == GetOppositeTeam( self.BBTeam ) then
				if ent:GetClass() == "structure_dropship" then
					self.ChaseSpeed = self.Ref.force_chase_airunit
				elseif ent:GetClass() == "structure_scout" then
					self.ChaseSpeed = self.Ref.force_chase_scout
				else
					self.ChaseSpeed = self.Ref.force_chase
				end
			
				self.SentryTarget = ent
				self.SentryMode = "check"
			end
		end
	
	elseif self.SentryMode == "check" then
		--make sure the ent is still in the radius, if not, go back to search mode
		--[[
		local found = false
		for k, ent in pairs( orgin_ents ) do
			if ent == self.SentryTarget then
				found = true
			end
		end
		
		if found == false then
			self.SentryTarget = nil
			self.SentryMode = "search"
		end
		]]--
		
		if not IsValid( self.SentryTarget ) then
			self.SentryTarget = nil
			self.SentryMode = "search"
		end
	end
	
	--push self towards the target
	if IsValid(self.SentryTarget) then
		local self_vec = self:GetPos()
		local target_vec = self.SentryTarget:GetPos()
		
		local shoot_ang = ( target_vec - self_vec):GetNormal()
		local rot = Angle(0, 0, 0)
		shoot_ang:Rotate( rot )
	
		//local phys = self.SentryTarget:GetPhysicsObject()
			//phys:ApplyForceCenter (shoot_ang *  self.Ref.force_chase)
			
		local phys = self:GetPhysicsObject()
			phys:SetVelocity ((shoot_ang + Vector(0,0,.5)) *  self.ChaseSpeed )
	else
		self.SentryTarget = nil
		self.SentryMode = "search"
	end
	
	--explode if an enemy is within the radius
	--[[
	local orgin_ents = ents.FindInSphere( self:GetPos(), self.Ref.radius )
	for k, ent in pairs( orgin_ents ) do
		if ent:IsValidPuck() and ent.BBTeam == GetOppositeTeam( self.BBTeam ) then
			self:StartEffect( ent )
		end
	end
	]]--
	
	
	if CurTime() > self.BeepTimer then
		self:EmitSound( self.Ref.sound_repeat )
		self.BeepTimer = CurTime() + self.Ref.repeat_rate
	end
	
	
	self:NextThink( CurTime() + self.Ref.think_rate )
	return true
end