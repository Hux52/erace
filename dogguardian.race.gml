#define init
global.sprMenuButton = sprite_add("sprites/sprDogSelect.png", 1, 0, 0);
global.sprPortrait = mskNone; //sprite_add("sprites/sprPortraitRat.png", 1 , 15, 185);

global.sprDogHit = sprite_add("sprites/sprDogHit.png", 3, 0, 0);

// character select sounds
global.sndSelect = sndDogGuardianBounce;
var _race = [];
for(var i = 0; i < maxp; i++) _race[i] = player_get_race(i);
while(true){
	//character selection sound
	for(var i = 0; i < maxp; i++){
		var r = player_get_race(i);
		if(_race[i] != r && r = "dogguardian"){
			sound_play(global.sndSelect);
		}
		_race[i] = r;
	}
	wait 1;
}

#define create
// player instance creation of this race
// https://bitbucket.org/YellowAfterlife/nuclearthronetogether/wiki/Scripting/Objects/Player

// sprites
spr_idle = sprDogGuardianWalk;
spr_walk = sprDogGuardianWalk;
spr_hurt = sprDogGuardianHurt;
spr_dead = sprDogGuardianDead;
spr_chrg = sprDogGuardianCharge;
spr_nort = sprDogGuardianJumpUp;
spr_sout = sprDogGuardianJumpDown;
spr_land = sprDogGuardianLand;
spr_sit1 = sprMutant15GoSit;
spr_sit2 = sprMutant15Sit;

// sounds
snd_hurt = sndDogGuardianHurt;
snd_dead = sndDogGuardianDead;
snd_jump = sndDogGuardianJump;
snd_bnce = sndDogGuardianBounce;
snd_land = sndDogGuardianLand;
snd_mele = sndDogGuardianMelee;

// stats
maxspeed = 2;
team = 2;
maxhealth = 160;
spr_shadow_y = 8;
spr_shadow = shd32;
mask_index = mskPlayer;

// vars
melee = 1;	// can melee or not
jump = -1;	// jump stupid """alarm"""
jump_dir = 0;
bounce = 0;
dog = -4;	// my dog


#define game_start
// executed after picking race and starting for each player picking this race
// player-specific global variable init


#define step
// executed within each player instance of this race after step
// most actives and passives handled here

// no weps
canswap = 0;
canpick = 0;

// sprite faces direction, as you have no weps
if(direction > 90 and direction <= 270){
	right = -1;
}
else{
	right = 1;
}

if(jump = -1 and canspec = 1){
	if(button_pressed(index, "spec")){
		bounce = 0;
		jump = 25;
		canwalk = 0;
		jump_dir = direction;
	}
}

