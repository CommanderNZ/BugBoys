/*---------------------------------------------------------
	Client Game Time Display
---------------------------------------------------------*/


//local show = false
local function RespawnHud()
	
	--[[
	if show == true then
		local timeleft = GetGlobalInt( "CL_RespawnTimer_" .. LocalPlayer():UniqueID() )
		//if timeleft < (10 + 1) and timeleft > 0 then
		if timeleft > 0 then
			draw.SimpleTextOutlined("Spawning in:", "TargetID", ScrW()/2-60, 130, red, 3, 3, 3, Color(0, 0, 0, 255))
			draw.SimpleTextOutlined( timeleft , "TargetID", ScrW()/2, 150, Color(255, 255, 255, 255), 3, 3, 3, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER)
		end
	end
	]]--
	
	
	local Ply = LocalPlayer()
	
	if Ply:Team() == TEAM_SPEC then return end
	
	local complete_time = Ply:GetRespawnTime()
	if complete_time != 0 and CurTime() < complete_time then
		local cur_time = CurTime()
		local display = RoundNum( (complete_time - cur_time), 1 )

		if display != 0 then
			draw.SimpleTextOutlined("Spawning in:", "TargetID", ScrW()/2-60, 130, Color(255, 255, 255, 255), 3, 3, 3, Color(0, 0, 0, 255))
			draw.SimpleTextOutlined( display , "TargetID", ScrW()/2, 150, Color(255, 255, 255, 255), 3, 3, 3, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER)
		end
	end
	
	
	--[[
	local function Start()
		show = true
	end
	usermessage.Hook( "RepsawnTimer_Start", Start )

	local function End()
		show = false
	end
	usermessage.Hook( "RepsawnTimer_End", End )
	]]--
end
hook.Add("HUDPaint", "RespawnHud", RespawnHud)

