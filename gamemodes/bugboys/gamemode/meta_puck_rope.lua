local PuckEnt = FindMetaTable("Entity")






--function which controls the rope ability
function PuckEnt:DoRope()
	//if true then return end

	local enemyteam = self:GetEnemyTeam()
	
	local function RopeTo( ent, hitpos, physbone )
		--Rope setup code--
		local forcelimit = 0;
		local addlength     = 0;
		local material      = "cable/cable2"
		local width      = 3;
		local rigid         = false;
					 
		local Ent1 = self
		local Ent2 = ent
		local Bone1, Bone2 = 0, physbone
		local WPos1, WPos2 = self:GetPos(), hitpos
		local LPos1, LPos2 = self:WorldToLocal(WPos1), ent:WorldToLocal(WPos2)
		local length = (WPos2 - WPos1):Length()
		
		local constraint, rope = constraint.Rope( Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, length, addlength, forcelimit, width, material, rigid )	
		
		self:EmitSound( SOUND_ROPE_MAKE )
	end
	
	local function RopeEnt( ent, hitpos, physbone )
		if ent != self and ent.BBTeam != enemyteam then
			if CheckIfInEntTable(ent) then
				
				--the ent must be respawned if its frozen
				if ent:FrozenStatus() == true then
					ent = ent:RespawnSelf()
				end
			
				--add something that checks if its already in the list
				table.insert( self.RopedEntList, ent )
				
				RopeTo( ent, hitpos, physbone )
				
			elseif ent:IsValidPuck() then
				RopeTo( ent, hitpos, physbone )
			end
		end
	end	

	local function UnropeEnts()
		--[[
		for k, ent in pairs( self.RopedEntList ) do
			if IsValid(ent) then
				constraint.RemoveConstraints( ent, "Rope" )
				ent:OnUnGrab( self )  --doesnt do anything, just activates the ent's OnUnGrab function, if it has it
			end
		end
		]]--
		//constraint.RemoveConstraints( self, "Rope" )
		constraint.RemoveAll( self )
		table.Empty( self.RopedEntList )
		
		self:EmitSound( SOUND_ROPE_REMOVE )
	end	
	
	
	if (self.Owner:KeyDown(IN_USE)) then
		if (self.RopeTimer < CurTime()) then
			local Aim = self.Owner:EyeAngles()
			local pos = self:GetPos() + (Aim:Up() * ( self.Ref.cam_height - 1))
			local ang = self.Owner:GetAimVector()
			local tracedata = {}
			tracedata.start = pos
			tracedata.endpos = pos+(ang * self.Ref.rope_length)
			tracedata.filter = self, self.Owner
			
			local trace = util.TraceLine(tracedata)
			
			
			--make sure the rope is hitting an entity
			--if not, remove all ropes
			if not IsValid( trace.Entity ) then 
				UnropeEnts()
				self.RopeTimer = CurTime() + .5
				return 
			end
			
			--make sure its ok, then rope it
			if trace.Entity:GetClass() != "ent_intermediary_structure" and !(trace.Entity:GetIfStatic()) then
				RopeEnt( trace.Entity, trace.HitPos, trace.PhysicsBone )
			end
			
			self.RopeTimer = CurTime() + .5
		end
	end
end









--function which controls the rope ability
function PuckEnt:DoRopeWorld()
	local enemyteam = self:GetEnemyTeam()
	
	local function RopeTo( ent, hitpos, physbone )
		--Rope setup code--
		local forcelimit = 0;
		local addlength     = 0;
		local material      = "cable/cable2"
		local width      = 3;
		local rigid         = false;
					 
		local Ent1 = self
		local Ent2 = ent
		local Bone1, Bone2 = 0, physbone
		local WPos1, WPos2 = self:GetPos(), hitpos
		local LPos1, LPos2 = self:WorldToLocal(WPos1), ent:WorldToLocal(WPos2)
		local length = (WPos2 - WPos1):Length()
		
		local constraint, rope = constraint.Rope( Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, length, addlength, forcelimit, width, material, rigid )	
	end
	
	local function RopeEnt( ent, hitpos, physbone )
		if ent != self and ent.BBTeam != enemyteam then
			if CheckIfInEntTable(ent) then
				--doesnt do anything, just activates the ent's OnGrab function, if it has it
				ent:OnGrab( self )
				
				--the ent must be respawned if its frozen
				if ent:FrozenStatus() == true then
					ent = ent:RespawnSelf()
				end
			
				--add something that checks if its already in the list
				table.insert( self.RopedEntList, ent )
				
				RopeTo( ent, hitpos, physbone )
				
			elseif ent:IsValidPuck() then
				RopeTo( ent, hitpos, physbone )
			end
		end
	end	

	local function UnropeEnts()
		--[[
		for k, ent in pairs( self.RopedEntList ) do
			if IsValid(ent) then
				constraint.RemoveConstraints( ent, "Rope" )
				ent:OnUnGrab( self )  --doesnt do anything, just activates the ent's OnUnGrab function, if it has it
			end
		end
		]]--
		constraint.RemoveConstraints( self, "Rope" )
		table.Empty( self.RopedEntList )
	end	
	
	
	if (self.Owner:KeyDown(IN_USE)) then
		if (self.RopeTimer < CurTime()) then
			local Aim = self.Owner:EyeAngles()
			local pos = self:GetPos() + (Aim:Up() * ( self.Ref.cam_height - 1))
			local ang = self.Owner:GetAimVector()
			local tracedata = {}
			tracedata.start = pos
			tracedata.endpos = pos+(ang * self.Ref.rope_length)
			tracedata.filter = self, self.Owner
			
			local trace = util.TraceLine(tracedata)
			
			
			--make sure the rope is hitting an entity
			--if not, remove all ropes
			--[[
			if not IsValid( trace.Entity ) then 
				UnropeEnts()
				self.RopeTimer = CurTime() + .5
				return 
			end
			]]--
			local hitent = trace.Entity
			print(hitent)
			
			--make sure its ok, then rope it
			//if trace.Entity:GetClass() != "ent_intermediary_structure" and !(trace.Entity:GetIfStatic()) then
				RopeTo( trace.Entity, trace.HitPos, trace.PhysicsBone )
			//end
			
			self.RopeTimer = CurTime() + .5
		end
	end
end
