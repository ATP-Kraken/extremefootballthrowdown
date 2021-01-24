AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "prop_carry_base"

ENT.Name = "Soccer Bomb"

ENT.IsPropWeapon = true

ENT.Model = Model("models/combine_helicopter/helicopter_bomb01.mdl")
ENT.ThrowForce = 0

ENT.BoneName = "ValveBiped.Bip01_R_Hand"

local MeleeStates = {
	STATE_PUNCH1,
	STATE_CHAIRATTACK,
	STATE_BEATINGSTICKATTACK,
	STATE_BIGPOLEATTACK,
	STATE_BOSTONBASH,
	STATE_HOMERUNBATATTACK,
	STATE_BOOTKICK,
	STATE_GETUPATTACK,
	STATE_KICK1
}
local LenientMeleeStates = {
	STATE_DIVETACKLE,
	STATE_BREAKDANCE,
	STATE_HIGHJUMP,
	STATE_BIKEKICK,
	STATE_PUNCH1
}

function ENT:SecondaryAttack(pl)
	if pl:CanThrow() then
		pl:SetState(STATE_PUNT_HOLD)
	end
	
	return true
end

function ENT:Move(pl, move)
	move:SetMaxSpeed(move:GetMaxSpeed() * 0.95)
	move:SetMaxClientSpeed(move:GetMaxClientSpeed() * 0.95)
end

function ENT:Drop()
	if SERVER then
		if !self.FuseTime then
			self.FuseTime = CurTime() + 8		
			self:EmitSound("weapons/grenade/tick1.wav")
			self.Exploded = false
			
		end
	end
	self:SetLastCarrier(self:GetCarrier())
	self:SetCarrier(nil)
end

function ENT:GetImpactSpeed()
	return self:GetLastCarrier():IsValid() and 200 or 450
end


function ENT:Explode(hitpos, hitnormal)
	hitpos = hitpos or self:GetPos()
	hitnormal = hitnormal or self:GetForward()
	
	local effectdata = EffectData()
	effectdata:SetOrigin(hitpos)
	effectdata:SetNormal(hitnormal)
	util.Effect("barrelexplosion", effectdata)
	
	util.BlastDamage(self, self:GetLastCarrier():IsValid() and self:GetLastCarrier() or self, hitpos, 300, 75)
	util.ScreenShake(hitpos, 500, 0.5, 1, 300)
	
	self:Remove()
end

if CLIENT then return end

function ENT:OnThink()
	
	
	if self.FuseTime then
		local TimeRemaining = self.FuseTime - CurTime()
		if  TimeRemaining <= 0 then
			if !self.Exploded then
				self:Explode(self:GetPos(), Vector(0,0,0))
			end
			
			elseif TimeRemaining <= 2 then
			
			if math.abs(TimeRemaining*4 - math.floor(TimeRemaining*4)) < 0.05 then
				self:EmitSound("weapons/grenade/tick1.wav",80,125)
				if self:GetSkin() == 1 then
					self:SetSkin(0)
					else
					self:SetSkin(1)
				end
			end	
			elseif TimeRemaining <= 4 then
			
			if math.abs(TimeRemaining*2 - math.floor(TimeRemaining*2)) < 0.05 then
				self:EmitSound("weapons/grenade/tick1.wav",80,110-TimeRemaining)
				if self:GetSkin() == 1 then
					self:SetSkin(0)
					else
					self:SetSkin(1)
				end
			end	
			elseif math.abs(TimeRemaining - math.floor(TimeRemaining)) < 0.05 then
			self:EmitSound("weapons/grenade/tick1.wav",80,100-TimeRemaining)
			if self:GetSkin() == 1 then
				self:SetSkin(0)
				else
				self:SetSkin(1)
			end
		end
	end
		local _ents = ents.FindInSphere( self:GetPos(), 90 )
		for k,v in ipairs( _ents ) do	
			if not v:IsPlayer() then return end
			if (MeleeStates[v:GetState()] and v:GetStateStart()+ 0.2 < CurTime() ) or LenientMeleeStates[v:GetState()] or (v != self:GetCarrier() and self.FuseTime and v:CanCharge()) then
				self.DieTime = CurTime() + self.LifeTime
				
				local dir = self:GetPos() - v:EyePos()
				dir:Normalize()
				local phys = self:GetPhysicsObject()
				if phys:IsValid() then
					local ang = dir:Angle()
					ang.pitch = -35
					phys:SetVelocityInstantaneous(ang:Forward() * 500)
				end
				if !self.NextDoof or self.NextDoof <= CurTime() then
					self:EmitSound("taunts/pain/coconut.wav")
					self.NextDoof = CurTime() + 0.2
					if self.FuseTime then
						self.FuseTime = math.min(self.FuseTime+1,CurTime()+8)
					else
						self.FuseTime = CurTime()+8
					end
				end
			end
		end
	
	if self.PhysicsData then
		self:HitObject(self.PhysicsData.HitPos, self.PhysicsData.HitNormal, self.PhysicsData.HitEntity)
		elseif self.TouchedEnemy then
		self:HitObject(nil, nil, self.TouchedEnemy)
	end
end

function ENT:HitObject(hitpos, hitnormal, hitent)
	self.PhysicsData = nil
self.TouchedEnemy = nil

self:NextThink(CurTime())

hitpos = hitpos or self:GetPos()
hitnormal = hitnormal or Vector(0, 0, 1)

if IsValid(hitent) and hitent:IsPlayer() and hitent:Team() ~= self:GetLastCarrierTeam() then
	hitent:EmitSound("npc/zombie/zombie_hit.wav", 75, math.Rand(90, 140))
hitent:ThrowFromPosition(hitent:GetPos() + Vector(0, 0, -16), 200, true)
hitent:TakeDamage(5, self:GetLastCarrier(), self)

local phys = self:GetPhysicsObject()
if phys:IsValid() then
	local vel = phys:GetVelocity() * 0.15
	vel.z = 300
	phys:SetVelocityInstantaneous(vel)
	phys:AddAngleVelocity(VectorRand():GetNormalized() * 420)
end
end

self:EmitSound("physics/metal/metal_canister_impact_hard"..math.random(3)..".wav")
end

function ENT:PhysicsCollide(data, phys)
	if data.Speed >= 150 then
		self:EmitSound("physics/metal/metal_solid_impact_soft"..math.random(3)..".wav")
		
		self:NextThink(CurTime())
	end
end

function ENT:OnTouch(ent)
	if ent:IsPlayer() and ent:Alive() and self:GetVelocity():Length() >= self:GetImpactSpeed() and ent:Team() ~= self:GetLastCarrierTeam() and CurTime() >= (self.NextTouch[ent] or 0) then
		self.NextTouch[ent] = CurTime() + 0.5
		self.TouchedEnemy = ent
	end
end
