AddCSLuaFile("structure_jumppad.lua")

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
	
	self.TriggerCooldownTimer = 0

	self:ChangeStaticModel( self.Ref.model, COLLISION_GROUP_WEAPON )
	
	//local phys = self.Entity:GetPhysicsObject()
		//phys:SetAngles( Angle(0, 0, 90))
end





function ENT:AttemptJump( puck )
	local orgin_ents = ents.FindInSphere( self:GetPos(), self.Ref.radius_use )
	
	for k, ent in pairs( orgin_ents ) do
		if ent == puck then
			local phys = ent:GetPhysicsObject()
				phys:SetVelocity( Vector(0,0,1) * self.Ref.force )
			self:EmitSound( self.Ref.sound_jump )	
				
			return true
		end
	end
	
	puck.Owner:ChatPrint( "You must stand closer to use this!")
	return false
end


function ENT:RayTrigger( activator )
	if !SERVER then return end
	
	--if on cooldown..
	if self.TriggerCooldownTimer > CurTime() then 
		local timeleft = self.TriggerCooldownTimer -  CurTime()
		activator:ChatPrint( "Ability on cooldown:  " .. RoundNum( timeleft, 1 ) .. " seconds left.." )
		activator:PlayLocalSound( "Sound_Failed" )
		return 
	
	--if NOT on cooldown..
	elseif self.TriggerCooldownTimer < CurTime() then  
		//self:EmitSound( self.Ref.sound_collisionsoff )
		
		if self:AttemptJump( activator.Puck ) then
			self.TriggerCooldownTimer =  CurTime() + self.Ref.trigger_cooldown
		else
			activator:PlayLocalSound( "Sound_Failed" )
		end
	end
end





function ENT:PhysicsCollide( data, phys )

end


