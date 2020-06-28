#define init
// character select button
global.sprMenuButton = sprite_add("sprites/selectIcon/sprSalamanderSelect.png", 1, 0,0);
// character select portrait
global.sprPortrait = sprite_add("sprites/portrait/sprPortraitSalamander.png",1 , 15, 205);

global.sprIcon = sprite_add("sprites/mapIcon/LoadOut_FireSalamander.png", 1, 10, 10);

// ultra sprites

global.sprSalamanderIdleB = sprite_add("sprites/sprSalamanderIdleB.png", 8, 24, 24);
global.sprSalamanderWalkB = sprite_add("sprites/sprSalamanderWalkB.png", 8, 24, 24);
global.sprSalamanderHurtB = sprite_add("sprites/sprSalamanderHurtB.png", 3, 24, 24);
global.sprSalamanderDeadB = sprite_add("sprites/sprSalamanderDeadB.png", 8, 24, 24);
global.sprSalamanderFireB = sprite_add("sprites/sprSalamanderFireB.png", 2, 24, 24);

// character select sounds
global.sndSelect = sndSalamanderFire;
var _race = [];
for(var i = 0; i < maxp; i++) _race[i] = player_get_race(i);
while(true){
	//character selection sound
	for(var i = 0; i < maxp; i++){
		var r = player_get_race(i);
		if(_race[i] != r && r = "salamander"){
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
if(ultra_get("salamander", 2)){
	spr_idle = global.sprSalamanderIdleB;
	spr_walk = global.sprSalamanderWalkB;
	spr_hurt = global.sprSalamanderHurtB;
	spr_dead = global.sprSalamanderDeadB;
}
else{
	spr_idle = sprSalamanderIdle;
	spr_walk = sprSalamanderWalk;
	spr_hurt = sprSalamanderHurt;
	spr_dead = sprSalamanderDead;
}
spr_sit1 = spr_idle;
spr_sit2 = spr_idle;

// sounds
snd_hurt = sndSalamanderHurt;
snd_dead = sndSalamanderDead;

// stats
maxspeed = 2.1;
team = 2;
maxhealth = 25;
melee = 0;	// can melee or not

cooldown = 0;
cooldown_base = 30;
is_spewing_fire = false;
fire_remaining = 60;
fire_max = 60;
fire_angle = 0;
fire_angle_increase = 0;
fireBar_alpha = 2;
loop = 0;
spit_timer = 0;

#define game_start
// executed after picking race and starting for each player picking this race
// player-specific global variable init


#define step
// executed within each player instance of this race after step
// most actives and passives handled here
canswap = 0;
canpick = 0;
boilcap = maxhealth;

lastscale = current_time_scale;

if(cooldown > 0){
	cooldown-= current_time_scale;
	canspec = false;
} else {
	canspec = true;
}

// Ultra A increased fuel
if(ultra_get("salamander", 1)){
	if(fire_max != 100){
		fire_max = 100;
	}
}

if(button_pressed(index, 'fire') && canspec = true){
	is_spewing_fire = true;

		sound_play(sndSalamanderFire);
		sound_play(sndSalamanderCharge);

	loop = sound_loop(sndSalamanderFireLoop);
	fire_angle = point_direction(x,y,mouse_x[index],mouse_y[index]);
}
if(button_released(index,"fire")){
	is_spewing_fire = false;
	fire_remaining = floor(fire_remaining);
}

//currently gushing flames
if(is_spewing_fire){
	canwalk = false;
	if(ultra_get("salamander", 2)){
		spr_idle = global.sprSalamanderFireB;
		spr_walk = global.sprSalamanderFireB;
	}
	else{
		spr_idle = sprSalamanderFire;
		spr_walk = sprSalamanderFire;
	}
	correction = sign(angle_difference(fire_angle,point_direction(x,y,mouse_x[index],mouse_y[index]))) * 2;
	fire_angle_increase = lerp(fire_angle_increase, correction, 0.1);
	fire_angle -= fire_angle_increase * current_time_scale;
	fire_remaining-= current_time_scale;
	fireBar_alpha = 2;
	
	if(fire_remaining - floor(fire_remaining) == 0){
		with(instance_create(x,y,TrapFire)){
			creator = other;
			team = creator.team;
			direction = creator.fire_angle;
			image_angle = direction;
			speed = 6;
			if(ultra_get("salamander", 2)){
				sprite_index = sprFireLilHunter;
				damage = 6;
			}
			else{
				sprite_index = sprSalamanderBullet;
				damage = 3
			}
		}
	}
} else {
	if(fire_remaining < fire_max){
		fire_remaining +=  current_time_scale; //fire refills when not in use
		if(ultra_get("salamander", 2)){
			if(fire_remaining < fire_max){
				fire_remaining +=  current_time_scale;	// Ultra B double refill
			}
		}
	} else {
		fireBar_alpha -= 0.1 * current_time_scale;
		fire_remaining = floor(fire_remaining);
	}
	
	if(ultra_get("salamander", 2)){
		spr_idle = global.sprSalamanderIdleB;
		spr_walk = global.sprSalamanderWalkB;
	}
	else{
		spr_idle = sprSalamanderIdle;
		spr_walk = sprSalamanderWalk;
	}
	canwalk = true;
	
	sound_stop(loop);
}

// fireball spec
if(button_pressed(index, "spec")){
	if(is_spewing_fire = false and canspec = true and fire_remaining >= 45){
		fireBar_alpha = 2;
		spit_timer = 5;
		sound_play_pitchvol(sndSalamanderCharge, random_range(1.5, 1.6), 1);
		if(ultra_get("salamander", 1)){
			sound_play_pitchvol(sndFlameCannon, random_range(0.9, 1.1), 1);
			sound_play_pitchvol(sndRatkingCharge, random_range(0.9, 1.1), 1);
			with(instance_create(x, y, FlameBall)){
				creator = other;
				team = creator.team;
				direction = creator.gunangle;
				speed = 8;
				damage = 15;
			}
		}
		else{
			sound_play_pitchvol(sndFlare, random_range(0.9, 1.1), 1);
			with(instance_create(x, y, Flare)){
				creator = other;
				team = creator.team;
				direction = creator.gunangle;
				speed = 8;
				damage = 12;
				if(ultra_get("salamander", 2)){
					image_blend = make_color_rgb(0, 148, 255);
				}
			}
		}
		fire_remaining -= 45;
	}
}

if(spit_timer > 0){
	if(ultra_get("salamander", 2)){
		if(sprite_index != global.sprSalamanderHurtB or sprite_index != global.sprSalamanderDeadB){
			sprite_index = global.sprSalamanderFireB;
		}
	}
	else{
		if(sprite_index != sprSalamanderHurt or sprite_index != sprSalamanderDead){
			sprite_index = sprSalamanderFire;
		}
	}
	spit_timer -= 1 * current_time_scale;
}

if(fire_remaining <= 0){
	fire_remaining = floor(fire_remaining);
	is_spewing_fire = false;
}

// outgoing contact damage
with(collision_rectangle(x + 12, y + 10, x - 12, y - 10, enemy, 0, 1)){
	if(sprite_index != spr_hurt){
		projectile_hit_push(self, 1, 4);
		sound_play_pitchvol(sndScorpionMelee,random_range(0.9,1.1),0.6);
	}
}

// Ultra B improved fire
if(ultra_get("salamander", 2)){
	with(instances_matching(Flame, "team", 2)){
		if("check" not in self){
			sprite_index = sprFireLilHunter;
			damage *= 2;
			check = true;
		}
	}
}

if(sprite_index = spr_hurt){
	if(ultra_get("salamander", 2)){
		if(spr_hurt != global.sprSalamanderHurtB){
			spr_hurt = global.sprSalamanderHurtB;
		}
	}
}

if(my_health <= 0){
	sound_stop(loop);
}

#define draw
//center coords
xx = x - 10;
yy = y - 10;
r = 8;
num = 32;

a = draw_get_alpha();
draw_set_alpha(fireBar_alpha);
//draw_triangle_color(x - 15, y - 10, x - 15 + ((fire_remaining/fire_max)*30), y - 10, x - 15 + ((fire_remaining/fire_max)*30), y - 10 - ((fire_remaining/fire_max)*5),c_red,c_orange,c_yellow, false);
draw_primitive_begin(pr_trianglestrip);
draw_set_color(c_red);
draw_vertex(xx, yy);
for(i = 0; i <= num; i += 1){
	if((fire_remaining/fire_max) >= (i / num)){
		if(fireBar_alpha = 1.5 || fireBar_alpha = 1.55 || fireBar_alpha = 1.6 || fireBar_alpha = 1.65  || fireBar_alpha = 1.8 || fireBar_alpha = 1.85 || fireBar_alpha = 1.9 || fireBar_alpha = 1.95 ){
			draw_set_color(c_white);
		} else {
		draw_set_color(make_color_hsv(40 * (i/num),255,255));
		}
		draw_vertex(xx - lengthdir_x(r, -90 + (360*i / num)), yy - lengthdir_y(r, -90 + (360*i / num)));
		draw_vertex(xx - lengthdir_x(r/2, -90 + (360*i / num)), yy - lengthdir_y(r/2, -90 + (360*i / num)));
	}
}
draw_primitive_end();

draw_primitive_begin(pr_linestrip);
draw_set_color(c_black);
for(i = 0; i <= num; i += 1){
	if((fire_remaining/fire_max) * 360 >= (360*i / num)){
		draw_set_color(c_black);
		draw_vertex(xx - lengthdir_x(r/2, -90 + (360*i / num)), yy - lengthdir_y(r/2, -90 + (360*i / num)));
	}
}
draw_primitive_end();

draw_primitive_begin(pr_linestrip);
draw_set_color(c_black);
for(i = 0; i <= num; i += 1){
	if((fire_remaining/fire_max) * 360 >= (360*i / num)){
		draw_set_color(c_black);
		draw_vertex(xx - lengthdir_x(r, -90 + (360*i / num)), yy - lengthdir_y(r, -90 + (360*i / num)));
	}
}
draw_primitive_end();

draw_set_alpha(a);
//alternate firebar:
//draw_line_width_color(x - ((fire_remaining/fire_max) * 24)/2, y - 10, x + ((fire_remaining/fire_max) * 24)/2, y - 10, 3, c_yellow, c_red);

#define race_name
// return race name for character select and various menus
return "SALAMANDER";

#define race_text
// return passive and active for character selection screen
return "SPITS @rFIRE";

#define race_portrait
// return portrait for character selection screen and pause menu
return global.sprPortrait;

#define race_mapicon
// return sprite for loading/pause menu map
return global.sprIcon;

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
	case 1: return "BACKED UP";
	case 2: return "SUPER HOT";
	default: return "";
}


#define race_ultra_text
// recieves ultra mutation index and returns description
switch(argument0){
	case 1: return "UPGRADED FIREBALL#MORE FUEL";
	case 2: return "UPGRADED FIRE#FUEL RECHARGES FASTER";
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
return choose("THIRSTY", "PIPING HOT", "MOLTEN BREATH", "FIRE EVERYWHERE", "ROASTY TOASTY", "MEDIUM RARE", "LEAPIN LIZARDS");