STATE.Time = 0.55
STATE.HitTime = 0.18
STATE.Range = 64
STATE.FOV = 90

function STATE:Started(pl, oldstate)
	pl:ResetJumpPower(0)
	pl:DoAttackEvent()
	pl:SetStateBool(false)

	if SERVER then
		pl:EmitSound("weapons/iceaxe/iceaxe_swing1.wav", 72, math.Rand(65, 75))
	end
end

function STATE:IsIdle(pl)
	return false
end

function STATE:PreMove(ball, pl, move)
	move:SetMaxSpeed(move:GetMaxSpeed() * 0.5)
end

function STATE:OnChargedInto(pl, otherpl)
	if CurTime() >= pl:GetStateStart() + self.HitTime then
		local tr = pl:TargetsContain(otherpl, self.Range)
		if tr then
			self:HitEntity(pl, otherpl, tr, true)
			return true
		end
	end
end

function STATE:OnHitWithArcaneBolt(pl, ent)
	if CurTime() >= pl:GetStateStart() + self.HitTime and ent:GetOwner():IsValid() and ent:GetOwner():IsPlayer() and ent:GetOwner():Team() ~= pl:Team() then
		local tr = pl:TargetsContain(ent, self.Range)
		if tr then
			local phys = ent:GetPhysicsObject()
			if phys:IsValid() then
				local vel = phys:GetVelocity()
				local aim = pl:GetAimVector()
				if vel:GetNormalized():Dot(aim) <= -0.8 then
					phys:SetVelocityInstantaneous(vel * -1.4)
				else
					phys:SetVelocityInstantaneous(vel:Length() * 1.4 * aim)
				end
			end

			ent:SetOwner(pl)
			ent:SetColor(team.GetColor(pl:Team()))
			ent.Team = pl:Team()
			ent:EmitSound("npc/manhack/bat_away.wav")

			return true
		end
	end
end

function STATE:HitEntity(pl, hitent, tr, spinny)
	local knockdown = CurTime() >= hitent:GetKnockdownImmunity(self)
	hitent:ThrowFromPosition(pl:GetLaunchPos(), 450, knockdown, pl)
	if knockdown then
		hitent:ResetKnockdownImmunity(self)
	end
	hitent:TakeDamage(12, pl)
	if spinny then
		hitent:SetState(STATE_SPINNYKNOCKDOWN, STATES[STATE_SPINNYKNOCKDOWN].Time)
	end

	pl:ViewPunch(VectorRand():Angle() * (math.random(2) == 1 and -1 or 1) * 0.1)

	local effectdata = EffectData()
		effectdata:SetOrigin(tr.HitPos)
		effectdata:SetNormal(tr.HitNormal)
		effectdata:SetEntity(hitent)
	util.Effect("hit_beatingstick", effectdata, true, true)
end

function STATE:ThinkCompensatable(pl)
	if not (pl:IsOnGround() and pl:WaterLevel() < 2) then
		pl:EndState(true)
	elseif SERVER and not pl:GetStateBool() and CurTime() >= pl:GetStateStart() + self.HitTime then
		pl:SetStateBool(true)

		local comp = pl:ShouldCompensate()

		if comp then
			pl:LagCompensation(true)
		end

		for _, tr in ipairs(pl:GetSweepTargets(self.Range, self.FOV)) do
			local hitent = tr.Entity
			if hitent:IsPlayer() and not hitent:ImmuneToAll() then
				self:HitEntity(pl, hitent, tr)
			end
		end

		if comp then
			pl:LagCompensation(false)
		end
	end
end

function STATE:DoAnimationEvent(pl, event, data)
	if event == PLAYERANIMEVENT_ATTACK_PRIMARY then
		pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2, true)

		return ACT_INVALID
	--[[elseif event == PLAYERANIMEVENT_CUSTOM_GESTURE and data == ACT_GMOD_GESTURE_MELEE_SHOVE_2HAND then
		pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_MELEE_SHOVE_2HAND, true)

		return ACT_INVALID]]
	end
end

function STATE:CalcMainActivity(pl, velocity)
	pl.CalcSeqOverride = pl:LookupSequence("walk_melee2")
end

function STATE:UpdateAnimation(pl, velocity, maxseqgroundspeed)
	--pl:SetCycle(math.Clamp(1 - (pl:GetStateEnd() - CurTime()) / self.Time, 0, 1) * 0.8)
	--pl:SetPlaybackRate(0)

	--return true
end
