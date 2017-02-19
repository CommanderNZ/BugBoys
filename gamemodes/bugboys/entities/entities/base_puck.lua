AddCSLuaFile( "base_puck.lua" )

DEFINE_BASECLASS( "base_anim" )

ENT.PrintName		= ""
ENT.Author			= ""
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""

ENT.Spawnable			= false
ENT.AdminSpawnable		= false



function ENT:SpecialInit()
	--set the reference table of the various attributes this ent has
	self.Ref = self:GetRef()

	if !SERVER then return end
	self.BBTeam = self.Owner:Team()
	self:SetEntTeamForClient()
	
	--set team color

	if self.Owner:Team() == TEAM_RED then
		//self:SetColor(Color(255, 0, 0, 255))
		self:SetSkin(0)
	else 
		self:SetSkin(1)
		//self:SetColor(Color(0, 0, 255, 255))
	end

	
	--set their health
	self:SetHealth(self.Ref.health)
	self:SetMaxHealth(self.Ref.health)
	
	--set their color ( based on how much health they have )
	self:InitializeColor()
	
	
	
	
	--rope vars
	self.RopeTimer = 0
	self.RopedEntList = {}
	
	--craft vars
	self.CraftTimer = 0
	
	--magnet vars
	self.MagnetTimer = 0
	self.MagnetAttached = false
	
	--grab vars
	self.GrabTimer = 0
	self.GrabStep = 1
	self.GrabbedEntList = {}
	self.Grabbing = false
	
	--trigger vars
	self.TriggerTimer = 0
	
	--healhurt vars
	self.HealHurtTimer = 0
end


function ENT:InitializeColor()
	//print("adding color")

	--[[
	if self.Owner:Team() == TEAM_BLUE then
		//print("setting color blue")
		self.BaseColor = Color( 54, 224, 254, 255 )
	elseif self.Owner:Team() == TEAM_RED then
		//print("setting color red")
		self.BaseColor = Color( 255, 118, 118, 255 )
	end
	]]--
	self.BaseColor = Color( 255, 255, 255, 255 )
	//print( self.BaseColor )
	
	local alpha = 255
	if self.AlphaAmount != nil then
		alpha = self.AlphaAmount
	end
	
	--also update the color based on how much health it has currently here
	local ref = self:GetRef()
	
	if ref.damage_color_override != true then
		local health = self:Health() 
		local basehealth = ref.health
		//if ref.health_building != nil then
			//basehealth = ref.health_building
		//end
		
		local colordeci = (health/basehealth)
		if colordeci < .2 then
			colordeci = .2
		end
		
		local color = Color( self.BaseColor.r * colordeci, self.BaseColor.g * colordeci, self.BaseColor.b * colordeci, alpha )
		self.MyColor = color
		self:SetColor( color ) 
	else
		local color = Color( self.BaseColor.r, self.BaseColor.g, self.BaseColor.b, alpha )
		self.MyColor = color
		self:SetColor( self.BaseColor ) 
	end
end



function ENT:GetRef()		--returns the ent from the main table of stats for easy reference
	local ref = nil
	for _, obj in pairs( PUCK_TABLE ) do
		if obj.name == self:GetClass() then
			ref = obj
		end
	end
	return ref
end




