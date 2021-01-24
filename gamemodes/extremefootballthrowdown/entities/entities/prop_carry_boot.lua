AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "prop_carry_base"

ENT.Name = "Speed Boot(s)"
ENT.PickupSound = Sound("weapons/discipline_device_power_up.wav")
ENT.IsPropWeapon = true

ENT.Model = Model("models/props_junk/Shoe001a.mdl")
ENT.ThrowForce = 850

ENT.BoneName = "ValveBiped.Bip01_R_Calf"
ENT.AttachmentOffset = Vector(9, 6.5, -1)
ENT.AttachmentAngles = Angle(-8, -104, 83)

ENT.Mass = 40

ENT.AllowDuringOverTime = true

function ENT:Initialize()
	self.BaseClass.Initialize(self)

	self:SetModelScale(2.5, 0)

	self.NextTouch = {}
end

function ENT:PrimaryAttack(pl)
	if pl:CanMelee() then
		pl:SetState(STATE_BOOTKICK, STATES[STATE_BOOTKICK].Time)
	end

	return true
end

function ENT:SecondaryAttack(pl)
		if pl:KeyDown(IN_FORWARD) then
		pl:SetState(STATE_DIVETACKLE)
	else
		pl:SetState(STATE_BIKEKICK)
		end
	return true
end

function ENT:Move(pl, move)
	move:SetMaxSpeed(move:GetMaxSpeed() * 1.5)
	move:SetMaxClientSpeed(move:GetMaxClientSpeed() * 1.5)
	if pl:GetState() == STATE_NONE and pl:GetStateInteger() == 0 then
	pl:SetStateInteger(1) --Disables charging
	end
end

function ENT:CalcMainActivity(pl, velocity)
	if not pl:OnGround() then
		pl.CalcIdeal = ACT_HL2MP_JUMP_FIST
		pl.CalcSeqOverride = -1
	elseif pl:Crouching() then
		if velocity:Length() > 0.5 then
			pl.CalcIdeal = ACT_HL2MP_WALK_CROUCH_FIST
			pl.CalcSeqOverride = -1
		else
			pl.CalcIdeal = ACT_HL2MP_IDLE_CROUCH_FIST
			pl.CalcSeqOverride = -1
		end
	elseif velocity:Length() > 0.5 then
		pl.CalcIdeal = ACT_HL2MP_RUN_FAST
		pl.CalcSeqOverride = -1
	else
		pl.CalcIdeal = ACT_HL2MP_IDLE_FIST
		pl.CalcSeqOverride = -1
	end
end

function ENT:AlignToCarrier()
	local carrier = self:GetCarrier()
	if carrier:IsValid() then
	if self:GetCarrier():GetCarry() ~= self then
		self.BoneName = "ValveBiped.Bip01_L_Calf"
	else
		self.BoneName = "ValveBiped.Bip01_R_Calf"
end	
	local pos, ang = self:GetAttachmentPosAng(carrier)
		local offset = self.AttachmentOffset
		local rotate = self.AttachmentAngles

		self:SetPos(pos + offset.x * ang:Forward() + offset.y * ang:Right() + offset.z * ang:Up())

		if rotate.yaw ~= 0 then ang:RotateAroundAxis(ang:Up(), rotate.yaw) end
		if rotate.pitch ~= 0 then ang:RotateAroundAxis(ang:Right(), rotate.pitch) end
		if rotate.roll ~= 0 then ang:RotateAroundAxis(ang:Forward(), rotate.roll) end
		self:SetAngles(ang)
	end
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

	self:EmitSound("npc/metropolice/gear"..math.random(6)..".wav", 72, math.Rand(85, 135))
end

function ENT:PhysicsCollide(data, phys)
	if data.Speed >= 150 then
		self:EmitSound("npc/footsteps/softshoe_generic6.wav",math.min(data.Speed/2,100),math.Rand(65, 115))

		self:NextThink(CurTime())
	end
end

function ENT:OnTouch(ent)
	if ent:IsPlayer() and ent:Alive() and self:GetVelocity():Length() >= self:GetImpactSpeed() and ent:Team() ~= self:GetLastCarrierTeam() and CurTime() >= (self.NextTouch[ent] or 0) then
		self.NextTouch[ent] = CurTime() + 0.5
		self.TouchedEnemy = ent
	end
end
