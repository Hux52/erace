#define init
global.sprMenuButton = sprite_add("sprites/sprGruntSelect.png", 1, 0, 0);
global.sprPortrait = sprite_add("sprites/sprPortraitRat.png",1 , 15, 185);

// character select sounds
var _race = [];
for(var i = 0; i < maxp; i++) _race[i] = player_get_race(i);
while(true){
	//character selection sound
	for(var i = 0; i < maxp; i++){
		var r = player_get_race(i);
		_race[i] = r;
	}
	wait 1;
}

#define create
// player instance creation of this race
// https://bitbucket.org/YellowAfterlife/nuclearthronetogether/wiki/Scripting/Objects/Player

// sprites
spr_idle = sprGruntIdle;
spr_walk = sprGruntWalk;
spr_hurt = sprGruntHurt;
spr_dead = sprGruntDead;
spr_sit1 = sprMutant15GoSit;
spr_sit2 = sprMutant15Sit;

// sounds- pick from male or female
if(random(1) < 0.5){
	snd_hurt = sndGruntHurtM;
	snd_dead = sndGruntDeadM;
	snd_wrld = sndGruntEnterM;
	snd_nade = sndGruntThrowNadeM;
}
else{
	snd_hurt = sndGruntHurtF;
	snd_dead = sndGruntDeadF;
	snd_wrld = sndGruntEnterF;
	snd_nade = sndGruntThrowNadeF;
}

// stats
maxspeed = 4;
team = 2;
maxhealth = 8;
spr_shadow_y = 0;
mask_index = mskPlayer;

// vars
melee = 0;	// can melee or not
roll_time = 0;	// rolling time
grenade_time = 0;	// grenade cooldown
can_grenade = true;

#define game_start
// executed after picking race and starting for each player picking this race
// player-specific global variable init


#define step
// executed within each player instance of this race after step
// most actives and passives handled here

// no weps
canswap = 0;
canpick = 0;

if(canspec){
	 // Roll Towards Mouse If Not Moving:
	if(button_pressed(index, "spec") && speed <= 0) direction = gunangle;

	 // Start Water Boost:
	if(skill_get(5)){
		 // Sound:
		if(button_pressed(index, "spec")){
			sound_play(sndFishRollUpg);
			sound_loop(sndFishTB);
		}

		 // Boost:
		if(button_check(index, "spec")) roll_time = 2;
	}

	 // Start Roll:
	else if(button_pressed(index, "spec") && !roll_time){
		roll_time = 10;		 // 10 Frame Roll
		sound_play(sndRoll); // Sound
		
	}
}
if(roll_time > 0){
	roll_time-= current_time_scale;

	 // Speedify:
	speed = maxspeed + 2;

	/// Throne Butt
	if(skill_get(5)){
		sprite_angle = direction - 90;	// Point Towards Direction
		instance_create(x,y,FishBoost);	// Water Particles
	}

	/// Roll (No Butt)
	else{
		canwalk = 0;				// Can't Use Movement Keys
		sprite_angle += 40 * right * current_time_scale;	// Rotate
		instance_create(x + random_range(-3, 3), y + random(6), Dust); // Dust Particles:
	}

	 // Bounce Off Walls:
	if(place_meeting(x + hspeed, y + vspeed, Wall)){
		move_bounce_solid(true);
		roll_time *= skill_get(5);
	}

	 // On Roll End:
	if(roll_time <= 0){
		sprite_angle = 0;		// Reset Rotation
		canwalk = 1;			// Can Use Movement Keys Again
		sound_stop(sndFishTB);	// Stop Water Boost Sound
	}
}

// grenade throw and alarm management
if(grenade_time <= 0){
	if(can_grenade = false){
		sound_play_pitch(sndIDPDNadeAlmost, random_range(1.4, 1.6));
	}
	can_grenade = true;
}else{
	can_grenade = false;
	grenade_time-= current_time_scale;
}
if(button_pressed(index, "pick") and can_grenade){
		sound_play_pitch(snd_nade, random_range(0.9, 1.1));
		with(instance_create(x, y, PopoNade)){
			creator = other;
			team = creator.team;
			direction = creator.gunangle;
			sprite_angle = direction;
			speed = 10;
			damage = 15;
			friction = 0;
		}
		grenade_time = 120;
	}

if(my_health <= 0){
	if(instance_exists(CustomHitme)){
		sq = instances_matching(CustomHitme, "name", "squad");
		if(array_length(sq) > 0){
			_to = sq[0];
		}
	}
	if(instance_exists(_to)){
		mod_script_call("mod","erace","respawn_as", true, _to.class, "squad");
	}
}
#define race_name
// return race name for character select and various menus
return "I.D.P.D. GRUNT";


#define race_text
// return passive and active for character selection screen
return "@sCAN @wROLL#@sTHROW @bGRENADES@b#FREEZE!";


#define race_portrait
// return portrait for character selection screen and pause menu
return global.sprPortrait;


#define race_mapicon
// return sprite for loading/pause menu map
return sprMapIconChickenHeadless;


#define race_swep
// return ID for race starting weapon
return "grunt";


#define race_avail
// return if race is unlocked
return 1;


#define race_menu_button
// return race menu button icon
sprite_index = global.sprMenuButton;

#define race_skins
// return number of skins the race has
return 1;


#define race_skin_avail
// return if skin is unlocked
return 1;

#define race_skin_button
// return skin switch button sprite
return sprMapIconChickenHeadless;


#define race_soundbank
// return build in race id for default sounds
return 0;


#define race_tb_text
// return description for Throne Butt
return "DOES NOTHING";


#define race_tb_take
// run when Throne Butt is taken
// player of race may not be alive at the time

#define race_ultra_name
// return a name for each ultra
// determines how many ultras are shown
switch(argument0){
	case 1: return "NOTHING";
	default: return "";
}


#define race_ultra_text
// recieves ultra mutation index and returns description
switch(argument0){
	case 1: return "DOES NOTHING";
	default: return "";
}


#define race_ultra_button
// called by ultra mutation button on creation
// recieves ultra mutation index
switch(argument0){
	case 1: return mskNone;
}


#define race_ultra_take
// recieves ultra mutation index
// called when ultra for race is picked
// player of race may not be alive at the time


#define race_ttip
// return character-specific tooltips
return choose("FREEZE!", "HANDS IN THE AIR", "BATON SWINGIN', JUSTICE BRINGIN'", "WEE WOO", "ON PATROL");