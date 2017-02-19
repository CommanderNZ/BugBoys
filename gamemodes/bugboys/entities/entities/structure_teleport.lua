AddCSLuaFile("structure_teleport.lua")

ENT.Type 			= "anim"
ENT.Base 			= "base_bbentity"
//ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

if !SERVER then return end
------------------------------------------------------------------------------------------------
--all server from now on
------------------------------------------------------------------------------------------------
local angle = Angle( 0, 0, 0 )


--this entity doesnt do anything, just spawns the exit and entrance as soon as it spawns
function ENT:Initialize()
	self:SpecialInit()
	
	self:ChangeStaticModel( self.Ref.model, COLLISION_GROUP_WEAPON )
	
	//print("this is my team:  "  ..  self.BBTeam)
	
	--entrance
	local tp_entrance = ents.Create( self.Ref.spawn_ent_a )
		tp_entrance:SetPos( self:GetPos() + self.Ref.pos_a )
		tp_entrance:SetAngles( self:GetAngles() )
		if IsValid( self.Creator ) then
			tp_entrance.Creator = self.Creator
		end
		tp_entrance.BBTeam = self.BBTeam
		tp_entrance:Spawn()
	
	--exit
	local tp_exit = ents.Create( self.Ref.spawn_ent_b )
		tp_exit:SetPos( self:GetPos() + self.Ref.pos_b )
		tp_exit:SetAngles( self:GetAngles() )
		if IsValid( self.Creator ) then
			tp_exit.Creator = self.Creator
		end
		tp_exit.BBTeam = self.BBTeam
		tp_exit:Spawn()
		
	--so they know who each other are
	tp_entrance:SetPartnerEnt( tp_exit )
	tp_exit:SetPartnerEnt( tp_entrance )
	
	self:Remove()
		
	--[[
	timer.Simple( .5, function()
		if not IsValid( self ) then return end	
		--make sure they have the right skin, dont know why this needs to be done
		if self.BBTeam== TEAM_BLUE then
			tp_entrance:SetSkin( self.Ref.skin_entrance_blue )
			tp_exit:SetSkin( self.Ref.skin_exit_blue )
		elseif self.BBTeam == TEAM_RED then
			tp_entrance:SetSkin( self.Ref.skin_entrance_red )
			tp_exit:SetSkin( self.Ref.skin_exit_red )
		end
		
		self:Remove()
	end)
	]]--
end
