#define init
// for level start
global.newLevel = instance_exists(GenCont);
global.hasGenCont = false;

// character select button
global.sprMenuButton = sprite_add("sprites/selectIcon/sprJungleAssassinSelect.png", 1, 0, 0);

global.sprPortrait = sprite_add("sprites/portrait/sprPortraitJungleAssassin.png", 1, 15, 198);

global.sprIcon = sprite_add("sprites/mapIcon/LoadOut_JungleAssAssin.png", 1, 10, 10);

global.sprLeaf = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAAAsAAAAJCAYAAADkZNYtAAAABmJLR0QA/wD/AP+gvaeTAAAACXBIWXMAAA7DAAAOwwHHb6hkAAAAB3RJTUUH5AEWAQ0ghhHmdQAAAG5JREFUGNOVkDEOwCAIRT+1xMQzdXX2TB6J2dVLGWLs0Gpsmw6yED4P+AFYCHoLHLjNtYrSB+6Qiw4AUFJBzfUxsHfQRYeSygCtt4BH15qKEnHgZg7z69N6O65sKko112vT3ex5BlWUljwvfWMpTqPHQFwI58JVAAAAAElFTkSuQmCC", 1, 5, 5)

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

//lol


#define create
// player instance creation of this race
// https://bitbucket.org/YellowAfterlife/nuclearthronetogether/wiki/Scripting/Objects/Player

// sprites
spr_idle = sprJungleAssassinIdle;
spr_walk = sprJungleAssassinWalk;
spr_hurt = sprJungleAssassinHurt;
spr_dead = sprJungleAssassinDead;
spr_sit1 = spr_idle;
spr_sit2 = spr_idle;

// sounds
snd_hurt = sndJungleAssassinHurt;
snd_dead = sndJungleAssassinDead;

// stats
maxspeed = 4.5;
team = 2;
maxhealth = 12;
melee = 0;	// can melee or not
spec_load = 0;
want_load = false;

died = false;
lasthealth = maxhealth;

// vars
getup = 0;	// alarm to get up from faking

#define level_start
with(instances_matching(Player, "race", "jungleassassin")){
	// fake player
	with(instance_create(x, y, CustomObject)){
		creator = other;
		index = creator.index;
		sprite_index = sprJungleAssassinHide;
		image_speed = 0.4;
		depth = -1.1;
		getup = 180;
		mask_index = mskNone;
		on_step = script_ref_create(fake_step);
		// outline
		playerColor = player_get_color(creator.index);
		toDraw = self;
		script_bind_draw(draw_outline, depth, playerColor, toDraw);
	}
	// temp lighting fix
	with(instance_create(x, y, Wall)){
		creator = other;
		index = creator.index;
		topspr = mskNone;
		outspr = mskNone;
		sprite_index = mskNone;
		mask_index = mskNone;
	}
	fake = instances_matching(CustomObject, "index", index);
	light = instances_matching(Wall, "index", index);
	view_object[index] = fake[0];
	mask_index = mskNone;
	spr_idle = mskNone;
}


#define game_start
// executed after picking race and starting for each player picking this race
// player-specific global variable init


#define step
// executed within each player instance of this race after step
// most actives and passives handled here

// no more weps
canswap = 0;
canpick = 0;

if(button_check(index, "spec")){
	if("fake" in self){
		if(!instance_exists(fake[0])){
			if(spec_load <= 0){
				leaf_burst();
				want_load = true;
				spec_load = 15;
			}
		}
	}
}

if(spec_load > 0){
	spec_load -= current_time_scale;
}
else{
	if(want_load = true){
		want_load = false;
	}
}

if(my_health < lasthealth){
	spawnLeaf((lasthealth - my_health) * 5);
	lasthealth = my_health;
}

if(my_health > lasthealth){
	lasthealth = my_health;
}

if(my_health == 0){
	if(died == false){
		spawnLeaf(irandom_range(5,10));
	}
	died = true;
} else died = false;

with(instances_matching(Feather, "wantLeafDamage", true)){
	e = instance_place(x,y,enemy);
	if(e != noone and fall > 0){
		ApplyLeaf(e);
		instance_destroy();
	}
}

#define fake_step
if(getup > 0){
	creator.reload = 99;	// no firing
	if(image_index > 21 and image_index < 22){
		if(!audio_is_playing(sndJungleAssassinPretend)){
			sound_play(sndJungleAssassinPretend);
		}
	}
	
	// alarm management
	getup-= current_time_scale;
	
	// hide wep
	creator.wkick = 999;
	
	// cancel hiding
	with(creator){
		if(button_check(index, "nort") or button_check(index, "sout") or button_check(index, "east") or button_check(index, "west") or button_pressed(index, "fire") or other.getup <= 1){
			x = other.x;
			y = other.y;
			mask_index = mskPlayer;
			spr_idle = sprJungleAssassinIdle;
			sound_play(sndJungleAssassinWake);
			spawnLeaf(irandom_range(5,10));
			wkick = 0;
			other.getup = 0;
			reload = 0;
			view_object[index] = self;
			instance_delete(fake[0]);
			instance_delete(light[0]);
		}
	}
}

