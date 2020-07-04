#define init
// UI
global.sprMenuButton = sprite_add("sprites/selectIcon/sprBanditSelect.png", race_skins(), 0, 0);
global.spr_port = sprite_add("sprites/portrait/sprPortraitBandit.png", race_skins(), 22, 210);
global.spr_skin = sprite_add("sprites/mapIcon/LoadOut_Bandit.png", race_skins(), 10, 10);
global.spr_icon = global.spr_skin;

// A Skin
global.sprIdle[0] = sprBanditIdle;
global.sprWalk[0] = sprBanditWalk;
global.sprHurt[0] = sprBanditHurt;
global.sprDead[0] = sprBanditDead;


// B Skin
global.sprIdle[1] = sprSnowBanditIdle;
global.sprWalk[1] = sprSnowBanditWalk;
global.sprHurt[1] = sprSnowBanditHurt;
global.sprDead[1] = sprSnowBanditDead;

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
spr_idle = global.sprIdle[bskin];
spr_walk = global.sprWalk[bskin];
spr_hurt = global.sprHurt[bskin];
spr_dead = global.sprDead[bskin];
spr_sit1 = global.sprIdle[bskin];
spr_sit2 = global.sprIdle[bskin];

// sounds
snd_hurt = sndBanditHit;
snd_dead = sndBanditDie;

// stats
maxspeed = 3;
team = 2;
maxhealth = 10;
melee = 0;	// can melee or not
spinning = 0;
spun = 0;
spins = 0;

has_bandit = false; //input bubber

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

if(u1 == 1){
	if(button_pressed(index, "spec") and reload <= weapon_get_load(wep)/2){
		has_bandit = true;
	}

	if(has_bandit and can_shoot){
		if(my_health > 1){
			my_health -= 1;
			weapon_post(10, 30, 10);	// weapon kick and screen shake
			sound_play_pitchvol(sndBloodGamble,0.5,0.6);
			sound_play_pitchvol(sndBloodHurt,0.5,0.6);
			with(instance_create(x + lengthdir_x(6,gunangle), y + lengthdir_y(6,gunangle), BloodGamble)){
				image_angle = other.gunangle;
			}
			for(i = 0; i < 3; i++){
				with(instance_create(x + lengthdir_x(18,gunangle), y + lengthdir_y(18,gunangle),BloodStreak)){
					image_angle = other.gunangle - 45 + (other.i * 45);
					direction = image_angle;
					speed = 3;
				}
			}
			reload = weapon_get_load(wep);
			with(spawn_bandit()){
				direction = other.gunangle;
				speed = other.maxspeed * 3;
			}
				
			has_bandit = false;
		} else {
			has_bandit = false;
			sound_play_pitchvol(sndEmpty, random_range(0.9,1.1), 0.65);
			with(instance_create(x,y,PopupText)){
				xstart = x;
				ystart = y;
				text = "not enough health!";
				mytext = "not enough health!";
				time = 10;
				target = 0;
			}
		}
		
	}
}
else{
	if(button_pressed(index, "spec") and spinning = 0 and spins < 3){
		spins += 1;
		sound_play_pitchvol(sndEnemySlash, (spins * 0.2) + random_range(0.7, 0.9), 2);
		sound_play_pitchvol(sndMeleeFlip, random_range(0.9, 1.1), 1);
		spinning = 8 - (floor(GameCont.level / 4));
	}
}

if(spinning > 0){
	spinning -= current_time_scale;
	// wepangle -= 360 - (current_time_scale * 20 / 20) * 13;
	canaim = 0
	reload = 5;
	gunangle = point_direction(x,y,mouse_x[index],mouse_y[index])
	script_bind_end_step(step_end, 0);
}

if(spinning <= 0){
	if(spun > 0){
		canaim = 1;
		reload = 0;
		sound_play_pitchvol(sndFootPlaMetal4, random_range(2.9, 3.1), 1.5);
	}
}

if(spins > 0){
	wkick = random(spins);
	if(random(12) < spins){
		with(instance_create(x, y, Smoke)){
			direction = random_range(75, 115);
			image_angle = random(360);
			image_xscale = 0.5;
			image_yscale = 0.5;
			speed = 3;
		}
	}
}
spun = spinning;

if(gunangle <= 180 and gunangle > 0){
	script_bind_draw(gun_draw, depth);
}
else{
	script_bind_draw(gun_draw, depth - 1);
}
script_bind_draw(gun_outline_draw, depth);


if(u2 == 1){
	if(my_health = 0){ //reincarnation in tarnation
		_to = mod_script_call("mod","erace","respawn_as", false, "bandit", Bandit);
		instance_delete(_to);
	}
}




