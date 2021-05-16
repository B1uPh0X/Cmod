SWEP.PrintName			= "prop picker upper ander thrower 9000er" -- This will be shown in the spawn menu, and in the weapon selection menu
SWEP.Author			= "REDACTED" -- These two options will be shown when you have the weapon highlighted in the weapon selection menu
SWEP.Instructions		= "Right mouse to pick the prop, Left mouse to fire the prop!"

--the following lines of code set the porperties of the item

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

--Declares and intilizes varibles that will be used

SWEP.ShootSound = Sound("Metal.SawbladeStick")

local proplook
local delay = 0

SWEP.PropTable = {"models/props_borealis/bluebarrel001.mdl","models/props_c17/oildrum001.mdl","models/props_junk/PlasticCrate01a.mdl",
					"models/props_combine/breenglobe.mdl","models/props_lab/huladoll.mdl"}
SWEP.PropSelected = nil
SWEP.PropPicked = "e" --Needed to be intilized as a string type


-- Called when the left mouse button is pressed, the primary function of the SWEP
function SWEP:PrimaryAttack()
	
	--prevents the user from spam clicking, prevents the user from crasing the game
	self:SetNextPrimaryFire( CurTime() + .5 )

	--stops the server from running unesccary code. Files are ran by both the client and server
	if(not CLIENT) then
		return
	end

	--Additional measure to prevent the code from executing multiple times simultaneously
	if (not (IsFirstTimePredicted())) then
		return
	end

	--If the selected prop is valid then it will throw it
	if(self.PropTable[self.PropSelected] ~=nil) then
	
		self.PropPicked = self.PropTable[self.PropSelected]

		--variable needs to update server side, gets handled in serpaerate server file.
		net.Start("newVar")
		net.WriteString(self.PropPicked)
		net.SendToServer()
	
	end

	--prints nil if invalid or nil
	if(self.PropTable[self.PropSelected] == nil) then
		print("nil value")
	end
	
end

-- Called when the right mouse button is pressed
function SWEP:SecondaryAttack()

	--same as above, prevents user from spamming and the server from running unesscary code.

	self:SetNextSecondaryFire( CurTime() + .1 )

	if(not CLIENT) then
		return
	end

	if (not (IsFirstTimePredicted())) then
		return
	end

	--pulls the model of a valid prop that the player is looking at, stores that prop model in the table.
	if (IsValid(Entity( 1 ):GetEyeTrace().Entity)) then
		proplook= Entity( 1 ):GetEyeTrace().Entity:GetModel()
	end

	if (proplook ~= nil ) then
		self.PropTable[self.PropSelected] = proplook
		
	end		
	
end

-- Called when Reload is pressed
function SWEP:Reload()
	--prevets multiple prompts from appearing simultaneously
	if(not CLIENT) then
		return
	end

	if (not (IsFirstTimePredicted())) then
		return
	end

	if CurTime() < delay then return end
	delay = CurTime() + 1

	--creates the menu which will have 5 buttons, each of which will change the index of the table accordingly. menu will close once a choice is selected.
	local botframe = vgui.Create("DFrame")
	botframe:SetSize(400, 75)
	botframe:Center()
	botframe:SetVisible(true)
	botframe:MakePopup()

	local button1 = vgui.Create("DButton", botframe)
	button1:SetText("one")
	button1:SetPos(25, 25)
	button1:SetSize(50,50)
	button1:SetVisible(true)
	function button1.DoClick()
		chat.AddText("prop 1 is selected")
		self.PropSelected = 1
		botframe:Close()
	end

	local button2 = vgui.Create("DButton", botframe)
	button2:SetText("two")
	button2:SetPos(100, 25)
	button2:SetSize(50,50)
	button2:SetVisible(true)
	function button2.DoClick()
		chat.AddText("prop 2 is selected")
		self.PropSelected = 2
		botframe:Close()
	end

	local button3 = vgui.Create("DButton", botframe)
	button3:SetText("three")
	button3:SetPos(175, 25)
	button3:SetSize(50,50)
	button3:SetVisible(true)
	function button3.DoClick()
		chat.AddText("prop 3 is selected")
		self.PropSelected = 3
		botframe:Close()
	end

	local button4 = vgui.Create("Button", botframe)
	button4:SetText("four")
	button4:SetPos(250, 25)
	button4:SetSize(50,50)
	button4:SetVisible(true)
	function button4.DoClick()
		chat.AddText("prop 4 is selected")
		self.PropSelected = 4
		botframe:Close()
	end

	local button5 = vgui.Create("Button", botframe)
	button5:SetText("five")
	button5:SetPos(325, 25)
	button5:SetSize(50,50)
	button5:SetVisible(true)
	function button5.DoClick()
		chat.AddText("prop 5 is selected")
		self.PropSelected = 5
		botframe:Close()
	end
end

-- This the function that will actually throw the prop, the server has its own version of this function, a prop model file is passed in.
function SWEP:ThrowProp( ModelSelected )
	if (IsFirstTimePredicted() ) then
		
		-- makes sure that the weapons is in hand
		local owner = self:GetOwner()
		if ( not owner:IsValid() ) then return end
		-- plays the sound that was specified at the top of this file
		self:EmitSound( self.ShootSound )
	
		--ends here because this the client version of this function
		if ( CLIENT ) then return end

	end
end