#define leaf_burst()
var _x = x + lengthdir_x(5, gunangle);
var _y = y + lengthdir_y(5, gunangle);
with instance_create(_x, _y, CustomObject){
	name = "leafBurst";
	creator = other;
	team = creator.team;
	mask_index = mskNone;
	spr_shadow = mskNone;
	direction = other.gunangle;
	friction = 0;
	on_step = script_ref_create(leafBurst_step);
	alarm = [0];
	maxammo = 2;
	ammo = maxammo;
}

#define leafBurst_step
if(instance_exists(creator)){
	direction = creator.gunangle + (random(creator.accuracy) * choose(1, -1) * random(3));
	// follow player
	x = creator.x + lengthdir_x(5, creator.gunangle);
	y = creator.y + lengthdir_y(5, creator.gunangle);
	// fire bullets
	if(alarm[0] <= 0){	// 2 bullets
		sound_play_pitchvol(sndLuckyShotProc, 2 + random_range(-0.2, 0.2), 0.9);
		sound_play_pitchvol(sndSwapSword, 2.6 + random_range(-0.2, 0.2), 0.45);
		sound_play_pitchvol(sndHitPlant, 1.8 + random_range(-0.2, 0.2), 0.35);
		sound_play_pitchvol(sndJungleAssassinAttack, 3 + random_range(-0.2, 0.2), 0.25);
		view_shake[creator.index] += 6;
		with(instance_create(x, y, CustomProjectile)){
			sprite_index = global.sprLeaf;
			image_blend = c_green;
			mask_index = mskBouncerBullet;
			creator = other.creator;
			team = creator.team;
			direction = other.direction;
			image_angle = direction;
			image_yscale = 0.75;
			friction = 0;
			speed = 12;
			damage = 0;
			on_hit = script_ref_create(leaf_hit);
			on_wall = script_ref_create(leaf_wall);
			on_destroy = script_ref_create(leaf_destroy);
		}
		ammo--;
	}
	for(i = 0; i < array_length(alarm); i++){
		if(alarm[i] <= 0){
			alarm[i] = irandom_range(1, 5);
		}
		alarm[i]-= current_time_scale;
	}
	if(ammo <= 0){
		instance_destroy();
	}
}

#define leaf_hit
projectile_hit(other, damage, direction);
other.nexthurt = current_frame;
ApplyLeaf(other);
instance_destroy();

#define leaf_wall

spawnLeaf(1);
instance_destroy();

#define leaf_destroy
with(instance_create(x,y,RainSplash)){
	image_angle = other.direction + 90;
	image_index = 0;
	image_blend = c_green;
	image_speed = 1;
}



#define spawnLeaf(count)

repeat(count){
	with(instance_create(x,y,Feather)){
		sprite_index = sprLeaf;
		wantLeafDamage = true;
	}
}


#define race_name
// return race name for character select and various menus
return "JUNGLE ASSASSIN";


#define race_text
// return passive and active for character selection screen
return "@sSTART @wHIDDEN#@sTHROW @gLEAVES";


#define race_portrait
// return portrait for character selection screen and pause menu
return global.sprPortrait;


#define race_mapicon
// return sprite for loading/pause menu map
return global.sprIcon;


#define race_swep
// return ID for race starting weapon
return "assassin";


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
	case 1: return "BLEEDING EDGE";
	case 2: return "TECHNOLOGY";
	default: return "";
}


