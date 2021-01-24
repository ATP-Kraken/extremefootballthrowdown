STATE.Time = 100

function STATE:Started(pl, oldstate)
	pl:ResetJumpPower(0)
	pl:SetCycle(0)
	pl:SetStateInteger(math.random(9))
	if SERVER then
		if pl.WinnerTeam then
		pl:PlayVoiceSet(VOICESET_HAPPY)
	else
		pl:PlayVoiceSet(VOICESET_MAD)
		end
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
	if pl:KeyDown(IN_ATTACK) or pl:GetCycle() >= 0.99 then
		pl:EndState(true)
	end
end

function STATE:UpdateAnimation(pl, velocity, maxseqgroundspeed)
	pl:SetPlaybackRate(1)

	return true
end

function STATE:CalcMainActivity(pl, velocity)
	if pl.LoserTeam then
	pl.CalcSeqOverride = pl:LookupSequence("gesture_disagree_original") 
	elseif pl:GetStateInteger() == 9 then
	pl.CalcSeqOverride = pl:LookupSequence("gesture_agree_original")
	elseif pl:GetStateInteger() == 8 then
	pl.CalcSeqOverride = pl:LookupSequence("taunt_muscle_base")
	elseif pl:GetStateInteger() == 7 then
	pl.CalcSeqOverride = pl:LookupSequence("taunt_robot_base")
	elseif pl:GetStateInteger() == 6 then
	pl.CalcSeqOverride = pl:LookupSequence("taunt_dance_base")
	elseif pl:GetStateInteger() == 5 then
	pl.CalcSeqOverride = pl:LookupSequence("taunt_laugh_base")
	elseif pl:GetStateInteger() == 4 then
	pl.CalcSeqOverride = pl:LookupSequence("taunt_cheer_base")
	elseif pl:GetStateInteger() == 3 then
	pl.CalcSeqOverride = pl:LookupSequence("taunt_cheer_base")
	elseif pl:GetStateInteger() == 2 then
	pl.CalcSeqOverride = pl:LookupSequence("gesture_bow_original")
	else
	pl.CalcSeqOverride = pl:LookupSequence("gesture_salute_original")
	end
	
end
