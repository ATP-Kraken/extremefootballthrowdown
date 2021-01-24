sound.Add( {
	name = "EFTaunts.MeleeScream",
	channel = CHAN_BODY,
	pitch = { 95, 110 },
	sound = {
		"taunts/throw/hellogordon.mp3",
		"vo/scout_beingshotinvincible06.mp3",
		"vo/scout_stunballhittingit04.mp3",
		"vo/taunts/scout_taunts07.mp3",
		"vo/taunts/scout_taunts08.mp3",
		"vo/taunts/scout_taunts14.mp3",
		"vo/Heavy_niceshot02.mp3",
		"vo/Heavy_meleeing03.mp3",
		"taunts/throw/pizza.mp3",
		"taunts/throw/cutg.mp3",
		"taunts/throw/huhahu.mp3",
		"taunts/throw/sumodewa.mp3",
		"taunts/throw/sumodewa.mp3",
		"taunts/throw/sumodewa.mp3",
		"taunts/throw/sumodewa.mp3"
	}
} )
sound.Add( {
	name = "EFTaunts.Throw",
	channel = CHAN_AUTO,
	pitch = { 77, 83 },
	sound = {
		"taunts/throw/throw.wav",
		"taunts/throw/throw.wav",
		"taunts/throw/throw.wav",
		"taunts/throw/throw.wav",
		"npc/zombie/claw_miss1.wav",
		"npc/zombie/claw_miss2.wav",
		"npc/zombie/claw_miss1.wav",
		"npc/zombie/claw_miss2.wav",
		"passtime/projectile_swoosh1.wav",
		"passtime/projectile_swoosh2.wav",
		"passtime/projectile_swoosh3.wav",
		"passtime/projectile_swoosh4.wav",
		"passtime/projectile_swoosh5.wav",
		"passtime/projectile_swoosh6.wav",
		"player/pl_scout_jump1.wav",
		"player/pl_scout_jump2.wav",
		"player/pl_scout_jump3.wav",
		"player/pl_scout_jump4.wav"
	}
} )
sound.Add( {
	name = "EFTaunts.Tackle",
	channel = CHAN_BODY,
	pitch = { 95, 110 },
	sound = {
		"taunts/tackle/yodel.wav",
		"taunts/pain/reverb_fart.mp3",
		"taunts/tackle/goneguru.mp3",
		"taunts/tackle/majima1.mp3",
		"taunts/tackle/majima2.mp3",
		"taunts/tackle/pizzahut.mp3",
		"taunts/tackle/ridindir.mp3",
		"taunts/neeaah.mp3",
		"taunts/throw/throw.wav",
		"taunts/tackle/mario_yahoo.mp3",
		"taunts/tackle/mario_yahoo.mp3",
		"taunts/tackle/mario_yahoo.mp3"
	}
} )
sound.Add( {
	name = "EFTaunts.Drunk",
	channel = CHAN_AUTO,
	pitch = { 80, 100 },
	sound = {
		"taunts/throw/coldbrew.mp3",
		"taunts/fail/wacky_effects.mp3",
		"vo/demoman_gibberish02.mp3",
		"vo/demoman_gibberish08.mp3",
		"vo/demoman_gibberish10.mp3"
	}
} )
sound.Add( {
	name = "EFTaunts.HelmetBlock",
	channel = CHAN_AUTO,
	pitch = { 100, 100 },
	level = 100,
	volume = 1,
	sound = {
	"vo/Scout_beingshotinvincible05.mp3",
	"scientist/idontthinkso.wav",
	"taunts/coveredwars.mp3",
	"taunts/collegeball.mp3",
	"taunts/its_a_stone.mp3",
	"taunts/johnmadden.mp3",
	"taunts/whoopee.mp3",
	"taunts/pain/theman.mp3",
	"taunts/pain/bruh.mp3",
	"taunts/pain/bruh.mp3",
	"taunts/objection.mp3",
	"taunts/objection.mp3",
	"taunts/objection.mp3",
	"vo/engineer_no01.mp3",
	"vo/engineer_no01.mp3",
	"vo/engineer_no01.mp3"
	}
} )
sound.Add( {
	name = "EFTaunts.BallReset",
	channel = CHAN_AUTO,
	pitch = { 100, 100 },
	level = 100,
	volume = 1,
	sound = {
	"eft/ballreset.ogg",
	"eft/ballreset.ogg"
	}
} )

