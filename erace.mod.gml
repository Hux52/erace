#define init
for(i = 1; i < 16; i++){
	race_set_active(i, 0);
}

#define step
with(WeaponChest){
	instance_create(x, y, HealthChest);
	instance_destroy();
}
with(AmmoChest){
	instance_create(x, y, HealthChest);
	instance_destroy();
}
with(AmmoPickup){
	if(random(10) < 3){
		instance_create(x, y, HPPickup);
	}
	instance_destroy();
}