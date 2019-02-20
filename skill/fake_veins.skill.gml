#define init

// stop coding and go to sleep, possibly, 4:30 AM

#define game_start


#define skill_name
return "BOILING VEINS";
	
#define skill_text
return "@wNO DAMAGE @sFROM EXPLOSIONS AND FIRE#WHEN UNDER @w1/2 @rMAX HP";

#define skill_button
sprite_index = sprSkillIcon;
image_index = 14;

#define skill_icon
return mskNone;

#define skill_wepspec
return 0;

#define skill_tip
return "This will never show up";

#define skill_lose

#define skill_take
sound_play(sndMutBoilingVeins);
skill_set(mut_boiling_veins, 1);
skill_set("fake_veins", 0);
skill_set_active("fake_veins", 0);

#define step