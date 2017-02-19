//AddCSLuaFile("func_bb_lava.lua")

ENT.Type 			= "brush"
ENT.Base 			= "base_anim"
ENT.PrintName		= ""



if !SERVER then return end
------------------------------------------------------------------------------------------------
--all server from now on
------------------------------------------------------------------------------------------------

//ENT.TouchingPlyList = {}

local table_who_not_to_hurt = { "structure_boat", "structure_scout", "structure_destroyer", "structure_blimp", }



function ENT:Initialize()
	self.TouchingPlyList = {}
end


function ENT:EmptyTable()
	table.Empty( self.TouchingPlyList )
end



function ENT:StartTouch( entity )
	if entity:IsValidPuck() then
		if entity:IsThisPuckType( table_who_not_to_hurt ) then return end
		table.insert( self.TouchingPlyList, entity )
	end
end

function ENT:EndTouch( entity )
	if entity:IsValidPuck() then
		if entity:IsThisPuckType( table_who_not_to_hurt ) then return end
		table.RemoveByValue( self.TouchingPlyList, entity )
	end
end

function ENT:Think()
	//print( table.ToString(self.TouchingPlyList) )
	
	--deal flat damage to an ent
	local function HurtEnt( ent )
		//print(ent:Health())
		local dmginfo = DamageInfo()
			dmginfo:SetDamage( LAVA_DAMAGE )
			dmginfo:SetDamageType( DMG_CRUSH )
			dmginfo:SetInflictor( self )
			dmginfo:SetAttacker( self )
		ent:TakeDamageInfo( dmginfo )
	end
	
	--[[
	local function HurtEnt( ent )
		local health = ent:Health()
		print(health)
		ent:SetHealth( health - 10 )
	end
	]]--
	
	
	--hurt all the pucks that are touching the lava
	for k,ent in pairs( self.TouchingPlyList ) do
		//local level = ent:WaterLevel()
		//print( level )
		//if level >= 1 then
			HurtEnt( ent )
		//elseif ent:GetClass() == "puck_jetpack" then
			//HurtEnt( ent )
		//end
	end 
	
end



//for _, v in pairs(player.GetAll()) do
	//v:PrintMessage(HUD_PRINTTALK, entity:GetName().. " has entered the lua brush area.")
//end
