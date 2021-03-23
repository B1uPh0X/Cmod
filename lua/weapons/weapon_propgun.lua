SWEP.PrintName			= "prop picker upper" -- This will be shown in the spawn menu, and in the weapon selection menu
SWEP.Author			= "B1uDe4D" -- These two options will be shown when you have the weapon highlighted in the weapon selection menu
SWEP.Instructions		= "Right mouse to pick the prop, Left mouse to fire the prop!"

SWEP.Spawnable = true 
SWEP.AdminOnly = false

SWEP.Primary.Clipsize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.Clipsize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 1
SWEP.SlotPos = 2
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true

SWEP.ViewModel = "models/weapons/v_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"

SWEP.ShootSound = Sound("Metal.SawbladeStick")

local proppicked
local proplook

local delay = 0


SWEP.PropTable = {"models/props_borealis/bluebarrel001.mdl","models/props_c17/oildrum001.mdl","models/props_junk/PlasticCrate01a.mdl","models/props_combine/breenglobe.mdl","models/props_lab/huladoll.mdl"}
SWEP.PropSelected = 1

-- Called when the left mouse button is pressed
function SWEP:PrimaryAttack()

	print(self.PropSelected)

	print("Primary Start")
	
	self:SetNextPrimaryFire( CurTime() + .5 )

--self:ThrowChair( "models/props/cs_office/Chair_office.mdl" )

	print(self.PropTable[self.PropSelected])
	print(self.PropSelected)

	if(self.PropTable[self.PropSelected] ~=nil) then

		print(self.PropTable[self.PropSelected])
		-- Call 'ThrowProp' on self with this model
		self:ThrowProp( self.PropTable[self.PropSelected] )
		print(self.PropTable[self.PropSelected])
	
	end

	if(self.PropTable[self.PropSelected] == nil) then
		print("nil value")
	end
	
	print("Primary end")
	
end
 

-- Called when the right mouse button is pressed
function SWEP:SecondaryAttack()
	
	self:SetNextSecondaryFire( CurTime() + .1 )


-- works will need to be reworked for use with table
	print("secondary start")

	--local ply = LocalPlayer()
	--print( LocalPlayer() )
	if (IsValid(Entity( 1 ):GetEyeTrace().Entity)) then
		proplook= Entity( 1 ):GetEyeTrace().Entity:GetModel()
	end

	print(self.PropSelected)
	print(proplook)

	if (proplook ~= nil ) then
		self.PropTable[self.PropSelected] = proplook
		--chat.AddText("value at " + SWEP.PropSelected + " set too " + self.PropTable[SWEP.PropSelected])	
	end		
	print("secondary end")
end

-- Called when Reload is pressed
function SWEP:Reload()

	print("reload start")

	--make this gui based, cycle is too sesitive with key binds

	if not IsFirstTimePredicted() then return end


	if CurTime() < delay then return end
	delay = CurTime() + 1

	
	local botframe = vgui.Create("DFrame")
	botframe:SetSize(400, 75)
	botframe:Center()
	botframe:SetVisible(true)
	botframe:MakePopup()

	

	local button0 = vgui.Create("DButton", botframe)
	button0:SetText("nilly")
	button0:SetPos(25, 25)
	button0:SetSize(50,50)
	button0:SetVisible(true)
	function button0:DoClick()
		chat.AddText("Ouch that hurt!!")
		print(self.PropSelected)
		self.PropSelected = 1 --Dose not execute?
		print(self.PropSelected)
		botframe:Close()
	end

	local button1 = vgui.Create("DButton", botframe)
	button1:SetText("one")
	button1:SetPos(100, 25)
	button1:SetSize(50,50)
	button1:SetVisible(true)
	function button1.DoClick()
		chat.AddText("aaaaaaaaaaa!!!")
		self.PropSelected = 2
		botframe:Close()
	end

	local button2 = vgui.Create("DButton", botframe)
	button2:SetText("due")
	button2:SetPos(175, 25)
	button2:SetSize(50,50)
	button2:SetVisible(true)
	function button2.DoClick()
		chat.AddText("Ow0")
		self.PropSelected = 3
		botframe:Close()
	end

	local button3 = vgui.Create("Button", botframe)
	button3:SetText("triangle")
	button3:SetPos(250, 25)
	button3:SetSize(50,50)
	button3:SetVisible(true)
	function button3.DoClick()
		chat.AddText("fuck that shit hurts!!")
		self.PropSelected = 4
		botframe:Close()
	end

	local button3 = vgui.Create("Button", botframe)
	button3:SetText("quesdeia")
	button3:SetPos(325, 25)
	button3:SetSize(50,50)
	button3:SetVisible(true)
	function button3.DoClick()
		chat.AddText("hehe that tickles!")
		self.PropSelected = 5
		botframe:Close()
	end

