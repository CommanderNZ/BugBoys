AddCSLuaFile("structure_gainer.lua")

ENT.Type 			= "anim"
ENT.Base 			= "base_bbentity"
//ENT.RenderGroup = RENDERGROUP_TRANSLUCENT


if !SERVER then return end
------------------------------------------------------------------------------------------------
--all server from now on
------------------------------------------------------------------------------------------------


function ENT:Initialize()
	self:SpecialInit()
	
	self:ChangePhysicsModel( self.Ref.model, COLLISION_GROUP_WEAPON, self.Ref.mass )
	
	self.DamageCounter = 0
	self.Gains = 0
	self.Holder = nil
end




--applys all the current stats to the player currently holding the device
function ENT:ApplyGains()
	//print("setting gained damage to:  " .. self.Gains)
	if IsValid(self.Holder) then
		local class = self.Holder.Puck:GetClass()
		local puckref = PuckReference( class )
		
	
		self.Holder:SetGainedDamage( self.Gains )
		
		
		self.Holder.Puck:SetMaxHealth( puckref.health + self.Gains )
		
		--
		local curhealth = self.Holder.Puck:Health()
		if curhealth >= puckref.health  then
			self.Holder.Puck:SetHealth( puckref.health + self.Gains )
		end
		--
	end
end

function ENT:RemoveGains()
	if IsValid(self.Holder) and IsValid(self.Holder.Puck) then
		self.Holder:SetGainedDamage( 0 )
		self.Holder.Puck:ResetMaxHealth()
		
		local class = self.Holder.Puck:GetClass()
		local puckref = PuckReference( class )
	
		self.Holder.Puck:SetMaxHealth( puckref.health )
		
		local curhealth = self.Holder.Puck:Health()
		if curhealth > puckref.health then
			curhealth = puckref.health
		end
		self.Holder.Puck:SetHealth( curhealth )
	end
end



--this is called when damage is dealt by the owners slider
function ENT:Gain( dmg )
	self.DamageCounter = self.DamageCounter + dmg
	
	local gains = RoundNum( self.DamageCounter / self.Ref.damage_interval )
	self.Gains = gains
	
	self:ApplyGains()
	self:Flashy( .1 )
	//self:Puff()
	self:EmitSound( self.Ref.sound_gain )
end



function ENT:Flashy(time)
	self:SetMaterial("models/debug/debugwhite")
	
	timer.Simple( time, function()
		if self != NULL then 
		self:SetMaterial(self.OrigMat)
		end
	end)
	
end


function ENT:Puff()
	local glow = ents.Create( "env_smoketrail" )
		glow:SetPos( self:GetPos() )
		glow:SetOwner( self.Owner )
		glow:SetParent( self )
		glow:Spawn()
		glow:SetKeyValue( "startcolor", "176 255 216" )
		glow:SetKeyValue( "endcolor", "123 185 198" )
		glow:SetKeyValue( "startsize", 15 )
		glow:SetKeyValue( "endsize", 3000 )
		glow:SetKeyValue( "lifetime", 1 )
		glow:SetKeyValue( "opacity", 1 )
		
	timer.Simple( .3, function()
		if not IsValid(glow) then return end
		glow:Remove()
	end)
		
end




function ENT:OnGrab( ply )
	--give the player stat gains
	self.Holder = ply
	self:ApplyGains()
end


function ENT:OnUnGrab()
	--take away stat gains
	if IsValid( self.Holder ) then
		self:RemoveGains()
	end
	self.Holder = nil
end



function ENT:OnRemove()
	if IsValid(self.Holder) then
		self:RemoveGains()
	end
end

--[[
function ENT:Think()
	
	
	
	
	self:NextThink( CurTime() + self.Ref.think_rate )
	return true
end
]]--

