#define init
global.sprMenuButton = sprite_add("sprites/selectIcon/sprBoneFishSelect.png", 1, 0, 0);
global.sprPortrait = sprite_add("sprites/portrait/sprPortraitBonefish.png",1 , 15, 210);
global.sprIcon = sprite_add("sprites/mapIcon/LoadOut_Bonefish.png", 1, 10, 10);

// character select sounds
global.sndSelect = sndOasisChest;
var _race = [];
for(var i = 0; i < maxp; i++) _race[i] = player_get_race(i);
while(true){
	//character selection sound
	for(var i = 0; i < maxp; i++){
		var r = player_get_race(i);
		if(_race[i] != r && r = "bonefish"){
			sound_play_pitchvol(global.sndSelect,1.2,1);
		}
		_race[i] = r;
	}
	wait 1;
}

#define create
// player instance creation of this race
// https://bitbucket.org/YellowAfterlife/nuclearthronetogether/wiki/Scripting/Objects/Player

// sprites
spr_idle = sprBoneFish1Idle;
spr_walk = sprBoneFish1Walk;
spr_hurt = sprBoneFish1Hurt;
spr_dead = sprBoneFish1Dead;
spr_sit1 = sprBoneFish1Idle;
spr_sit2 = sprBoneFish1Idle;

// sounds
snd_hurt = sndOasisHurt;
snd_dead = sndOasisDeath;
snd_melee = sndOasisMelee;

// stats
maxspeed = 4;
erace_maxspeed_orig = maxspeed;
team = 2;
maxhealth = 6;
spr_shadow_y = 0;
mask_index = mskPlayer;

bupple_cooldown = 0;
bupple_cooldown_base = 45;

delay = 0;
delay_base = 7;

bupple_count = 5;
bupple_count_base = 5;

bupple_alpha = 2;
bupple_flash = 0;

bupple_excess = 15;

big_bupple = 0;
want_big = false;

// vars
melee = 1;	// can melee or not


#define game_start
// executed after picking race and starting for each player picking this race
// player-specific global variable init


#define step
// executed within each player instance of this race after step
// most actives and passives handled here

u1 = ultra_get(player_get_race(index), 1); //ultra 1: big ol' buppel
u2 = ultra_get(player_get_race(index), 2); //ultra 2: double bouble

script_bind_draw(custom_draw, -10);

if(big_bupple > 4) big_bupple = 0;
//passive: swimming
friction = 0.25;
footstep = 10;

// no weps
canswap = 0;
canpick = 0;

// face direction you're moving in- no weps
if(direction > 90 and direction <= 270){
	right = -1;
}
else{
	right = 1;
}

// outgoing contact damage
if(collision_rectangle(x + 12, y + 10, x - 12, y - 10, enemy, 0, 1)){
	with(instance_nearest(x, y, enemy)){
		if(sprite_index != spr_hurt){
			projectile_hit_push(self, 2, 4);
			sound_play_pitchvol(other.snd_melee,random_range(0.9,1.1),1);
			other.bupple_count += 1;
			other.bupple_excess = 15;
			other.bupple_flash = 2;
		}
	}
}

if(big_bupple == 4 and u1 == 1) {want_big = true;} else{want_big = false;}

if(delay <= 0){
	if(button_check(index, "spec") and bupple_count > 0){
		pdir = point_direction(x,y,mouse_x[index], mouse_y[index]);
		repeat(u2 + 1){
			with(instance_create(x,y,CustomObject)){
				name = "bupple"
				creator = other;
				sprite_index = sprPlayerBubble;
				image_index = 0;
				big = other.want_big; // 0 or 1
				maxhealth = 15 + 10*big;
				health = maxhealth;
				timer = 45;
				friction = 0.02;
				direction = other.pdir;
				damaged = 0;
				speed = random_range(5,7);

				dmg = 3 + 5*big;

				image_xscale = 1 + big;
				image_yscale = 1 + big;
				
				on_step = script_ref_create(bupple_step);
				on_draw = script_ref_create(bupple_draw);
			}
		}

		repeat(5){
			with(instance_create(x,y,Bubble)){
				direction = other.pdir + random_range(-15,15);
				friction = 0;
				speed = random_range(1,3)
			}
		}
		// sound_play_pitchvol(sndOasisHurt, 2.5 + random_range(-0.1,0.1), 0.25);
		sound_play_pitchvol(sndOasisChest, 1.5 + random_range(-0.1,0.1), 0.25);
		sound_play_pitchvol(sndOasisMelee, 1.5 + random_range(-0.1,0.1), 0.65);
		delay = min(delay_base, max(3, 15 - bupple_count));
		bupple_count--;
		bupple_excess = 15;
		bupple_flash = 2;
		big_bupple++;
	}
} else {
	delay -= current_time_scale;
}

