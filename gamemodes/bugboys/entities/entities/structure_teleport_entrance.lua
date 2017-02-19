AddCSLuaFile("structure_teleport_entrance.lua")

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
	
	//self:ChangeStaticModel( self.Ref.model, COLLISION_GROUP_WEAPON )
	self:ChangePhysicsModel( self.Ref.model, COLLISION_GROUP_WEAPON, self.Ref.mass )
	
	local phys = self:GetPhysicsObject()
		phys:EnableMotion(false)
end

function ENT:Teleport( ply )
	local bug = ply.Puck
	local exit_pos = (self.ExitEnt:GetPos() + Vector(0,0,150))
	
	constraint.RemoveAll( bug )
	ply:PlayLocalSound( "Sound_Successful" )
	
	//timer.Simple( .5, function()
		//if not IsValid(bug) then return end
		bug:DetachSelfFromVehicle()
		bug:SetPos( exit_pos )
	
		self:EmitSound( SOUND_RECALL_FINISH )
		bug:EmitSound( SOUND_RECALL_APPEAR )
	//end)
end


function ENT:AttemptTeleport( ply )
	local orgin_ents = ents.FindInSphere( self:GetPos(), self.Ref.radius_teleport )
	
	if not IsValid(self.ExitEnt) then
		ply:ChatPrint( "Exit not setup for this teleport!")
		return false
	end
	
	if self.ExitEnt.Disabled == true then
		ply:ChatPrint( "Exit is being held a player right now!")
		return false
	end
	
	
	for k, ent in pairs( orgin_ents ) do
		if ent == ply then
			self:Teleport( ply )
			return true
		end
	end
	
	ply:ChatPrint( "You must stand closer to the teleport!")
	return false
end


function ENT:RayTrigger( activator )
	if !SERVER then return end
	
	--if on cooldown..
	if self.TriggerCooldownTimer > CurTime() then 
		local timeleft = self.TriggerCooldownTimer -  CurTime()
		activator:ChatPrint( "Teleport on cooldown:  " .. RoundNum( timeleft, 1 ) .. " seconds left.." )
		activator:PlayLocalSound( "Sound_Failed" )
		return 
	
	--if NOT on cooldown..
	elseif self.TriggerCooldownTimer < CurTime() then  
		//self:EmitSound( self.Ref.sound_collisionsoff )
		
		if self:AttemptTeleport( activator ) then
			self.TriggerCooldownTimer =  CurTime() + self.Ref.trigger_cooldown
		else
			activator:PlayLocalSound( "Sound_Failed" )
		end
	end
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

