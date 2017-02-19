AddCSLuaFile("structure_bugbrain_shield.lua")

DEFINE_BASECLASS( "base_anim" )

//ENT.Type 			= "anim"
//ENT.Base 			= "base_bbentity"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

//if !SERVER then return end
------------------------------------------------------------------------------------------------
--all server from now on
------------------------------------------------------------------------------------------------

function ENT:GetRef( ver )
	return EntReference( self:GetClass() )
end


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
	self.Ref = self:GetRef()
	
	self:DrawShadow( false )
	
	self:SetModel( self.Ref.model )
	self:SetCollisionGroup( COLLISION_GROUP_WORLD )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	local phys = self:GetPhysicsObject()
		phys:EnableMotion(false)
	
	if self.BBTeam == TEAM_BLUE then
		self:SetSkin( 1 )
	end
	
	self:Transparency_Set( self.Ref.transparency )
	
	self.OrigMat = self:GetMaterial()
end



function ENT:FlashWhite(time)
	self:SetMaterial("models/debug/debugwhite")
	
	timer.Simple( time, function()
		if not IsValid(self) then return end
		self:SetMaterial(self.OrigMat)
	end)
end

