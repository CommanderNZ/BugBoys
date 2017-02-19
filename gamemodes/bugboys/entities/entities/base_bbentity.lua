AddCSLuaFile( "base_bbentity.lua" )

DEFINE_BASECLASS( "base_anim" )

ENT.PrintName		= ""
ENT.Author			= ""
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""

ENT.Spawnable			= false
ENT.AdminSpawnable		= false




function ENT:GetRef( ver )
	return EntReference( self:GetClass(), self.Version )
end



function ENT:SpecialInit()
	--creates reference table which refers to a table of all this ents attributes
	self.Ref = self:GetRef()
	
	
	self.DamageMarkTimer = 0

	if self.Ref.teamless != true then
		--this is redundant and probably bad, so ive gotten rid of it
		//self.BBTeam = self.Creator:Team()
	elseif self.Ref.teamless == true then
		self.BBTeam = nil
	end
	

	if SERVER then
		self:SetEntTeamForClient(  )
	end
	
	--set their health if its 0
	if self:Health() == 0 then
		if self.Ref.health != nil then
			self:SetHealth(self.Ref.health)
			self:SetMaxHealth(self.Ref.health)
		end
	end
	
	--set their health from before if the ent is being redeployed
	if self.OverrideHealth != nil then
		self:SetHealth( self.OverrideHealth )
	end
	
	self.OrigMat = self:GetMaterial()
	
	
	
	--sets a matte material if the structure doesnt have a texture for its model
	if self.Ref.has_texture != true then
		self:SetMaterial("bugboys/box")
		//self:SetMaterial("bugboys/machine_vehicle")
	end
	
	
	if self.Ref.special_texture != nil then
		self:SetMaterial( self.Ref.special_texture )
	end
	
	--set their color ( based on how much health they have )
	self:InitializeColor()
end




function ENT:InitializeColor()
	--print("adding color")

	if self.BBTeam != nil then
		if self.BBTeam== TEAM_BLUE then
			--print("setting color blue")
			//self.BaseColor = Color( 54, 224, 254, 255 )
			if self.Ref.is_projectile then
				self.BaseColor = Color( 64, 220, 232, 255 )
			else
				self.BaseColor = Color( 185, 244, 255, 255 )
				//self.BaseColor = Color( 64, 220, 232, 255 )
			end
			
		elseif self.BBTeam == TEAM_RED then
			--print("setting color red")
			//self.BaseColor = Color( 255, 118, 118, 255 )
			if self.Ref.is_projectile then
				self.BaseColor = Color( 248, 92, 147, 255 )
			else
				self.BaseColor = Color( 255, 150, 150, 255 )
				//self.BaseColor = Color( 255, 187, 187, 255 )
				//self.BaseColor = Color( 248, 92, 147, 255 )
			end
		end
	else
		self.BaseColor = Color( 255, 255, 255, 255 )
	end
	
	
	--we dont need to tint the model if it already has colors on the texture
	if self.Ref.skin_red != nil or self.Ref.skin_blue != nil  then
		self.BaseColor = Color( 255, 255, 255, 255 )
		
		--set what skin to show depending on the structure's team, this will give it its color
		if self.BBTeam== TEAM_BLUE then
			self:SetSkin( self.Ref.skin_blue )
		elseif self.BBTeam == TEAM_RED then
			self:SetSkin( self.Ref.skin_red )
		end
	end
	
	--print( self.BaseColor )
	
	local alpha = 255
	if self.AlphaAmount != nil then
		alpha = self.AlphaAmount
	end
	
	--also update the color based on how much health it has currently here
	local ref = self:GetRef()
	
	if ref.takes_damage == true and ref.damage_color_override != true then
		local health = self:Health() 
		local basehealth = ref.health
		
		local colordeci = (health/basehealth)
		local color = Color( self.BaseColor.r * colordeci, self.BaseColor.g * colordeci, self.BaseColor.b * colordeci, alpha )
		self:SetColor( color ) 
	else
		local color = Color( self.BaseColor.r, self.BaseColor.g, self.BaseColor.b, alpha )
		self:SetColor( self.BaseColor ) 
	end
end




