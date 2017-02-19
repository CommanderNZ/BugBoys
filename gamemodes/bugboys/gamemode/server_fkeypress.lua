

--F2 Key press
function TeamJoin( ply )
	--if the menu is already open then close out of it
	if ply:GetIfTeamJoinMenuOpen() then 
		ply:TeamMenu_Close()
		return 
	end

	if ply:GetIfClassMenuOpen() then 
		ply:TeamMenu_Open()
		ply:ClassMenu_Close()
		return 
	end
	

	--open the menu
	ply:TeamMenu_Open()
end
hook.Add("ShowTeam", "TeamJoin", TeamJoin)







--F1 Key press
--Ready up
function HelpMenu( ply )
	
end
hook.Add("ShowHelp", "HelpMenu", HelpMenu)





--F3 Key press
--Ready up
function ReadySet( ply )
	if PUB_MODE == true then return end

	local phase = GetGamePhase()
	if phase != "NoPlayers" and phase != "PreGame" then return end
	
	if ply:GetIfReady() then 
		ply:SetIfReady( false )
	else
		ply:SetIfReady( true )
	end

end
hook.Add("ShowSpare1", "ReadySet", ReadySet)













--F1 Key press
--[[
function ClassSet( ply )
	if true then return end

	if ply:GetIfTeamJoinMenuOpen() then 
		ply:TeamMenu_Close()
		ply:ClassMenu_Open()
		return 
	end

	if ply:GetIfClassMenuOpen() then 
		ply:ClassMenu_Close()
		return 
	end
	

	--open the menu
	ply:ClassMenu_Open()
end
hook.Add("ShowHelp", "ClassSet", ClassSet)
]]--




--help screen (shows all tools and descriptions)

--[[
--F1 Key press
function HelpGUI( ply )
	if ply.HelpMenuIsOpen != true then
		umsg.Start("Open_HelpVgui", ply)
		umsg.End()
		
		ply.HelpMenuIsOpen = true
		
	elseif ply.HelpMenuIsOpen == true then
		umsg.Start("Close_HelpVgui", ply)
		umsg.End()
		
		ply.HelpMenuIsOpen = false
	end
end
hook.Add("ShowHelp", "HelpGUI", HelpGUI)
]]--