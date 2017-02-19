AddCSLuaFile( "ent_token_spawn.lua" )

DEFINE_BASECLASS( "base_anim" )

ENT.PrintName		= ""
ENT.Author			= ""
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""

ENT.Spawnable			= false
ENT.AdminSpawnable		= false


function ENT:Draw()
	return false
end


function ENT:Initialize()
	self:DrawShadow(false)
	
	self.LastSpawnedToken = nil
	
end

if !SERVER then return end



--token sends this call back when its picked up, so we can know its space is now open
function ENT:TokenCallback( putoken )
	if putoken == self.LastSpawnedToken then
		self.LastSpawnedToken = nil
	end
end



	


function ENT:SpawnToken()
	--add to the current tokens amount, so the token is worth 1 more
	if self.LastSpawnedToken != nil and IsValid(self.LastSpawnedToken) then
		self.LastSpawnedToken:AddInstance()
	
	
	--if there isnt already a token there, spawn one
	else
		local groundpos = self:GetPos()
		local newent = ents.Create( "structure_token" )
			newent:SetPos( groundpos + Vector(0,0,12) )
			newent:SetAngles( self:GetAngles() )
			if IsValid( self.Creator ) then
				newent.Creator = self.Creator
			end
			newent.Generator = self
			newent:Spawn()
			//print(spot.name)
			
		self.LastSpawnedToken = newent	
	end

		
	self:EmitSound( CRYSTAL_SPAWN_SOUND )
end




