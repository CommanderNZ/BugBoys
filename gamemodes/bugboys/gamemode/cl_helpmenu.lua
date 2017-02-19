--[[---------------------------------------------------------
	Quick menu that opens when you hold Q
---------------------------------------------------------]]--

function ShowHelpMenu()
	local Ply = LocalPlayer()

	local function HelpImage()
		draw.TexturedQuad
		{
		texture = surface.GetTextureID "bugboys/helpscreen",
		color = Color(255, 255, 255, 255),
		x = ScrW()/2 - 256,
		y = ScrH()/2-512,
		w = 512,
		h = 1024,
		}
	end

	local function SetVisibility(bool)
		if bool == true then 
			hook.Add( "HUDPaint", "HelpImage", HelpImage )
		else
			hook.Remove( "HUDPaint", "HelpImage" )
		end
	end
	
	
	local turned_on = false
	
	local function F3Press()
		local iskeydown = input.IsKeyDown( KEY_F1 )
		
		if iskeydown then 
			SetVisibility(true)
			turned_on = true
		else
			if turned_on == true then
				turned_on = false
			end
			SetVisibility(false)
		end
	end
	hook.Add("Think","F3Press",F3Press)
end
ShowHelpMenu()