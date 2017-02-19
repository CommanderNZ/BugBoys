AddCSLuaFile( "base_bbswep.lua" )
--[[
if CLIENT then
	function SWEP:DrawWorldModel()
		self:DrawModel()
	end
end
]]--


------------------------------------------------------------------------------------------------
--all shared from now on
------------------------------------------------------------------------------------------------

--SWEP.ViewModel			= "models/weapons/v_pistol.mdl"
--SWEP.WorldModel			= "models/weapons/w_pistol.mdl"

SWEP.ViewModel			= ""
SWEP.WorldModel			= ""

SWEP.Primary.ClipSize		= 3
SWEP.Primary.DefaultClip	= 3
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "Pistol"

SWEP.Secondary.ClipSize		= 3
SWEP.Secondary.DefaultClip	= 3
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= "Pistol"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.PrintName			= ""			
SWEP.Slot				= 0
SWEP.SlotPos			= ""
SWEP.DrawAmmo			= true
SWEP.DrawCrosshair		= true

SWEP.DrawWeaponInfoBox	= false	
SWEP.BounceWeaponIcon   = false		


SWEP.EntTable = {}



function SWEP:SpecialInit()
	self.Redeploy_Step = 1
end

function SWEP:ShouldDropOnDie()
	return false
end



function SWEP:GetRef()
	return SwepReference( self:GetClass() )
end



function SWEP:Disable()
	self.Disabled = true
end

function SWEP:Enable()
	self.Disabled = false
end




------------------------------------------------------------------------------------------------
--custom functions for the third ability of the swep, triggered by reload
------------------------------------------------------------------------------------------------

function SWEP:SetClip3( amount )
	self:SetNetworkedInt("Clip3", amount)
end

function SWEP:Clip3()
	return self:GetNetworkedInt("Clip3", 0)
end

function SWEP:TakeThirdaryAmmo( amount )
	local clip3 = self:GetNetworkedInt("Clip3", 0)
	self:SetNetworkedInt("Clip3", (clip3 - amount))
end

function SWEP:CanThirdaryAttack()
	if self:Clip3() > 0 and CurTime() > self:GetNextThirdaryFire() then 
		return true 
	end
end

function SWEP:SetNextThirdaryFire( time )
	self:SetNetworkedInt("NextThirdaryFire", time)
end

function SWEP:GetNextThirdaryFire()
	return self:GetNetworkedInt("NextThirdaryFire", 0)
end



------------------------------------------------------------------------------------------------
--swep possible functions
------------------------------------------------------------------------------------------------




function SWEP:DoFunc( funcname )
	--Smallman Funcs
	if funcname == "func_smallman_shotgun" then
		self:Func_Smallman_Shotgun(  )
	elseif funcname == "func_smallman_dash" then 
		self:Func_Smallman_Dash(  )
	elseif funcname == "func_smallman_airbomb" then 
		self:Func_Smallman_Airbomb(  )
	elseif funcname == "func_smallman_airblast" then 
		self:Func_Smallman_Airblast(  )
	elseif funcname == "func_smallman_slider" then 
		self:Func_Smallman_Slider(  )
	elseif funcname == "func_smallman_detonate" then 
		self:Func_Smallman_Detonate(  )
		
	--Special ability Funcs
	elseif funcname == "func_rope" then
		self:Func_Rope(  )
	elseif funcname == "func_deconstruct" then
		self:Func_Deconstruct(  )
		
		
	end
end





------------------------------------------------------------------------------------------------
--Small man functions
------------------------------------------------------------------------------------------------