--[[
	chat.AddText( self.PropTable[SWEP.PropSelected] ) 
	SWEP.PropSelected = SWEP.PropSelected + 1
		if (SWEP.PropSelected > 5) then
			SWEP.PropSelected = 1
		end
--]]
print("reload end")
end


-- A custom function. When you call this the player will fire a prop
function SWEP:ThrowProp( ModelSelected )
	print("throw start")
	print(ModelSelected)
	print(self.PropTable[ModelSelected])
	local owner = self:GetOwner()

	-- Make sure the weapon is being held before trying to throw a chair
	if ( not owner:IsValid() ) then return end

	-- Play the shoot sound we precached earlier!
	self:EmitSound( self.ShootSound )
 
	-- If we're the client then this is as much as we want to do.
	-- We play the sound above on the client due to prediction.
	-- ( if we didn't they would feel a ping delay during multiplayer )
	if ( CLIENT ) then return end

	-- Create a prop_physics entity
	local ent = ents.Create( "prop_physics" )

	-- Always make sure that created entities are actually created!
	if ( not ent:IsValid() ) then return end

	-- Set the entity's model to the passed in model
	ent:SetModel( self.PropTable[ModelSelected])

	-- This is the same as owner:EyePos() + (self.Owner:GetAimVector() * 16)
	-- but the vector methods prevent duplicitous objects from being created
	-- which is faster and more memory efficient
	-- AimVector is not directly modified as it is used again later in the function
	local aimvec = owner:GetAimVector()
	local pos = aimvec * 16 -- This creates a new vector object
	pos:Add( owner:EyePos() ) -- This translates the local aimvector to world coordinates

	-- Set the position to the player's eye position plus 16 units forward.
	ent:SetPos( pos )

	-- Set the angles to the player'e eye angles. Then spawn it.
	ent:SetAngles( owner:EyeAngles() )
	ent:Spawn()
 
	-- Now get the physics object. Whenever we get a physics object
	-- we need to test to make sure its valid before using it.
	-- If it isn't then we'll remove the entity.
	local phys = ent:GetPhysicsObject()
	if ( not phys:IsValid() ) then ent:Remove() return end
 
	-- Now we apply the force - so the chair actually throws instead 
	-- of just falling to the ground. You can play with this value here
	-- to adjust how fast we throw it.
	-- Now that this is the last use of the aimvector vector we created,
	-- we can directly modify it instead of creating another copy
	aimvec:Mul( 100 )
	aimvec:Add( VectorRand( -10, 10 ) ) -- Add a random vector with elements [-10, 10)
	phys:ApplyForceCenter( aimvec )
 
	-- Assuming we're playing in Sandbox mode we want to add this
	-- entity to the cleanup and undo lists. This is done like so.
	cleanup.Add( owner, "props", ent )
 
	undo.Create( "Thrown_Prop" )
		undo.AddEntity( ent )
		undo.SetPlayer( owner )
	undo.Finish()

	print("throw end")
end

