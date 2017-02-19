AddCSLuaFile("marker_pointzone.lua")

ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= ""

if CLIENT then
	function ENT:Draw()
		self.Entity:DrawModel()
	end
end

if !SERVER then return end
------------------------------------------------------------------------------------------------
--all server from now on
------------------------------------------------------------------------------------------------


function ENT:Initialize()
	//SetGlobalVector( "MarkerPos", self:GetPos() )

	self:SetModel("models/bugboys/pointzone.mdl")
	--[[
	if self.BBTeam == TEAM_RED then
		self:SetSkin( 1 )
	elseif self.BBTeam == TEAM_BLUE then
		self:SetSkin( 2 )
	end
	]]--
	self:DrawShadow(false)
	self:SetNotSolid(true)
end


function ENT:PhysicsCollide(data, phys)

end
