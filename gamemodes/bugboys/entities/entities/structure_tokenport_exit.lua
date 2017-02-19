AddCSLuaFile("structure_tokenport_exit.lua")

ENT.Type 			= "anim"
ENT.Base 			= "base_bbentity"
//ENT.RenderGroup = RENDERGROUP_TRANSLUCENT



function ENT:SetPartnerEnt( ent )
	//if SERVER then
		self.EntranceEnt = ent
	//end
	self:SetNWEntity( "Partner", ent ) 
end

function ENT:GetPartnerEnt()
	return self:GetNWEntity( "Partner", nil ) 
end




if !SERVER then return end
------------------------------------------------------------------------------------------------
--all server from now on
------------------------------------------------------------------------------------------------
local angle = Angle( 0, 0, 0 )

ENT.EntranceEnt = nil

function ENT:Initialize()
	self:SpecialInit()

	self:ChangePhysicsModel( self.Ref.model, COLLISION_GROUP_WEAPON, self.Ref.mass )
	local phys = self:GetPhysicsObject()
		phys:EnableMotion(false)
	
	self.LastSpawnedToken = nil
end




--token sends this call back when its picked up, so we can know its space is now open
function ENT:TokenCallback( putoken )
	if putoken == self.LastSpawnedToken then
		self.LastSpawnedToken = nil
	end
end



function ENT:Import( amount )

	--add to the current tokens amount, so the token is worth 1 more
	if self.LastSpawnedToken != nil and IsValid(self.LastSpawnedToken) then
		self.LastSpawnedToken:AddInstance( amount )
	
	
	else
		local newent = ents.Create( self.Ref.created_ent )
			newent:SetPos( self:GetPos() + Vector(0,0,self.Ref.token_height) )
			newent:SetAngles( self:GetAngles() )
			if IsValid( self.Creator ) then
				newent.Creator = self.Creator
			end
			newent.Generator = self
			newent.Amount = amount
			newent:Spawn()
			
			//local add = amount - 1
			//newent:AddInstance( add )
			
		self.LastSpawnedToken = newent	
	end
	
	self:Puff( self:GetPos() + Vector(0,0,self.Ref.token_height) )
	self:EmitSound(self.Ref.sound_craft)
end





--called by the parter ent when its killed, so this one dies too
function ENT:PartnerDestroyed()
	self:Break()
end


function ENT:OnRemove()
	if IsValid( self.ExitEnt ) then
		self.EntranceEnt:PartnerDestroyed()
	end
end


--cannot teleport when one of the teleporters isnt placed on the ground
function ENT:OnGrab()
	self.Disabled = true
end

function ENT:OnUnGrab()
	self.Disabled = false
end