function SWEP:Func_Smallman_Slider()
	if !SERVER then return end
	
	--table of vars the function uses, for easy modification
	local Vars =
	{
	projectile = "subitem_slider",
	throwforce = 32000,  --28000
	heightadd = 20, --10
	//sound = Sound("Weapon_Mortar.Single"),
	sound = Sound("npc/headcrab_fast/attack1.wav"),
	added_force = 1200,
	}
	
	self.Owner:EmitSound( Vars.sound )
	
	
	if IsValid( self.Owner.Puck.CurGrabbedEnt ) then
		if self.Owner.Puck.CurGrabbedEnt:GetClass() == "structure_nade" then
			Vars.projectile = "subitem_nade"
		end
	end
	
	local obj = ents.Create( Vars.projectile )
		local pos = self.Owner:GetPuckPos() + Vector(0,0,Vars.heightadd)
			
		obj.BBTeam = self.Owner:Team()
		obj.Creator = self.Owner
		obj.CreatorSwep = self
		

		--if the owner has the gainer item
		//print( self.Owner.Puck.CurGrabbedEnt:GetClass() )
		if IsValid( self.Owner.Puck.CurGrabbedEnt ) then
			if self.Owner.Puck.CurGrabbedEnt:GetClass() == "structure_gainer" then
				obj.Gaining = true
				
			elseif self.Owner.Puck.CurGrabbedEnt:GetClass() == "structure_rocket" then
				obj.Rocket = true
				Vars.throwforce = 50000
				pos = self.Owner:GetPuckPos() + Vector(0,0,40)
			
			elseif self.Owner.Puck.CurGrabbedEnt:GetClass() == "structure_repair" then
				obj.Repair = true
			
			end
		end
		
		
		obj:SetPos( pos )
		obj:SetOwner(self.Owner)
		obj:SetAngles( self.Owner:EyeAngles() )
		obj:Spawn()
		
		--nocollide the projectile with airships if the puck is on an airship
		local possible_parent = self.Owner.Puck:GetParent()
		if IsValid( possible_parent ) and possible_parent:GetClass() == "structure_blimp" then
			obj:NoCollideEnt( possible_parent )
		end
		
		
		--add the object to the ent table, so the swep remembers it to activate its ability
		obj.CreatorTool = self
		table.insert( self.EntTable, obj )
		
		
		
		obj:NoCollideTeam()
		obj:NoCollideSlider()
	
	local Aim = self.Owner:GetAimVector():GetNormalized() 
	--[[
	local Aim_trunc = Vector(Aim.x, Aim.y, Aim.z)
	if Aim_trunc.z > 0 then
		Aim_trunc = Vector(Aim.x, Aim.y, 0)
	end
	]]--
	//local Aim_trunc = Vector(Aim.x, Aim.y, 0)
	
	
	local phys = obj:GetPhysicsObject()
		
	
		
		
	if Aim.z < 0 then
		local Aim_trunc = Vector(Aim.x, Aim.y, 0)
		Aim_trunc = Aim_trunc:GetNormal()
		
		phys:ApplyForceCenter (Aim_trunc *  Vars.throwforce)
	
		timer.Simple( .01, function()
		if not IsValid( obj ) then return end --if this isnt here, the game crashes if its not valid
		if obj.AirBlasted == true then return end --dont add this force if the player already airblasted it	
			phys:SetVelocity(Aim *  Vars.added_force )
		end)
		
		
	else
		local Aim_trunc = Vector(Aim.x, Aim.y, Aim.z)
		Aim_trunc = Aim_trunc:GetNormal()
		
		phys:ApplyForceCenter (Aim_trunc *  Vars.throwforce)
		//phys:ApplyForceCenter (Vector(0, 0, 4000))
	end

end



