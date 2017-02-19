AddCSLuaFile("structure_shieldgenerator.lua")

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
	
	//self:ChangePhysicsModel( self.Ref.model, COLLISION_GROUP_WEAPON, self.Ref.mass )
	self:ChangeStaticModel( self.Ref.model, COLLISION_GROUP_WEAPON )
	
	--set to be slidy
	//local phys = self.Entity:GetPhysicsObject()
		//phys:SetMaterial("gmod_ice")
	
	self.Active = true
end


function ENT:OnUnGrab()
	timer.Create( tostring(self) .. "_Timer", self.Ref.time_activate, 1, function() 
		if not IsValid( self ) then return end
		self.Active = true
	end )
end


function ENT:OnGrab()
	self.Active = false
	timer.Destroy( tostring(self) .. "_Timer" )
end



function ENT:Think()
	if self.Active != true then return end

	--deal flat damage to an ent
	local function HealEnt( ent, num )
		local dmginfo = DamageInfo()
			dmginfo:SetDamage( -num )
			dmginfo:SetInflictor( self )
			dmginfo:SetAttacker( self )
		ent:TakeDamageInfo( dmginfo )
	end
	
	--heal ents in the radius
	local orgin_ents = ents.FindInSphere( self:GetPos(), self.Ref.radius )
	
	for k, ent in pairs( orgin_ents ) do
		if ent:IsValidPuck() and ent.BBTeam == self.BBTeam then
			//print("healing" .. ent:GetClass())
			local health = ent:Health()
			local max_hp = ent:GetMaxHP()
			if health <= max_hp then
				//print("healing   sfsdf   " .. health)
				if (health + self.Ref.heal_amount) > max_hp then
					ent:SetHealth( max_hp )
				else
					HealEnt( ent, self.Ref.heal_amount )
					//ent:SetHealth( health + self.Ref.heal_amount )
				end
			end
		
		--[[
		elseif CheckIfInEntTable(ent) and (ent has health add that here) then
			local health = ent:Health()
			local max_hp = ent:GetMaxHP()
			if max_hp != false then
				--add code to heal buildings
			end
		]]--
		end
	end
	
	self:NextThink( CurTime() + self.Ref.heal_rate )
	return true
end

function ENT:PhysicsCollide( data, phys )

end


