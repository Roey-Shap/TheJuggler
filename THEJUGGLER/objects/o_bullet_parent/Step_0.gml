
manage_collision();

var sin_val = sin(current_time/200) + sin(current_time/100);
var scale = map(-2, 2, sin_val, 0.8, 1.2);
var scale2 = map(-2, 2, sin_val, 1.2, 0.8);
draw_scale.x = scale;
draw_scale.y = scale2;

image_angle += 1;

x += hspd;
y += vspd;

if hit_roll(0.08) {
	var particle_noise = 2;
	var ran_x = x + irandom_range(-particle_noise, particle_noise);
	var ran_y = y + irandom_range(-particle_noise, particle_noise);
	var ran_spr = choose(spr_fx_sparkle_1, spr_fx_dust_1, spr_fx_dust_3);
	var fx = new SpriteFX(ran_x, ran_y, ran_spr, -1);
	fx_setup_screen_layer(fx);
	var s = irandom_range(0.75, 0.95);
	fx.hspd = random_range(-0.3, 0.3);	// current going opposite to target_side_for_flyby
	fx.vspd = random_range(-0.3, 0.3);
	fx.image_xscale = s;
	fx.image_yscale = s;
	fx.image_angle = irandom_range(-10, 10);
	fx.image_blend = array_pick_random(concat_arrays([c_white], global.c_magic_colors)); //merge_color(c_white, global.c_magic, random_range(0, 0.1));
}