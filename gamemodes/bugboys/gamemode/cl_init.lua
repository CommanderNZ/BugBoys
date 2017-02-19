--all shared files go here
include( 'shared.lua' )
include( 'table_puck.lua' )
include( 'table_ent.lua' )
include( 'table_swep.lua' )
include( 'table_craft.lua' )
include( 'table_swepability.lua' )
include( 'shared_settings.lua' )
include( 'meta_player.lua' )
include( 'meta_ent.lua' )
include( 'meta_puck_grab.lua' )
include( 'meta_puck_rope.lua' )
include( 'meta_puck_weld.lua' )
include( 'meta_puck_craft.lua' )

--all client files go here
include( 'cl_teammenu.lua' )
include( 'cl_classmenu.lua' )
include( 'cl_gametimer.lua' )
include( 'cl_sounds.lua' )
include( 'cl_deathnotice.lua' )
include( 'cl_keypress.lua' )
include( 'cl_quickmenu.lua' )
include( 'cl_typecommands.lua' )
include( 'cl_respawntimer.lua' )
include( 'cl_scoreboard.lua' )
include( 'cl_buildingghost.lua' )
include( 'cl_helpmenu.lua' )








 surface.CreateFont( "CustomBBFont_A", {
	 font = "Arial",
	 size = 120,
	 weight = 500,
	 blursize = 0,
	 scanlines = 0,
	 antialias = true,
	 underline = false,
	 italic = false,
	 strikeout = false,
	 symbol = false,
	 rotary = false,
	 shadow = false,
	 additive = false,
	 outline = false
	} )
 
  surface.CreateFont( "CustomBBFont_B", {
	 font = "Arial",
	 size = 40,
	 weight = 500,
	 blursize = 0,
	 scanlines = 0,
	 antialias = true,
	 underline = false,
	 italic = false,
	 strikeout = false,
	 symbol = false,
	 rotary = false,
	 shadow = false,
	 additive = false,
	 outline = false
	} )


	surface.CreateFont( "CustomBBFont_C", {
	 font = "Arial",
	 size = 70,
	 weight = 500,
	 blursize = 0,
	 scanlines = 0,
	 antialias = true,
	 underline = false,
	 italic = false,
	 strikeout = false,
	 symbol = false,
	 rotary = false,
	 shadow = false,
	 additive = false,
	 outline = false
	} )






--makes it so it doesnt draw players names and their hp% when you look at them
function GM:HUDDrawTargetID()
     return false
end



local tohide = { -- This is a table where the keys are the HUD items to hide
	["CHudHealth"] = true,
	["CHudBattery"] = true,
	["CHudAmmo"] = true,
	["CHudSecondaryAmmo"] = true,
	["CHudWeaponSelection"] = true,
}

local function HUDShouldDraw(name) -- This is a local function because all functions should be local unless another file needs to run it
	if (tohide[name]) then     -- If the HUD name is a key in the table
		return false;      -- Return false.
	end
end
hook.Add("HUDShouldDraw", "HUD hider", HUDShouldDraw)

 


 
 surface.CreateFont( "TheDefaultSettings", {
	 font = "Arial",
	 size = 120,
	 weight = 500,
	 blursize = 0,
	 scanlines = 0,
	 antialias = true,
	 underline = false,
	 italic = false,
	 strikeout = false,
	 symbol = false,
	 rotary = false,
	 shadow = false,
	 additive = false,
	 outline = false
	} )
	
 surface.CreateFont( "SmallerFont", {
	 font = "Arial",
	 size = 60,
	 weight = 500,
	 blursize = 0,
	 scanlines = 0,
	 antialias = true,
	 underline = false,
	 italic = false,
	 strikeout = false,
	 symbol = false,
	 rotary = false,
	 shadow = false,
	 additive = false,
	 outline = false
	} )
 
  surface.CreateFont( "NewSmallerFont", {
	 font = "Arial",
	 size = 40,
	 weight = 500,
	 blursize = 0,
	 scanlines = 0,
	 antialias = true,
	 underline = false,
	 italic = false,
	 strikeout = false,
	 symbol = false,
	 rotary = false,
	 shadow = false,
	 additive = false,
	 outline = false
	} )
 
 

 
 

 --sets the camera for the player
