AddCSLuaFile("structure_quickport.lua")

ENT.Type 			= "anim"
ENT.Base 			= "base_bbentity"
//ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

if !SERVER then return end
------------------------------------------------------------------------------------------------
--all server from now on
------------------------------------------------------------------------------------------------
local angle = Angle( 0, 0, 0 )


function ENT:Initialize()
	self:SpecialInit()
	
	self:ChangeStaticModel( self.Ref.model, COLLISION_GROUP_WEAPON )
	
	self.Active = true
	self.TriggerCooldownTimer = 0
end

//self:EmitSound( SOUND_RECALL_FINISH )


function ENT:AttemptPort( puck )
	local orgin_ents = ents.FindInSphere( self:GetPos(), self.Ref.radius )
	
	for k, ent in pairs( orgin_ents ) do
		if ent == puck then
			puck:DetachSelfFromVehicle()
			puck:SetPos( self:GetPos() + Vector(0,0,50) )
			self:EmitSound( SOUND_RECALL_FINISH )	
			
			return true
		end
	end
	
	puck.Owner:ChatPrint( "You must stand closer!")
	return false
end


function ENT:RayTrigger( activator )
	if !SERVER then return end
	if self.Active != true then return end
	
	--if on cooldown..
	if self.TriggerCooldownTimer > CurTime() then 
		local timeleft = self.TriggerCooldownTimer -  CurTime()
		activator:ChatPrint( "Ability on cooldown:  " .. RoundNum( timeleft, 1 ) .. " seconds left.." )
		activator:PlayLocalSound( "Sound_Failed" )
		return 
	
	--if NOT on cooldown..
	elseif self.TriggerCooldownTimer < CurTime() then  
		if self:AttemptPort( activator.Puck ) then
			self.TriggerCooldownTimer =  CurTime() + self.Ref.trigger_cooldown
		else
			activator:PlayLocalSound( "Sound_Failed" )
		end
	end
end


function ENT:OnUnGrab()
	self.Active = true
end


function ENT:OnGrab()
	self.Active = false
end