if(bupple_count < bupple_count_base){
	bupple_alpha = 10;
	bupple_excess = 15;
	if(bupple_cooldown < 45){
		bupple_cooldown += current_time_scale;
	} else {
		bupple_count++;
		bupple_cooldown = 0;
	}
} else if (bupple_count > bupple_count_base) {
	bupple_alpha = 10;
	if(bupple_excess > 0){
		bupple_excess -= current_time_scale;
	} else {
		bupple_count--;
		bupple_excess = min(24, max(4, 30 - bupple_count));
	}
}

bupple_alpha -= 5/room_speed;

bupple_flash -= current_time_scale;

if(bupple_cooldown == 45 or bupple_excess == 0){
	bupple_flash = 2;
}

#define custom_draw
origalpha = draw_get_alpha();
origcolor = draw_get_color();
with(Player){
	if(bupple_count < 10){
		for(i = 0; i < bupple_count; i++){
			if(i == bupple_count){
				draw_set_alpha(bupple_cooldown/bupple_cooldown_base);
			} else {
				draw_set_alpha(1);
			}
			draw_set_alpha(bupple_alpha);
			//shadow
			d3d_set_fog(true, player_get_color(index), 0, 0);
			// draw_sprite(sprBubble, 3, x + i*8 - (4*(bupple_count)) + 4 - 1, y - 16 - (i mod 2 * 2));
			draw_sprite(sprBubble, 3, x + i*8 - (4*(bupple_count)) + 4, y - 16 - (i mod 2 * 2) + 1);

			// draw_set_color(c_white);
			d3d_set_fog(true, c_white, 0, 0);
			draw_sprite(sprBubble, 3, x + i*8 - (4*(bupple_count)) + 4, y - 16 - (i mod 2 * 2));
			if(bupple_flash > 0){
				draw_circle(x + i*8 - (4*(bupple_count)) + 3, y - 16 - (i mod 2 * 2), 4, false);
			}
			d3d_set_fog(false, c_blue, 0, 0);
		}
	} else {
		draw_set_alpha(1);
		draw_set_halign(fa_left);
		draw_set_valign(fa_center);
		d3d_set_fog(true, player_get_color(index), 0, 0);
		draw_sprite(sprBubble, 3, x - 8, y - 24 + 1);
		draw_text(x, y - 24 + 1, string(bupple_count));
		// draw_sprite(sprBubble, 3, x + i*8 - (4*(bupple_count)) + 4 - 1, y - 16 - (i mod 2 * 2));
		d3d_set_fog(false, player_get_color(index), 0, 0);
		draw_sprite(sprBubble, 3, x - 8, y - 24);
		if(bupple_flash > 0){
			draw_circle(x - 9, y - 24, 4, false);
		}
		draw_text(x, y - 24, string(bupple_count));
	}
}
draw_set_alpha(origalpha);
draw_set_color(origcolor);

instance_destroy();

#define bupple_step

timer-=current_time_scale;
damaged-=current_time_scale;
if(timer<=0){timer = 45; health--;}
health = clamp(health, 0, maxhealth);

motion_add_ct(90, 0.15);
vspeed = clamp(vspeed, -7, 7);
hspeed = clamp(hspeed, -6, 6);

