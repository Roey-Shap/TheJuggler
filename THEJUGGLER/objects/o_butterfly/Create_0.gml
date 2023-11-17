// Inherit the parent event
event_inherited();

hspd = 2.5;
vspd = 0;

vspd_target = 0;

afterimage_timer = new Timer(get_frames(0.75));
afterimage_timer.start();
life_timer = new Timer(get_frames(20));