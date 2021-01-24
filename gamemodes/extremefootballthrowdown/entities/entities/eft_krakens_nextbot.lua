AddCSLuaFile()

ENT.Base 			= "base_nextbot"
ENT.Spawnable		= true
function ENT:Initialize()
	self:SetHealth(1000000)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self:SetModel( "models/editor/playerstart.mdl" )
	
	if self:GetNWInt("teamid",0) == TEAM_RED then
		self:SetMaterial("models/shiny")
		self:SetColor(Color(255,20,20))
		self:SetNoDraw( true )
		elseif self:GetNWInt("teamid",0) == TEAM_BLUE then
		self:SetMaterial("models/shiny")
		self:SetColor(Color(60,80,255))
		self:SetNoDraw( true )
		else
		self:SetNoDraw( false )
	end
	--self:SetModel( "models/hunter.mdl" )
	self.LoseTargetDist	= 2000	-- How far the enemy has to be before we lose them
	self.LoseBallDist	= 2000	-- How far the ball has to be before we lose them
	self.SearchRadius 	= 1000	-- How far to search for enemies
	self.RetargetBallTime = 0.5 --How long from losing an enemy to going
	self.NextRetargetBall = CurTime() + 2
end

----------------------------------------------------
-- ENT:Get/SetEnemy()
-- Simple functions used in keeping our enemy saved
----------------------------------------------------
function ENT:SetEnemy(ent)
	self.Enemy = ent
end
function ENT:GetEnemy()
	return self.Enemy
end

----------------------------------------------------
-- ENT:HaveEnemy()
-- Returns true if we have an enemy
----------------------------------------------------
function ENT:HaveEnemy()
	-- If our current enemy is valid
	if ( self:GetEnemy() and IsValid(self:GetEnemy()) ) then
		if self:GetEnemy():GetClass() == "eft_krakens_nextbot" and self:GetNWBool("IsCapping",false) then --goal capping
			
			return true --there is nothing to need
			elseif ( self:GetRangeTo(self:GetEnemy():GetPos()) > self.LoseTargetDist ) then -- If the enemy is too far
			-- If the enemy is lost then call FindEnemy() to look for a new one
			-- FindEnemy() will return true if an enemy is found, making this function return true
			if self:GetEnemy():GetClass() == "prop_ball" and self:GetOwner():IsValid() then
				if self.NextRetargetBall <= CurTime() then
					self.NextRetargetBall = CurTime() + self.RetargetBallTime
					self:SetPos(self:GetOwner():GetPos()) --retry looking for ball
				end
				return true
				else
				self.NextRetargetBall = CurTime() + self.RetargetBallTime
				return self:FindEnemy()
			end
			-- If the enemy is dead( we have to check if its a player before we use Alive() )
			elseif self:GetEnemy():GetClass() != "prop_ball" and ( self:GetEnemy():IsPlayer() and (!self:GetEnemy():Alive() or self:GetEnemy():WaterLevel() > 1 or self:GetEnemy():GetState() == STATE_KNOCKEDDOWN) ) then
			self.NextRetargetBall = CurTime() + self.RetargetBallTime/2 -- Knocked out enemy means go to the ball more
			return self:FindEnemy()		-- Return false if the search finds nothing
		end	
		-- The enemy is neither too far nor too dead so we can return true
		return true
		else
		-- The enemy isn't valid so lets look for a new one
		--self.NextRetargetBall = CurTime() + self.RetargetBallTime
		return self:FindEnemy()
	end
end

