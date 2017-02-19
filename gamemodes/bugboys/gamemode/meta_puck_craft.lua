local PuckEnt = FindMetaTable("Entity")





function PuckEnt:Craft( location, get_angles )

	--theres a limit to the amount of structures than can be built in the game during warmup
	--just so people dont spam the server with them and lag it out
	local phase = GetGamePhase()
	if phase == "PreGame" or phase == "NoPlayers" then
		local count = 0
		for k,ent in pairs(ents.GetAll()) do
			if CheckIfInEntTable(ent) and not ent:IsProjectile() and ent:GetClass() != "structure_bugbrain" 
			and ent:GetClass() != "structure_bugbrain_shield"then
				//print( ent:GetClass() )
				count = count + 1
			end
		end
		
		if count >= PREGAME_STRUCTURE_LIMIT then
			self.Owner:ChatPrint( "Pregame structure limitation reached.  Can't build." )
			return
		end
	end



	local craft = self.Owner:GetCraft()
	local craftref = TableReference_Craft( craft )
	
	--first check if they have enough money for it and such
	if self.Owner:GetTokens() < craftref.crystals_required then
		self.Owner:ChatPrint( "You don't have enough tokens to construct that structure.  It costs " .. craftref.crystals_required )
		self.Owner:PlayLocalSound( "Sound_Failed" )
		self.CraftTimer = CurTime() + 1
		return
	end


	--make sure the player is near this location
	local distance = self:GetPos():Distance( location )
	if distance > 600 then
		self.Owner:ChatPrint( "You are too far from that position" )
		self.Owner:PlayLocalSound( "Sound_Failed" )
		self.CraftTimer = CurTime() + 1
		return
	end	
	
	
	
	--create a beam effect
	local function BeamEffect( startpt, endpt )
		local effectdata = EffectData()
			effectdata:SetOrigin( endpt )
			effectdata:SetStart( startpt )
			effectdata:SetAttachment( 1 )
			effectdata:SetEntity( self )
			util.Effect( "ToolTracer", effectdata )
	end
	
	
	local function CreateEnt( pos, ang )
		--Trace stuff
		local Aim = self.Owner:EyeAngles()
		local trpos = self:GetPos() + (Aim:Up() * ( self.Ref.cam_height - 1))
		local ang = self.Owner:GetAimVector()
		
		local tracedata = {}
		tracedata.start = trpos
		tracedata.endpos = trpos+(ang * 400)
		tracedata.filter = self, self.Owner
		local trace = util.TraceLine(tracedata)
		
		local hitent = trace.Entity
		local normalz = trace.HitNormal[3]
		local nrml = trace.HitNormal
		
		BeamEffect( self:GetPos(), trace.HitPos )
	
	
		local obj = ents.Create("ent_intermediary_structure")
		local objref = EntReference( obj:GetClass() )
			obj:SetPos( pos )
			obj.Creator = self.Owner
			obj.BBTeam = self.BBTeam
			obj.Craft = craft
			obj.CraftRef = craftref

			
			local ang_tbl = 
			{ 
			{name = "1", ang = 90}, 
			{name = "2", ang = 0}, 
			{name = "3", ang = -90}, 
			{name = "4", ang = 180} 
			}
			
			local function GetClosestAng()
				local eyeangles = self.Owner:EyeAngles()
				local decided_ang = nil
				local prev_dif = 1000
				for _, thing in pairs( ang_tbl ) do
					local dif = 0
					local eyeangles_y = eyeangles.y
					if eyeangles.y < -135 then
						eyeangles_y = 225
					end
					
					if eyeangles_y > thing.ang then
						dif = eyeangles_y - thing.ang
					else
						dif = thing.ang - eyeangles_y
					end
					
					if dif < prev_dif then
						decided_ang = thing.name
						prev_dif = dif
					end
				end
				
				return decided_ang
			end
			
			--new way which locks at 90 degrees
			if craftref.sets_angles == true then
				--for the ramp
				if IsValid(hitent) and (hitent:GetClass() == "structure_wall" or hitent:GetClass() == "ent_intermediary_structure") and normalz == 0 then
					obj:SetPos( (hitent:GetPos()-Vector(0,0,96)) + (nrml * 240) )
					
					local nrml_ang = nrml:Angle( )
					local newang = Angle(nrml_ang[1], nrml_ang[2]-90, nrml_ang[3])
					obj:SetAngles( newang )
				
				else	
					local closest = GetClosestAng()
					local setnum = nil
					for _, thing in pairs( ang_tbl ) do
						if thing.name == closest then
							setnum = thing.ang
							break
						end
					end
					
					local newang = Angle(0,setnum+90,0)
					obj:SetAngles( newang )
				end
			end
			
			
			if craftref.special_ang != nil then
				//print("SETTING ANG")
				obj:SetAngles( craftref.special_ang )
			end
		obj:Spawn()
	end
	


	local function BeginConstruction()
		self.Owner:EmitSound(TEST_SOUND)
		
		self.Owner:SubtractTokens( craftref.crystals_required )
		
		CreateEnt( location )
	end
	
	
	BeginConstruction()
end




--This is the old obsolete way