//Handle damage
function ENT:OnTakeDamage( damageinfo )
	local amount = damageinfo:GetDamage()
	local health = self:Health() 
	local ref = self:GetRef()
	
	local healing = false
	
	--if the amount is negative, then we're being healed right now
	if amount < 0 then
		healing = true
	end
	
	--set the latest person who hurt us, so they can get credit for the kill
	local attacker = damageinfo:GetAttacker()
	local inflictor = damageinfo:GetInflictor()
	if healing != true then
		self.LatestInflictor = inflictor
		self.LatestAttacker = attacker
	end
	
	//if this kind of ent doesnt ever take damage, do not take damage
	//if ref.takes_damage != true then return end		
		
	//if the ent has damage turned off at this moment for some reason, do not take damage
	if self.CurTakeDamage == false then return end
	
	
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
		
		if self.Recalling == true then 
			self:RecallCancel()
		end
	end
	
	--do different things depending on if it lost health or gained health
	if newhealth < health then
		if ref.do_not_flash != true then
			self:FlashWhite(.05)
		end
		
		
		local thing = 1-(newhealth/ref.health)
		self.Entity:EmitSound( SOUND_BUG_HURT, 100, 50 + (thing*150), 1, CHAN_AUTO ) 
		//self.Entity:EmitSound( SOUND_BUG_HURT )
	elseif newhealth > health then
		self.Entity:EmitSound("buttons/button19.wav")
	end
	
	//makes it greener depending on how damaged it is
	//local basehealth = ref.health
	//local colornum = ((255/basehealth)*newhealth)
	//local color = Color( colornum, 255, colornum, 255 )
	//self:SetColor( color ) 
	
	local alpha = 255
	if self.AlphaAmount != nil then
		alpha = self.AlphaAmount
	end
	
	//makes it blacker depending on how damaged it is
	if ref.damage_color_override != true then
		//local basehealth = ref.health
		local basehealth = self:GetMaxHealth()
		local colordeci = (newhealth/basehealth)
		if colordeci < .3 then
			colordeci = .3
		end
		
		local color = Color( self.BaseColor.r * colordeci, self.BaseColor.g * colordeci, self.BaseColor.b * colordeci, alpha )
		self.MyColor = color
		self:SetColor( color ) 
	end
	
	//if its below or at 0 health it must die
	if self:Health() <= 0 then
		self:Break()
	end
	
end



function ENT:FlashWhite(time)
	self:SetMaterial("models/debug/debugwhite")
	
	timer.Simple( time, function()
		if self != NULL then 
		self:SetMaterial(self.OrigMat)
		end
	end)
	
end




