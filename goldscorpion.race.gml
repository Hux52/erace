#define init
global.sprMenuButton = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAABAAAAAYCAYAAADzoH0MAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAADpSURBVDhPvZI9CgIxEEYHvIWttYWdpWfYI3gNK4s9huAJrKzt7Bc8g6UHEIToBF74ErKL4K7Fg2Qm38vPrj0uTXDMLEHtG6LAQ8v9LPJ/gYZVArWQYrvNIjga1nEtpNi9OwWHHT3YPucRajCN4HZchT4QDl3nU7f4BorXCOtpphPwDuV7eFCvA5mABexejpWa5HfBa23BIaTQA8KZrBas4YsZZ6fSRUP0CrxxaLehu54TPqfGuBSka2Evwwi8p2EE6QSjCQgRoKZzlbBhEkD8tjInoDVON55AF/CHIaJfShI0NFgT1Nc04Q2YTjeSiZKRigAAAABJRU5ErkJggg==", 1, 0, 0);


#define create
// player instance creation of this race
// https://bitbucket.org/YellowAfterlife/nuclearthronetogether/wiki/Scripting/Objects/Player

// sprites
spr_idle = sprGoldScorpionIdle;
spr_walk = sprGoldScorpionWalk;
spr_hurt = sprGoldScorpionHurt;
spr_dead = sprGoldScorpionDead;
spr_sit1 = sprMutant15GoSit;
spr_sit2 = sprMutant15Sit;

// sounds
snd_hurt = sndGoldScorpionHurt;
snd_dead = sndGoldScorpionDead;

// stats
maxspeed = 5;
team = 2;
maxhealth = 37;
spr_shadow = shd32;
spr_shadow_y = 5;
mask_index = mskPlayer;

// vars
cooldown = 0;	// cooldown for shooting
venom = 0;	// shooting duration
dir = 0;	// initial firing direction
died = 0;	// prevent frames after death


#define game_start
// executed after picking race and starting for each player picking this race
// player-specific global variable init


#define step
// executed within each player instance of this race after step
// most actives and passives handled here

// no weps
canswap = 0;
canpick = 0;

// special- shoot venom
if(button_pressed(index, "spec")){
	if(cooldown = 0){
		cooldown = 90;	// shoot venom again in 90 frames
		venom = 25;	// shoot venom for 25 frames
		dir = gunangle;	// initial direction, as you can't change firing direction once started
		spr_idle = sprGoldScorpionFire;
		spr_walk = sprGoldScorpionFire;
		sound_play_pitch(sndScorpionFireStart, 0.7);	// can't find the sound file for this, if any
	}
}

// while firing
if(venom > 0){
	canwalk = 0;	// no walking
	// sprite based on direction, as you can't fire right now
	if(dir > 90 and dir <= 270){
		right = -1;
	}
	else{
		right = 1;
	}
	sound_play_gun(sndScorpionFire, 0.2, 0.6);
	// ambient, slow spread of bullets
	with(instance_create(x, y, Bullet1)){
		var acc = 80;
		creator = other;
		team = creator.team;
		sprite_index = sprScorpionBullet;
		direction = other.dir + (random(creator.accuracy) * choose(1, -1) * random(acc));
		image_angle = direction;
		friction = 0;
		speed = 2;
		damage = 2;
	}
	// fast, concentrated bullets
	with(instance_create(x, y, Bullet1)){
		var acc = 20;
		creator = other;
		team = creator.team;
		sprite_index = sprScorpionBullet;
		direction = other.dir + (random(creator.accuracy) * choose(1, -1) * random(acc));
		image_angle = direction;
		friction = 0;
		speed = 7;
		damage = 2;
	}
	venom--;
}
else{
	// fix sprites when not firing
	spr_idle = sprGoldScorpionIdle;
	spr_walk = sprGoldScorpionWalk;
	canwalk = 1;
}

// cooldown management
if(cooldown > 0){
	cooldown--;
}

// outgoing contact damage
if(collision_rectangle(x + 20, y + 10, x - 20, y - 10, enemy, 0, 1)){
	with(instance_nearest(x, y, enemy)){
		if(sprite_index != spr_hurt){
			my_health -= 5;
			sound_play(snd_hurt);
			sprite_index = spr_hurt;
			sound_play(sndGoldScorpionMelee);
		}
	}
}

// on death
if(my_health = 0 and died = 0){
	// bullets
	for(i = 0; i < 360; i += 5){
		with(instance_create(x, y, Bullet1)){
			creator = other;
			team = creator.team;
			sprite_index = sprScorpionBullet;
			direction = other.i + random_range(-5, 5);
			image_angle = direction;
			friction = 0;
			speed = random_range(3, 4);
			damage = 2;
		}
	}
	// effect
	for(i = 0; i < 360; i += 120){
		with(instance_create(x, y, AcidStreak)){
			speed = 8;
			direction = other.i + random_range(-30, 30);
		}
	}
	died = 1;
}

#define race_name
// return race name for character select and various menus
return "GOLD SCORPION";


#define race_text
// return passive and active for character selection screen
return "CONTACT DAMAGE#CAN SPRAY VENOM";


#define race_portrait
// return portrait for character selection screen and pause menu
return sprBigPortraitChickenHeadless;


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
return choose("HISS", "SHINY", "ARMORED UP", "STINGER", "PINCH PINCH", "VENOMOUS");