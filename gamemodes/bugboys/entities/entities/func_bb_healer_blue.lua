//AddCSLuaFile("func_bb_healer.lua")

ENT.Type 			= "brush"
ENT.Base 			= "base_anim"
ENT.PrintName		= ""



if !SERVER then return end
------------------------------------------------------------------------------------------------
--all server from now on
------------------------------------------------------------------------------------------------

//ENT.TouchingPlyList = {}



function ENT:Initialize()
	self.TouchingPlyList = {}
end


function ENT:EmptyTable()
	table.Empty( self.TouchingPlyList )
end



function ENT:StartTouch( entity )
	if entity:IsValidPuck() then
		//if entity.BBTeam == TEAM_BLUE then
			table.insert( self.TouchingPlyList, entity )
		//end
	end
end

function ENT:EndTouch( entity )
	if entity:IsValidPuck() then
		//if entity.BBTeam == TEAM_BLUE then
			table.RemoveByValue( self.TouchingPlyList, entity )
		//end
	end
end

function ENT:Think()
	//print( table.ToString(self.TouchingPlyList) )
	
	--deal flat damage to an ent
	local function HealEnt( ent )
		//print(ent:Health())
		local dmginfo = DamageInfo()
			dmginfo:SetDamage( -3 )
			//dmginfo:SetDamageType( DMG_CRUSH )
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
		//print("hurting:  " .. ent:GetClass())
		if ent.BBTeam == TEAM_BLUE then
			HealEnt( ent )
		else
			ent:HurtEnt( 10, self, self )
		end
	end 
	
end



//for _, v in pairs(player.GetAll()) do
	//v:PrintMessage(HUD_PRINTTALK, entity:GetName().. " has entered the lua brush area.")
//end
