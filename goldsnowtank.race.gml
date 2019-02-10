#define init
// character select button
global.sprMenuButton = sprite_add("sprites/sprSnowTankSelect.png", 1, 0, 0);
// character select portrait
global.sprPortrait = sprite_add("/sprites/sprPortraitGoldSnowTank.png", 1, 5, 198);

// character select sounds
// global.sndSelect = sound_add("sounds/sndBanditSelect.ogg");
// var _race = [];
// for(var i = 0; i < maxp; i++) _race[i] = player_get_race(i);
// while(true){
// 	//character selection sound
// 	for(var i = 0; i < maxp; i++){
// 		var r = player_get_race(i);
// 		if(_race[i] != r && r = "bandit"){
// 			sound_play(global.sndSelect);
// 		}
// 		_race[i] = r;
// 	}
// 	wait 1;
// }


#define create
// player instance creation of this race
// https://bitbucket.org/YellowAfterlife/nuclearthronetogether/wiki/Scripting/Objects/Player

// sprites
spr_idle = sprGoldTankIdle;
spr_walk = sprGoldTankWalk;
spr_hurt = sprGoldTankHurt;
spr_dead = sprGoldTankDead;
spr_sit1 = sprMutant15GoSit;
spr_sit2 = sprMutant15Sit;

// sounds
snd_hurt = sndGoldTankHurt;
snd_dead = sndGoldTankDead;
snd_aim = sndGoldTankAim;
snd_fire = sndGoldTankShoot;

// stats
maxspeed = 1.2;
team = 2;
maxhealth = 70;
melee = 0;	// can melee or not
spr_shadow = shd64;
spr_shadow_y = 8;

has_died = false;

fire_cooldown = 0;
fire_cooldown_base = 12;

charge_base = 6;
charge = 6;

bulletCountBase = 16;
bulletCount = 16;

fireDelay = 2;
fireDelayBase = 2;

can_fire = true;
is_charging = false;
is_firing = false;

#define game_start
// executed after picking race and starting for each player picking this race
// player-specific global variable init


#define step
// executed within each player instance of this race after step
// most actives and passives handled here

on_draw = script_bind_draw(snowtank_draw, depth);

// no weps
canswap = 0;
canpick = 0;

u1 = ultra_get(player_get_race(index), 1);
u2 = ultra_get(player_get_race(index), 2);

if(direction > 90 and direction <= 270){
	right = -1;
}
else{
	right = 1;
}

if(fire_cooldown > 0){
	can_fire = false;
} else {
	can_fire = true;
}

if(button_pressed(index,"fire")){
	if(can_fire){
		if(is_charging = false){
			is_charging = true;
			sound_play_pitchvol(snd_aim, random_range(0.9,1.1), 0.8);
			spread = choose(0,1);
		}
	}
}

if(is_charging){
	charge -= current_time_scale;
	if(charge <= 0){
		is_charging = false;
		is_firing = true;
	}
}

if(is_firing){
	fire_cooldown = fire_cooldown_base;
	if(bulletCount > 0){
		if(fireDelay <= 0){
			//shot boolit
			sound_play_pitchvol(snd_fire, random_range(0.9,1.1), 0.6);
			for(i = 0; i < 2; i++){
				if (i = 0){
					r = -1;
				} else {
					r = 1;
				}
				q = d + ((spread-(bulletCount/bulletCountBase))*r * 20);
				with(instance_create(x,y,EnemyBullet4)){
					damage = 3;
					speed = 12;
					team = other.team;
					direction = other.q;
					image_angle = direction;
				}
			}
			if(bulletCount = bulletCountBase){
				sound_play_pitchvol(sndGoldTankPreShoot, random_range(0.9,1.1), 0.6);
				with(instance_create(x,y,JockRocket)){
					sprite_index = sprGoldTankRocket;
					team = other.team;
					direction = other.q;
					image_angle = direction;
				}
			}
			bulletCount -= 1;
			fireDelay = fireDelayBase;
		}
		fireDelay -= current_time_scale;
	} else {
		sound_play_pitchvol(sndGoldTankCooldown, random_range(0.9,1.1), 0.6);
		is_firing = false; //stop firing
	}
}

if(is_charging = false and is_firing = false){
	//reset everything
	fire_cooldown -= current_time_scale;
	charge = charge_base;
	bulletCount = bulletCountBase;
} else {
	d = point_direction(x,y,mouse_x[index],mouse_y[index]);
}

if(my_health < 1){
	if(has_died = false){
		with(instance_create(x,y,SnowTankExplode)){
			sprite_index = sprGoldTankExplode;
		}
		has_died = true;
	}
} else {
	has_died = false;
}

#define snowtank_draw
with(Player){
	laser_x = x;
	laser_y = y;
	_n = 0;

	if (is_firing or is_charging){
		p_dir = point_direction(x,y,mouse_x[index],mouse_y[index]);
		while(instance_position(x + lengthdir_x(_n,p_dir), y + lengthdir_y(_n,p_dir), Wall) == noone){
			_n++;
			laser_x = x + lengthdir_x(_n,p_dir);
			laser_y = y + lengthdir_y(_n,p_dir);
			if(_n > 200){
				break;
			}
		}
		draw_line_color(x,y,laser_x,laser_y,c_red,c_red);
	}
}
instance_destroy();

#define race_name
// return race name for character select and various menus
return "GOLD SNOW TANK";


#define race_text
// return passive and active for character selection screen
return "@sFIRES IN LARGE @wBURSTS";


#define race_portrait
// return portrait for character selection screen and pause menu
return global.sprPortrait;


#define race_mapicon
// return sprite for loading/pause menu map
return sprMapIconChickenHeadless;


#define race_swep
// return ID for race starting weapon
return false;


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
return choose("MOW THEM DOWN");