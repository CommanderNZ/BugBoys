AddCSLuaFile("structure_sapper.lua")

ENT.Type 			= "anim"
ENT.Base 			= "base_bbentity"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT


if !SERVER then return end
------------------------------------------------------------------------------------------------
--all server from now on
------------------------------------------------------------------------------------------------
ENT.Froze = false


function ENT:Initialize()
	self:SpecialInit()
	
	self:ChangeStaticModel( self.Ref.model, COLLISION_GROUP_WEAPON )
	
	self.Active = true
	self:EnableRadius()
	
	self.OrigMat = self:GetMaterial()
end



function ENT:OnUnGrab()
	if not IsValid( self ) then return end
	self.Froze = false
	
	
	local phys = self:GetPhysicsObject()
		if IsValid( phys ) then
			phys:EnableMotion( true )
		end
	--
	timer.Create( tostring(self) .. "_Timer", self.Ref.time_activate, 1, function() 
		if not IsValid( self ) then return end
		self.Grabbed = false
		
		if self:GetIfOnGround( 34, self ) then
			self:FreezeStraight()
		end
	end)
	--
end


function ENT:OnGrab()
	self.Active = false
	self:DisableRadius()
	
	self.Froze = false
	self.Grabbed = true
	
	local phys = self:GetPhysicsObject()
		phys:EnableMotion( true )
		
	timer.Destroy( tostring(self) .. "_Timer" )
end


function ENT:FreezeStraight( normal, pos )
	self.Froze = true
	self.Active = true
	self:EnableRadius()

	if normal != nil then
	
		local selfpos = self:GetPos()
		local combined = Vector(selfpos.x,selfpos.y,pos.z)
	
		self:SetPos( combined + (32 * -normal) )
		
		
		
		local phys = self:GetPhysicsObject()
			phys:SetAngles( Angle(0, 0, 0))
			phys:EnableMotion( false )
	else	
		local phys = self:GetPhysicsObject()
			phys:SetAngles( Angle(0, 0, 0))
			phys:EnableMotion( false )
	
	end
end



function ENT:PhysicsCollide(data, phys)
	if self.Grabbed == true then return end
	if self.Froze == true then return end
	
	
	if data.HitEntity:IsWorld() or data.HitEntity:GetPhysicsObject():IsMotionEnabled() != true then 
		local normal = data.HitNormal
		if normal.z < -.5 then
			self:FreezeStraight( data.HitNormal, data.HitPos )
		end
	end
end




function ENT:Think()
	if self.Active != true then return end

	local orgin_ents = ents.FindInSphere( self:GetPos(), self.Ref.radius )
	
	for k, ent in pairs( orgin_ents ) do
		if CheckIfInEntTable(ent) and ent.BBTeam == GetOppositeTeam( self.BBTeam ) and ent:GetPhysicsObject():IsMotionEnabled() != true 
		and ent:GetClass() != "structure_bugbrain" and ent:GetClass() != "structure_bugbrain_shield" then//and ent:GetClass() != "structure_sapper" then
			ent:HurtEnt( 10, self, self )
			ent:EmitSound( self.Ref.sound_hurt )
			self:FlashWhite( .2 )
		end
	end
	
	self:NextThink( CurTime() + self.Ref.hurt_rate )
	return true
end






function ENT:EnableRadius()
	local sphere = ents.Create( "ent_sphere" )
		sphere:SetPos( self:GetPos() )
		sphere.BBTeam = self.BBTeam
		sphere:Spawn()
		
	local scale = self.Ref.radius * .02
		sphere:SetModelScale( scale, 0 )
		
	sphere:SetMaterial( "bugboys/elevator_beam" )

	local red = Color(255,40,40,255)
	local blue = Color(40,40,255,255)

	if sphere.BBTeam == TEAM_BLUE then
		sphere:SetColor( blue ) 
	else
		sphere:SetColor( red ) 
	end
	
		
	self.SphereRadius = sphere
end

function ENT:DisableRadius()
	if IsValid( self.SphereRadius ) then
		self.SphereRadius:Remove()
	end
end

function ENT:OnRemove()
	self:DisableRadius()
end

function ENT:FlashWhite(time)
	self:SetMaterial("models/debug/debugwhite")
	
	timer.Simple( time, function()
		if not IsValid(self) then return end
		self:SetMaterial(self.OrigMat)
	end)
end