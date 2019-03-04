#define init
global.sprMenuButton = sprite_add("sprites/sprVanSelect.png", 1, 0, 0);
global.sprPortrait = mskNone;
global.sprEmptyHurt = sprite_add("sprites/sprDogHit.png", 3, 0, 0);
global.sprAnime = sprite_add("sprites/anime_squish.png", 30, 0, 0);
global.sndmusAbegin = sound_add("sounds/sndAbegin.ogg");
global.sndmusAloop = sound_add("sounds/sndAloop.ogg");
global.sndmusBbegin = sound_add("sounds/sndBbegin.ogg");
global.sndmusBloop = sound_add("sounds/sndBloop.ogg");
global.sndRecordA = sound_add("sounds/sndRecordScratch1.ogg");
global.sndRecordB = sound_add("sounds/sndRecordScratch2.ogg");

// level start init- MUST GO AT END OF INIT
global.newLevel = instance_exists(GenCont);
global.hasGenCont = false;
global.sndSelect = sndVanWarning;
var _race = [];
for(var i = 0; i < maxp; i++) _race[i] = player_get_race(i);
while(true){
	//character selection sound
	for(var i = 0; i < maxp; i++){
		var r = player_get_race(i);
		if(_race[i] != r && r = "van"){
			sound_play(global.sndSelect);
		}
		_race[i] = r;
	}
	// first chunk here happens at the start of the level, second happens in portal
	if(instance_exists(GenCont)) global.newLevel = 1;
	else if(global.newLevel){
		global.newLevel = 0;
	}
	var hadGenCont = global.hasGenCont;
	global.hasGenCont = instance_exists(GenCont);
	if (!hadGenCont && global.hasGenCont) {
		//
	}
	wait 1;
}

#define level_start

#define create
// player instance creation of this race
// https://bitbucket.org/YellowAfterlife/nuclearthronetogether/wiki/Scripting/Objects/Player

// sprites
spr_idle = mskNone;
spr_walk = mskNone;
spr_hurt = global.sprEmptyHurt;
spr_dead = mskNone;
spr_sit1 = sprMutant15GoSit;
spr_sit2 = sprMutant15Sit;

// sounds
snd_hurt = sndVanHurt;
snd_dead = sndExplosion;

// stats
maxspeed = 5;
team = 2;
maxhealth = 250;
spr_shadow_y = -8;
spr_shadow = mskNone;
mask_index = mskNone;
canwalk = 0;
friction = 0;
right = choose(-1, 1);
dir = right;

// vars
melee = 1;	// can melee or not
want_van = 50;	// time until van
sprite_change = false;	// sprites not changed
my_wall = -4;	// van cover
deploy_alarm = 0;
my_portal = -4;
want_portal = true;
speed = 0;
roll_time = 0;
sprite_angle = 0;
my_direction = noone;
my_anime = noone;
music_index = choose(0,1);
music_start = [global.sndmusAbegin,global.sndmusBbegin];
music_loop = [global.sndmusAloop, global.sndmusBloop];
is_in_portal = false;

if("anime_sound_start" not in self){
	anime_sound_start = -1;
}

if("anime_sound_loop" not in self){
	anime_sound_loop = -1;
} else {
	if(audio_is_playing(anime_sound_loop)){
		sound_stop(anime_sound_loop);
	}
}


#define game_start
// executed after picking race and starting for each player picking this race
// player-specific global variable init


#define step
// executed within each player instance of this race after step
// most actives and passives handled here

footstep = 10;
u1 = ultra_get(player_get_race(index), 1);

// no weps
canswap = 0;
canpick = 0;
if(wep != 0){
	wep = 0;
}

// no walking
canwalk = 0;

// sprite faces direction, as you have no weps
right = 1;
//direction = dir;

//direction thing
if(instance_exists(my_direction) == false){
	if(want_van > 0){
		my_direction = instance_create(x,y, CustomObject);
	}
	with(my_direction){
		name = "VanDirection";
		d = 1; //left or right
		depth = -10;
		sprite_index = sprRogueStrike;
		image_alpha = 0.3;
		image_speed = 0.4;
		speed = 0;
		friction = 0;
		spr_shadow = mskNone;
		mask_index = mskNone;
		image_speed = 0.5;
	}
} else {
	with(my_direction){
		if(button_pressed(other.index, "west")){
			d = -1;
		} 
		if(button_pressed(other.index, "east")){
			d = 1;
		}
		image_xscale = d;
		other.dir = d;
		if(other.u1 == 1){
			if(d = 1){
				other.sprite_angle = 0;
			} else {
				other.sprite_angle = 180;
			}
		}
	}
	if(want_van <= 0){
		instance_delete(my_direction);
	}
}

// spawn portal graphic
if(!instance_exists(my_portal) and want_portal = true){
	my_portal = instance_create(x, y, CustomObject);
	with(my_portal){
		creator = other;
		name = "VanPortal";
		depth = -11;
		sprite_index = sprVanPortalStart;
		speed = 0;
		friction = 0;
		spr_shadow = mskNone;
		mask_index = mskNone;
		sprite_alarm = 83;
		image_speed = 0.5;
		on_step = script_ref_create(vp_step);
	}
}

