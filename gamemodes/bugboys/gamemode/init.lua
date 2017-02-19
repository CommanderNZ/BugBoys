/*---------------------------------------------------------
	AddCSLuaFile
---------------------------------------------------------*/

--all client side files
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_teammenu.lua" )
AddCSLuaFile( "cl_gametimer.lua" )
AddCSLuaFile( "cl_classmenu.lua" )
AddCSLuaFile( "cl_sounds.lua" )
AddCSLuaFile( "cl_deathnotice.lua" )
AddCSLuaFile( "cl_keypress.lua" )
AddCSLuaFile( "cl_quickmenu.lua" )
AddCSLuaFile( "cl_typecommands.lua" )
AddCSLuaFile( "cl_respawntimer.lua" )
AddCSLuaFile( "cl_scoreboard.lua" )
AddCSLuaFile( "cl_buildingghost.lua" )
AddCSLuaFile( "cl_helpmenu.lua" )



--all shared files
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "table_puck.lua" )
AddCSLuaFile( "table_ent.lua" )
AddCSLuaFile( "table_swep.lua" )
AddCSLuaFile( "table_craft.lua" )
AddCSLuaFile( "table_swepability.lua" )
AddCSLuaFile( "shared_settings.lua" )
AddCSLuaFile( "meta_player.lua" )
AddCSLuaFile( "meta_ent.lua" )
AddCSLuaFile( 'meta_puck_grab.lua' )
AddCSLuaFile( 'meta_puck_rope.lua' )
AddCSLuaFile( 'meta_puck_weld.lua' )
AddCSLuaFile( 'meta_puck_craft.lua' )





/*---------------------------------------------------------
	Include
---------------------------------------------------------*/

--all shared files
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


--all server files
include( 'server_spawning.lua' )
include( 'server_death.lua' )
include( 'server_gamesetup.lua' )
include( 'server_concommands.lua' )
include( 'server_fkeypress.lua' )
include( 'server_gametimer.lua' )
include( 'server_ingame.lua' )
include( 'server_abilitybinds.lua' )
include( 'server_typecommands.lua' )



game.AddParticles( "particles/rockettrail_dx80.pcf" )
game.AddParticles( "particles/rockettrail.pcf" )
game.AddParticles( "particles/explosion_dx80.pcf" )
game.AddParticles( "particles/explosion.pcf" )
game.AddParticles( "particles/explosion_high.pcf" )



/*---------------------------------------------------------
	Custom Content Needed To Download
---------------------------------------------------------*/

