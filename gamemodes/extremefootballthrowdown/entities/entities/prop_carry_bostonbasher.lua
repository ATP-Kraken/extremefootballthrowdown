AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "prop_carry_base"

ENT.Name = "Boston Basher"
ENT.PickupSound = Sound("weapons/draw_sword.wav")
ENT.IsPropWeapon = true

ENT.Model = Model("models/weapons/c_models/c_boston_basher/c_boston_basher.mdl")
ENT.ThrowForce = 850

ENT.BoneName = "ValveBiped.Bip01_R_Hand"
ENT.AttachmentOffset = Vector(3, 1, 4)
ENT.AttachmentAngles = Angle(180, 0, 0)

ENT.Mass = 40

ENT.AllowDuringOverTime = true

function ENT:Initialize()
	self.BaseClass.Initialize(self)

	self:SetModelScale(1, 0)

	self.NextTouch = {}
end

function ENT:PrimaryAttack(pl)
	if pl:CanMelee() then
		pl:SetState(STATE_BOSTONBASH, STATES[STATE_BOSTONBASH].Time)
	end

	return true
end

function ENT:SecondaryAttack(pl)
	if pl:CanThrow() then
		pl:SetState(STATE_THROW)
	end

	return true
end

function ENT:Move(pl, move)
	move:SetMaxSpeed(move:GetMaxSpeed() * 0.8)
	move:SetMaxClientSpeed(move:GetMaxClientSpeed() * 0.8)
end

function ENT:GetImpactSpeed()
	return self:GetLastCarrier():IsValid() and 300 or 600
end

function ENT:CalcMainActivity(pl, velocity)
	if pl:GetState() == STATE_NONE then
	if not pl:OnGround() then
		pl.CalcIdeal = ACT_HL2MP_JUMP_MELEE2
		pl.CalcSeqOverride = -1
	elseif pl:Crouching() then
		if velocity:Length() > 0.5 then
			pl.CalcIdeal = ACT_HL2MP_WALK_CROUCH_MELEE2
			pl.CalcSeqOverride = -1
		else
			pl.CalcIdeal = ACT_HL2MP_IDLE_CROUCH_MELEE2
			pl.CalcSeqOverride = -1
		end
	elseif velocity:Length() > 0.5 then
		pl.CalcIdeal = ACT_HL2MP_RUN_MELEE2
		pl.CalcSeqOverride = -1
	else 
		pl.CalcIdeal = ACT_HL2MP_IDLE_MELEE2
		pl.CalcSeqOverride = -1
	end
	end
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
		hitent:TakeDamage(15, self:GetLastCarrier(), self)

		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			local vel = phys:GetVelocity() * 0.15
			vel.z = 300
			phys:SetVelocityInstantaneous(vel)
			phys:AddAngleVelocity(VectorRand():GetNormalized() * 420)
		end
	end

	self:EmitSound("weapons/bat_baseball_hit_flesh.wav")
end

function ENT:PhysicsCollide(data, phys)
	if data.Speed >= 200 then
		if math.random(3) > 2 then
		self:EmitSound("ui/item_wood_weapon_drop.wav",math.min(data.Speed/4.5,100),math.Rand(65, 115))
	else
		self:EmitSound("npc/stalker/stalker_footstep_left1.wav",math.min(data.Speed/4.5,100),math.Rand(65, 115))
		end
	
		self:NextThink(CurTime())
	end
end

function ENT:OnTouch(ent)
	if ent:IsPlayer() and ent:Alive() and self:GetVelocity():Length() >= self:GetImpactSpeed() and ent:Team() ~= self:GetLastCarrierTeam() and CurTime() >= (self.NextTouch[ent] or 0) then
		self.NextTouch[ent] = CurTime() + 0.5
		self.TouchedEnemy = ent
	end
end
