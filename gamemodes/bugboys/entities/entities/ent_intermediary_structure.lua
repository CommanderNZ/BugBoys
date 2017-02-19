AddCSLuaFile("ent_intermediary_structure.lua")

ENT.Type 			= "anim"
ENT.Base 			= "base_bbentity"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT



function ENT:SetCraftForClient( x )
	self:SetNetworkedString("CraftName", x)
end

function ENT:GetCraftForClient()
	return self:GetNetworkedString("CraftName", "-")
end


function ENT:SetCompleteTime( x )
	self:SetNetworkedInt( "CompleteTime", x )
end

function ENT:GetCompleteTime()
	return self:GetNetworkedInt( "CompleteTime", 0 )
end


--client initialize
--[[
function ENT:Initialize()
	:GetCraftForClient()
end

local firstthink = true

function ENT:Think()
	if self.TimerDone == true then return end

	if firstthink == true then
		self:NextThink( CurTime() + 1 )
		firstthink = false
		return true
	end
	
	self.ClientTime = self.ClientTime - 1

	if self.ClientTime <= 0 then
		self.TimerDone = true
	end
	
	self:NextThink( CurTime() + 1 )
	return true
end
]]--




if !SERVER then return end
------------------------------------------------------------------------------------------------
--all server from now on
------------------------------------------------------------------------------------------------
local angle = Angle( 0, 0, 0 )




function ENT:Initialize()
	self:SpecialInit()
	
	
	if self.BBTeam == TEAM_RED then
		self:SetMaterial( self.Ref.special_mat_red )
	elseif self.BBTeam == TEAM_BLUE then
		self:SetMaterial( self.Ref.special_mat_blue )
	end
	
	
	local pos = self:GetPos()
	
	self.OrigPos = pos
	//self.CraftRef = TableReference_Craft( self.Craft )
	self.Ent = self.CraftRef.ent
	self.EntRef = EntReference( self.CraftRef.ent )
	self.CancelCheck = false
	

	self:SetPos( pos + Vector(0,0,self.CraftRef.spawn_height) )
	self:ChangeStaticModel( self.EntRef.model, COLLISION_GROUP_WORLD )
	//self:SetPropCollide( false )
	
	if SERVER then
		self:SetCompleteTime( CurTime() + self.CraftRef.craft_time )
		self:SetCraftForClient( self.CraftRef.name )
	end
	
	--skip the whole construction stuff if this thing instantly builds
	if self.CraftRef.craft_time <= self.Ref.time_cancel_check then
		self:SpawnEnt()
	else
		self:Construct()
	end
end




function ENT:Construct()
	--start the looping build sound
	self.BuildingSound = CreateSound( self, self.Ref.sound_build )
	self.BuildingSound:Play()

	timer.Simple( self.Ref.time_cancel_check, function()
		if not IsValid(self) then return end
		self.CancelCheck = true
	end )

	--build fast if we've been told to build at double speed
	if self.DoubleSpeed == true then
		timer.Simple( self.CraftRef.craft_time/2, function()
			if not IsValid(self) then return end
			self:SpawnEnt()
		end )
	else
		timer.Simple( self.CraftRef.craft_time, function()
			if not IsValid(self) then return end
			self:SpawnEnt()
		end )
	end
end


function ENT:SpawnEnt()
	local newent = ents.Create( self.Ent )
		newent:SetPos( self:GetPos() )
		newent:SetAngles( self:GetAngles() )

		if IsValid( self.Creator ) then
			newent.Creator = self.Creator
		end
		
		--if this structure is being redeployed, set its health to what it was before
		if self.OverrideHealth != nil then
			newent.OverrideHealth = self.OverrideHealth
		end
		
		--if it has no team for some reason, set it to be the team of this ent
		if self.CraftRef.no_team != true then
			newent.BBTeam = self.BBTeam
		end
		
		--if this structure is being redeployed, tell the swep its completed
		if self.RedeployCallback != nil then
			self:RedeployCallback_Finish( self.RedeployCallback )
		end
		
		self:EmitSound(self.Ref.sound_craft)
		newent:Spawn()
		self:Remove()
end

