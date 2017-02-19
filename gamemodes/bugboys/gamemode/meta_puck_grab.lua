local PuckEnt = FindMetaTable("Entity")







function PuckEnt:UnGrab( keep_pos )
	local ent = self.CurGrabbedEnt

	if IsValid( ent ) then
		local entref = EntReference( ent:GetClass() )
		
		
		--make sure we arent in spawn
		if self:IsInFountain() then
			self.Owner:ChatPrint( "Cannot place structures in spawn!" )
			return
		end
		
		--make sure we arent in the air if its angular, and set its angles
		if entref.angular == true then
			if entref.doesnt_need_to_be_on_ground == true then
				ent:SetAngles( Angle(0,0,0) )
		
			else
				if not self:GetIfOnGround( 40, {ent} ) then
					self.Owner:ChatPrint( "This structure must be placed on the ground!" )
					return
				end
				ent:SetAngles( Angle(0,0,0) )
			end
			
			
		end
	
		ent:SetModel( ent.RealModel )
	
	
		--if the ent is currently parented to a vehicle
		if ent:GetParent() != self then
			local vehicle = ent:GetParent()
			vehicle:DetachBox( self )
			
			--make the box not collide with the flying vehicle, so its easier to drop
			if vehicle:GetClass() == "structure_blimp" or vehicle:GetClass() == "structure_chopper" then 
				ent:NoCollideEnt( vehicle )
				local phys = ent:GetPhysicsObject()
					phys:SetVelocity( vehicle:GetVelocity() * 1 )
			end
		end
	
		//ent:SetMoveType( MOVETYPE_VPHYSICS )
		ent:SetParent( nil )
		if not ent:IsInWorld() then
			//print("ITS NOT OK")
		end
		
		

		//local Aim = self.Owner:EyeAngles()
		//local pos = puckpos + (Aim:Up() * ( puckref.cam_height - 1))
		local ang = self.Owner:GetAimVector()
		ang = Vector(ang.x,ang.y,0)
		ang = ang:GetNormal()
		
		local tracedata = {}
			tracedata.start = self:GetPos()
			tracedata.endpos = self:GetPos() + (ang * self.Ref.ungrab_dist)
			tracedata.filter = { self, self.Owner, ent }
		local trace = util.TraceLine(tracedata)
		
		local hitent = trace.Entity
		local hitpos = trace.HitPos
		

		if IsValid( hitent ) or hitent:IsWorld() or keep_pos == true then
			ent:SetPos( ent:GetPos() + Vector(0,0,0) )
		else
			ent:SetPos( hitpos + Vector(0,0,20) )
		end
		

		local phys = ent:GetPhysicsObject()
		if IsValid( phys ) then
			phys:Wake()
		end
			
		//ent:Transparency_Set( 255 )
		ent:SetIfBeingGrabbed( false )
		ent:OnUnGrab()
		
		self.CurGrabbedEnt = nil
		self.Grabbing = false
		
		//local velo = self:GetVelocity()
			//phys:SetVelocity( velo )
			
		//ent:SetPos( self:GetPos() + Vector(0,0,40) )
	
		
		//constraint.RemoveConstraints( ent, "Weld" )
		
	end
	//table.Empty( self.GrabbedEntList )
end



--[[
function PuckEnt:UnGrab_FromTank()
	self.CurGrabbedEnt:DetachPuck( self )

	self:SetParent( nil )
	self:SetPos( self:GetPos() )
	
	local phys = self:GetPhysicsObject()
		phys:Wake()
	
	//self:Transparency_Set( 255 )
	
	self.CurGrabbedEnt = nil
	self.Grabbing = false
end
]]--

--controls the phase fuse ability
function PuckEnt:DoGrab()
	//if true then return end
	local enemyteam = self:GetEnemyTeam()
	
	
	local function WeldEnts()
		local orgin_ents = ents.FindInSphere( self:GetPos(), self.Ref.radius_weld )
		for k, ent in pairs( orgin_ents ) do
		
			--make sure the ent isnt a projectile, cant grab those
			local isproj = false
			if CheckIfInEntTable( ent ) then
				entref = EntReference(ent:GetClass())
				isproj = entref.is_projectile
			end
			
			if ent != self and CheckIfInEntTable(ent) and isproj != true and ent.BBTeam != enemyteam 
				and ent:GetIfStatic() != true and ent:GetIfCanGrab() != false and ent:GetIfBeingGrabbed() != true then
				//print(ent:GetClass())
			
				local phys = self:GetPhysicsObject()
				local angle = self:GetAngles()
				local vec = phys:LocalToWorld( Vector(0,-25,0) )
				if angle.z > 0 then
					vec = phys:LocalToWorld( Vector(0,25,0) )
				end
				

				//ent:SetPos( self:GetPos() + Vector(0,0,25) )
				ent:SetPos( vec )
				ent:SetAngles(self:GetAngles())
				ent:SetParent( self )
				//ent:Transparency_Set( 130 ) --120
				
				ent.RealModel = ent:GetModel()
				
				ent:SetModel( "models/bugboys/box01_tiny.mdl" )
				
				ent:SetIfBeingGrabbed( true )
				ent:OnGrab( self.Owner )
				
				--turning this off for now to see if it stops crashes
				//ent:SetPos(ent:GetPos() + Vector(0,0,5))
				
				
				self.CurGrabbedEnt = ent
				
				//table.insert( self.GrabbedEntList, ent )
				self.Grabbing = true
				self.GrabSetSpecialAng = true
				return
			end
		end
	end	
	
	
	if (self.Owner:KeyDown(IN_USE)) then
		if (self.GrabTimer < CurTime()) then
			if self.CurGrabbedEnt == nil or IsValid( self.CurGrabbedEnt ) != true then
				
				if self.JumpEnabled != false then
					WeldEnts()
				end
				
				if self.Grabbing == true then
					self:EmitSound( SOUND_GRAB )
				else
					self:EmitSound( SOUND_ATTEMPT )
				end
				
			elseif self.CurGrabbedEnt != nil and IsValid( self.CurGrabbedEnt ) then 
				self:UnGrab()
				if self.Grabbing == false then
					self:EmitSound( SOUND_UNGRAB )
				else
					self:EmitSound( SOUND_ATTEMPT )
				end
				
			end
			
			self.GrabTimer = CurTime() + .4
		end
	end
	
	--[[
	if self:GetClass() == "puck_jetpack" then
		local phys = self.Entity:GetPhysicsObject()
			phys:AddAngleVelocity( -1 * phys:GetAngleVelocity( )) 
		return
	end
	]]--
	
	

