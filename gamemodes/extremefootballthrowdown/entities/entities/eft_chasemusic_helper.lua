
AddCSLuaFile()

DEFINE_BASECLASS( "base_anim" )

ENT.PrintName = "Exploding Bathtub"
ENT.Author = "DPh Kraken"

ENT.Editable = false
ENT.Spawnable = false
ENT.AdminOnly = false
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT --RENDERGROUP_OTHER

function ENT:SetupDataTables()
local mysound
local stopping = false
end

function ENT:Think()
	local p_1 = self:GetNWEntity("Player1",nil)
	local p_2 = self:GetNWEntity("Player2",nil)
	if SERVER then
		if p_1:IsValid() and p_2:IsValid() and p_1:Alive() and p_2:Alive() then
		self:SetPos((3*p_1:GetPos() + p_2:GetPos())/4)
		
		local distance = (p_1:GetPos() - p_2:GetPos()):Length2DSqr()
		
		if distance < 32768 then
		mysound:ChangePitch(100+(32768-distance)/320,0)
		mysound:ChangeVolume(math.Clamp((p_1:GetVelocity()+p_2:GetVelocity()):Length2DSqr()/60000,0,1),5)
		else
		mysound:ChangePitch(100,0)
		mysound:FadeOut(20)
		end
		
	elseif !stopping then
		stopping = true
		self:SetNWEntity("Player1",nil)
		self:SetNWEntity("Player2",nil)
		mysound:FadeOut(3)
		SafeRemoveEntityDelayed(self,3)
		end
	if math.Round(mysound:GetVolume(),6) <= 0 then
		SafeRemoveEntity(self)
	end
	end
end

function ENT:Initialize()
	
	-- We do NOT want to execute anything below in this FUNCTION on CLIENT
	if ( CLIENT ) then return end
	mysound = CreateSound(self,"music/grass_skirt_chase.mp3")
	mysound:Play()
	mysound:SetSoundLevel(120)
end

function ENT:OnRemove()
		if SERVER then
if self:GetNWEntity("Player1",nil):IsValid() then
	self:GetNWEntity("Player1"):SetNWBool("HasChaseMusic",false)
end
if self:GetNWEntity("Player2",nil):IsValid() then
	self:GetNWEntity("Player2"):SetNWBool("HasChaseMusic",false)
end
mysound:Stop()
		end

end

if ( SERVER ) then return end -- We do NOT want to execute anything below in this FILE on SERVER

--local matBall = Material( "editor/ambient_generic" )

function ENT:Draw()
	return false
	--render.SetMaterial( matBall )
	--render.DrawSprite( self:GetPos(), 64, 64, Color(175,255,25))
end
