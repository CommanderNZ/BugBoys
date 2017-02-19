AddCSLuaFile("structure_token.lua")

ENT.Type 			= "anim"
ENT.Base 			= "base_bbentity"
//ENT.RenderGroup = RENDERGROUP_TRANSLUCENT




function ENT:Draw()
	//local distance = LocalPlayer():EyePos():Distance( self:GetPos() )
	//if distance < 1000 then
		self:DrawModel()
	//end
	//self:DrawShadow( false )
end




function ENT:SetAmountDisplay( num )
	self:SetNWInt( "Amount", num ) 
end

function ENT:GetAmountDisplay()
	return self:GetNWInt( "Amount", 1 ) 
end




if !SERVER then return end
------------------------------------------------------------------------------------------------
--all server from now on
------------------------------------------------------------------------------------------------
ENT.CanPickup = false
ENT.Amount = 1


function ENT:Initialize()
	self:SpecialInit()
	self:DrawShadow( false )
	
	self:ChangeStaticModel( self.Ref.model, COLLISION_GROUP_WORLD )
	
	self:SetColor( self.Ref.color ) 
	
	--must wait a sec til it can be picked up, so that it doesnt disappear instantly after spawning if a players in its radius
	--so they know what happened
	timer.Simple( self.Ref.time_canpickup, function()
		if not IsValid(self) then return end
		self.CanPickup = true
	end)
end


function ENT:Think()
	if self.CanPickup != true then return end
	
	--change the model if its worth more than 1
	if self:GetModel() == self.Ref.model and self.Amount > 1 then
		self:SetModel( self.Ref.model_multi )
	end
	
	--explode if there are enemies in the radius
	local orgin_ents = ents.FindInSphere( self:GetPos(), self.Ref.radius )
	
	for k, ent in pairs( orgin_ents ) do
		if ent:IsValidPlyBug() then
			self:StartEffect( ent.Owner )
		end
	end
	
	self:SetAmountDisplay( self.Amount )
	
	
	//print("token think")
	//self:NextThink( CurTime() + self.Ref.think_rate )
	//return true
end


--gives the touching player the money
function ENT:StartEffect( ply )
	ply:AddTokens( self.Amount )
	
	if self.Generator != nil and IsValid(self.Generator) then
		self.Generator:TokenCallback( self )
	end
	
	--change the model if its worth more than 1
	if self:GetModel() == self.Ref.model and self.Amount > 1 then
		self:SetModel( self.Ref.model_multi )
	end
	
	self:EmitSound( self.Ref.sound_pickup )
	self:Remove()
end


--makes this token worth more than it is at the moment
function ENT:AddInstance( add )
	if add != nil then
		self.Amount = self.Amount + add
	else
		self.Amount = self.Amount + 1
	end
	
	//self:SetAmountDisplay( self.Amount )
end



//tells the spawner, this token is gone, so open up the position its in
function ENT:OnRemove()
	if self.Generator != nil and IsValid(self.Generator) then
		self.Generator:TokenCallback( self )
	end
end


function ENT:PhysicsCollide( data, phys )

end


