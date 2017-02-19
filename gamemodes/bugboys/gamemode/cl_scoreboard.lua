





/*----------------------------------------------------------------------------------------------------------
	Scoreboard
	
	Shows what everyone on your team and the enemy team has bought
------------------------------------------------------------------------------------------------------------*/

--[[
function DermaScoreboard()
	local ply = LocalPlayer()
	local panel_width = 300
	local panel_height = 450

	

	local function Update()
	
	
	end
	hook.Add("Think", "Update_ScoreboardVgui", Update)
	
	
	
	local function Close()
		//PanelFriendly:SetVisible( false )
		//PanelFriendly:Close()
		hook.Remove( "Think", "Update_ScoreboardVgui" )
	end
	hook.Add("ScoreboardHide", "Close_ScoreboardVgui", Close)
	
 
	
end
hook.Add("ScoreboardShow", "Open_ScoreboardVgui", DermaScoreboard)


]]--






surface.CreateFont( "ScoreboardDefault",
{
	font		= "Helvetica",
	size		= 22,
	weight		= 800
})

surface.CreateFont( "ScoreboardDefaultTitle",
{
	font		= "Helvetica",
	size		= 32,
	weight		= 800
})


--
-- This defines a new panel type for the player row. The player row is given a player
-- and then from that point on it pretty much looks after itself. It updates player info
-- in the think function, and removes itself when the player leaves the server.
--
local PLAYER_LINE = 
{
	Init = function( self )

		self.AvatarButton = self:Add( "DButton" )
		self.AvatarButton:Dock( LEFT )
		self.AvatarButton:SetSize( 32, 32 )
		self.AvatarButton.DoClick = function() self.Player:ShowProfile() end

		self.Avatar		= vgui.Create( "AvatarImage", self.AvatarButton )
		self.Avatar:SetSize( 32, 32 )
		self.Avatar:SetMouseInputEnabled( false )		

		self.Name		= self:Add( "DLabel" )
		self.Name:Dock( FILL )
		self.Name:SetFont( "ScoreboardDefault" )
		self.Name:DockMargin( 8, 0, 0, 0 )
		self.Name:SetColor( Color(255,255,255,255) )
		

		self.Ping		= self:Add( "DLabel" )
		self.Ping:Dock( RIGHT )
		self.Ping:SetWidth( 50 )
		self.Ping:SetFont( "ScoreboardDefault" )
		self.Ping:SetContentAlignment( 5 )
		self.Ping:SetColor( Color(255,255,255,255) )

		--[[
		self.Kills		= self:Add( "DLabel" )
		self.Kills:Dock( RIGHT )
		self.Kills:SetWidth( 50 )
		self.Kills:SetFont( "ScoreboardDefault" )
		self.Kills:SetContentAlignment( 5 )
		self.Kills:SetColor( Color(255,255,255,255) )
		]]--

		self:Dock( TOP )
		self:DockPadding( 3, 3, 3, 3 )
		self:SetHeight( 32 + 3*2 )
		self:DockMargin( 2, 0, 2, 2 )

	end,

	Setup = function( self, pl )

		self.Player = pl

		self.Avatar:SetPlayer( pl )
		self.Name:SetText( pl:Nick() )

		self:Think( self )

		--local friend = self.Player:GetFriendStatus()
		--MsgN( pl, " Friend: ", friend )

	end,

	Think = function( self )

		if ( !IsValid( self.Player ) ) then
			self:Remove()
			return
		end
		
		
		if ( self.TeamNum != self.Player:Team() ) then
			self:Remove()
			return
		end


		--[[
		if ( self.NumKills == nil || self.NumKills != self.Player:Frags() ) then
			self.NumKills	=	self.Player:Frags()
			self.Kills:SetText( self.NumKills )
		end
		]]--

		if ( self.NumPing == nil || self.NumPing != self.Player:Ping() ) then
			self.NumPing	=	self.Player:Ping()
			self.Ping:SetText( self.NumPing )
		end



		--
		-- Connecting players go at the very bottom
		--
		if ( self.Player:Team() == TEAM_CONNECTING ) then
			self:SetZPos( 2000 )
		end

		--
		-- This is what sorts the list. The panels are docked in the z order, 
		-- so if we set the z order according to kills they'll be ordered that way!
		-- Careful though, it's a signed short internally, so needs to range between -32,768k and +32,767
		--
		
		//self:SetZPos( (self.NumKills * -50) )// + self.NumDeaths )

	end,

	Paint = function( self, w, h )

		if ( !IsValid( self.Player ) ) then
			return
		end

		--
		-- We draw our background a different colour based on the status of the player
		--

		if ( self.Player:Team() == TEAM_CONNECTING ) then
			draw.RoundedBox( 4, 0, 0, w, h, Color( 200, 200, 200, 200 ) )
			return
		end
		
		if ( self.Player:Team() == TEAM_RED ) then
			if self.Player:HasNetPuck() then
				draw.RoundedBox( 4, 0, 0, w, h, Color( 250, 150, 150, 200 ) )
			else
				draw.RoundedBox( 4, 0, 0, w, h, Color( 150, 50, 50, 200 ) )
			end
			return
		end
		
		if ( self.Player:Team() == TEAM_BLUE ) then
			if self.Player:HasNetPuck() then
				draw.RoundedBox( 4, 0, 0, w, h, Color( 150, 150, 250, 200 ) )
			else
				draw.RoundedBox( 4, 0, 0, w, h, Color( 50, 50, 150, 200 ) )
			end
			return
		end

		draw.RoundedBox( 4, 0, 0, w, h, Color( 230, 230, 230, 255 ) )
		
	end,
}