VOICESET_PAIN_LIGHT = 1
VOICESET_PAIN_MED = 2
VOICESET_PAIN_HEAVY = 3
VOICESET_DEATH = 4
VOICESET_HAPPY = 5
VOICESET_MAD = 6
VOICESET_TAUNT = 8
VOICESET_KILL = 7
VOICESET_THROW = 9
VOICESET_OVERHERE = 10
VOICESET_NULL = 0

local VoiceSets = {}

VoiceSets[0] = {
	[VOICESET_NULL] = {
		Sound("common/null.wav")
	},
	[VOICESET_THROW] = {
		Sound("vo/npc/male01/headsup01.wav"),
		Sound("vo/npc/male01/headsup02.wav"),
		--
		Sound("vo/scout_stunballhittingit01.mp3"),
		Sound("vo/scout_stunballhittingit02.mp3"),
		Sound("vo/Scout_stunballhit15.mp3"),
		Sound("vo/scout_battlecry01.mp3"),
		Sound("vo/sniper_JarateToss02.mp3"),
		Sound("vo/sniper_JarateToss03.mp3"),
		--
		Sound("taunts/throw/bababuoy.wav"),
		Sound("taunts/throw/yeet.mp3"),
		Sound("taunts/throw/its_a_football.mp3")
	},
	[VOICESET_PAIN_LIGHT] = {
		Sound("vo/npc/Barney/ba_pain02.wav"),
		Sound("vo/npc/Barney/ba_pain07.wav"),
		Sound("vo/npc/Barney/ba_pain04.wav"),
		Sound("vo/npc/male01/ow01.wav"),
		Sound("vo/npc/male01/ow02.wav"),
		Sound("vo/npc/male01/pain01.wav"),
		Sound("vo/npc/male01/pain02.wav"),
		Sound("vo/npc/male01/pain03.wav"),
		--
		Sound("vo/Scout_beingshotinvincible03.mp3"),
		--
		Sound("taunts/pain/maam.mp3"),
		Sound("taunts/pain/mama.wav"),
		Sound("scientist/sci_pain1.wav"),
		--
		Sound("taunts/pain/kitty_soft1.wav"),
		Sound("taunts/pain/kitty_soft2.wav"),
		Sound("taunts/pain/kitty_soft3.wav"),
		Sound("taunts/pain/kitty_soft4.wav"),
		Sound("taunts/pain/kitty_soft5.wav"),
		--
		Sound("taunts/pain/cat.mp3"),
		Sound("taunts/pain/roblox_oof.wav"),
		Sound("taunts/pain/doom_oof.wav"),
		Sound("taunts/pain/coconut.wav"),
		Sound("taunts/pain/whip.wav")
	},
	[VOICESET_PAIN_MED] = {
		Sound("vo/npc/Barney/ba_pain01.wav"),
		Sound("vo/npc/Barney/ba_pain08.wav"),
		Sound("vo/npc/Barney/ba_pain10.wav"),
		Sound("vo/npc/male01/pain04.wav"),
		Sound("vo/npc/male01/pain05.wav"),
		Sound("vo/npc/male01/pain06.wav"),
		Sound("ambient/voices/citizen_beaten1.wav"),
		Sound("ambient/voices/citizen_beaten5.wav"),
		--
		Sound("taunts/pain/ins_sicko.wav"),
		Sound("taunts/pain/slap_urgh.mp3"),
		Sound("scientist/sci_pain2.wav"),
		Sound("scientist/sci_pain3.wav"),
		Sound("scientist/sci_pain4.wav"),
		--
		Sound("taunts/pain/cat.mp3"),
		Sound("taunts/pain/doom_oof.wav"),
		Sound("taunts/pain/steve_oof.wav"),
		Sound("taunts/pain/myleg.wav"),
		Sound("taunts/pain/ouhnouh.wav"),
		Sound("taunts/pain/coconut.wav"),
		Sound("taunts/pain/whip.wav")
	},
	[VOICESET_PAIN_HEAVY] = {
		Sound("vo/npc/male01/pain07.wav"),
		Sound("vo/npc/male01/pain08.wav"),
		Sound("vo/npc/male01/pain09.wav"),
		Sound("vo/npc/male01/help01.wav"),
		Sound("vo/npc/Barney/ba_pain05.wav"),
		Sound("vo/npc/Barney/ba_pain06.wav"),
		Sound("vo/npc/Barney/ba_pain09.wav"),
		--
		Sound("taunts/pain/reverb_fart.mp3"),
		Sound("taunts/pain/fword.mp3"),
		Sound("taunts/pain/nownow.mp3"),
		Sound("taunts/pain/thwomp.mp3"),
		Sound("taunts/fail/lose5.mp3"),
		Sound("taunts/pain/maam.mp3"),
		--
		Sound("taunts/pain/kitty_hard1.wav"),
		Sound("taunts/pain/kitty_hard2.wav"),
		Sound("taunts/pain/kitty_hard4.wav"),
		Sound("taunts/pain/kitty_hard5.wav"),
		--
		Sound("taunts/pain/steve_oof.wav"),
		Sound("taunts/pain/myleg.wav"),
		Sound("taunts/pain/ouhnouh.wav"),
		Sound("taunts/pain/coconut.wav"),
		Sound("taunts/pain/whip.wav")
	},
	[VOICESET_DEATH] = {
		Sound("vo/npc/male01/no02.wav"),
		Sound("vo/npc/Barney/ba_ohshit03.wav"),
		Sound("vo/npc/Barney/ba_no01.wav"),
		Sound("vo/npc/Barney/ba_no02.wav"),
		Sound("vo/npc/male01/hacks01.wav"),
		--
		Sound("player/doubledonk.wav"),
		Sound("ui/killsound.wav"),
		Sound("ui/killsound_note.wav"),
		Sound("npc/fast_zombie/fz_scream1.wav"),
		--
		Sound("taunts/fail/zero_wah.wav"),
		Sound("taunts/pain/roblox_oof.wav"),
		Sound("taunts/pain/roblox_oof.wav"),
		Sound("taunts/fail/fnf_ballspercent.mp3"),
		Sound("taunts/fail/fnf_ballspercent.mp3"),
		Sound("taunts/pain/scream1.wav"),
		Sound("taunts/pain/scream2.wav"),
		Sound("taunts/pain/scream3.wav"),
		Sound("taunts/fail/smaaash.wav"),
		Sound("taunts/fail/rimshot.mp3"),
		Sound("taunts/fail/rimshot.mp3"),
		Sound("taunts/fail/damedane.mp3"),
		Sound("taunts/fail/lose3.mp3"),
		Sound("taunts/fail/neverlearnedtoread.mp3"),
		Sound("taunts/fail/tacobell.mp3"),
		Sound("taunts/fail/lose4.mp3"),
		Sound("taunts/neeaah.mp3"),
		Sound("taunts/mortal_ko.mp3"),
		Sound("taunts/mortal_ko.mp3")
	},
	[VOICESET_HAPPY] = {
		Sound("vo/npc/Barney/ba_gotone.wav"),
		Sound("vo/npc/Barney/ba_yell.wav"),
		Sound("vo/npc/Barney/ba_bringiton.wav"),
		Sound("vo/NovaProspekt/br_outoftime.wav"),
		Sound("vo/Citadel/br_mock06.wav"),
		Sound("vo/Citadel/br_mock09.wav"),
		Sound("vo/Citadel/br_mock13.wav"),
		Sound("vo/Citadel/br_mock05.wav"),
		Sound("vo/coast/odessa/male01/nlo_cheer01.wav"),
		Sound("vo/coast/odessa/male01/nlo_cheer02.wav"),
		Sound("vo/coast/odessa/male01/nlo_cheer03.wav"),
		Sound("vo/coast/odessa/male01/nlo_cheer04.wav"),
		--
		Sound("vo/scout_stunballhit06.mp3"),
		--
		Sound("taunts/victory/congrats.mp3"),
		Sound("taunts/victory/holy_shit.wav"),
		Sound("taunts/victory/mm_win.wav"),
		--
		Sound("misc/clap_single1.wav"),
		Sound("misc/clap_single1.wav"),
		Sound("misc/clap_single1.wav"),
		Sound("misc/clap_single2.wav"),
		Sound("misc/clap_single2.wav"),
		Sound("misc/clap_single2.wav")
	},
	[VOICESET_MAD] = {
		Sound("vo/k_lab/ba_getitoff01.wav"),
		Sound("vo/k_lab/ba_whoops.wav"),
		Sound("vo/npc/Barney/ba_damnit.wav"),
		Sound("vo/k_lab/ba_thingaway02.wav"),
		Sound("vo/k_lab/ba_cantlook.wav"),
		Sound("vo/k_lab/ba_whatthehell.wav"),
		Sound("vo/Streetwar/rubble/ba_damnitall.wav"),
		Sound("vo/npc/Barney/ba_no02.wav"),
		Sound("vo/npc/Barney/ba_no01.wav"),
		Sound("vo/Citadel/br_no.wav"),
		Sound("vo/Citadel/br_youfool.wav"),
		Sound("vo/Citadel/br_failing11.wav"),
		Sound("vo/k_lab/br_tele_02.wav"),
		Sound("vo/Citadel/br_ohshit.wav"),
		Sound("vo/Streetwar/rubble/ba_tellbreen.wav"),
		--
		Sound("vo/heavy_jeers07"),
		Sound("vo/heavy_jeers09"),
		--
		Sound("scientist/shutup2.wav"),
		Sound("scientist/sci_pain2.wav"),
		Sound("taunts/fail/fightingfor.mp3"),
		Sound("taunts/fail/onnathosedays.mp3"),
		Sound("taunts/fail/onnathosedays.mp3"),
		Sound("taunts/fail/kakyoin.mp3"),
		Sound("taunts/fail/dud.mp3"),
		Sound("taunts/fail/mamafer.mp3"),
		Sound("taunts/fail/mamafer.mp3"),
		Sound("taunts/fail/firespirit.mp3"),
		Sound("taunts/fail/joeljeer1.mp3"),
		Sound("taunts/fail/joeljeer2.mp3"),
		Sound("taunts/fail/joeljeer3.mp3"),
		Sound("taunts/fail/joeljeer4.mp3"),
		Sound("taunts/fail/uuuu_piece_dropped.mp3"),
		Sound("taunts/coveredwars.mp3"),
		Sound("taunts/fail/thelegend.mp3"),
		Sound("taunts/whoopee.mp3")
	},
	[VOICESET_KILL] = {
		Sound("vo/npc/Barney/ba_yell.wav"),
		Sound("vo/npc/Barney/ba_laugh02.wav"),
		Sound("vo/npc/Barney/ba_laugh04.wav"),
		Sound("vo/npc/Barney/ba_getoutofway.wav"),
		Sound("vo/npc/Barney/ba_ohyeah.wav"),
		Sound("vo/Citadel/br_youfool.wav"),
		Sound("vo/Citadel/br_laugh01.wav"),
		Sound("vo/Citadel/br_mock09.wav"),
		Sound("vo/Citadel/br_mock06.wav"),
		Sound("vo/npc/male01/pardonme01.wav"),
		Sound("vo/npc/male01/gordead_ans16.wav"),
		Sound("vo/npc/female01/gordead_ques17.wav"),
		--
		Sound("vo/scout_laughhappy02.mp3"),
		Sound("vo/scout_misc02.mp3"),
		Sound("vo/taunts/Scout_taunts04.mp3"),
		Sound("vo/Soldier_DominationScout07.mp3"),
		Sound("vo/taunts/soldier_taunts07.mp3"),
		Sound("vo/heavy_domination17.mp3"),
		Sound("vo/Engineer_dominationheavy02.mp3"),
		Sound("vo/Engineer_dominationscout01.mp3"),
		--
		Sound("taunts/fail/joeljeer1.mp3"),
		Sound("taunts/fail/joeljeer2.mp3"),
		Sound("taunts/fail/joeljeer3.mp3"),
		Sound("taunts/fail/joeljeer4.mp3"),
		Sound("taunts/fail/uuuu_piece_dropped.mp3"),
		Sound("taunts/fail/thelegend.mp3"),
		Sound("taunts/collegeball.mp3"),
		Sound("taunts/its_a_stone.mp3"),
		Sound("taunts/johnmadden.mp3"),
		Sound("taunts/victory/mm_all.wav"),
		Sound("taunts/whoopee.mp3")
		
	},
	[VOICESET_TAUNT] = {
		Sound("vo/npc/Barney/ba_letsdoit.wav"),
		Sound("vo/npc/Barney/ba_letsgo.wav"),
		Sound("vo/npc/Barney/ba_bringiton.wav"),
		Sound("vo/npc/Barney/ba_gotone.wav"),
		Sound("vo/npc/Barney/ba_letsdoit.wav"),
		Sound("vo/npc/Barney/ba_letsgo.wav"),
		Sound("vo/npc/Barney/ba_bringiton.wav"),
		Sound("vo/npc/Barney/ba_gotone.wav"),
		Sound("vo/npc/Barney/ba_losttouch.wav"),
		Sound("vo/Citadel/br_gravgun.wav"),
		Sound("vo/npc/male01/excuseme02.wav"),
		Sound("vo/npc/male01/strider_run.wav"),
		Sound("vo/npc/male01/likethat.wav"),
		--
		Sound("vo/Scout_battlecry01.mp3"),
		Sound("vo/scout_autocappedintelligence02.mp3"),
		Sound("vo/scout_autocappedintelligence03.mp3"),
		Sound("vo/scout_autocappedintelligence03.mp3"),
		Sound("vo/Scout_invinciblechgunderfire01.mp3"),
		Sound("vo/Scout_invinciblechgunderfire01.mp3"),
		Sound("vo/Scout_invinciblechgunderfire03.mp3"),
		Sound("vo/Scout_invinciblechgunderfire03.mp3"),
		Sound("vo/taunts/soldier/soldier_tank_03.mp3"),
		--
		Sound("taunts/physics_real.mp3"),
		Sound("taunts/supermannotimetowaste.wav"),
		Sound("scientist/idontthinkso.wav"),
		Sound("taunts/groovy.mp3"),
		Sound("taunts/groovy.mp3"),
		Sound("taunts/pass/yoinky.mp3"),
		Sound("taunts/pass/yoinky.mp3"),
		Sound("taunts/pass/shimmering_lifeprize.mp3"),
		Sound("taunts/pass/distract_sports.mp3"),
		Sound("taunts/johnmadden.mp3"),
		Sound("taunts/coveredwars.mp3"),
		Sound("taunts/gooutside.mp3"),
		Sound("taunts/victory/mm_win.wav"),
		Sound("taunts/victory/mm_win.wav"),
		Sound("taunts/throw/how_well_you_can_catch.mp3"),
	},
	[VOICESET_OVERHERE] = {
		Sound("vo/Streetwar/sniper/ba_overhere.wav"),
		Sound("vo/npc/male01/overhere01.wav"),
		Sound("vo/npc/female01/readywhenyouare02.wav"),
		--
		Sound("vo/Scout_award05.mp3"),
		Sound("vo/Scout_helpme02.mp3"),
		Sound("vo/Spy_helpme03.mp3"),
		Sound("vo/heavy_needdispenser01.mp3"),
		Sound("vo/engineer_moveup01.mp3"),
		Sound("vo/sniper_award01.mp3"),
		--
		Sound("taunts/johnmadden.mp3"),
		Sound("taunts/pass/newpass.mp3"),
		Sound("taunts/pass/papa.mp3"),
		Sound("taunts/pass/mario_throwme.mp3")
	}
}

