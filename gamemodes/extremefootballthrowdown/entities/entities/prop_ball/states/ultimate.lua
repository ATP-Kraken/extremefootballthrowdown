STATE.Name = "Ultimate Ball"

if SERVER then
	function STATE:Start(ball, samestate)
		ball:EmitSound("passtime/crowd_cheer.wav", 90, 100)
	end
	
	function STATE:End(ball)
		ball:EmitSound("npc/barnacle/barnacle_die1.wav", 90, 100)
		local carrier = ball:GetCarrier()
		if carrier:IsValid() and carrier:IsPlayer() then
			carrier:SetArmor(0)
		end
	end
	
	function STATE:CarrierChanged(ball, newcarrier, oldcarrier)
		if oldcarrier:IsValid() and oldcarrier:IsPlayer() then
			oldcarrier:SetArmor(0)
		end
	end
	
end

function STATE:PrimaryAttack()
	local owner = GAMEMODE:GetBall():GetCarrier()
	if owner:CanMelee() then
		local state = STATE_BREAKDANCE

		owner:SetState(state, STATES[state].Time)
	end
end


function STATE:Think(ball)
		local carrier = ball:GetCarrier()
		if carrier:IsValid() and carrier:IsPlayer() then
			if SERVER then
			for _, hitent in ipairs(ents.FindInSphere( carrier:GetPos(), 70 )) do
				if hitent:IsPlayer() and hitent:Team() != carrier:Team() and not hitent:ImmuneToAll() and (hitent:GetState() != STATE_KNOCKEDDOWN and hitent:GetState() != STATE_KNOCKDOWNRECOVER and hitent:GetState() != STATE_SPINNYKNOCKDOWN) then
					hitent:ThrowFromPosition(carrier:GetLaunchPos(), 700, true, carrier)
					hitent:EmitSound("weapons/physcannon/superphys_launch"..math.random(4)..".wav",60,math.random(100,120))
					--carrier:ViewPunch(VectorRand():Angle() * (math.random(2) == 1 and -1 or 1) * 0.1)
					hitent:SetArmor(100)
					local effectdata = EffectData()
					effectdata:SetOrigin(hitent:EyePos())
					effectdata:SetNormal(Vector(0,0,0))
					effectdata:SetEntity(hitent)
					util.Effect("punchhit", effectdata, true, true)
					
				end
			end
			end
			
			if carrier:CanMelee() and carrier:KeyDown(IN_ATTACK) then
		local state = STATE_BREAKDANCE

		carrier:SetState(state, STATES[state].Time)
	end
		end
end

function STATE:GetBallColor(ball, carrier)
	return Color(HSVtoRGB((CurTime() * 180) % 360))
end

if not CLIENT then return end

local vecGrav = Vector(0, 0, 20)
function STATE:PostDraw(ball)
	if CurTime() < ball.NextStateEmit then return end
ball.NextStateEmit = CurTime() + 0.01

local carrier = ball:GetCarrier()
local vel = carrier:IsValid() and carrier:GetVelocity() or ball:GetVelocity()
local col = self:GetBallColor(ball)
local pos = ball:GetPos()

local emitter = ParticleEmitter(pos)
emitter:SetNearClip(16, 24)

for i=1, 2 do
	local particle = emitter:Add("sprites/glow04_noz", pos)
	particle:SetDieTime(math.Rand(2.3, 2.5))
	particle:SetStartSize(math.Rand(6, 18))
	particle:SetEndSize(0)
	particle:SetStartAlpha(255)
	particle:SetEndAlpha(255)
	particle:SetVelocity(VectorRand() * math.Rand(2, 292) + vel * 0.8)
	particle:SetAirResistance(100)
	particle:SetGravity(vecGrav)
	particle:SetCollide(true)
	particle:SetBounce(1)
	particle:SetRoll(math.Rand(0, 360))
	particle:SetRollDelta(math.Rand(-32, 32))
	particle:SetColor(col.r, col.g, col.b)
end

emitter:Finish()
end
