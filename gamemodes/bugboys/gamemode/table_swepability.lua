/*---------------------------------------------------------
	Swep Abilities base table
---------------------------------------------------------*/

SWEP_ABILITY_TABLE = 
{


abil_rope =
{
name = "abil_rope",
print_name = "Rope",
func = "func_rope",
delay = 1,
clip = 1,
reload = 5,
dont_show_ammo = false,
}
,


abil_deconstruct =
{
name = "abil_deconstruct",
print_name = "Deconstruct",
func = "func_deconstruct",
delay = 1,
clip = 1,
reload = 1,
dont_show_ammo = true,
dont_reload = true,
}
,




}



--returns the reference table for the ent, X can ask for a specific version of an ent for multi mode ents
--X is not required
function SwepabilityReference( abilstring )
	for _, thing in pairs( SWEP_ABILITY_TABLE ) do
		if thing.name == abilstring then
			return thing
		end
	end
end