function GM:CalcView(Ply, Position, Angles, FOV)
	--print( " calc viewing")
	--[[
	-- Set the chase distance --
	if (Ply:KeyDown(IN_SPEED)) then
		-- Zoom out
		Ply.ZoomDist = math.min(250, Ply.ZoomDist + 200*FrameTime())
		
	elseif (Ply:KeyDown(IN_DUCK)) then
		-- Zoom in
		Ply.ZoomDist = math.max(0, Ply.ZoomDist - 200*FrameTime())
	end
	]]--
	
	-- Prevent camera from noclipping with world
	local Puck = Ply:GetNetworkedEntity( "Puck" )
	if (Puck:IsValid()) then
		--print("running")
	
		--local PuckStats = Puck:GetRef()
		local PuckStats = PuckReference(Puck:GetClass())
		Ply.ZoomDist = PuckStats.cam_dist
		
		//local UpTrace = util.QuickTrace(Puck:GetPos(), (Angles:Up()*PuckStats.cam_height), {Puck, Ply})
		//local UpTraceUltimatePos = UpTrace.HitPos
		local UpTrace = {}
		UpTrace.start = Puck:GetPos()
		UpTrace.endpos = (Puck:GetPos()) + (Angles:Up()*PuckStats.cam_height)
		UpTrace.filter = {Puck, Ply}
		UpTrace.mask = MASK_SOLID_BRUSHONLY  //MASK_SOLID - CONTENTS_GRATE
		UpTrace = util.TraceLine( UpTrace ) 
		
		//print( UpTrace.Entity )
		--[[
		--if somethings in the way of the trace view, disregard it unless its the world
		if (UpTrace.HitNonWorld) then
			local filtertable = {Puck, Ply}
			
			while true do
				local ReTrace = util.QuickTrace(Puck:GetPos(), (Angles:Up()*PuckStats.cam_height), filtertable)
				local filteradd = ReTrace.Entity
					print("adding this ent  " .. ReTrace.Entity:GetClass())
					table.insert( filtertable, filteradd)
				
				if (ReTrace.HitWorld) then
					UpTraceUltimatePos = ReTrace.HitPos
					break
				//elseif not (ReTrace.Hit) then
				else
					UpTraceUltimatePos = ReTrace.HitPos
					break
				end
			end
			--View.origin = (Puck:GetPos() + Ply:GetAimVector()* -Ply.ZoomDist)
		end
		]]--
		
		
		
		
		--set up another trace from the top hit position of Uptrace
		local Trace = util.QuickTrace(UpTrace.HitPos, Ply:GetAimVector() * -Ply.ZoomDist, {Puck, Ply})
		
		local View = {}
		View.origin = Trace.HitPos + (Trace.HitNormal * 2)
		View.angles = Angles
		
		
		--if somethings in the way of the trace view, disregard it unless its the world
		if (Trace.HitNonWorld) 
		and Trace.Entity:GetClass() != "structure_turret_vehicle" then
		//and Trace.Entity:GetClass() != "structure_destroyer"
		//and Trace.Entity:GetClass() != "structure_boat" then
			--local norm_dist = (Puck:GetPos() - Ply:GetAimVector()* -Ply.ZoomDist)
			--local subtraction = (Trace.HitPos - Puck:GetPos())
			
			--local dif = norm_dist - subtraction
			
			local filtertable = {Puck, Ply}
			
			while true do
				local ReTrace = util.QuickTrace(UpTrace.HitPos, Ply:GetAimVector() * -Ply.ZoomDist, filtertable)
				local filteradd = ReTrace.Entity
					table.insert( filtertable, filteradd)
				
				if (ReTrace.HitWorld) then
					View.origin = ReTrace.HitPos + (ReTrace.HitNormal * 2)
					break
				//elseif not (ReTrace.Hit) then
				else
					View.origin = (UpTrace.HitPos + Ply:GetAimVector()* -Ply.ZoomDist)
					break
				end
			end
			--View.origin = (Puck:GetPos() + Ply:GetAimVector()* -Ply.ZoomDist)
		end

		
		
		-- We're not actually here..
		Ply.FakePos = View.origin
		
		--Make view higher up--
		--View.origin = Position+(Angles:Up()*20)
		
		return View
	end
end
 
 

 

local PlyPressing_Primary = false
local PlyPressing_Secondary = false
local PlyPressing_Thirdary = false
local PlyPressing_E = false
local PlyPressing_Shift = false
local PlyPressing_Control = false
local PlyPressing_Alt = false

function KeyIsDown()
	PlyPressing_Primary = false
	PlyPressing_Secondary = false
	PlyPressing_Thirdary = false
	PlyPressing_E = false
	PlyPressing_Shift = false
	PlyPressing_Control = false
	PlyPressing_Alt = false
	
	local ply = LocalPlayer()
	
	if ( ply:KeyDown( IN_ATTACK ) ) then
		PlyPressing_Primary = true
	end
	
	if ( ply:KeyDown( IN_ATTACK2 ) ) then
		PlyPressing_Secondary = true
	end
	
	if ( ply:KeyDown( IN_RELOAD ) ) then
		PlyPressing_Thirdary = true
	end
	
	if ( ply:KeyDown( IN_USE) ) then
		PlyPressing_E = true
	end
	
	if ( ply:KeyDown( IN_SPEED ) ) then
		PlyPressing_Shift = true
	end
	
	if ( ply:KeyDown( IN_DUCK ) ) then
		PlyPressing_Control = true
	end
	
	//if ( ply:KeyDown( IN_WALK ) ) then
		//PlyPressing_Alt = true
	//end
end
hook.Add( "Think", "KeyIsDown", KeyIsDown )
 

local PlyPressing_Q = false
local function QPress()
	local iskeydown = input.IsKeyDown(KEY_Q)
	if LocalPlayer():Team() == TEAM_SPEC then return end
		
	if iskeydown then 
		PlyPressing_Q = true
	else
		PlyPressing_Q = false
	end
end
hook.Add("Think","QPress",QPress)
 

/*---------------------------------------------------------
	Hud features
---------------------------------------------------------*/
function hud()


	
	local Ply = LocalPlayer()
	
	----Player must be alive for the rest of this stuff.....
	//if !(Ply && Ply:Alive()) then
		//return
	//end
	
	
	
	
