AddCSLuaFile( "swep_smallman.lua" )

SWEP.Base = "base_bbswep"


function SWEP:Initialize()
	self:SpecialInit()

	self.Ref = self:GetRef()
	
	self:SetClip1( self.Ref.primary_clip )
	self:SetClip2( self.Ref.secondary_clip )
	//self:SetClip3( self.Ref.thirdary_clip )
end

--old mode of reloading the entire clip
--[[
function SWEP:ReloadClip( x )
	local time = 1
	local max_ammo = 1
	local reloadsound = nil

	if x == "primary" then
		time = self.Ref.primary_reload 
		max_ammo = self.Ref.primary_charges 
		reloadsound = self.Ref.sound_reload
	elseif x == "secondary" then
		time = self.Ref.secondary_reload 
		max_ammo = self.Ref.secondary_charges 
		reloadsound = self.Ref.sound_reload2
	elseif x == "reloadary" then
		time = self.Ref.reloadary_reload 
		max_ammo = self.Ref.reloadary_charges 
		reloadsound = self.Ref.sound_reload2
	end

	timer.Simple( (time - .5), function()
		if not IsValid(self) then return end
		self.Owner:EmitSound( reloadsound )
	end)
	
	timer.Simple( time, function()
		if not IsValid(self) then return end
		
		if x == "primary" then
			self:SetClip1( max_ammo )
		elseif x == "secondary" then
			self:SetClip2( max_ammo )
		elseif x == "reloadary" then
			//self:SetClip3( max_ammo )
		end
	end)
end
]]--



function SWEP:ChargeLoop( x )
	local reload_time = 1
	local reload_sound = nil

	if x == "primary" then
		self.ReloadingPrimary = true
		reload_time = self.Ref.primary_reload
		reload_sound = self.Ref.primary_sound_reload
	elseif x == "secondary" then
		self.ReloadingSecondary = true
		reload_time = self.Ref.secondary_reload
		reload_sound = self.Ref.secondary_sound_reload
	elseif x == "thirdary" then
		self.ReloadingThirdary = true
		reload_time = self.ThirdaryReloadTime
		reload_sound = nil
	end
	
	--play a reloading sound just before a thing is added to the clip
	if reload_sound != nil then
		timer.Simple( (reload_time - .5), function()
			if not IsValid(self) then return end
			self.Owner:EmitSound( reload_sound )
		end)
	end
	
	--add one to the clip when the timer runs
	timer.Simple( reload_time, function()
		if not IsValid(self) then return end
		
		if x == "primary" then
			if self:Clip1() < self.Ref.primary_clip then
				self:SetClip1( self:Clip1() + 1 )
			end
			
			if self:Clip1() < self.Ref.primary_clip then
				self:ChargeLoop( "primary" )
			else
				self.ReloadingPrimary = false
			end
		elseif x == "secondary" then
			self:SetClip2( self:Clip2() + 1 )
			if self:Clip2() < self.Ref.secondary_clip then
				self:ChargeLoop( "secondary" )
			else
				self.ReloadingSecondary = false
			end
		elseif x == "thirdary" and self.Owner:GetSwepAbility() != nil then
			local plyabil = self.Owner:GetSwepAbility()
			if plyabil != nil then
				local plyabil_ref = SwepabilityReference( plyabil )
				
				if self:Clip3() < plyabil_ref.clip then
					self:SetClip3( self:Clip3() + 1 )
				end
			
				if self:Clip3() < plyabil_ref.clip then
					self:ChargeLoop( "thirdary" )
				else
					self.ReloadingThirdary = false
				end
			end
		end
	end)
end



function SWEP:PrimaryAttack()
	if (!SERVER) then return end

	if ( !self:CanPrimaryAttack() ) then return end
	if self.Disabled == true then return end
	if self.Owner.Puck.ShootingEnabled == false then return end

	self:TakePrimaryAmmo(1)
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Ref.primary_delay )
	
	self:DoFunc( self.Ref.primary_func )
	--[[
	if IsValid(self.Owner:GetPuck()) then
		self.Owner:GetPuck():OnPrimaryFire()
	end
	]]--
	
	
	if (!SERVER) then return end

		--check if its charge mode, or reload mode, then reload the gun in the proper way
		--if we have no more ammo, reload the swep
		//if self:Clip1() <= 0 then
			//self:ReloadClip( "primary" )
		//end
		
		if self.ReloadingPrimary != true then
			self:ChargeLoop( "primary" )
		end
end



function SWEP:SecondaryAttack()
	if (!SERVER) then return end

	if ( !self:CanSecondaryAttack() ) then return end
	if self.Disabled == true then return end

	self:TakeSecondaryAmmo(1)
	self.Weapon:SetNextSecondaryFire( CurTime() + self.Ref.secondary_delay )
	
	--Trigger what it does when this button is pressed
	self:DoFunc( self.Ref.secondary_func )
	
	
	if (!SERVER) then return end
	
		if self.ReloadingSecondary != true then
			self:ChargeLoop( "secondary" )
		end
end



--add thing that triggers on pressing R
function SWEP:Reload()
	if not (self.Owner:KeyDown(IN_RELOAD)) then return end
	//if (!SERVER) then return end
	if ( !self:CanThirdaryAttack() ) then return end
	if self.Disabled == true then return end
	
	local plyabil = self.Owner:GetSwepAbility()
	if plyabil == 0 then return end
		
	local plyabil_ref = SwepabilityReference( plyabil )

	self.ThirdaryReloadTime = plyabil_ref.reload
	self.Weapon:SetNextThirdaryFire( CurTime() + plyabil_ref.delay )
	
	self:DoFunc( plyabil_ref.func )
	
	
	--
	if (!SERVER) then return end
		if plyabil_ref.dont_reload != true then
			self:TakeThirdaryAmmo( 1 )
		
			if self.ReloadingThirdary != true then
				self:ChargeLoop( "thirdary" )
			end
		end
	--
end


