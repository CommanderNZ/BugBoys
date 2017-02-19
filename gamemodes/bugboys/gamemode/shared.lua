GM.Name = "Bug Boys"
GM.Author = "Sean 'Heyo' Cutino"
GM.Email = ""
GM.Website = ""




CAN_NOCLIP = false







--gets returns vec position with Z modified so its on the ground
function ToGround( vec, filter )
	local pos = vec
	local tracedata = {}
		tracedata.start = pos
		tracedata.endpos = pos + (Vector(0, 0, -1) * 4000)
		tracedata.filter = filter
	local trace = util.TraceLine(tracedata)
	local hitpos = trace.HitPos

	return hitpos
end









--Disable footsteps
function GM:PlayerFootstep( ply, pos, foot, sound, volume, rf ) 
	--[[
	--Dont disable local players footsteps ONLY
	if CLIENT then
		if ply == LocalPlayer() then
			return false
		end
	end
	--return true 
	]]--
	return false
end







/*---------------------------------------------------------
	Team Set Up and team methods
---------------------------------------------------------*/

TEAM_RED = 1
TEAM_BLUE = 2
TEAM_SPEC = 3

team.SetUp( TEAM_RED, "Red Team", Color( 255, 0, 0, 255 ), true )
team.SetUp( TEAM_BLUE, "Blue Team", Color( 0, 0, 255, 255 ), true )
team.SetUp( TEAM_SPEC, "Spectators", Color( 200, 200, 200, 255 ), true )




//function GetTeamRespawnTime()
//end





function SetShieldHealth( teamnum, hp )
	if teamnum == TEAM_BLUE then
		SetGlobalInt("Shield_Blue_HP", hp)
	elseif teamnum == TEAM_RED then
		SetGlobalInt("Shield_Red_HP", hp)
	end
end

function GetShieldHealth( teamnum )
	if teamnum == TEAM_BLUE then
		return GetGlobalInt("Shield_Blue_HP", 0)
	elseif teamnum == TEAM_RED then
		return GetGlobalInt("Shield_Red_HP", 0)
	end
end






function SetBrainHealth( teamnum, hp )
	if teamnum == TEAM_BLUE then
		SetGlobalInt("Brain_Blue_HP", hp)
	elseif teamnum == TEAM_RED then
		SetGlobalInt("Brain_Red_HP", hp)
	end
end

function GetBrainHealth( teamnum )
	if teamnum == TEAM_BLUE then
		return GetGlobalInt("Brain_Blue_HP", 0)
	elseif teamnum == TEAM_RED then
		return GetGlobalInt("Brain_Red_HP", 0)
	end
end




--this runs at the beginning of the round
function SetTeamStartingTokens()
	local bluecount = 0
	local redcount = 0
	for k,ply in pairs(player.GetAll()) do	
		if ply:Team() == TEAM_RED then
			redcount = redcount + 1
		elseif ply:Team() == TEAM_BLUE then
			bluecount = bluecount + 1
		end
	end
	
	local bluetokens = RoundNum( (STARTING_TEAM_TOKENS / bluecount) )
	local redtokens = RoundNum( (STARTING_TEAM_TOKENS / redcount) )
	
	if bluecount == 0 then
		bluetokens = 10
	end
	
	if redcount == 0 then
		redtokens = 10
	end
	
	SetGlobalInt("Blue_StartingTokens", bluetokens)
	SetGlobalInt("Red_StartingTokens", redtokens)
end


function GetTeamStartingTokens( teamnum )
	if teamnum == TEAM_BLUE then	
		return GetGlobalInt("Blue_StartingTokens", 0)
	elseif teamnum == TEAM_RED then	
		return GetGlobalInt("Red_StartingTokens", 0)
	end
end



function GetOppositeTeam( teamnum )
	if teamnum == TEAM_RED then	
		return TEAM_BLUE
	else
		return TEAM_RED
	end
end








function ResetDeathCounter()
	SetGlobalInt("Blue_Deaths", 0)
	SetGlobalInt("Red_Deaths", 0)
end

