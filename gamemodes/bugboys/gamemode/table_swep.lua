/*---------------------------------------------------------
	Tool stats base table
---------------------------------------------------------*/
//any buyable tool thats meant to be an usable in the game must be in this table, all base stats derive from it
//this is meant to be used by the buying menu mostly, for when you buy tool SWEPs
//Tool = SWEP



SWEP_TABLE = 
{



swep_smallman =
{
name = "swep_smallman",

primary_print_name = "Slider",
primary_func = "func_smallman_slider",
primary_delay = .5, --.7
primary_clip = 4,
primary_reload = 2, --2

secondary_print_name = "Airblast",
secondary_func = "func_smallman_airblast",
secondary_delay = 1,
secondary_clip = 1,
secondary_reload = 4,

--[[
thirdary_print_name = "Detonate",
thirdary_func = "func_smallman_detonate",
thirdary_delay = 1,
thirdary_clip = 1,
thirdary_reload = 5,
//thirdary_dont_show_ammo = true,
]]--

sound_reload = Sound("weapons/smg_worldreload.wav")	,
sound_reload2 = Sound("buttons/blip1.wav"),
sound_shoot = Sound("weapons/smg1/smg1_fire1.wav"),
}
,



swep_tank =
{
name = "swep_tank",

primary_print_name = "Bomb",
primary_func = "func_tank_airbomb",
primary_chargeup_time = 0,
primary_delay = 1,
primary_clip = 1,
primary_reload = 2.5,
primary_sound_reload = Sound("weapons/smg_worldreload.wav")	,

secondary_print_name = "Airblast",
secondary_func = "func_smallman_airblast",
secondary_delay = 1,
secondary_clip = 1,
secondary_reload = 4,

sound_shoota = Sound("ambient/explosions/explode_4.wav"),
sound_shootb = Sound("Weapon_Mortar.Single"),
//sound_chargeup = Sound("npc/strider/charging.wav"),
sound_chargeup = Sound("Weapon_Mortar.Single"),
}
,



swep_blimp =
{
name = "swep_blimp",

primary_print_name = "Bomb",
primary_func = "func_blimp_airbomb",
primary_delay = .5,
primary_clip = 1,
primary_reload = 2,
primary_sound_reload = Sound("weapons/smg_worldreload.wav")	,

secondary_print_name = "Heal Ray",
secondary_func = "func_blimp_heal",
secondary_delay = .8,
secondary_clip = 1,
secondary_reload = 1,

thirdary_print_name = "Unrope Target",
thirdary_func = "func_blimp_unrope",
thirdary_delay = 1,
thirdary_clip = 1,
thirdary_reload = 8,
thirdary_dont_show_ammo = true,

sound_reload = Sound("weapons/smg_worldreload.wav")	,
sound_shootmissile = Sound("Weapon_Mortar.Single"),
}
,


swep_climber =
{
name = "swep_climber",

primary_print_name = "Bomb",
primary_func = "func_climber_bomb",
primary_delay = .5,
primary_clip = 5,
primary_reload = 2,

secondary_print_name = "JumpSlam",
secondary_func = "func_climber_jumpslam",
secondary_delay = 1,
secondary_clip = 1,
secondary_reload = 10,

thirdary_print_name = "Redeploy",
thirdary_func = "func_climber_redeploy",
thirdary_delay = 1,
thirdary_clip = 1,
thirdary_reload = 8,
thirdary_dont_show_ammo = true,

sound_reload = Sound("weapons/smg_worldreload.wav")	,
sound_reload2 = Sound("buttons/blip1.wav"),
sound_shoot = Sound("weapons/smg1/smg1_fire1.wav"),
}
,


swep_rammer =
{
name = "swep_rammer",

primary_print_name = "",
primary_func = "",
primary_delay = 0,
primary_clip = 0,
primary_reload = 4,

secondary_print_name = "",
secondary_func = "",
secondary_delay = 0,
secondary_clip = 0,
secondary_reload = 5,

sound_reload = Sound("weapons/smg_worldreload.wav")	,
sound_reload2 = Sound("buttons/blip1.wav"),
sound_shoot = Sound("weapons/smg1/smg1_fire1.wav"),
}
,


swep_jetpack =
{
name = "swep_jetpack",

primary_print_name = "Buggler",
primary_func = "func_jetpack_airbomb",
primary_delay = .8,
primary_clip = 5,
primary_reload = 2.5,

secondary_print_name = "Airblast",
secondary_func = "func_smallman_airblast",
secondary_delay = 1,
secondary_clip = 1,
secondary_reload = 4,

sound_reload = Sound("weapons/smg_worldreload.wav")	,
sound_reload2 = Sound("buttons/blip1.wav"),
sound_shoot = Sound("weapons/smg1/smg1_fire1.wav"),
}
,

}




function SwepReference(toolstring)		//returns the tool from the main table of stats for easy reference
	local ref = nil
	for _, tool in pairs(SWEP_TABLE) do
		if tool.name == toolstring then
			ref = tool
		end
	end
	return ref
end



--[[

function CheckIfInToolTable(str)
	for _, value in pairs(TOOL_TABLE) do		///check if the ent is one of the the games's objects
		if value.name == str then
			return true
		end
	end
	return false
end


function ConvertToPrintName(toolname)	//returns the print name of the input tool name
	local printname = nil
	for _, tool in pairs(TOOL_TABLE) do
		if tool.name == toolname then
			printname = tool.print_name
			return printname
		end
	end
	return "invalid tool name"
end

function ConvertToName(toolprintname)	//converts in reverse from printname to name
	local name = nil
	for _, tool in pairs(TOOL_TABLE) do
		if tool.print_name == toolprintname then
			name = tool.name
			return name
		end
	end
	return "invalid tool print name"
end

]]--