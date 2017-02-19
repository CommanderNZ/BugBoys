AddCSLuaFile( "ent_crystal_spawnonce.lua" )

DEFINE_BASECLASS( "base_anim" )

ENT.PrintName		= ""
ENT.Author			= ""
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""

ENT.Spawnable			= false
ENT.AdminSpawnable		= false


function ENT:Initialize()
	self:DrawShadow(false)
end


function ENT:Draw()
	return false
end


//function ENT:Think()
//end



//for _, v in pairs(player.GetAll()) do
	//v:PrintMessage(HUD_PRINTTALK, entity:GetName().. " has entered the lua brush area.")
//end
