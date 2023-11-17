if hit_roll(0.1) {
	vspd_target += random_range(-2, 2); 
}

vspd = lerp(vspd, vspd_target, 0.001);

x += hspd;
y += vspd;

// sparkles
if hit_roll(0.6) {
	var offset_x = choose(-1, 1) * irandom_range(8, 20);
	var offset_y = irandom_range(-10, 2);
	var spr = choose(spr_fx_dust_1, spr_fx_sparkle_1, spr_fx_sparkle_tri, spr_fx_dust_3);
	var fx = new SpriteFX(x + offset_x, y + offset_y, spr, 1);
	fx.image_angle = irandom(359);
	fx.image_speed = random_range(0.8, 1);
	if spr == spr_fx_sparkle_tri {
		fx.growth_scale = new Vector2(0.999, 0.999);
	}

	fx.alpha_fade_with_time = true;
	fx.hspd = -sign(hspd) * random_range(0, 1.5);
	fx.vspd = 0;
	fx.grav = 0.025;
	fx.fric = 0.99;
}

// afterimages
if afterimage_timer.is_done() {
	afterimage_timer.start();
	var fx = new FadeFX(x, y, sprite_index, 1, image_index, get_frames(0.4));
	fx.image_xscale = image_xscale * draw_scale.x;
	fx.image_angle = image_angle;
	fx.image_blend = image_blend;
	fx.hspd = -hspd * 0.5;
	//fx_setup_screen_layer(fx);
	fx.fog_color = c_aqua;
}

//life_timer.is_done() or 
if !place_meeting(x, y, o_screen) {
	instance_destroy(id);
}