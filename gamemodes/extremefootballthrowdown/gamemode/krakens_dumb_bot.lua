--[[ The self deprecation is part of the point. It's certainly dumb in the fact that it doesn't know how to throw well to score or use items.
	It uses the most pragmatic strategies - just punching and charging.
	Its pathfinding is high because of Nextbot integration.
	It's reasonably competent? On touch-score maps, a bot can rival a player.]]

hook.Add( "StartCommand", "KrakensNextbot", function( ply, cmd )
	if ( ply:IsBot() and ply:Alive() ) then
		
	if ply:GetNWEntity("chasetarget"):IsValid() then
		
	local chasetarget = ply:GetNWEntity("chasetarget")
	local aimangle = (chasetarget:GetPos() - ply:GetPos()):Angle()
	cmd:SetViewAngles( aimangle )
	cmd:SetForwardMove(900) 
	cmd:SetButtons( IN_FORWARD )
	if ply:GetCarrying():IsValid() or ply:GetState() == STATE_THROW then
	chasetarget:SetNWBool("IsCapping",true)
		local _ents = ents.FindInSphere( ply:GetPos(), 400 )
		
		local bab_the_booie = false
		
	for k,v in ipairs( _ents ) do
		if chasetarget:HaveEnemy() and v:IsPlayer() and v == chasetarget:GetEnemy() then
			bab_the_booie = true --the enemy are here throw the thing
		end
		
		if ( (v:GetClass() == "prop_goal" or v:GetClass() == "trigger_goal") and v.m_ScoreType == 2) then
		chasetarget:SetNWBool("ShouldIStayOrShouldIThrow",true)
		
		if (ply:CanThrow() or ply:GetState() == STATE_THROW) and chasetarget:GetNWBool("IfIThrow",true) and not bab_the_booie then
				cmd:SetButtons( IN_ATTACK2 )
				chasetarget:SetNWBool("ShouldIStayOrShouldIThrow",false)
			end
		--	chasetarget:SetPos(v:GetPos())
		--[[chasetarget:SetEnemy(chasetarget)
			if ply:CanMelee() then
				cmd:SetButtons( IN_ATTACK2 )
		end]]--
			elseif ( v != ply and v:IsPlayer() and v:Alive() and !v:IsBot() and v:Team() == ply:Team() and !v:GetCarrying():IsValid()) then
			-- We found one so lets set it as our "enemy" and return true
			if chasetarget.NextRetargetBall <= CurTime() and GAMEMODE:GetBall():GetLastCarrier() == v then
				chasetarget.NextRetargetBall = CurTime() + chasetarget.RetargetBallTime
				GAMEMODE:GetBall():SetLastCarrier(ply)
			end
			chasetarget:SetNWBool("ShouldIStayOrShouldIThrow",false)
			if (GAMEMODE:GetBall():GetLastCarrier() != v and chasetarget.NextRetargetBall <= CurTime()) or ply:GetState() == STATE_THROW then
			chasetarget:SetEnemy(v)
			chasetarget:SetPos(v:GetPos()+Vector(0,0,-32))
			if v:GetState() == STATE_WAVE then
				--chasetarget:SetPos(ply:GetPos())
				chasetarget:SetEnemy(nil)
			elseif (ply:CanThrow() and math.AngleDifference(v:GetAngles().y,ply:GetAngles().y) > 90) or ply:GetState() == STATE_THROW then
				cmd:SetButtons( IN_ATTACK2 )
				if v:CanCharge() or v:GetState() == STATE_KNOCKEDDOWN then
				cmd:SetButtons( IN_ATTACK )
				chasetarget.NextRetargetBall = CurTime() + chasetarget.RetargetBallTime
				end
			end
			return true
			end
		end
	end
else
	chasetarget:SetNWBool("IsCapping",false)
	end
	
	if chasetarget:GetNWBool("SwingAttack") and !ply:CanCharge() then
	if ply:CanMelee() and ply:WaterLevel() < 2 then
	cmd:SetButtons( IN_ATTACK )
	end
	chasetarget:SetEnemy(nil)
	chasetarget:SetNWBool("SwingAttack",false)
	end
	
	end
	end
end )