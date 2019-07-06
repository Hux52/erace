#define init
global.sprMenuButton = sprite_add("sprites/selectIcon/sprLaserCrystalSelect.png", 1, 0, 0);
global.sprPortrait = sprite_add("sprites/portrait/sprPortraitCursedLaserCrystal.png",1 , 30, 195);

// character select sounds
// global.sndSelect = sound_add("sounds/sndRatSelect.ogg");
// var _race = [];
// for(var i = 0; i < maxp; i++) _race[i] = player_get_race(i);
// while(true){
// 	//character selection sound
// 	for(var i = 0; i < maxp; i++){
// 		var r = player_get_race(i);
// 		if(_race[i] != r && r = "rat"){
// 			sound_play(global.sndSelect);
// 		}
// 		_race[i] = r;
// 	}
// 	wait 1;
// }

global.hitSounds = [
	sndBanditHit,
	sndSniperHit,
	sndRavenHit,
	sndScorpionHit,
	sndRatHit,
	sndGatorHit,
	sndBuffGatorHit,
	sndBigMaggotHit,
	sndSalamanderHurt
];

global.deathSounds = [
	sndBanditDie,
	sndRavenDie,
	sndScorpionDie,
	sndRatDie,
	sndGatorDie,
	sndBuffGatorDie,
	sndBigMaggotDie,
	sndSalamanderDead
];

#define create
// player instance creation of this race
// https://bitbucket.org/YellowAfterlife/nuclearthronetogether/wiki/Scripting/Objects/Player

// sprites
spr_idle = sprInvLaserCrystalIdle;
spr_walk = sprInvLaserCrystalIdle;
spr_hurt = sprInvLaserCrystalHurt;
spr_dead = sprInvLaserCrystalDead;
spr_fire = sprInvLaserCrystalFire; //for when it's firing lol good explanation right
spr_sit1 = sprMutant15GoSit;
spr_sit2 = sprMutant15Sit;

// sounds
snd_hurt = global.hitSounds[irandom(array_length(global.hitSounds) - 1)];
snd_dead = global.deathSounds[irandom(array_length(global.deathSounds) - 1)];
snd_charge = sndLaserCrystalCharge; //no idea what this is for
snd_laser = sndLaser;

// stats
maxspeed = 1.1;
team = 2;
maxhealth = 45;
spr_shadow_y = 8;

//laser stuff
laserCountBase = 4;
laserChargeBase = 24;
laserDelayBase = 5;
laserCooldownBase = 30;

laserCount = 4;
laserCharge = 24;
laserDelay = 5;
laserCooldown = 30;

laserDamage = 2;

laserFiring = false;
canLaser = true;

teleportAlarm = 0;
myFloor = noone;

// vars
melee = false;	// can melee or not


#define game_start
// executed after picking race and starting for each player picking this race
// player-specific global variable init


#define step
// executed within each player instance of this race after step
// most actives and passives handled here

// no weps
canswap = 0;
canpick = 0;

footstep = 10;

//passive: is floaty
friction = 0.2;

// sprite always faces the same way and doesn't flip
right = -1;

// constant movement
if(canwalk = 1){
	move_bounce_solid(true);
	motion_add(direction, maxspeed/2);
}

if(laserCooldown > 0){
	canLaser = false;
} else {
	canLaser = true;
}

if(button_pressed(index,"fire")){
	if(canLaser){
		laserFiring = true;
		sound_play(snd_charge);
	}
}

if(laserFiring){
	canwalk = false;
	sprite_index = spr_fire;
	laserCooldown = laserCooldownBase;
	if(laserCharge > 0){
		rand = random(360);
		if(random(100) < 100 * current_time_scale){
			with(instance_create(x + lengthdir_x(random_range(40,50),rand),y + lengthdir_y(random_range(40,50),rand),CustomObject)){
				name = "CustomLaserCharge";
				sprite_index = sprLaserCharge;
				image_index = (other.laserCharge / other.laserChargeBase)*4 +2;
				image_speed = 0;
				speed = random_range(2,3);
				direction = point_direction(x,y,other.x,other.y);
				on_step = script_ref_create(laser_charge_step);
				destX = other.x;
				destY = other.y;
			}
		}
		
		laserCharge -= 1 * current_time_scale;
	} else {
		if(laserCount > 0){
			if(laserDelay <= 0){
				//spawn laser
				sound_play_pitchvol(snd_laser, random_range(0.9,1.1), 0.6);
				d = point_direction(x,y,mouse_x[index],mouse_y[index]);
				with(instance_create(x,y,EnemyLaser)){
					damage = 2;
					team = other.team;
					direction = other.d + random_range(-3,3);

					image_angle = direction;
					alarm0 = 1;
				}
				laserCount -= 1;
				laserDelay = laserDelayBase;
			}
			laserDelay -= 1 * current_time_scale;
		} else {
			laserFiring = false; //stop firing
		}
	}
} else {
	//reset everything
	canwalk = true;
	laserCooldown -= 1 * current_time_scale;
	laserCharge = laserChargeBase;
	laserCount = laserCountBase;
}

//cursy particles
if(random(100) < 50 * current_time_scale){
	instance_create(x + random_range(-16,16), y + random_range(-16,16),Curse);
}

if(random(100) < 5 * current_time_scale){
	repeat(5){instance_create(x + random_range(-12,12), y + random_range(-16,16),Curse);}
}

// outgoing contact damage
if(collision_rectangle(x + 12, y + 10, x - 12, y - 10, enemy, 0, 1)){
	with(instance_nearest(x, y, enemy)){
		if(sprite_index != spr_hurt){
			projectile_hit_push(self, 20, 4);
		}
	}
}

//'portation
teleportAlarm -= current_time_scale;

if(teleportAlarm <= 0){
	//find floor
	radius = random_range(32, 64);
	ang = random(360);
	searchX = cos(ang) * radius;
	searchY = sin(ang) * radius;
	myFloor = instance_nearest(x + searchX - 16, y + searchY - 16, Floor);

	x = myFloor.x + sprite_get_width(myFloor.sprite_index)/2;
	y = myFloor.y + sprite_get_height(myFloor.sprite_index)/2;
	teleportAlarm = random_range(25, 75);
	myFloor = noone;
}

#define laser_charge_step
if(point_distance(x,y,destX,destY) <= 5){
	instance_destroy();
}

#define race_name
// return race name for character select and various menus
return "CURSED LASER CRYSTAL";


#define race_text
// return passive and active for character selection screen
return "CONTACT DAMAGE#SHOOTS @rLASERS#@wTELEPORTS";


#define race_portrait
// return portrait for character selection screen and pause menu
return global.sprPortrait;


#define race_mapicon
// return sprite for loading/pause menu map
return sprMapIconChickenHeadless;


#define race_swep
// return ID for race starting weapon
return 0;


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
	case 1: return "RAPID BURST";
	case 2: return "RADIAL BURST";
	default: return "";
}


#define race_ultra_text
// recieves ultra mutation index and returns description
switch(argument0){
	case 1: return "FIRE LASERS RAPIDLY";
	case 2: return "LASERS EVERYWHERE";
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
return false