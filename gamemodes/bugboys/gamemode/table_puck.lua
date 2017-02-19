/*---------------------------------------------------------
	Puck class base table
---------------------------------------------------------*/

PUCK_TABLE = 
{


puck_smallman =
{
name = "puck_smallman",
print_name = "Engineer",
--model = "models/props_vehicles/carparts_tire01a.mdl",
--model = "models/props_2fort/trainwheel001.mdl",
model = "models/bugboys/engineer.mdl",
//model = "models/props_vehicles/apc_tire001.mdl",
--model = "models/hitchswing/grappler.mdl",
--model = "models/props_2fort/tire001.mdl", --regularly positioned model version
--model = "models/props_vehicles/tire001a_tractor.mdl",
--model = "models/props_vehicles/tire001b_truck.mdl",
swep = "swep_smallman",
health = 100, --125
cam_dist = 120, --120
cam_height = 75, --50
speed_max = 270,
force_add = 2000, --1200, doing an experiment with this number
craft_dist = 400, --350
zap_dist = 100,
zap_trigger_dist = 3000,
mass = 200,
speed_jump = 63000, --60000
height_spawn = 10,
radius_weld = 50,
jump_cooldown = 3,
noise_cooldown = .7,
noise_cooldown_scream = 2,

ungrab_dist = 80,
override_ctrl_off = true,
}
,

--[[
puck_blimp =
{
name = "puck_blimp",
print_name = "Blimp",
model = "models/bugboys/blimp.mdl",
swep = "swep_blimp",
health = 125, --125
cam_dist = 250,  --300
cam_height = -140, ---100
speed_max = 250, --250
mass = 5000,
force_add = 10000,
force_add_vertical = 13000,
momentum_decay = 1,
height_spawn = 20,
rope_length = 500,
craft_dist = 400,
zap_dist = 150,
override_rope = false,
override_magnetize = true,
override_convert = false,
override_ctrl = "Down Thrust",
override_shift = "Drop Token",
override_e = "Rope",
}
,

puck_tank =
{
name = "puck_tank",
print_name = "Tank",
//model = "models/props_wasteland/wheel02b.mdl",
model = "models/bugboys/tank.mdl",
--model = "models/tacticaltoolgame_models/boulder01.mdl",
swep = "swep_tank",
health = 250,
mass = 5000,
cam_dist = 200, --175
cam_height = 90, --75
speed_max = 250,
force_add = 3500, --3500
momentum_decay = 1,
height_spawn = 20,
craft_dist = 400,
zap_dist = 150,
radius_weld = 110, --91
slowed_speed = 25,
override_shift = "Drop Token",

ungrab_dist = 130,
override_ctrl_off = true,
}
,

puck_climber =
{
name = "puck_climber",
print_name = "Climber",
model = "models/bugboys/climber.mdl",
swep = "swep_climber",
health = 100,
cam_dist = 115,	--130
cam_height = 60, --60
speed_max = 270,
force_add = 1500, --1500 --1000
craft_dist = 300,
zap_dist = 100,
mass = 200,
speed_jump = 80000, --70000
jump_cooldown = 1.5,
height_spawn = 10,
radius_weld = 50, --35
dropslam_radius = 250,
dropslam_damage = .08,	--.13
dropslam_damage_high = .13,	--.2
sound_dropslam = "ambient/explosions/explode_2.wav",
override_e = "Grapple",
override_shift = "Drop Token",

ungrab_dist = 80,
override_ctrl_off = true,
}
,


puck_rammer =
{
name = "puck_rammer",
print_name = "Rammer",
model = "models/bugboys/rammer.mdl",
swep = "swep_rammer",
health = 100,
cam_dist = 100,
cam_height = 40,
speed_max = 250,
speed_max_upper = 1000,
force_add = 1000, --1500 --1000
rope_length = 500,
craft_dist = 300,
zap_dist = 100,
mass = 200,
speed_jump = 60000, --70000
height_spawn = 10,
radius_weld = 40,
override_shift = "Drop Token",

time_boost = .2,
force_boost = 2300,
damage_hit = 50,
damage_mul_player = .003,
damage_mul_structure = .002,

ungrab_dist = 80,
override_ctrl_off = true,
}
,

puck_jetpack =
{
name = "puck_jetpack",
print_name = "Jetpacker",
model = "models/bugboys/jetpack.mdl",
swep = "swep_jetpack",
health = 100, --125
cam_dist = 200,  --200
cam_height = 60, ---100
mass = 200,
speed_max = 270,
force_add = 1200,
force_add_vertical = 2800,
momentum_decay = 1,
height_spawn = 20,
rope_length = 300,
craft_dist = 300,
zap_dist = 100,
radius_weld = 40,
override_rope = false,
override_magnetize = true,
override_convert = false,
override_shift = "Drop Token",

ungrab_dist = 80,
override_ctrl_off = true,

sound_jet = "npc/manhack/mh_engine_loop1.wav",
jetpack_multiplier1 = 165, --200
jetpack_multiplier2 = 115, --130
jetpack_multiplier3 = 5,
jetpack_frame_phase1 = 100,
jetpack_frame_phase2 = 400, --300
jetpack_cooldown = .5,
}
,

]]--

}

--recieves an actual ent, not the string name of one
function CheckIfInPuckTable(ent)
	for _, value in pairs( PUCK_TABLE ) do		--/check if the ent is one of the the games's objects
		if value.name == ent:GetClass() then
			return true
		end
	end
	return false
end


function PuckReference( entstring )		--returns the ent from the main table of stats for easy reference
	local ref = nil
	for _, ent in pairs( PUCK_TABLE ) do
		if ent.name == entstring then
			ref = ent
		end
	end
	return ref
end


//returns the name of the puck, based on the print name
function ConvertToName_Puck(printname)	
	local name = nil
	for _, puck in pairs(PUCK_TABLE) do
		if puck.print_name == printname then
			name = puck.name
			return name
		end
	end
	return "invalid puck name"
end


function ConvertToPrintName_Puck( toolname )	//returns the print name of the input tool name
	local printname = nil
	for _, tool in pairs(PUCK_TABLE) do
		if tool.name == toolname then
			printname = tool.print_name
			return printname
		end
	end
	return "invalid tool name"
end