hitwall = instance_place(x + hspeed/2, y,Wall);
if(instance_exists(hitwall)){
	direction = -direction + 180;
	speed *= 0.95;
	health -= 2;
	damaged = 3;
	sound_play_pitchvol(sndOasisShoot, 1.5 + random_range(-0.1,0.1), 0.15);
}

hitwall = instance_place(x, y + vspeed/2,Wall);
if(instance_exists(hitwall)){
	direction = -direction;
	speed *= 0.95;
	health -= 2;
	damaged = 3;
	sound_play_pitchvol(sndOasisShoot, 1.5 + random_range(-0.2,0.2), 0.15);
}

hit_thing = instance_place(x + hspeed/2, y + vspeed/2, hitme);
if(instance_exists(hit_thing)){
	if(hit_thing.team != 2){
		direction = point_direction(hit_thing.x,hit_thing.y,x,y);
		health--;
		damaged = 3;
		sound_play_pitchvol(sndOasisShoot, 1.5 + random_range(-0.2,0.2), 0.15);
		sound_play_pitchvol(sndOasisHurt, 2.5 + random_range(-0.1,0.1), 0.25);
		projectile_hit(hit_thing, dmg);
	}
}

proj = instance_place(x,y,projectile);
if(instance_exists(proj)){
	if(proj.team != 2){
		motion_add_ct(proj.direction, 4);
		health -= proj.damage;
		damaged = 3;
		sound_play_pitchvol(sndOasisShoot, 1.5 + random_range(-0.2,0.2), 0.15);
		with(proj){
			instance_destroy();
		}
	}
}

ex = instance_place(x,y,Explosion);
if(instance_exists(ex)){
	health -= ex.damage;
	damaged = 3;
	sound_play_pitchvol(sndOasisShoot, 1.5 + random_range(-0.2,0.2), 0.15);
}

bupple = instance_place(x,y,CustomObject);
if(instance_exists(bupple)){
	if("name" in bupple and bupple.name == "bupple"){
		direction = point_direction(bupple.x,bupple.y,x,y);
		health++;
		speed *= 1.1;
		instance_create(x,y,ThrowHit);
	}
}

if(health <= 0) {
	with(instance_create(x,y,BubblePop)){
		image_angle = random(360);
		image_speed = 1;
		image_xscale = other.image_xscale;
		image_yscale = image_xscale;
	}
	sound_play_pitchvol(sndOasisExplosionSmall, 2.5 + random_range(-0.1,0.1), 0.15);
	sound_play_pitchvol(sndOasisHurt, 2.5 + random_range(-0.1,0.1), 0.15);
	if(big){
		sound_play_pitchvol(sndOasisExplosion, 2.5 + random_range(-0.1,0.1), 0.15);
		repeat(irandom_range(5,10)){
			instance_create(x,y,Bubble);
		}
		repeat(3){
			with(instance_create(x,y,CustomObject)){
				name = "bupple"
				creator = other;
				sprite_index = sprPlayerBubble;
				image_index = 0;
				big = 0;
				maxhealth = 15;
				health = maxhealth;
				timer = 45;
				friction = 0.02;
				direction = random(360);
				damaged = 0;
				speed = random_range(5,7);

				dmg = 3;
				
				on_step = script_ref_create(bupple_step);
				on_draw = script_ref_create(bupple_draw);
			}
		}
	}
	instance_destroy();
}

#define bupple_draw
draw_self();

if(damaged>0){
	draw_set_color(c_white);
	draw_circle(x,y,13 + 13*big,false);
}

#define race_name
// return race name for character select and various menus
return "BONEFISH";


#define race_text
// return passive and active for character selection screen
return "CONTACT DAMAGE#@sSHOOT @wBUBBLES";


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
	case 1: return "BIG BUBBLE";
	case 2: return "DOUBLE BUBBLE"
	default: return "";
}


#define race_ultra_text
// recieves ultra mutation index and returns description
switch(argument0){
	case 1: return "@sFIRE A @wBIGGER BUBBLE @s OCCASIONALLY";
	case 2: return "@sFIRE @wTWO @sBUBBLES AT THE @wSAME TIME";
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
return choose("BLUB", "HOW AM I SWIMMING");