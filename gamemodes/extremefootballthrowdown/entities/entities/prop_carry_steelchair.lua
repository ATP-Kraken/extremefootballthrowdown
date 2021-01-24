AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "prop_carry_base"

ENT.Name = "Steel Chair"
ENT.PickupSound = Sound("weapons/draw_melee.wav")
ENT.IsPropWeapon = true

ENT.Model = Model("models/props_wasteland/controlroom_chair001a.mdl")
ENT.ThrowForce = 450

ENT.BoneName = "ValveBiped.Bip01_R_Hand"
ENT.AttachmentOffset = Vector(6.3, 12, -15)
ENT.AttachmentAngles = Angle(5.7, -21.3, 7.2)

ENT.Mass = 40

ENT.AllowDuringOverTime = true

function ENT:Initialize()
	self.BaseClass.Initialize(self)

	self:SetModelScale(1, 0)

	self.NextTouch = {}
end

function ENT:PrimaryAttack(pl)
	if pl:CanMelee() then
		pl:SetState(STATE_CHAIRATTACK, STATES[STATE_CHAIRATTACK].Time)
	end

	return true
end

function ENT:SecondaryAttack(pl)
	if pl:CanThrow() then
		pl:SetState(STATE_THROW)
	end

	return true
end

function ENT:CalcMainActivity(pl, velocity)
	if not pl:OnGround() then
		pl.CalcIdeal = ACT_HL2MP_JUMP_DUEL
		pl.CalcSeqOverride = -1
	elseif pl:Crouching() then
		if velocity:Length() > 0.5 then
			pl.CalcIdeal = ACT_HL2MP_WALK_CROUCH_DUEL
			pl.CalcSeqOverride = -1
		else
			pl.CalcIdeal = ACT_HL2MP_SIT_PHYSGUN
			pl.CalcSeqOverride = -1
		end
	elseif velocity:Length() > 0.5 then
		pl.CalcIdeal = ACT_HL2MP_RUN_DUEL
		pl.CalcSeqOverride = -1
	else
		pl.CalcIdeal = ACT_HL2MP_IDLE_DUEL
		pl.CalcSeqOverride = -1
	end
end

function ENT:Move(pl, move)
	move:SetMaxSpeed(move:GetMaxSpeed() * 0.8)
	move:SetMaxClientSpeed(move:GetMaxClientSpeed() * 0.8)
end

function ENT:GetImpactSpeed()
	return self:GetLastCarrier():IsValid() and 300 or 600
end

if CLIENT then return end

function ENT:OnThink()
	if self.PhysicsData then
		self:HitObject(self.PhysicsData.HitPos, self.PhysicsData.HitNormal, self.PhysicsData.HitEntity)
	elseif self.TouchedEnemy then
		self:HitObject(nil, nil, self.TouchedEnemy)
	end
end

function ENT:HitObject(hitpos, hitnormal, hitent)
	self.PhysicsData = nil
	self.TouchedEnemy = nil

	self:NextThink(CurTime())

	hitpos = hitpos or self:GetPos()
	hitnormal = hitnormal or Vector(0, 0, 1)

	if IsValid(hitent) and hitent:IsPlayer() and hitent:Team() ~= self:GetLastCarrierTeam() then
		hitent:EmitSound("npc/zombie/zombie_hit.wav", 75, math.Rand(90, 140))
		hitent:ThrowFromPosition(hitent:GetPos() + Vector(0, 0, -16), 200, true)
		hitent:TakeDamage(5, self:GetLastCarrier(), self)

		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			local vel = phys:GetVelocity() * 0.15
			vel.z = 300
			phys:SetVelocityInstantaneous(vel)
			phys:AddAngleVelocity(VectorRand():GetNormalized() * 420)
		end
	end

	self:EmitSound("physics/metal/metal_canister_impact_hard"..math.random(3)..".wav")
end

function ENT:PhysicsCollide(data, phys)
	if data.Speed >= 150 then
		self:EmitSound("physics/metal/metal_solid_impact_soft"..math.random(3)..".wav")

		self:NextThink(CurTime())
	end
end

function ENT:OnTouch(ent)
	if ent:IsPlayer() and ent:Alive() and self:GetVelocity():Length() >= self:GetImpactSpeed() and ent:Team() ~= self:GetLastCarrierTeam() and CurTime() >= (self.NextTouch[ent] or 0) then
		self.NextTouch[ent] = CurTime() + 0.5
		self.TouchedEnemy = ent
	end
end
