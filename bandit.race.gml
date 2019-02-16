#define init
// character select button
global.sprMenuButton = sprite_add("sprites/sprBanditSelect.png", 1, 0, 0);
// character select portrait
global.sprPortrait = sprite_add("/sprites/sprPortraitBandit.png", 1, 22, 210);

// character select sounds
global.sndSelect = sound_add("sounds/sndBanditSelect.ogg");
var _race = [];
for(var i = 0; i < maxp; i++) _race[i] = player_get_race(i);
while(true){
	//character selection sound
	for(var i = 0; i < maxp; i++){
		var r = player_get_race(i);
		if(_race[i] != r && r = "bandit"){
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
spr_idle = sprBanditIdle;
spr_walk = sprBanditWalk;
spr_hurt = sprBanditHurt;
spr_dead = sprBanditDead;
spr_sit1 = sprMutant15GoSit;
spr_sit2 = sprMutant15Sit;

// sounds
snd_hurt = sndBanditHit;
snd_dead = sndBanditDie;

// stats
maxspeed = 3;
team = 2;
maxhealth = 4;
melee = 0;	// can melee or not


#define game_start
// executed after picking race and starting for each player picking this race
// player-specific global variable init


#define step
// executed within each player instance of this race after step
// most actives and passives handled here
canswap = 0;
canpick = 0;
if(wep != "bandit"){
	wep = "bandit";
}

u1 = ultra_get(player_get_race(index), 1); // bandit gun
u2 = ultra_get(player_get_race(index), 2); // reincarnation

if(reload > 0){
	can_shoot = false;
} else {
	can_shoot = true;
}

if(ultra_get(player_get_race(index), 1) == 1){
	if(object_index = Player){
		if(button_pressed(index, "spec") and reload <= 0){
			weapon_post(5, 30, 10);	// weapon kick and screen shake
			sound_play_pitchvol(sndEnemyFire,0.5,1);
			reload = weapon_get_load(wep);
			spawn_bandit();
		}
	}
}

if(my_health = 0){ //reincarnation in tarnation
	if(instance_exists(Bandit)){
		_b = instance_nearest(x,y,Bandit);
		with(instance_create(x,y,Corpse)){
			sprite_index = other.spr_dead;
			size = 1;
			direction = other.direction;
			speed = other.speed;
			friction = 0.3;
		}
		x = _b.x;
		y = _b.y;
		my_health = ceil(_b.my_health);
		spr_idle = _b.spr_idle;
		spr_walk = _b.spr_walk;
		spr_hurt = _b.spr_hurt;
		spr_dead = _b.spr_dead;
		canspirit = true;
		sound_play_pitchvol(sndStrongSpiritGain,0.8 + random_range(-0.1,0.1),0.4);
		sound_play_pitchvol(sndStrongSpiritLost,0.6 + random_range(-0.1,0.1),0.4);
		sound_play_pitchvol(sndNecromancerRevive,0.4 + random_range(-0.1,0.1),0.8);
		instance_create(_b.x,_b.y,ReviveFX);
		instance_delete(_b);
	}
}


#define race_name
// return race name for character select and various menus
return "BANDIT";


#define race_text
// return passive and active for character selection screen
return "HAS BANDIT RIFLE";


#define race_portrait
// return portrait for character selection screen and pause menu
return global.sprPortrait;


#define race_mapicon
// return sprite for loading/pause menu map
return sprMapIconChickenHeadless;


#define race_swep
// return ID for race starting weapon
return "bandit";


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
	case 1: return "BANDIT GUN";
	case 2: return "REINCARNATION";
	//case 3: return "ALLIES";
	default: return "";
}


#define race_ultra_text
// recieves ultra mutation index and returns description
switch(argument0){
	case 1: return "@wRIGHT CLICK @sTO SUMMON @yREINFORCEMENTS";
	case 2: return "@sREQUIRES A @wVESSEL";
	//case 3: return "@sALL BANDITS BECOME @gFRIENDLY";
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
return choose("WARM BARRELS", "DUST PROOF", "PLUNDER", "FIRE FIRST, AIM LATER");

#define bandit_step
if(my_health > 0){
	// speed management
	speed = clamp(speed, 0, maxspeed);

	// targeting
	var _e = instance_nearest(x, y, enemy);
	if(instance_exists(_e) and distance_to_object(_e) < 100 and !collision_line(x, y, _e.x, _e.y, Wall, true, true)){
		// target is enemy
		if(target == noone){instance_create(x,y-8,AssassinNotice)}
		target = _e;
	} else {
		//target is nobody
		target = noone;
	}

	if(reload > 0){	// manage reload
		reload--;
	}
	
	if(wkick > 0){	// manage weapon kick
		wkick--;
	}

	if(target != noone){
		gunangle = point_direction(x,y,target.x,target.y);
		//shoOoOoOot
		if(reload <= 0){
			sound_play_gun(sndEnemyFire, 0.2, 0.6);
			with(instance_create(x, y, AllyBullet)){
				creator = other;
				team = creator.team;
				direction = other.gunangle;
				image_angle = direction;
				friction = 0;
				speed = 8;
				damage = 3;
			}
			wkick = 10;
			reload = weapon_get_load(wep);
		}
	}

	// movement
	motion_set(dir, maxspeed);
	_f = instance_place(x,y,Floor);
	if(instance_exists(_f)){
		friction = lerp(friction, _f.traction, 0.5);
	}
	
	// stop hit sprite
	if(sprite_index = spr_hurt and image_index >= 2){
		sprite_index = spr_idle;
	}
	
	// alarm management
	for(i = 0; i < array_length_1d(alarm); i++){
		if(alarm[i] > 0){
			alarm[i]-= current_time_scale;
		}
	}
	
	// incoming/outgoing contact damage
	with(collision_rectangle(x + 12, y + 10, x - 12, y - 10, enemy, 0, 1)){
		if(sprite_index != spr_hurt){
			if(meleedamage > 0){
				other.my_health -= meleedamage;
				sound_play(snd_mele);
			}
		}
	}
		
	// sprite facing based on direction
	if(speed > 0 and sprite_index != spr_hurt){
		sprite_index = spr_walk;
	}
	else if(sprite_index != spr_hurt){
		sprite_index = spr_idle;
	}
	
	if(gunangle > 90 and gunangle <= 270){
		right = -1;
	}
	else{
		right = 1;
	}
	// face right or left
	if(right = 1){
		image_xscale = 1;
	}
	else{
		image_xscale = -1;
	}
	if(place_meeting(x,y,TrapFire)){
		sprite_index = spr_hurt;
	}

	// collision - dies on touching a wall
	if(place_meeting(x+hspeed, y+vspeed, Wall)){
		instance_destroy();
	}
}
else{
	instance_destroy();
}

#define bandit_draw
d3d_set_fog(1, playerColor, 0, 0);
draw_sprite_ext(sprite_index, -1, x - 1, y, 1 * right, 1, image_angle, playerColor, 1);
draw_sprite_ext(sprite_index, -1, x + 1, y, 1 * right, 1, image_angle, playerColor, 1);
draw_sprite_ext(sprite_index, -1, x, y - 1, 1 * right, 1, image_angle, playerColor, 1);
draw_sprite_ext(sprite_index, -1, x, y + 1, 1 * right, 1, image_angle, playerColor, 1);
// gun outline
draw_sprite_ext(weapon_get_sprite(wep), -1, x - lengthdir_x(wkick, gunangle) - 1, y - lengthdir_y(wkick, gunangle), 1, right, gunangle, playerColor, 1);
draw_sprite_ext(weapon_get_sprite(wep), -1, x - lengthdir_x(wkick, gunangle) + 1, y - lengthdir_y(wkick, gunangle), 1, right, gunangle, playerColor, 1);
draw_sprite_ext(weapon_get_sprite(wep), -1, x - lengthdir_x(wkick, gunangle), y - lengthdir_y(wkick, gunangle) - 1, 1, right, gunangle, playerColor, 1);
draw_sprite_ext(weapon_get_sprite(wep), -1, x - lengthdir_x(wkick, gunangle), y - lengthdir_y(wkick, gunangle) + 1, 1, right, gunangle, playerColor, 1);
d3d_set_fog(0,c_lime,0,0);
// draw gun
draw_sprite_ext(weapon_get_sprite(wep), 0, x - lengthdir_x(wkick, gunangle), y - lengthdir_y(wkick, gunangle), 1, right, gunangle, c_white, 1);
draw_self();

#define bandit_destroy
sound_play(snd_dead);
// make corpse
with (instance_create(x, y, Corpse)){
	sprite_index = other.spr_dead;
	size = 1;
	direction = other.direction;
	speed = other.speed;
	friction = 0.3;
}

#define bandit_hurt(damage, kb_vel, kb_dir)
// incoming damage
if(sprite_index != spr_hurt){
	if(nexthurt <= current_frame){		
		sound_play_pitchvol(snd_hurt,1,0.6);
		my_health -= argument0;
		motion_add(argument2, argument1);
		nexthurt = current_frame + 3;
		sprite_index = spr_hurt;
	}
}

#define draw_outline(playerColor, toDraw)
d3d_set_fog(1,playerColor,0,0);
if(instance_exists(toDraw)){
    with(toDraw){
        draw_sprite_ext(sprite_index, -1, x - 1, y, 1 * right, 1, image_angle, playerColor, 1);
        draw_sprite_ext(sprite_index, -1, x + 1, y, 1 * right, 1, image_angle, playerColor, 1);
        draw_sprite_ext(sprite_index, -1, x, y - 1, 1 * right, 1, image_angle, playerColor, 1);
        draw_sprite_ext(sprite_index, -1, x, y + 1, 1 * right, 1, image_angle, playerColor, 1);
    }
}
d3d_set_fog(0,c_lime,0,0);

#define spawn_bandit
	_b = (instance_create(x, y, CustomHitme));
	with(_b){
		name = "BanditFriendly";
		creator = other;
		team = creator.team;
		dir = creator.gunangle;

		gunangle = random(360);
		wep = "bandit";
		wkick = 0;
		reload = 0;
		//sprites
		spr_idle = sprBanditIdle;
		spr_walk = sprBanditWalk;
		spr_hurt = sprBanditHurt;
		spr_dead = sprBanditDead;

		sprite_index = spr_idle;
		
		// sounds
		snd_hurt = sndBanditHit;
		snd_dead = sndBanditDie;

		maxhealth = creator.maxhealth;
		my_health = maxhealth;
		maxspeed = creator.maxspeed/2;
		mask_index = mskBandit;
		size = 1;
		image_speed = 0.4;
		depth = -1.9;
		spr_shadow = shd24;
		move_bounce_solid(true);
		friction = 0.45;
		right = choose(-1, 1);
		alarm = [0]; // shoot timer
		target = noone;
		on_step = script_ref_create(bandit_step);
		on_hurt = script_ref_create(bandit_hurt);
		on_destroy = script_ref_create(bandit_destroy);
		on_draw = script_ref_create(bandit_draw);
		toDraw = self;		
		playerColor = player_get_color(creator.index);	
		script_bind_draw(draw_outline, depth, playerColor, toDraw);
		wall_stuck = 0;
	}
 return _b;