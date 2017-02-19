ENT.Type 			= "brush"
ENT.Base 			= "base_anim"
ENT.PrintName		= ""



if !SERVER then return end
------------------------------------------------------------------------------------------------
--all server from now on
------------------------------------------------------------------------------------------------

//ENT.TouchingPlyList = {}



function ENT:Initialize()
end



function ENT:StartTouch( entity )
	--if the touching ent is a point piece, give the correct team a point for getting it in there
	if entity:GetClass() == "ent_crystal" then //and entity.BBTeam == TEAM_BLUE  then 
		if GetGamePhase() == "BegunGame" then
			--add points for the enemy team
			print("blue team SCORES!")
			PlayGlobalSound( "Sound_TeamScore" )
			team.AddScore ( TEAM_BLUE, 1 )
		end
		entity:Remove()
	
	--if a puck fell in the hole, deal massive damage to them to kill them
	elseif entity:IsValidPuck() then
		local dmginfo = DamageInfo()
			dmginfo:SetDamage( 5000 )
			dmginfo:SetDamageType( DMG_CRUSH )
			dmginfo:SetInflictor( entity )
			dmginfo:SetAttacker( entity )
			entity:TakeDamageInfo( dmginfo )
		
	--if a random game ent has fallen in the hole, just delete it
	elseif CheckIfInEntTable( entity ) then
		entity:Remove()
	end
end


//function ENT:Think()
//end



//for _, v in pairs(player.GetAll()) do
	//v:PrintMessage(HUD_PRINTTALK, entity:GetName().. " has entered the lua brush area.")
//end
