STATE.Time = 1
STATE.HitTime = 0.2
STATE.FOV = 360
STATE.Range = 72

function STATE:CanPickup(pl, ent)
	return false
end

function STATE:Started(pl, oldstate)
	pl:ResetJumpPower(0)
	pl:SetStateBool(false)
	pl:ResetLuaAnimation("breakdance", nil, nil, 0.5)
	if SERVER then
		pl:EmitSound("weapons/bat_draw_swoosh"..math.random(2)..".wav", 72, math.Rand(93, 107),10)
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
			if hitent:IsPlayer() and (hitent:OnGround() or hitent:WaterLevel() > 1)and (hitent.CrossCounteredBy ~= pl or CurTime() >= (hitent.CrossCounteredTime or -math.huge) + 1) then
					pl:PunchHit(hitent, tr)
				end
		end
		elseif pl:KeyDown(IN_ATTACK) and CurTime() >= pl:GetStateStart()+0.7 then
		pl:SetLocalVelocity(pl:GetVelocity()*0.5)
		if SERVER then
		
		for _, tr in ipairs(pl:GetSweepTargets(self.Range, self.FOV, nil, nil, true)) do
			local hitent = tr.Entity
			if hitent:IsPlayer() and (hitent:OnGround() or hitent:WaterLevel() > 1)and (hitent.CrossCounteredBy ~= pl or CurTime() >= (hitent.CrossCounteredTime or -math.huge) + 1) then
					pl:PunchHit(hitent, tr)
				end
		end
				
		pl:EndState(true)
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
	pl.CalcSeqOverride = pl:LookupSequence("zombie_slump_rise_02_slow")
end

function STATE:UpdateAnimation(pl, velocity, maxseqgroundspeed)
	pl:SetCycle(0.6 * math.Clamp((CurTime() - pl:GetStateStart()) / self.Time, 0, 1) )
	pl:SetPlaybackRate(0)

	return true
end

RegisterLuaAnimation('breakdance', {
	FrameData = {
		{
			BoneInfo = {
				['ValveBiped.Bip01_Pelvis'] = {
					RR = -360
				},
			},
			FrameRate = 10
			},
		{
			BoneInfo = {
				['ValveBiped.Bip01_Pelvis'] = {
					RR = 10
				},
			},
			FrameRate = 4
			},
			{
			BoneInfo = {
				['ValveBiped.Bip01_Pelvis'] = {
					RR = 0
				},
			},
			FrameRate = 0.25
			}
	},
	RestartFrame = 2,
	Type = TYPE_STANCE,
	ShouldPlay = function(pl, sGestureName, tGestureTable, iCurFrame, tFrameData, fFrameDelta, fPower) -- This just automatically stops the sequence when not in the kick state
		if pl:GetState() == STATE_BREAKDANCE then
		return true
	else
		return false
		end
	end
})