// spawn van
if(want_van <= 0){
	if(sprite_change = false){
		sound_play_pitch(sndVanPortal, random_range(0.9, 1.1));
		spr_idle = sprVanDrive;
		spr_walk = sprVanDrive;
		spr_hurt = sprVanHurt;
		spr_dead = sprVanDead;
		mask_index = mskVan;
		spr_shadow = shd96;
		deploy_alarm = 40;
		if(instance_exists(my_wall)){
			with(my_wall){
				instance_destroy();
			}
			my_wall = -4;
		}
		sprite_change = true;
		if(audio_is_playing(anime_sound_start)){
			sound_stop(anime_sound_start);
		}
	}

	if(u1 == 1){
		if(instance_exists(Portal)){			
			if(audio_is_playing(anime_sound_loop)){
				sound_stop(anime_sound_loop);
				sound_play(choose(global.sndRecordA,global.sndRecordB));
			}
			_port = instance_nearest(x,y,Portal);
			if(point_distance(x,y,_port.x,_port.y) < 25){
				is_in_portal = true;
				direction = point_direction(x,y, _port.x,_port.y);
			} else {
				is_in_portal = false;
			}
		} else {
			if(audio_is_playing(anime_sound_loop) == false){
				anime_sound_loop = sound_loop(music_loop[music_index]);
			}
		}
		while(collision_rectangle(x + 42, y + 40, x - 42, y - 40, Wall, 0, 1) != noone){
			with(collision_rectangle(x + 42, y + 40, x - 42, y - 40, Wall, 0, 1)){
				if(mask_index == mskNone){
					continue;
				}
				instance_create(x, y, FloorExplo);
				instance_destroy();
			}
		}
		deploy_alarm = 20;
		friction = 0.4;
		if(instance_exists(my_anime) == false){
			my_anime = instance_create(x,y,CustomObject);
		} else {
			with(my_anime){
				creator = other;
				name = "animeSpeed";
				depth = -100;
				sprite_index = global.sprAnime;
				speed = 0;
				friction = 0;
				spr_shadow = mskNone;
				mask_index = mskNone;
				image_speed = 1;
				on_step = script_ref_create(anime_step);

			}
		}
		sprite_angle += (button_check(index,"west") * 7) - ((button_check(index,"east") * 7));
		if(abs(sprite_angle mod 360) >= 90 and abs(sprite_angle mod 360) <= 270){
			image_yscale = -1;
		} else {
			image_yscale = 1;
		}
		maxspeed = 10;

		if(is_in_portal = false){
			if(speed < 3){
				motion_set(sprite_angle, 3);
			}
			motion_add(sprite_angle, 0.8);
		}

		if(button_pressed(index,"spec")){
			deploy_alarm = -1;
			if(audio_is_playing(anime_sound_loop)){
				sound_stop(anime_sound_loop);
				sound_play(choose(global.sndRecordA,global.sndRecordB));
			}
		}
	} else {
		with(collision_rectangle(x + 42, y + 22, x - 42, y - 22, Wall, 0, 1)){
			if(mask_index == mskNone){
				continue;
			}
			instance_create(x, y, FloorExplo);
			instance_destroy();
		}
		x += maxspeed * dir;
		right = dir;
	}

	// outgoing contact damage
	with(collision_rectangle(x + 37, y + 22, x - 37, y - 22, enemy, 0, 1)){
		if(sprite_index != spr_hurt){
			my_health -= 20;
			sound_play(snd_hurt);
			sprite_index = spr_hurt;
			direction = other.direction;
		}
	}
	// outgoing contact damage PROP
	with(collision_rectangle(x + 37, y + 22, x - 37, y - 22, prop, 0, 1)){
		if(sprite_index != spr_hurt){
			my_health -= 20;
			sound_play(snd_hurt);
			sprite_index = spr_hurt;
			direction = other.direction;
		}
	}
	
	if(deploy_alarm >= 0){
		deploy_alarm -= current_time_scale;
	}
	else{
		sound_play(sndVanOpen);
		sprite_angle = 0;
		image_yscale = 1;
		with(instance_create(x, y, CustomHitme)){
			depth = 1;
			creator = other;
			team = creator.team;
			right = other.right;
			direction = other.direction;
			friction = 0;
			speed = 0;
			spr_shadow = shd96;
			spr_shadow_y = -8;
			my_health = other.my_health;
			spr_hurt = sprVanHurt;
			spr_dead = sprVanDead;
			name = "deacvan";
			size = 3;
			sprite_index = sprVanOpen;
			image_speed = 0.5;
			deac_alarm = 30;
			on_step = script_ref_create(van_step);
			on_hurt = script_ref_create(van_hurt);
			on_draw = script_ref_create(van_draw);
			on_destroy = script_ref_create(van_destroy);
		}
		repeat(3 + GameCont.loops){
			popo_x = x - (37 * right);
			popo_y = y + random_range(-10, 10);
			daddy = self;
			spawn_popo(popo_x, popo_y, daddy);
		}
		race = choose("grunt", "inspector", "shielder");
		x = x - (37 * right);
		y = y + random_range(-10, 10);
		if(race = "grunt"){
			roll_time = 10;
		}
		canwalk = true;
		wep = race;
		wantrace = "van";
		for(i = 1; i < 6; i++){
			ammo[i] = 55;
			if(i = 1){
				ammo[i] = 255
			}
		}
	}
}
else{
	if(my_wall = -4){
		my_wall = instance_create(x, y, Wall);
		if(u1 == 0){
			sound_play(sndVanWarning);
		} else {
			anime_sound_start = sound_play_pitchvol(music_start[music_index], 1, 2);
		}
		with(my_wall){
			creator = other;
			mask_index = mskNone;
			sprite_index = mskNone;
			topspr = mskNone;
			outspr = mskNone;
			name = "VanCover";
		}
	}
	if(instance_exists(my_anime)){
		instance_delete(my_anime);
	}
}

