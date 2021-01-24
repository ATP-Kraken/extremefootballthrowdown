AddCSLuaFile()

SWEP.PrintName = ""

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 0

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Delay = 0

SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false

SWEP.ViewModel = "models/weapons/c_arms_citizen.mdl"
SWEP.WorldModel	= ""

function SWEP:Think()
	if not self.Owner:CallCarryFunction("ThinkCompensatable") then
		self.Owner:CallStateFunction("ThinkCompensatable")
	end
	local owner = self.Owner
	
	if owner:CanCharge() and !owner:GetNWBool("HasChaseMusic",false) then
	for k,v in pairs(ents.FindInBox(owner:GetPos()+Vector(1028,1028,64),owner:GetPos()+Vector(-1028,-1028,0))) do
		if v:IsPlayer() and v:Team() != TEAM_SPECTATOR and v:Team() != owner:Team() and v:IsIdle() and owner:GetVelocity():Dot(v:GetVelocity()) > 0.5 and (owner:GetVelocity()+v:GetVelocity()):Length2DSqr() > 70000 then
		owner:SetNWBool("HasChaseMusic",true)
		v:SetNWBool("HasChaseMusic",true)
		if SERVER then
		ent = ents.Create("eft_chasemusic_helper")
		ent:SetPos(owner:GetPos())
		ent:SetNWEntity("Player1",owner)
		ent:SetNWEntity("Player2",v)
		ent:Spawn()
		end
		end
    end
	end
	
	self:NextThink(CurTime())
	return true
end

function SWEP:PrimaryAttack()
	local owner = self.Owner

	if owner:CallStateFunction("PrimaryAttack") then return end
	if owner:CallCarryFunction("PrimaryAttack") then return end

	if owner:CanMelee() then
		local state = STATE_PUNCH1
		--[[for _, tr in pairs(owner:GetTargets()) do
			local hitent = tr.Entity
			if hitent:IsPlayer() and hitent:GetState() == STATE_KNOCKEDDOWN then
				state = STATE_KICK1
				break
			end
		end]]

		owner:SetState(state, STATES[state].Time)
	end
end

function SWEP:SecondaryAttack()
	local owner = self.Owner

	if owner:CallStateFunction("SecondaryAttack") then return end
	if owner:CallCarryFunction("SecondaryAttack") then return end

	if owner:CanMelee() then
		local vel = owner:GetVelocity()
		local dir = vel:GetNormalized()
		local speed = vel:Length() * dir:Dot(owner:GetForward())
		if speed >= 290 and CurTime() >= owner:GetLastChargeHit() + 0.4 and owner:GetCarry() ~= GAMEMODE:GetBall() then
			owner:SetState(STATE_DIVETACKLE)
		end
	end
end

function SWEP:Reload()
	local owner = self.Owner

	if owner:KeyPressed(IN_RELOAD) then
		if owner:CallStateFunction("Reload") then return end
		--[[if]] owner:CallCarryFunction("Reload") --then return end
	end
end

if not CLIENT then return end

function SWEP:DrawWeaponSelection()
end

function SWEP:PreDrawViewModel(vm, wep, pl)
	vm:SetMaterial("engine/occlusionproxy")
end
