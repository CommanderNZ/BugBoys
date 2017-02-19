AddCSLuaFile("structure_bugbrain.lua")

DEFINE_BASECLASS( "base_anim" )

//ENT.Type 			= "anim"
//ENT.Base 			= "base_bbentity"
//ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

if !SERVER then return end
------------------------------------------------------------------------------------------------
--all server from now on
------------------------------------------------------------------------------------------------


function ENT:GetRef( ver )
	return EntReference( self:GetClass() )
end

function ENT:SpecialInit()
	--creates reference table which refers to a table of all this ents attributes
	self.Ref = self:GetRef()

	if SERVER then
		self:SetEntTeamForClient(  )
	end
end

function ENT:Initialize()
	self:SpecialInit()
	
	self:ChangeStaticModel( self.Ref.model, COLLISION_GROUP_WEAPON )
	
	if self.BBTeam == TEAM_RED then
		self:SetSkin(0)
	else
		self:SetSkin(1)
	end
	
	--initialize the brains health
	SetBrainHealth( self.BBTeam, BRAIN_HP )
	self:SetHealth( BRAIN_HP )
	
	
	self.OrigMat = self:GetMaterial()
	
	self.ShieldTimer = 0
	self.ShieldTimerRegen = 0
	
	self.ShieldDamage = 0
	self.ShieldEnt = nil
	self.ShieldIsUp = true
	
	self:ShieldEnable( true )
	
	self.BeepTimer = 0
end


function ENT:ShieldEnable( x )
	if x == true then
		local obj = ents.Create( "structure_bugbrain_shield" )
			obj:SetPos( self:GetPos() )//+ Vector(0,0,400) )
			obj.BBTeam = self.BBTeam
			obj:Spawn()
			
		self.ShieldEnt = obj
		self.ShieldDamage = 0
		self.ShieldIsUp = true
		
		self.ShieldEnt:SetHealth( self.Ref.damage_shield_break - self.ShieldDamage )
		SetShieldHealth( self.BBTeam, self.Ref.damage_shield_break - self.ShieldDamage )
		
		self:EmitSound( self.Ref.sound_shield_form )
		
	elseif x == false then
		if IsValid( self.ShieldEnt ) then
			self.ShieldEnt:Remove()
			
			self.ShieldEnt = nil
			self.ShieldDamage = 0
			self.ShieldIsUp = false
			
			self:EmitSound( self.Ref.sound_shield_break )
		end
	end
end




function ENT:ChangeStaticModel( model, collision )
	//self:InitializeColor()
	
	self:SetModel( model )
	self:SetCollisionGroup( collision )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	local phys = self:GetPhysicsObject()
		phys:EnableMotion(false)	
end



//Handle damage
function ENT:OnTakeDamage( damageinfo )
	local amount = damageinfo:GetDamage()
	
	if self.ShieldIsUp == true then
		--alert the enemy team their brain is under attack, if its the first attack when shield is full HP
		if self.ShieldDamage == 0 then
			PlayGlobalSound( "Sound_TeamScoreWarning", self.BBTeam )
			for k,ply in pairs(player.GetAll()) do		
				if ply:Team() == self.BBTeam then
					ply:BBChatPrint( "Our Bug Brain is under attack!" )
				end
			end
		end
	
		self.ShieldTimerRegen = CurTime() + self.Ref.time_shield_regen
	
		self:EmitSound( self.Ref.sound_shield_damage )
		
		self.ShieldDamage = self.ShieldDamage + amount
		
		self.ShieldEnt:FlashWhite( .1 )
		self.ShieldEnt:SetHealth( self.Ref.damage_shield_break - self.ShieldDamage )
		SetShieldHealth( self.BBTeam, self.Ref.damage_shield_break - self.ShieldDamage )
		
		if self.ShieldDamage >= self.Ref.damage_shield_break then
			self:ShieldEnable( false )
			self.ShieldTimer = CurTime() + self.Ref.time_shield_reform
		end
		return
		
	else
		self:EmitSound("npc/headcrab_poison/ph_pain"..math.random(1, 3)..".wav", 100, 40)
	
		--put more time on the clock making it take longer for the shield to come back
		self.ShieldTimer = CurTime() + self.Ref.time_shield_reform
	
		if GetGamePhase() == "BegunGame" then
			//AddPoints( GetOppositeTeam( self.BBTeam  ), 1 )
			
			--handle damage
			local amount = damageinfo:GetDamage()
			local health = self:Health() 
			
			local healing = false
			--if the amount is negative, then we're being healed right now
			if amount < 0 then
				healing = true
			end
			
			--set the new health
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
				if newhealth <= 0 then
					newhealth = 0
				end
				self:SetHealth(newhealth)
			end
			
			--sets it for the clientside display bar at the top of the screen
			SetBrainHealth( self.BBTeam, newhealth )
			
			--do different things depending on if it lost health or gained health
			if newhealth < health then
				//local thing = 1-(newhealth/ref.health)
				//self:EmitSound( "physics/metal/metal_box_break1.wav", 100, 25 + (thing*120), 1, CHAN_AUTO ) 
				self:EmitSound("npc/headcrab_poison/ph_pain"..math.random(1, 3)..".wav", 100, 40)
				
			elseif newhealth > health then
				self:EmitSound("buttons/button19.wav")
			end
			

			
			PlayGlobalSound( "Sound_TeamScoreAgainst", self.BBTeam )
			PlayGlobalSound( "Sound_TeamScore", GetOppositeTeam( self.BBTeam  ) )
		end
		
		self:FlashWhite( .1 )
		
		
		if self:Health() <= 0 then
			ChooseWinner( GetOppositeTeam( self.BBTeam ) )
			self:Break()
		end
	end
end


function ENT:Break()
	self:EmitSound("npc/headcrab_fast/die2.wav", 100, 80)
	self:EmitSound("ambient/explosions/explode_8.wav", 100, 80)
	//ParticleEffect("ExplosionCore_MidAir",self:GetPos(),Angle(0,0,0),nil)

	self:ShieldEnable( false )
	self:Remove()
end


function ENT:Think()
	if CurTime() > self.ShieldTimer and self.ShieldIsUp == false then
		self:ShieldEnable( true )
	end
	
	--make shield health regen
	if IsValid( self.ShieldEnt ) and CurTime() > self.ShieldTimerRegen and self.ShieldDamage > 0 then 
		self.ShieldDamage = self.ShieldDamage - 3
		if self.ShieldDamage < 0 then
			self.ShieldDamage = 0
		end
		
		self.ShieldEnt:SetHealth( self.Ref.damage_shield_break - self.ShieldDamage )
		SetShieldHealth( self.BBTeam, self.Ref.damage_shield_break - self.ShieldDamage )
		
		self:EmitSound( "buttons/button19.wav" )
	end
	
	
	if CurTime() > self.BeepTimer then
		self:EmitSound( self.Ref.sound_repeat ..math.random(1, 4)..".wav", 70, 130)
		self.BeepTimer = CurTime() + self.Ref.repeat_rate
	end
	
	
	self:NextThink( CurTime() + .5 )
	return true
end



function ENT:FlashWhite(time)
	self:SetMaterial("models/debug/debugwhite")
	
	timer.Simple( time, function()
		if not IsValid(self) then return end
		self:SetMaterial(self.OrigMat)
	end)
end