if(want_van >= 0){
	want_van -= current_time_scale;
}

#define anime_step
if("creator" in self){
	x = view_xview[creator.index];
	y = view_yview[creator.index];
	image_xscale = game_width/320;
	image_yscale = game_height/240;
	image_alpha = 0.5;

	if(creator.deploy_alarm < 0 or creator.want_van > 0 or instance_exists(GenCont)){
		instance_destroy(); // delet this
	}
}

#define vp_step
/*if(random(3) < 1){
	var _dir = random(360);
	with(instance_create(x + lengthdir_x(_dir, 15), y + lengthdir_y(_dir, 15), IDPDPortalCharge)){
		creator = other;
		direction = point_direction(x, y, creator.x, creator.y);
		speed = random_range(3, 4);
	}
}*/

if(sprite_alarm >= 0){
	sprite_alarm -= current_time_scale;
}

if(sprite_alarm >= 79){
	sprite_index = sprVanPortalStart;
}
else if(sprite_alarm >= 28){
	sprite_index = sprVanPortalCharge;
}
else if(sprite_alarm > 0){
	sprite_index = sprVanPortalClose;
}
else if(sprite_alarm <= 0){
	if(instance_exists(creator)){
		creator.want_portal = false;
	}
	instance_destroy();
}


#define van_step
if(my_health > 0){
	// speed management
	speed = 0;
	friction = 0;
	
	// sprite stuff
	if(nexthurt <= 0){
		if(deac_alarm >= 22){
			sprite_index = sprVanOpen;
		}
		else if(deac_alarm >= 20){
			sprite_index = sprVanOpenIdle;
		}
		else if(deac_alarm >= 16){
			sprite_index = sprVanDeactivate;
		}
		else{
			sprite_index = sprVanDeactivated;
		}
	}

	if(right = 1){
		image_xscale = 1;
	}
	else{
		image_xscale = -1;
	}
	
	if(deac_alarm >= 0){
		deac_alarm -= current_time_scale;
	}
	
	if(nexthurt >= 0){
		nexthurt -= current_time_scale;
	}
}
else{
	instance_destroy();
}

#define van_draw
if(nexthurt >= 2){
	d3d_set_fog(1, c_white, 0, 0);
	draw_sprite_ext(sprite_index, image_number, x, y, 1 * right, 1, 0, c_white, 1);
	d3d_set_fog(0, c_lime, 0, 0);
}
else{
	draw_self();
}

#define van_destroy
// create corpse
repeat(3){
	instance_create(x, y, PopoExplosion);
}
with(instance_create(x, y, Corpse)){
	sprite_index = other.spr_dead;
	size = 3;
}

#define van_hurt(damage, kb_vel, kb_dir)
// incoming damage
if(nexthurt <= 0){
	my_health -= argument0;
	sound_play_pitch(sndVanHurt, random_range(0.9, 1.1));
	motion_add(argument2 / size, argument1 / size);
	nexthurt = 6;
}

#define race_name
// return race name for character select and various menus
return "I.D.P.D. VAN";


#define race_text
// return passive and active for character selection screen
return "CONTACT DAMAGE#@sDEPLOY @bREINFORCEMENTS#FREEZE!";


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
	case 1: return "INTERDIMENSIONAL DRIFTING";
	default: return "";
}