-- ENT:Break - Break the puck and spawn chunks --
function ENT:Break()

	--only create the gibs if the player is not in the fountain, so people dont spam die in pregame mode where theres instant spawn
	if not self:IsInFountain() then
		for i = 1, 3 do
			if self.Chunked != true then
				-- There is 3 different chunks
				local Part = "a"
				if (i == 2) then
					Part = "b"
				elseif (i == 3) then
					Part = "c"
				end
				
				-- Create it
				local Chunk = ents.Create("prop_physics")
				//Chunk:SetModel("models/props_junk/watermelon01_chunk01"..Part..".mdl")
				Chunk:SetModel("models/bugboys/gibs_"..Part..".mdl")
				Chunk:SetSkin( self:GetSkin() )
				Chunk:SetPos( self:GetPos() )
				Chunk:SetAngles( self:GetAngles() )
				//Chunk:SetColor( self.MyColor )
				Chunk:Spawn()
				Chunk:Activate()
				
				//Chunk:SetCollisionGroup( COLLISION_GROUP_IN_VEHICLE )
				//Chunk:NoCollideGibs()
				Chunk.IsGib = true
				
				
				//ParticleEffectAttach("flamethrower",PATTACH_ABSORIGIN_FOLLOW,Chunk,0)
				//ParticleEffectAttach("rockettrail",PATTACH_ABSORIGIN_FOLLOW,Chunk,0)

				
				local knock_ang = ( Chunk:GetPos() - self:GetPos() ):GetNormal()
					local rot = Angle(0, 0, 0)
					knock_ang:Rotate( rot )
			
				
				-- Make them fly forwards
				//Chunk:GetPhysicsObject():ApplyForceCenter(self.Entity:GetVelocity() * 3)
				Chunk:GetPhysicsObject():SetVelocity(self.Entity:GetVelocity() * 1)
				//Chunk:GetPhysicsObject():ApplyForceCenter(Vector(0,0,300))
				Chunk:GetPhysicsObject():ApplyForceOffset(Vector( 0, 0, 100 ),Vector(0,0,0) )
				//Chunk:GetPhysicsObject():SetVelocity( knock_ang * 10000)
				
				-- Remove after 10 - 15 seconds
				//timer.Simple(math.Rand(10, 15), function() if (IsValid(Chunk)) then Chunk:Remove() end end)
				timer.Simple(5, function() if (IsValid(Chunk)) then Chunk:Remove() end end)
			end
			
			--this will prvent the chunks fom spawning twice which happens for some reason sometimes
			if i == 3 then
				self.Chunked = true
			end
		end
	end
	

	
	ParticleEffect("blood_impact_red_01",self:GetPos(),Angle(0,0,0),nil)
	ParticleEffect("blood_impact_red_01_chunk",self:GetPos(),Angle(0,0,0),nil)
	ParticleEffect("blood_impact_red_01_droplets",self:GetPos(),Angle(0,0,0),nil)
	ParticleEffect("blood_impact_red_01_goop",self:GetPos(),Angle(0,0,0),nil)
	ParticleEffect("blood_impact_red_01_smalldroplets",self:GetPos(),Angle(0,0,0),nil)
	
	--tf2 effect
	//ParticleEffect("ExplosionCore_MidAir",self:GetPos(),Angle(0,0,0),nil)


	
	
	
	
	
	
	//ParticleEffect("particles/blood_impact",self:GetPos(),Angle(0,0,0),nil)
	
	
	
	--[[
	--this explosion is just visual
	local explosion = ents.Create( "env_explosion" )		--/create an explosion and delete the prop
		explosion:SetPos( self:GetPos() )
		explosion:SetOwner( self.Owner )
		explosion:Spawn()
		explosion:SetKeyValue("spawnflags","117")
		explosion:Fire( "Explode", 0, 0 )
	]]--
	
	
	//local start_pos = self:GetPos()
	//local end_pos = self:GetPos() + (Vector(0, 0, -1) * 200)
	//util.Decal( "Blood", start_pos, end_pos )
	
	
	--play destruction sound
	self.Entity:EmitSound( SOUND_BUG_KILL )
	
	--death scream sound
	self.Entity:EmitSound("physics/flesh/flesh_squishy_impact_hard"..math.random(1, 4)..".wav", 100, 100)
	self.Entity:EmitSound("npc/headcrab_poison/ph_wallpain"..math.random(1, 3)..".wav", 100, 100)
	
	
	--create crystal (the resource of the game), pucks drop these when they die
	--[[
	local crystal = ents.Create("ent_crystal")
		crystal:SetPos( self:GetPos() + Vector(0,0,70) )
		crystal:Spawn()
	]]--
	
	--take away the owner's weapons
	self:RemoveOwnerConnection()
	
	self.Owner.DeathSpot = self:GetPos()
	self.Owner:AddToNextRespawn()

	
	if GetGamePhase() == "BegunGame" then
		--take away a life from the teams pool
		//RemoveLife( self.Owner:Team() )
		
		AddDeathCounter( self.Owner:Team(), 1 )
		
		--give the player who killed me a frag, and announce the death
		//print( self.LatestInflictor )
		//DeathAnnounce( self.Owner, self.LatestInflictor, self.LatestAttacker )
		DeathAnnounce( self.Owner, self.LatestInflictor, self.LatestAttacker )
		
		
		--drop up to 3 tokens on the ground
		--
		local tokenshave = self.Owner:GetTokens()
		local tokensdrop = 1
		if tokenshave >= 3 then
			self.Owner:SubtractTokens( 3 )
			tokensdrop = 3
		elseif tokenshave == 2 then
			self.Owner:SubtractTokens( 2 )
			tokensdrop = 2
		elseif tokenshave == 1 then
			self.Owner:SubtractTokens( 1 )
			tokensdrop = 3
		end
		
		
		if tokenshave >= 1 then
			local newent = ents.Create( "structure_token" )
			newent:SetPos( self:GetPos() + Vector(0,0,12) )
			newent.Creator = self.Creator
			newent.Amount = tokensdrop
			newent:Spawn()
		end
		--
	end

	//DeathAnnounce( self.Owner, self.LatestInflictor, self.LatestAttacker )

	
	-- Remove the puck
	self:Remove()
end


