/*---------------------------------------------------------
	Game Settings
---------------------------------------------------------*/









--Attribute Vars


BEGINNING_COUNTDOWN = 5

PUBMODE_COUNTDOWN = 60



--how much health each team's bug brain starts with
BRAIN_HP = 800 --800
SHIELD_HP = 200 --800


//BEGINNING_COUNTDOWN = 30		--seconds to countdown from when beginning the round once all players are ready
CRYSTAL_SPAWN_CANCEL_RADIUS = 70
CRYSTAL_SPAWN_HEIGHT = 100
CRYSTAL_NEARBY_CRAFT_COMBINE_RADIUS = 100
//CRYSTAL_SPAWN_INTERVAL = 60


SETUP_TIME = 150 --150
GAME_DURATION = 1200 --900 15 min     --600 10 min

PREGAME_STRUCTURE_LIMIT = 100


--respawn time is higher depending on how many players are on the team
RESPAWN_TIME_1_PLY = 5
RESPAWN_TIME_2_PLY = 10
RESPAWN_TIME_3_PLY = 15
RESPAWN_TIME_4_PLY = 20




RESPAWN_TIME_PREGAME = 1

STARTING_LIVES_PER_PLAYER = 5


--this is now obsolete
STARTING_TOKENS_PER_PLAYER = 10

--this is split amongst the players
STARTING_TEAM_TOKENS = 50

--how many tokens are given during the pre game phase for people to dick around with
STARTING_TOKENS_NOPLAYERS = 10




--CAPTURE ZONE VARS---------------------------------
TIME_CAP_FAST = 1
TIME_CAP_SLOW = 3
GOALBALL_POINTS = 2

--subtracts a point from the capturement of the point every X amount of seconds
POINT_SUBTRACTION_INTERVAL = 15

--the maximum amount of points a team can have without worrying about it decaying
POINT_SUBTRACTION_THRESHOLD = 300

--the points required to win, theyre added every half second during capture, so this would take 30 seconds
POINT_WINNING_AMOUNT = 30








--unused
TOKENS_PER_INTERVAL = 0

--spawns tokens every X amount of seconds6
TOKENS_SPAWN_INTERVAL = 30 --30



MAX_NAME_RENDER_DISTANCE = 4000







TIME_RECALL = 4
SOUND_RECALL_FINISH = "bugboys/portal_disappear.wav"
SOUND_RECALL_APPEAR = "bugboys/portal_appear.wav"
SOUND_RECALL_LOOP = "bugboys/portal_loop.wav"

SOUND_STARWARS_GUN = "bugboys/starwars_gun.wav"


SOUND_JUMP = "npc/fast_zombie/claw_miss1.wav"
SOUND_SENTRYSPOT = "bugboys/sentry_spot.wav"
//SOUND_YELL = "npc/headcrab_poison/ph_idle"..math.random(1, 3)..".wav"


--Art Vars without a table to call home
CRYSTAL_SPAWN_SOUND = "buttons/button5.wav"
CRAFTRAY_DAMAGE = 10
LAVA_DAMAGE = 10


TEST_SOUND = Sound("buttons/blip1.wav")
MATERIAL_WHITE = "models/debug/debugwhite"

SOUND_GRAB = "physics/metal/metal_sheet_impact_soft2.wav"
SOUND_UNGRAB = "physics/metal/metal_sheet_impact_hard8.wav"

SOUND_FUSE = "ambient/energy/spark1.wav"
SOUND_UNFUSE = "ambient/energy/spark2.wav"

SOUND_ATTEMPT = "buttons/button18.wav"

SOUND_HEALHURT = "weapons/physcannon/physcannon_dryfire.wav"

//SOUND_BUG_HURT = "weapons/cleaver_hit_04.wav"
SOUND_BUG_HURT = "physics/flesh/flesh_strider_impact_bullet3.wav"

//SOUND_BUG_KILL = "physics/body/body_medium_impact_hard5.wav"
SOUND_BUG_KILL = "physics/wood/wood_plank_break1.wav"


SOUND_ALLEGIANCE_CHANGE = "npc/scanner/cbot_energyexplosion1.wav"



SOUND_CHEER = "bugboys/cheers.wav"

SOUND_ROPE_MAKE = "bugboys/rope_make.wav"
SOUND_ROPE_REMOVE = "bugboys/rope_remove.wav"



VOTING_TIME = 30

--the func_brush which the game will disable at the end of the setup time every round
//BRUSH_DOOR_NAME = "TTG_Brush_Door"




--VOTE_CHANGEMAP_ENABLED = true
--SERVER_MAPS = { "ttg_1path_v1", "ttg_2path_v1", "ttg_hole_a1", "ttg_knavey_a4", "ttg_canyon_a1", "ttg_foundry_a1",  }






--Custom settings
if SERVER then
	--Number of Rounds
	--The number of rounds to play per map
	local set_rounds = GetConVarNumber( "bb_var_rounds" )
	ROUNDS = set_rounds
	
	
	--
	local pubmode = GetConVarNumber( "bb_var_pubmode" )
	if pubmode <= 0 then
		PUB_MODE = false
		SetGlobalBool("Pub_Mode", false)
	elseif pubmode > 0 then
		PUB_MODE = true
		SetGlobalBool("Pub_Mode", true)
	end
	--
	
	
	--Developer mode
	--makes it so menus switch fast, noclip is enabled, the game doesnt end if one teams dead, etc
	local set_devmode = GetConVarNumber( "bb_var_devmode" )
	if set_devmode <= 0 then
		DEV_MODE = false
	elseif set_devmode > 0 then
		DEV_MODE = true
	end
	
	
	
	local set_duration = GetConVarNumber( "bb_var_gametime" )
	if set_duration != nil then
		GAME_DURATION = set_duration
	end
	
	
	
	local set_setuptime = GetConVarNumber( "bb_var_setuptime" )
	if set_setuptime != nil then
		SETUP_TIME = set_setuptime
	end
	
	
	
	local set_startingtokens = GetConVarNumber( "bb_var_startingtokens" )
	if set_startingtokens != nil then
		STARTING_TEAM_TOKENS = set_startingtokens
	end
end






if SERVER then
	print("Restarted!")
end







if DEV_MODE == true then
	if SERVER then
		print("This is Dev mode!")
	end

	--allows the game to start even if theres only one player on one of the two teams
	MUST_HAVE_ATEAST_1PLAYER_PERTEAM = false

else
	MUST_HAVE_ATEAST_1PLAYER_PERTEAM = true
end