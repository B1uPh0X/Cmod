SWEP.PrintName			= "prop picker upper" -- This will be shown in the spawn menu, and in the weapon selection menu
SWEP.Author			= "B1u" -- These two options will be shown when you have the weapon highlighted in the weapon selection menu
SWEP.Instructions		= "Right mouse to pick the prop, Left mouse to fire the prop!"

SWEP.Spawnable = true 
SWEP.AdminOnly = true

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

function SWEP:PrimaryAttack()
    
    self:SetNextPrimaryFire( CurTime() + 0.5)

    self:ThrowProp("models/props/cs_office/Chair_office.mdl")    
end

function SWEP:SecondaryAttack()
    self:SetNextSecondaryFire( CurTime() + 0.1)

    self:ThrowProp("models/props/cs_office/Chair_office.mdl")
end

function SWEP:ThrowProp(model_file)
    local owner = self:GetOwner()

    if ( not owner:IsValid() ) then return end

    self:EmitSound(self.shootSound)


    
end