--
-- Convert it from a normal table into a Panel Table based on DPanel
--
PLAYER_LINE = vgui.RegisterTable( PLAYER_LINE, "DPanel" );








--
-- Here we define a new panel table for the scoreboard. It basically consists 
-- of a header and a scrollpanel - into which the player lines are placed.
--
local SCORE_BOARD_RED = 
{
	Init = function( self )

		--[[
		self.Header = self:Add( "Panel" )
		self.Header:Dock( TOP )
		self.Header:SetHeight( 100 )

		self.Name = self.Header:Add( "DLabel" )
		self.Name:SetFont( "ScoreboardDefaultTitle" )
		self.Name:SetTextColor( Color( 255, 255, 255, 255 ) )
		self.Name:Dock( TOP )
		self.Name:SetHeight( 40 )
		self.Name:SetContentAlignment( 5 )
		self.Name:SetExpensiveShadow( 2, Color( 0, 0, 0, 200 ) )
		]]--


		self.Scores = self:Add( "DScrollPanel" )
		self.Scores:Dock( FILL )

	end,

	
	PerformLayout = function( self )
		self:SetSize( 300, ScrH() - 200 )
		self:SetPos( ScrW()/2 - 350, 100 )
	end,

	
	
	Paint = function( self, w, h )
		--draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 0, 0, 200 ) )
	end,

	
	Think = function( self, w, h )

		//self.Name:SetText( GetHostName() )
		//self.Name:SetText( "Red Team" )

		--
		-- Loop through each player, and if one doesn't have a score entry - create it.
		--
		local plyrs = player.GetAll()
		for id, pl in pairs( plyrs ) do

			if pl:Team() == TEAM_RED then
				if ( IsValid( pl.ScoreEntry ) ) then continue end

				pl.ScoreEntry = vgui.CreateFromTable( PLAYER_LINE, pl.ScoreEntry )
				pl.ScoreEntry.TeamNum = pl:Team()
				pl.ScoreEntry:Setup( pl )

				self.Scores:AddItem( pl.ScoreEntry )
			end

		end		

	end,
}

SCORE_BOARD_RED = vgui.RegisterTable( SCORE_BOARD_RED, "EditablePanel" );





local SCORE_BOARD_BLUE = 
{
	Init = function( self )
		self.Scores = self:Add( "DScrollPanel" )
		self.Scores:Dock( FILL )
	end,

	
	PerformLayout = function( self )
		self:SetSize( 300, ScrH() - 200 )
		self:SetPos( ScrW()/2 + 50, 100 )
	end,

	
	
	Paint = function( self, w, h )
		--draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 0, 0, 200 ) )
	end,

	
	Think = function( self, w, h )
		local plyrs = player.GetAll()
		for id, pl in pairs( plyrs ) do
		
			if pl:Team() == TEAM_BLUE then
				if ( IsValid( pl.ScoreEntry ) ) then continue end
				
				pl.ScoreEntry = vgui.CreateFromTable( PLAYER_LINE, pl.ScoreEntry )
				pl.ScoreEntry.TeamNum = pl:Team()
				pl.ScoreEntry:Setup( pl )

				self.Scores:AddItem( pl.ScoreEntry )
			end
		end		
		
		
	end,
}

SCORE_BOARD_BLUE = vgui.RegisterTable( SCORE_BOARD_BLUE, "EditablePanel" );








--
function GM:ScoreboardShow()
	if ( !IsValid( r_Scoreboard ) ) then
		r_Scoreboard = vgui.CreateFromTable( SCORE_BOARD_RED )
		b_Scoreboard = vgui.CreateFromTable( SCORE_BOARD_BLUE )
	end

	if ( IsValid( r_Scoreboard ) ) then
		r_Scoreboard:Show()
		b_Scoreboard:Show()
		//g_Scoreboard:RequestFocus()
		//g_Scoreboard:MakePopup()
	end
end


function GM:ScoreboardHide()
	if ( IsValid( r_Scoreboard ) ) then
		r_Scoreboard:Hide()
		b_Scoreboard:Hide()
	end
end

--