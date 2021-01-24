if CLIENT then 
function GM:TeamScored(teamid, hitter, points, homerun)
	self.CurrentTransition = math.random(#TRANSITIONS)

	if not MySelf:IsValid() then return end

	if teamid == MySelf:Team() or not team.Joinable(MySelf:Team()) then
		surface.PlaySound("taunts/victory/win"..math.random(13)..".mp3")
	else
		surface.PlaySound("npc/dog/dog_on_dropship.wav")
	end

	self.RoundWinner = teamid
	self.RoundEndScroll = 0
	self.RoundEndCameraTime = RealTime()
	self.RoundHomeRun = homerun
end
end