if(jump > 0){
	if(jump > 20){
		sprite_index = spr_chrg;
	}
	else if(jump >= 4){
		if(jump >= 14){
			if(jump = 20){
				sound_play(snd_jump);
				if(ultra_get("dogguardian", 1)){
					sound_play(sndFlameCannon);
				}
				with(instance_create(x, y, CustomObject)){
					creator = other;
					spr_nort = creator.spr_nort;
					spr_sout = creator.spr_sout;
					spr_hurt = creator.spr_hurt;
					image_speed = creator.image_speed;
					mask_index = creator.mask_index;
					depth = creator.depth;
					offset = 0;
					name = "dog";
					creator.dog = self;
					playerColor = player_get_color(creator.index);
					toDraw = self;
					on_step = script_ref_create(dog_step);
					script_bind_draw(draw_outline, depth, playerColor, toDraw);
				}
				spr_idle = mskNone;
				spr_walk = mskNone;
				spr_hurt = global.sprDogHit;
			}
		}
		move_bounce_solid(true)
		motion_add(direction, 5);
	}
	else{
		if(jump = 3){
			sound_play(snd_land);
			instance_delete(dog);
			sprite_index = spr_idle;
			spr_idle = sprDogGuardianWalk;
			spr_walk = sprDogGuardianWalk;
			spr_hurt = sprDogGuardianHurt;
			repeat(10){
				var _w = instance_nearest(x, y, Wall);
				if(instance_exists(_w)){
					if(distance_to_object(_w) < 20){
						with(_w){
							instance_create(x, y, FloorExplo);
							instance_destroy();
						}
					}
				}
			}
			if(ultra_get("dogguardian", 1)){
				if(distance_to_object(Portal) > 60){
					for(i = 0; i < 360; i += (360 / 20)){
						with(instance_create(x + lengthdir_x(10, i), y + lengthdir_y(10, i), Flame)){
							creator = other;
							team = creator.team;
							direction = other.i;
							speed = 8;
							swirl = 1;
						}
					}
					for(i = 0; i < 360; i += (360 / 20)){
						with(instance_create(x + lengthdir_x(5, i), y + lengthdir_y(5, i), Flame)){
							creator = other;
							team = creator.team;
							direction = other.i;
							speed = 8;
							swirl = 2;
						}
					}
					instance_create(x, y + 12, Scorch);
					sound_play(sndFlameCannonEnd);
				}
			}
		}
		speed = 0;
		sprite_index = spr_land;
	}
	if(jump_dir != direction and bounce = 0){
		bounce = 10;
		sound_play(snd_bnce);
	}
	if(ultra_get("dogguardian", 1)){
		with(instance_create(x + random_range(-20, 20), y + 6, Flame)){
			creator = other;
			team = creator.team;
			direction = 90 + random_range(-20, 20);
			speed = 3 + random_range(-0.5, 0.5);
		}
	}
	jump_dir = direction;
	jump--;
}
else{
	move_bounce_solid(false);
	canwalk = 1;
	jump = -1;
}

if(bounce > 0){
	bounce--;
}

if(distance_to_object(Portal) < 60){
	if(jump > 3){
		jump = 3;
	}
}


// outgoing contact damage
if(collision_rectangle(x + 12, y + 10, x - 12, y - 10, enemy, 0, 1)){
	with(instance_nearest(x, y, enemy)){
		if(sprite_index != spr_hurt){
			my_health -= 6;
			sound_play(snd_hurt);
			sound_play(other.snd_mele);
			sprite_index = spr_hurt;
			direction = other.direction;
		}
	}
}

with(instances_matching_ne(Flame, "swirl", null)){
	if(swirl = 1){
		direction += 15;
	}
	if(swirl = 2){
		direction += 20;
	}
}

#define dog_step
if(instance_exists(creator)){
	if(creator.sprite_index = creator.spr_hurt){
		sprite_index = spr_hurt;
	}
	image_xscale = creator.right;
	
	if(creator.jump >= 12){
		offset -= 2;;
		sprite_index = spr_nort;
	}
	else if(creator.jump > 3){
		offset += 2;
		sprite_index = spr_sout;
	}
	y = creator.y + offset;
	x = creator.x + creator.hspeed;
}

#define draw_outline(playerColor, toDraw)
d3d_set_fog(1,playerColor,0,0);
if(instance_exists(toDraw)){
    with(toDraw){
		if(instance_exists(creator)){
			draw_sprite_ext(sprite_index, -1, x - 1, y, 1 * creator.right, 1, 0, playerColor, 1);
			draw_sprite_ext(sprite_index, -1, x + 1, y, 1 * creator.right, 1, 0, playerColor, 1);
			draw_sprite_ext(sprite_index, -1, x, y - 1, 1 * creator.right, 1, 0, playerColor, 1);
			draw_sprite_ext(sprite_index, -1, x, y + 1, 1 * creator.right, 1, 0, playerColor, 1);
		}
    }
}
d3d_set_fog(0,c_lime,0,0);

#define race_name
// return race name for character select and various menus
return "DOG GUARDIAN";


#define race_text
// return passive and active for character selection screen
return "@sCAN @wJUMP#CONTACT DAMAGE";


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
	case 1: return "HOT DOG";
	default: return "";
}


#define race_ultra_text
// recieves ultra mutation index and returns description
switch(argument0){
	case 1: return "FASTER AND MORE FIRE";
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
switch(argument0){
	case 1:
		maxspeed = 4;
	break;
}


#define race_ttip
// return character-specific tooltips
return choose("WOOF", "YAHOO", "HOPS", "PANT", "RADICAL");