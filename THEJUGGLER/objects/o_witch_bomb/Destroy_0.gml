var fx = new SpriteFX(x, y, spr_fx_bomb_explosion, 1);
fx_setup_screen_layer(fx);
fx.image_angle = irandom(359);
var s = random_range(0.95, 1.05);
fx.image_xscale = s;
fx.image_yscale = s;
fx.growth_scale.x = 1.005;

repeat(irandom_range(3, 4)) {
	var side = choose(-1, 1);
	var offset_x = side * irandom_range(4, 8);
	var offset_y = irandom_range(-10, 2);
	var spr = choose(spr_fx_dust_1, spr_fx_dust_2, spr_fx_dust_3);
	fx = new SpriteFX(x + offset_x, y + offset_y, spr, 1);
	fx.hspd = side * random_range(0.3, 3);
	fx.vspd = random_range(-0.5, 1);
	fx.grav = -0.06;
	fx.fric = 0.999;
	fx.image_angle = irandom(359);
	fx.image_speed = random_range(0.8, 1);
	fx.image_xscale = random_range(0.5, 0.8);
	fx.image_yscale = random_range(0.5, 0.8);
	fx_setup_screen_layer(fx);
}

o_manager.start_shake(new Vector2(irandom_range(2, 5), irandom_range(9, 13)), get_frames(0.8));