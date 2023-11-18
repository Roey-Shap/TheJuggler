// Inherit the parent event
event_inherited();

hspd = 2.5;
vspd = 0;

vspd_target = 0;
enabled = true;
made_sound = false;

afterimage_timer = new Timer(get_frames(0.4));
afterimage_timer.start();
life_timer = new Timer(get_frames(20));

function make_afterimage() {
	afterimage_timer.start();
	var fx = new FadeFX(x, y, sprite_index, 1, image_index, get_frames(0.4));
	fx.image_xscale = image_xscale * draw_scale.x;
	fx.image_yscale = image_yscale;
	fx.image_angle = image_angle;
	fx.image_blend = image_blend;
	fx.hspd = -hspd * 0.25;
	//fx_setup_screen_layer(fx);
	fx.fog_color = c_aqua;
	
	if !enabled {
		fx_setup_screen_layer(fx);
	}
}