// B SKIN EFFECTS
if(bskin = 1){
	with(Floor){
		if(random(1000) < current_time_scale){
			with(instance_create(x+18,y+16,SnowFlake)){
				addx = -5;
			}
		}
		switch(sprite_index){
			case sprFloor0:
			case sprFloor1:
			case sprFloor3:
			material = 1;
			sprite_index = sprFloor5;
			break;

			case sprFloor0Explo:
			case sprFloor1Explo:
			case sprFloor3Explo:
			material = 2;
			sprite_index = sprFloor5Explo;
			break;
			
			case sprFloor1B:
			case sprFloor3B:
			sprite_index = sprFloor5B;
			break;
		}
	}

	with(prop){
		switch(object_get_name(object_index)){
			case "Cactus":
			case "NightCactus":
			case "BigSkull":
			case "BonePile":
			case "BonePileNight":
			case "Tires":
			toReplace = choose(Hydrant, Hydrant, Hydrant, StreetLight, SodaMachine, SodaMachine, SnowMan);
			with(instance_create(x,y,toReplace)){
				if(object_index = Hydrant){
					if(random(100) < 5){
						spr_idle = sprNewsStand;
						spr_hurt = sprNewsStandHurt;
						spr_dead = sprNewsStandDead;
					}
				}
			}
			instance_delete(self);
			break;
		}
	}

	with(RainDrop){
		instance_destroy();
	}
	instance_delete(RainSplash);

	if(button_pressed(index, "spec") and spinning = 0 and spins < 3){
		spins += 1;
		sound_play_pitchvol(sndEnemySlash, (spins * 0.2) + random_range(0.7, 0.9), 2);
		spinning = 8;
	}
}

#define step_end
with(Player){
	if("spinning" in self){
		if(spinning > 0){
			gunangle = point_direction(x,y,mouse_x[index],mouse_y[index]) + (360 / (8 / spinning)) * right;
		}
	}
}
instance_destroy();

#define gun_draw
with(Player){
	if("spins" in self){
		// gun
		draw_sprite_ext(sprBanditGun, 0, x - lengthdir_x(wkick, gunangle + wepangle), y - lengthdir_y(wkick, gunangle + wepangle), 1, right, gunangle + wepangle, merge_color(c_white, c_red, spins * 0.3), 1);
	}
}
instance_destroy();

#define gun_outline_draw
with(Player){
	if("spins" in self){
		// gun outline
		d3d_set_fog(1, player_get_color(index), 0, 0);
		draw_sprite_ext(sprBanditGun, -1, x - lengthdir_x(wkick, gunangle + wepangle) - 1, y - lengthdir_y(wkick, gunangle + wepangle), 1, right, gunangle, player_get_color(index), 1);
		draw_sprite_ext(sprBanditGun, -1, x - lengthdir_x(wkick, gunangle + wepangle) + 1, y - lengthdir_y(wkick, gunangle + wepangle), 1, right, gunangle, player_get_color(index), 1);
		draw_sprite_ext(sprBanditGun, -1, x - lengthdir_x(wkick, gunangle + wepangle), y - lengthdir_y(wkick, gunangle + wepangle) - 1, 1, right, gunangle, player_get_color(index), 1);
		draw_sprite_ext(sprBanditGun, -1, x - lengthdir_x(wkick, gunangle + wepangle), y - lengthdir_y(wkick, gunangle + wepangle) + 1, 1, right, gunangle, player_get_color(index), 1);
		d3d_set_fog(0,c_lime,0,0);
	}
}
instance_destroy();

#define race_name
// return race name for character select and various menus
return "BANDIT";


#define race_text
// return passive and active for character selection screen
return "HAS BANDIT RIFLE";


#define race_portrait
// return portrait for character selection screen and pause menu
return global.spr_port


#define race_mapicon
// return sprite for loading/pause menu map
return global.spr_icon;


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
return 2;


#define race_skin_avail
// return if skin is unlocked
return 1;

#define race_skin_button
// return skin switch button sprite
sprite_index = global.spr_skin;
image_index = argument0;


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
	speed = lerp(speed,maxspeed, 0.1 * current_time_scale);

	_enemies = instances_matching_gt(enemy, "my_health", 0);
	// targeting
	if(array_length(_enemies) > 0){
		for (i = 0; i < array_length(_enemies); i++){
			if(instance_exists(_enemies[i])){
				if(!collision_line(x, y, _enemies[i].x, _enemies[i].y, Wall, false, true)){
					if(point_distance(x,y,_enemies[i].x,_enemies[i].y) > 150) continue;
					if(instance_exists(_enemies[i])){
						target = _enemies[i];
						break;
					}
				}
				target = noone;
			}
		}
	} else {
		//target is nobody
		target = noone;
	}

	if(reload > 0){	// manage reload
		reload -= current_time_scale;
	}
	
	if(wkick > 0){	// manage weapon kick
		wkick -= current_time_scale;
	}

	if(target != noone){
		//shoOoOoOot
		if(reload <= 0){
			if(instance_exists(target)){
				gunangle = point_direction(x,y,target.x,target.y);
			}
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
	if(speed <= maxspeed){
		motion_set(dir, maxspeed);
	}
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
	
	if(target != noone){
		if(gunangle > 90 and gunangle <= 270){
			right = -1;
		}
		else{
			right = 1;
		}
	} else {
		if(direction > 90 and direction <= 270){
			right = -1;
		}
		else{
			right = 1;
		}
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
sound_play_pitchvol(snd_dead,random_range(0.9,1.1), 0.65);
// make corpse
with (instance_create(x, y, Corpse)){
	sprite_index = other.spr_dead;
	size = 1;
	direction = other.direction;
	speed = other.speed;
	friction = 0.4;
}

#define bandit_hurt(damage, kb_vel, kb_dir)
// incoming damage
if(sprite_index != spr_hurt){
	if(nexthurt <= current_frame){		
		sound_play_pitchvol(snd_hurt,random_range(0.9,1.1), 0.65);
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