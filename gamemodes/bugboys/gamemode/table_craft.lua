/*---------------------------------------------------------
	Crafting base table
---------------------------------------------------------*/
--used by the GUI you use to set what you're crafting



--num = the line position in the gui the craftable will appear in
CRAFT_TABLE = 
{


--[[
craft_rope =
{	
name = "craft_rope",
print_name = "Upgrade: Rope",
ent = "structure_rope",
spawn_height = 32,
craft_time = 5,
crystals_required = 5,
description = "",
cant_into_walls = true,
cant_into_walls_dist = 32,
}
,
]]--

craft_quickport =
{	
name = "craft_quickport",
print_name = "Support: Quickport",
ent = "structure_quickport",
spawn_height = 32,
craft_time = 10,
crystals_required = 4,
description = "Creates a prop which you can teleport to by zapping it \nYou must be within its radius of 1500 to teleport to it",
cant_into_walls = true,
cant_into_walls_dist = 32,
on_zap_description = "Teleport to the quickport",
}
,


craft_dispenser =
{	
name = "craft_dispenser",
print_name = "Support: Healer",
ent = "structure_dispenser",
spawn_height = 32,
craft_time = 10, --10
crystals_required = 4,
description = "Heals nearby bugs and vehicles 3 hp every .5 seconds",
display_grabbable = true,
cant_into_walls = true,
cant_into_walls_dist = 32,
}
,

--[[
craft_ammoamp =
{	
name = "craft_ammoamp",
print_name = "Ammo Amp",
ent = "structure_ammoamp",
spawn_height = 32,
craft_time = 15, --10
crystals_required = 4,
description = "",
display_grabbable = true,
}
,
]]--

craft_wall =
{	
name = "craft_wall",
print_name = "Base: Wall",
ent = "structure_wall",
spawn_height = 96,
craft_time = 10,
crystals_required = 1,
//sets_angles = true,
description = "Big tanky box that blocks enemies \nOn zap:  Disables the wall temporarily",
box_collision = true,
on_zap_description = "Temporarily disable",
}
,


craft_token =
{	
name = "craft_token",
print_name = "Token",
ent = "structure_token",
spawn_height = 20, --8
craft_time = 0,
crystals_required = 1,
no_team = true,
description = "1 unit of token currency in physical form",
}
,

--[[
craft_bomb =
{
name = "craft_bomb",
print_name = "Bug-Bomb",
ent = "structure_bomb",
spawn_height = 48,
craft_time = 7,
crystals_required = 2,
description = "TEST TEST \nTEST TEST",
not_in_shop = false,
}
,
]]--

craft_bombtime =
{
name = "craft_bombtime",
print_name = "Weapon: C4",
ent = "structure_bombtime",
spawn_height = 32,
craft_time = 15,
crystals_required = 3,
description = "Mobile bomb that explodes after 17 sec countdown \n350 damage, 700 radius, Dmg goes through walls \nOn zap:  Start the fuse of the timebomb",
not_in_shop = false,
display_grabbable = true,
cant_into_walls = true,
cant_into_walls_dist = 32,
on_zap_description = "Light the fuse",
}
,

--[[
craft_sentry =
{	
name = "craft_sentry",
print_name = "Sentry",
ent = "structure_sentry",
spawn_height = 0, --48
craft_time = 15,
crystals_required = 6,
description = "Shoots nearby enemy bugs it sees \n1200 Radius",
}
,
]]--


--[[
craft_sentryaa =
{	
name = "craft_sentryaa",
print_name = "Sentry-AA",
ent = "structure_sentryaa",
spawn_height = 48,
craft_time = 15,
crystals_required = 5,
description = "TEST TEST \nTEST TEST",
}
,
]]--

craft_tokengenerator =
{	
name = "craft_tokengenerator",
print_name = "Token Generator",
ent = "structure_tokengenerator",
//spawn_height = 36,
spawn_height = 32,
craft_time = 5,
crystals_required = 5,
description = "Generates 1 token every 60 seconds \n(The tokens spawn on top of it)",
cant_into_walls = true,
cant_into_walls_dist = 32,
}
,

craft_fortifier =
{	
name = "craft_fortifier",
print_name = "Support: Fortifier",
ent = "structure_fortifier",
//spawn_height = 0,
spawn_height = 32,
craft_time = 15,
crystals_required = 3,
description = "Heals nearby static structures 5 hp every .5 sec",
display_grabbable = true,
cant_into_walls = true,
cant_into_walls_dist = 32,
}
,

--
craft_radar =
{	
name = "craft_radar",
print_name = "Support: Radar",
ent = "structure_radar",
//spawn_height = 8,
spawn_height = 32,
craft_time = 10,
crystals_required = 4,
description = "Gives gives your team vision of enemy players \n1200 radius",
//display_grabbable = true,
cant_into_walls = true,
cant_into_walls_dist = 32,
}
,
--


craft_artillery =
{	
name = "craft_artillery",
print_name = "Sentry: Sieger",
ent = "structure_artillery",
spawn_height = 0,
craft_time = 10,
crystals_required = 4,
description = "Shoots slow moving missiles at enemy structures \n4000 radius, Must have direct line of sight",
cant_into_walls = true,
cant_into_walls_dist = 32,
}
,


--[[
craft_goalball =
{	
name = "craft_goalball",
print_name = "Goal Ball",
ent = "structure_goalball",
spawn_height = 48,
craft_time = 60, --30
crystals_required = 2,
description = "TEST TEST \nTEST TEST",
display_grabbable = true,
}
,
]]--


--[[
craft_robobomb =
{	
name = "craft_robobomb",
print_name = "RoboBomb",
ent = "structure_robobomb",
spawn_height = 48,
craft_time = 15,
crystals_required = 3,
description = "TEST TEST \nTEST TEST",
}
,
]]--


craft_teleport_entrance =
{	
name = "craft_teleport_entrance",
print_name = "Teleport Entrance",
ent = "structure_teleport_entrance",
spawn_height = 32,
craft_time = 20,
crystals_required = 6,
description = "TEST TEST \nTEST TEST",
not_in_shop = true,
display_grabbable = true,
has_partner = true,
partner_display = "Exit",
on_zap_description = "Teleport",
}
,

craft_teleport_exit =
{	
name = "craft_teleport_exit",
print_name = "Teleport Exit",
ent = "structure_teleport_exit",
spawn_height = 32,
craft_time = 20,
crystals_required = 6,
description = "TEST TEST \nTEST TEST",
not_in_shop = true,
display_grabbable = true,
has_partner = true,
partner_display = "Entrance",
}
,



craft_teleport =
{	
name = "craft_teleport",
print_name = "Support: Teleporter",
ent = "structure_teleport",
spawn_height = 32,
craft_time = 5, --10
crystals_required = 6,
description = "Creates a teleport entrance and exit \nThey can be grabbed and re deployed anywhere \nTeleports bug players to the exit \n(Zap the teleport entrance to be teleported)",
cant_into_walls = true,
cant_into_walls_dist = 32,
}
,


--[[
craft_cloud =
{	
name = "craft_cloud",
print_name = "Cloud",
ent = "structure_cloud",
spawn_height = 48,
craft_time = 15,
crystals_required = 4,
description = "TEST TEST \nTEST TEST",
}
,
]]--


--
craft_ramp =
{	
name = "craft_ramp",
print_name = "Base: Ramp",
ent = "structure_ramp",
spawn_height = 0,
craft_time = 10,
crystals_required = 1,
sets_angles = true,
description = "An angular ramp the same height as a wall \nOn zap:  Disables the ramp for 10 seconds",
on_zap_description = "Temporarily disable",
}
,
--

--[[
craft_turret =
{	
name = "craft_turret",
print_name = "Turret",
ent = "structure_turret",
spawn_height = 8,
craft_time = 15,
crystals_required = 4,
description = "TEST TEST \nTEST TEST",
}
,
]]--


--[[
craft_bridge =
{	
name = "craft_bridge",
print_name = "Bridge",
ent = "structure_bridge",
spawn_height = 0,
craft_time = 15,
crystals_required = 2,
sets_angles = true,
description = "TEST TEST \nTEST TEST",
}
,
]]--

--[[
craft_turretaa =
{	
name = "craft_turretaa",
print_name = "Turret (AA)",
ent = "structure_turretaa",
spawn_height = 96,
craft_time = 15,
crystals_required = 4,
description = "TEST TEST \nTEST TEST",
}
,
]]--

craft_heatseeker =
{	
name = "craft_heatseeker",
print_name = "Sentry: Anti-Vehicle",
ent = "structure_heatseeker",
spawn_height = 0,
craft_time = 15, --15
crystals_required = 5,
description = "Shoots slow moving missile balls at enemy vehicles \nThe missiles explode after 12 seconds  \n2500 radius",
cant_into_walls = true,
cant_into_walls_dist = 32,
}
,

craft_heatsentry =
{	
name = "craft_heatsentry",
print_name = "Sentry: Anti-Bug",
ent = "structure_heatsentry",
spawn_height = 0,
craft_time = 15, --15
crystals_required = 5,
description = "Shoots slow moving missile balls at enemy bugs \nThe missiles explode after 3 seconds  \n700 radius",
cant_into_walls = true,
cant_into_walls_dist = 32,
}
,


craft_boat =
{	
name = "craft_boat",
print_name = "Vehicle: Carrier",
ent = "structure_boat",
spawn_height = 48,
special_ang = Angle(0, 0, 90),
craft_time = 10, --15
crystals_required = 5,
description = "A large 300 hp ground vehicle you can ride on \nIt's immune to water \nTravels 100 units faster than bugs \nZap it to attach/detach from it \nCan carry up to 4 bugs",
on_zap_description = "Get on/off",
}
,

--[[
craft_blimp =
{	
name = "craft_blimp",
print_name = "Vehicle: Airship",
ent = "structure_blimp",
spawn_height = 48,
special_ang = Angle(0, 0, 90),
craft_time = 15, --15
crystals_required = 7,
description = "A 100 hp flying vehicle you can ride on \nYou cannot shoot while attached to the airship \nHold CTRL to move down \nZap the airship to attach/detach from it  \nCan carry up to 4 bugs",
}
,
]]--

--[[

craft_chopper =
{	
name = "craft_chopper",
print_name = "Vehicle: Chopper",
ent = "structure_chopper",
spawn_height = 48,
special_ang = Angle(0, 0, 90),
craft_time = 5, --15
crystals_required = 7,
description = "",
}
,
]]--


--[[
craft_plane =
{	
name = "craft_plane",
print_name = "Vehicle: Jet",
ent = "structure_plane",
spawn_height = 48,
special_ang = Angle(0, 0, 90),
craft_time = 5, --15
crystals_required = 5,
description = "",
}
,
]]--

craft_scout =
{	
name = "craft_scout",
print_name = "Vehicle: Rammer",
ent = "structure_scout",
spawn_height = 48,
special_ang = Angle(0, 0, 90),
craft_time = 10, --15
crystals_required = 5,
description = "A small 150 hp ground vehicle you can ride on \nIt's immune to water \nIt's very fast: 700 units per sec \nZap it to attach/detach from it \nOnly carries 1 bug \nRams enemy bugs/vehicles for 75 damage",
on_zap_description = "Get on/off",
}
,

--
craft_destroyer =
{	
name = "craft_destroyer",
print_name = "Vehicle: Destroyer",
ent = "structure_destroyer",
spawn_height = 48,
special_ang = Angle(0, 0, 90),
craft_time = 10, --15
crystals_required = 7,
description = "A large 200 hp ground vehicle you can ride on \nIt's immune to water \nIt has tank-like controls, \nShoots rapid fire missiles that hurt structures/bugs/vehicles \nZap it to attach/detach from it \nOnly carries 1 bug",
on_zap_description = "Get on/off",
}
,
--

--[[
craft_jumppad =
{	
name = "craft_jumppad",
print_name = "Support: Spring",
ent = "structure_jumppad",
spawn_height = 32,
craft_time = 5,
crystals_required = 3,
display_grabbable = true,
description = "Zap it to shoot yourself into the air",
cant_into_walls = true,
cant_into_walls_dist = 32,
}
,
]]--


--
craft_sapper =
{
name = "craft_sapper",
print_name = "Weapon: Sapper",
ent = "structure_sapper",
spawn_height = 32,
craft_time = 15, --10
crystals_required = 3,
description = "Mobile device which hurts enemy structures in an AOE \nDeals 6 dmg every .5 seconds \n300 radius",
display_grabbable = true,
cant_into_walls = true,
cant_into_walls_dist = 32,
}
,
--


--[[
craft_gainer =
{
name = "craft_gainer",
print_name = "Gainer",
ent = "structure_gainer",
spawn_height = 48,
craft_time = 10,
crystals_required = 5,
description = "TEST TEST \nTEST TEST",
display_grabbable = true,
}
,
]]--

craft_tokenport_entrance =
{	
name = "craft_tokenport_entrance",
print_name = "Token Harvester Entrance",
ent = "structure_tokenport_entrance",
spawn_height = 32,
craft_time = 20,
crystals_required = 6,
description = "TEST TEST \nTEST TEST",
not_in_shop = true,
display_grabbable = true,
has_partner = true,
partner_display = "Exit",
}
,

craft_tokenport_exit =
{	
name = "craft_tokenport_exit",
print_name = "Token Harvester Exit",
ent = "structure_tokenport_exit",
spawn_height = 32,
craft_time = 20,
crystals_required = 6,
description = "TEST TEST \nTEST TEST",
not_in_shop = true,
display_grabbable = true,
has_partner = true,
partner_display = "Entrance",
}
,


--[[
craft_tokenport =
{	
name = "craft_tokenport",
print_name = "Token Harvester",
ent = "structure_tokenport",
spawn_height = 32,
craft_time = 5, --10
crystals_required = 4,
description = "Creates a token transporter entrance and exit \nCan be grabbed and re deployed anywhere \nAutomatically teleports any nearby tokens \nUse it to harvest from the map token spawners",
cant_into_walls = true,
cant_into_walls_dist = 32,
}
,
]]--

craft_bugbrain =
{	
name = "craft_bugbrain",
print_name = "Bug Brain",
ent = "structure_bugbrain",
not_in_shop = true,
}
,


craft_bugbrain_shield =
{	
name = "craft_bugbrain_shield",
print_name = "Shielded Bug Brain",
ent = "structure_bugbrain_shield",
not_in_shop = true,
}
,


--[[
craft_rocket =
{
name = "craft_rocket",
print_name = "Upgrade: Rocket",
ent = "structure_rocket",
spawn_height = 48,
craft_time = 10, --10
crystals_required = 4,
description = "",
display_grabbable = true,
}
,
]]--


--[[
craft_repair =
{
name = "craft_repair",
print_name = "Upgrade: Repair",
ent = "structure_repair",
spawn_height = 48,
craft_time = 10, --10
crystals_required = 4,
description = "",
display_grabbable = true,
}
,
]]--

craft_turret_vehicle =
{	
name = "craft_turret_vehicle",
print_name = "Vehicle: Turret",
ent = "structure_turret_vehicle",
spawn_height = 0,
craft_time = 15, --15
crystals_required = 4,
description = "A static 200 hp ground turret you can get on top of \nIt shoots missiles that hurt enemy bugs/vehicles \nZap it to attach/detach from it",
on_zap_description = "Get on/off",
}
,

--[[
craft_shieldgenerator =
{	
name = "craft_shieldgenerator",
print_name = "Shield Generator",
ent = "structure_shieldgenerator",
spawn_height = 32,
craft_time = 10, --10
crystals_required = 4,
description = "",
display_grabbable = true,
}
,
]]--

craft_dropship =
{	
name = "craft_dropship",
print_name = "Vehicle: Dropship",
ent = "structure_dropship",
spawn_height = 48,
special_ang = Angle(0, 0, 90),
craft_time = 10, --15
crystals_required = 7,
description = "A 150 hp flying vehicle you can ride on \nZap it to attach/detach from it \nCan carry up to 5 bugs",
on_zap_description = "Get on/off",
}
,


craft_elevator =
{	
name = "craft_elevator",
print_name = "Support: Elevator",
ent = "structure_elevator",
spawn_height = 32,
craft_time = 10,
crystals_required = 3,
display_grabbable = true,
description = "Creates a 600 unit tall anti-gravity field \nAllied bugs can stand in the field to float upwards",
cant_into_walls = true,
cant_into_walls_dist = 32,
}
,

craft_deconstructor =
{
name = "craft_deconstructor",
print_name = "Upgrade: Deconstruct",
ent = "structure_deconstructor",
spawn_height = 32,
craft_time = 5, --10
crystals_required = 3,
description = "",
display_grabbable = true,
description = "While grabbed: gives you the ability to deconstruct stuff \nYou can only deconstruct structures you created \nBound to R key \nReturns the token value of the structure minus 1",
cant_into_walls = true,
cant_into_walls_dist = 32,
}
,

--[[
craft_nade =
{
name = "craft_nade",
print_name = "Upgrade: Nade",
ent = "structure_nade",
spawn_height = 32,
craft_time = 5, --10
crystals_required = 4,
description = "",
display_grabbable = true,
description = "While grabbed: replaces your sliders with nades \nNades have a bigger damage/knockback radius \nNades explode on impact",
cant_into_walls = true,
cant_into_walls_dist = 32,
}
,
]]--

}