----------------------------------------------------
-- ENT:FindEnemy()
-- Returns true and sets our enemy if we find one
----------------------------------------------------
function ENT:FindEnemy()
	-- Search around us for entities
	-- This can be done any way you want eg. ents.FindInCone() to replicate eyesight
	local _ents = ents.FindInSphere( self:GetPos(), self.SearchRadius )
	-- Here we loop through every entity the above search finds and see if it's the one we want
	for k,v in ipairs( _ents ) do
		if ( v:IsPlayer() and v:WaterLevel() < 2 and v:Team() != TEAM_SPECTATOR and v:Team() != self:GetNWInt("teamid",0) and v:GetState() != STATE_KNOCKEDDOWN) then
			-- We found one so lets set it as our enemy and return true
			self:SetEnemy(v)
			return true
		end
	end
	if self.NextRetargetBall <= CurTime() then --Look for the ball if all else
		self:SetEnemy(GAMEMODE:GetBall())
		return true
		else
		-- We found nothing so we will set our enemy as nil (nothing) and return false
		self:SetEnemy(nil)
		return false
	end
end
----------------------------------------------------
-- ENT:RunBehaviour()
-- This is where the meat of our AI is
----------------------------------------------------
function ENT:RunBehaviour()
	-- This function is called when the entity is first spawned, it acts as a giant loop that will run as long as the NPC exists
	while ( true ) do
		-- Lets use the above mentioned functions to see if we have/can find a enemy
		
		if ( self:HaveEnemy() and !self:GetNWBool("IsCapping",false)) then
			-- Now that we have a enemy, the code in this block will run
			self.loco:FaceTowards(self:GetEnemy():GetPos())	-- Face our enemy
			self.loco:SetDesiredSpeed( 450 )		-- Set the speed that we will be moving at. Don't worry, the animation will speed up/slow down to match
			self.loco:SetAcceleration(900)			-- We are going to run at the enemy quickly, so we want to accelerate really fast
			self:ChaseEnemy( ) 						-- The new function like MoveToPos that will be looked at soon.
			self.loco:SetAcceleration(400)			-- Set this back to its default since we are done chasing the enemy
			-- Now once the above function is finished doing what it needs to do, the code will loop back to the start
			-- unless you put stuff after the if statement. Then that will be run before it loops
			elseif self:GetNWBool("IsCapping",false) then
			self.loco:SetDesiredSpeed( 450 )		-- Set the speed that we will be moving at. Don't worry, the animation will speed up/slow down to match
			self.loco:SetAcceleration(300)			-- We are going to run at the enemy quickly, so we want to accelerate really fast
			self:ChaseEnemy( ) 						-- The new function like MoveToPos that will be looked at soon.
			self.loco:SetAcceleration(400)			-- Set this back to its default since we are done chasing the enemy
			else
			-- Since we can't find an enemy, lets wander
			-- Its the same code used in Garry's test bot
			self:MoveToPos( self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 400 ) -- Walk to a random place within about 400 units (yielding)
			coroutine.wait(1.5)
		end
		-- At this point in the code the bot has stopped chasing the player or finished walking to a random spot
		-- Using this next function we are going to wait 2 seconds until we go ahead and repeat it 
		coroutine.wait(0.5)
		
	end
	
end

