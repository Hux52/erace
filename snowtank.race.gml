#define init
// character select button
global.sprMenuButton = sprite_add("sprites/selectIcon/sprSnowTankSelect.png", 1, 0, 0);
// character select portrait
global.sprPortrait = sprite_add("/sprites/portrait/sprPortraitSnowTank.png", 1, 5, 198);

global.sprIcon = sprite_add("sprites/mapIcon/LoadOut_SnowTank.png", 1, 10, 10);

global.sprThruster = sprite_add("/sprites/sprTankThruster.png", 8, 24, 24);

global.laser_color = make_color_rgb(250, 54, 0);

// level start init- MUST GO AT END OF INIT
var _race = [];
for(var i = 0; i < maxp; i++) _race[i] = player_get_race(i);
while(true){
	//character selection sound
	for(var i = 0; i < maxp; i++){
		var r = player_get_race(i);
		if(_race[i] != r && r = "snowtank"){
			sound_play(sndSnowTankAim);
		}
		_race[i] = r;
	}
	wait 1;
}


#define create
// player instance creation of this race
// https://bitbucket.org/YellowAfterlife/nuclearthronetogether/wiki/Scripting/Objects/Player

// sprites
spr_idle = sprSnowTankIdle;
spr_walk = sprSnowTankWalk;
spr_hurt = sprSnowTankHurt;
spr_dead = sprSnowTankDead;
spr_sit1 = spr_idle;
spr_sit2 = spr_idle;

// sounds
snd_hurt = sndSnowTankHurt;
snd_dead = sndSnowTankDead;
snd_aim = sndSnowTankAim;
snd_fire = sndSnowTankShoot;

// stats
maxspeed = 1.2;
team = 2;
maxhealth = 50;
melee = 0;	// can melee or not
spr_shadow = shd64;
spr_shadow_y = 8;

has_died = false;

fire_cooldown = 0;
fire_cooldown_base = 30;

charge_base = 30;
charge = 30;

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

if (ultra_get("snowtank",1) = 1){
	if (player_get_race(index) == "snowtank"){
		player_set_race(index, "goldsnowtank");
		race = "goldsnowtank";
	}
}

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
			sound_play_pitchvol(snd_aim, random_range(0.9,1.1), 0.75);
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
			//hshshoot bullit
			sound_play_pitchvol(snd_fire, random_range(0.9,1.1), 0.6);
			if(bulletCount = bulletCountBase){
				sound_play_pitchvol(sndSnowTankPreShoot, random_range(0.9,1.1), 0.6);
			}
			for(i = 0; i < 2; i++){
				if (i = 0){
					r = -1;
				} else {
					r = 1;
				}
				q = d + ((spread-(bulletCount/bulletCountBase))*r * 20)
				with(instance_create(x,y,EnemyBullet4)){
					creator = other;
					damage = 3;
					speed = 12;
					team = other.team;
					direction = other.q;
					image_angle = direction;
				}
			}
			view_shake[index] = 4.5;
			bulletCount -= 1;
			fireDelay = fireDelayBase;
		}
		fireDelay -= current_time_scale;
	} else {
		is_firing = false; //stop firing
		sound_play_pitchvol(sndSnowTankCooldown, random_range(0.9,1.1), 0.6);
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
		instance_create(x,y,SnowTankExplode);
		has_died = true;
	}
} else {
	has_died = false;
}

#define snowtank_draw
with(Player){
	if (is_firing or is_charging){
		draw_set_color(c_red);
		draw_lasersight(x, y, d, 900, 1);
	}
}
instance_destroy();

#define race_name
// return race name for character select and various menus
return "SNOW TANK";


#define race_text
// return passive and active for character selection screen
return "@sFIRES IN LARGE @wBURSTS";


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
	case 1: return "EVOLUTION";
	case 2: return "NUKE";
	default: return "";
}


#define race_ultra_text
// recieves ultra mutation index and returns description
switch(argument0){
	case 1: return "EVOLVE INTO @yGOLDEN @wSNOW TANK";
	case 2: return "LOL";
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

#define draw_lasersight(_x, _y, _dir, _maxDistance, _width)
    var _sx = _x,
        _sy = _y,
        _lx = _sx,
        _ly = _ly,
        _md = _maxDistance,
        d = _md,
        m = 0; // Minor hitscan increment distance

    while(d > 0){
         // Major Hitscan Mode (Start at max, go back until no collision line):
        if(m <= 0){
            _lx = _sx + lengthdir_x(d, _dir);
            _ly = _sy + lengthdir_y(d, _dir);
            d -= sqrt(_md);

             // Enter minor hitscan mode:
            if(!collision_line(_sx, _sy, _lx, _ly, Wall, false, false)){
                m = 2;
                d = sqrt(_md);
            }
        }

         // Minor Hitscan Mode (Move until collision):
        else{
            if(position_meeting(_lx, _ly, Wall)) break;
            _lx += lengthdir_x(m, _dir);
            _ly += lengthdir_y(m, _dir);
            d -= m;
        }
    }

    draw_line_width(_sx, _sy, _lx, _ly, _width);

return [_lx, _ly];