--[[
--materials
resource.AddFile("materials/ttg_logo.vmt")
resource.AddFile("materials/ttg_logo.vtf")

resource.AddFile("materials/tacticaltoolgame_mats/barrier01.vmt")
resource.AddFile("materials/tacticaltoolgame_mats/barrier01.vtf")

resource.AddFile("materials/tacticaltoolgame_mats/boulder01.vmt")
resource.AddFile("materials/tacticaltoolgame_mats/boulder01.vtf")

resource.AddFile("materials/tacticaltoolgame_mats/box.vmt")
resource.AddFile("materials/tacticaltoolgame_mats/box.vtf")

resource.AddFile("materials/tacticaltoolgame_mats/lasso01.vmt")
resource.AddFile("materials/tacticaltoolgame_mats/lasso01.vtf")

resource.AddFile("materials/tacticaltoolgame_mats/point01.vmt")
resource.AddFile("materials/tacticaltoolgame_mats/point01.vtf")

resource.AddFile("materials/tacticaltoolgame_mats/point02.vmt")

resource.AddFile("materials/tacticaltoolgame_mats/smokecube01.vmt")
resource.AddFile("materials/tacticaltoolgame_mats/smokecube01.vtf")

resource.AddFile("materials/tacticaltoolgame_mats/sphere01.vmt")
resource.AddFile("materials/tacticaltoolgame_mats/sphere01.vtf")

resource.AddFile("materials/tacticaltoolgame_mats/spikepanel01.vmt")
resource.AddFile("materials/tacticaltoolgame_mats/spikepanel01.vtf")



--models
resource.AddFile("models/tacticaltoolgame_models/box01.dx80.vtx")
resource.AddFile("models/tacticaltoolgame_models/box01.dx90.vtx")
resource.AddFile("models/tacticaltoolgame_models/box01.mdl")
resource.AddFile("models/tacticaltoolgame_models/box01.phy")
resource.AddFile("models/tacticaltoolgame_models/box01.sw.vtx")
resource.AddFile("models/tacticaltoolgame_models/box01.vvd")

resource.AddFile("models/tacticaltoolgame_models/box01_big.dx80.vtx")
resource.AddFile("models/tacticaltoolgame_models/box01_big.dx90.vtx")
resource.AddFile("models/tacticaltoolgame_models/box01_big.mdl")
resource.AddFile("models/tacticaltoolgame_models/box01_big.phy")
resource.AddFile("models/tacticaltoolgame_models/box01_big.sw.vtx")
resource.AddFile("models/tacticaltoolgame_models/box01_big.vvd")

resource.AddFile("models/tacticaltoolgame_models/barrier01.dx80.vtx")
resource.AddFile("models/tacticaltoolgame_models/barrier01.dx90.vtx")
resource.AddFile("models/tacticaltoolgame_models/barrier01.mdl")
resource.AddFile("models/tacticaltoolgame_models/barrier01.phy")
resource.AddFile("models/tacticaltoolgame_models/barrier01.sw.vtx")
resource.AddFile("models/tacticaltoolgame_models/barrier01.vvd")

resource.AddFile("models/tacticaltoolgame_models/boulder01.dx80.vtx")
resource.AddFile("models/tacticaltoolgame_models/boulder01.dx90.vtx")
resource.AddFile("models/tacticaltoolgame_models/boulder01.mdl")
resource.AddFile("models/tacticaltoolgame_models/boulder01.phy")
resource.AddFile("models/tacticaltoolgame_models/boulder01.sw.vtx")
resource.AddFile("models/tacticaltoolgame_models/boulder01.vvd")

resource.AddFile("models/tacticaltoolgame_models/boulder01_small.dx80.vtx")
resource.AddFile("models/tacticaltoolgame_models/boulder01_small.dx90.vtx")
resource.AddFile("models/tacticaltoolgame_models/boulder01_small.mdl")
resource.AddFile("models/tacticaltoolgame_models/boulder01_small.phy")
resource.AddFile("models/tacticaltoolgame_models/boulder01_small.sw.vtx")
resource.AddFile("models/tacticaltoolgame_models/boulder01_small.vvd")

resource.AddFile("models/tacticaltoolgame_models/boulder01_medium.dx80.vtx")
resource.AddFile("models/tacticaltoolgame_models/boulder01_medium.dx90.vtx")
resource.AddFile("models/tacticaltoolgame_models/boulder01_medium.mdl")
resource.AddFile("models/tacticaltoolgame_models/boulder01_medium.phy")
resource.AddFile("models/tacticaltoolgame_models/boulder01_medium.sw.vtx")
resource.AddFile("models/tacticaltoolgame_models/boulder01_medium.vvd")

resource.AddFile("models/tacticaltoolgame_models/spikepanel01.dx80.vtx")
resource.AddFile("models/tacticaltoolgame_models/spikepanel01.dx90.vtx")
resource.AddFile("models/tacticaltoolgame_models/spikepanel01.mdl")
resource.AddFile("models/tacticaltoolgame_models/spikepanel01.phy")
resource.AddFile("models/tacticaltoolgame_models/spikepanel01.sw.vtx")
resource.AddFile("models/tacticaltoolgame_models/spikepanel01.vvd")

resource.AddFile("models/tacticaltoolgame_models/smokecube01_bullcollide.dx80.vtx")
resource.AddFile("models/tacticaltoolgame_models/smokecube01_bullcollide.dx90.vtx")
resource.AddFile("models/tacticaltoolgame_models/smokecube01_bullcollide.mdl")
resource.AddFile("models/tacticaltoolgame_models/smokecube01_bullcollide.phy")
resource.AddFile("models/tacticaltoolgame_models/smokecube01_bullcollide.sw.vtx")
resource.AddFile("models/tacticaltoolgame_models/smokecube01_bullcollide.vvd")




--sounds
resource.AddFile("sound/setup_ha.mp3")
resource.AddFile("sound/setup_lor.mp3")
]]--