--onlytoken is a boolean that makes the function only craft tokens if its true
function PuckEnt:DoCraft( onlytoken )


	--draw a ghost of the building for the player to place it more easily
	if (self.Owner:KeyDown(IN_SPEED)) then
		--[[
	
		--Trace stuff
		local Aim = self.Owner:EyeAngles()
		local pos = self:GetPos() + (Aim:Up() * ( self.Ref.cam_height - 1))
		local ang = self.Owner:GetAimVector()
		
		local tracedata = {}
		tracedata.start = pos
		tracedata.endpos = pos+(ang * self.Ref.craft_dist)
		tracedata.filter = self, self.Owner
		local trace = util.TraceLine(tracedata)
		
		local hitent = trace.Entity
		local normalz = trace.HitNormal[3]
	
	
		local showing = false
	
		if trace.HitWorld and normalz > .8 then 
			self.Owner:SetShowGhost( true )
			 showing = true
			
		elseif trace.HitNonWorld and normalz > 0 then
			if hitent:GetClass() == "structure_wall" then
				self.Owner:SetShowGhost( true )
				showing = true
			end
		end
		
		if showing == false then
			self.Owner:SetShowGhost( false )
		end
		
	else
		self.Owner:SetShowGhost( false )
		
	]]--
		self.Owner:SetShowGhost( true )
	
	else
		self.Owner:SetShowGhost( false )
	
	end


	--when the player releases the key, the structure starts to build
	//if (self.Owner:KeyDown(IN_SPEED)) then
	if (self.Owner:KeyReleased(IN_SPEED)) then
		self.Owner:BBChatPrint( "RELEASED SHIFT" )
	
		self.Owner:SetShowGhost( false )
	
		if (self.CraftTimer < CurTime()) then
	
			local craft = self.Owner:GetCraft()
			local craftref = TableReference_Craft( craft )
			
			if onlytoken == true then
				craft = "craft_token"
				craftref = TableReference_Craft( craft )
			end
			
			--first check if they have enough money for it and such
			if self.Owner:GetTokens() < craftref.crystals_required then
				self.Owner:ChatPrint( "You don't have enough tokens to construct that structure.  It costs " .. craftref.crystals_required )
				self.Owner:PlayLocalSound( "Sound_Failed" )
				self.CraftTimer = CurTime() + 1
				return
			end

		
			--Trace stuff
			local Aim = self.Owner:EyeAngles()
			local pos = self:GetPos() + (Aim:Up() * ( self.Ref.cam_height - 1))
			local ang = self.Owner:GetAimVector()
			
			local tracedata = {}
			tracedata.start = pos
			tracedata.endpos = pos+(ang * self.Ref.craft_dist)
			tracedata.filter = self, self.Owner
			local trace = util.TraceLine(tracedata)
			
			local hitent = trace.Entity
			local normalz = trace.HitNormal[3]


			
			
			--create a beam effect
			local function BeamEffect( startpt, endpt )
				local effectdata = EffectData()
					effectdata:SetOrigin( endpt )
					effectdata:SetStart( startpt )
					effectdata:SetAttachment( 1 )
					effectdata:SetEntity( self )
					util.Effect( "ToolTracer", effectdata )
			end
			
			
			local function CreateEnt( pos, ang )
				local obj = ents.Create("ent_intermediary_structure")
				local objref = EntReference( obj:GetClass() )
					obj:SetPos( pos )
					obj.Creator = self.Owner
					obj.BBTeam = self.BBTeam
					obj.Craft = craft
					--[[
					if self.BBTeam == TEAM_RED then
						obj:SetMaterial( objref.special_mat_red )
					elseif self.BBTeam == TEAM_BLUE then
						obj:SetMaterial( objref.special_mat_blue )
					end
					]]--
					
					local eyeangles = self.Owner:EyeAngles()
					local newang = Angle(0,eyeangles.y+90,0)
					//local finalang = newang:Forward()
					
					if craftref.sets_angles == true then
						//print("SETTING ANG")
						obj:SetAngles( newang )
					end
					
					if craftref.special_ang != nil then
						//print("SETTING ANG")
						obj:SetAngles( craftref.special_ang )
					end
					
					
					
					obj:Spawn()
			end
			
			
			local function VerifyCanBuildThis()
				--players can only build 1 of teleport entrance/exit
				if craft == "craft_teleport_entrance" or craft == "craft_teleport_exit" then
					for k,allent in pairs(ents.GetAll()) do
						if allent.Creator == self.Owner and allent:GetClass() == craftref.ent then
							
							self.Owner:ChatPrint( "You can only build 1 " .. craftref.print_name)
							self.Owner:PlayLocalSound( "Sound_Failed" )
							
							return false
						elseif allent.Creator == self.Owner and allent:GetClass() == "ent_intermediary_structure" and allent.Ent == craftref.ent then
							
							self.Owner:ChatPrint( "You can only build 1 " .. craftref.print_name)
							self.Owner:PlayLocalSound( "Sound_Failed" )
							
							return false
						end
					end
				end
				
				return true
			end
			
			
			local function BeginConstruction()
				if VerifyCanBuildThis() then
					self.Owner:EmitSound(TEST_SOUND)
					BeamEffect( self:GetPos(), trace.HitPos )
					
					self.Owner:SubtractTokens( craftref.crystals_required )
					
					CreateEnt( trace.HitPos )
				end
			end
			
			
			--create the construction entity and subtract the player's tokens
			//print( normalz )
			if trace.HitWorld and normalz > .8 then 
				BeginConstruction()
			elseif trace.HitNonWorld and normalz > 0 then
				if hitent:GetClass() == "structure_wall" then
					BeginConstruction()
				end
			end

		end
	end
end


