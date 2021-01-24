STATE.Time = 0.1

function STATE:Started(pl, oldstate)
	pl:ResetJumpPower(0)
	if SERVER then pl:PlayVoiceSet(VOICESET_THROW) end
end

function STATE:Move(pl, move)
	move:SetSideSpeed(0)
	move:SetForwardSpeed(0)
	move:SetMaxSpeed(0)
	move:SetMaxClientSpeed(0)
	
	return MOVE_STOP
end

function STATE:Think(pl)
	if not pl:IsOnGround() and pl:WaterLevel() < 2 then
		pl:EndState(true)
		elseif pl:KeyDown(IN_ATTACK) then
			pl:EndState(true)
			elseif not pl:KeyDown(IN_ATTACK2) then
				if SERVER then
			pl:GetCarry():Drop()
			self:GoToNextState(pl)
				end
			
		end
	end

function STATE:Ended(pl, newstate)
	pl:Freeze(false)
end

if SERVER then
	function STATE:GoToNextState(pl)
		pl:SetState(STATE_BOOTKICK, 0.5)
		return true
	end
end

function STATE:IsIdle(pl)
	return false
end

function STATE:CanPickup(pl, ent)
	return false
end

function STATE:CalcMainActivity(pl, velocity)
	pl.CalcSeqOverride = pl:LookupSequence("idle_pistol")
end

if not CLIENT then return end

function STATE:GetCameraPos(pl, camerapos, origin, angles, fov, znear, zfar)
	pl:ThirdPersonCamera(camerapos, origin, angles, fov, znear, zfar, pl:GetStateEnd() == 0 and math.Clamp((CurTime() - pl:GetStateStart()) / 0.2, 0, 1) or 1)
end

function STATE:ShouldDrawCrosshair()
	return true
end

function STATE:ShouldDrawAngleFinder()
	return true
end
