AddCSLuaFile("ent_sphere.lua")

DEFINE_BASECLASS( "base_anim" )

//ENT.Type 			= "anim"
//ENT.Base 			= "base_bbentity"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

//if !SERVER then return end
------------------------------------------------------------------------------------------------
--all server from now on
------------------------------------------------------------------------------------------------



--make the ent some level of transparency
function ENT:Transparency_Set( num )
	if num < 255 then
		self:SetRenderMode( RENDERMODE_TRANSALPHA )
	else
		self:SetRenderMode( RENDERMODE_NORMAL )	
	end
	
	local color = Color( 255,255,255, num )
	self:SetColor( color ) 
end


function ENT:Initialize()
	if !SERVER then return end

	self:DrawShadow( false )
	
	self:SetModel( "models/bugboys/sphere100.mdl" )
	self:SetCollisionGroup( COLLISION_GROUP_IN_VEHICLE )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	local phys = self:GetPhysicsObject()
		phys:EnableMotion(false)
	
	if self.BBTeam == TEAM_BLUE then
		self:SetSkin( 1 )
		self:SetMaterial( "bugboys/sphere_blue" )
	else
		self:SetSkin( 0 )
		self:SetMaterial( "bugboys/sphere_red" )
	end
	
	self:Transparency_Set( 150 )
	
	self.OrigMat = self:GetMaterial()
end