/*---------------------------------------------------------
	Token amount display - shows even if they dont have a puck
---------------------------------------------------------*/		

	if Ply:Team() != TEAM_SPEC then
		draw.RoundedBox(0, 0, ScrH()-35, 150, 35, Color(50,50,50,255))	
		draw.SimpleText("Tokens:", "Trebuchet18", 40, ScrH() - 30, Color(255,255,255,255), TEXT_ALIGN_CENTER) 
		
		local tokens = Ply:GetTokens()
		draw.SimpleText( tokens, "DermaLarge", 80, ScrH() - 32, Color(200,150,255,255)) 
	end
	
	
	
	
	
	
	
	
	
/*---------------------------------------------------------
	Revealer Marker - radar
---------------------------------------------------------*/
	local function DrawMark( ent, mark, color )
		local PosScr = ent:GetPos():ToScreen()
		draw.SimpleTextOutlined( mark, "SmallerFont", PosScr.x, PosScr.y, color, 1, 1, 1, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER)
	end
	
	
	
	if LocalPlayer():Team() != TEAM_SPEC then
		for k,ent in pairs( ents.GetAll() ) do
			if ent:GetClass() == "structure_radar" and ent:GetEntTeamForClient() == LocalPlayer():Team() then
				local ref = EntReference( ent:GetClass() )
				local orgin_ents = ents.FindInSphere( ent:GetPos(), ref.radius )
			
				--mark all enemy players in the origin of the radar, (except if theyre invisible)
				for k, in_ent in pairs( orgin_ents ) do
					if in_ent:IsValidPlyBug() and in_ent:GetEntTeamForClient() != LocalPlayer():Team() then
						local color = Color(255, 255, 255, 255)
						if in_ent:GetEntTeamForClient() == TEAM_BLUE then
							color = Color(0, 0, 255, 255)
						elseif in_ent:GetEntTeamForClient() == TEAM_RED then
							color = Color(255, 0, 0, 255)
						end
						
						DrawMark( in_ent, "x", color )
					end
				end
			end
		end
	
	--mark playets for spectators so they know who sees who on radar
	elseif LocalPlayer():Team() == TEAM_SPEC then
		for k,ent in pairs( ents.GetAll() ) do
			if ent:GetClass() == "structure_radar" and ent:GetEntTeamForClient() == LocalPlayer():Team() then
				local ref = EntReference( ent:GetClass() )
				local orgin_ents = ents.FindInSphere( ent:GetPos(), ref.radius )
			
				--mark all enemy players in the origin of the radar, (except if theyre invisible)
				for k, in_ent in pairs( orgin_ents ) do
					if in_ent:IsValidPuck() then
						local color = Color(255, 255, 255, 255)
						if in_ent:GetEntTeamForClient() == TEAM_BLUE then
							color = Color(0, 0, 255, 255)
						elseif in_ent:GetEntTeamForClient() == TEAM_RED then
							color = Color(255, 0, 0, 255)
						end
						
						DrawMark( in_ent, "x", color )
					end
				end
			end
		end
	end
	
	
	
	
	
	
	
/*---------------------------------------------------------
	Damage Marker - shows the team where they are taking damage
---------------------------------------------------------*/

	local function DrawDamageMark( ent, mark, color )
		local PosScr = ent:GetPos():ToScreen()
		draw.SimpleTextOutlined( "X", "TargetID", PosScr.x, PosScr.y, Color(255, 255, 255, 255), 1, 1, 1, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER)
	end
	
	local entcheck = "ent_damagemarker_red"
	if LocalPlayer():Team() == TEAM_BLUE then
		entcheck = "ent_damagemarker_blue"
	else
		entcheck = "ent_damagemarker_red"
	end
	entcheck = "ent_damagemarker_red"
	
	for k,ent in pairs( ents.GetAll() ) do
		if ent:GetClass() == entcheck then
			DrawDamageMark( ent )
		end
	end	
	
	
	
	
	
	
	
		
