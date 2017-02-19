/*---------------------------------------------------------
	Ent base table
---------------------------------------------------------*/
//any ent that tools create is in this list
//used to clean up everything at the end of a round, like the buildable barriers and such.
//Ent = entity a tool created


ENT_TABLE = 
{




structure_bugbrain =
{
name = "structure_bugbrain",
print_name = "Bug Brain",
static = true,
model = "models/bugboys/bugbrain.mdl",
damage_shield_break = 200,
time_shield_reform = 10,
time_shield_regen = 10,
takes_damage = true,
sound_shield_form = "ambient/energy/whiteflash.wav",
sound_shield_damage = "physics/glass/glass_impact_bullet1.wav",
sound_shield_break = "physics/glass/glass_largesheet_break3.wav",
sound_repeat = "ambient/machines/combine_terminal_idle",
repeat_rate = 3,
}
,

structure_bugbrain_shield =
{
name = "structure_bugbrain_shield",
print_name = "Bug Brain Shield",
static = true,
model = "models/bugboys/sphere380.mdl",
transparency = 150,
}
,


ent_intermediary_structure =
{
name = "ent_intermediary_structure",
print_name = "Intermediary Structure",
model = "models/props_junk/wood_crate001a.mdl",
takes_damage = true,
static = true,
triggerable = true,
health = 20,
craftpoints_max = 1,
radius_cancel = 128,
time_cancel_check = 1.3,	--how long to wait until checking if stuff is in the way of construction, 1
sound_craft = "ambient/energy/weld2.wav",
sound_zap = "buttons/button16.wav",
sound_cancel = "buttons/button10.wav" ,
//sound_build = "ambient/machines/engine4.wav",
sound_build = "npc/dog/dog_idlemode_loop1.wav",
special_mat_blue = "models/props_combine/stasisshield_sheet",
special_mat_red = "models/props_combine/tprings_globe",
}
,

--[[
ent_crystal =
{
name = "ent_crystal",
print_name = "Crystal",
model = "models/props_junk/wood_crate001a.mdl",
teamless = true,
takes_damage = true,
health = 200,
mass = 100,
time_despawn = 60,
craftpoints_max = 1,
sound_craft = "ambient/energy/weld2.wav",
sound_zap = "buttons/button16.wav",
}
,
]]--


subitem_tank_airbomb =
{
name = "subitem_tank_airbomb",
print_name = "Air-bomb",
takes_damage = false,
model = "models/props_c17/playgroundtick-tack-toe_block01a.mdl",
mass = 20,
sound_explode = "ambient/explosions/explode_2.wav",
damage = 40,
radius = 170,

is_projectile = true,
}
,

subitem_smallman_airbomb =
{
name = "subitem_smallman_airbomb",
print_name = "Airbomb",
takes_damage = false,
model = "models/props_c17/playgroundtick-tack-toe_block01a.mdl",
mass = 20,
sound_explode = "npc/roller/mine/rmine_explode_shock1.wav",
damage = 25,
radius = 30,

is_projectile = true,
}
,

--has default settings for smallmans version
subitem_slider =
{
name = "subitem_slider",
print_name = "Slider",
takes_damage = false,
//model = "models/props_vehicles/tire001a_tractor.mdl",
//model = "models/props_vehicles/carparts_tire01a.mdl",
model = "models/bugboys/cylinder_puck.mdl",
mass = 20, --20
sound_explode = "npc/roller/mine/rmine_explode_shock1.wav",
fuse = 3,
damage = 25, --20
radius = 75, --75
radius_knockback = 85,

is_projectile = true,
}
,





--this ent has multiple modes, the ents mode can be set using "self.Version" before its initialized
subitem_airbomb =
{
name = "subitem_airbomb",
multimode = true,

{
version = "tank",
print_name = "Tank Airbomb",
takes_damage = false,
model = "models/props_c17/playgroundtick-tack-toe_block01a.mdl",
mass = 20,
sound_explode = "ambient/explosions/explode_2.wav",
damage = 50,
radius = 128,
is_projectile = true,
}
,

{
version = "blimp",
print_name = "Blimp Airbomb",
takes_damage = false,
model = "models/props_c17/playgroundtick-tack-toe_block01a.mdl",
mass = 20,
sound_explode = "weapons/physcannon/energy_sing_flyby1.wav",
damage = 40,
radius = 128,
is_projectile = true,
}
,

{
version = "climber",
print_name = "Climber Airbomb",
takes_damage = false,
model = "models/props_c17/playgroundtick-tack-toe_block01a.mdl",
mass = 20,
sound_explode = "weapons/physcannon/energy_sing_flyby1.wav",
damage = 40,
radius = 128,
gravity_force = 4000,
is_projectile = true,
}
,

{
version = "jetpack",
print_name = "Jetpack Airbomb",
takes_damage = false,
model = "models/props_c17/playgroundtick-tack-toe_block01a.mdl",
mass = 20,
sound_explode = "weapons/physcannon/energy_sing_flyby1.wav",
damage = 25,
radius = 128,
knockback = true,
knockback_force = 500,
hurts_only_players = true,
is_projectile = true,
}
,

}
,




--[[
structure_block =
{
name = "structure_block",
print_name = "Block",
takes_damage = true,
health = 350,
model = "models/tacticaltoolgame_models/box01_big.mdl",
mass = 50,
sound_explode = "ambient/explosions/explode_2.wav",
triggerable = true,
trigger_duration = 3,
trigger_cooldown = 10,
sound_collisionsoff = "ambient/energy/zap1.wav",
sound_collisionson = "ambient/energy/zap2.wav",
ongrab_effect = true,
freezing_frames = 4,
special_mat = "models/props_combine/stasisshield_sheet",
//special_mat = "models/props_c17/frostedglass_01a",
}
,

structure_pointpiece =
{
name = "structure_pointpiece",
print_name = "Point Piece",
takes_damage = true,
health = 500,
model = "models/tacticaltoolgame_models/box01.mdl",
mass = 100,
}
,

]]--

structure_wall =
{
name = "structure_wall",
print_name = "Base: Wall",
takes_damage = true,
static = true,
size = 128,
health = 350, --400
//model = "models/tacticaltoolgame_models/box01_big.mdl",
model = "models/bugboys/box01_big_nozfight.mdl",
sound_explode = "ambient/explosions/explode_2.wav",
triggerable = true,
trigger_duration = 3,
trigger_cooldown = 10,
sound_collisionsoff = "ambient/energy/zap1.wav",
sound_collisionson = "ambient/energy/zap2.wav",
has_texture = true,
special_texture = "bugboys/box_outlined",
}
,


structure_dispenser =
{
name = "structure_dispenser",
print_name = "Healer",
takes_damage = true,
static = false,
angular = true,
size = 32,
health = 130,
heal_amount = 3,
heal_rate = .5,
radius = 300,
display_radius_sphere = true,
//model = "models/props_junk/trashdumpster01a.mdl",
model = "models/bugboys/box01.mdl",
has_texture = true,
skin_red = 1,
skin_blue = 2,
mass = 150,
sound_explode = "ambient/explosions/explode_2.wav",
time_activate = 5,
//triggerable = true,
//trigger_duration = 3,
//trigger_cooldown = 10,
}
,

structure_bomb =
{
name = "structure_bomb",
print_name = "Bomb",
takes_damage = true,
size = 32,
health = 120,
radius_activation = 150,
radius_damage = 175,
//damage = 300,
damage_percent = .8,
model = "models/bugboys/box01_small.mdl",
has_texture = true,
skin_red = 11,
skin_blue = 12,
mass = 120,
sound_explode = "ambient/explosions/explode_7.wav",
}
,


structure_bombstun =
{
name = "structure_bombstun",
print_name = "Bomb-Stun",
takes_damage = true,
size = 32,
health = 200,
radius_activation = 250,
radius_damage = 300,
damage = 300,
model = "models/props_junk/cardboard_box002a.mdl",
mass = 120,
sound_explode = "ambient/explosions/explode_7.wav",
}
,



structure_token =
{
name = "structure_token",
print_name = "Token",
takes_damage = false,
static = true,
size = 32,
teamless = true,
health = 200,
radius = 30, --17
time_canpickup = .2,
color = Color(148,95,235,255),
//model = "models/props_c17/oildrum001.mdl",
model_multi = "models/bugboys/cylinder_small.mdl",
model = "models/props_c17/playgroundtick-tack-toe_block01a.mdl",
//model = "models/bugboys/cylinder.mdl",
sound_pickup = "items/ammo_pickup.wav",
//think_rate = .2,
}
,

structure_tokengenerator =
{
name = "structure_tokengenerator",
print_name = "Token Generator",
takes_damage = true,
static = true,
size = 32,
health = 100,
//spawn_distance_adder = 48,
time_interval = 60, --60 --75
created_ent = "structure_token",
model = "models/bugboys/box01.mdl",
has_texture = true,
skin_red = 3,
skin_blue = 4,
sound_craft = "ambient/energy/weld2.wav",
spawn_height = -10,
token_height = 60,
}
,

structure_sentry =
{
name = "structure_sentry",
print_name = "Sentry",
takes_damage = true,
static = true,
size = 32,
health = 120,
radius = 1000, --1200
max_target_height = 400,
height_gun = 120, --50
charge_time = 1, --.7
bullet_damage = 5,	--4
aim_cone = .01, --.02
pucks_to_hurt = {"puck_smallman, puck_tank"},
//model = "models/props_c17/furnitureboiler001a.mdl",
model = "models/props_trainstation/trainstation_ornament001.mdl",
//sound_see = "ambient/levels/labs/teleport_alarm_loop1.wav",
sound_see = "npc/attack_helicopter/aheli_damaged_alarm1.wav",
sound_shoot = "weapons/smg1/smg1_fire1.wav",
sound_explode = "ambient/explosions/explode_2.wav",
sound_loop = "ambient/levels/labs/machine_moving_loop4.wav",
sound_repeat = "buttons/button16.wav",
repeat_rate = 1.5,
//sound_loop = "ambient/energy/force_field_loop1.wav",
}
,

structure_sentryaa =
{
name = "structure_sentryaa",
print_name = "Sentry-AA",
takes_damage = true,
static = true,
size = 32,
health = 100,
radius = 1200,
height_gun = 20,
charge_time = .4,
bullet_damage = 3,	--3
aim_cone = .02,
pucks_to_hurt = {"puck_blimp"},
model = "models/props_c17/furniturefireplace001a.mdl",
sound_see = "npc/stalker/go_alert2a.wav",
sound_shoot = "weapons/smg1/smg1_fire1.wav",
}
,


structure_artillery =
{
name = "structure_artillery",
print_name = "Sieger",
takes_damage = true,
static = true,
size = 64,
health = 200,
radius = 4000, --8000
display_radius_sphere = true,
height_gun = 130,
charge_time = .5,
fire_rate = 2,
missile = "subitem_artillerymissile",
shoot_force = 50000,
model = "models/bugboys/sentry_sieger.mdl",
sound_see = "hl1/fvox/beep.wav",
//sound_shoot = "weapons/smg1/smg1_fire1.wav",
sound_shoot = "weapons/rpg/rocketfire1.wav",
has_texture = true,
raise_checkpos = true,
//special_texture = "bugboys/machine_vehicle_sentry",
}
,


subitem_artillerymissile =
{
name = "subitem_artillerymissile",
print_name = "Artillery Missile",
takes_damage = false,
//model = "models/props_c17/playgroundtick-tack-toe_block01a.mdl",
model = "models/props_junk/plasticbucket001a.mdl",
mass = 50,
sound_explode = "npc/roller/mine/rmine_explode_shock1.wav",
damage = 40,
is_projectile = true,
//radius = 75,
}
,



structure_fortifier =
{
name = "structure_fortifier",
print_name = "Fortifier",
takes_damage = true,
static = false,
angular = true,
display_radius_sphere = true,
size = 32,
health = 100,
heal_amount = 5,
heal_rate = .5,
radius = 300,
//model = "models/props_c17/canister_propane01a.mdl",
model = "models/bugboys/box01.mdl",
has_texture = true,
skin_red = 5,
skin_blue = 6,
}
,

structure_radar =
{
name = "structure_radar",
print_name = "Radar",
takes_damage = true,
static = true,
angular = true,
size = 32,
health = 50,
radius = 1200,
display_radius_sphere = true,
//model = "models/props_junk/plasticbucket001a.mdl",
model = "models/bugboys/box01.mdl",
has_texture = true,
skin_red = 7,
skin_blue = 8,
}
,



structure_goalball =
{
name = "structure_goalball",
print_name = "Goal Ball",
takes_damage = true,
size = 32,
health = 130,
model = "models/bugboys/box01_small.mdl",
has_texture = true,
skin_red = 17,
skin_blue = 18,
mass = 80, --150
//sound_explode = "ambient/explosions/explode_2.wav",
}
,


structure_robobomb =
{
name = "structure_robobomb",
print_name = "RoboBomb",
takes_damage = true,
size = 32,
health = 150,
model = "models/bugboys/box01_small.mdl",
//model = "models/bugboys/robobomb.mdl",
has_texture = true,
skin_red = 11,
skin_blue = 12,
mass = 150,
think_rate = .1,
force_chase = 6000,
radius = 2000,
radius_explode = 100,
//radius_damage = 400,
damage = 150,
triggerable = true,
//sound_on = "npc/manhack/mh_engine_loop1.wav",
sound_on = "npc/combine_gunship/dropship_engine_distant_loop1.wav",
sound_explode = "ambient/explosions/explode_8.wav",
}
,


structure_bombtime =
{
name = "structure_bombtime",
print_name = "C4",
takes_damage = true,
static = false,
angular = true,
display_radius_sphere = true,
size = 32,
health = 200,
//radius_activation = 200,
radius = 700, -- to display it when its being built
radius_damage = 700,
damage = 350,
triggerable = true,
//model = "models/bugboys/box01_small.mdl",
model = "models/bugboys/box01.mdl",
has_texture = true,
skin_red = 9,
skin_blue = 10,
mass = 300, 
time_fuse = 17,	--20
beep_rate = 1,
beep_rate_amp = .029, --.026 --.052
sound_beep = "hl1/fvox/beep.wav",
sound_explode = "ambient/explosions/explode_2.wav",
sound_on = "npc/combine_gunship/dropship_dropping_pod_loop1.wav",
//cant_heal = true,
}
,



structure_teleport =
{
name = "structure_teleport",
print_name = "Teleport",
takes_damage = false,
static = true,
mass = 100,
size = 32,
health = 200,
model = "models/bugboys/box01.mdl",
has_texture = true,
skin_entrance_red = 19,
skin_entrance_blue = 20,
skin_exit_red = 21,
skin_exit_blue = 22,

spawn_ent_a = "structure_teleport_entrance",
spawn_ent_b = "structure_teleport_exit",
pos_a = Vector(0,48,0),
pos_b = Vector(0,-48,0),
}
,



structure_teleport_entrance =
{
name = "structure_teleport_entrance",
print_name = "Teleport Entrance",
takes_damage = true,
static = false,
mass = 100,
size = 32,
health = 200,
model = "models/bugboys/box01.mdl",
has_texture = true,
skin_red = 19,
skin_blue = 20,
angular = true, --makes its angles 0,0,0 when ungrabbed

triggerable = true,
trigger_cooldown = 15, --25
sound_teleport = "ambient/energy/zap1.wav",
radius_teleport = 150,
}
,



structure_teleport_exit =
{
name = "structure_teleport_exit",
print_name = "Teleport Exit",
takes_damage = true,
static = false,
mass = 100,
size = 32,
health = 200,
model = "models/bugboys/box01.mdl",
has_texture = true,
skin_red = 21,
skin_blue = 22,
angular = true, --makes its angles 0,0,0 when ungrabbed
}
,


structure_cloud =
{
name = "structure_cloud",
print_name = "Cloud",
takes_damage = true,
//static = true,
size = 32,
health = 250,
mass = 100,
//model = "models/tacticaltoolgame_models/box01_big.mdl",
model = "models/bugboys/box01.mdl",
model_platform = "models/bugboys/cloud.mdl",
triggerable = true,
sound_collisionson = "ambient/energy/zap2.wav",
has_texture = true,
skin_red = 15,
skin_blue = 16,
}
,


structure_ramp =
{
name = "structure_ramp",
print_name = "Base: Ramp",
takes_damage = true,
static = true,
size = 128,
health = 200,
model = "models/bugboys/ramp_wide.mdl",
special_texture = "bugboys/box_outlined",
//has_texture = true,
//skin_red = 15,
//skin_blue = 16,
triggerable = true,
trigger_duration = 3,
trigger_cooldown = 10,
sound_collisionsoff = "ambient/energy/zap1.wav",
sound_collisionson = "ambient/energy/zap2.wav",
}
,


structure_bridge =
{
name = "structure_bridge",
print_name = "Bridge",
takes_damage = true,
static = true,
size = 128,
health = 400,
model = "models/bugboys/bridge.mdl",
sound_collisionson = "ambient/energy/zap2.wav",
//has_texture = true,
//skin_red = 15,
//skin_blue = 16,
}
,


structure_turret =
{
name = "structure_turret",
print_name = "Turret",
takes_damage = true,
static = true,
size = 32,
health = 150,
model = "models/bugboys/cylinder.mdl",
//has_texture = true,
//skin_red = 19,
//skin_blue = 20,

triggerable = true,
trigger_cooldown = .5, --25
sound_shoot = "weapons/airboat/airboat_gun_energy2.wav",
ent_shoot = "subitem_slider_turret",
force_shoot = 30000,
}
,



subitem_slider_turret =
{
name = "subitem_slider_turret",
print_name = "Slider for Turret",
takes_damage = false,
//model = "models/props_vehicles/carparts_tire01a.mdl",
model = "models/bugboys/cylinder_small.mdl",
mass = 20,
sound_explode = "npc/roller/mine/rmine_explode_shock1.wav",
fuse = 4,
damage = 25, --20
radius = 75,

is_projectile = true,
}
,

--anti-vehicle
structure_heatseeker =
{
name = "structure_heatseeker",
print_name = "Heat Seeker",
takes_damage = true,
static = true,
size = 32,
//health = 250,
health = 150,
radius = 2500,
display_radius_sphere = true,
height_gun = 100, --100
charge_time = .5,
bullet_damage = 3,	--3
aim_cone = .02,
//model = "models/props_c17/furnitureboiler001a.mdl",
//model = "models/props_c17/gravestone_cross001b.mdl",
model = "models/bugboys/sentry_vehicle.mdl",
//sound_see = "ambient/levels/labs/teleport_alarm_loop1.wav",
sound_see = "npc/attack_helicopter/aheli_damaged_alarm1.wav",
sound_shoot = "ambient/levels/citadel/weapon_disintegrate3.wav",
sound_explode = "ambient/explosions/explode_2.wav",
sound_loop = "ambient/levels/labs/machine_moving_loop4.wav",
sound_repeat = "buttons/combine_button5.wav",
repeat_rate = 1.5,
//sound_loop = "ambient/energy/force_field_loop1.wav",
has_texture = true,
raise_checkpos = true,
//special_texture = "bugboys/machine_vehicle_sentry",

shoot_rate = 4,
ent_shoot = "subitem_missile_heatseeker",
}
,

subitem_missile_heatseeker =
{
name = "subitem_missile_heatseeker",
print_name = "Heatseeker",
takes_damage = true,
health = 25,
//model = "models/props_vehicles/carparts_tire01a.mdl",
//model = "models/bugboys/box01_small.mdl",
model = "models/bugboys/jetpack.mdl",
//model = "models/bugboys/cylinder.mdl",
mass = 20,
sound_explode = "npc/roller/mine/rmine_explode_shock1.wav",
fuse = 12,
damage = 40,
radius = 50,
radius_search = 3000,
force_chase = 500, --400
force_chase_airunit = 600, --500
force_chase_scout = 900,
think_rate = .2,
is_projectile = true,
cant_switch_allegiance = true,
repeat_rate = 1,
sound_repeat = "npc/roller/mine/rmine_predetonate.wav",
}
,



structure_heatsentry =
{
name = "structure_heatsentry",
print_name = "Bug Sentry",
takes_damage = true,
static = true,
size = 32,
health = 100,
radius = 700,
display_radius_sphere = true,
height_gun = 100, --200
charge_time = .5,
bullet_damage = 3,	--3
aim_cone = .02,
//model = "models/props_c17/furnitureboiler001a.mdl",
//model = "models/props_c17/gravestone_cross001b.mdl",
//model = "models/props_trainstation/trainstation_ornament001.mdl",
model = "models/bugboys/sentry_bug.mdl",
//sound_see = "ambient/levels/labs/teleport_alarm_loop1.wav",
sound_see = "npc/attack_helicopter/aheli_damaged_alarm1.wav",
sound_shoot = "ambient/levels/citadel/weapon_disintegrate3.wav",
sound_explode = "ambient/explosions/explode_2.wav",
sound_loop = "ambient/levels/labs/machine_moving_loop4.wav",
sound_repeat = "buttons/combine_button5.wav",
repeat_rate = 1.5,
//sound_loop = "ambient/energy/force_field_loop1.wav",
shoot_rate = 1, --3
ent_shoot = "subitem_missile_heatsentry",
has_texture = true,
raise_checkpos = true,
//special_texture = "bugboys/machine_vehicle_sentry",
}
,

subitem_missile_heatsentry =
{
name = "subitem_missile_heatsentry",
print_name = "Missile",
takes_damage = true,
health = 25,
//model = "models/props_vehicles/carparts_tire01a.mdl",
//model = "models/bugboys/box01_small.mdl",
//model = "models/bugboys/jetpack.mdl",
model = "models/bugboys/jetpack_small.mdl",
//model = "models/bugboys/cylinder.mdl",
mass = 20,
sound_explode = "npc/roller/mine/rmine_explode_shock1.wav",
fuse = 4,
damage = 40,
radius = 50,
radius_search = 1000,
force_chase = 400,
think_rate = .2,
is_projectile = true,
cant_switch_allegiance = true,
repeat_rate = 1,
sound_repeat = "npc/roller/mine/rmine_predetonate.wav",
}
,



structure_turretaa =
{
name = "structure_turretaa",
print_name = "Anti-Air",
takes_damage = true,
static = true,
size = 32,
health = 200,
//model = "models/bugboys/cylinder.mdl",
model = "models/bugboys/box01.mdl",
triggerable = true,
trigger_cooldown = .5, --25
sound_shoot = "weapons/airboat/airboat_gun_energy2.wav",
ent_shoot = "subitem_airbomb_turret",
force_shoot = 500000,
}
,



subitem_airbomb_turret =
{
name = "subitem_airbomb_turret",
print_name = "Airbomb for AA",
takes_damage = false,
//model = "models/props_vehicles/carparts_tire01a.mdl",
model = "models/bugboys/cylinder_small.mdl",
mass = 20,
sound_explode = "npc/roller/mine/rmine_explode_shock1.wav",
fuse = 3,
damage = 15,
radius = 75,
is_projectile = true,
}
,


structure_boat =
{
name = "structure_boat",
print_name = "Carrier",
takes_damage = true,
size = 32,
health = 300,
model = "models/bugboys/tank_vehicle.mdl",
//model = "models/bugboys/tank.mdl",
//model = "models/bugboys/boat.mdl",
mass = 500, --500
speed_max = 350, --350
force_add = 3500,
radius_attach = 130,
//sound_explode = "ambient/explosions/explode_2.wav",
triggerable = true,
sound_jet = "vehicles/airboat/fan_motor_idle_loop1.wav",
special_texture = "bugboys/machine_vehicle",
}
,


structure_blimp =
{
name = "structure_blimp",
print_name = "Blimp",
takes_damage = true,
size = 32,
health = 150,
model = "models/bugboys/airship_large.mdl",
//model = "models/bugboys/blimp.mdl",
//model = "models/bugboys/boat.mdl",
mass = 1000, --500
speed_max = 270, --300
force_add = 3500,
force_add_vertical = 3500,
force_gravity = 200,
radius_attach = 150,
shoot_delay = .5,
//sound_explode = "ambient/explosions/explode_2.wav",
triggerable = true,
//sound_jet = "npc/combine_gunship/engine_rotor_loop1.wav",
sound_jet = "npc/combine_gunship/dropship_engine_near_loop1.wav",
}
,

structure_chopper =
{
name = "structure_chopper",
print_name = "Chopper",
takes_damage = true,
size = 32,
health = 100,
model = "models/bugboys/airship.mdl",
//model = "models/bugboys/blimp.mdl",
//model = "models/bugboys/boat.mdl",
mass = 500, --500
speed_max = 250,
force_add = 3500,
force_add_vertical = 3500,
force_gravity = 200,
radius_attach = 100,
shoot_delay = 1,
//sound_explode = "ambient/explosions/explode_2.wav",
triggerable = true,
sound_jet = "npc/attack_helicopter/aheli_rotor_loop1.wav",
sound_shoot = "npc/strider/strider_minigun.wav",
}
,


structure_plane =
{
name = "structure_plane",
print_name = "Plane",
takes_damage = true,
size = 32,
health = 100,
model = "models/bugboys/destroyer.mdl",
mass = 1000, --500
speed_max = 250,
force_add = 3500,
force_add_vertical = 3500,
force_gravity = 200,
radius_attach = 100,
//sound_explode = "ambient/explosions/explode_2.wav",
triggerable = true,
sound_jet = "npc/attack_helicopter/aheli_rotor_loop1.wav",
}
,


structure_scout =
{
name = "structure_scout",
print_name = "Rammer",
takes_damage = true,
size = 32,
health = 150,
model = "models/bugboys/scout.mdl",
//model = "models/bugboys/boat.mdl",
mass = 400, --500
speed_max = 700, --250
force_add = 3000, --3500
radius_attach = 100,
damage_hit = 80,
//sound_explode = "ambient/explosions/explode_2.wav",
triggerable = true,
//sound_jet = "npc/combine_gunship/dropship_onground_loop1.wav",
//sound_jet = "vehicles/apc/apc_cruise_loop3.wav",
sound_jet = "vehicles/diesel_loop2.wav",
sound_hit = "weapons/physcannon/energy_disintegrate5.wav",
special_texture = "bugboys/machine_vehicle",
}
,


structure_destroyer =
{
name = "structure_destroyer",
print_name = "Destroyer",
takes_damage = true,
size = 32,
health = 200,
model = "models/bugboys/destroyer.mdl",
//model = "models/bugboys/boat.mdl",
mass = 400, --500
speed_max = 350, --250
force_add = 3500,
radius_attach = 100,
shoot_delay = .3,
//sound_explode = "ambient/explosions/explode_2.wav",
triggerable = true,
sound_jet = "npc/scanner/cbot_fly_loop.wav",
special_texture = "bugboys/machine_vehicle_destroyer",
}
,


subitem_missile_destroyer =
{
name = "subitem_missile_destroyer",
print_name = "Missile",
takes_damage = false,
//model = "models/props_vehicles/tire001a_tractor.mdl",
model = "models/props_vehicles/carparts_tire01a.mdl",
mass = 20,
sound_explode = "npc/roller/mine/rmine_explode_shock1.wav",
fuse = .5,
damage = 25, --20
radius = 100, --75
radius_knockback = 85,
is_projectile = true,
}
,

subitem_missile_chopper =
{
name = "subitem_missile_chopper",
print_name = "Missile",
takes_damage = false,
//model = "models/props_vehicles/tire001a_tractor.mdl",
model = "models/props_vehicles/carparts_tire01a.mdl",
mass = 20,
sound_explode = "npc/roller/mine/rmine_explode_shock1.wav",
fuse = 2,
damage = 30, --20
radius = 100, --75
radius_knockback = 85,
is_projectile = true,
}
,


structure_jumppad =
{
name = "structure_jumppad",
print_name = "Jump Pad",
takes_damage = true,
static = false,
angular = true,
doesnt_need_to_be_on_ground = true,
size = 32,
health = 50,
//model = "models/bugboys/rammer.mdl",
model = "models/bugboys/box01.mdl",
force = 1000,
radius_use = 100,
sound_jump = "vehicles/airboat/pontoon_impact_hard1.wav",
triggerable = true,
trigger_cooldown = 5,
has_texture = true,
skin_red = 23,
skin_blue = 24,
}
,

structure_sapper =
{
name = "structure_sapper",
print_name = "Sapper",
takes_damage = true,
angular = true,
display_radius_sphere = true,
doesnt_need_to_be_on_ground = true,
size = 32,
health = 125,
radius = 300,
damage = 6,
model = "models/bugboys/box01.mdl",
has_texture = true,
skin_red = 11,
skin_blue = 12,
mass = 100,
sound_hurt = "weapons/physcannon/energy_disintegrate5.wav",
hurt_rate = .5,
time_activate = .3,
//cant_heal = true,
}
,



structure_gainer =
{
name = "structure_gainer",
print_name = "Gainer",
takes_damage = true,
size = 32,
health = 175,
model = "models/bugboys/box01.mdl",
has_texture = true,
skin_red = 15,
skin_blue = 16,
mass = 100,
damage_interval = 100,
sound_gain = "physics/metal/metal_computer_impact_soft1.wav",
}
,



structure_tokenport =
{
name = "structure_tokenport",
print_name = "Tokenport",
takes_damage = false,
static = true,
size = 32,
health = 200,
model = "models/bugboys/box01.mdl",
has_texture = true,

spawn_ent_a = "structure_tokenport_entrance",
spawn_ent_b = "structure_tokenport_exit",
pos_a = Vector(0,48,0),
pos_b = Vector(0,-48,0),
}
,



structure_tokenport_entrance =
{
name = "structure_tokenport_entrance",
print_name = "Tokenport Entrance",
takes_damage = true,
static = false,
mass = 100,
size = 32,
health = 200,
model = "models/bugboys/box01.mdl",
has_texture = true,
skin_red = 13,
skin_blue = 14,
angular = true, --makes its angles 0,0,0 when ungrabbed

sound_teleport = "ambient/energy/zap1.wav",
radius = 150,
}
,



structure_tokenport_exit =
{
name = "structure_tokenport_exit",
print_name = "Tokenport Exit",
takes_damage = true,
static = false,
mass = 100,
size = 32,
health = 200,
model = "models/bugboys/box01.mdl",
has_texture = true,
skin_red = 15,
skin_blue = 16,
angular = true, --makes its angles 0,0,0 when ungrabbed

token_height = 48,
created_ent = "structure_token",
sound_craft = "ambient/energy/weld2.wav",
}
,


structure_rocket =
{
name = "structure_rocket",
print_name = "Rocket",
takes_damage = true,
static = false,
angular = true,
size = 32,
health = 100,
model = "models/bugboys/box01.mdl",
//has_texture = true,
//skin_red = 11,
//skin_blue = 12,
mass = 100,
}
,

structure_repair =
{
name = "structure_repair",
print_name = "Repair",
takes_damage = true,
size = 32,
health = 100,
model = "models/bugboys/box01.mdl",
//has_texture = true,
//skin_red = 11,
//skin_blue = 12,
mass = 100,
}
,


structure_ammoamp =
{
name = "structure_ammoamp",
print_name = "Ammo Amp",
takes_damage = true,
static = false,
angular = true,
size = 32,
health = 130,
think_rate = .5,
radius = 100,
model = "models/bugboys/box01.mdl",
//has_texture = true,
//skin_red = 1,
//skin_blue = 2,
mass = 150,
time_activate = 5,
sound_give = "items/ammocrate_open.wav",
}
,


structure_turret_vehicle =
{
name = "structure_turret_vehicle",
print_name = "Turret",
takes_damage = true,
size = 32,
health = 200,
//model = "models/bugboys/airship.mdl",
model = "models/bugboys/robobomb.mdl",
mass = 500, --500
radius_attach = 100,
shoot_delay = .5,
triggerable = true,
static = true,
sound_jet = "ambient/machines/machine3.wav",
}
,


subitem_missile_turret =
{
name = "subitem_missile_turret",
print_name = "Turret",
takes_damage = false,
//model = "models/props_vehicles/tire001a_tractor.mdl",
//model = "models/props_vehicles/carparts_tire01a.mdl",
model = "models/bugboys/cylinder.mdl",
mass = 20,
sound_explode = "npc/roller/mine/rmine_explode_shock1.wav",
fuse = 6,
damage = 25, --20
radius = 100, --75
radius_knockback = 85,
is_projectile = true,
}
,


structure_quickport =
{
name = "structure_quickport",
print_name = "Quickport",
takes_damage = true,
static = true,
size = 32,
health = 150,
radius = 1500,
display_radius_sphere = true,
model = "models/bugboys/box01.mdl",
has_texture = true,
skin_red = 25,
skin_blue = 26,
mass = 150,
sound_port = "items/ammocrate_open.wav",
triggerable = true,
trigger_cooldown = 4,
}
,


structure_shieldgenerator =
{
name = "structure_shieldgenerator",
print_name = "Shield Generator",
takes_damage = true,
static = false,
angular = true,
size = 32,
health = 130,
heal_amount = 3,
heal_rate = .5,
radius = 300,
//model = "models/props_junk/trashdumpster01a.mdl",
model = "models/bugboys/box01.mdl",
has_texture = true,
skin_red = 1,
skin_blue = 2,
mass = 150,
sound_explode = "ambient/explosions/explode_2.wav",
time_activate = 5,
//triggerable = true,
//trigger_duration = 3,
//trigger_cooldown = 10,
}
,


structure_dropship =
{
name = "structure_dropship",
print_name = "Dropship",
takes_damage = true,
size = 32,
health = 125,
model = "models/bugboys/airship.mdl",
//model = "models/bugboys/blimp.mdl",
//model = "models/bugboys/boat.mdl",
mass = 500, --500
speed_max = 250,
force_add = 2000,
force_add_vertical = 3000,
force_gravity = 200,
radius_attach = 100,
shoot_delay = 1,
//sound_explode = "ambient/explosions/explode_2.wav",
triggerable = true,
sound_jet = "npc/attack_helicopter/aheli_rotor_loop1.wav",
sound_shoot = "npc/strider/strider_minigun.wav",
special_texture = "bugboys/machine_vehicle",
}
,


structure_rope =
{
name = "structure_rope",
print_name = "Rope",
takes_damage = true,
static = false,
angular = true,
size = 32,
health = 150,
model = "models/bugboys/box01.mdl",
//has_texture = true,
//skin_red = 1,
//skin_blue = 2,
mass = 150,
swep_ability = "abil_rope",
}
,



subitem_missile_rope =
{
name = "subitem_missile_rope",
print_name = "Rope",
takes_damage = false,
//model = "models/props_vehicles/tire001a_tractor.mdl",
//model = "models/props_vehicles/carparts_tire01a.mdl",
model = "models/bugboys/cylinder.mdl",
mass = 20,
sound_explode = "npc/roller/mine/rmine_explode_shock1.wav",
fuse = 6,
is_projectile = true,
}
,

subitem_platform_rope =
{
name = "subitem_platform_rope",
print_name = "Rope",
takes_damage = true,
static = true,
is_projectile = true,
size = 32,
health = 150,
model = "models/bugboys/box01.mdl",
//has_texture = true,
//skin_red = 1,
//skin_blue = 2,
mass = 150,
swep_ability = "abil_rope",
}
,


structure_elevator =
{
name = "structure_elevator",
print_name = "Elevator",
takes_damage = true,
static = false,
angular = true,
doesnt_need_to_be_on_ground = true,
size = 32,
health = 25,
model = "models/bugboys/box01.mdl",
force = 1000,
has_texture = true,
skin_red = 23,
skin_blue = 24,
}
,


structure_deconstructor =
{
name = "structure_deconstructor",
print_name = "Deconstructor",
takes_damage = true,
static = false,
angular = true,
size = 32,
health = 100,
model = "models/bugboys/box01.mdl",
has_texture = true,
skin_red = 29,
skin_blue = 30,
mass = 150,
swep_ability = "abil_deconstruct",
}
,


structure_nade =
{
name = "structure_nade",
print_name = "Nade",
takes_damage = true,
static = false,
angular = true,
size = 32,
health = 50,
model = "models/bugboys/box01.mdl",
has_texture = true,
skin_red = 27,
skin_blue = 28,
mass = 150,
}
,


subitem_nade =
{
name = "subitem_nade",
print_name = "Nade",
takes_damage = false,
//model = "models/props_vehicles/carparts_tire01a.mdl",
model = "models/bugboys/nade.mdl",
mass = 15,
//sound_explode = "npc/roller/mine/rmine_explode_shock1.wav",
sound_explode = "npc/scanner/cbot_energyexplosion1.wav",
fuse = 3,
damage = 25, --20
radius = 120, --75
radius_knockback = 120,
is_projectile = true,
}
,



}