end




--[[

function PuckEnt:UnGrab( keep_pos )
	local ent = self.CurGrabbedEnt

	if IsValid( ent ) then
		local entref = EntReference( ent:GetClass() )
		
		--make the ent straight, for stuff like teleports
		if entref.angular == true then
			ent:SetAngles( Angle(0,0,0) )
		end
	
		ent:SetModel( ent.RealModel )
	
		//ent:SetMoveType( MOVETYPE_VPHYSICS )
		ent:SetParent( nil )
		if not ent:IsInWorld() then
			//print("ITS NOT OK")
		end
		
		

		//local Aim = self.Owner:EyeAngles()
		//local pos = puckpos + (Aim:Up() * ( puckref.cam_height - 1))
		local ang = self.Owner:GetAimVector()
		ang = Vector(ang.x,ang.y,0)
		ang = ang:GetNormal()
		
		local tracedata = {}
			tracedata.start = self:GetPos()
			tracedata.endpos = self:GetPos() + (ang * self.Ref.ungrab_dist)
			tracedata.filter = { self, self.Owner, ent }
		local trace = util.TraceLine(tracedata)
		
		local hitent = trace.Entity
		local hitpos = trace.HitPos
		

		if IsValid( hitent ) or hitent:IsWorld() or keep_pos == true then
			ent:SetPos( ent:GetPos() + Vector(0,0,0) )
		else
			ent:SetPos( hitpos + Vector(0,0,20) )
		end
		

		local phys = ent:GetPhysicsObject()
		if IsValid( phys ) then
			phys:Wake()
		end
			
		//ent:Transparency_Set( 255 )
		ent:SetIfBeingGrabbed( false )
		ent:OnUnGrab()
		
		self.CurGrabbedEnt = nil
		self.Grabbing = false
		
	end
	//table.Empty( self.GrabbedEntList )
end



function PuckEnt:Grab()
	local orgin_ents = ents.FindInSphere( self:GetPos(), self.Ref.radius_weld )
	for k, ent in pairs( orgin_ents ) do
	
		--make sure the ent isnt a projectile, cant grab those
		local isproj = false
		if CheckIfInEntTable( ent ) then
			entref = EntReference(ent:GetClass())
			isproj = entref.is_projectile
		end
		
		if ent != self and CheckIfInEntTable(ent) and isproj != true and ent.BBTeam != enemyteam 
			and ent:GetIfStatic() != true and ent:GetIfCanGrab() != false and ent:GetIfBeingGrabbed() != true then
			
			--start displaying a small box on top of the bug to represent this ent
			self:DisplayBox( ent )
			
			--save information about the ent we grabbed
			self.HeldEnt_Name = ent:GetClass()
			self.HeldEnt_Health = ent:Health()
			
			if ent.Partner != nil then
				self.HeldEnt_Partner = ent.Partner
			end
			
			--remove the ent from the world
			ent:GrabRemove()
			
			

			self.Grabbing = true
			self.GrabSetSpecialAng = true
			return
		end
	end
end	




--controls the phase fuse ability
function PuckEnt:DoGrab()
	//if true then return end
	local enemyteam = self:GetEnemyTeam()
	
	if (self.Owner:KeyDown(IN_USE)) then
		if (self.GrabTimer < CurTime()) then
			if self.CurGrabbedEnt == nil or IsValid( self.CurGrabbedEnt ) != true then
			
				Grab()
				
				if self.Grabbing == true then
					self:EmitSound( SOUND_GRAB )
				else
					self:EmitSound( SOUND_ATTEMPT )
				end
				
			elseif self.CurGrabbedEnt != nil and IsValid( self.CurGrabbedEnt ) then 
				self:UnGrab()
				self:EmitSound( SOUND_UNGRAB )
				
			end
			
			self.GrabTimer = CurTime() + .4
		end
	end
	
	
	
end
]]--