function AddDeathCounter( teamnum, amount )
	if amount == nil then
		amount = 1
	end

	if teamnum == TEAM_BLUE then
		local cur = GetGlobalInt("Blue_Deaths", 0)
		SetGlobalInt("Blue_Deaths", amount + cur)
	elseif teamnum == TEAM_RED then
		local cur = GetGlobalInt("Red_Deaths", 0)
		SetGlobalInt("Red_Deaths", amount + cur)
	end
end

function GetHowManyDeaths( teamnum )
	if teamnum == TEAM_BLUE then
		return GetGlobalInt("Blue_Deaths", 0)
	elseif teamnum == TEAM_RED then
		return GetGlobalInt("Red_Deaths", 0)
	end
end







--team based lives code

function SetLives( teamnum, amount )
	if teamnum == TEAM_BLUE then
		SetGlobalInt("Blue_Lives", amount)
	elseif teamnum == TEAM_RED then
		SetGlobalInt("Red_Lives", amount)
	end
end


function AddLife( teamnum, amount )
	if amount == nil then
		amount = 1
	end

	if teamnum == TEAM_BLUE then
		local cur = GetGlobalInt("Blue_Lives", 0)
		SetGlobalInt("Blue_Lives", amount + cur)
	elseif teamnum == TEAM_RED then
		local cur = GetGlobalInt("Red_Lives", 0)
		SetGlobalInt("Red_Lives", amount + cur)
	end
end


function RemoveLife( teamnum, amount )
	if amount == nil then
		amount = 1
	end
	
	if teamnum == TEAM_BLUE then
		local cur = GetGlobalInt("Blue_Lives", 0)
		SetGlobalInt("Blue_Lives", cur - amount)
	elseif teamnum == TEAM_RED then
		local cur = GetGlobalInt("Red_Lives", 0)
		SetGlobalInt("Red_Lives", cur - amount)
	end
end


function GetHowManyLives( teamnum )
	if teamnum == TEAM_BLUE then
		return GetGlobalInt("Blue_Lives", 0)
	elseif teamnum == TEAM_RED then
		return GetGlobalInt("Red_Lives", 0)
	end
end








function SetWinningTeam( teamnum )
	if teamnum == TEAM_BLUE then
		SetGlobalInt("WinningTeam", TEAM_BLUE)
	elseif teamnum == TEAM_RED then
		SetGlobalInt("WinningTeam", TEAM_RED)
	else
		SetGlobalInt("WinningTeam", 3)
	end
end

function GetWinningTeam()
	return GetGlobalInt("WinningTeam", 50)
end

function ResetWinningTeam()
	SetGlobalInt("WinningTeam", 50)
end






function AddPoints( teamnum, amount )
	if amount == nil then
		amount = 1
	end
	team.AddScore ( teamnum, amount )
end

function SubtractPoints( teamnum, amount )
	if amount == nil then
		amount = 1
	end
	team.AddScore ( teamnum, -amount )
end

function GetPoints( teamnum )
	return team.GetScore( teamnum )
end




function SetMaxScore(num)
	SetGlobalInt("MaxScore", num)
end

function GetMaxScore()
	return GetGlobalInt("MaxScore", 0)
end




function ConvertToTeamName(num)
	local printname = "Invalid Team"

	if num == 1 then
		printname = "Team Red"
	elseif num == 2 then
		printname = "Team Blue"
	elseif num == 3 then
		printname = "Spectators"
	elseif num == 4 then
		printname = "Racers"
	end
	
	return printname
end




function SetGamePhase(phase)
	SetGlobalString("GamePhase", phase)
end

function GetGamePhase()
	return GetGlobalString("GamePhase")
end






--Random useful stuff for client and server, doesnt really have to do with game itself

function RoundNum(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end




--creates a visual explosion at the position
function VisualExplosion(pos, owner, flags)
	if flags == nil then
		flags = 81
	end

	local explosion = ents.Create( "env_explosion" )
	explosion:SetPos( pos )
	explosion:SetOwner( owner )
	explosion:Spawn()
	explosion:SetKeyValue("spawnflags",flags)
	explosion:Fire( "Explode", 0, 0 )
end



--returns whether or not the ent is within the radius located at pos
function GetIfInRange( pos, radius, ent )
	local orgin_ents = ents.FindInSphere( pos, radius )
	for k, thing in pairs( orgin_ents ) do
		if thing == ent then
			return true
		end
	end
	return false
end