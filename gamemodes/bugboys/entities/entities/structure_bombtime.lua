AddCSLuaFile("structure_bombtime.lua")

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
	
	//self:ChangePhysicsModel( self.Ref.model, COLLISION_GROUP_NONE, self.Ref.mass )
	self:ChangeStaticModel( self.Ref.model, COLLISION_GROUP_WEAPON )
	
	self.OrigMat = self:GetMaterial()
end


--triggers the bomb to attach to a surface and start the fuse
function ENT:RayTrigger( activator )
	if !SERVER then return end

	--cant set this off before the game starts
	if GetGamePhase() != "BegunGame" then return end
	
	if self.Triggered != true then
		self.Triggered = true
		self.CheckingIfWeld = true
		
		
		self:SetIfCanGrab( false )
		
		self:EnableRadius()
	else
		self.Triggered = false
		self.CheckingIfWeld = false
		
		
		if self.FuseOn == true then
			--destroy the timer so it doesnt explode
			timer.Destroy( tostring(self) .. "_Timer" )
			
			self.FuseOn = false
			self.CurBeepRate = self.Ref.beep_rate
			//constraint.RemoveAll( self )
			//constraint.RemoveConstraints( self, "Weld" )
			
			self:SetIfCanGrab( true )
			
			self:DisableRadius()
		end
	end
end



function ENT:Fuse()
	self.CheckingIfWeld = false
	self.FuseOn = true
	
	self.CurBeepRate = self.Ref.beep_rate
	
	//print( tostring(self) .. "_Timer" )
	timer.Create( tostring(self) .. "_Timer", self.Ref.time_fuse, 1, function() 
		if not IsValid( self ) then return end
		self:Explode()
	end )
	
	--old way with simple timer
	--[[
	timer.Simple( self.Ref.time_fuse, function()
		if not IsValid( self ) then return end
		
		self:Explode()
	end)
	]]--
end



--visual effect
function ENT:DoVisualEffect(  )
	local effectdata = EffectData()
		effectdata:SetOrigin( self:GetPos() + Vector(0, 0, 40) )
		effectdata:SetStart( self:GetPos() + Vector(0, 0, 80) )
		effectdata:SetScale( 15 )
		effectdata:SetAttachment( 1 )
		effectdata:SetEntity( self )
	util.Effect( "HelicopterMegaBomb", effectdata )
end




--explodes
function ENT:Explode()
	//self.Exploded = true

	self:DoVisualEffect(  )
	
	--deal flat damage to an ent
	local function HurtEnt( ent )	
		if ent:GetClass() == "structure_bugbrain" and ent.ShieldIsUp != true then 
			return
		end
	
		local dmginfo = DamageInfo()
			dmginfo:SetDamage( self.Ref.damage )
			dmginfo:SetInflictor( self )
			if IsValid( self.Creator ) then
				dmginfo:SetAttacker( self.Creator )
			end	
		ent:TakeDamageInfo( dmginfo )
	end

	
	--[[
	--do a trace on the ent, return true if target still in sight and range
	local function CheckEntTrace( ent )
		--check if the ent is in sight of the sentry
		local Trace = {}
			Trace.start = self:GetPos()
			Trace.endpos = ent:GetPos()
			Trace.filter = self
			Trace.mask = MASK_SOLID //- CONTENTS_GRATE
			Trace = util.TraceLine(Trace) 
		local ent_traced = Trace.Entity
		if ent_traced == ent then
			return true
		end

		return false
	end
	]]--
	
	local orgin_ents = ents.FindInSphere( self:GetPos(), self.Ref.radius_damage )
	
	--hurt structures and players in the radius
	for k, ent in pairs( orgin_ents ) do
		if ent.BBTeam == GetOppositeTeam(self.BBTeam) then
			HurtEnt( ent )
		end
	end
	
	--resets the vars, even though we dont really need to cause its being removed but who cares
	self.FuseOn = false
	self.CurBeepRate = self.Ref.beep_rate
	

	self:EmitSound( self.Ref.sound_explode )
	self:Remove()
end



function ENT:Think()

	--check if on the ground or a static ent, weld to it if thats the case
	if self.CheckingIfWeld == true then
		//print("checking if weld")
	
		local function GroundCheck()
			local pos = self:GetPos()
			local tracedata = {}
			tracedata.start = pos
			tracedata.endpos = pos + (Vector(0, 0, -1) * 50)
			tracedata.filter = self, self.Owner
			
			local trace = util.TraceLine(tracedata)
			
			--if it didnt hit anything, we have nothing to do
			local hit = trace.Hit
			if not hit then
				return false
			end
			
			
			local hitnonworld = trace.HitNonWorld
			local hitworld = trace.HitWorld
			local ent = trace.Entity
			
			//print(ent)
			if hitnonworld then
				if CheckIfInEntTable( ent ) and ent:GetIfStatic() then
					return true
				else
					return false
				end
				
			elseif hitworld then
				return true
			end
			return false
		end
		
		if GroundCheck() then
			//self:WeldTo( game.GetWorld( ) )
			//local phys = self:GetPhysicsObject()
				//phys:EnableMotion(false)
			self:SetIfCanGrab( false )
			self:Fuse()
		end
	end
	

	--dont do anything unless the fuse is on
	if self.FuseOn != true then return end
	
	
	--play the count down sound at a faster and faster pace until it explodes, this doesnt trigger the explosion though
	self:EmitSound( self.Ref.sound_beep )
	self:FlashWhite( .1 )
	
	self:NextThink( CurTime() + self.CurBeepRate )
	self.CurBeepRate = self.CurBeepRate - self.Ref.beep_rate_amp
	return true
end



function ENT:WeldTo( x )
	timer.Simple(0, function()

	local Ent1 = self
	local Ent2 = x
	local Bone1 = 0
	local Bone2 = 0
	local constraint, weld = constraint.Weld( Ent1, Ent2, Bone1, Bone2, 0, true )	
	end);
end



function ENT:FlashWhite(time)
	self:SetMaterial("models/debug/debugwhite")
	
	timer.Simple( time, function()
		if not IsValid(self) then return end
		self:SetMaterial(self.OrigMat)
	end)
end


function ENT:FlashRadius( time )
	local sphere = ents.Create( "ent_sphere" )
		sphere:SetPos( self:GetPos() )//+ Vector(0,0,400) )
		sphere.BBTeam = self.BBTeam
		sphere:Spawn()
		
	local scale = self.Ref.radius * .02
		sphere:SetModelScale( scale, 0 )
	
	timer.Simple( time, function()
		if not IsValid( sphere ) then return end
		sphere:Remove()
	end)
end




function ENT:EnableRadius()
	local sphere = ents.Create( "ent_sphere" )
		sphere:SetPos( self:GetPos() )
		sphere.BBTeam = self.BBTeam
		sphere:Spawn()
		
	local scale = self.Ref.radius * .02
		sphere:SetModelScale( scale, 0 )
		
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



--[[
function ENT:PhysicsCollide(data, phys)
	if self.CheckingIfWeld != true then return end

	local hitent = data.HitEntity
	
	if hitent:IsValidPuck() != true and hitent.BBTeam == GetOppositeTeam( self.BBTeam ) and hitent:GetClass() != "structure_bugbrain" then
		//self:WeldTo( hitent )
		local physobj = self:GetPhysicsObject()
			physobj:EnableMotion(false)
		self:Fuse()
	end
	

	//if CheckIfInEntTable( hitent ) and hitent:GetIfStatic() then//and hitent.BBTeam == GetOppositeTeam( self.BBTeam ) then
		//self:WeldTo( hitent )
		//self:Fuse()
	//end

end
]]--