/*---------------------------------------------------------
	Names on pucks
---------------------------------------------------------*/	
--[[
	---- Names ----
	-- Player names --
	for k,v in pairs(player.GetAll()) do
		local Puck = v:GetNetPuck()
		local trstart = Ply.FakePos
		if LocalPlayer():Team() == TEAM_SPEC then
			trstart = Ply:GetPos()
		end
		
		-- Make sure our Puck is valid before we do anything
		if (IsValid(Puck)) then
			-- Make a traceline
			local Trace = {}
			Trace.start = trstart
			Trace.endpos = Puck:GetPos()
			Trace.filter = Ply
			Trace.mask = MASK_SOLID - CONTENTS_GRATE
			Trace = util.TraceLine(Trace) 
			
			if (Trace.HitNonWorld) and Trace.Entity:IsValidPuck() and Trace.Entity:GetOwner() != Ply then
				local Pos = Puck:GetPos() + Vector(0, 0,10)
				local PosScr = Pos:ToScreen()
				
				local distance = Ply:EyePos():Distance( Puck:GetPos() )
					PosScr.y = (PosScr.y - ( math.log(distance)*4) - 30) --*4
				
				local teamcolor = Color(200, 200, 200, 255)
				if v:Team() == TEAM_RED then
					teamcolor = Color(255, 170, 170, 255)
				elseif v:Team() == TEAM_BLUE then
					teamcolor = Color(170, 170, 255, 255)
				end
				
				local dorender = true
				if distance > MAX_NAME_RENDER_DISTANCE then
					dorender = false
				end
				
				if dorender == true then
					-- Draw their names above their Pucks
					draw.SimpleTextOutlined(v:Name() .. " - "  .. v:GetTokens(), "Default", PosScr.x, PosScr.y, teamcolor, 1, 1, 1, Color(0, 0, 0, 255))
				end
			end
		end
	end	
]]--	
	
	
	
	
/*---------------------------------------------------------
	name of ent the player is looking at
---------------------------------------------------------*/		
	
	local trstart = Ply.FakePos
	if Ply:Team() == TEAM_SPEC then
		trstart = Ply:GetPos()
	end
	

	-- Make a traceline
	if trstart != nil then
		local Trace = {}
			Trace.start = trstart
			Trace.endpos = trstart + (Ply:GetAimVector() * 8000)
			Trace.filter = Ply
			Trace.mask = MASK_SOLID - CONTENTS_GRATE
			Trace = util.TraceLine(Trace) 

		local hitent = Trace.Entity
		//print(hitent)
		if IsValid( hitent ) then
			local hitent_team = hitent:GetEntTeamForClient()
		
		
			--if looking at a built structure
			if CheckIfInEntTable( hitent ) and not hitent:IsProjectile() and hitent:GetClass() != "ent_intermediary_structure" then
				local color = Color(255, 255, 255, 255)
				--[[
				if hitent:GetEntTeamForClient() == TEAM_RED then
					color = Color(255, 200, 200, 255)
				elseif hitent:GetEntTeamForClient() == TEAM_BLUE then
					color = Color(200, 200, 255, 255)
				end
				]]--
				
				local plural = ""
				if hitent:GetClass() == "structure_token" then
					color = Color(220, 180, 255, 255)
					
					if hitent:GetAmountDisplay() > 1 then
						plural = "s"
					end
				end
				
				
				local craftname = ConvertToCraftNameFromEntName_Craft( hitent:GetClass() )
				local craftref = TableReference_Craft( craftname )
				local hp = hitent:Health()
				
				if craftref != nil then
					draw.SimpleTextOutlined( craftref.print_name .. plural, "TargetID", ScrW()/2, ScrH()/2 -100, color, 1, 1, 1, Color(0, 0, 0, 255))
				end
				
				
				
				--if its a general structure someone built
				if hitent:GetClass() != "structure_token" then
					draw.SimpleTextOutlined( hp .. " hp", "TargetID", ScrW()/2, ScrH()/2 -80, color, 1, 1, 1, Color(0, 0, 0, 255))
					
					if craftref.display_grabbable == true then
						local green = Color( 71, 255, 120, 255 )
						draw.SimpleTextOutlined( "Grabbable", "TargetID", ScrW()/2, ScrH()/2 -60, green, 1, 1, 1, Color(0, 0, 0, 255))
					end
					
					if hitent:GetClass() == "structure_quickport" then
						local Puck = Ply:GetNetPuck()
						if IsValid( Puck ) then
							local distance = Puck:GetPos():Distance( hitent:GetPos() )
							local entref = EntReference( craftref.ent )
							if distance < entref.radius then
								draw.SimpleTextOutlined( "(In range)", "TargetID", ScrW()/2, ScrH()/2 -40, color, 1, 1, 1, Color(0, 0, 0, 255))
							end
						end
					end
					
					--
					if craftref.on_zap_description != nil and hitent_team == Ply:Team() then
						local green = Color( 71, 255, 120, 255 )
						draw.SimpleTextOutlined( "On Zap:   ( " .. craftref.on_zap_description .. " )", "TargetID", 400, ScrH() - 80, color, 1, 1, 1, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT)
					
					elseif hitent_team == GetOppositeTeam( Ply:Team() ) then
						draw.SimpleTextOutlined( "On Zap:   ( Melee attack )", "TargetID", 400, ScrH() - 80, color, 1, 1, 1, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT)
					
					end
					--
					
					--for teleporters with entangled ents across the map, show their positon on the hud
					if craftref.has_partner == true and IsValid( hitent:GetPartnerEnt() ) then
						local partner = hitent:GetPartnerEnt()
						local pos = partner:GetPos()
						local pos_scr = pos:ToScreen()
						local partner_name = craftref.partner_display
						
						draw.SimpleTextOutlined( partner_name, "TargetID", pos_scr.x, pos_scr.y, color, 1, 1, 1, Color(0, 0, 0, 255))
					end
				
				else
					local amount = hitent:GetAmountDisplay()
					draw.SimpleTextOutlined( amount, "TargetID", ScrW()/2, ScrH()/2 -80, color, 1, 1, 1, Color(0, 0, 0, 255))
				end
			
			
			
			
			--if looking at a structure before its built fully
			elseif hitent:GetClass() == "ent_intermediary_structure" then
				local color = Color(255, 255, 255, 255)	
				
				local craftname = hitent:GetCraftForClient()
				//print("this is craftname  " .. craftname)
				local craftref = TableReference_Craft( craftname )
				local full_time = nil

				
				if craftref != nil then
					draw.SimpleTextOutlined( craftref.print_name, "TargetID", ScrW()/2, ScrH()/2 -100, color, 1, 1, 1, Color(0, 0, 0, 255))
					draw.SimpleTextOutlined( "Constructing...", "TargetID", ScrW()/2, ScrH()/2 -80, color, 1, 1, 1, Color(0, 0, 0, 255))
				
					full_time = craftref.craft_time
				end
				
				--say what it does on zap
				draw.SimpleTextOutlined( "On Zap:   ( Cancel )", "TargetID", 400, ScrH() - 80, color, 1, 1, 1, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT)

				
				--show a bar that displays how long until its finished constructing
				local complete_time = hitent:GetCompleteTime()
				if complete_time != nil then
					local cur_time = CurTime()
					local display = RoundNum( (complete_time - cur_time), 1 )
					
					if full_time != nil then
						local difference = (full_time -(complete_time - cur_time))
						//draw.RoundedBox(0, ScrW()/2, ScrH()/2, full_time*4, 15, health_color_bg)
						//draw.RoundedBox(0, ScrW()/2, ScrH()/2, difference*4, 15, health_color)
						
						local ratio = ((difference/full_time)*100)
						
						draw.RoundedBox(0, ScrW()/2-55, ScrH()/2-65, 110, 25, Color(100,100,100,255))
						draw.RoundedBox(0, ScrW()/2-50, ScrH()/2-60, 100, 15, Color(0,0,0,255))
						draw.RoundedBox(0, ScrW()/2-50, ScrH()/2-60, ratio*1, 15, Color(255,255,255,255))
						
						draw.SimpleTextOutlined( display, "TargetID", ScrW()/2, ScrH()/2 -30, color, 1, 1, 1, Color(0, 0, 0, 255))
					end
					
				end
			
			
			--if looking at a player bug
			elseif hitent:IsValidPlyBug() then
				local purple = Color(220, 180, 255, 255)
				local color = Color(255, 255, 255, 255)
				if hitent:GetEntTeamForClient() == TEAM_RED then
					color = Color(255, 200, 200, 255)
				elseif hitent:GetEntTeamForClient() == TEAM_BLUE then
					color = Color(200, 200, 255, 255)
				end
				
				local name = hitent.Owner:Nick()
				local hp = hitent:Health()
				local tokens = hitent.Owner:GetTokens()
				draw.SimpleTextOutlined( name, "TargetID", ScrW()/2, ScrH()/2 -100, color, 1, 1, 1, Color(0, 0, 0, 255))
				draw.SimpleTextOutlined( hp .. " hp", "TargetID", ScrW()/2, ScrH()/2 -80, color, 1, 1, 1, Color(0, 0, 0, 255))
				draw.SimpleTextOutlined( tokens .. " tokens", "TargetID", ScrW()/2, ScrH()/2 -60, purple, 1, 1, 1, Color(0, 0, 0, 255))
				
				
				
			end
		end
	end
	
	
	
