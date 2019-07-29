#define init
//global.sprMenuButton = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAABAAAAAYCAYAAADzoH0MAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAADpSURBVDhPvZI9CgIxEEYHvIWttYWdpWfYI3gNK4s9huAJrKzt7Bc8g6UHEIToBF74ErKL4K7Fg2Qm38vPrj0uTXDMLEHtG6LAQ8v9LPJ/gYZVArWQYrvNIjga1nEtpNi9OwWHHT3YPucRajCN4HZchT4QDl3nU7f4BorXCOtpphPwDuV7eFCvA5mABexejpWa5HfBa23BIaTQA8KZrBas4YsZZ6fSRUP0CrxxaLehu54TPqfGuBSka2Evwwi8p2EE6QSjCQgRoKZzlbBhEkD8tjInoDVON55AF/CHIaJfShI0NFgT1Nc04Q2YTjeSiZKRigAAAABJRU5ErkJggg==", 1, 0, 0);
global.sprPortrait = sprite_add("sprites/portrait/sprPortraitGoldScorpion.png",1 , 10, 200);

#define create
// player instance creation of this race
// https://bitbucket.org/YellowAfterlife/nuclearthronetogether/wiki/Scripting/Objects/Player

// sprites
spr_idle = sprGoldScorpionIdle;
spr_walk = sprGoldScorpionWalk;
spr_hurt = sprGoldScorpionHurt;
spr_dead = sprGoldScorpionDead;
spr_sit1 = sprMutant15GoSit;
spr_sit2 = sprMutant15Sit;

// sounds
snd_hurt = sndGoldScorpionHurt;
snd_dead = sndGoldScorpionDead;

// stats
maxspeed = 5;
team = 2;
maxhealth = 14 + GameCont.level * 1 + skill_get(mut_rhino_skin) * 4;
spr_shadow = shd32;
spr_shadow_y = 5;
mask_index = mskPlayer;

// vars
cooldown = 0;	// cooldown for shooting
venom = 0;	// shooting duration
dir = 0;	// initial firing direction
died = 0;	// prevent frames after death
melee = 0;	// can melee or not


#define game_start
// executed after picking race and starting for each player picking this race
// player-specific global variable init


#define step
// executed within each player instance of this race after step
// most actives and passives handled here

// no weps
canswap = 0;
canpick = 0;

// health scale
if(maxhealth != 14 + GameCont.level * 1 + skill_get(mut_rhino_skin) * 4){
	var _d = 14 + GameCont.level * 1 + skill_get(mut_rhino_skin) * 4 - maxhealth;
	maxhealth = 14 + GameCont.level * 1 + skill_get(mut_rhino_skin) * 4;
	my_health += _d;
	
}

// special- shoot venom
if(button_pressed(index, "fire")){
	if(cooldown <= 0){
		cooldown = 90;	// shoot venom again in 90 frames
		venom = 25;	// shoot venom for 25 frames
		dir = gunangle;	// initial direction, as you can't change firing direction once started
		spr_idle = sprGoldScorpionFire;
		spr_walk = sprGoldScorpionFire;
		sound_play_pitch(sndScorpionFireStart, 0.7);	// can't find the sound file for this, if any
	}
}

// while firing
if(venom > 0){
	canwalk = 0;	// no walking
	speed = 0;
	// sprite based on direction, as you can't fire right now
	if(dir > 90 and dir <= 270){
		right = -1;
	}
	else{
		right = 1;
	}
	sound_play_gun(sndScorpionFire, 0.2, 0.6);
	// ambient, slow spread of bullets
	if(venom - floor(venom) = 0){
		with(instance_create(x, y, Bullet1)){
			var acc = 80;
			creator = other;
			team = creator.team;
			sprite_index = sprScorpionBullet;
			direction = other.dir + (random(creator.accuracy) * choose(1, -1) * random(acc));
			image_angle = direction;
			friction = 0;
			speed = 2;
			damage = 3 + min(2.5, 0.25 * GameCont.level);
		}
		// fast, concentrated bullets
		with(instance_create(x, y, Bullet1)){
			var acc = 20;
			creator = other;
			team = creator.team;
			sprite_index = sprScorpionBullet;
			direction = other.dir + (random(creator.accuracy) * choose(1, -1) * random(acc));
			image_angle = direction;
			friction = 0;
			speed = 7;
			damage = 3 + min(2.5, 0.25 * GameCont.level);
		}
	}
	venom -= current_time_scale;
}
else{
	// fix sprites when not firing
	spr_idle = sprGoldScorpionIdle;
	spr_walk = sprGoldScorpionWalk;
	canwalk = 1;
}

// cooldown management
if(cooldown > 0){
	cooldown -= current_time_scale;
}

