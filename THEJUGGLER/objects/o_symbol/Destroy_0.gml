repeat(irandom_range(4, 6)) {
	var offset_x = irandom_range(-10, 10);
	var offset_y = irandom_range(-30, 30);
	var pos = bbox_center(id);
	var spr = choose(spr_fx_dust_1, spr_fx_dust_2, spr_fx_dust_3, spr_fx_sparkle_1);
	var fx = new SpriteFX(pos.x + offset_x, pos.y + offset_y, spr, 1);
	fx.image_angle = irandom(359);
	fx.image_speed = random_range(0.8, 1);
	var scale = random_range(0.8, 1.1);
	fx.image_xscale = scale;
	fx.image_yscale = scale;
	var move_spd = random_range(1, 3);
	var move_dir = irandom(359);
	fx.hspd = lengthdir_x(move_spd, move_dir);
	fx.vspd = -random_range(-0.1, 3);
	fx.image_blend = merge_color(death_col_1, death_col_2, random_range(0.05, 0.4));
	fx_setup_screen_layer(fx);
}