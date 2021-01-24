function STATE:Started(pl, oldstate)
	pl:ResetJumpPower(0)
	if SERVER then
	pl:SetArmor(0)
	end
end

function STATE:Ended(pl, newstate)
	if newstate == STATE_NONE then
		pl:SetNextMoveVelocity(pl:GetVelocity() + pl:GetStateVector())
	end
end

function STATE:IsIdle(pl)
	return false
end

function STATE:Move(pl, move)
	move:SetSideSpeed(2)
	move:SetForwardSpeed(2)
	move:SetMaxSpeed(2)
	move:SetMaxClientSpeed(2)

	--return MOVE_STOP
end

function STATE:CalcMainActivity(pl, velocity)
	if pl:WaterLevel() > 1 then
	pl.CalcSeqOverride = pl:LookupSequence("zombie_leap_mid")

	return true
	end
end