// outgoing contact damage
if(collision_rectangle(x + 20, y + 10, x - 20, y - 10, enemy, 0, 1)){
	with(instance_nearest(x, y, enemy)){
		if(sprite_index != spr_hurt){
			projectile_hit_push(self, 4 + min(4, 0.4 * GameCont.level), 4);
		}
	}
}

// on death
if(my_health = 0 and died = 0){
	// bullets
	for(i = 0; i < 360; i += 5){
		with(instance_create(x, y, Bullet1)){
			creator = other;
			team = creator.team;
			sprite_index = sprScorpionBullet;
			direction = other.i + random_range(-5, 5);
			image_angle = direction;
			friction = 0;
			speed = random_range(3, 4);
			damage = 2;
		}
	}
	// effect
	for(i = 0; i < 360; i += 120){
		with(instance_create(x, y, AcidStreak)){
			speed = 8;
			direction = other.i + random_range(-30, 30);
		}
	}
	died = 1;
}


//active
if(button_pressed(index, "spec") && my_health > 3){
	projectile_hit_push(self, 3, 0);
	egg = instance_create(x, y, CustomHitme);
	with(egg){
		creator = other;
		team = creator.team;
		name = "ScorpionEgg";
		right = choose(-1, 1);
		my_health = creator.maxhealth;
		maxhealth = my_health;
		friction = 1;
		alarm = [12, 150];
		hatch = false; //to spawn or not to spawn
		
		spr_idle = sprFrogEgg;
		spr_hurt = sprFrogEggHurt;
		spr_spwn = sprFrogEggSpawn;
		spr_dead = sprFrogEggDead;
		
		snd_hurt = sndFrogEggHurt;
		snd_spwn = choose(sndFrogEggSpawn1, sndFrogEggSpawn2, sndFrogEggSpawn3);
		snd_open = choose(sndFrogEggOpen1, sndFrogEggOpen2);
		snd_dead = sndFrogEggDead;
		
		sound_play_pitch(snd_spwn, random_range(0.9, 1.1));
		
		sprite_index = spr_spwn;
		mask_index = mskFrogEgg;
		image_speed = 0.4;
		image_blend = make_color_rgb(255,160,60);

		on_step = script_ref_create(egg_step);
		on_hurt = script_ref_create(egg_hurt);
		on_destroy = script_ref_create(egg_destroy);
		
		playerColor = player_get_color(creator.index);
		toDraw = self;
		with(script_bind_draw(0, 0)){
			script = script_ref_create_ext("mod", "erace", "draw_outline", other.playerColor, other);
		}
	}
}



#define egg_step
if(my_health > 0){
	// don't move
	speed = 0;
	
	// sprite stuff
	if(sprite_index != spr_hurt){
		if(alarm[0] <= 0){
			sprite_index = spr_idle;
		}
		else{
			sprite_index = spr_spwn;
		}
	} // put else here

	if(right = 1){
		image_xscale = 1;
	}
	else{
		image_xscale = -1;
	}

	// stop showing hurt sprite
	if(sprite_index = spr_hurt and image_index >= 2){
		if(alarm[0] <= 0){
			sprite_index = spr_idle;
		}
		else{
			sprite_index = spr_spwn;
			image_index = round(alarm[0] / 3);
		}
	}
	
	// alarm management
	for(i = 0; i < array_length(alarm); i++){
		if(alarm[i] > 0){
			alarm[i]-= current_time_scale;
		}
	}
	
	if(alarm[1] <= 0){
		my_health = 0;
		hatch = true;
	}
}
else{
	instance_destroy();
}


#define egg_hurt(damage, kb_vel, kb_dir)
// incoming damage
if(sprite_index != spr_hurt){
	if(nexthurt <= current_frame){
		sound_play_hit(snd_hurt, 0.1);
		my_health -= argument0;
		nexthurt = current_frame + 3;
		sprite_index = spr_hurt;
		image_index = 0;
	}
}

#define egg_destroy
sound_play_pitchvol(snd_dead, random_range(0.9,1.1), 0.6);
// create corpse
with(instance_create(x, y, Corpse)){
	sprite_index = other.spr_dead;
	size = 1;
}

// spawn
if(hatch){
	repeat(2){
		SpawnScorp(maxhealth / 2);
	}
}