VoiceSets[TEAM_RED] = {
		
}

VoiceSets[TEAM_BLUE] = {

}

local meta = FindMetaTable("Player")
if not meta then return end

local empty = {}
function meta:GetVoiceSet(set)
		if VoiceSets[0][set] then return VoiceSets[0][set] end

	return empty
end

function meta:PlayVoiceSet(set, level, pitch, volume)
	local snd = table.Random(self:GetVoiceSet(set))
	level = level or 80
	pitch = pitch or math.Rand(95, 105)
	volume = volume or 0.8

	if snd and SERVER then
		self:EmitSound(snd, level, pitch, volume, CHAN_VOICE)
	end

	return snd
end

function meta:PlayPainSound()
	if CurTime() < self.NextPainSound then return end

	local snds
	local health = self:Health()
	if self:WaterLevel() > 0 then
		snds = 0
		self:EmitSound("player/pl_drown"..math.random(3)..".wav")
	elseif 70 <= health or self:Armor() > 0 then
		snds = VOICESET_PAIN_LIGHT
	elseif 35 <= health then
		snds = VOICESET_PAIN_MED
	elseif health > 0 then
		snds = VOICESET_PAIN_HEAVY
	else
		snds = 0
	end
	snd = self:PlayVoiceSet(snds)
	
	if snd then
		self.NextPainSound = CurTime() + SoundDuration(snd) - 0.1
	end
end