/*---------------------------------------------------------
	PLAYER MUST HAVE PUCK FROM NOW ON FOR FOLLOWING TO RENDER
---------------------------------------------------------*/	
	-- dont render any of this stuff if the player doesnt durrently have a puck
	if Ply:HasNetPuck() != true then return end
	

	
	
	
	
/*---------------------------------------------------------
	HUD ability info
---------------------------------------------------------*/	
	local Puck = Ply:GetNetPuck()
	local Puckref = Puck:GetRef()	
	
	
	---------------------------------------------------------*/	
	--E key hud display
	draw.RoundedBox(0, 0, ScrH()-200, 85, 45, Color(50,50,50,255))			--background box
	draw.RoundedBox(0, 85, ScrH()-195, 190, 35, Color(50,50,50,180))			--2nd background box
	draw.SimpleText("'E'", "Trebuchet18", 40, ScrH() - 195, Color(255,255,255,255), TEXT_ALIGN_CENTER) 

	local e_text = "Grab"
	if Puckref.override_e != nil then
		e_text = Puckref.override_e
	end
	draw.SimpleText( e_text, "DermaLarge", 100, ScrH() - 195, Color(200,200,200,255)) 


	
	---------------------------------------------------------*/	
	--Shift key hud display
	draw.RoundedBox(0, 0, ScrH()-150, 85, 45, Color(50,50,50,255))			--background box
	draw.RoundedBox(0, 85, ScrH()-145, 190, 35, Color(50,50,50,180))			--2nd background box
	draw.SimpleText("'SHIFT'", "Trebuchet18", 40, ScrH() - 145, Color(255,255,255,255), TEXT_ALIGN_CENTER) 
	
	local shift_text = "Construct"
	if Puckref.override_shift != nil then
		shift_text = Puckref.override_shift
	end
	draw.SimpleText( shift_text, "DermaLarge", 100, ScrH() - 145, Color(200,200,200,255)) 
	
	--if it has the crafting ray, draw the box which says what you will convert the thing to
	if Puckref.override_shift == nil then
		local craft = Ply:GetCraft()
		local craftref = TableReference_Craft( craft )
	
		draw.RoundedBox(0, 275, ScrH()-140, 140, 25, Color(50,50,50,110))
		draw.SimpleText("- " .. craftref.print_name, "Trebuchet18", 280, ScrH() - 135, Color(255,255,255,255), TEXT_ALIGN_LEFT) 
	end
	
	
	
	---------------------------------------------------------*/	
	--Ctrl key hud display
	draw.RoundedBox(0, 0, ScrH()-100, 85, 45, Color(50,50,50,255))			--background box
	draw.RoundedBox(0, 85, ScrH()-95, 190, 35, Color(50,50,50,180))			--2nd background box
	draw.SimpleText("'CTRL'", "Trebuchet18", 40, ScrH() - 95, Color(255,255,255,255), TEXT_ALIGN_CENTER) 
	
	local alt_text = "Zap"
	if Puckref.override_alt != nil then
		alt_text = Puckref.override_alt
	end
	draw.SimpleText( alt_text, "DermaLarge", 100, ScrH() - 95, Color(200,200,200,255)) 


	
	---------------------------------------------------------*/	
	--Control key hud display
	if Puckref.override_ctrl_off != true then
		draw.RoundedBox(0, 0, ScrH()-50, 85, 45, Color(50,50,50,255))			--background box
		draw.RoundedBox(0, 85, ScrH()-45, 190, 35, Color(50,50,50,180))			--2nd background box
		draw.SimpleText("'CTRL'", "Trebuchet18", 40, ScrH() - 45, Color(255,255,255,255), TEXT_ALIGN_CENTER) 
		
		local ctrl_text = "Fuse to Friend"
		if Puckref.override_ctrl != nil then
			ctrl_text = Puckref.override_ctrl
		end
		draw.SimpleText( ctrl_text, "DermaLarge", 100, ScrH() - 45, Color(200,200,200,255)) 
	end
	
	
	
	
	
	
	
	--[[
		---------------------------------------------------------*/	
	--Alt key hud display
	draw.RoundedBox(0, 0, ScrH()-50, 85, 45, Color(50,50,50,255))			--background box
	draw.RoundedBox(0, 85, ScrH()-45, 190, 35, Color(50,50,50,180))			--2nd background box
	draw.SimpleText("'ALT'", "Trebuchet18", 40, ScrH() - 45, Color(255,255,255,255), TEXT_ALIGN_CENTER) 
	
	local alt_text = "Zap"
	if Puckref.override_alt != nil then
		alt_text = Puckref.override_alt
	end
	draw.SimpleText( alt_text, "DermaLarge", 100, ScrH() - 45, Color(200,200,200,255)) 


	
	---------------------------------------------------------*/	
	--Control key hud display
	if Puckref.override_ctrl_off != true then
		draw.RoundedBox(0, 0, ScrH()-100, 85, 45, Color(50,50,50,255))			--background box
		draw.RoundedBox(0, 85, ScrH()-95, 190, 35, Color(50,50,50,180))			--2nd background box
		draw.SimpleText("'CTRL'", "Trebuchet18", 40, ScrH() - 95, Color(255,255,255,255), TEXT_ALIGN_CENTER) 
		
		local ctrl_text = "Fuse to Friend"
		if Puckref.override_ctrl != nil then
			ctrl_text = Puckref.override_ctrl
		end
		draw.SimpleText( ctrl_text, "DermaLarge", 100, ScrH() - 95, Color(200,200,200,255)) 
	end
	
	]]--
	
	
	
	
	
	
	