//Handle damage
function ENT:OnTakeDamage( damageinfo )
	local amount = damageinfo:GetDamage()
	local health = self:Health() 
	local ref = self:GetRef()
	
	//print("takung damage:" .. amount)
	
	local healing = false
	
	--if the amount is negative, then we're being healed right now
	if amount < 0 then
		healing = true
	end

	
	
	--tell the players on this structure's team that their structures are under attack
	--[[
	if healing != true and self:GetPhysicsObject():IsMotionEnabled() != true then
		local markerent = "ent_damagemarker_red"
		if self.BBTeam == TEAM_BLUE then
			markerent = "ent_damagemarker_blue"
		end
		
		local function CheckPlayersNear()
			local orgin_ents = ents.FindInSphere( self:GetPos(), 3000 )
			for k, ent in pairs( orgin_ents ) do
				if ent:IsValidPlyBug() and ent.BBTeam == self.BBTeam then
					return true
				end
			end
			return false
		end
		
		local function CheckDamageNearby()
			local orgin_ents = ents.FindInSphere( self:GetPos(), 3000 )
			for k, ent in pairs( orgin_ents ) do
				if ent:GetClass() == markerent then
					return true
				end
			end
			return false
		end
	
		local marker = ents.Create( markerent )
			marker:SetPos( self:GetPos() )
			marker:Spawn()
			
		self.DamageMarkerEnt = marker
		
		--play a sound to tell the team if no one is nearby and this hasnt happened recently
		if CheckPlayersNear() != true and CheckDamageNearby() != true then
		//if CheckDamageNearby() != true then
			PlayGlobalSound( "Sound_TeamScoreWarning", self.BBTeam )
			for k,ply in pairs(player.GetAll()) do		
				if ply:Team() == self.BBTeam then
					ply:BBChatPrint( "Our base is under attack!" )
				end
			end
		end
	end
	]]--
	
	
	
	//if this kind of ent doesnt ever take damage, do not take damage
	if ref.takes_damage != true then return end		
		
	//if the ent has damage turned off at this moment for some reason, do not take damage
	if self.CurTakeDamage == false then return end
	
	--cannot take damage while being held by a bug
	if self:GetIfBeingGrabbed() == true then return end
	
	
	local newhealth = nil
	
	//if healing, then make sure health doesnt go over max amount, then change the health
	if healing == true then
		if (health - amount) >= ref.health then
			newhealth = ref.health
			self:SetHealth( newhealth )
		else
			newhealth = health - amount
			self:SetHealth(newhealth)
		end
	elseif healing == false then
		newhealth = health - amount
		self:SetHealth(newhealth)
	end
	
	--do different things depending on if it lost health or gained health
	if newhealth < health then
		if ref.do_not_flash != true then
			self:FlashWhite(.1)
		end
		
		//local thing = 1-(newhealth/ref.health)
		//self:EmitSound( "physics/metal/metal_box_break1.wav", 100, 25 + (thing*120), 1, CHAN_AUTO ) 
		self:EmitSound( "physics/metal/metal_box_break1.wav", 100, 100, 1, CHAN_AUTO ) 
		
		//self.Entity:EmitSound("physics/glass/glass_impact_bullet1.wav")
	elseif newhealth > health then
		self:EmitSound("buttons/button19.wav")
	end
	
	
	local alpha = 255
	if self.AlphaAmount != nil then
		alpha = self.AlphaAmount
	end
	
	//makes it blacker depending on how damaged it is
	if ref.damage_color_override != true then
		local basehealth = ref.health
		local colordeci = (newhealth/basehealth)
		if colordeci < .2 then
			colordeci = .2
		end
		
		local color = Color( self.BaseColor.r * colordeci, self.BaseColor.g * colordeci, self.BaseColor.b * colordeci, alpha )
		self:SetColor( color ) 
	end
	
	//if its below or at 0 health it must die
	if self:Health() <= 0 then
		self:Break()
	end
	
end


//Explodes machine and shows breaking effects
function ENT:Break()
	self:EmitSound("npc/scanner/scanner_explode_crash2.wav")
	//self:EmitSound("physics/metal/metal_box_break1.wav")
	//ParticleEffect("ExplosionCore_MidAir",self:GetPos(),Angle(0,0,0),nil)

	self:Remove()
	//self.Entity:EmitSound("physics/glass/glass_largesheet_break1.wav")
end


function ENT:FlashWhite(time)
	//self:SetMaterial("models/debug/debugwhite")
	//self:SetColor( Color( 0, 255, 0, 255 ) ) 
	
	timer.Simple( time, function()
		if self != NULL then 
		//self:SetMaterial(self.OrigMat)
		--[[
		local healthinfo = self:Health()
		local ref = self:GetRef()
		local basehealth = ref.health
		local colordeci = (healthinfo/basehealth)
		local color = Color( self.BaseColor.r * colordeci, self.BaseColor.g * colordeci, self.BaseColor.b * colordeci, alpha )
			self:SetColor( color )
			]]--
		end
	end)
	
end


--changes the ents model, initilizing physics stuff as well
--		model: the model you want it to change to
--		collision: the kind of collision you want it to have
function ENT:ChangeStaticModel( model, collision )
	//self:InitializeColor()
	
	self:SetModel( model )
	self:SetCollisionGroup( collision )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	local phys = self:GetPhysicsObject()
		phys:EnableMotion(false)	
		
	--so other ents can tell this ent is static
	self.IsStatic = true
		
	--if self.HitPostion != nil then
		--self:SetPos( self.HitPostion )
	--end
