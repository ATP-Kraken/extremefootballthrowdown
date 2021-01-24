STATE.Time = 2

function STATE:Started(pl, oldstate)
	pl:ResetJumpPower(0)
	pl:SetCycle(0)
	
	if SERVER then
	if !pl.WinnerTeam and !pl.LoserTeam then
		pl:PlayVoiceSet(VOICESET_OVERHERE)
	end
	end
	
	if pl.WinnerTeam or pl.LoserTeam then -- Post-round taunting
		local state = STATE_WAVE_DANCE
	pl:EndState(true)
		timer.Simple(0.1,function() pl:SetState(state, STATES[state].Time) end)
	end
	
end

function STATE:IsIdle(pl)
	return false
end

function STATE:CanPickup(pl, ent)
	return true
end

function STATE:Move(pl, move)
	move:SetSideSpeed(0)
	move:SetForwardSpeed(0)
	move:SetMaxSpeed(0)
	move:SetMaxClientSpeed(0)

	return MOVE_STOP
end

function STATE:Think(pl)
	if not pl:IsOnGround() or pl:WaterLevel() >= 2 or pl:IsCarrying() or pl:KeyDown(IN_ATTACK) then
		pl:EndState(true)
	end
end

function STATE:UpdateAnimation(pl, velocity, maxseqgroundspeed)
	pl:SetCycle(math.Clamp((pl:GetStateEnd() - CurTime()) / self.Time, 0, 1))
	pl:SetPlaybackRate(0)

	return true
end

local Sequences = {"seq_wave_smg1"}
function STATE:CalcMainActivity(pl, velocity)
	pl.CalcSeqOverride = pl:LookupSequence("seq_wave_smg1")
end
