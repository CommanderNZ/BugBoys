AddCSLuaFile("structure_tokenport_entrance.lua")

ENT.Type 			= "anim"
ENT.Base 			= "base_bbentity"
//ENT.RenderGroup = RENDERGROUP_TRANSLUCENT





function ENT:SetPartnerEnt( ent )
	//if SERVER then
		self.ExitEnt = ent
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


function ENT:Initialize()
	self:SpecialInit()
	
	self.TriggerCooldownTimer = 0
	
	self:ChangePhysicsModel( self.Ref.model, COLLISION_GROUP_WEAPON, self.Ref.mass )
	local phys = self:GetPhysicsObject()
		phys:EnableMotion(false)
end

function ENT:Teleport( token )
	local amount = token.Amount
	local pos = token:GetPos()
	self.ExitEnt:Import( amount )
	
	token:Remove()
	
	self:Puff( pos )
	self:EmitSound( SOUND_RECALL_FINISH )
	//self.ExitEnt:EmitSound( SOUND_RECALL_APPEAR )
end




function ENT:Think()
	if self.Disabled == true then return end
	if self.ExitEnt.Disabled == true then return end
	
	local orgin_ents = ents.FindInSphere( self:GetPos(), self.Ref.radius )
	
	local token = nil
	for k, ent in pairs( orgin_ents ) do
		if ent:GetClass() == "structure_token" then
			token = ent
		end
	end
	
	if token != nil then
		//timer.Simple( .5, function()
			//if not IsValid( token ) then return end
			
			self:Teleport( token )
		//end)
	end
	
	self:NextThink( CurTime() + 2 )
	return true
end




--called by the parter ent when its killed, so this one dies too
function ENT:PartnerDestroyed()
	self:Break()
end


function ENT:OnRemove()
	if IsValid( self.ExitEnt ) then
		self.ExitEnt:PartnerDestroyed()
	end
end



--cannot teleport when one of the teleporters isnt placed on the ground
function ENT:OnGrab()
	self.Disabled = true
end

function ENT:OnUnGrab()
	self.Disabled = false
end

