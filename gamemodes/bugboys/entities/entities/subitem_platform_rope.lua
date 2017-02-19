AddCSLuaFile("subitem_platform_rope.lua")

ENT.Type 			= "anim"
ENT.Base 			= "base_bbentity"
//ENT.RenderGroup = RENDERGROUP_TRANSLUCENT


if !SERVER then return end
------------------------------------------------------------------------------------------------
--all server from now on
------------------------------------------------------------------------------------------------

function ENT:Initialize()
	self:SpecialInit()
	
	self:ChangeStaticModel( self.Ref.model, COLLISION_GROUP_WEAPON )
	
	
	local function RopeTo( ent )
		--Rope setup code--
		local forcelimit = 0;
		local addlength     = 0;
		local material      = "cable/cable2"
		local width      = 3;
		local rigid         = false;
					 
		local Ent1 = self.Creator.Puck
		local Ent2 = self
		local Bone1, Bone2 = 0, 0
		local WPos1, WPos2 = self.Creator.Puck:GetPos() + Vector(0,0,25), self:GetPos()
		local LPos1, LPos2 = self.Creator.Puck:WorldToLocal(WPos1), self:WorldToLocal(WPos2)
		local length = (WPos2 - WPos1):Length()
		
		local constraint, rope = constraint.Rope( Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, length, addlength, forcelimit, width, material, rigid )	
	end

	
	timer.Simple( .1, function()
		if IsValid( self.Creator.Puck ) then
			constraint.RemoveAll( self.Creator.Puck )
			RopeTo()
		end
	end)
end