#define SpawnScorp(hp)
with(instance_create(x, y, CustomHitme)){
	creator = other.creator;
	team = creator.team;
	name = "GoldBabyScorp";
	spr_idle = sprGoldScorpionIdle;
	spr_walk = sprGoldScorpionWalk;
	spr_hurt = sprGoldScorpionHurt;
	spr_dead = sprGoldScorpionDead;

	// sounds
	snd_hurt = sndGoldScorpionHurt;
	snd_dead = sndGoldScorpionDead;
	my_health = hp;
	maxspeed = 3.5;
	sprite_index = spr_idle;
	mask_index = mskScorpion;
	size = 1;
	image_speed = 0.3;
	spr_shadow = shd16;
	direction = random(360);
	move_bounce_solid(true);
	my_damage = 1;
	right = choose(-1, 1);
	alarm = [0];	// movement alarm
	on_step = script_ref_create(scorp_step);
	on_hurt = script_ref_create(scorp_hurt);
	on_destroy = script_ref_create(scorp_destroy);
	
	// friendly player outline
	playerColor = other.playerColor;
	toDraw = self;
	with(script_bind_draw(0, 0)){
		script = script_ref_create_ext("mod", "erace", "draw_outline", other.playerColor, other);
	}
}


#define scorp_step
if(my_health > 0){
	// speed management
	if(speed > maxspeed){
		speed = maxspeed;
	}
	
	// collision stuff
	move_bounce_solid(true);
	
	// sprite stuff
	if(speed > 0 and sprite_index != spr_hurt){
		sprite_index = spr_walk;
	}
	else if(sprite_index != spr_hurt){
		sprite_index = spr_idle;
	}
	// face direction...
	if(direction > 90 and direction <= 270){
		right = -1;
	}
	else{
		right = 1;
	}
	// ...cont
	image_xscale = 0.75 * right;

	image_yscale = 0.75;


	// targeting
	var _e = instance_nearest(x, y, enemy);
	var _p = creator;
	if(instance_exists(_e) and distance_to_object(_e) < 100 and !collision_line(x, y, _e.x, _e.y, Wall, true, true)){
		target = _e;
	} else if(instance_exists(_p) and player_get_race(_p.index) == "scorpion" and distance_to_object(_p) < 100 and !collision_line(x, y, _p.x, _p.y, Wall, true, true)){
		target = _p;
	} else {
		target = noone;
	}
	
	// movement
	if(target = noone){	// no target- random movement
		if(alarm[0] = 0){
			direction = random(360);
			move_bounce_solid(true);
			motion_add(direction, maxspeed);
			friction = 0.05;
			alarm[0] = irandom_range(20, 40);
		}
	}
	else{
		if(alarm[0] = 0){	// target- go for it!
			direction = point_direction(x, y, target.x, target.y) + random_range(-20, 20);
			move_bounce_solid(true);
			motion_add(direction, maxspeed);
			friction = 0.075;
			alarm[0] = irandom_range(10, 15);
		}
	}

	// stop showing hurt sprite
	if(sprite_index = spr_hurt and image_index >= 2){
		sprite_index = spr_idle;
	}
	
	// alarm management
	for(i = 0; i < array_length_1d(alarm); i++){
		if(alarm[i] > 0){
			alarm[i]-= current_time_scale;
		}
	}
	
	// outgoing/incoming contact damage
	with(collision_rectangle(x + 10, y + 8, x - 10, y - 8, enemy, 0, 1)){
		if(sprite_index != spr_hurt){
			projectile_hit_push(self, 3, 4);
			sound_play_pitchvol(sndGoldScorpionMelee,random_range(1.3,1.5),0.6);
		}
	}
}
else{
	instance_destroy();
}

#define scorp_destroy
sound_play_pitchvol(snd_dead, random_range(1.3,1.5), 0.6);
// create corpse
with(instance_create(x, y, Corpse)){
	sprite_index = other.spr_dead;
	size = 1;
}

for(i = 0; i < 360; i += 120){
	with(instance_create(x, y, AcidStreak)){
		speed = 8;
		direction = other.i + random_range(-30, 30);
		image_xscale = 0.75;
		image_yscale = 0.75;
	}
}

num = irandom_range(16,24);
for(i = 0; i < num; i++){
	with(instance_create(x, y, EnemyBullet2)){
		speed = random_range(3,6);
		team = other.team;
		direction = (360/other.num) * other.i;
		image_angle = direction;
		damage = 1;
	}
}


#define scorp_hurt(damage, kb_vel, kb_dir)
// incoming damage
if(sprite_index != spr_hurt){
	if(nexthurt <= current_frame){
		sound_play_hit(snd_hurt, 0.1);
		my_health -= argument0;
		motion_add(argument2, argument1);
		nexthurt = current_frame + 3;
		sprite_index = spr_hurt;
	}
}

#define race_name
// return race name for character select and various menus
return "GOLD SCORPION";


#define race_text
// return passive and active for character selection screen
return "CONTACT DAMAGE#CAN SPRAY VENOM";


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
return false;

#define race_menu_button
// return race menu button icon
return mskNone;

#define race_skins
// return number of skins the race has
return 0;


#define race_skin_avail
// return if skin is unlocked
return 0;

#define race_skin_button
// return skin switch button sprite
return mskNone;


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
return choose("HISS", "SHINY", "ARMORED UP", "STINGER", "PINCH PINCH", "VENOMOUS");