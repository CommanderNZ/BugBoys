AddCSLuaFile("structure_tokengenerator.lua")

ENT.Type 			= "anim"
ENT.Base 			= "base_bbentity"
//ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

if !SERVER then return end
------------------------------------------------------------------------------------------------
--all server from now on
------------------------------------------------------------------------------------------------
local angle = Angle( 0, 0, 0 )


function ENT:Initialize()
	self:SpecialInit()
	
	self:ChangeStaticModel( self.Ref.model, COLLISION_GROUP_WEAPON )
	
	--[[
	self.PosTable = 
	{
	Pos1 ={ name = "Pos1", vector = Vector(0,-64,0), token = nil, tier = 1,},
	Pos2 ={ name = "Pos2", vector = Vector(0,64,0), token = nil, tier = 1,},
	Pos3 ={ name = "Pos3", vector = Vector(64,0,0), token = nil, tier = 1,},
	Pos4 ={ name = "Pos4", vector = Vector(-64,0,0), token = nil, tier = 1,},
	Pos5 ={ name = "Pos5", vector = Vector(64,64,0), token = nil, tier = 1,},
	Pos6 ={ name = "Pos6", vector = Vector(-64,-64,0), token = nil, tier = 1,},
	Pos7 ={ name = "Pos7", vector = Vector(-64,64,0), token = nil, tier = 1,},
	Pos8 ={ name = "Pos8", vector = Vector(64,-64,0), token = nil, tier = 1,},
	
	Pos9 ={ name = "Pos9", vector = Vector(0,-96,0), token = nil, tier = 2,},
	Pos10 ={ name = "Pos10", vector = Vector(0,96,0), token = nil, tier = 2,},
	Pos11 ={ name = "Pos11", vector = Vector(96,0,0), token = nil, tier = 2,},
	Pos12 ={ name = "Pos12", vector = Vector(-96,0,0), token = nil, tier = 2,},
	Pos13 ={ name = "Pos13", vector = Vector(96,96,0), token = nil, tier = 2,},
	Pos14 ={ name = "Pos14", vector = Vector(-96,-96,0), token = nil, tier = 2,},
	Pos15 ={ name = "Pos15", vector = Vector(-96,96,0), token = nil, tier = 2,},
	Pos16 ={ name = "Pos16", vector = Vector(96,-96,0), token = nil, tier = 2,},
	}
	]]--
	
	self.LastSpawnedToken = nil
	
	
	timer.Simple( self.Ref.time_interval, function()
		if not IsValid(self) then return end
		self.Generating = true
	end)
end


--[[
function ENT:CheckIfNearWalls()
	local function DoTraceTo(vec)
		local vecn = vec:GetNormal()
		local pos = self:GetPos()
		local tracedata = {}
		tracedata.start = pos
		tracedata.endpos = pos + (Vector(vecn.x, vecn.y, vecn.z) * 100)
		tracedata.filter = self
		
		local trace = util.TraceLine(tracedata)
		
		--if it didnt hit anything, we have nothing to do
		local hit = trace.Hit
		if not hit then
			return false
		end
		
		--cannot attach to sky
		local hitsky = trace.HitSky
		if hitsky then
			return false
		end
		
		local hitnonworld = trace.HitNonWorld
		local hitworld = trace.HitWorld
		local ent = trace. Entity
		//print( ent )
		
		if hitnonworld then
			if CheckIfInEntTable( ent ) and ent:GetIfStatic() then
				return true
			else
				return false
			end
			
		elseif hitworld then
			return true
		end
		
		return false
	end

	local vec_list = 
	{
	Vector(1,0,0),
	Vector(-1,0,0),
	Vector(0,1,0),
	Vector(0,-1,0),
	
	Vector(1,1,0),
	Vector(-1,-1,0),
	Vector(1,-1,0),
	Vector(-1,1,0),
	}

	for _,vec in pairs(vec_list) do
		local tracer = DoTraceTo( vec )
		if tracer then
			self.MustSpawnAbove = true
			//print( "must spawn above is TRUE" )
			return
		end
	end
	self.MustSpawnAbove = false
end
]]--



--[[

function ENT:RayTrigger( activator )
	if !SERVER then return end
	
end
]]--



--token sends this call back when its picked up, so we can know its space is now open
function ENT:TokenCallback( putoken )
	--[[
	for _, pos in pairs( self.PosTable ) do
		if pos.token == putoken then
			pos.token = nil
		end
	end
	]]--
	
	if putoken == self.LastSpawnedToken then
		self.LastSpawnedToken = nil
	end
end

--[[
--returns a positiom for the ent to spawn in, next to the generator
function ENT:GetOpenPos()
	local spot = { vector = Vector(0,0,60), name = "topspot" }
	return spot
end


--returns a positiom for the ent to spawn in, next to the generator
function ENT:AddTokenToTable( posname, tokenadd )
	for _, pos in pairs( self.PosTable ) do
		if pos.name == posname then
			pos.token = tokenadd
		end
	end
end
]]--


function ENT:Think()
	if self.Generating != true then return end

	
	--add to the current tokens amount, so the token is worth 1 more
	if self.LastSpawnedToken != nil and IsValid(self.LastSpawnedToken) then
		self.LastSpawnedToken:AddInstance()
	
	
	else
		local groundpos = self:GetPos() + Vector(0,0,self.Ref.spawn_height)
		
		local newent = ents.Create( self.Ref.created_ent )
			newent:SetPos( groundpos + Vector(0,0,self.Ref.token_height) )
			newent:SetAngles( self:GetAngles() )
			if IsValid( self.Creator ) then
				newent.Creator = self.Creator
			end
			newent.Generator = self
			newent:Spawn()
			//print(spot.name)
			
		self.LastSpawnedToken = newent	
	end
	
	self:EmitSound(self.Ref.sound_craft)
	self:NextThink( CurTime() + self.Ref.time_interval )
	return true
end


function ENT:PhysicsCollide( data, phys )

end


