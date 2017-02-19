ENT.Type 			= "brush"
ENT.Base 			= "base_anim"
ENT.PrintName		= ""



if !SERVER then return end
------------------------------------------------------------------------------------------------
--all server from now on
------------------------------------------------------------------------------------------------

//ENT.TouchingEntList = {}



function ENT:Initialize()
	self.TouchingEntList = {}
end



function ENT:StartTouch( entity )
end

function ENT:EndTouch( entity )
end

function ENT:Think()
end

