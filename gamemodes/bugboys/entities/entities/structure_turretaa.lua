AddCSLuaFile("structure_turretaa.lua")

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
	
	self.TriggerCooldownTimer = 0
	
	self:ChangeStaticModel( self.Ref.model, COLLISION_GROUP_WEAPON )
	
	self:Transparency_Set( 160 )
end


function ENT:ShootSlider( activator )
	local obj = ents.Create( self.Ref.ent_shoot )

		obj:SetPos( self:GetPos() + Vector(0,0,30))
			
		obj.BBTeam = self.BBTeam
		obj.Creator = self.Creator
		obj.CreatorSwep = self
		
		obj:SetOwner(self.Creator)
		//obj:SetAngles( self.Owner:EyeAngles() )
		obj:Spawn()
		
		obj:NoCollideTeam()
	
	local Aim = activator:GetAimVector():GetNormalized() 

	local Aim_trunc = Aim //Vector(Aim.x, Aim.y, 0)
		Aim_trunc = Aim_trunc:GetNormal()
	
	local phys = obj:GetPhysicsObject()
		phys:EnableGravity(false)	
		phys:SetVelocity( Aim_trunc *  50000000 )
		
	self:EmitSound( self.Ref.sound_shoot )
end




function ENT:RayTrigger( activator )
	if !SERVER then return end
	
	--if on cooldown..
	if self.TriggerCooldownTimer > CurTime() then 
		//local timeleft = self.TriggerCooldownTimer -  CurTime()
		//activator:ChatPrint( "Ability on cooldown:  " .. RoundNum( timeleft, 1 ) .. " seconds left.." )
		//activator:PlayLocalSound( "Sound_Failed" )
		return 
	
	--if NOT on cooldown..
	elseif self.TriggerCooldownTimer < CurTime() then  

		self:ShootSlider( activator )
		self.TriggerCooldownTimer =  CurTime() + self.Ref.trigger_cooldown
	end
end





function ENT:PhysicsCollide( data, phys )

end