--delete the puck, without taking away a life from the team
function ENT:Delete( teamswitch )
	--take away the owner's weapons
	self:RemoveOwnerConnection()
	
	self.Owner.DeathSpot = self:GetPos()
	if teamswitch != true then
		--instantly respawn
		self.Owner:AddToNextRespawn( "instant" )
	else
		self.Owner:AddToNextRespawn(  )
	end
	
	-- Remove the puck
	self:Remove()
end


function ENT:Delete_NoRespawn()
	print("deleting with no respawn" .. self.Owner:Name())

	--take away the owner's weapons
	self:RemoveOwnerConnection()
	
	-- Remove the puck
	self:Remove()
end



function ENT:RemoveOwnerConnection()
	if not SERVER then return end
	
	--make sure this only runs once on death
	if self.RemovedOwner == true then return end

	--remove stuff from the players visual inventory
	self.Owner:SetHeldEnt( 0 )
	
	--fix the owner, if hes still in the server
	if IsValid( self.Owner ) then
		self.Owner:StripWeapons()
		self.Owner:UnSpectate()
		self.Owner.Puck = nil
		
		self.Owner:Spectate( OBS_MODE_ROAMING )
	end
	self.RemovedOwner = true
end




function ENT:OnRemove( )
	if !SERVER then return end
	self:RemoveOwnerConnection()
	
	if IsValid( self.Owner ) then
		self.Owner:RemoveSwepAbilities()
	end
	
	if self.RecallSound != nil then
		self.RecallSound:Stop()
	end
	
	if self.JetSound != nil then
		self.JetSound:Stop()
	end
	
	if self.CurGrabbedEnt != nil then
	
		--destroy the ent if it needs to be placed on the ground and we arent on the ground
		local entref = EntReference( self.CurGrabbedEnt:GetClass() )
		if entref.angular == true and not self:GetIfOnGround( 40, {self.CurGrabbedEnt} ) then
			self.CurGrabbedEnt:Break()
			return
		end
	
		--structures cant be in the spawn area
		if self:IsInFountain() then
			self.CurGrabbedEnt:Break()
			return
		end
	
		self:UnGrab( true )
	end
end



-- ENT:PhysicsCollide - We hit stuff, do custom damage functions --
function ENT:PhysicsCollide(Data, PhysObj)
	-- Play sound, depending on speed
	//if ((Data.DeltaTime >= 0.8) and (Data.Speed > 100)) or (Data.Speed > 250) then
		//self.Entity:EmitSound("physics/rubber/rubber_tire_impact_hard"..math.random(1, 3)..".wav", 100, 100)
	//end
	
	if ((Data.DeltaTime >= 0.8) and (Data.Speed > 100)) or (Data.Speed > 250) then
		if self.JumpEnabled != false then
			self.Entity:EmitSound("physics/flesh/flesh_squishy_impact_hard"..math.random(1, 4)..".wav", 100, 100)
		end
	end
	
	--push them back towards their side of the map if they touch the dividing brush in the middle of the mep
	--[[
	if Data.HitEntity:GetClass() == "func_brush" then
		print("hit brush")
		local spawnent = nil
		for k,ent in pairs(ents.GetAll()) do	
			if self.BBTeam == TEAM_RED then
				if ent:GetClass() == "info_player_red" then
					spawnent = ent
				end
			else
				if ent:GetClass() == "info_player_blue" then
					spawnent = ent
				end
			end
		end
		
		if spawnent != nil then
			local vec1 = spawnent:GetPos()
			local vec2 = self:GetPos()
			
			local phys = self:GetPhysicsObject()
			//phys:SetVelocity((vec1 - vec2):Angle()*5000)
			phys:SetVelocity((vec1 - vec2)*1000)
			
			self:EmitSound("npc/scanner/scanner_electric2.wav", 100, 100)
		end
	end
	]]--
end





