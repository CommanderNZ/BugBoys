/*---------------------------------------------------------
	Client Game Time Display
---------------------------------------------------------*/
local curgametime = "00:00"

local function TimeHud()

	local function  GameTimerUpdate(num)
		curgametime = num:ReadString()
		
		//local dosounds = GetGlobalBool("CL_PlayTimerCountSounds")
		//if dosounds != true then return end
		
		if curgametime == "00:05" then
			//surface.PlaySound( "vo/announcer_begins_5sec.wav" )
			surface.PlaySound( "buttons/button3.wav" )
		elseif curgametime == "00:04" then
			//surface.PlaySound( "vo/announcer_begins_4sec.wav" )
			surface.PlaySound( "buttons/button3.wav" )
		elseif curgametime == "00:03" then
			//surface.PlaySound( "vo/announcer_begins_3sec.wav" )
			surface.PlaySound( "buttons/button3.wav" )
		elseif curgametime == "00:02" then
			//surface.PlaySound( "vo/announcer_begins_2sec.wav" )
			surface.PlaySound( "buttons/button3.wav" )
		elseif curgametime == "00:01" then
			//surface.PlaySound( "vo/announcer_begins_1sec.wav" )
			surface.PlaySound( "buttons/button3.wav" )
		end
	end
	usermessage.Hook("GameTimerUpdate", GameTimerUpdate)
	
	//draw.SimpleText(curgametime, "DermaLarge", 10, ScrH() - 100, Color(255,255,255,255))

	//the grey box behind the time display text
	draw.RoundedBox(20, ScrW()/2 - 50, 0, 100, 45, Color(50,50,50,255))	

	local game_time = {}
		game_time.pos = {}
		game_time.pos[1] = ScrW()/2 -- x pos
		game_time.pos[2] = 25 -- y pos
		game_time.color = Color(255,255,255,255)
		game_time.text =  curgametime
		game_time.font = "DermaLarge"
		game_time.xalign = TEXT_ALIGN_CENTER -- Horizontal Alignment
		game_time.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
		draw.Text( game_time )

	
	--this should be fixed cause it spams overtime
	local overtime = GetGlobalBool("CL_DrawOvertime")
		if overtime == true then
			surface.PlaySound( "vo/announcer_overtime.wav" )
			
	
			draw.SimpleText("OVERTIME","SmallerFont",(ScrW()/2)+200, 140,Color(255,255,255,255))
		end

		
		
	--[[
	local redscore = team.GetScore( TEAM_RED )
	draw.SimpleTextOutlined( redscore .. "/" .. GetMaxScore() .. "    -", "TargetID", ScrW()/2 - 80, 25, Color(255, 190, 190, 255), 1, 1, 1, Color(0, 0, 0, 255))
	
	local bluescore = team.GetScore( TEAM_BLUE )
	draw.SimpleTextOutlined( "-    " .. bluescore ..  "/" .. GetMaxScore(), "TargetID", ScrW()/2 + 80, 25, Color(190, 190, 255, 255), 1, 1, 1, Color(0, 0, 0, 255))
	]]--
	
	
		
		
		
	local phase = GetGamePhase()

	--[[
	if phase == "BegunGame" or phase == "EndGame" then
		local reddeaths = GetHowManyDeaths( TEAM_RED )
		if reddeaths == 1 then
			draw.SimpleTextOutlined( reddeaths .. "  death    ", "TargetID", ScrW()/2 - 80, 25, Color(255, 190, 190, 255), 1, 1, 1, Color(0, 0, 0, 255))
		else
			draw.SimpleTextOutlined( reddeaths .. "  deaths    ", "TargetID", ScrW()/2 - 80, 25, Color(255, 190, 190, 255), 1, 1, 1, Color(0, 0, 0, 255))
		end
		
		local bluedeaths = GetHowManyDeaths( TEAM_BLUE )
		if bluedeaths == 1 then
			draw.SimpleTextOutlined( "    " .. bluedeaths ..  " death", "TargetID", ScrW()/2 + 80, 25, Color(190, 190, 255, 255), 1, 1, 1, Color(0, 0, 0, 255))
		else
			draw.SimpleTextOutlined( "    " .. bluedeaths ..  " deaths", "TargetID", ScrW()/2 + 80, 25, Color(190, 190, 255, 255), 1, 1, 1, Color(0, 0, 0, 255))
		end
	end
	]]--
	
	--show bug brain health
	if phase == "BegunGame" or phase == "EndGame" then
		local red_color = Color(239,69,82,255)
		local blue_color = Color(97,187,211,255)
		local grey_color = Color(200,200,200,150)
	
	
	
		--red bug brain health
		local red_hp = GetBrainHealth( TEAM_RED )
		local red_ratio = ((red_hp/BRAIN_HP)*100)
		
		
		draw.RoundedBox(0, ScrW()/2-170, 15, 110, 25, Color(100,100,100,255))
		draw.RoundedBox(0, ScrW()/2-165, 20, 100, 15, Color(0,0,0,255))
		draw.RoundedBox(0, ScrW()/2-165, 20, red_ratio*1, 15, red_color)
		draw.SimpleTextOutlined( red_hp .. "  hp", "TargetID", ScrW()/2 - 115, 8, red_color, 1, 1, 1, Color(0, 0, 0, 255))
		
		local red_hp_shield = GetShieldHealth( TEAM_RED )
		local red_ratio_shield = ((red_hp_shield/SHIELD_HP)*100)
		
		draw.RoundedBox(0, ScrW()/2-165, 25, red_ratio_shield*1, 5, grey_color)
		
	
		--blue bug brain health
		local blue_hp = GetBrainHealth( TEAM_BLUE )
		local blue_ratio = ((blue_hp/BRAIN_HP)*100)
		
		draw.RoundedBox(0, ScrW()/2 + 60, 15, 110, 25, Color(100,100,100,255))
		draw.RoundedBox(0, ScrW()/2 + 65, 20, 100, 15, Color(0,0,0,255))
		draw.RoundedBox(0, ScrW()/2 + 65, 20, blue_ratio*1, 15, blue_color)
		draw.SimpleTextOutlined( blue_hp .. "  hp", "TargetID", ScrW()/2 + 115, 8, blue_color, 1, 1, 1, Color(0, 0, 0, 255))
	
		local blue_hp_shield = GetShieldHealth( TEAM_BLUE )
		local blue_ratio_shield = ((blue_hp_shield/SHIELD_HP)*100)
		
		draw.RoundedBox(0, ScrW()/2 + 65, 25, blue_ratio_shield*1, 5, grey_color)
	
	end
	
	
	
	if phase == "NoPlayers" then
		if (GetGlobalBool("Pub_Mode", false) == true) then
			draw.SimpleTextOutlined("WAITING FOR PLAYERS", "TargetID", ScrW()/2, 55, Color(255, 255, 255, 255), 1, 1, 1, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER)
		else
			draw.SimpleTextOutlined("WAITING FOR PLAYERS TO READY-UP", "TargetID", ScrW()/2, 55, Color(255, 255, 255, 255), 1, 1, 1, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER)
		end
	elseif phase == "PreGame" then
		draw.SimpleTextOutlined("GAME STARTING...", "TargetID", ScrW()/2, 55, Color(255, 255, 255, 255), 1, 1, 1, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER)
	elseif phase == "SetupGame" then
		draw.SimpleTextOutlined("SETUP YOUR DEFENSES", "TargetID", ScrW()/2, 55, Color(255, 255, 255, 255), 1, 1, 1, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER)
	elseif phase == "BegunGame" then
		draw.SimpleTextOutlined("KILL THE ENEMY BUG BRAIN!", "TargetID", ScrW()/2, 55, Color(255, 255, 255, 255), 1, 1, 1, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER)
	elseif phase == "EndGame" then
		draw.SimpleTextOutlined("A TEAM WON!", "TargetID", ScrW()/2, 55, Color(255, 255, 255, 255), 1, 1, 1, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER)
	end
	
	
	
	--old method for team score
	--[[
	local red = Color(255, 200, 200, 255)
	local blue = Color(200, 200, 255, 255)
		
	local redscore = team.GetScore( TEAM_RED )
	local bluescore = team.GetScore( TEAM_BLUE )
	
	if bluescore < 10 then
		bluescore = (0 .. tostring(bluescore))
	end
	if redscore < 10 then
		redscore = (0 .. tostring(redscore))
	end
	
	if phase == "BegunGame" then
		draw.SimpleTextOutlined(redscore, "CustomBBFont_A", 35, 0, red, 3, 3, 3, Color(0, 0, 0, 255))
		draw.SimpleTextOutlined("Red Score", "TargetID", 60, 110, red, 3, 3, 3, Color(0, 0, 0, 255))
		
		
		draw.SimpleTextOutlined(bluescore, "CustomBBFont_A", ScrW()-160, 0, blue, 3, 3, 3, Color(0, 0, 0, 255))
		draw.SimpleTextOutlined("Blue Score", "TargetID", ScrW()-135, 110, blue, 3, 3, 3, Color(0, 0, 0, 255))
	end
	]]--
	
	
	local red_color = Color(239,69,82,255)
	local blue_color = Color(97,187,211,255)
	
	local plyteam = LocalPlayer():Team()
	if phase == "EndGame" then
		if GetWinningTeam() == TEAM_RED or GetWinningTeam() == TEAM_BLUE then
			if GetWinningTeam() == TEAM_BLUE then
				draw.SimpleTextOutlined("Blue team wins!", "CustomBBFont_A", 100, 100, blue_color, 3, 3, 3, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER)
			elseif GetWinningTeam() == TEAM_RED then
				draw.SimpleTextOutlined("Red team wins!", "CustomBBFont_A", 100, 100, red_color, 3, 3, 3, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER)
			end
			
			--play a winning or losing sound
			if GetWinningTeam() == plyteam then
				--winning sound
			else
				--losing sound
			end
		else
			draw.SimpleTextOutlined("It's a draw...", "CustomBBFont_A", 100, 100, white, 3, 3, 3, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER)
		end
	end


	--help info

	if phase == "NoPlayers" or phase == "PreGame" then
		//draw.SimpleTextOutlined("(Press F2 to switch teams or ready up)", "TargetID", 400, 15, Color(255, 255, 255, 255), 1, 1, 1, Color(0, 0, 0, 255), TEXT_ALIGN_RIGHT)
		//draw.SimpleTextOutlined("(type !votekick to kick someone)", "TargetID", 200, 15, Color(255, 255, 255, 255), 1, 1, 1, Color(0, 0, 0, 255), TEXT_ALIGN_RIGHT)
	else
		//draw.SimpleTextOutlined("(Press F2 to switch teams)", "TargetID", 400, 15, Color(255, 255, 255, 255), 1, 1, 1, Color(0, 0, 0, 255), TEXT_ALIGN_RIGHT)
	end

	
	
	
	--ready up
	if phase == "NoPlayers" or phase == "PreGame" then
	
		if LocalPlayer().Team == nil then return end
		if LocalPlayer():Team() == TEAM_SPEC then 
			draw.SimpleTextOutlined("(Press F2 to join a team)", "TargetID", 400, 15, Color(255, 255, 255, 255), 1, 1, 1, Color(0, 0, 0, 255), TEXT_ALIGN_RIGHT)
			return 
		end
	
		if (GetGlobalBool("Pub_Mode", false) != true) then
			local Ply = LocalPlayer()
			local ready = Ply:GetIfReady()
			draw.SimpleTextOutlined( LocalPlayer():Name() .. " : ", "CustomBBFont_B", ScrW()-400, 10, Color(255, 255, 255, 255), 3, 3, 3, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER)
			if ready == true then
				draw.SimpleTextOutlined( "Ready", "CustomBBFont_C", ScrW()-400, 50, Color(0,255, 0, 255), 3, 3, 3, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT)
			else	
				draw.SimpleTextOutlined( "Not Ready", "CustomBBFont_C", ScrW()-400, 50, Color(255, 0, 0, 255), 3, 3, 3, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT)
				draw.SimpleTextOutlined("(Press F2 to ready up in the menu)", "TargetID", ScrW()-270, 130, Color(255, 255, 255, 255), 1, 1, 1, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT)
			end
		end
	end
end
hook.Add("HUDPaint", "TimeHud", TimeHud)

