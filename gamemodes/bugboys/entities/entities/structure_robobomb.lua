AddCSLuaFile("structure_robobomb.lua")

ENT.Type 			= "anim"
ENT.Base 			= "base_bbentity"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

if !SERVER then return end
------------------------------------------------------------------------------------------------
--all server from now on
------------------------------------------------------------------------------------------------
local angle = Angle( 0, 0, 0 )

ENT.SentryMode = "search"
ENT.SentryTarget = nil


function ENT:Initialize()
	self:SpecialInit()
	
	self:ChangePhysicsModel( self.Ref.model, COLLISION_GROUP_WEAPON, self.Ref.mass )
	
	--set to be slidy
	local phys = self.Entity:GetPhysicsObject()
		//phys:SetMaterial("default")
		phys:SetMaterial("gmod_ice")
end

--triggers the robot to start looking for people to chase
function ENT:RayTrigger( activator )
	if !SERVER then return end

	if self.Triggered != true then
		self.Triggered = true
		
		--start looping sound
		self.LoopingSound_A = CreateSound( self, self.Ref.sound_on )
		self.LoopingSound_A:Play()
		
	else
		self.Triggered = false
		self.SentryMode = "search"
		
		--stop looping sound
		self.LoopingSound_A:Stop()
		
		local phys = self:GetPhysicsObject()
			phys:SetVelocity(Vector(0,0,0))
	end
end


function ENT:Think()
	--if the robot is not turned on, theres nothing to do
	if self.Triggered != true then return end
	
	local orgin_ents = ents.FindInSphere( self:GetPos(), self.Ref.radius )
	
	if self.SentryMode == "search" then
		--find an enemy in the radius
		for k, ent in pairs( orgin_ents ) do
			if ent:IsValidPuck() and ent:GetClass() != "puck_blimp" and ent.BBTeam == GetOppositeTeam( self.BBTeam ) then
				self.SentryTarget = ent
				self.SentryMode = "check"
			end
		end
	
	elseif self.SentryMode == "check" then
		local found = false
		--make sure the ent is still in the radius, if not, go back to search mode
		for k, ent in pairs( orgin_ents ) do
			if ent == self.SentryTarget then
				found = true
			end
		end
		
		if found == false then
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
			phys:ApplyForceCenter (shoot_ang *  self.Ref.force_chase)
	else
		self.SentryTarget = nil
		self.SentryMode = "search"
	end
	
	--explode if an enemy is within the radius
	local orgin_ents = ents.FindInSphere( self:GetPos(), self.Ref.radius_explode )
	for k, ent in pairs( orgin_ents ) do
		if ent:IsValidPuck() and ent.BBTeam == GetOppositeTeam( self.BBTeam ) then
			self:EmitSound( self.Ref.sound_explode )
			VisualExplosion( self:GetPos(), self.Creator )
			
			ent:HurtEnt(self.Ref.damage, self, self.Creator)
			
			self:Remove()
		end
	end
	
	
	self:NextThink( CurTime() + self.Ref.think_rate )
	return true
end

function ENT:PhysicsCollide( data, phys )

end