--[[
--materials
resource.AddSingleFile("materials/ttg_logo.vmt")
resource.AddSingleFile("materials/ttg_logo.vtf")

resource.AddSingleFile("materials/tacticaltoolgame_mats/barrier01.vmt")
resource.AddSingleFile("materials/tacticaltoolgame_mats/barrier01.vtf")

resource.AddSingleFile("materials/tacticaltoolgame_mats/boulder01.vmt")
resource.AddSingleFile("materials/tacticaltoolgame_mats/boulder01.vtf")

resource.AddSingleFile("materials/tacticaltoolgame_mats/box.vmt")
resource.AddSingleFile("materials/tacticaltoolgame_mats/box.vtf")

resource.AddSingleFile("materials/tacticaltoolgame_mats/lasso01.vmt")
resource.AddSingleFile("materials/tacticaltoolgame_mats/lasso01.vtf")

resource.AddSingleFile("materials/tacticaltoolgame_mats/point01.vmt")
resource.AddSingleFile("materials/tacticaltoolgame_mats/point01.vtf")

resource.AddSingleFile("materials/tacticaltoolgame_mats/point02.vmt")

resource.AddSingleFile("materials/tacticaltoolgame_mats/smokecube01.vmt")
resource.AddSingleFile("materials/tacticaltoolgame_mats/smokecube01.vtf")

resource.AddSingleFile("materials/tacticaltoolgame_mats/sphere01.vmt")
resource.AddSingleFile("materials/tacticaltoolgame_mats/sphere01.vtf")

resource.AddSingleFile("materials/tacticaltoolgame_mats/spikepanel01.vmt")
resource.AddSingleFile("materials/tacticaltoolgame_mats/spikepanel01.vtf")

resource.AddSingleFile("materials/hitchswing/ballmat01.vmt")
resource.AddSingleFile("materials/hitchswing/ballmat01.vtf")



--models
resource.AddSingleFile("models/tacticaltoolgame_models/box01.dx80.vtx")
resource.AddSingleFile("models/tacticaltoolgame_models/box01.dx90.vtx")
resource.AddSingleFile("models/tacticaltoolgame_models/box01.mdl")
resource.AddSingleFile("models/tacticaltoolgame_models/box01.phy")
resource.AddSingleFile("models/tacticaltoolgame_models/box01.sw.vtx")
resource.AddSingleFile("models/tacticaltoolgame_models/box01.vvd")

resource.AddSingleFile("models/tacticaltoolgame_models/box01_big.dx80.vtx")
resource.AddSingleFile("models/tacticaltoolgame_models/box01_big.dx90.vtx")
resource.AddSingleFile("models/tacticaltoolgame_models/box01_big.mdl")
resource.AddSingleFile("models/tacticaltoolgame_models/box01_big.phy")
resource.AddSingleFile("models/tacticaltoolgame_models/box01_big.sw.vtx")
resource.AddSingleFile("models/tacticaltoolgame_models/box01_big.vvd")

resource.AddSingleFile("models/tacticaltoolgame_models/barrier01.dx80.vtx")
resource.AddSingleFile("models/tacticaltoolgame_models/barrier01.dx90.vtx")
resource.AddSingleFile("models/tacticaltoolgame_models/barrier01.mdl")
resource.AddSingleFile("models/tacticaltoolgame_models/barrier01.phy")
resource.AddSingleFile("models/tacticaltoolgame_models/barrier01.sw.vtx")
resource.AddSingleFile("models/tacticaltoolgame_models/barrier01.vvd")

resource.AddSingleFile("models/tacticaltoolgame_models/boulder01.dx80.vtx")
resource.AddSingleFile("models/tacticaltoolgame_models/boulder01.dx90.vtx")
resource.AddSingleFile("models/tacticaltoolgame_models/boulder01.mdl")
resource.AddSingleFile("models/tacticaltoolgame_models/boulder01.phy")
resource.AddSingleFile("models/tacticaltoolgame_models/boulder01.sw.vtx")
resource.AddSingleFile("models/tacticaltoolgame_models/boulder01.vvd")

resource.AddSingleFile("models/tacticaltoolgame_models/boulder01_small.dx80.vtx")
resource.AddSingleFile("models/tacticaltoolgame_models/boulder01_small.dx90.vtx")
resource.AddSingleFile("models/tacticaltoolgame_models/boulder01_small.mdl")
resource.AddSingleFile("models/tacticaltoolgame_models/boulder01_small.phy")
resource.AddSingleFile("models/tacticaltoolgame_models/boulder01_small.sw.vtx")
resource.AddSingleFile("models/tacticaltoolgame_models/boulder01_small.vvd")

resource.AddSingleFile("models/tacticaltoolgame_models/boulder01_medium.dx80.vtx")
resource.AddSingleFile("models/tacticaltoolgame_models/boulder01_medium.dx90.vtx")
resource.AddSingleFile("models/tacticaltoolgame_models/boulder01_medium.mdl")
resource.AddSingleFile("models/tacticaltoolgame_models/boulder01_medium.phy")
resource.AddSingleFile("models/tacticaltoolgame_models/boulder01_medium.sw.vtx")
resource.AddSingleFile("models/tacticaltoolgame_models/boulder01_medium.vvd")

resource.AddSingleFile("models/tacticaltoolgame_models/spikepanel01.dx80.vtx")
resource.AddSingleFile("models/tacticaltoolgame_models/spikepanel01.dx90.vtx")
resource.AddSingleFile("models/tacticaltoolgame_models/spikepanel01.mdl")
resource.AddSingleFile("models/tacticaltoolgame_models/spikepanel01.phy")
resource.AddSingleFile("models/tacticaltoolgame_models/spikepanel01.sw.vtx")
resource.AddSingleFile("models/tacticaltoolgame_models/spikepanel01.vvd")

resource.AddSingleFile("models/tacticaltoolgame_models/smokecube01_bullcollide.dx80.vtx")
resource.AddSingleFile("models/tacticaltoolgame_models/smokecube01_bullcollide.dx90.vtx")
resource.AddSingleFile("models/tacticaltoolgame_models/smokecube01_bullcollide.mdl")
resource.AddSingleFile("models/tacticaltoolgame_models/smokecube01_bullcollide.phy")
resource.AddSingleFile("models/tacticaltoolgame_models/smokecube01_bullcollide.sw.vtx")
resource.AddSingleFile("models/tacticaltoolgame_models/smokecube01_bullcollide.vvd")

resource.AddSingleFile("models/hitchswing/grappler.dx80.vtx")
resource.AddSingleFile("models/hitchswing/grappler.dx90.vtx")
resource.AddSingleFile("models/hitchswing/grappler.mdl")
resource.AddSingleFile("models/hitchswing/grappler.phy")
resource.AddSingleFile("models/hitchswing/grappler.sw.vtx")
resource.AddSingleFile("models/hitchswing/grappler.vvd")






--sounds
resource.AddSingleFile("sound/setup_ha.mp3")
resource.AddSingleFile("sound/setup_lor.mp3")

resource.AddSingleFile("sound/portal_disappear.mp3")
resource.AddSingleFile("sound/portal_appear.mp3")
resource.AddSingleFile("sound/portal_loop.mp3")
]]--




