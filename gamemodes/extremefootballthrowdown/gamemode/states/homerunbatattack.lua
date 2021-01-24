STATE.Time = 0.7
STATE.HitTime = 0.3
STATE.Range = 64
STATE.FOV = 90

function STATE:Started(pl, oldstate)
	pl:ResetJumpPower(0)

	pl:SetStateBool(false)

	if SERVER then
		pl:EmitSound("weapons/iceaxe/iceaxe_swing1.wav", 72, math.Rand(65, 75))
	end
end

function STATE:CanPickup(pl, ent)
	return true
end

if SERVER then
function STATE:Ended(pl, newstate)
	pl:SetStateBool(false)
end
end

function STATE:IsIdle(pl)
	return false
end

function STATE:Move(pl, move)
	move:SetSideSpeed(0)
	move:SetForwardSpeed(0)
	move:SetMaxSpeed(0)
	move:SetMaxClientSpeed(0)

	return MOVE_STOP
end

function STATE:HitEntity(pl, hitent, tr, spinny)
	local knockdown = CurTime() >= hitent:GetKnockdownImmunity(self)
	hitent:ThrowFromPosition(pl:GetLaunchPos(), 800, knockdown, pl)
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

		if SERVER then
			local ball = GAMEMODE:GetBall()
			if not ball:GetCarrier():IsValid() then
				local ballpos = ball:GetPos()
				local eyepos = pl:EyePos()
				if ballpos:Distance(eyepos) <= self.Range*2 and util.IsVisible(ballpos, eyepos) then
					local eyevector = pl:EyeAngles()
					eyevector.pitch = 0
					eyevector = eyevector:Forward()

					local dir = ballpos - eyepos
					dir:Normalize()
					if eyevector:Dot(dir) >= 0.4 then
						if CurTime() >= (NEXTHOMERUN or 0) then
							NEXTHOMERUN = CurTime() + 5
							--GAMEMODE:SlowTime(0.25, 2)
						end

						ball.LastBigPoleHit = pl
						ball.LastBigPoleHitTime = CurTime()
						ball:SetLastCarrier(pl)
						ball:SetAutoReturn(0)
						ball:EmitSound("taunts/fail/smaaash.wav", 70, math.Rand(95, 105))
						local phys = ball:GetPhysicsObject()
						if phys:IsValid() then
							local ang = dir:Angle()
							ang.pitch = -35
							phys:SetVelocityInstantaneous(ang:Forward() * 1300)
						end
					end
				end
			end
		end

		if comp then
			pl:LagCompensation(false)
		end
	end
end

function STATE:CalcMainActivity(pl, velocity)
	pl.CalcSeqOverride = pl:LookupSequence("seq_baton_swing")
end

function STATE:UpdateAnimation(pl, velocity, maxseqgroundspeed)
	pl:SetCycle(math.Clamp(1 - (pl:GetStateEnd() - CurTime()) / self.Time, 0, 1)^ 1.3 * 0.8)
	pl:SetPlaybackRate(0)

	return true
end