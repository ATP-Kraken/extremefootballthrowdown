STATE.Time = 1.7
STATE.HitTime = 0.4
STATE.FOV = 150
STATE.Range = 64


function STATE:Started(pl, oldstate)
	pl:ResetJumpPower(0)

	pl:SetStateBool(false)
end

function STATE:IsIdle(pl)
	return false
end


function STATE:GoToNextState(pl)
	local dir = vector_origin
	if pl:KeyDown(IN_FORWARD) then
		dir = dir + pl:GetForward()
	end
	if pl:KeyDown(IN_BACK) then
		dir = dir - pl:GetForward()
	end
	if pl:KeyDown(IN_MOVERIGHT) then
		dir = dir + pl:GetRight()
	end
	if pl:KeyDown(IN_MOVELEFT) then
		dir = dir - pl:GetRight()
	end

	if dir ~= vector_origin then
		dir:Normalize()
		dir = dir * 180
		dir.z = 128
		pl:SetState(STATE_KNOCKDOWNRECOVER, 0.1)
		pl:SetStateVector(dir)
	end
end

function STATE:Move(pl, move)
	move:SetSideSpeed(0)
	move:SetForwardSpeed(0)
	move:SetMaxSpeed(0)
	move:SetMaxClientSpeed(0)

	return MOVE_STOP
end

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
	hitent:ThrowFromPosition(pl:GetLaunchPos(), 150, knockdown, pl)
	if knockdown then
		hitent:ResetKnockdownImmunity(self)
	end
	hitent:TakeDamage(7, pl)
	if spinny then
		hitent:SetState(STATE_SPINNYKNOCKDOWN, STATES[STATE_SPINNYKNOCKDOWN].Time)
	end

	pl:ViewPunch(VectorRand():Angle() * (math.random(2) == 1 and -1 or 1) * 0.1)

	local effectdata = EffectData()
		effectdata:SetOrigin(tr.HitPos)
		effectdata:SetNormal(tr.HitNormal)
		effectdata:SetEntity(hitent)
	util.Effect("punchhit", effectdata, true, true)
end

function STATE:ThinkCompensatable(pl)
	if not (pl:IsOnGround() and pl:WaterLevel() < 2) then
		pl:EndState(true)
	elseif (team.HasPity(pl:Team()) or pl:Armor() > 0) and pl:GetStateEnd() < CurTime()  + 0.8 then
		if SERVER then
		pl:SetArmor(0)
		end
		pl:EndState(true)
	elseif SERVER and not pl:GetStateBool() and CurTime() >= pl:GetStateStart() + self.HitTime then
		pl:SetStateBool(true)
		pl:EmitSound("npc/zombie/claw_miss"..math.random(2)..".wav", 72, math.Rand(91, 97))
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

function STATE:CalcMainActivity(pl, velocity)
	pl.CalcSeqOverride = pl:LookupSequence("zombie_slump_rise_02_slow")
end

function STATE:UpdateAnimation(pl, velocity, maxseqgroundspeed)
	pl:SetCycle(math.Clamp(1 - (pl:GetStateEnd() - CurTime()) / self.Time, 0, 1) * 0.8)
	pl:SetPlaybackRate(0)

	return true
end