--AKA Zap
function ENT:DoHealHurt()
	if (self.Owner:KeyDown(IN_DUCK)) then
		if (self.HealHurtTimer < CurTime()) then
			--create a beam effect
			local function BeamEffect( startpt, endpt )
				local effectdata = EffectData()
					effectdata:SetOrigin( endpt )
					effectdata:SetStart( startpt )
					effectdata:SetAttachment( 1 )
					effectdata:SetEntity( self )
					util.Effect( "ToolTracer", effectdata )
			end
			
			local function SeeIfHurt( ent, reference )
				--hurt and trigger version
				if ent.BBTeam != self.Owner:Team() and reference.takes_damage == true then
					ent:HurtEnt( 10, self, self.Owner )
					return true
				end
			end	
				
			local function SeeIfTrigger( ent, reference )
				--hurt and trigger version
				if ent.BBTeam == self.Owner:Team() and reference.triggerable == true then
					ent:RayTrigger( self.Owner )
					return true
				end
			end
			
			local Aim = self.Owner:EyeAngles()
			local pos = self:GetPos() + (Aim:Up() * ( self.Ref.cam_height - 1))
			local ang = self.Owner:GetAimVector()
			
			local tracedata = {}
			tracedata.start = pos
			tracedata.endpos = pos+(ang * self.Ref.zap_dist)
			tracedata.filter = self, self.Owner
			local trace = util.TraceLine(tracedata)
			
			local hitent = trace.Entity
			
			--its a structure, hurt it or heal it depending on if its ally or enemy
			if IsValid( hitent ) and CheckIfInEntTable(hitent) and hitent:GetClass() != "ent_intermediary_structure" and hitent:GetClass() != "structure_bugbrain" then
				local ref = EntReference( hitent:GetClass() )
				
				
				if SeeIfHurt( hitent, ref ) then
					self.Owner:EmitSound(SOUND_HEALHURT)
					BeamEffect( self:GetPos(), trace.HitPos )
					self.HealHurtTimer = CurTime() + .5
					return
				end
				
				--[[
				--heal and hurt version
				if ref.takes_damage == true and self.Owner:Team() == hitent.BBTeam then
					hitent:HurtEnt( -3, self, self.Owner )
					BeamEffect( self:GetPos(), trace.HitPos )
				elseif ref.takes_damage == true and GetOppositeTeam( self.Owner:Team() ) == hitent.BBTeam then
					hitent:HurtEnt( 7, self, self.Owner )
					BeamEffect( self:GetPos(), trace.HitPos )
				end
				]]--
			end
			
			
			
			local tracedata = {}
			tracedata.start = pos
			tracedata.endpos = pos+(ang * self.Ref.zap_trigger_dist)
			tracedata.filter = self, self.Owner
			local trace = util.TraceLine(tracedata)
			
			local hitent = trace.Entity
			
			--trigger it
			if IsValid( hitent ) and CheckIfInEntTable(hitent) then
				local ref = EntReference( hitent:GetClass() )
				
				
				if SeeIfTrigger( hitent, ref ) then
					self.Owner:EmitSound(SOUND_HEALHURT)
					BeamEffect( self:GetPos(), trace.HitPos )
					self.HealHurtTimer = CurTime() + .5
					return
				end
			end
			
			--if the zap attempt failed, just make a noise
			self:EmitSound( SOUND_ATTEMPT )
			
			self.HealHurtTimer = CurTime() + .5
		end
	end
end




--[[
--this is called when the player presses 1 its all set up clientside cause 
function ENT:Abil_Trigger()
	if (self.TriggerTimer < CurTime()) then
		local Aim = self.Owner:EyeAngles()
		local pos = self:GetPos() + (Aim:Up() * ( self.Ref.cam_height - 1))
		local ang = self.Owner:GetAimVector()
		
		local tracedata = {}
		tracedata.start = pos
		tracedata.endpos = pos+(ang * 15000)
		tracedata.filter = self, self.Owner
		local trace = util.TraceLine(tracedata)
		
		--needs to hit a valid ent in the first place. not the world
		local hitent = trace.Entity
		if not IsValid( trace.Entity ) then 
			self.TriggerTimer = CurTime() + .5
			return 
		end
		
		
		--its a triggerable structure, trigger it
		if CheckIfInEntTable(hitent) then
			local ref = EntReference( hitent:GetClass() )
			--trigger it if its triggerable
			if ref.triggerable == true and self.Owner:Team() == hitent.BBTeam then
				hitent:RayTrigger( self.Owner )
			end
		end
		
		self.TriggerTimer = CurTime() + .5
	end
end
]]--