function SWEP:Func_Smallman_Airblast()
	if !SERVER then return end
	
	--table of vars the function uses, for easy modification
	local Vars =
	{
	force_projectile = 2200,  --1700
	force = 1700, --1700
	force_enemybug = 1700, --1700
	radius = 120, --100
	sound = Sound("physics/metal/metal_barrel_impact_hard5.wav"),
	}
	
	//self.Owner:BBChatPrint( "airBLAST" )
	self.Owner:EmitSound( Vars.sound )
	
	
	local puck = self.Owner.Puck
	--[[
	if puck.CurGrabbedEnt != nil then
		local ungrabbedent = puck.CurGrabbedEnt
		
		puck:UnGrab( true )
	
		local phys = ungrabbedent:GetPhysicsObject()
			if ungrabbedent:IsProjectile() then
				phys:SetVelocity(self.Owner:GetAimVector():GetNormalized() *  Vars.force_projectile )
			else
				phys:SetVelocity(self.Owner:GetAimVector():GetNormalized() *  Vars.force )
			end
		return
	end
	]]--
	
	local selfvector = self.Owner.Puck:GetPos() + (self.Owner:GetAimVector() * Vars.radius)
	local orgin_ents = ents.FindInSphere( selfvector, Vars.radius );
	local aim = self.Owner:GetForward()
	
	for k, ent in pairs( orgin_ents ) do
		--blast back physics ent
		if ent:GetPhysicsObject( ):IsValid() and ent:IsValidPuck() != true and ent:IsValidVehicle() != true and ent:GetIfBeingGrabbed() != true then
			local blastit = true
			
			if ent:GetClass() == "structure_boat" or ent:GetClass() == "structure_blimp" then
				blastit = false
			end	
				
			if blastit == true then
				local phys = ent:GetPhysicsObject()
					
				if ent:IsProjectile() then
					ent.AirBlasted = true
					phys:SetVelocity(self.Owner:GetAimVector():GetNormalized() *  Vars.force_projectile )
				else
					phys:SetVelocity(self.Owner:GetAimVector():GetNormalized() *  Vars.force )
				end
				
				--if the ent is from the opposite team, and its a projectile, switch it to our team
				if ent.BBTeam == GetOppositeTeam( self.Owner:Team() ) and ent:IsProjectile() then
					local newent = ent:RespawnWithOppTeam()
					if IsValid( newent ) then
						local newphys = newent:GetPhysicsObject()
						newphys:SetVelocity(self.Owner:GetAimVector():GetNormalized() *  Vars.force_projectile )
					end
				end
			end
			
		--you can airblast enemy bugs
		elseif ent:IsValidPuck() and ent.BBTeam == GetOppositeTeam( self.Owner:Team() ) and ent:GetClass() != "structure_scout" then
			
			local phys = ent:GetPhysicsObject()
				phys:SetVelocity(self.Owner:GetAimVector():GetNormalized() *  Vars.force_enemybug )
		
		
		end
		
		
		
	end
end




--[[
function SWEP:Func_Rope()
	if !SERVER then return end
	
	
	local function RopeTo( ent, hitpos, physbone )
		--Rope setup code--
		local forcelimit = 0;
		local addlength     = 0;
		local material      = "cable/cable2"
		local width      = 3;
		local rigid         = false;
		
		if ent:IsWorld() then
			ent = game.GetWorld()
		end
		
		local Ent1 = self.Owner.Puck
		local Ent2 = ent
		local Bone1, Bone2 = 0, physbone
		local WPos1, WPos2 = self.Owner.Puck:GetPos(), hitpos
		local LPos1, LPos2 = self:WorldToLocal(WPos1), ent:WorldToLocal(WPos2)
		local length = (WPos2 - WPos1):Length()
		
		local constraint, rope = constraint.Rope( Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, length, addlength, forcelimit, width, material, rigid )	
		
		self:EmitSound( SOUND_ROPE_MAKE )
	end
	
	local function RopeEnt( ent, hitpos, physbone )
		if ent != self and ent.BBTeam != GetOppositeTeam( self.Owner:Team() ) then
			print("roping ent")
			RopeTo( ent, hitpos, physbone )
		end
	end	
	
	local function UnropeEnts()
		constraint.RemoveAll( self )
	end	
	
	
	
	self.Owner:EmitSound( Sound("physics/metal/metal_barrel_impact_hard5.wav") )

	local Aim = self.Owner:EyeAngles()
	local pos = self:GetPos() + (Aim:Up() * ( 75 - 1))
	local ang = self.Owner:GetAimVector()
	local tracedata = {}
		tracedata.start = pos
		tracedata.endpos = pos+(ang * 2000)
		tracedata.filter = self, self.Owner, self.Owner.Puck	
	local trace = util.TraceLine(tracedata)
		
	print( trace.Entity )	
	
	--make sure its ok, then rope it
	if trace.Entity:GetClass() != "ent_intermediary_structure" then
		RopeEnt( trace.Entity, trace.HitPos, trace.PhysicsBone )
	end
end
]]--