//add workshop download thing in the future







--global vars which do not reset until the map is changed, unlike other globals which all reset at the end of a match

--this var keeps track of how many games of ttg have taken place without switching from the current map
--gets added to at the end of a match, when one team wins the whole thing
--P_MatchNum = 0 

--this var is for activating the "wait for players" timer, if we just switched maps, gets set to false after the first GameRestart()
--P_JustSwitchedMaps = true












--Starts the whole game up
GameRestart()


SERVER_MAPS = { "bb_temples_b17", "bb_flatspace_b7", "bb_islands_b10", "bb_normandy_b4"  }

--reloads level every 1 hour so stuff doesnt get wonky in the game

function Check_TimeChangeLevel()
	--3600 = 1 hr
	if CurTime() >= 3600 then
		local phase = GetGamePhase()
		if GetGamePhase() == "NoPlayers" or GetGamePhase() == "PreGame" then
			local curmap = game.GetMap()
			
			local function GetMap()
				local newmap = table.Random( SERVER_MAPS )
				return newmap
			end
			
			local done = false
			while done == false do
				local getmap = GetMap()
				if getmap != curmap then
					done = true
					RunConsoleCommand( "changelevel", getmap )
				end
			end	

			
		end
	end
end

function Start_CheckTimeChangeLevel()
	hook.Add("Tick", "Check_TimeChangeLevel", Check_TimeChangeLevel)
end

Start_CheckTimeChangeLevel()













--theres no fall damage in the game right now
function GM:GetFallDamage( ply, speed )
	return 0
end


--disallow noclip if we're not in devmode
function GM:PlayerNoClip( pl )
	return false
end







