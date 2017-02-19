local PuckEnt = FindMetaTable("Entity")



--function which controls the weld self ability, this fuses to to a friend
function PuckEnt:DoWeld()
	if true then return end
	local function WeldTo( x )
		self.MagnetAttached = true

		local Ent1 = self
		local Ent2 = x
		local Bone1 = 0
		local Bone2 = 0
		local constraint, weld = constraint.Weld( Ent1, Ent2, Bone1, Bone2, 0, false )	
	end
	
	local function CheckForTargets()
		local orgin_ents = ents.FindInSphere( self:GetPos(), self.Ref.radius_weld )
		for k, ent in pairs( orgin_ents ) do
			if ent != self and ent:IsValidPuck() and ent.BBTeam == self.BBTeam then
			--make it check if the puck is bigger than self
			//if ent:GetClass() == "ent_crystal"then
				WeldTo( ent )
				ent.MagnetAttached = true
				//print("attached")
				return
			end
		end
	end

	
	if (self.Owner:KeyDown(IN_DUCK)) then
		constraint.RemoveConstraints( self, "Rope" )
		if (self.MagnetTimer < CurTime()) then
			if self.MagnetAttached == true then
				constraint.RemoveConstraints( self, "Weld" )
				self.MagnetTimer = CurTime() + 1
				self.MagnetAttached = false
				//print("detached")
			else
				//self:FlashWhite( .2 )
				CheckForTargets()
				
				if self.MagnetAttached == true then
					self:EmitSound( SOUND_FUSE )
				else
					self:EmitSound( SOUND_ATTEMPT )
				end
				
				self.MagnetTimer = CurTime() + 1
			end
		end
	end
end