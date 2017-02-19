AddCSLuaFile("structure_elevator_beam.lua")

DEFINE_BASECLASS( "base_anim" )

//ENT.Type 			= "anim"
//ENT.Base 			= "base_bbentity"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

//if !SERVER then return end
------------------------------------------------------------------------------------------------
--all server from now on
------------------------------------------------------------------------------------------------




function ENT:Initialize()
	if !SERVER then return end

	self:DrawShadow( false )
	
	self:SetModel( "models/bugboys/elevator_beam.mdl" )
	self:SetCollisionGroup( COLLISION_GROUP_IN_VEHICLE )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	local phys = self:GetPhysicsObject()
		phys:EnableMotion(false)
	
	
	local red = Color(239,210,210,255)
	local blue = Color(200,200,239,255)

	if self.BBTeam == TEAM_BLUE then
		self:SetColor( blue ) 
	else
		self:SetColor( red ) 
	end

	
	
	self.OrigMat = self:GetMaterial()
end



function ENT:Think()
	if !SERVER then return end

	local mins = self:OBBMins() * .6
	local maxs = self:OBBMaxs() * .6
	local orgin_ents = ents.FindInBox( self:LocalToWorld( mins ), self:LocalToWorld( maxs + Vector( 0,0,200 ) ) )
	
	for k, ent in pairs( orgin_ents ) do
		if ent:IsValidPlyBug() and ent.BBTeam == self.BBTeam then
			local vel = ent:GetVelocity( )
			local veloz = Vector(0,0,vel.z)
			local vert_speed = veloz:Length()
			if veloz.z < 0 then
				vert_speed = -vert_speed
			end
			
			self.Force = 900
			
			local force = ( self.Force - vert_speed) * 16
			local phys = ent:GetPhysicsObject()
				phys:ApplyForceCenter( Vector(0,0,1) * force )
		end
	end
	
	self:NextThink( CurTime() + .1 )
	return true
end
