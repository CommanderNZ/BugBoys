AddCSLuaFile( "ent_damagemarker_blue.lua" )

//ENT.Type 	= "point"
//ENT.Base 	= "base_point"
DEFINE_BASECLASS( "base_anim" )


function ENT:Draw()
	return false
end


--this ent marks a position at which a team's structures have recently taken damage
--it shows this position on the hud and announces to the team
function ENT:Initialize()
	self:DrawShadow( false )
	
	
	if !SERVER then return end
	timer.Simple( 15, function()
		if not IsValid(self) then return end
		self:Remove()
	end)
end


