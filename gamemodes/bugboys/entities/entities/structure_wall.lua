AddCSLuaFile("structure_wall.lua")

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
	
	//self:Transparency_Set( 200 )
	self:ChangeStaticModel( self.Ref.model, COLLISION_GROUP_WEAPON )
	self:EmitSound( self.Ref.sound_collisionson )
end

--triggers the block to go unsolid for a moment, only possible while frozen
function ENT:RayTrigger( activator )
	if !SERVER then return end
	
	--if on cooldown..
	if self.TriggerCooldownTimer > CurTime() then 
		local timeleft = self.TriggerCooldownTimer -  CurTime()
		activator:ChatPrint( "Ability on cooldown:  " .. RoundNum( timeleft, 1 ) .. " seconds left.." )
		activator:PlayLocalSound( "Sound_Failed" )
		return 
	
	--if NOT on cooldown and NOT currently active..
	elseif self.TriggerCooldownTimer < CurTime() and self.Triggered != true  then  
		self:Transparency_Set( 100 )
		
		//self:SetPropCollide( false )
		self:SetCollisionGroup( COLLISION_GROUP_IN_VEHICLE )
		self:Activate()
		
		
		self:EmitSound( self.Ref.sound_collisionsoff )
		self.Triggered = true
		
		
		
		timer.Simple( self.Ref.trigger_duration, function()
			if not IsValid(self) then return end

			self:EmitSound( self.Ref.sound_collisionson )
			//self:Transparency_Set( 200 )
			self:Transparency_Set( 255 )
			
			//self:SetPropCollide( true )
			self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
			self:Activate()
			
			
			self.TriggerCooldownTimer =  CurTime() + self.Ref.trigger_cooldown
			self.Triggered = false
			
			
		end)
	end
end

--[[
function ENT:OnGrab( grabberpuck )
	//print("inserting a grabber " .. grabberpuck:GetClass())
	table.insert( self.Grabbers, grabberpuck )
end

function ENT:OnUnGrab( grabberpuck )
	//print("removing a grabber " .. grabberpuck:GetClass())
	table.RemoveByValue( self.Grabbers, grabberpuck )
end
]]--



--makes the wall kill enemy bugs and vehicles on touch
--[[
function ENT:PhysicsCollide(Data, PhysObj)
	local hitent = Data.HitEntity
	if hitent:IsValidPuck() == true and hitent.BBTeam == GetOppositeTeam( self.BBTeam ) then		
		print("playing sound")
		self:EmitSound("physics/metal/metal_grate_impact_hard"..math.random(1, 3)..".wav", 100, 100)
		
		hitent:HurtEnt( 1000, self, self.Creator )
	end
end	

]]--