/*---------------------------------------------------------
	SWEP code
---------------------------------------------------------*/	

	if Ply:GetActiveWeapon( ) != NULL then
		local swepref = Ply:GetActiveWeapon( ):GetRef()
		
	
		---------------------------------------------------------*/	
		--Primary key hud display
		local primname = swepref.primary_print_name
		draw.RoundedBox(0, ScrW()-85, ScrH()-235, 85, 45, Color(50,50,50,255))			--background box
		draw.RoundedBox(0, ScrW()-275, ScrH()-230, 190, 35, Color(50,50,50,180))			--2nd background box
		draw.SimpleText("'PRIMARY'", "Trebuchet18", ScrW()-40, ScrH() - 228, Color(255,255,255,255), TEXT_ALIGN_CENTER) 

		
		local AmmoPrimary = Ply:GetActiveWeapon( ):Clip1() 
		
		if AmmoPrimary == 0 then
			draw.SimpleText( AmmoPrimary, "DermaLarge", ScrW()-250, ScrH() - 228, Color(255,100,100,255), TEXT_ALIGN_CENTER) 
			draw.SimpleText( primname, "DermaLarge", ScrW()-100, ScrH() - 228, Color(200,100,100,255), TEXT_ALIGN_RIGHT) 
		else
			draw.SimpleText( AmmoPrimary, "DermaLarge", ScrW()-250, ScrH() - 228, Color(255,255,255,255), TEXT_ALIGN_CENTER) 
			draw.SimpleText( primname, "DermaLarge", ScrW()-100, ScrH() - 228, Color(200,200,200,255), TEXT_ALIGN_RIGHT) 
		end
		
		if Ply:GetGainedDamage() != 0 then
			local gain = Ply:GetGainedDamage()
			draw.SimpleTextOutlined( "+" .. gain .. " dmg", "TargetID", ScrW()-100, ScrH() - 250, Color(255,255,255,255), 1, 1, 1, Color(0, 0, 0, 255))			
		end
		
		
		---------------------------------------------------------*/	
		--Secondary key hud display
		local secname = swepref.secondary_print_name
		if secname != nil then
			draw.RoundedBox(0, ScrW()-85, ScrH()-185, 85, 45, Color(50,50,50,255))			--background box
			draw.RoundedBox(0, ScrW()-275, ScrH()-180, 190, 35, Color(50,50,50,180))			--2nd background box
			draw.SimpleText("'SECONDARY'", "Trebuchet18", ScrW()-40, ScrH() - 178, Color(255,255,255,255), TEXT_ALIGN_CENTER) 

			
			local AmmoSecondary = Ply:GetActiveWeapon( ):Clip2() 
			
			if AmmoSecondary == 0 then
				draw.SimpleText( AmmoSecondary, "DermaLarge", ScrW()-250, ScrH() - 178, Color(255,100,100,255), TEXT_ALIGN_CENTER) 
				draw.SimpleText( secname, "DermaLarge", ScrW()-100, ScrH() - 178, Color(200,100,100,255), TEXT_ALIGN_RIGHT) 
			else
				draw.SimpleText( AmmoSecondary, "DermaLarge", ScrW()-250, ScrH() - 178, Color(255,255,255,255), TEXT_ALIGN_CENTER) 
				draw.SimpleText( secname, "DermaLarge", ScrW()-100, ScrH() - 178, Color(200,200,200,255), TEXT_ALIGN_RIGHT) 
			end
		end
		
		
		---------------------------------------------------------*/	
		--Thirdary key hud display
		local third = Ply:GetSwepAbility()
		if third != 0 and third != nil and third != "" then
			local third_ref = SwepabilityReference( third )
		
			draw.RoundedBox(0, ScrW()-85, ScrH()-135, 85, 45, Color(50,50,50,255))			--background box
			draw.RoundedBox(0, ScrW()-275, ScrH()-130, 190, 35, Color(50,50,50,180))			--2nd background box
			draw.SimpleText("'RELOAD KEY'", "Trebuchet18", ScrW()-40, ScrH() - 128, Color(255,255,255,255), TEXT_ALIGN_CENTER) 


			local AmmoThirdary = ""
			if third_ref.dont_show_ammo != true then
				AmmoThirdary = Ply:GetActiveWeapon( ):Clip3() 
			end
			
			if AmmoThirdary == 0 then
				draw.SimpleText( AmmoThirdary, "DermaLarge", ScrW()-250, ScrH() - 128, Color(255,100,100,255), TEXT_ALIGN_CENTER)
				draw.SimpleText( third_ref.print_name, "DermaLarge", ScrW()-100, ScrH() - 128, Color(200,100,100,255), TEXT_ALIGN_RIGHT) 
			else
				draw.SimpleText( AmmoThirdary, "DermaLarge", ScrW()-250, ScrH() - 128, Color(255,255,255,255), TEXT_ALIGN_CENTER) 
				draw.SimpleText( third_ref.print_name, "DermaLarge", ScrW()-100, ScrH() - 128, Color(200,200,200,255), TEXT_ALIGN_RIGHT) 
			end
		end
		
	
	end
	
	
	if Ply:GetHeldEnt() != "0" and Ply:GetHeldEnt() != 0 then
		//print( Ply:GetHeldEnt() )
		local heldent = Ply:GetHeldEnt()
		local entref = EntReference( heldent )
		
		draw.RoundedBox(0, ScrW()-85, ScrH()-320, 85, 20, Color(50,50,50,255))
		draw.SimpleText("INVENTORY:", "Trebuchet18", ScrW()-40, ScrH() - 320, Color(255,255,255,255), TEXT_ALIGN_CENTER) 
		
		draw.RoundedBox(0, ScrW()-140, ScrH()-300, 140, 20, Color(50,50,50,180))
		draw.SimpleText( entref.print_name, "Trebuchet18", ScrW()-70, ScrH() - 300, Color(100,200,100,255), TEXT_ALIGN_CENTER) 
	end
	

