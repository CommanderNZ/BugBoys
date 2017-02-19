ENT.Type 	= "point"
ENT.Base 	= "base_point"

--time to count down from
ENT.Time = nil

ENT.GlobalIntName = nil


if !SERVER then return end
------------------------------------------------------------------------------------------------
--all server from now on
------------------------------------------------------------------------------------------------

function ENT:Initialize()
	SetGlobalInt( self.GlobalIntName, self.Time )
end


local firstthink = true

--thinks every second
function ENT:Think()
	if firstthink == true then
		self:NextThink( CurTime() + 1 )
		firstthink = false
		return true
	end
	
	self.Time = self.Time - 1
	SetGlobalInt( self.GlobalIntName, self.Time )
	
	if self.Time <= 0 then
		self:Remove()
	end
	
	self:NextThink( CurTime() + 1 )
	return true
end


