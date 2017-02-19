/*---------------------------------------------------------
	Ghost that shows when the player is about to build a structure
---------------------------------------------------------*/

local CL_ShowingGhost = false
local Ghost = nil
local Ghost_Prev = nil
local Ghost_Prev_Ang = nil
local Ghost_In_Wall = false
local Sphere = nil
local Build_Cooldown = 0

function BuildingGhost()
	if LocalPlayer():Team() == TEAM_SPEC then return end
	
	local Ply = LocalPlayer()
	local Puck = Ply:GetNetworkedEntity( "Puck" )
	if Puck == nil or not IsValid( Puck ) then return end
	
	local craft = Ply:GetCraft()
	local craftref = TableReference_Craft( craft )
	local entref = EntReference( craftref.ent )
	
	
	local function StopShowing()
		if IsValid( Ghost ) then
			Ghost_Prev = Ghost:GetPos()
			Ghost_Prev_Ang = Ghost:GetAngles()
			
			Ghost:Remove()
		end
		if IsValid( Sphere ) then
			Sphere:Remove()
		end
		
		Ghost = nil
		Sphere = nil
		CL_ShowingGhost = false
	end
	
	
	local function CheckIfInWall( ent, dist )
		local function DoTraceTo(vec, posoverride)
			local vecn = vec:GetNormal()
			local pos = ent:GetPos()
			if posoverride != nil then
				pos = posoverride
			end
			
			local tracedata = {}
			tracedata.start = pos
			tracedata.endpos = pos + (Vector(vecn.x, vecn.y, vecn.z) * dist)
			tracedata.filter = ent
			
			local trace = util.TraceLine(tracedata)
			
			--if it didnt hit anything, we have nothing to do
			local hit = trace.Hit
			if not hit then
				return false
			end
			
			local hitnonworld = trace.HitNonWorld
			local hitworld = trace.HitWorld
			local hitent = trace.Entity
			local hitsky = trace.HitSky
			
			if hitnonworld then
				return true
				
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

		--for the structures that have a center position at their feet, like sentries
		--this pos needs to be raised up to detect if in wall
		local pos_override = nil
		if DoTraceTo( Vector(0,0,-1) ) == true then
			pos_override = ent:GetPos() + (Vector(0,0,1) * dist)
		end
		
		--check all the positions to see if theyre in the wall
		for _,vec in pairs(vec_list) do
			local tracer = nil
			if pos_override != nil then
				tracer = DoTraceTo( vec, pos_override )
			else
				tracer = DoTraceTo( vec )
			end
			if tracer then
				return true
			end
		end
		
		return false
	end
	

	if (Ply:KeyDown(IN_SPEED)) then

		--create the ent if its not already showing
		if CL_ShowingGhost == false then
			Ghost = ents.CreateClientProp()
				Ghost:SetPos( Ply:GetPos() + Vector(0,0,craftref.spawn_height) )
				Ghost:SetModel( entref.model )
				Ghost:Spawn()
				if Ply:Team() == TEAM_RED then
					//Ghost:SetMaterial( "models/props_combine/tprings_globe" )
					//Ghost:SetMaterial( "bugboys/ghost_red" )
					Ghost:SetMaterial( "bugboys/sphere_red" )
				else
					//Ghost:SetMaterial( "models/props_combine/stasisshield_sheet" )
					//Ghost:SetMaterial( "bugboys/ghost_blue" )
					Ghost:SetMaterial( "bugboys/sphere_blue" )
				end
				if craftref.special_ang != nil then
					Ghost:SetAngles( craftref.special_ang )
				end
				
			--create a giant sphere surrounding the ent to show its radius of effect
			if entref.display_radius_sphere == true then
				local scale = entref.radius * .02
			
				Sphere = ents.CreateClientProp()
				Sphere:SetPos( Ply:GetPos() + Vector(0,0,craftref.spawn_height) )
				Sphere:SetModel( "models/bugboys/sphere100.mdl" )
				if Ply:Team() == TEAM_RED then
					Sphere:SetMaterial( "bugboys/sphere_red" )
				else
					Sphere:SetMaterial( "bugboys/sphere_blue" )
				end
				Sphere:Spawn()
				Sphere:SetModelScale( scale, 0 )
			end
			
			CL_ShowingGhost = true
		end
		
		
		--do a trace where the player is looking
		local trstart = Ply.FakePos
		if trstart == nil then
			trstart = Ply:GetPos()
		end
		local Trace = {}
			Trace.start = trstart
			Trace.endpos = trstart + (Ply:GetAimVector() * 400) --400
			Trace.filter = Ply
			Trace.mask = MASK_SOLID - CONTENTS_GRATE
			Trace = util.TraceLine(Trace) 
		local hitpos = Trace.HitPos
		local hitent = Trace.Entity
		local hitsky = Trace.HitSky
		local normalz = Trace.HitNormal[3]
		
		--update the ghosts position to be where the player is looking
		Ghost:SetPos( hitpos + Vector(0,0,craftref.spawn_height) )
		if IsValid( Sphere ) then
			Sphere:SetPos( hitpos + Vector(0,0,craftref.spawn_height) )
		end
		
		
		
		
		local ang_tbl = 
		{ 
		{name = "1", ang = 90}, 
		{name = "2", ang = 0}, 
		{name = "3", ang = -90}, 
		{name = "4", ang = 180 or -180} 
		}
		
		local function GetClosestAng()
			local eyeangles = Ply:EyeAngles()
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
		
		
		
		--update the angles if this ent builds with a specified angle
		if craftref.sets_angles == true and (Trace.HitWorld and normalz > .8) or (Trace.HitNonWorld and hitent:GetClass() == "structure_wall" and normalz > .8) then
			local closest = GetClosestAng()
			local setnum = nil
			for _, thing in pairs( ang_tbl ) do
				if thing.name == closest then
					setnum = thing.ang
					break
				end
			end
			
			local newang = Angle(0,setnum+90,0)
			Ghost:SetAngles( newang )
		end
		
		
		
		--we cant draw the ghost if the player isnt aiming at something it can be built on
		local itsok = false
		if Trace.HitWorld and normalz > .8 then 
			itsok = true
		elseif Trace.HitNonWorld and normalz > 0 then
			if hitent:GetClass() == "structure_wall" then
				itsok = true
			end
		end
		
		
		--allow people to build walls on the sides of the world
		if craft == "craft_wall" and Trace.HitWorld and normalz == 0 then
			local nrml = Trace.HitNormal
			Ghost:SetPos( hitpos + (nrml * craftref.spawn_height) )
			itsok = true
		end
		
		
		--snap walls to align with other walls if aiming at a wall or a wall in the process of building
		if craft == "craft_wall" then
			if Trace.HitNonWorld and hitent:GetClass() == "structure_wall" then
				local nrml = Trace.HitNormal
				//Ghost:SetPos( hitpos + (nrml * craftref.spawn_height) )
				
				--snap to the walls position, so they are aligned
				Ghost:SetPos( hitent:GetPos() + (nrml * (craftref.spawn_height*2)) )
				itsok = true
				
			elseif Trace.HitNonWorld and hitent:GetClass() == "ent_intermediary_structure" and hitent:GetCraftForClient() == "craft_wall" then
				if normalz == 0 then
					local nrml = Trace.HitNormal
					Ghost:SetPos( hitent:GetPos() + (nrml * (craftref.spawn_height*2)) )
					itsok = true
				else
					itsok = false
				end
				
			end
		end
		
		
		--snap ramps to align with other walls if aiming at a wall or a wall in the process of building
		if craft == "craft_ramp" then
			if Trace.HitNonWorld and hitent:GetClass() == "structure_wall" and normalz == 0 then
				local nrml = Trace.HitNormal
				Ghost:SetPos( (hitent:GetPos()-Vector(0,0,96)) + (nrml * 240) )
				
				local nrml_ang = nrml:Angle( )
				local newang = Angle(nrml_ang[1], nrml_ang[2]-90, nrml_ang[3])
				Ghost:SetAngles( newang )
				
				itsok = true
				
			elseif Trace.HitNonWorld and hitent:GetClass() == "ent_intermediary_structure" and hitent:GetCraftForClient() == "craft_wall" and normalz == 0 then
				local nrml = Trace.HitNormal
				Ghost:SetPos( (hitent:GetPos()-Vector(0,0,96)) + (nrml * 240) )
				
				local nrml_ang = nrml:Angle( )
				local newang = Angle(nrml_ang[1], nrml_ang[2]-90, nrml_ang[3])
				Ghost:SetAngles( newang )
				
				itsok = true
				
				
			end
		end
		
		

		--cant build it into walls
		Ghost_In_Wall = false
		if craftref.cant_into_walls == true and CheckIfInWall( Ghost, craftref.cant_into_walls_dist ) then
			itsok = false
			Ghost_In_Wall = true
		end
	
	
		if hitsky then
			itsok = false
		end
	
		
		if itsok != true then
			StopShowing()
		end
		
		
	--if they arent even holding shift then stop showing
	else
		StopShowing()
		
		
		
	end


	
	if Ply:KeyReleased( IN_SPEED ) and Build_Cooldown < CurTime() then 
		Build_Cooldown = CurTime() + .05
	
		--do a trace where the player is looking
		local trstart = Ply.FakePos
		local Trace = {}
			Trace.start = trstart
			Trace.endpos = trstart + (Ply:GetAimVector() * 400)
			Trace.filter = Ply
			Trace.mask = MASK_SOLID - CONTENTS_GRATE
			Trace = util.TraceLine(Trace) 
		local hitpos = Trace.HitPos
		local hitent = Trace.Entity
		local hitsky = Trace.HitSky
		local normalz = Trace.HitNormal[3]
	
		local itsok = false
		if Trace.HitWorld and normalz > .8 then 
			itsok = true
		elseif Trace.HitNonWorld and normalz > 0 then
			if hitent:GetClass() == "structure_wall" then
				itsok = true
			end
		end
		
		--allow people to build walls on the sides of the world or sides of walls
		if Trace.HitWorld and normalz == 0 and craft == "craft_wall" or craft == "craft_ramp" then
			if hitent == NULL then
				itsok = false
			else
				itsok = true
			end
			
		elseif Trace.HitNonWorld and (hitent:GetClass() == "structure_wall" or hitent:GetClass() == "ent_intermediary_structure") and normalz == 0 and craft == "craft_wall" then	
			itsok = true
			
		elseif Trace.HitNonWorld and hitent:GetClass() == "structure_wall" and craft == "craft_wall" then
			itsok = true
		
		end
		
		
		if Ghost_In_Wall == true then
			itsok = false
		end
		
		
		if hitsky then
			itsok = false
		end
		
		
		if itsok == true then
			local location = Ghost_Prev - Vector(0,0,craftref.spawn_height)

			if craftref.sets_angles != true then
				RunConsoleCommand( "bb_craft", tostring(location.x), tostring(location.y), tostring(location.z)  )
			else
				RunConsoleCommand( "bb_craft", tostring(location.x), tostring(location.y), tostring(location.z), Ghost_Prev_Ang )
			end
			
			//Ply:BBChatPrint( "Building" )
			//surface.PlaySound( "hl1/fvox/bell.wav" )
		end
	end

end
hook.Add("Think", "BuildingGhost", BuildingGhost)