/*---------------------------------------------------------
	Quick menu display
---------------------------------------------------------*/		

	if Ply:Team() != TEAM_SPEC then
		draw.RoundedBox(0, 180, ScrH()-35, 125, 35, Color(50,50,50,255))	
		draw.SimpleText("'Q' - Quick Menu", "Trebuchet18", 240, ScrH() - 30, Color(255,255,255,255), TEXT_ALIGN_CENTER) 
	end	
	
	
	
	
	--highlight keys as theyre pressed
	
	if PlyPressing_Primary == true then
		--white highlight box
		draw.RoundedBox(0, ScrW()-85, ScrH()-235, 85, 45, Color(255,255,255,100))	
	end
	
	if PlyPressing_Secondary == true then
		--white highlight box
		draw.RoundedBox(0, ScrW()-85, ScrH()-185, 85, 45, Color(255,255,255,100))	
	end
	
	if PlyPressing_Thirdary == true then
		--white highlight box
		draw.RoundedBox(0, ScrW()-85, ScrH()-135, 85, 45, Color(255,255,255,100))	
	end
	
	if PlyPressing_E == true then
		--white highlight box
		draw.RoundedBox(0, 0, ScrH()-200, 85, 45, Color(255,255,255,100))
	end
	
	if PlyPressing_Shift == true then
		--white highlight box
		draw.RoundedBox(0, 0, ScrH()-150, 85, 45, Color(255,255,255,100))	
	end
	
	//if PlyPressing_Alt == true then
		--white highlight box
		//draw.RoundedBox(0, 0, ScrH()-100, 85, 45, Color(255,255,255,100))	
	//end
	
	if PlyPressing_Control == true then
		--white highlight box
		draw.RoundedBox(0, 0, ScrH()-100, 85, 45, Color(255,255,255,100))	
	end
	
	if PlyPressing_Q == true then
		--white highlight box
		draw.RoundedBox(0, 180, ScrH()-35, 125, 35, Color(255,255,255,100))
	end





	
	
	