--recieves the string name of a craftable
function CheckIfInTable_Craft( str )
	for _, value in pairs( CRAFT_TABLE ) do	
		if value.name == str then
			return true
		end
	end
	return false
end

--recieves the string name of a craftable, returns the ref
function TableReference_Craft( entstring )
	local ref = nil
	for _, ent in pairs(CRAFT_TABLE) do
		if ent.name == entstring then
			ref = ent
		end
	end
	return ref
end


--receives built ent, returns craft table
function TableReference_CraftEnt( entstring )
	for _, thing in pairs(CRAFT_TABLE) do
		if thing.ent == entstring then
			return thing
		end
	end
	
end



//returns the name of the craftable, based on the print name
function ConvertToName_Craft(printname)	
	local name = nil
	for _, craftable in pairs(CRAFT_TABLE) do
		if craftable.print_name == printname then
			name = craftable.name
			return name
		end
	end
	return "invalid craftable name"
end

function ConvertToPrintName_Craft( craftname )
	for _, craft in pairs(CRAFT_TABLE) do
		if craft.name == craftname then
			return craft.print_name
		end
	end
	return "invalid tool name"
end


function ConvertToCraftNameFromEntName_Craft( entname )
	for _, craft in pairs(CRAFT_TABLE) do
		if craft.ent == entname then
			return craft.name
		end
	end
	return "invalid tool name"
end