#define race_ultra_text
// recieves ultra mutation index and returns description
switch(argument0){
	case 1: return "SHURIKENS DEAL @rBLEEDING @sDAMAGE";
	case 2: return "@gHIGHLY ADVANCED @sPIPE-BASED WEAPONRY";
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
return choose("THEY'LL NEVER SEE IT COMING", "HIDING IN PLAIN SIGHT", "@gRUSTLE RUSTLE", "LOOK LIKE A SMALL TREE", "@gI FIT RIGHT IN");

#define draw_outline(playerColor, toDraw)
d3d_set_fog(1,playerColor,0,0);
if(instance_exists(toDraw)){
    with(toDraw){
        draw_sprite_ext(sprite_index, -1, x - 1, y, 1, 1, 0, playerColor, 1);
        draw_sprite_ext(sprite_index, -1, x + 1, y, 1, 1, 0, playerColor, 1);
        draw_sprite_ext(sprite_index, -1, x, y - 1, 1, 1, 0, playerColor, 1);
        draw_sprite_ext(sprite_index, -1, x, y + 1, 1, 1, 0, playerColor, 1);
    }
}
d3d_set_fog(0,c_lime,0,0);

#define ApplyLeaf(trg)
with(trg){
	if("lasthealth" not in self) {lasthealth = my_health;}
	if("leaf_debuff" not in self){
		leaf_debuff = instance_create(x,y,CustomObject);
		with(leaf_debuff){
			image_blend_orig = other.image_blend;
			target = other;
			active = true;
			ticks = 1;
			maxticks = 5;
			timer = 120;
			depth = -2.1;
			dmg = 0;
			leaves = array_create(0);
			on_step = script_ref_create(leaf_debuff_step);
			on_draw = script_ref_create(leaf_debuff_draw);
		}
	} else {
		with(leaf_debuff){
			timer = 120;
			if(ticks < maxticks){
				ticks++;
			} else {
				dmg = max(2, target.my_health * 0.02); //2 damage or 2% of current hp
				projectile_hit(target, dmg);
				nexthurt = current_frame;
				sub = ticks;

				sound_play_pitchvol(sndJungleAssassinHurt, 2, 0.3 + ticks/25);
				sound_play_pitchvol(sndJungleAssassinWake, 2.6, ticks/10);
				target.lasthealth = target.my_health;
			}
		}
	}
}

#define leaf_debuff_step
if(instance_exists(target)){
	if(active){
		if(object_is_ancestor(target.object_index, becomenemy) == false){
			x = target.x;
			y = target.y;
			depth = target.depth - 0.1;
			dmg = max(ticks, target.my_health * ticks * 0.01); 
			//does x damage or x% of current health, whichever is greatest

			if(target.my_health < target.lasthealth){ //on taking damage
				target.my_health -= dmg;
				sub = ticks;
				ticks -= 1;
				repeat(sub * 3){
					with(instance_create(x,y,Feather)){
						sprite_index = sprLeaf;
						image_blend = c_red;
						fall = random_range(30,60);
					}
				}
				sound_play_pitchvol(sndJungleAssassinHurt, 2 - (ticks/12), 0.3 + ticks/25);
				sound_play_pitchvol(sndJungleAssassinWake, 2.6 - (ticks/30), ticks/10);
				target.lasthealth = target.my_health;
			}

			if(target.my_health > target.lasthealth){
				//healed, somehow
				target.lasthealth = target.my_health;
			}
			if(timer <= 0){
				timer = 90;
				ticks--;
				with(instance_create(x,y,Feather)){
					sprite_index = sprLeaf;
					image_blend = c_orange;
				}
			} else {
				timer -= current_time_scale;
			}
		}
	} else {
		if(target.my_health < target.lasthealth){
			target.lasthealth = target.my_health;
		}
		if(target.my_health > target.lasthealth){
			target.lasthealth = target.my_health;
		}
	}

	if(ticks > 0) {
		active = true;
	} else {
		active = false;
	}

} else {
	repeat(ticks){
		with(instance_create(x,y,Feather)){
			sprite_index = sprLeaf;
			image_blend = c_red;
			fall = random_range(30,60);
		}
	}
	instance_destroy();

}

#define leaf_debuff_draw
if(instance_exists(target) and active){
	if(object_is_ancestor(target.object_index, becomenemy) == false){
		with(target){
			if("z" not in self){z = 0;}
			if("right" not in self){right = image_xscale;}
			d3d_set_fog(true, merge_color(c_green, c_lime, other.ticks/10), 0, 0);
			
			if("drawspr" in self and "drawimg" in self){
				draw_sprite_ext(drawspr, drawimg, x, y - z, right, image_yscale, image_angle, c_white, 0.25 + other.ticks/40);
			} else {
				draw_sprite_ext(sprite_index, image_index, x, y - z, right, image_yscale, image_angle, c_white, 0.25 + other.ticks/40);
			}

			d3d_set_fog(false, c_red, 0, 0);

			for(i = -1; i < other.ticks; i++){
			    ang = (90 + other.ticks*12)/other.ticks * i;
			    if(i > 0 && i < other.ticks){
			        _x = x + lengthdir_x(16 + other.ticks/2, ang + (45 - other.ticks*6));
			        _y = y + lengthdir_y(16 + other.ticks/2, ang + (45 - other.ticks*6));
					d3d_set_fog(true, c_black, 0, 0);
			        draw_sprite_ext(sprLeaf, 0, _x, _y+1, 1, 1, 0, c_white, 1);
					d3d_set_fog(true, c_lime, 0, 0);
			        draw_sprite_ext(sprLeaf, 0, _x, _y, 1, 1, 0, c_white, 0.9);
					d3d_set_fog(false, c_lime, 0, 0);
			    }
			}
		}
	}
}