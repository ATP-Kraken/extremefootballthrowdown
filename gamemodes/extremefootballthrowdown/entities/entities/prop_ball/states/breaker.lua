STATE.Name = "Breakdance Ball"

--STATE.NoGravityTime = 0.25

if SERVER then
	function STATE:Start(ball, samestate)
		ball:EmitSound("taunts/tackle/majima2.mp3", 90, 100)
		ball:PhysicsInit(SOLID_VPHYSICS)
	end

	function STATE:End(ball)
		ball:EmitSound("npc/barnacle/barnacle_die1.wav", 90, 100)
		ball:PhysicsInit(SOLID_VPHYSICS)
	end
end

function STATE:GetBallColor(ball, carrier)
	return Color(255, 10, 120)
end

function STATE:PrimaryAttack()
	local owner = GAMEMODE:GetBall():GetCarrier()
	if owner:CanMelee() then
		local state = STATE_BREAKDANCE

		owner:SetState(state, STATES[state].Time)
	end
end

function STATE:Think(ball)
	local owner = ball:GetCarrier()
if not owner:IsValid() then return end
	if owner:CanMelee() and owner:KeyDown(IN_ATTACK) then
		local state = STATE_BREAKDANCE

		owner:SetState(state, STATES[state].Time)
	end
end

if not CLIENT then return end



function STATE:Think(ball)
		--
end

function STATE:PreDraw(ball)
	render.SetColorModulation(0.25, 0.2, 0.2)
end

function STATE:PostDraw(ball)
	render.SetColorModulation(1, 1, 1)

	if CurTime() < ball.NextStateEmit then return end
	ball.NextStateEmit = CurTime() + 0.2

	local carrier = ball:GetCarrier()
	local vel = carrier:IsValid() and carrier:GetVelocity() or ball:GetVelocity()

	local size = math.Rand(14, 20)

	local pos = ball:GetPos()
	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(16, 24)

	for i=1, math.random(5, 7) do
		local particle = emitter:Add("sprites/glow04_noz", ball:GetPos())
		particle:SetDieTime(math.Rand(1.7, 2.5))
		particle:SetStartSize(10)
		particle:SetEndSize(4)
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(0)
		particle:SetVelocity(Vector(0,0,0))
		particle:SetAirResistance(64)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-15, 15))
		particle:SetGravity(Vector(0,0,0))
	end

	emitter:Finish()
end
