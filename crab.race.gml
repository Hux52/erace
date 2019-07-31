#define init
global.sprMenuButton = sprite_add("sprites/selectIcon/sprCrabSelect.png", 1, 0, 0);
global.sprPortrait = sprite_add("sprites/portrait/sprPortraitHermitCrab.png",1 , 15, 205);
global.sprIcon = sprite_add("sprites/mapIcon/LoadOut_HermitCrab.png", 1, 10, 10);

// character select sounds
global.sndSelect = sndOasisDeath;
var _race = [];
for(var i = 0; i < maxp; i++) _race[i] = player_get_race(i);
while(true){
	//character selection sound
	for(var i = 0; i < maxp; i++){
		var r = player_get_race(i);
		if(_race[i] != r && r = "crab"){
			sound_play_pitchvol(global.sndSelect,1.5,1);
		}
		_race[i] = r;
	}
	wait 1;
}

#define create
// player instance creation of this race
// https://bitbucket.org/YellowAfterlife/nuclearthronetogether/wiki/Scripting/Objects/Player

// sprites
spr_idle = sprCrabIdle;
spr_idle_normal = spr_idle;
spr_walk = sprCrabWalk;
spr_walk_normal = spr_walk;
spr_hurt = sprCrabHurt;
spr_dead = sprCrabDead;
spr_sit1 = sprCrabIdle;
spr_sit2 = sprCrabIdle;

spr_fire = sprCrabFire;

// sounds
snd_hurt = sndOasisHurt;
snd_dead = sndOasisDeath;
snd_melee = sndOasisMelee;
snd_fire = sndOasisCrabAttack;

// stats
maxspeed = 4.1;
erace_maxspeed_orig = maxspeed;
team = 2;
maxhealth = 12;
spr_shadow_y = 0;
mask_index = mskPlayer;

// vars
melee = 0;	// can melee or not

d = 0;

fire_cooldown = 0;
fire_cooldown_base = 30;

bulletCountBase = 8;
bulletCount = 8;

fireDelay = 1;
fireDelayBase = 1;

can_fire = true;
is_firing = false;

#define game_start
// executed after picking race and starting for each player picking this race
// player-specific global variable init


#define step
// executed within each player instance of this race after step
// most actives and passives handled here

// no weps
canswap = 0;
canpick = 0;

footstep = 2;

// outgoing contact damage
if(collision_rectangle(x + 12, y + 10, x - 12, y - 10, enemy, 0, 1)){
	with(instance_nearest(x, y, enemy)){
		if(sprite_index != spr_hurt){
			projectile_hit_push(self, 3, 4);
			sound_play_pitchvol(other.snd_melee,random_range(0.9,1.1),1);
		}
	}
}

//firing

if(fire_cooldown > 0){
	can_fire = false;
} else {
	can_fire = true;
}

if(button_pressed(index,"fire")){
	if(can_fire){
		is_firing = true;
		fire_cooldown = fire_cooldown_base;
	}
}

if(is_firing){
	spr_walk = spr_fire;
	spr_idle = spr_fire;
	if(bulletCount > 0){
		if(fireDelay <= 0){
			sound_play_pitchvol(snd_fire, random_range(0.9,1.1), 1);
			for(i = -1; i < 2; i += 2){
				q = d + (i*20);
				with(instance_create(x,y,EnemyBullet2)){
					creator = other;
					damage = 2;
					speed = random_range(5,7);
					team = other.team;
					direction = other.q + random_range(-3,3);
					image_angle = direction;
				}
			}
			bulletCount -= 1;
			fireDelay = fireDelayBase;
		}
		fireDelay -= current_time_scale;
	} else {
		is_firing = false; //stop firing
	}
}else{
	//reset everything
	bulletCount = bulletCountBase;
	d = point_direction(x,y,mouse_x[index],mouse_y[index]);
	spr_idle = spr_idle_normal;
	spr_walk = spr_walk_normal;
}

fire_cooldown -= current_time_scale;

#define race_name
// return race name for character select and various menus
return "CRAB";


#define race_text
// return passive and active for character selection screen
return "CONTACT DAMAGE";


#define race_portrait
// return portrait for character selection screen and pause menu
return global.sprPortrait;


#define race_mapicon
// return sprite for loading/pause menu map
return global.sprIcon;


#define race_swep
// return ID for race starting weapon
return 0;


#define race_avail
// return if race is unlocked
return true;


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
return choose("SNIP SNIP", "AIN'T EASY BEING GREEN");