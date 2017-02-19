AddCSLuaFile("structure_elevator.lua")

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
	
	self:EnableBeam()
end



function ENT:OnUnGrab()
	timer.Create( tostring(self) .. "_Timer", 2, 1, function() 
		if not IsValid( self ) then return end
		self:EnableBeam()
	end )
end


function ENT:OnGrab()
	self:DisableBeam()
	timer.Destroy( tostring(self) .. "_Timer" )
end



function ENT:EnableBeam()
	local beam = ents.Create( "structure_elevator_beam" )
		beam:SetPos( self:GetPos() - Vector(0,0,32) )
		beam.BBTeam = self.BBTeam
		beam.Force = self.Ref.force
		beam:Spawn()
		
	self.Beam = beam
end

function ENT:DisableBeam()
	if IsValid( self.Beam ) then
		self.Beam:Remove()
	end
end

function ENT:OnRemove()
	self:DisableBeam()
end


