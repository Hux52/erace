#define init
firing = false;

#define game_start

#define step

#define weapon_name
return "HYPER SNIPER";

#define weapon_sprt
return sprSniperGun;

#define weapon_type
return 0;

#define weapon_auto
return false;

#define weapon_load
return 180;

#define weapon_cost
return 0;

#define weapon_area
return -1;

#define weapon_swap
return sndSwapHammer;

#define weapon_melee
return false;

#define weapon_laser_sight
return true;

#define weapon_text
return "IN MY SIGHTS";

#define weapon_fire
// no moving
speed = 0;
canwalk = 0;
// effect
sound_play(sndSniperTarget);
// delay
wait(30);
// can walk again
canwalk = 1;
for (i = 0; i < 100; i++){
	//if(reload>0)trace(reload);
	weapon_post(5, 20, 5);	// weapon kick and screen shake
	sound_play_pitch(sndSnowTankShoot,1 + (i/200));
	motion_add(gunangle+180, 10);
	
	if(i > random(100)){
		with(instance_create(x,y,Smoke)){
			direction = random(360);
			friction = 0.3;
			speed = 4;
		}
	}
	
	with(instance_create(x + lengthdir_x(4, gunangle), y + lengthdir_y(4, gunangle), Bullet2)){
		creator = other;
		team = creator.team;
		
		if (creator.i mod 2 == 0){
			a = 1;
		} else {a = -1;}
		
		direction = creator.gunangle + (((creator.i/6) * a) * 1);
		image_angle = direction;
		speed = 20;
		friction = 0.5;
		damage = 4;
	}
	if (i mod 2 == 1){
		wait(2);
	}
}