--recieves an actual ent, not the string name of one
function CheckIfInEntTable(ent)
	for _, value in pairs(ENT_TABLE) do		///check if the ent is one of the the games's objects
		if value.name == ent:GetClass() then
			return true
		end
	end
	return false
end


--returns the reference table for the ent, X can ask for a specific version of an ent for multi mode ents
--X is not required
function EntReference( entstring, x )
	//print( type(entstring) )

	local version_input = "none"
	local go_deeper = false
	
	if x != nil then
		version_input = x
	end
	
	local function GoDeeper( tbl )
		for _, inner in pairs( tbl ) do
			--ask if the thing were looking at is a table within the table
			if type(inner) == "table" then
			
				--return this table cause its the version we want
				if inner.version == version_input then
					//for k,v in pairs(ent) do print(k,v) end
					return inner
				end
				
				--return this table anyway since we arent trying for a specific version of this ent
				if version_input == "none" then
					return inner
				end
			end
		end
	end
	
	
	for _, ent in pairs(ENT_TABLE) do
		if ent.name == entstring then
			if ent.multimode == true then
				return GoDeeper( ent )
			else
				return ent
			end
		end
	end
end



function ConvertToPrintName_Ent( entname )	//returns the print name of the input tool name
	local printname = nil
	for _, ent in pairs(ENT_TABLE) do
		if ent.name == entname then
			printname = ent.print_name
			return printname
		end
	end
	return "invalid tool name"
end








local function PrecacheModels()
	local Cached_Models = {}

	for _, ent in pairs( ENT_TABLE ) do		///check if the ent is one of the the games's objects
		if ent.model != nil and not table.HasValue( Cached_Models, ent.model ) then
			util.PrecacheModel( ent.model )
			//print( "Precaching Model:   " .. ent.model )
			table.insert( Cached_Models, ent.model )
		end
	end
end

local function PrecacheSounds()
	local Cached_Sounds = {}

	for _, ent in pairs( ENT_TABLE ) do		///check if the ent is one of the the games's objects
		for _, var in pairs( ent ) do
			if type( var  ) == "string" then
				if string.find( var, ".wav" ) != nil and not table.HasValue( Cached_Sounds, var ) then
					util.PrecacheSound( var  )
					//print( "Precaching Sound:   " .. var )
					table.insert( Cached_Sounds, var )
				end
			end
		end
	end
end


--precache all the stuff for the server and client
PrecacheModels()
PrecacheSounds()