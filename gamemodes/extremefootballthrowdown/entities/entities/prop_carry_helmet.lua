AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "prop_carry_base"

ENT.Name = "Protective Headgear"

ENT.IsPropWeapon = true

ENT.Model = Model("models/player/items/heavy/football_helmet.mdl")
ENT.ThrowForce = 850
--ENT.AttachmentOffset = Vector(-97, -1, 0)
--ENT.AttachmentAngles = Angle(180, 90, 90)

ENT.BoneName = "ValveBiped.Bip01_Spine4"
ENT.AttachmentOffset = Vector(-69, -48.5, 0)
ENT.AttachmentAngles = Angle(180,-120, -90)

ENT.Mass = 40

ENT.AllowDuringOverTime = false

function ENT:Initialize()
	self.BaseClass.Initialize(self)
	self:SetPos(self:GetPos()+Vector(0,0,20))
	self:SetModelScale(1.1, 0)
	self:SetSkin(math.random(0,1))
	
	for k, v in pairs(ents.FindInSphere(self:GetPos(),700)) do 
		if v:IsPlayer() then
			if v:Team() == TEAM_RED then
			self:SetSkin(0)
		elseif v:Team() == TEAM_BLUE then
			self:SetSkin(1)
			end
		end
		end
	
	self.NextTouch = {}
end

function ENT:PrimaryAttack(pl)
	if pl:CanMelee() then
		pl:SetState(STATE_PUNCH1, STATES[STATE_PUNCH1].Time)
	end

	return true
end

function ENT:SecondaryAttack(pl)
	if pl:CanThrow() then
	self.m_TeamPickupImmunity = CurTime() + 0.25
	if SERVER then
		self:GetLastCarrier():SetArmor( 0 )
		self:Drop()
		end
	else if pl:CanCharge() then
		pl:SetState(STATE_DIVETACKLE, STATES[STATE_DIVETACKLE].Time)
	end
	end
	
	return true
end

function ENT:Move(pl, move)
	move:SetMaxSpeed(move:GetMaxSpeed() * 0.95)
	move:SetMaxClientSpeed(move:GetMaxClientSpeed() * 0.95)
end

function ENT:GetImpactSpeed()
	return self:GetLastCarrier():IsValid() and 300 or 600
end



if CLIENT then

function ENT:OnThink()
	if self:GetCarrier():IsValid() and self:GetCarrier():IsPlayer() then
	if self:GetCarrier():Team() == TEAM_RED then
		self:SetSkin(0)
		elseif self:GetCarrier():Team() == TEAM_BLUE then
			self:SetSkin(1)
			end
	end
end
end


if CLIENT then return end

function ENT:OnThink()
	
	if self:GetCarrier():IsValid() and self:GetCarrier():IsPlayer() then
	self:GetCarrier():SetArmor( 100 )
elseif self:GetLastCarrier():IsValid() and self:GetLastCarrier():IsPlayer() then
	if (self:GetLastCarrier():GetState() == STATE_KNOCKEDDOWN or self:GetLastCarrier():GetState() == STATE_SPINNYKNOCKDOWN) then
	self:GetLastCarrier():EmitSound("common/null.wav",100,100,1,CHAN_VOICE)
	self:GetLastCarrier():EmitSound("EFTaunts.HelmetBlock")
	self:GetLastCarrier():SetStateEnd(CurTime()+1.3)
	
	self.m_TeamPickupImmunity = CurTime() + 0.25
	self:EmitSound("physics/metal/metal_box_break1.wav",65,100)
	self:GetPhysicsObject():SetVelocity( -1 * self:GetPhysicsObject():GetVelocity())
	
	for k, v in pairs(ents.FindInSphere(self:GetLastCarrier():GetPos(),500)) do 
		if v:IsPlayer() then
		v:SetVelocity( -0.7*v:GetVelocity())
		end
		end
	
	end
	
	--self:GetLastCarrier():SetArmor( 0 )
	self:SetLastCarrier(NULL)
	
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

	self:EmitSound("player/taunt_helmet_hit.wav", 72, math.Rand(85, 135))
end

function ENT:PhysicsCollide(data, phys)
	if data.Speed >= 150 then
		if math.random(2) > 1 then
		self:EmitSound("ui/item_helmet_drop.wav",math.min(data.Speed/4.5,100),math.Rand(65, 115))
	else
		self:EmitSound("ui/item_helmet_pickup.wav",math.min(data.Speed/4.5,100),math.Rand(65, 115))
		end
		self:NextThink(CurTime())
	end
end

function ENT:OnTouch(ent)
	if ent:IsPlayer() and ent:Alive() and self:GetVelocity():Length() >= self:GetImpactSpeed() and ent:Team() ~= self:GetLastCarrierTeam() and CurTime() >= (self.NextTouch[ent] or 0) then
		self.NextTouch[ent] = CurTime() + 0.5
		self.TouchedEnemy = ent
	end
end
