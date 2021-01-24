STATE.Time = 0.75

function STATE:Started(pl, oldstate)
	pl:ResetJumpPower(0)
	if SERVER then
	pl:EmitSound("npc/metropolice/vo/pickupthecan"..math.random(3)..".wav")
	end
end

--[[if SERVER then
function STATE:Ended(pl, newstate)
	if newstate == STATE_NONE then
		local carry = pl:GetCarry()
		if not carry:IsValid() or carry:GetClass() ~= "prop_carry_trashbin" then return end

		for _, tr in ipairs(pl:GetTargets()) do
			local hitent = tr.Entity
			if hitent:IsPlayer() then
				local ent = ents.Create("prop_trashbin")
				if ent:IsValid() then
					ent:SetPos(hitent:EyePos())
					ent:SetOwner(hitent)
					ent:SetParent(hitent)
					ent:Spawn()
				end

				hitent:TakeDamage(1, pl, carry)

				carry:Remove()

				return
			end
		end
	end
end
end]]

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
	if not pl:IsOnGround() and pl:WaterLevel() < 2 then
		pl:EndState(true)
	else
		local carry = pl:GetCarry()
		if not carry:IsValid() or carry:GetClass() ~= "prop_carry_trashbin" then
			pl:EndState(true)
			return
		end

		if CurTime() < pl:GetStateStart() + self.Time then return end

		if SERVER then
			local comp = pl:ShouldCompensate()

			if comp then
				pl:LagCompensation(true)
			end

			for _, tr in ipairs(pl:GetTargets()) do
				local hitent = tr.Entity
				if hitent:IsPlayer() then
					local ent = ents.Create("prop_trashbin")
					if ent:IsValid() then
						ent:SetPos(hitent:EyePos())
						ent:SetOwner(hitent)
						ent:SetParent(hitent)
						ent:Spawn()
						ent:SetColor(Color(255, 255, 255, 176) )
						ent:SetRenderMode( RENDERMODE_TRANSCOLOR )
						ent:EmitSound("taunts/pain/groundpound2.wav")
					end

					hitent:TakeDamage(1, pl, carry)
					hitent:ThrowFromPosition(pl:GetPos() + Vector(0, 0, -24), 100, true)
					carry:Remove()

					break
				end
			end

			if comp then
				pl:LagCompensation(false)
			end
		end

		pl:EndState(true)
	end
end

function STATE:CalcMainActivity(pl, velocity)
	pl.CalcSeqOverride = pl:LookupSequence("seq_preskewer")
end

function STATE:UpdateAnimation(pl, velocity, maxseqgroundspeed)
	pl:SetCycle((1 - math.Clamp((CurTime() - pl:GetStateStart()) / self.Time, 0, 1)) ^ 2 * 0.85 + 0.15)
	pl:SetPlaybackRate(0)

	return true
end
