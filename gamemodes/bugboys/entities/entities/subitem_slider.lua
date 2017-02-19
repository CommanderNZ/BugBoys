AddCSLuaFile("subitem_slider.lua")

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
	
	--up the damage if the player has the gainer item
	--[[
	if self.Gaining == true then
		self.Damage = self.Ref.damage + self.Creator:GetGainedDamage()
	else
		self.Damage = self.Ref.damage
	end
	]]--
	
	self.Damage = self.Ref.damage
	
	//print("THIS IS MY DAMAGE   "  .. self.Damage)
	//self.Creator:PrintMessage( HUD_PRINTCENTER, self.Damage )
	
	--sliders innately repair allied structures
	self.Repair = true
	
	self.Radius = self.Ref.radius
	self.Var_Fuse = self.Ref.fuse
	
	if self.Rocket == true then
		//ParticleEffectAttach("rockettrail",PATTACH_ABSORIGIN_FOLLOW,self,0)
		local phys = self:GetPhysicsObject()
			phys:EnableGravity(false)
		
		self.Radius = self.Ref.radius
		self.Var_Fuse = 1.5	
	end
	
	--[[
	timer.Simple( 0, function()
		if not IsValid( self ) then return end
		ParticleEffectAttach("rockettrail",PATTACH_ABSORIGIN_FOLLOW,self,0)
	end)
	]]--
	
	self:Fuse()
end


function ENT:Fuse()
	timer.Simple( self.Var_Fuse, function()
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

--
function ENT:PhysicsCollide(data, phys)
	if self.Hit == true then return end

	if self.Repair == true and data.HitEntity.BBTeam == self.BBTeam and data.HitEntity:GetPhysicsObject():IsMotionEnabled() != true and data.HitEntity:Health() < data.HitEntity:GetMaxHealth() then
		self:HealEffect( data.HitEntity )
		phys:EnableMotion(false)
		self.Hit = true
	end

	if self.Rocket == true then
		self:StartEffect( data.HitEntity )
		self.Hit = true
	end
	
	if data.HitWorld then return end
	
	--check if it hit something thats going to make it explode
	if data.HitEntity:IsValidPuck() or CheckIfInEntTable( data.HitEntity ) then
		--doesnt explode if it hits another slider
		if data.HitEntity:GetClass() == "subitem_slider" then return end
		if data.HitEntity.BBTeam != self.BBTeam then
			--can only call this once
			if self.Hit == true then return end
			self.Hit = true
			
			phys:EnableMotion(false)
			self:StartEffect( data.HitEntity )
		end
	end
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
		
		--give the gainer more damage so it can gain more stats
		if self.Gaining == true and ent.BBTeam == GetOppositeTeam( self.BBTeam ) then
			local gainer_ent = self.Creator.Puck.CurGrabbedEnt
			if IsValid( gainer_ent ) then
				gainer_ent:Gain( self.Damage )
			end
		end
	end
	
	if hitent != nil then
		if hitent.BBTeam != self.BBTeam then
			HurtEnt( hitent )
		end
	end

	local orgin_ents = ents.FindInSphere( self:GetPos(), self.Radius )
	--hurt players and ents in the radius
	for k, ent in pairs( orgin_ents ) do
		if ent.BBTeam != self.BBTeam and ent != hitent and ent != self then
			HurtEnt( ent )
		end
	end

	
	self:KnockBackStuff()
	
	self:EmitSound(self.Ref.sound_explode)
	self:Remove()
end




function ENT:HealEffect( hitent )
	if CheckIfInEntTable( hitent ) then
		local entref = EntReference( hitent:GetClass() )
		if entref.cant_heal == true then
			return
		end
	end
	
	
	local function HealEnt( ent )
		local dmginfo = DamageInfo()
			dmginfo:SetDamage( -10 )
			dmginfo:SetInflictor( self )
			if IsValid( self.Creator ) then
				dmginfo:SetAttacker( self.Creator )
			end
		ent:TakeDamageInfo( dmginfo )
	end
	
	if hitent != nil then
		HealEnt( hitent )
	end
	
	local color = Color( 51, 255, 102, 255 )
		self:SetColor( color ) 

	self:Puff( self:GetPos(), .3, "134 255 128", 15, 50 )	
		
	self:EmitSound("buttons/button19.wav")
	timer.Simple( .4, function()
		if not IsValid(self) then return end
		self:Remove()
	end)
end




function ENT:KnockBackStuff()
	local orgin_ents = ents.FindInSphere( self:GetPos(), self.Ref.radius_knockback )
	for k, ent in pairs( orgin_ents ) do
		local knock_ang = ( ent:GetPos() - self:GetPos() ):GetNormal()
		local rot = Angle(0, 0, 0)
		knock_ang:Rotate( rot )
	

		if ent:GetPhysicsObject():IsValid() and ent:IsValidPuck() and ent.BBTeam != self.BBTeam and ent:GetClass() != "structure_scout" then
			local phys = ent:GetPhysicsObject()
				phys:SetVelocity( knock_ang *  500 )
			
			//ent:Knockback( knock_ang, self.Ref.force_physics_blast )
		end
	end
end



function ENT:OnRemove( )
	local swep = self.CreatorTool 
	if IsValid(swep) then
		table.RemoveByValue( swep.EntTable, self )
	end
end




--[[
function ENT:KnockBackStuff()
	local orgin_ents = ents.FindInSphere( self:GetPos(), self.Ref.force_radius );

	for k, ent in pairs( orgin_ents ) do
	
		--special var to give to stuff i dont want to be knockbackable for some reason
		if ent.CanAirblast != false then
		
			//local self_vec = self:GetPos()
			//local target_vec = ent:GetPos()
			
			local knock_ang = ( ent:GetPos() - self:GetPos() ):GetNormal()
			local rot = Angle(0, 0, 0)
			knock_ang:Rotate( rot )
		
			--blast back a player
			if ent:IsValidGamePlayer() and ent:Team() != self.TTG_Team then
				


				if ent:OnGround() then
					//ent:SetVelocity( knock_ang * self.Ref.force_player_blast + Vector(0, 0, 400))
					ent:Knockback( knock_ang, self.Ref.force_player_blast, self.Ref.force_player_blast_vert )
			
				else
					//ent:SetVelocity( knock_ang * self.Ref.force_player_blast )
					ent:Knockback( knock_ang, self.Ref.force_player_blast )
				end
				break
				
			--blast back physics ent
			elseif ent:GetPhysicsObject( ):IsValid() and CheckIfInEntTable( ent ) then
				//local phys = ent:GetPhysicsObject()
				//phys:SetVelocity( knock_ang *  self.Ref.force_physics_blast )
				
				ent:Knockback( knock_ang, self.Ref.force_physics_blast )
					
			end
		end
	end
end
]]--



--explosion is no longer triggered by a player being within range
--[[
function ENT:Think()

	local orgin_ents = ents.FindInSphere( self:GetPos() + Vector(0,0,15), self.Ref.radius )
	
	
	--stun players in the radius
	for k, ent in pairs( orgin_ents ) do
		if ent:IsValidGamePlayer() then
			if ent:Team() != self.TTG_Team then
				self:StartEffect(  )
			end
		end
	end
	
	self:NextThink( CurTime() + self.Ref.think_rate )
	return true
end

]]--