function ENT:RecallCancel()
	timer.Remove("RecallTimer_" .. self.Owner:UniqueID())
	self:EnableInput( true )
	self.Owner:GetActiveWeapon( ):Enable()
	if self.RecallSound != nil then
		self.RecallSound:Stop()
	end
	
	if IsValid( self.Glow ) then
		self.Glow:Remove()
	end
end


--this is called when the player presses 2
function ENT:Abil_Recall()
	if self.Recalling == true then return end
	
	self.Recalling = true
	self.RecallSound = CreateSound( self, SOUND_RECALL_LOOP )
	self.RecallSound:Play()
	
	self.Owner:GetActiveWeapon( ):Disable()
	self:EnableInput( false )
	
	local glow = ents.Create( "env_smoketrail" )
		glow:SetPos( self:GetPos() )
		glow:SetOwner( self.Owner )
		glow:SetParent( self )
		glow:Spawn()
		glow:SetKeyValue( "startcolor", "176 255 216" )
		glow:SetKeyValue( "endcolor", "123 185 198" )
		glow:SetKeyValue( "startsize", 15 )
		glow:SetKeyValue( "endsize", 3000 )
		glow:SetKeyValue( "lifetime", 1 )
		glow:SetKeyValue( "opacity", 1 )
		//glow:SetKeyValue("spawnflags","117")
		//glow:SetKeyValue( "MaxDist", 2000 )
		//glow:SetKeyValue( "MaxDist", 10 )
		//glow:SetKeyValue( "VerticalGlowSize", 30 )
		//glow:SetKeyValue( "HorizontalGlowSize", 30 )
	self.Glow = glow
	
	
	timer.Create("RecallTimer_" .. self.Owner:UniqueID(), TIME_RECALL, 1, function()
		if not IsValid(self) then return end
		
		self:EmitSound( SOUND_RECALL_FINISH )
		glow:Remove()
		
		
		
		--old way-----------------------------------
		//self:Delete_NoRespawn()
		//self.Owner:Spawn()
		
		
		
		--new way----------------------------------
		local spawns = ents.FindByClass( "info_player_red" )
		if (self.BBTeam == TEAM_RED) then
			spawns = ents.FindByClass( "info_player_red" )
		elseif (self.BBTeam == TEAM_BLUE) then
			spawns = ents.FindByClass( "info_player_blue" )
		end
		
		local chosen = nil
		for k, ent in pairs( spawns ) do
			if IsValid( ent ) then
				chosen = ent
				break
			end
		end
		
		self:DetachSelfFromVehicle()
		self:SetPos( chosen:GetPos() )
		
		self:EnableInput( true )
		self.Owner:GetActiveWeapon( ):Enable()
		if self.RecallSound != nil then
			self.RecallSound:Stop()
		end
		
		local physobj = self:GetPhysicsObject()
			physobj:Wake()
		
		local vec1 = Vector(0,0,0) -- Where we're looking at
		local vec2 = self.Owner:GetShootPos() -- The player's eye pos
		self.Owner:SetEyeAngles((vec1 - vec2):Angle()) -- Sets to the angle between the two vectors
		
		
		
		
		self.Owner:EmitSound( SOUND_RECALL_APPEAR )
		
		self.Recalling = false
	end)
end


--disables players ability to use any of the pucks abilities
function ENT:EnableInput( x )
	if x == false then
		self.EnabledInput = false
	else
		self.EnabledInput = true
	end
end



function ENT:SetJumpEnabled( x )
	self.JumpEnabled = x
end


function ENT:SetShootingEnabled( x )
	self.ShootingEnabled = x
end


--detaches the puck if its attached to something
function ENT:DetachSelfFromVehicle()
	if self.Vehicle != nil then
		self.Vehicle:DetachPuck( self )
	end
end


--these need to stay empty, if you want to use them recreate them within the puck ent itself
function ENT:OnPrimaryFire()
end

function ENT:OnSecondaryFire()
end

function ENT:OnReloadFire()
end




function ENT:ResetMaxHealth()
	self:SetMaxHealth( self.Ref.health )
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







