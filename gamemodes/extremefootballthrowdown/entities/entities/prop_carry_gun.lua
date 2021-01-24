AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "prop_carry_base"

ENT.Name = ".9cm Pistol"
--ENT.PickupSound = Sound("weapons/draw_sword.wav")
ENT.IsPropWeapon = true

ENT.Model = Model("models/weapons/w_pistol.mdl")
ENT.ThrowForce = 850

ENT.BoneName = "ValveBiped.Bip01_R_Hand"
ENT.AttachmentOffset = Vector(8, 1.5, -3.5)
ENT.AttachmentAngles = Angle(180, 0, 0)

ENT.ChargeTime = 1
ENT.FireDelay = 2.3

ENT.Mass = 40

ENT.AllowDuringOverTime = true

function ENT:Initialize()
	self.BaseClass.Initialize(self)

	self:SetModelScale(1.7, 0)

	self.NextTouch = {}
end

function ENT:PrimaryAttack(pl)
	if not pl:IsSwimming() and self:GetFireTime() == 0 and CurTime() >= self:GetNextFireTime() then
		self:SetFireTime(CurTime() + self.ChargeTime)
		self:SetNextFireTime(CurTime() + self.FireDelay)

		if SERVER then self:EmitSound("weapons/shotgun/shotgun_cock.wav", 78, 115) end
	elseif self:GetFireTime() == 0 and CurTime() <= self:GetNextFireTime() then
		if SERVER then self:EmitSound("weapons/pistol/pistol_empty.wav", 78, 100) end
	end

	return true
end

function ENT:SecondaryAttack(pl)
	if pl:CanThrow() and self:GetFireTime() == 0 then
		pl:SetState(STATE_THROW)
	end

	return true
end

function ENT:Move(pl, move)
	if self:GetFireTime() == 0 then
		move:SetMaxSpeed(move:GetMaxSpeed() * 0.7)
		move:SetMaxClientSpeed(move:GetMaxClientSpeed() * 0.7)
	else
		move:SetMaxSpeed(move:GetMaxSpeed() * 0.2)
		move:SetMaxClientSpeed(move:GetMaxClientSpeed() * 0.2)
	end
end

function ENT:CalcMainActivity(pl, velocity)
	if self:GetFireTime() ~= 0 then
		pl.CalcIdeal = pl:Crouching() and ACT_HL2MP_WALK_CROUCH_REVOLVER or ACT_HL2MP_WALK_REVOLVER
		pl.CalcSeqOverride = -1
	end
end

function ENT:OnThink()
	if SERVER then
		if self.PhysicsData then
			self:HitObject(self.PhysicsData.HitPos, self.PhysicsData.HitNormal, self.PhysicsData.HitEntity)
		elseif self.TouchedEnemy then
			self:HitObject(nil, nil, self.TouchedEnemy)
		end
	end
	
	local carrier = self:GetCarrier()
	if not carrier:IsValid() then return end

	if CurTime() < self:GetFireTime() and carrier:IsSwimming() then carrier:SetLocalVelocity(Vector(0,0,0)) end

	if self:GetFireTime() == 0 or CurTime() < self:GetFireTime() then return end
	if carrier:KeyDown(IN_ATTACK) then return end
	self:SetFireTime(0)
	carrier:ViewPunch( Angle( -1, 0, 0 ) )
	if SERVER then
		
		self:EmitSound("weapons/pistol/pistol_fire3.wav")

			local ang = carrier:EyeAngles()
			ang:RotateAroundAxis(ang:Up(), math.Rand(-1, 1))
			ang:RotateAroundAxis(ang:Right(), math.Rand(-1, 1))

			local ent = ents.Create("proj_bullet")
			if ent:IsValid() then
				ent:SetPos(carrier:GetShootPos())
				ent:SetAngles(ang)
				ent:SetOwner(carrier)
				ent:Spawn()
				ent:SetLastCarrier(carrier)

				local phys = ent:GetPhysicsObject()
				if phys:IsValid() then
					phys:Wake()
					phys:SetVelocityInstantaneous(ang:Forward() * 1600 + carrier:GetVelocity())
					phys:AddAngleVelocity(VectorRand() * 600)
				end
		end
	end