----------------------------------------------------
-- ENT:ChaseEnemy()
-- Works similarly to Garry's MoveToPos function
--  except it will constantly follow the
--  position of the enemy until there no longer
--  is an enemy.
----------------------------------------------------
function ENT:ChaseEnemy( options )
	
	local options = options or {}
	local path = Path( "Follow" )
	path:SetMinLookAheadDistance( options.lookahead or 300 )
	path:SetGoalTolerance( options.tolerance or 20 )
	if self:HaveEnemy() then
		path:Compute(self, self:GetEnemy():GetPos())
		else
		path:Compute( self, self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 10 )		-- Compute the path towards the enemy's position
	end
	
	if ( !path:IsValid() ) then return "failed" end
	if self:GetNWBool("IsCapping",false) then
		
		while ( path:IsValid() and self:GetNWBool("IsCapping",false) ) do --Alternative Goal finding loop
			
			if ( path:GetAge() > 0.5 ) then					-- Since we are following the player we have to constantly remake the path
				if self:GetNWBool("ShouldIStayOrShouldIThrow",false) then
				
				if self:GetNWInt("teamid",TEAM_RED) == TEAM_RED then 
					self:SetPos(GAMEMODE:GetGoalCenter(TEAM_BLUE))
					else
					self:SetPos(GAMEMODE:GetGoalCenter(TEAM_BLUE))
					end
				
				else
					
				if self:GetNWInt("teamid",TEAM_RED) == TEAM_RED then 
					path:Compute(self, GAMEMODE:GetGoalCenter(TEAM_BLUE))
					else
					path:Compute(self, GAMEMODE:GetGoalCenter(TEAM_RED))
				end
				
			end
		end
		path:Update( self )								-- This function moves the bot along the path
		
		if ( options.draw ) then path:Draw() end
		-- If we're stuck then call the HandleStuck function and abandon
		if ( self.loco:IsStuck() ) then
			self:HandleStuck()
			return "stuck"
		end
		
		coroutine.yield()
		
		end
		
		else	
		
		while ( path:IsValid() and self:HaveEnemy() and !self:GetNWBool("IsCapping",false) ) do
			
			if ( path:GetAge() > 0.1 ) then					-- Since we are following the player we have to constantly remake the path
				path:Compute(self, self:GetEnemy():GetPos())-- Compute the path towards the enemy's position again
			end
			path:Update( self )								-- This function moves the bot along the path
			
			if ( options.draw ) then path:Draw() end
			-- If we're stuck then call the HandleStuck function and abandon
			if ( self.loco:IsStuck() ) then
				self:HandleStuck()
				return "stuck"
			end
			
			coroutine.yield()
			
		end
		
	end
	
	return "ok"
	
end
---

function ENT:Think()
	if CLIENT then return end
	self:SetHealth(1000000)
	
	local owner = self:GetOwner()
	if owner:IsValid() and owner:IsPlayer() and owner:Alive() then
		
		if self:GetEnemy() == GAMEMODE:GetBall() and self:GetNWBool("IsCapping",false) then --You don't need to chase the ball when you have it.
			self:SetEnemy(nil)
			return
		end
		
		if self:GetNWBool("ShouldIStayOrShouldIThrow",false) then --Throw-score type behavior
		if self:GetNWInt("teamid",TEAM_RED) == TEAM_RED then 
					self:SetPos(GAMEMODE:GetGoalCenter(TEAM_BLUE))
					else
					self:SetPos(GAMEMODE:GetGoalCenter(TEAM_BLUE))
					end
		
		
			if (self:GetPos() - owner:GetPos()):Length2D() < 128 then --Only throw if close
			self:SetNWBool("IfIThrow",true)
			return
		else
			self:SetNWBool("IfIThrow",false)
			end
		end
		
		if self:WaterLevel() > 1 then --Nextbots can't swim. Humans can.
			if self:HaveEnemy() then
				self:SetPos(self:GetEnemy():GetPos())
				else
				self:SetPos(owner:GetPos())
			end
			return
		end
		
		if self.NextRetargetBall <= CurTime() and owner:GetVelocity():Length2DSqr() < 1 then
			self.NextRetargetBall = CurTime() + self.RetargetBallTime
			self:SetPos(owner:GetPos())
			self:SetEnemy(nil)
			self:SetNWBool("ShouldIStayOrShouldIThrow",false)
			return
		end
		
		if self:HaveEnemy() then
			if (self:GetEnemy():IsPlayer() or (GAMEMODE:GetBall():GetCarrier():IsValid() and GAMEMODE:GetBall():GetCarrier() != self:GetOwner())) and (self:GetEnemy():GetPos() - owner:GetPos()):Length2D() < 75 then
				self:SetNWBool("SwingAttack",true)
				if self:GetEnemy():IsPlayer() and !owner:CanCharge() then
					self:SetEnemy(nil)
					self.NextRetargetBall = CurTime() + self.RetargetBallTime
				end
				
				else
				self:SetNWBool("SwingAttack",false)
			end
		end
		
		
		
		elseif owner and !self:GetNWBool("teamid",0) then
		SafeRemoveEntity(self)
		else
		if self:WaterLevel() > 1 then
			SafeRemoveEntity(self)
		end
	end
end