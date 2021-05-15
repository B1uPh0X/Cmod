--serverside code for the propgun

	--opens the network string
    util.AddNetworkString("newVar")

	--called when something is recieved from the network string
	net.Receive("newVar", function(len, ply)
		if  (IsFirstTimePredicted()) then 
			--calls the throw prop function for the server
        	ThrowProp( net.ReadString() , ply)
		end
	end)



    function ThrowProp( ModelSelected , plyer )

	if (IsFirstTimePredicted()) then
	
		--creates a valid entity with the prop model that was passed from client side
		local owner = plyer
		local ent = ents.Create( "prop_physics" )

		if ( not ent:IsValid() ) then return end
		ent:SetModel( ModelSelected )

		-- spawns the new prop with location and angles relative to the player
		local aimvec = owner:GetAimVector()
		local pos = aimvec * 16 
		pos:Add( owner:EyePos() )
		ent:SetPos( pos)
		ent:SetAngles( owner:EyeAngles() )
		ent:Spawn()
	
		-- adds 
		local phys = ent:GetPhysicsObject()
		if ( not phys:IsValid() ) then ent:Remove() return end
	
		-- Applies force to the prop so it is luanched instead of it dropping to the 
		aimvec:Mul( 1000)
		aimvec:Add( VectorRand( -10, 10 ) ) -- Add a random vector with elements [-10, 10)
		phys:ApplyForceCenter( aimvec )
	
		-- adds the prop that was luanched to the undo, so the palyer can 
		cleanup.Add( owner, "props", ent )
	
		undo.Create( "Thrown_Prop" )
			undo.AddEntity( ent )
			undo.SetPlayer( owner )
		undo.Finish()

		print("throw end")
	end
end
