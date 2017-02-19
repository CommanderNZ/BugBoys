AddCSLuaFile("dev_posmark.lua")

DEFINE_BASECLASS( "base_anim" )

if !SERVER then return end
------------------------------------------------------------------------------------------------
--all server from now on
------------------------------------------------------------------------------------------------


function ENT:Initialize()
	self.Ref = self:GetRef()
	
	self:SetModel( self.Ref.model )
	timer.Simple( 6, function()
		if not IsValid(self) then return end
		self:Remove()
	end)
end