end



--changes the ents model, initilizing physics stuff as well
--		model: the model you want it to change to
--		collision: the kind of collision you want it to have
function ENT:ChangePhysicsModel( model, collision, mass )
	//self:InitializeColor()
	
	self:SetModel( model )
	self:SetCollisionGroup( collision )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS  )
	self:SetSolid( SOLID_VPHYSICS )
	local phys = self:GetPhysicsObject()
		phys:Wake()
	
	if phys:IsValid() then
		phys:SetMass( mass )
		phys:EnableMotion(true)	
	end
end

function ENT:Color_Update()
	local ref = self:GetRef()
	if ref.damage_color_override != true then
		local basehealth = ref.health
		local colordeci = (self:Health()/basehealth)
		local color = Color( self.BaseColor.r * colordeci, self.BaseColor.g * colordeci, self.BaseColor.b * colordeci, self.AlphaAmount )
		self:SetColor( color ) 
	end
end

--make the ent some level of transparency
function ENT:Transparency_Set( num )
	if num < 255 then
		self:SetRenderMode( RENDERMODE_TRANSALPHA )
	else
		self:SetRenderMode( RENDERMODE_NORMAL )	
	end
	
	self.AlphaAmount = num
	
	//update colors
	self:Color_Update()
end

--make the ent either collide with other props, or only the world
function ENT:SetPropCollide( bool )
	if bool == true then
		self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	else
		self:SetCollisionGroup( COLLISION_GROUP_WORLD )
	end
end




//Explodes machine and shows breaking effects
function ENT:OnRemove()
	if self.LoopingSound_A != nil then
		self.LoopingSound_A:Stop()
	end
	
	if self.LoopingSound_B != nil then
		self.LoopingSound_B:Stop()
	end
	
	//if IsValid( self.DamageMarkerEnt ) then
		//self.DamageMarkerEnt:Remove()
	//end
end




--this switches the ents team, for stuff like airblasting back projectile
function ENT:SwitchAllegiance()
	if self.BBTeam == nil then return end
	if self.Ref.cant_switch_allegiance == true then return end
	
	self.BBTeam = GetOppositeTeam( self.BBTeam )
	self:InitializeColor()
	
	self:EmitSound( SOUND_ALLEGIANCE_CHANGE )
end



--respawns the ent in its current position, sets it to be on the opposite team
function ENT:RespawnWithOppTeam()
	if self.BBTeam == nil then return end
	if self.Ref.cant_switch_allegiance == true then return end
	
	newteam = GetOppositeTeam( self.BBTeam )
	
	self:EmitSound( SOUND_ALLEGIANCE_CHANGE )
	
	local newent = ents.Create( self:GetClass() )
		newent:SetPos( self:GetPos() )
		newent:SetAngles( self:GetAngles() )
		newent:SetHealth( self:Health() )
		
		newent.Creator = self.Creator
		newent.BBTeam = newteam
		
		self:Remove()
		newent:Spawn()
	return newent
end



--keep these empty, use in derived entities
function ENT:OnGrab( ply )
end

function ENT:OnUnGrab()
end




--creates a little puff of smoke at the position
function ENT:Puff( pos, timelast, colorstring, startsize_set, endsize_set )
	local time = timelast
	if time == nil then
		time = .3
	end

	local color = colorstring
	if color == nil then
		color = "176 255 216"
	end
	
	local startsize = startsize_set
	if startsize == nil then
		startsize = 15
	end
	
	local endsize = endsize_set
	if endsize == nil then
		endsize = 3000
	end
	
	
	local glow = ents.Create( "env_smoketrail" )
		glow:SetPos( pos )
		glow:SetOwner( self.Owner )
		glow:SetParent( self )
		glow:Spawn()
		glow:SetKeyValue( "startcolor", color )
		glow:SetKeyValue( "endcolor", color )
		glow:SetKeyValue( "startsize", startsize )
		glow:SetKeyValue( "endsize", endsize )
		glow:SetKeyValue( "lifetime", 1 )
		glow:SetKeyValue( "opacity", 1 )
		
	timer.Simple( time, function()
		if not IsValid(glow) then return end
		glow:Remove()
	end)
		
end



--for use by vehicles, makes the vehicles pos table forget the box that was attached
function ENT:DetachBox( puckowner )
	for _, pos in pairs( self.PosTable ) do
		if pos.puckat == puckowner then
			local ent = pos.puckat
			if IsValid( ent ) then
				pos.boxat = nil
			end
		
			pos.boxat = nil
			return
		end
	end
end