--old way
--[[
	local Ability_A = Ply:GetAbilityInfo("Primary")
	
	if Ability_A.name != "none" then

		draw.RoundedBox(0, 0, ScrH()-185, 85, 45, Color(50,50,50,255))			--background box
		
		draw.RoundedBox(0, 85, ScrH()-180, 190, 35, Color(50,50,50,180))			--2nd background box
		
		draw.SimpleText("'PRIMARY'", "Trebuchet18", 40, ScrH() - 178, Color(255,255,255,255), TEXT_ALIGN_CENTER) 
		
		local ref = AbilReference( Ability_A.name )
		
		--draw in red if its in cooldown (cant be used)
		if (Ability_A.cooldown) == true then
			draw.SimpleText( ConvertToPrintName(Ability_A.name), "DermaLarge", 100, ScrH() - 178, Color(255,100,100,255))
		else
			draw.SimpleText( ConvertToPrintName(Ability_A.name), "DermaLarge", 100, ScrH() - 178, Color(200,200,200,255)) 
		end
		
		--change display settings depending on if its single charge or multi charge.
		if ref.charges > 1 then
			--draw in red if they have 0 charges left
			if Ability_A.charges == 0 then
				draw.SimpleText( Ability_A.charges, "DermaLarge", 250, ScrH() - 178, Color(255,100,100,255), TEXT_ALIGN_CENTER) 
			else
				draw.SimpleText( Ability_A.charges, "DermaLarge", 250, ScrH() - 178, Color(255,255,255,255), TEXT_ALIGN_CENTER) 
			end
		else
			draw.SimpleText( Ability_A.time, "DermaLarge", 250, ScrH() - 178, Color(255,100,100,255), TEXT_ALIGN_CENTER) 
		end

	end
	
	
	
	local Ability_B = Ply:GetAbilityInfo("Secondary")
	
	if Ability_B.name != "none" then

		draw.RoundedBox(0, 0, ScrH()-235, 85, 45, Color(50,50,50,255))			--background box
		
		draw.RoundedBox(0, 85, ScrH()-230, 190, 35, Color(50,50,50,180))			--2nd background box
		
		draw.SimpleText("'ALT'", "Trebuchet18", 40, ScrH() - 228, Color(255,255,255,255), TEXT_ALIGN_CENTER) 
		if (Ability_B.cooldown) == true then
			draw.SimpleText( ConvertToPrintName(Ability_B.name), "DermaLarge", 100, ScrH() - 228, Color(255,100,100,255)) 
			draw.SimpleText( Ability_B.time, "DermaLarge", 250, ScrH() - 228, Color(255,100,100,255), TEXT_ALIGN_CENTER) 
		else
			draw.SimpleText( ConvertToPrintName(Ability_B.name), "DermaLarge", 100, ScrH() - 228, Color(200,200,200,255)) 
		end
	end
	

	local Ability_C = Ply:GetAbilityInfo("c")
	
	if Ability_C.name != "none" then

		draw.RoundedBox(0, 0, ScrH()-285, 85, 45, Color(50,50,50,255))			--background box
		
		draw.RoundedBox(0, 85, ScrH()-280, 190, 35, Color(50,50,50,180))			--2nd background box
		
		draw.SimpleText("'IN_WALK'", "Trebuchet18", 40, ScrH() - 278, Color(255,255,255,255), TEXT_ALIGN_CENTER) 
		if (Ability_C.cooldown) == true then
			draw.SimpleText( ConvertToPrintName(Ability_C.name), "DermaLarge", 100, ScrH() - 278, Color(255,100,100,255)) 
			draw.SimpleText( Ability_C.time, "DermaLarge", 250, ScrH() - 278, Color(255,100,100,255), TEXT_ALIGN_CENTER) 
		else
			draw.SimpleText( ConvertToPrintName(Ability_C.name), "DermaLarge", 100, ScrH() - 278, Color(200,200,200,255)) 
		end
	end
	]]--
	
	
	
	
	
	
	
	
	
	

	

	
	
/*---------------------------------------------------------
	Bad Crosshair
---------------------------------------------------------*/
	draw.RoundedBox(10, (ScrW()/2)-3, (ScrH() / 2)-3, 6, 6, Color(0,0,0,75))
	


	
	
	
	
	

	
	
	
	
	
	
	
	

	

/*---------------------------------------------------------
	Healthbar
---------------------------------------------------------*/
	if not IsValid( Puck ) then return end
	
	//local healthmax = Puckref.health
	local healthmax = Puck:GetMaxHealth()
	//print(healthmax)
	local health = Puck:Health()
	if health <= 0 then
		health = 0
	end
	
	local health_color = Color(255,255,255,255)
	local health_color_bg = Color(100,100,100,255)
	
	if LocalPlayer():Team() == TEAM_RED then
		health_color = Color(239,69,82,255)
		health_color_bg = Color(100,0,0,255)
	elseif LocalPlayer():Team() == TEAM_BLUE then
		health_color = Color(97,187,211,255)
		health_color_bg = Color(0,0,100,255)
	end
	
	local healthratio = ((health/healthmax)*100)
	
	draw.RoundedBox(0, ScrW()-420, ScrH()-50, 420, 50, Color(20,20,20,255))			--background box
	draw.RoundedBox(0, ScrW()-405, ScrH() - 15 - 20, 400, 25, health_color_bg) --background health bar
	draw.RoundedBox(0, ScrW()-405, ScrH() - 15 - 20, healthratio*4, 25, health_color) --changing health bar
	draw.SimpleText(health, "DermaLarge", ScrW()-405, ScrH() - 45, Color(255,255,255,255)) --health number text
	
	
	
	
end 

hook.Add("HUDPaint", "HealthHud", hud)

