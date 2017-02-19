/*---------------------------------------------------------
	Stuff that has to do with toggling abilities
---------------------------------------------------------*/


function KeyPressed (Ply, key)
	//print( key )

	if key == IN_ATTACK then
		if Ply.Ability_Primary != nil then
			Ply.Ability_Primary:DoAbility()
		end
	elseif key == IN_ATTACK2 then
		if Ply.Ability_Secondary != nil then
			Ply.Ability_Secondary:DoAbility()
		end
	end
end
 
hook.Add( "KeyPress", "KeyPressedHook", KeyPressed )