function GM:PlayerDisconnected( ply )
	print( ply:GetName() .. "  disconnected from the game!")
	if ply:HasPuck() then
		ply.Disconnected = true
		
		--drop tokens for teammates to use
		if GetGamePhase() == "BegunGame" or GetGamePhase() == "SetupGame" then
			ply:DropAllTokensInSpawn()
		end
		
		ply.Puck:Break()
		--disallowing respawn
	end
end


function GM:AllowPlayerPickup( player, entity)
	return false
end



--[[
function SetEntityDamage( ent, dmginfo )


	--Disable team damage
	local attacker = dmginfo:GetAttacker()
	print( "attacker:", attacker )
	print( "taking damage ent:", ent )
	if attacker:IsPlayer() and ent:IsPlayer() then
		//if attacker:Team() == victim:Team() and attacker != victim then
		if attacker:Team() == ent:Team() then
			print("taking away TEAM DAMAGE")
			dmginfo:ScaleDamage( 0 )
			return 
		end
	end


	//print("ent taking damage:  " .. dmginfo:GetDamageType() )
	
	--Disable physics damage on all ents
	if dmginfo:IsDamageType( DMG_CRUSH ) then
		//print("phys damage")
		//print("taking away physics damage from player")
		dmginfo:ScaleDamage( 0 )
		return
	end


	--Explosion damage type modifier
	if dmginfo:IsDamageType( DMG_BLAST ) then
		local explosion = dmginfo:GetInflictor()
		if not IsValid(explosion) then return end
		if explosion:GetClass() != "env_explosion" then return end
			
		if explosion.DamagePlyOnly == true and CheckIfInEntTable( ent ) then
			//print("taking away explosion damage from building")
			dmginfo:ScaleDamage( 0 )
		elseif explosion.DamageBuildingOnly == true and ent:IsPlayer() then
			//print("taking away explosion damage from player")
			dmginfo:ScaleDamage( 0 )
		end
	end

end
hook.Add("EntityTakeDamage", "SetEntityDamage", SetEntityDamage)
]]--






--[[

function GM:Think()
	for k,v in pairs(player.GetAll()) do	
		if v:Team() != TEAM_SPEC then
			if v:OnGround() then
				-- Make a trace to check if the sentry can see the target
				local Trace = {}
					Trace.start = v:GetPos() + Vector(0, 0, 40)
					Trace.endpos = v:GetPos() - Vector(0, 0, 100)
					Trace.filter = v
					Trace.mask = MASK_SOLID - CONTENTS_GRATE
					Trace = util.TraceLine(Trace) 
					
				--print( Trace.HitNormal )
				local vel = v:GetVelocity()
		
				--print( vel[3] )
				v:SetLocalVelocity( (Trace.HitNormal + v:GetForward()) * 500 )
				--v:SetLocalVelocity( (Trace.HitNormal) * 500 )
			end
		end
	end

end
]]--

--[[

function DropSlamHitGround( ply, inwater, onfloater, fallspeed )
	local Trace = {}
		Trace.start = ply:GetPos() + Vector(0, 0, 40)
		Trace.endpos = ply:GetPos() - Vector(0, 0, 100)
		Trace.filter = ply
		Trace.mask = MASK_SOLID - CONTENTS_GRATE
		Trace = util.TraceLine(Trace) 
		
	--print( Trace.HitNormal )
	print( fallspeed )
	print(ply)
	local height_amp = fallspeed * 2
	ply:SetVelocity( (Trace.HitNormal + ply:GetForward()) * fallspeed	)
	--ply:SetLocalVelocity( (Trace.HitNormal) * 500 )
end
hook.Add("OnPlayerHitGround", "DropSlamHitGround", DropSlamHitGround)
]]--




/*---------------------------------------------------------
	Movement
---------------------------------------------------------*/
--[[
function KeyPressed (ply, key)
	--print(ply:Name() .. " pressed ".. key)
	
	if key == IN_MOVELEFT then
		ply:SetVelocity( (ply:GetForward() - ply:GetRight()) * 200 )
	elseif key == IN_MOVERIGHT then
		ply:SetVelocity( (ply:GetForward() + ply:GetRight()) * 200 )
	end
end
 
hook.Add( "KeyPress", "KeyPressedHook", KeyPressed )






]]--








function ChatPrintToAll( str )
	for _, ply in pairs(player.GetAll()) do
		ply:ChatPrint( str )
	end
end