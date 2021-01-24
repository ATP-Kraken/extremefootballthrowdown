STATE.ExtraSpeed = 0
STATE.UpwardBoost = 300
STATE.HitTime = 0.2
STATE.Range = 64


function STATE:IsIdle(pl)
	return false
end

function STATE:Started(pl, oldstate)
	pl:Freeze(true)

	local ang = pl:EyeAngles()
	ang[1] = 0
	ang[3] = 0

	pl:SetGroundEntity(NULL)
	pl:SetLocalVelocity(pl:GetVelocity()*0.25 + Vector(0, 0, self.UpwardBoost))
	pl:ResetLuaAnimation("bikekick", nil, nil, 0.5)
	pl:SetStateBool(false)
	if SERVER then
			pl:EmitSound("npc/headcrab_poison/ph_jump"..math.random(3)..".wav", 72, math.Rand(67, 83))
			pl:SetArmor(100)
	end
	
	if SERVER then
		local ent = ents.Create("point_divetackletrigger")
		if ent:IsValid() then
			ent:SetOwner(pl)
			ent:SetParent(pl)
			ent:SetPos(pl:GetPos() + pl:GetForward() * 24)
			ent:Spawn()
		end
	end
end

function STATE:Ended(pl, newstate)
	pl:Freeze(false)
	pl:SetNWBool("HasChaseMusic",false)
	pl:SetStateBool(false)
	if SERVER then
		for _, ent in pairs(ents.FindByClass("point_divetackletrigger")) do
			if ent:GetOwner() == pl then
				ent:Remove()
			end
		end
	end
end

function STATE:ThinkCompensatable(pl)
	if SERVER and not pl:GetStateBool() and CurTime() >= pl:GetStateStart() + self.HitTime then
		pl:SetStateBool(true)

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
				if ballpos:Distance(eyepos) <= self.Range*3 and util.IsVisible(ballpos, eyepos) then
					local eyevector = pl:EyeAngles()
					eyevector.pitch = 0
					eyevector = eyevector:Forward() * -1

					local dir = ballpos - eyepos
					dir:Normalize()
					if eyevector:Dot(dir) >= 0 then
						if CurTime() >= (NEXTHOMERUN or 0) then
							NEXTHOMERUN = CurTime() + 5
							--GAMEMODE:SlowTime(0.25, 2)
						end

						ball.LastBigPoleHit = pl
						ball.LastBigPoleHitTime = CurTime()
						ball:SetLastCarrier(pl)
						ball:SetAutoReturn(0)
						if not ball:OnGround() then
						ball:SetState(_G["BALL_STATE_HOMING"],10)
						GAMEMODE:SlowTime(0.25, 2)
						end
						ball:EmitSound("taunts/fail/smaaash.wav", 70, math.Rand(95, 105))
						local phys = ball:GetPhysicsObject()
						if phys:IsValid() then
							local ang = dir:Angle()
							ang.pitch = 15
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

if SERVER then
function STATE:Think(pl)
	if pl:OnGround() or pl:WaterLevel() > 1 then
		for _, ent in pairs(ents.FindByClass("point_divetackletrigger")) do
			if ent:GetOwner() == pl then
				pl:SetNWBool("HasChaseMusic",false)
				ent:ProcessTackles()
			end
		end
	--[[else
		local heading = pl:GetVelocity()
		local speed = heading:Length()
		if 200 <= speed then
			heading:Normalize()
			local startpos = pl:GetPos()
			local tr = util.TraceHull({start = startpos, endpos = startpos + speed * FrameTime() * 2 * heading, mask = MASK_PLAYERSOLID, filter = pl:GetTraceFilter(), mins = pl:OBBMins(), maxs = pl:OBBMaxs()})
			if tr.Hit and tr.HitNormal.z < 0.65 and 0 < tr.HitNormal:Length() and not (tr.Entity:IsValid() and tr.Entity:IsPlayer()) then
				pl:KnockDown(3)
			end
		end]]
	end
end
end

function STATE:CalcMainActivity(pl, velocity)
	pl.CalcSeqOverride = pl:LookupSequence("taunt_persistence_base")

	return true
end

function STATE:UpdateAnimation(pl)
	pl:SetPlaybackRate(0)
pl:SetCycle(math.Clamp((CurTime() - pl:GetStateStart())*1.3,0,0.75))

	return true
end

RegisterLuaAnimation('bikekick', {
	FrameData = {
		{
			BoneInfo = {
				['ValveBiped.Bip01_Pelvis'] = {
					RF = 20
				},
			},
			FrameRate = 10
			},
		{
			BoneInfo = {
				['ValveBiped.Bip01_Pelvis'] = {
					RF = -300
				},
			},
			FrameRate = 4
			},
			{
			BoneInfo = {
				['ValveBiped.Bip01_Pelvis'] = {
					RF = -290
				},
			},
			FrameRate = 0.25
			}
	},
	RestartFrame = 2,
	Type = TYPE_STANCE,
	ShouldPlay = function(pl, sGestureName, tGestureTable, iCurFrame, tFrameData, fFrameDelta, fPower) -- This just automatically stops the sequence when not in the kick state
		if pl:GetState() == STATE_BIKEKICK then
		return true
	else
		return false
		end
	end
})