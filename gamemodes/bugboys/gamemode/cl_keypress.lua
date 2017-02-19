

 
 
 
  --[[
local function BuyMenuPress()
	local iskeydown = input.IsKeyDown(KEY_B)
    //gui.EnableScreenClicker(iskeydown)
	if iskeydown then 
		ShowBuyMenu():SetVisibility(true)
	else
		ShowBuyMenu():SetVisibility(false)
	end
	
	if input.WasKeyReleased(KEY_B) then
		print("key was released")
	end
end
 
hook.Add("Think","Buy Menu Press",BuyMenuPress)
 ]]--