function SWEP:Func_Deconstruct()
	if !SERVER then return end
	
	local function DeconstructEnt( ent )
		local entpos = ent:GetPos()
		local newent = ents.Create( "structure_token" )
			if IsValid( self.Owner ) then
				newent.Creator = self.Owner
			end
			
		local craftref = TableReference_CraftEnt( ent:GetClass() )
		local amount = craftref.crystals_required - 1
		if amount <= 0 then
			amount = 1
		end
			newent.Amount = amount
			newent:Spawn()
		
		ent:Break()
		
		local tokenpos = ToGround( entpos )
		newent:SetPos( tokenpos + Vector(0,0,12) )
	end
	
	
	local Aim = self.Owner:EyeAngles()
	local pos = self:GetPos() + (Aim:Up() * ( 75 - 1))
	local ang = self.Owner:GetAimVector()
	local tracedata = {}
		tracedata.start = pos
		tracedata.endpos = pos+(ang * 2000)
		tracedata.filter = self, self.Owner, self.Owner.Puck	
	local trace = util.TraceLine(tracedata)
		
	local hitent = trace.Entity
		
	--make sure its ok, then rope it
	if CheckIfInEntTable(hitent)and hitent:GetClass() != "ent_intermediary_structure" and hitent:GetClass() != "structure_token" and hitent:GetClass() != "structure_bugbrain" and hitent:GetClass() != "structure_bugbrain_shield" then
		local creator = hitent.Creator
		if (IsValid(creator) and creator == self.Owner) or not IsValid(creator) then
			if self.Owner:Team() == hitent.BBTeam then
				DeconstructEnt( hitent )
			end
		end
	end
	
	
end



function SWEP:Func_Rope()
	if !SERVER then return end
	
	
	self.Owner:EmitSound( Sound("physics/metal/metal_barrel_impact_hard5.wav") )

	local pos = self.Owner:GetPuckPos() + Vector(0,0,30)
	local obj = ents.Create( "subitem_missile_rope" )
		obj.BBTeam = self.Owner:Team()
		obj.Creator = self.Owner
		obj.CreatorSwep = self
		obj:SetPos( pos )
		obj:SetOwner( self.Owner )
		obj:SetAngles( self.Owner:EyeAngles() )
		obj:Spawn()
		
		
		--add the object to the ent table, so the swep remembers it to activate its ability
		obj.CreatorTool = self
		table.insert( self.EntTable, obj )
		
		
		obj:NoCollideTeam()
	
	local Aim = self.Owner:GetAimVector():GetNormalized() 
	local phys = obj:GetPhysicsObject()
		
		
	if Aim.z < 0 then
		local Aim_trunc = Vector(Aim.x, Aim.y, 0)
		Aim_trunc = Aim_trunc:GetNormal()
		
		phys:ApplyForceCenter (Aim_trunc *  28000)
	
		timer.Simple( .01, function()
		if not IsValid( obj ) then return end --if this isnt here, the game crashes if its not valid
			phys:SetVelocity(Aim *  1200 )
		end)
		
		
	else
		local Aim_trunc = Vector(Aim.x, Aim.y, Aim.z)
		Aim_trunc = Aim_trunc:GetNormal()
		
		phys:ApplyForceCenter (Aim_trunc *  28000)
	end
end



function SWEP:Func_Smallman_Detonate()
	if !SERVER then return end
	
	--table of vars the function uses, for easy modification
	local Vars =
	{
	force = 1000,
	radius = 75,
	sound = Sound("physics/metal/metal_barrel_impact_hard5.wav"),
	}
	
	for k, ent in pairs( self.EntTable ) do
		if IsValid(ent) then
			ent:StartEffect()
		end
	end
end