--calls back to the swep which created it, telling it the build never completed so it must go back to inventory
--this is just used by climber with its "redeploy" ability
function ENT:RedeployCallback_Cancel( swep )
	if not IsValid( swep ) then return end
	swep:RedeployCallback_Cancel( self.Ent, self.OverrideHealth )
end


--calls back to the swep which created it, telling it the build never completed so it must go back to inventory
function ENT:RedeployCallback_Finish( swep )
	if not IsValid( swep ) then return end
	swep:RedeployCallback_Finish()
end


//if x is true then it will return the tokens MINUS one, so when enemies cancel, you lose a token
function ENT:Cancel( x )
	if self.RedeployCallback == nil then
		--take away 1 token, if an enemy cancelled the build
		if IsValid( self.Creator ) then
			if x == true then
				self.Creator:AddTokens( self.CraftRef.crystals_required - 1 )
			else
				self.Creator:AddTokens( self.CraftRef.crystals_required )
			end
		end
	else
		self:RedeployCallback_Cancel( self.RedeployCallback )
	end
	self:EmitSound( self.Ref.sound_cancel )
	self:Remove()
end


function ENT:OnRemove()
	--only cancel it if it ever started to begin with, and it didnt if it was an insta-build structure
	if self.CraftRef.craft_time > self.Ref.time_cancel_check then
		self.BuildingSound:Stop()
	end
end




function ENT:CheckIfInWall( dist )
	local function DoTraceTo(vec)
		local vecn = vec:GetNormal()
		local pos = self:GetPos()
		if self.EntRef.raise_checkpos == true then
			pos = self:GetPos() + Vector(0,0,28)
		end
		
		local tracedata = {}
		tracedata.start = pos
		tracedata.endpos = pos + (Vector(vecn.x, vecn.y, vecn.z) * dist)
		tracedata.filter = self
		
		local trace = util.TraceLine(tracedata)
		
		--if it didnt hit anything, we have nothing to do
		local hit = trace.Hit
		if not hit then
			return false
		end
		
		local hitnonworld = trace.HitNonWorld
		local hitworld = trace.HitWorld
		local ent = trace. Entity
		if hitnonworld then
			if ent:GetPhysicsObject():IsMotionEnabled() != true then
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
			return true
		end
	end
	
	return false
end


ENT.FirstThink = true

function ENT:Think()
	if self.CancelCheck == true then
		local orgin_ents = ents.FindInSphere( self:GetPos(), self.EntRef.size )
		
		if self.CraftRef.box_collision == true then
			//orgin_ents = ents.FindInBox( self.CraftRef.box_mins, self.CraftRef.box_maxs )
			local mins = self:OBBMins() * .7
			local maxs = self:OBBMaxs() * .7
			orgin_ents = ents.FindInBox( self:LocalToWorld( mins ), self:LocalToWorld( maxs ) )
		end
		
		if self.CraftRef.cant_into_walls == true and self.FirstThink == true then
			if self:CheckIfInWall( self.CraftRef.cant_into_walls_dist ) then
				if IsValid( self.Creator ) then
					self.Creator:ChatPrint("Can't build here, it's too close to something!")
				end
				self:Cancel()
			end
		end
		self.FirstThink = false 
		
		
		for k, ent in pairs( orgin_ents ) do
			if ent:GetClass() == "func_bb_healer_red" 
			or ent:GetClass() == "func_bb_healer_blue" 
			or ent:GetClass() == "func_bb_nobuild" then
				self:Cancel()
				
				if ent:GetClass() == "func_bb_nobuild" then
					if IsValid( self.Creator ) then
						self.Creator:ChatPrint("Can't build here, it's a no-build zone")
					end
				end
				break
				
			elseif ent:IsValidPuck() and ent.BBTeam == GetOppositeTeam( self.BBTeam ) then
				self:Cancel( true )
				break
				
			end
		end
	end
	
	
	--normally its around .25
	self:NextThink( CurTime() + .1 )
	return true
end

function ENT:PhysicsCollide( data, phys )

end




function ENT:RayTrigger( activator )
	if !SERVER then return end
	if activator != self.Creator then return end
	activator:ChatPrint( "Cancelled building" )
	self:Cancel()
end


