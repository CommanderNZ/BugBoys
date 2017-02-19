ENT.Type 	= "point"
ENT.Base 	= "base_point"

if !SERVER then return end
------------------------------------------------------------------------------------------------
--all server from now on
------------------------------------------------------------------------------------------------



function ENT:Initialize()
--[[
	local traceworld = {}
	traceworld.start = self:GetPos()
	traceworld.endpos = traceworld.start + (Vector(0,0,-1) * 8000)
	local trw = util.TraceLine(traceworld) // Send the trace and get the results.
	local worldpos1 = trw.HitPos + trw.HitNormal // Set worldpos 1. Add to the hitpos the world normal.
	local worldpos2 = trw.HitPos - trw.HitNormal // Set worldpos 2. Subtract from the hitpos the world normal.
	 
	util.Decal( "Scorch", worldpos1, worldpos2 )

]]--


end

