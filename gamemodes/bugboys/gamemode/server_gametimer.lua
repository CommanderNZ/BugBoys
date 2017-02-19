/*---------------------------------------------------------
	Game Time Stuff
---------------------------------------------------------*/
G_Overtime = false	--global var that says whether or not we're in overtime right now

local GameTimeOn = false
local EventAtZero = nil


--Starts running the timer whatever amount is specified
--Sets what function will happen when the timer reaches zero
function InitializeGameTimer(amount,eventatzero)
	GameTime = amount
	EventAtZero = eventatzero
	
	--this var triggers something to happen every time it reaches 60 sec, adds 1 sec every tick of the clock
	IntervalTrigger_PointSub = 0
	IntervalTrigger_TokensAdd = 0
	
	NextAddTime = CurTime() + 1
	GameTimeOn = true
	UpdateHUDTime()
end



--------------------------------------------------------------------------------

--Called when the timer reaches zero
--Turns timer off
--does whatever function EventAtZero refers to 
--resets EventAtZero to nil
function ZeroEvent(func)
	//print("time up!  Beginning next phase!")
	GameTimeOn = false
	EventAtZero = nil
	return func()
end


function Start_CheckOvertime()
	hook.Add("Think", "CheckOvertime", CheckOvertime)
end

function End_CheckOvertime()
	hook.Remove("Think", "CheckOvertime")
end

--called on think when it becomes overtime, (when timer is at 0 but the capture time is still in flux)
function CheckOvertime()
	if G_CaptureTimeMoving == false then --end itself if the 
		G_Overtime = false
		
		SetGlobalBool("CL_DrawOvertime", false)
		
		End_CheckOvertime()
	end
end


--Called every time the time changes seconds
function DoGameTimer()
	if GameTimeOn == true then
		if (CurTime() >= NextAddTime) then
			NextAddTime = CurTime() + 1
			GameTime = GameTime - 1
			IntervalTrigger_PointSub = IntervalTrigger_PointSub + 1
			IntervalTrigger_TokensAdd = IntervalTrigger_TokensAdd + 1
			UpdateHUDTime()
		end
		
		if IntervalTrigger_PointSub == POINT_SUBTRACTION_INTERVAL then
			SubtractPointsInterval()
			IntervalTrigger_PointSub = 0
		end
		
		if IntervalTrigger_TokensAdd == TOKENS_SPAWN_INTERVAL then
			SpawnTokens_Interval()
			IntervalTrigger_TokensAdd = 0
		end
		
		if GameTime <= 0 then
		
			--not currently used but may be re implemented at some point if theres a control point
			--if the capture timer thing is still active in the combat phase, 
			--the game is not over so dont do a zero event.
			if G_CaptureTimeMoving == true and G_CurrentPhase == "Combat" then
				SetGlobalBool("CL_DrawOvertime", true)
				
				Start_CheckOvertime()
				--play overtime sound
				//umsg.Start("Announcer_Overtime", v)
				//umsg.End()
				
				G_Overtime = true
				return 
			end
			
			ZeroEvent(EventAtZero)
		end
	end
end
hook.Add("Think", "DoGameTimer", DoGameTimer)


--Clears the timer, resetting it to zero, and turns it off
function Clear_Timer()
	GameTime = 0
	EventAtZero = nil
	GameTimeOn = false
	G_Overtime = false
	
	UpdateHUDTime()
end


--Converts seconds time variable to "minutes:seconds" in that format and returns it
function ConvertSecondsToDisplay(time)
	local mins = 0
	local secs = 0
	
	while time > 0 do
		if time >= 60 then 
			mins = mins + 1
			time = time - 60
		elseif time < 60 then
			secs = time
			time = 0
		end
	end
	
	if secs < 10 then
		secs = ("0" .. secs)
	end
	if mins < 10 then
		mins = ("0" .. mins)
	end
	
	local timestring = (mins .. ":" .. secs)
	return timestring
end

--Sends usermsg to the client to update the display of the current time on the clock
function UpdateHUDTime()
	local timestring = ConvertSecondsToDisplay(GameTime)
	
	umsg.Start( "GameTimerUpdate" )
	umsg.String( timestring )
	umsg.End()
end
