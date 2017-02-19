AddCSLuaFile("structure_teleport_exit.lua")

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

	//self:ChangeStaticModel( self.Ref.model, COLLISION_GROUP_WEAPON )
	self:ChangePhysicsModel( self.Ref.model, COLLISION_GROUP_WEAPON, self.Ref.mass )
	
	local phys = self:GetPhysicsObject()
		phys:EnableMotion(false)
end


--[[

function ENT:Think()
	if self.LookForEntrance != true then return end
	if IsValid(self.EntranceEnt) then return end
	
	for k,ent in pairs(ents.GetAll()) do
		if ent.Creator == self.Creator and ent:GetClass() == "structure_teleport_entrance" then
			self.EntranceEnt = ent
			ent:ExitCallback( self )
		end
	end
	

	self:NextThink( CurTime() + 1 )
	return true
end
]]--


--called by the parter ent when its killed, so this one dies too
function ENT:PartnerDestroyed()
	self:Break()
end


function ENT:OnRemove()
	if IsValid( self.EntranceEnt ) then
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

