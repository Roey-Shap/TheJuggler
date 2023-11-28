fog_color = -1;
draw_scale = new Vector2(1, 1);

is_stone = false;
stone_overlay = spr_symbol_frozen;

symbol_struct = -1;

hit_flash_timer = new Timer(get_frames(1.5));
hit_flash_interval_timer = new Timer(get_frames(0.35));
function start_hit_flash() {
	hit_flash_timer.start();
	
	var fx = new FadeFX(x, y, sprite_index, 1, image_index, get_frames(0.5));
	fx.fog_col = global.c_hurt;
	fx.growth_scale = new Vector2(1.01, 1.01);
	fx.growth_limit = new Vector2(1.2, 1.2);
	fx_setup_screen_layer(fx);
}

draw_custom = function(offset_pos=new Vector2(0, 0), draw_shadow=false) {
	//gpu_set_fog(true, global.c_lcd_shade, 0, 1);
	//if fog_color != -1 {
	//	gpu_set_fog(true, fog_color, 0, 1);
	//}
	var stone_alpha_factor = 0.75;
	
	if draw_shadow {
		var off = object_is_ancestor_ext(object_index, o_symbol)? LCD_SHADE_OFFSET.multiply(o_manager.symbol_draw_scale) : LCD_SHADE_OFFSET;
		draw_sprite_ext(sprite_index, image_index, x + offset_pos.x + off.x, y + offset_pos.y + off.y, image_xscale * draw_scale.x, image_yscale * draw_scale.y, image_angle, global.c_lcd_shade, global.lcd_alpha_large * image_alpha);
		
		if is_stone {
			gpu_set_fog(true, global.c_lcd_shade, 0, 1);
			draw_sprite_ext(stone_overlay, 0, x + offset_pos.x + off.x, y + offset_pos.y + off.y, image_xscale * draw_scale.x, image_yscale * draw_scale.y, image_angle, c_white, global.lcd_alpha_large * image_alpha * stone_alpha_factor);
			gpu_set_fog(false, c_white, 0, 1);
		}
	} else {
	//gpu_set_fog(false, c_white, 0, 1);
		//if fog_color != -1 {
		//	gpu_set_fog(true, fog_color, 0, 1);
		//}
		
		draw_sprite_ext(sprite_index, image_index, x + offset_pos.x, y + offset_pos.y, image_xscale * draw_scale.x, image_yscale * draw_scale.y, image_angle, image_blend, image_alpha);
		
		if is_stone {
			var c;
			var is_charged = symbol_struct != -1;
			if is_charged {
				is_charged = symbol_struct.type == symbol_type.charged;
			}
			
			if is_charged {
				c = merge_color(global.c_magic_1, global.c_magic_2, map(-1, 1, sin(current_time/350), 0, 1));
			} else {
				c = merge_color(c_white, c_aqua, map(-1, 1, sin(current_time/400), 0, 0.5));
			}
			
			draw_sprite_ext(stone_overlay, 0, x + offset_pos.x, y + offset_pos.y, 1, 1, image_angle, c, image_alpha * stone_alpha_factor);
		}
	}
	

	//gpu_set_fog(false, c_white, 0, 1);

}

function break_freeze() {
	var mag_cols = concat_arrays([c_white], global.c_magic_colors);
	is_stone = false;
	if symbol_struct != -1 {
		if symbol_struct.type == symbol_type.charged {
			o_manager.handle_charged_breaking();
		}
	}
	
	var center = bbox_center(id);
	play_pitch_range(snd_symbol_freeze_break, 0.8, 0.9);
	repeat(irandom_range(3, 5)) {
		var offset_x = choose(-1, 1) * irandom_range(8, 20);
		var offset_y = irandom_range(-10, 2);
		var spr = choose(spr_fx_dust_1, spr_fx_dust_2, spr_fx_dust_3);
		var fx = new SpriteFX(center.x + offset_x, center.y + offset_y, spr, 1);
		fx.grav = random_range(-0.4, 0.05);
		fx.hspd = choose(-1, 1) * random_range(1, 4);
		fx.image_angle = irandom(359);
		fx.image_speed = random_range(0.8, 1);
		fx.image_blend = array_pick_random(mag_cols);
		fx_setup_screen_layer(fx);
	}
	
	repeat(irandom_range(6, 10)) {
		var offset_x = choose(-1, 1) * irandom_range(8, 20);
		var offset_y = irandom_range(-10, 2);
		var spr = choose(spr_fx_sparkle_1, spr_fx_sparkle_1, spr_fx_sparkle_1, spr_fx_sparkle_tri);
		var fx = new SpriteFX(center.x + offset_x, center.y + offset_y, spr, 1);
		fx.grav = random_range(-0.4, 0.4);
		fx.hspd = choose(-1, 1) * random_range(1, 4);
		fx.image_angle = irandom(359);
		fx.image_speed = random_range(0.8, 1);
		fx.image_blend = merge_color(c_aqua, array_pick_random(mag_cols), 0.25);
		fx_setup_screen_layer(fx);
	}
}