#define race_ultra_text
// recieves ultra mutation index and returns description
switch(argument0){
	case 1: return "@yLEFT/RIGHT @w TO STEER#@yRIGHT CLICK @wTO DEPLOY";
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
return choose("OPEN UP", "POLICE", "PAGING ALL UNITS", "FREEZE!", "YES POPO");

#define spawn_popo(popo_x, popo_y, daddy)
var _c = random(3);
if(_c >= 2){
	with(instance_create(popo_x + random_range(-8, 8), popo_y + random_range(-8, 8), CustomHitme)){
		name = "squad";
		class = "grunt";	// type
		creator = daddy;	//	player
		team = creator.team;	// player team

		//sprites
		spr_idle = sprGruntIdle;
		spr_walk = sprGruntWalk;
		spr_hurt = sprGruntHurt;
		spr_dead = sprGruntDead;

		//sounds
		if(random(2) < 1){
			snd_hurt = sndGruntHurtM;
			snd_dead = sndGruntDeadM;
			snd_entr = sndGruntEnterM;
			snd_nade = sndGruntThrowNadeM;
		}
		else{
			snd_hurt = sndGruntHurtF;
			snd_dead = sndGruntDeadF;
			snd_entr = sndGruntEnterF;
			snd_nade = sndGruntThrowNadeF;
		}
		
		sound_play_pitch(snd_entr, 1 + random_range(-0.1, 0.1));	// enter sound
		depth = -1.9;
		sprite_index = spr_idle;	// current sprite
		my_health = 8;	// health
		iframes = 0;
		maxspeed = 3.5;	// top speed before being limited
		mask_index = mskPlayer;	// hitbox
		size = 1;	// deals with collision
		image_speed = 0.4;	// animation frame rate
		spr_shadow = shd24;	// shadow sprite
		direction = random(360);
		move_bounce_solid(true);
		friction = 0.01;
		right = choose(-1, 1);	// facing right or left
		target = [creator, -4];	// friendly, enemy
		alarm = [
					0,	// movement/targeting alarm
					0,	// firing
					0	// targeting
				];
		roll_time = 10;	// for rolling
		wepangle = 0;
		ammo = 0;
		gunangle = random(360);
		wkick = 0;
		wep = "grunt";
		accuracy = 8;
		reload = 0;
		on_step = script_ref_create(grunt_step);
		on_hurt = script_ref_create(squad_hurt);
		on_draw = script_ref_create(squad_draw);
		on_destroy = script_ref_create(squad_destroy);
		wall_stuck = 0;
	}
}
else if(_c >= 1){
	with(instance_create(popo_x + random_range(-8, 8), popo_y + random_range(-8, 8), CustomHitme)){
		name = "squad";
		class = "shielder";	// type
		creator = daddy;	//	player
		team = creator.team;	// player team

		//sprites
		spr_idle = sprShielderIdle;
		spr_walk = sprShielderWalk;
		spr_hurt = sprShielderHurt;
		spr_dead = sprShielderDead;

		//sounds
		if(random(2) < 1){
			snd_hurt = sndShielderHurtM;
			snd_dead = sndShielderDeadM;
			snd_entr = sndShielderEnterM;
			snd_shld = sndShielderShieldM;
		}
		else{
			snd_hurt = sndShielderHurtF;
			snd_dead = sndShielderDeadF;
			snd_entr = sndShielderEnterF;
			snd_shld = sndShielderShieldF;
		}
		
		sound_play_pitch(snd_entr, 1 + random_range(-0.1, 0.1));	// enter sound
		depth = -1.9;
		sprite_index = spr_idle;	// current sprite
		my_health = 45;	// health
		iframes = 0;
		maxspeed = 3.5;	// top speed before being limited
		mask_index = mskPlayer;	// hitbox
		size = 1;	// deals with collision
		image_speed = 0.4;	// animation frame rate
		spr_shadow = shd24;	// shadow sprite
		direction = random(360);
		move_bounce_solid(true);
		friction = 0.01;
		right = choose(-1, 1);	// facing right or left
		target = [creator, -4];	// friendly, enemy
		alarm = [
					0,	// movement/targeting alarm
					0,	// firing
					0,	// targeting
				];
		shieldCool = 0;
		shielding = false;
		wepangle = 0;
		gunangle = random(360);
		wkick = 0;
		wep = "shielder";
		accuracy = 8;
		reload = 0;
		ammo = 0;
		on_step = script_ref_create(shielder_step);
		on_hurt = script_ref_create(squad_hurt);
		on_draw = script_ref_create(squad_draw);
		on_destroy = script_ref_create(squad_destroy);
		wall_stuck = 0;
	}
}
else if(_c >= 0){
	with(instance_create(popo_x + random_range(-8, 8), popo_y + random_range(-8, 8), CustomHitme)){
		name = "squad";
		class = "inspector";	// type
		creator = daddy;	//	player
		team = creator.team;	// player team

		//sprites
		spr_idle = sprInspectorIdle;
		spr_walk = sprInspectorWalk;
		spr_hurt = sprInspectorHurt;
		spr_dead = sprInspectorDead;

		//sounds
		if(random(2) < 1){
			snd_hurt = sndInspectorHurtM;
			snd_dead = sndInspectorDeadM;
			snd_entr = sndInspectorEnterM;
			snd_strt = sndInspectorStartM;
			snd_stop = sndInspectorEndM;
		}
		else{
			snd_hurt = sndInspectorHurtF;
			snd_dead = sndInspectorDeadF;
			snd_entr = sndInspectorEnterF;
			snd_strt = sndInspectorStartF;
			snd_stop = sndInspectorEndF;
		}
		
		sound_play_pitch(snd_entr, 1 + random_range(-0.1, 0.1));	// enter sound
		depth = -1.9;
		sprite_index = spr_idle;	// current sprite
		my_health = 10;	// health
		maxspeed = 3.5;	// top speed before being limited
		iframes = 0;
		mask_index = mskPlayer;	// hitbox
		size = 1;	// deals with collision
		image_speed = 0.4;	// animation frame rate
		spr_shadow = shd24;	// shadow sprite
		direction = random(360);
		move_bounce_solid(true);
		friction = 0.01;
		right = choose(-1, 1);	// facing right or left
		target = [creator, -4];	// friendly, enemy
		alarm = [
					0,	// movement/targeting alarm
					0,	// firing
					0,	// targeting
					0,	// telekenesis duration
					120 + irandom(100)	// telekenesis propt
				];
		pulling = 0;
		pull_strength = 0.5;
		wepangle = 0;
		ammo = 0;
		gunangle = random(360);
		wkick = 0;
		wep = "inspector";
		accuracy = 8;
		reload = 0;
		on_step = script_ref_create(inspector_step);
		on_hurt = script_ref_create(squad_hurt);
		on_draw = script_ref_create(squad_draw);
		on_destroy = script_ref_create(squad_destroy);
		wall_stuck = 0;
	}
}


#define inspector_step
if(my_health > 0){
	// speed management
	if(speed > maxspeed){
		speed = maxspeed;
	}
	
	// collision
	move_bounce_solid(true);
	
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

	// targeting
	if(instance_exists(enemy)){
		var _e = instance_nearest(x, y, enemy);
		if(distance_to_object(_e) < 100 and !collision_line(x, y, _e.x, _e.y, Wall, true, true) and alarm[2] = 0){
			target[@1] = _e;
			var _t2 = target[1];
			gunangle = point_direction(x, y, _t2.x, _t2.y);
			alarm[2] = 5;
		}
		else{
			target[@1] = -4;	// can't see
		}
	}

	// movement
	if(target[0] = noone){	// no target, random movement
		if(alarm[0] = 0){
			direction = random(360);
			move_bounce_solid(true);
			motion_set(direction, maxspeed);
			alarm[0] = irandom_range(10, 30);
		}
	}
	else if(target[0] = creator and instance_exists(creator)){	// follow player
		if(distance_to_object(target[0]) <= 50){
			if(alarm[0] = 0){
				var _t1 = target[0];
				speed = 0;
				alarm[0] = irandom_range(10, 15);
			}
		}
		if(distance_to_object(target[0]) > 80){
			if(alarm[0] = 0){
				var _t1 = target[0];
				direction = point_direction(x, y, _t1.x, _t1.y) + random_range(-50, 50);
				move_bounce_solid(true);
				motion_set(direction, maxspeed);
				if(random(3) < 1){
					if(ammo <= 0){
						gunangle = random(360);
					}
				}
				alarm[0] = irandom_range(10, 15);
			}
		}
		else if(distance_to_object(target[0]) > 400){	// if too far away, teleport
			_dir = point_direction(creator.x, creator.y, x, y);
			_x = creator.x + lengthdir_x(350, _dir);
			_y = creator.y + lengthdir_y(350, _dir);
			_f = instance_nearest(_x, _y, Floor);
			x = _f.x + 4;
			y = _f.y + 4;
		}
	}
	
	if(instance_exists(target[1])){	// fire
		if(instance_exists(target[0])){
			if(distance_to_object(target[0]) < 220){
				if(reload <= 0 and pulling = false and ammo <= 0){
					sound_play_gun(sndGruntFire, 0.2, 0.6);
					with(instance_create(x, y, PopoSlug)){
						sprite_index = sprPopoSlug;
						spr_dead = sprPopoSlugDisappear;
						creator = other;
						team = creator.team;
						creator.wkick = 10;
						direction = other.gunangle;
						image_angle = direction;
						friction = 0.8;
						speed = 15;
						damage = 5;
					}
					wkick = 10;
					reload = 30 + irandom(50);
				}
			}
		}
	}
	
	if(ammo > 0){	// manage ammo
		speed = 0;
	}
	
	if(reload > 0){	// manage reload
		reload-= current_time_scale;
	}
	
	if(wkick > 0){	// manage weapon kick
		wkick-= current_time_scale;
	}
	
	// start pulling
	if(alarm[4] = 0 and alarm[3] = 0 and pulling = false){
		alarm[3] = 60 + irandom(30);
		sound_play_pitch(snd_strt, irandom_range(0.9, 1.1));
		pulling = true;
	}
	
	// while pulling
	if(pulling = true){
		to_draw_on = self;
		script_bind_draw(tele_draw, depth, to_draw_on);
		with(enemy){
			var _p = other;
			if(distance_to_object(_p) < 100){
				var pdir = point_direction(x, y, _p.x, _p.y);
				x += lengthdir_x(_p.pull_strength, pdir); // hey pdir
				y += lengthdir_y(_p.pull_strength, pdir);
			}
		}
		with(projectile){
			var _p = other;
			if(team != _p.team){
				if(distance_to_object(_p) < 100){
					var pdir = point_direction(x, y, _p.x, _p.y) + 180;
					x += lengthdir_x(_p.pull_strength, pdir);
					y += lengthdir_y(_p.pull_strength, pdir);
				}
			}
		}
	}
	
	// stop pulling
	if(alarm[3] = 1){
		sound_play_pitch(snd_stop, random_range(0.9, 1.1));
		pulling = false;
	}
	
	if(alarm[4] = 0){
		alarm[4] = 120 + irandom(100);
	}
	
	//getting unstuck from walls
	_wStuck = instance_place(x,y,Wall);
	if(instance_exists(_wStuck)){
		if(place_meeting(x,y,_wStuck)){
			wall_stuck += 1;
			if(wall_stuck >= 15){
				with(_wStuck){
					instance_create(x,y,FloorExplo);
					instance_destroy();
				}
			}
		}
	}
	else{
		wall_stuck = 0;
	}

	// stop hit sprite
	if(sprite_index = spr_hurt and image_index >= 2){
		sprite_index = spr_idle;
	}
	
	// alarm management
	for(i = 0; i < array_length(alarm); i++){
		if(alarm[i] > 0){
			alarm[i]-= current_time_scale;
		}
	}
	
	// incoming contact damage
	if(collision_rectangle(x + 10, y + 8, x - 10, y - 8, enemy, 0, 1)){
		_ce = instance_nearest(x, y, enemy);
		if(_ce.meleedamage > 0){
			if(iframes = 0){
				my_health -= _ce.meleedamage;
				sprite_index = spr_hurt;
				sound_play(snd_hurt);
			}
		}
	}
}
else{
	sound_play_pitchvol(snd_dead, random_range(0.9,1.1), 0.6);
	instance_destroy();
}






















#define shielder_step
if(my_health > 0){
	// speed management
	if(speed > maxspeed){
		speed = maxspeed;
	}
	
	// collision
	move_bounce_solid(true);
	
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

	// targeting
	if(instance_exists(enemy)){
		var _e = instance_nearest(x, y, enemy);
		if(distance_to_object(_e) < 100 and !collision_line(x, y, _e.x, _e.y, Wall, true, true) and alarm[2] = 0){
			target[@1] = _e;
			var _t2 = target[1];
			gunangle = point_direction(x, y, _t2.x, _t2.y);
			alarm[2] = 5;
		}
		else{
			target[@1] = -4;	// can't see
		}
	}

	// movement
	if(target[0] = noone){	// no target, random movement
		if(alarm[0] = 0){
			direction = random(360);
			move_bounce_solid(true);
			motion_set(direction, maxspeed);
			alarm[0] = irandom_range(10, 30);
		}
	}
	else if(target[0] = creator and instance_exists(creator)){	// follow player
		if(distance_to_object(target[0]) <= 30){
			if(alarm[0] = 0){
				var _t1 = target[0];
				speed = 0;
				alarm[0] = irandom_range(10, 15);
			}
		}
		if(distance_to_object(target[0]) > 50){
			if(alarm[0] = 0){
				var _t1 = target[0];
				direction = point_direction(x, y, _t1.x, _t1.y) + random_range(-50, 50);
				move_bounce_solid(true);
				motion_set(direction, maxspeed);
				if(random(3) < 1){
					if(ammo <= 0){
						gunangle = random(360);
					}
				}
				alarm[0] = irandom_range(10, 15);
			}
		}
		else if(distance_to_object(target[0]) > 400){	// if too far away, teleport
			_dir = point_direction(creator.x, creator.y, x, y);
			_x = creator.x + lengthdir_x(350, _dir);
			_y = creator.y + lengthdir_y(350, _dir);
			_f = instance_nearest(_x, _y, Floor);
			x = _f.x + 4;
			y = _f.y + 4;
		}
	}
	
	if(instance_exists(target[1])){	// fire
		if(instance_exists(target[0])){
			if(distance_to_object(target[0]) < 220){
				if(reload <= 0 and shielding = false and ammo <= 0){
					me = id;
					reload = 40 + irandom(20);
					ammo = 8;
					alarm[1] = 0;
				}
			}
		}
	}
	
	if(alarm[1] = 0 and ammo > 0){
		sound_play_gun(sndGruntFire, 0.2, 0.6);
		with(instance_create(x, y, Bullet1)){
			sprite_index = sprIDPDBullet;
			spr_dead = sprIDPDBulletHit;
			creator = other;
			team = creator.team;
			direction = other.gunangle + other.accuracy * choose(-1, 1);
			image_angle = direction;
			friction = 0;
			speed = 8;
			damage = 3;
		}
		wkick = 10;
		alarm[1] = 3;
		ammo-= current_time_scale;
	}
	
	if(ammo > 0){	// manage ammo
		speed = 0;
	}
	
	if(reload > 0){	// manage reload
		reload-= current_time_scale;
	}
	
	if(wkick > 0){	// manage weapon kick
		wkick-= current_time_scale;
	}
	
	// start shielding
	if(reload = 0){
		if(array_length(instances_matching_ne(projectile, "team", team)) > 0){
			_pro = instance_nearest(x, y, projectile);
			if(_pro.team != team){
				if(point_distance(x, y, _pro.x, _pro.y) < 40){	
					if(!shieldCool and !shielding){
						shieldCool = 30;
						sound_play(snd_shld); // sound
						with(instance_create(x, y, PopoShield)){
							mask_index = mskShield;
							creator = other;
							team = creator.team;
							alarm_set(0, irandom_range(30, 70));
						}
						shielding = true;
					}
				}
			}
		}
	}
	// shielding
	if(shielding = true){
		// don't move or shoot
		alarm[0] = 5;
		speed = 0;
		gunangle = 90;
		reload = 10;
		
		// if no shield, start cooldown
		if(array_length(instances_matching(PopoShield, "creator", self)) = 0){
			shielding = false;
			gunangle = random(360);
		}
	}
	else if(shieldCool > 0){
		shieldCool-= current_time_scale;
	}
	
	//getting unstuck from walls
	_wStuck = instance_place(x,y,Wall);
	if(instance_exists(_wStuck)){
		if(place_meeting(x,y,_wStuck)){
			wall_stuck += 1;
			if(wall_stuck >= 15){
				with(_wStuck){
					instance_create(x,y,FloorExplo);
					instance_destroy();
				}
			}
		}
	}
	else{
		wall_stuck = 0;
	}

	// stop hit sprite
	if(sprite_index = spr_hurt and image_index >= 2){
		sprite_index = spr_idle;
	}
	
	// alarm management
	for(i = 0; i < array_length(alarm); i++){
		if(alarm[i] > 0){
			alarm[i]-= current_time_scale;
		}
	}
	
	// incoming contact damage
	if(collision_rectangle(x + 10, y + 8, x - 10, y - 8, enemy, 0, 1)){
		_ce = instance_nearest(x, y, enemy);
		if(_ce.meleedamage > 0){
			if(iframes = 0){
				my_health -= _ce.meleedamage;
				sprite_index = spr_hurt;
				sound_play(snd_hurt);
			}
		}
	}
}
else{
	sound_play_pitchvol(snd_dead, random_range(0.9,1.1), 0.6);
	instance_destroy();
}




























#define grunt_step
if(my_health > 0){
	// speed management
	if(speed > maxspeed){
		speed = maxspeed;
	}
	
	// collision
	move_bounce_solid(true);
	
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

	// targeting
	if(instance_exists(enemy)){
		var _e = instance_nearest(x, y, enemy);
		if(distance_to_object(_e) < 100 and !collision_line(x, y, _e.x, _e.y, Wall, true, true) and alarm[2] = 0){
			target[@1] = _e;
			var _t2 = target[1];
			gunangle = point_direction(x, y, _t2.x, _t2.y);
			alarm[2] = 5;
		}
		else{
			target[@1] = -4;	// can't see
		}
	}

	// movement
	if(target[0] = noone){	// no target, random movement
		if(alarm[0] = 0){
			direction = random(360);
			move_bounce_solid(true);
			motion_set(direction, maxspeed);
			alarm[0] = irandom_range(10, 30);
		}
	}
	else if(target[0] = creator and instance_exists(creator)){	// follow player
		if(distance_to_object(target[0]) > 50){
			if(alarm[0] = 0){
				var _t1 = target[0];
				direction = point_direction(x, y, _t1.x, _t1.y) + random_range(-50, 50);
				move_bounce_solid(true);
				motion_set(direction, maxspeed);
				if(random(3) < 1 and ammo <= 0){
					gunangle = random(360);
				}
				alarm[0] = irandom_range(10, 15);
			}
		}
		else if(distance_to_object(target[0]) < 400){	// if far enough away, roll
			if(alarm[0] = 0){
				speed = 0;
				alarm[0] = irandom_range(10, 15);
			}
		}
		else{	// if too far away, teleport
			_dir = point_direction(creator.x, creator.y, x, y);
			_x = creator.x + lengthdir_x(350, _dir);
			_y = creator.y + lengthdir_y(350, _dir);
			_f = instance_nearest(_x, _y, Floor);
			x = _f.x + 4;
			y = _f.y + 4;
		}
	}
	
	if(instance_exists(target[1])){	// fire
		if(instance_exists(target[0])){
			if(distance_to_object(target[0]) < 220){
				if(reload <= 0 and ammo <= 0){
					me = id;
					reload = 3 + irandom(10);
					ammo = 1;
					alarm[1] = 0;
				}
			}
		}
	}
	
	if(alarm[1] = 0 and ammo > 0){
		sound_play_gun(sndGruntFire, 0.2, 0.6);
		with(instance_create(x, y, Bullet1)){
			sprite_index = sprIDPDBullet;
			spr_dead = sprIDPDBulletHit;
			creator = other;
			team = creator.team;
			direction = other.gunangle + other.accuracy * choose(-1, 1);
			image_angle = direction;
			friction = 0;
			speed = 8;
			damage = 3;
		}
		wkick = 10;
		alarm[1] = 3;
		ammo-= current_time_scale;
	}
	
	if(reload > 0){	// manage reload
		reload-= current_time_scale;
	}
	
	if(wkick > 0){	// manage weapon kick
		wkick-= current_time_scale;
	}
	
	// rolling
	if(!roll_time){
		// projectile dodge rolling
		if(array_length(instances_matching_ne(projectile, "team", team)) > 0){
			_pro = instance_nearest(x, y, projectile);
			if(_pro.team != team){
				if(point_distance(x, y, _pro.x, _pro.y) < 40){
					// roll direction
					direction = point_direction(_pro.x, _pro.y, x, y) + random_range(-20, 20);
					
					// start roll away from projectile
					if(!roll_time){
						roll_time = 10;		 // 10 Frame Roll
						sound_play(sndRoll); // Sound
					}
				}
			}
		}
		// random rolling
		if(random(15) < 1){
			if(instance_exists(target[0])){
				if(distance_to_object(creator) > 70){
					if(!roll_time){
						if(instance_exists(creator)){
							direction = creator.direction + random_range(-5, 5);
						}
						else{
							direction = random(360);
						}
						roll_time = 10;		 // 10 Frame Roll
						sound_play(sndRoll); // Sound
					}
				}
			}
		}
	}
	
	// rolling
	if(roll_time > 0){
		roll_time-= current_time_scale;

		 // speed up
		speed = maxspeed + 2;

		// roll
		image_angle += 40 * right;	// rotate
		with(instance_create(x + random_range(-3, 3), y + random(6), Dust)){	// dust
			depth = other.depth + 1;
		}

		 // bounce off walls
		if(place_meeting(x + hspeed, y + vspeed, Wall)){
			move_bounce_solid(true);
			roll_time *= skill_get(5);
		}
	}
	else{
		image_angle = 0;
	}
	
	//getting unstuck from walls
	_wStuck = instance_place(x,y,Wall);
	if(instance_exists(_wStuck)){
		if(place_meeting(x,y,_wStuck)){
			wall_stuck += 1;
			if(wall_stuck >= 15){
				with(_wStuck){
					instance_create(x,y,FloorExplo);
					instance_destroy();
				}
			}
		}
	}
	else{
		wall_stuck = 0;
	}

	// stop hit sprite
	if(sprite_index = spr_hurt and image_index >= 2){
		sprite_index = spr_idle;
	}
	
	// alarm management
	for(i = 0; i < array_length(alarm); i++){
		if(alarm[i] > 0){
			alarm[i]-= current_time_scale;
		}
	}
	
	// incoming contact damage
	if(collision_rectangle(x + 10, y + 8, x - 10, y - 8, enemy, 0, 1)){
		_ce = instance_nearest(x, y, enemy);
		if(_ce.meleedamage > 0){
			if(iframes = 0){
				my_health -= _ce.meleedamage;
				sprite_index = spr_hurt;
				sound_play(snd_hurt);
			}
		}
	}
}
else{
	sound_play_pitchvol(snd_dead, random_range(0.9,1.1), 0.6);
	instance_destroy();
}

#define squad_destroy
// make corpse
with(instance_create(x, y, Corpse)){
	sprite_index = other.spr_dead;
	size = 1;
}

#define squad_hurt(damage, kb_vel, kb_dir)
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

#define squad_draw
// friendly outline
if(instance_exists(creator)){
	playerColor = player_get_color(creator.index);
} 
d3d_set_fog(1, playerColor, 0, 0);
draw_sprite_ext(sprite_index, -1, x - 1, y, 1 * right, 1, image_angle, playerColor, 1);
draw_sprite_ext(sprite_index, -1, x + 1, y, 1 * right, 1, image_angle, playerColor, 1);
draw_sprite_ext(sprite_index, -1, x, y - 1, 1 * right, 1, image_angle, playerColor, 1);
draw_sprite_ext(sprite_index, -1, x, y + 1, 1 * right, 1, image_angle, playerColor, 1);
// gun outline
draw_sprite_ext(weapon_get_sprite(wep), -1, x - lengthdir_x(wkick, gunangle + wepangle) - 1, y - lengthdir_y(wkick, gunangle + wepangle), 1, right, gunangle, playerColor, 1);
draw_sprite_ext(weapon_get_sprite(wep), -1, x - lengthdir_x(wkick, gunangle + wepangle) + 1, y - lengthdir_y(wkick, gunangle + wepangle), 1, right, gunangle, playerColor, 1);
draw_sprite_ext(weapon_get_sprite(wep), -1, x - lengthdir_x(wkick, gunangle + wepangle), y - lengthdir_y(wkick, gunangle + wepangle) - 1, 1, right, gunangle, playerColor, 1);
draw_sprite_ext(weapon_get_sprite(wep), -1, x - lengthdir_x(wkick, gunangle + wepangle), y - lengthdir_y(wkick, gunangle + wepangle) + 1, 1, right, gunangle, playerColor, 1);
d3d_set_fog(0,c_lime,0,0);
// draw gun
draw_sprite_ext(weapon_get_sprite(wep), 0, x - lengthdir_x(wkick, gunangle + wepangle), y - lengthdir_y(wkick, gunangle + wepangle), 1, right, gunangle + wepangle, c_white, 1);
draw_self();

#define tele_draw(to_draw_on)
if(instance_exists(to_draw_on)){
	with(to_draw_on){
		// friendly outline
		if(instance_exists(creator)){
			playerColor = player_get_color(creator.index);
		} 
		draw_sprite_ext(sprMindPower, -1, x, y, image_xscale * right, image_yscale, image_angle, c_white, 1);
		d3d_set_fog(1, playerColor, 0, 0);
		draw_sprite_ext(sprMindPower, -1, x - 1, y, 1 * right, 1, image_angle, playerColor, 1);
		draw_sprite_ext(sprMindPower, -1, x + 1, y, 1 * right, 1, image_angle, playerColor, 1);
		draw_sprite_ext(sprMindPower, -1, x, y - 1, 1 * right, 1, image_angle, playerColor, 1);
		draw_sprite_ext(sprMindPower, -1, x, y + 1, 1 * right, 1, image_angle, playerColor, 1);
		d3d_set_fog(0,c_lime,0,0);
	}
}
instance_destroy();