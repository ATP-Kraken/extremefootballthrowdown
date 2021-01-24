STATE.Time = 0.5
--STATE.Time = 0.6
STATE.HitTime = 0.33
STATE.FOV = 90
STATE.Range = 64

function STATE:CanPickup(pl, ent)
	return true
end

function STATE:Started(pl, oldstate)
	pl:ResetJumpPower(0)
	pl:SetStateBool(false)
	if SERVER then
		pl:EmitSound("npc/zombie/claw_miss"..math.random(2)..".wav", 72, math.Rand(97, 103))
	end
end

if SERVER then
--[[function STATE:Ended(pl, newstate)
	if newstate == STATE_NONE then
		for _, tr in ipairs(pl:GetTargets()) do
			local hitent = tr.Entity
			if hitent:IsPlayer() and (hitent.CrossCounteredBy ~= pl or CurTime() >= (hitent.CrossCounteredTime or -math.huge) + 1) then
				pl:PunchHit(hitent, tr)
			end
		end
	end
end]]

function STATE:OnChargedInto(pl, otherpl)
	if CurTime() >= pl:GetStateEnd() - 0.2 and pl:TargetsContain(otherpl) then
		local vel = otherpl:GetVelocity()
		vel.x = 0
		vel.y = 0
		otherpl:SetLocalVelocity(vel)

		otherpl.CrossCounteredBy = pl
		otherpl.CrossCounteredTime = CurTime()

		pl:PunchHit(otherpl)
		otherpl:SetState(STATE_SPINNYKNOCKDOWN, STATES[STATE_SPINNYKNOCKDOWN].Time)

		pl:PrintMessage(HUD_PRINTTALK, "CROSS COUNTER!")
		otherpl:PrintMessage(HUD_PRINTTALK, "CROSS COUNTERED!")

		return true
	end
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

function STATE:ThinkCompensatable(pl)
	if not (pl:IsOnGround() and pl:WaterLevel() < 2) then
		pl:EndState(true)
	elseif SERVER and not pl:GetStateBool() and CurTime() >= pl:GetStateStart() + self.HitTime then
		pl:SetStateBool(true)

		local comp = pl:ShouldCompensate()

		if comp then
			pl:LagCompensation(true)
		end

		for _, tr in ipairs(pl:GetSweepTargets(self.Range, self.FOV, nil, nil, true)) do
			local hitent = tr.Entity
			if hitent:IsPlayer() and (hitent.CrossCounteredBy ~= pl or CurTime() >= (hitent.CrossCounteredTime or -math.huge) + 1) then
					pl:PunchHit(hitent, tr)
				end
		end
	elseif CurTime() >= pl:GetStateEnd() then
		if SERVER then
		pl:EndState(true)
		end end
end

function STATE:GoToNextState()
	return true
end

function STATE:CalcMainActivity(pl, velocity)
	pl.CalcSeqOverride = pl:LookupSequence("seq_meleeattack01")
end

function STATE:UpdateAnimation(pl, velocity, maxseqgroundspeed)
	pl:SetCycle(0.7 * math.Clamp(1 - (pl:GetStateEnd() - CurTime()) / self.Time, 0, 1) ^ 2.5)
	pl:SetPlaybackRate(0)

	return true
end
