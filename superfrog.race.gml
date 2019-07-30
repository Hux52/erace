#define init
// for level start
global.newLevel = instance_exists(GenCont);
global.hasGenCont = false;
global.sprPortrait = sprite_add("sprites/portrait/sprPortraitSuperExploder.png", 1, 10, 205);
global.sprIcon = sprite_add("sprites/mapIcon/LoadOut_toxicballguy.png", 1, 10, 10);

//global.sprMenuButton = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAABAAAAAYCAYAAADzoH0MAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAACySURBVDhPY/CJdPtPCUYxgIGBAQMjy2PD1DMApNhphSYGJmQQUA5hm0q0JhgjGwATg6mhvgHYFMMwNjlkC2lnALIYOoapgRuGTRJZDB1jGPDHguE/CCNLEINBejBcQA6m3ACYk2AhSzKm2ACYU0CGNO1lJRpTzwCYF0C4wKEJjFt/SoExiA3TAJODYZgYQQOQ2cgYJka5AchhgK4IhHEZAMPUNcCGyx0FY9OAjik0oOk/AAPExSzmQZwnAAAAAElFTkSuQmCC", 1, 0, 0);

// level start init- MUST GO AT END OF INIT
while(true){
	// first chunk here happens at the start of the level, second happens in portal
	if(instance_exists(GenCont)) global.newLevel = 1;
	else if(global.newLevel){
		global.newLevel = 0;
		level_start();
	}
	var hadGenCont = global.hasGenCont;
	global.hasGenCont = instance_exists(GenCont);
	if (!hadGenCont && global.hasGenCont) {
		// nothing yet
	}
	wait 1;
}


#define create
// player instance creation of this race
// https://bitbucket.org/YellowAfterlife/nuclearthronetogether/wiki/Scripting/Objects/Player

// sprites
spr_idle = sprSuperFrogIdle;
spr_walk = sprSuperFrogWalk;
spr_hurt = sprSuperFrogHurt;
spr_dead = sprSuperFrogDead;
spr_sit1 = sprMutant15GoSit;
spr_sit2 = sprMutant15Sit;

// sounds
snd_dead = sndSuperFrogExplode;

// stats
maxspeed = 2.5;
team = 2;
maxhealth = 21;
spr_shadow = shd24;
spr_shadow_y = 0;
mask_index = mskPlayer;

// vars
close = 0;	// timer for when close to an enemy- prevents sound spam
exploded = 0;	// prevent extra death frames
ambience = 0;	// ambient bullet frequence
melee = 1;	// can melee or not
dead = false; //for effect

#define level_start
// toxic on start
with(instances_matching(Player, "race", "superfrog")){
	repeat(10){
		with(instance_create(x, y, ToxicGas)){
			creator = other;
			team = creator.team;
			direction = random(360);
			speed = random_range(0.5, 1.5);
		}
	}
}

#define game_start
// executed after picking race and starting for each player picking this race
// player-specific global variable init


#define step
// executed within each player instance of this race after step
// most actives and passives handled here

// no weps
canswap = 0;
canpick = 0;

// face the direction you're moving in- no gun
if(direction > 90 and direction <= 270){
	right = -1;
}
else{
	right = 1;
}

// constant movement
if(canwalk = 1){
	move_bounce_solid(true);
	motion_add(direction, maxspeed / 4);
}

// ambient bullets
if(ambience = 0){
	with(instance_create(x, y, Bullet1)){
		creator = other;
		team = creator.team;
		sprite_index = sprScorpionBullet;
		direction = random(360);
		image_angle = direction;
		friction = 0;
		speed = 2.5;
		damage = 2;
	}
	ambience = 3;
}

// manage ambience
if(ambience > 0){
	ambience-= current_time_scale;
}

// explode on contact- make noise when close
if(collision_rectangle(x + 10, y + 10, x - 10, y - 10, enemy, 0, 1) && exploded <= 0){
	exploder_explode();
	my_health -= 1;
}
else if(collision_rectangle(x + 30, y + 10, x - 30, y - 10, enemy, 0, 1)){
	if(close = 0){
		sound_play(sndFrogClose);
		close = 30;
	}
}

// noise cooldown to prevent spam
if(close > 0){
	close-= current_time_scale;
}

if(exploded > 0){
	exploded-= current_time_scale;
}

// on death
if(my_health = 0 && dead = false){
	exploder_explode();
	dead = true;
}

#define exploder_explode
	instance_create(x,y,ExploderExplo);
	exploded = 30;
	// effect
	for(i = 0; i < 360; i += 120){
		with(instance_create(x, y, AcidStreak)){
			speed = 8;
			direction = other.i + random_range(-30, 30);
			image_angle = direction;
			friction = 0.9;
		}
	}
	// 12 bullets
	for(i = 0; i < 360; i += 30){
		with(instance_create(x, y, Bullet1)){
			creator = other;
			team = creator.team;
			sprite_index = sprScorpionBullet;
			direction = other.i + random_range(-5, 5);
			image_angle = direction;
			friction = 0;
			speed = 4;
			damage = 2;
		}
	}
	// slow bullets
	for(i = 0; i < 360; i += 45){
		with(instance_create(x, y, Bullet1)){
			creator = other;
			team = creator.team;
			sprite_index = sprScorpionBullet;
			direction = other.i + random_range(-30, 30);
			image_angle = direction;
			friction = 0;
			speed = random_range(1.5, 2);
			damage = 2;
		}
	}
	// toxic
	repeat(20){
		with(instance_create(x, y, ToxicGas)){
			creator = other;
			team = creator.team;
			direction = random(360);
			speed = random_range(0.5, 1);
		}
	}


#define race_name
// return race name for character select and various menus
return "TOXIC BALLGUY";


#define race_text
// return passive and active for character selection screen
return "CAN'T STAND STILL#EXPLODE ON CONTACT#AMBIENT VENOM";


#define race_portrait
// return portrait for character selection screen and pause menu
return sprBigPortraitChickenHeadless;


#define race_mapicon
// return sprite for loading/pause menu map
return global.sprIcon;


#define race_swep
// return ID for race starting weapon
return 0;


#define race_avail
// return if race is unlocked
return false;


#define race_menu_button
// return race menu button icon
return mskNone;

#define race_skins
// return number of skins the race has
return 1;


#define race_skin_avail
// return if skin is unlocked
return 1;

#define race_skin_button
// return skin switch button sprite
return global.sprIcon;


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
return choose("RIBBIT", "CAN'T STOP, PROBABLY WON'T STOP", "DON'T TOUCH ME", "SMELLY");