end

if SERVER then
function ENT:Initialize()
	self.BaseClass.Initialize(self)

	self.NextTouch = {}
end

function ENT:PhysicsCollide(data, phys)
	if data.Speed >= self:GetImpactSpeed() then
		self.PhysicsData = data
		self:NextThink(CurTime())
	end
end

function ENT:HitObject(hitpos, hitnormal, hitent)
	self.PhysicsData = nil
	self.TouchedEnemy = nil

	self:NextThink(CurTime())

	hitpos = hitpos or self:GetPos()
	hitnormal = hitnormal or Vector(0, 0, 1)

	if IsValid(hitent) and hitent:IsPlayer() and hitent:Team() ~= self:GetLastCarrierTeam() then
		hitent:EmitSound("physics/body/body_medium_impact_hard"..math.random(6)..".wav")
		hitent:ThrowFromPosition(hitpos + Vector(0, 0, -24), math.Clamp(self:GetVelocity():Length() * 1.2, 350, 750), true)
		hitent:TakeDamage(10, self:GetLastCarrier(), self)
	end

	self:EmitSound("physics/metal/weapon_impact_hard"..math.random(3)..".wav")
end

function ENT:OnTouch(ent)
	if ent:IsPlayer() and ent:Alive() and self:GetVelocity():Length() >= self:GetImpactSpeed() and ent:Team() ~= self:GetLastCarrierTeam() and CurTime() >= (self.NextTouch[ent] or 0) then
		self.NextTouch[ent] = CurTime() + 0.5
		self.TouchedEnemy = ent
	end
end
end

function ENT:GetImpactSpeed()
	return self:GetLastCarrier():IsValid() and 200 or 450
end

function ENT:SetFireTime(time) self:SetDTFloat(0, time) end
function ENT:GetFireTime() return self:GetDTFloat(0) end
function ENT:SetNextFireTime(time) self:SetDTFloat(1, time) end
function ENT:GetNextFireTime() return self:GetDTFloat(1) end

if not CLIENT then return end

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

local matRefraction	= Material("refract_ring")
local matRing = Material("effects/select_ring")
local colRing = Color(255, 120, 20, 255)
function ENT:DrawTranslucent()
	self:Draw()

	if self:GetFireTime() == 0 then return end

	local dir = self:GetForward()
	local pos = self:LocalToWorld(Vector(-5, 0, 5))
	local rot = CurTime() * 360 % 1
	local delta = (1 - CurTime() * 2 % 1) ^ 2 * math.Clamp((self:GetFireTime() - CurTime()) / self.ChargeTime, 0, 1)
	local size = delta * 200

	colRing.a = delta * 100
	render.SetMaterial(matRing)
	render.DrawQuadEasy(pos, dir, size, size, colRing, rot)
	render.DrawQuadEasy(pos, dir * -1, size, size, colRing, rot)

	colRing.a = 255
	matRefraction:SetFloat("$refractamount", delta / 2)
	render.SetMaterial(matRefraction)
	render.UpdateRefractTexture()
	render.DrawQuadEasy(pos, dir, size, size, color_white, rot)
	render.DrawQuadEasy(pos, dir * -1, size, size, color_white, rot)
end

function ENT:ShouldDrawCrosshair()
	return self:GetFireTime() ~= 0
end

function ENT:GetCameraPos(pl, camerapos, origin, angles, fov, znear, zfar)
	if self:GetFireTime() ~= 0 then
		pl:ThirdPersonCamera(camerapos, origin, angles, fov, znear, zfar, nil, 16)
	end
end

