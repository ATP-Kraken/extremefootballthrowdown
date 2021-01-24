STATE.Time = 0.6
--STATE.Time = 0.6
STATE.HitTime = 0.33
STATE.Range = 64

function STATE:Started(pl, oldstate)
	pl:ResetJumpPower(0)
	pl:ResetLuaAnimation("bootkick", nil, nil, 0.5)
	pl:SetStateBool(false)
	
	if SERVER then
		pl:EmitSound("weapons/boxing_gloves_swing"..math.random(2)..".wav", 72, math.Rand(57, 73))
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

function STATE:ThinkCompensatable(pl)
	if not (pl:IsOnGround() and pl:WaterLevel() < 2) then
		pl:EndState(true)
	elseif SERVER and not pl:GetStateBool() and CurTime() >= pl:GetStateStart() + self.HitTime then
		pl:SetStateBool(true)
		if SERVER then
			pl:EmitSound("npc/footsteps/softshoe_generic6.wav", 45, math.random(97, 103))
		end

		local comp = pl:ShouldCompensate()

		if comp then
			pl:LagCompensation(true)
		end

		for _, tr in ipairs(pl:GetSweepTargets(self.Range, self.FOV, nil, nil, true)) do
			local hitent = tr.Entity
			if hitent:IsPlayer() and not hitent:ImmuneToAll() then
				pl:PunchHit(hitent, tr)
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
	pl.CalcSeqOverride = pl:LookupSequence("idle_fist")

	return true
end

RegisterLuaAnimation('bootkick', {
	FrameData = {
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_UpperArm'] = {
					RU = 17
				},
				['ValveBiped.Bip01_L_Clavicle'] = {
					RU = 5
				},
				['ValveBiped.Bip01_Spine4'] = {
					RF = -11
				},
				['ValveBiped.Bip01_Spine2'] = {
					RF = -10
				},
				['ValveBiped.Bip01_R_Calf'] = {
					RU = 33
				},
				['ValveBiped.Bip01_Head1'] = {
					RF = 27
				},
				['ValveBiped.Bip01_L_Thigh'] = {
					RR = -8,
					RF = -30
				},
				['ValveBiped.Bip01_R_Clavicle'] = {
					RU = -18
				},
				['ValveBiped.Bip01_Spine1'] = {
					RF = -12
				},
				['ValveBiped.Bip01_L_Foot'] = {
					RU = 7,
					RR = 17,
					RF = 11
				},
				['ValveBiped.Bip01_R_Thigh'] = {
					RU = 19,
					RF = 31
				}
			},
			FrameRate = 7.5
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_Forearm'] = {
					RU = -42
				},
				['ValveBiped.Bip01_L_UpperArm'] = {
					RU = 17
				},
				['ValveBiped.Bip01_L_Clavicle'] = {
					RU = 5
				},
				['ValveBiped.Bip01_Spine4'] = {
					RF = 2
				},
				['ValveBiped.Bip01_Spine2'] = {
					RF = 13
				},
				['ValveBiped.Bip01_Spine'] = {
					RU = -16,
					RF = 26
				},
				['ValveBiped.Bip01_L_Thigh'] = {
					RR = -1,
					RF = -30
				},
				['ValveBiped.Bip01_R_Clavicle'] = {
					RU = -18
				},
				['ValveBiped.Bip01_L_Foot'] = {
					RU = 7,
					RR = 17,
					RF = 11
				},
				['ValveBiped.Bip01_Head1'] = {
					RU = -17,
					RR = -20,
					RF = -43
				},
				['ValveBiped.Bip01_R_Calf'] = {
					RU = -1
				},
				['ValveBiped.Bip01_Spine1'] = {
					RF = 7
				},
				['ValveBiped.Bip01_R_Thigh'] = {
					RU = -90,
					RR = 13,
					RF = -13
				}
			},
			FrameRate = 20
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_Forearm'] = {
					RU = -42
				},
				['ValveBiped.Bip01_L_UpperArm'] = {
					RU = 17
				},
				['ValveBiped.Bip01_L_Clavicle'] = {
					RU = 5
				},
				['ValveBiped.Bip01_Spine4'] = {
					RF = 2
				},
				['ValveBiped.Bip01_R_Foot'] = {
					RR = 22
				},
				['ValveBiped.Bip01_Spine2'] = {
					RF = 13
				},
				['ValveBiped.Bip01_R_Calf'] = {
					RU = -2
				},
				['ValveBiped.Bip01_Head1'] = {
					RU = -17,
					RR = -20,
					RF = -43
				},
				['ValveBiped.Bip01_L_Foot'] = {
					RU = 7,
					RR = 17,
					RF = 11
				},
				['ValveBiped.Bip01_R_Clavicle'] = {
					RU = -18
				},
				['ValveBiped.Bip01_Spine'] = {
					RU = -16,
					RF = 26
				},
				['ValveBiped.Bip01_Spine1'] = {
					RF = 7
				},
				['ValveBiped.Bip01_L_Thigh'] = {
					RF = -30
				},
				['ValveBiped.Bip01_R_Toe0'] = {
					RU = -28
				},
				['ValveBiped.Bip01_R_Hand'] = {
					RU = 24
				},
				['ValveBiped.Bip01_R_Thigh'] = {
					RU = -78,
					RR = 13,
					RF = -13
				}
			},
			FrameRate = 6
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_Forearm'] = {
					RU = -42
				},
				['ValveBiped.Bip01_L_UpperArm'] = {
					RU = 17,
					RR = 26
				},
				['ValveBiped.Bip01_L_Clavicle'] = {
					RU = 5
				},
				['ValveBiped.Bip01_R_Clavicle'] = {
					RU = -18
				},
				['ValveBiped.Bip01_L_Foot'] = {
					RU = 7,
					RR = 17,
					RF = 11
				},
				['ValveBiped.Bip01_L_Thigh'] = {
					RR = -12
				}
			},
			FrameRate = 9
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_Forearm'] = {
					RU = -42
				},
				['ValveBiped.Bip01_L_UpperArm'] = {
					RU = 17,
					RR = 26
				},
				['ValveBiped.Bip01_L_Clavicle'] = {
					RU = 5
				},
				['ValveBiped.Bip01_R_Clavicle'] = {
					RU = -18
				},
				['ValveBiped.Bip01_L_Foot'] = {
					RU = 7,
					RR = 17,
					RF = 11
				},
				['ValveBiped.Bip01_L_Thigh'] = {
					RR = -12
				}
			},
			FrameRate = 1
		}
	},
	RestartFrame = 5,
	Type = TYPE_STANCE,
	ShouldPlay = function(pl, sGestureName, tGestureTable, iCurFrame, tFrameData, fFrameDelta, fPower) -- This just automatically stops the sequence when it's done.
		return iCurFrame < #tGestureTable.FrameData
	end
})
