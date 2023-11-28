
//draw_circle(CAM_W/2, CAM_H/2, 100, false);
if instance_exists(o_screen) {
	var inst_screen = instance_nearest(0, 0, o_screen);
	var screen_dimensions = new Vector2(inst_screen.sprite_width, inst_screen.sprite_height);
	var margin_size = round(screen_dimensions.x / 100);
	var margin_vec = new Vector2(margin_size, margin_size);

	var screen_up_left = new Vector2(inst_screen.bbox_left, inst_screen.bbox_top);
	var screen_down_right = screen_up_left.add(screen_dimensions);
	title_position = new Vector2(screen_up_left.x + screen_dimensions.x/2, screen_up_left.y + 40);
	var player_health_position = new Vector2(screen_up_left.x, screen_up_left.y + margin_size * 3);
}

switch (state_game) {
	case st_game_state.main_menu:
		if instance_exists(o_screen) {
			if draw_flicker.is_done() {
				draw_flicker.start();
				draw_str = !draw_str;
			} 
			
			var time_scale = 0.1;
			var mins = seven_digit(current_minute, time_scale);
			if current_minute < 10 {
				mins = seven_digit(0, time_scale) + mins;
			}
			
			var hours = seven_digit(current_hour, time_scale);
			if current_hour < 10 {
				hours = seven_digit(0, time_scale) + hours;
			}
			
			
			var time_str = sfmt("%[c_green]%[/c]%", hours, draw_str? ":" : " ", mins);
			
			draw_set_halign(fa_right);
			draw_set_valign(fa_bottom);
			draw_set_color(global.c_lcd_shade);
			draw_set_alpha(global.lcd_alpha);
			draw_text_scribble(screen_down_right.x + LCD_SHADE_OFFSET.x, screen_down_right.y + LCD_SHADE_OFFSET.y, time_str);
			draw_set_alpha(1);
			draw_set_color(c_white);
			draw_text_scribble(screen_down_right.x, screen_down_right.y, time_str);
		}
	break;
	
	case st_game_state.playing:		
		if surface_exists(in_screen_draw_surface) { // and get_level_data().level_type == eLevelType.sidescrolling
			var screen = instance_nearest(0, 0, o_screen);
			if screen != noone {
				draw_surface(in_screen_draw_surface, screen.bbox_left, screen.bbox_top);
			}
	
		}


		//if keyboard_check(vk_space) {
		//		draw_rectangle(inst_screen.bbox_left, inst_screen.bbox_top, inst_screen.bbox_left + inst_screen.sprite_width, inst_screen.bbox_top + inst_screen.sprite_height, false);
		//	}
		//var text_draw_start_pos = screen_down_right.sub(new Vector2(margin_size, screen_dimensions.y/2));

		//var all_symbols = symbol_manager.get_concat_symbols_string();
		if !watch_platforming_growth_perform_transition {
			symbol_manager.draw_symbols();
		}
		//var symbols_element = scribble(all_symbols);
		//symbols_element.align(fa_right, fa_bottom).draw(screen_down_right.x, screen_down_right.y);

		var fire_num_str = sfmt("%\n[scaleStack,%]%", seven_digit(current_fire_counter_value), score_scale, seven_digit(current_score));
		var fire_number_element = scribble(fire_num_str);
		var offset_up_left = screen_up_left.add(margin_vec); //.add(new Vector2(screen_dimensions.x - margin_vec.x * 2, 0));
		fire_number_element.align(fa_left, fa_top);
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
		draw_set_color(global.c_lcd_shade);
		draw_set_alpha(global.lcd_alpha);
		draw_text_scribble(offset_up_left.x + LCD_SHADE_OFFSET.x, offset_up_left.y + LCD_SHADE_OFFSET.y, fire_num_str);
		draw_set_color(c_white);
		draw_set_alpha(1);
		fire_number_element.draw(offset_up_left.x, offset_up_left.y);

		with (o_player) {
			if !been_take_from_GUI {
				var title_position = other.title_position;
				if draw_hp_as_text {
					draw_set_color(global.c_lcd_shade);
					draw_set_alpha(global.lcd_alpha);
					draw_set_halign(fa_middle);
					draw_set_valign(fa_center);
					draw_text_scribble(title_position.x + LCD_SHADE_OFFSET.x, title_position.y + LCD_SHADE_OFFSET.y, seven_digit(hp));
					draw_set_color(c_white);
					draw_set_alpha(1);
					var hp_element = scribble(seven_digit(hp));		//seven_digit(hp)
					hp_element.align(draw_get_halign(), draw_get_valign()).draw(title_position.x, title_position.y);
				} else {
					draw_sprite_ext(sprite_index, image_index, title_position.x + LCD_SHADE_OFFSET.x + shake_offset.x, title_position.y + LCD_SHADE_OFFSET.y + shake_offset.y + 32, image_xscale * draw_scale.x, image_yscale * draw_scale.y, image_angle, global.c_lcd_shade, global.lcd_alpha_large * image_alpha);
					draw_sprite_ext(sprite_index, image_index, title_position.x + shake_offset.x, title_position.y + shake_offset.y + 32, image_xscale * draw_scale.x, image_yscale * draw_scale.y, image_angle, image_blend, image_alpha);
					o_manager.draw_circles(title_position.x, title_position.y - 32 + 32, 8, hp);
				}
			}
			//draw_set_halign(fa_left);
			//draw_set_valign(fa_top);
			//draw_text(24, 24, sfmt("buffer: %, coyote time: %", buffer_jump_timer.current_count, coyote_time_timer.current_count));
		}
	
	with (o_witch) {
		if draw_hp {
			var hp_bar_margin_x = screen_dimensions.x * 0.075;
			var hp_bar_dims = new Vector2(screen_dimensions.x - hp_bar_margin_x*2, screen_dimensions.y * 0.06);
			var hp_bar_corner_1 = screen_up_left.add(new Vector2(hp_bar_margin_x, -hp_bar_dims.y * 2));
			var hp_bar_corner_2 = hp_bar_corner_1.add(hp_bar_dims);
			draw_set_color(c_black);
			draw_rect_vec(hp_bar_corner_1, hp_bar_corner_2, false);
			
			// draw lerping hp
			draw_set_color(c_white);
			draw_rect_vec(hp_bar_corner_1, hp_bar_corner_1.add(new Vector2(hp_bar_dims.x * hp_shown / hp_max, hp_bar_dims.y)), false);
			
			// draw actual hp
			var hp_real_bottom_right = hp_bar_corner_1.add(new Vector2(hp_bar_dims.x * hp / hp_max, hp_bar_dims.y));
			var base1 = global.c_magic_1;
			var base2 = global.c_magic_2;
			var t = map(-1, 1, sin(current_time/350), 0, 1);
			var c1 = merge_color(base1, base2, t);
			var c2 = merge_color(base1, base2, 1 - t);
			draw_rectangle_color(hp_bar_corner_1.x, hp_bar_corner_1.y,
								 hp_real_bottom_right.x, hp_real_bottom_right.y, 
								 c1, c2, c2, c1,
								 false);
		}
	}
	
	break;
}

with (o_watch_screen_shade) {
	draw_self();
}

if DEBUG and instance_exists(o_screen){
	var stats_element = scribble(sfmt("Enemy: % / %\nWave: % / %\n Level: %", num_enemies_defeated_this_wave, current_wave_size, current_wave, current_number_of_waves, current_level));
	stats_element.align(fa_center, fa_top).starting_format(default_font_name, 1).draw(screen_up_left.x, screen_up_left.y - screen_dimensions.y/2);
	draw_set_halign(fa_left);
	draw_text(24, 24, string(charge_level));
	draw_text(24, 48, string(between_symbols_timer.current_count));
	draw_text(24, 72, sfmt("num cs: %", instance_number(o_cutscene)));
}

//if !level_title_timer.is_done() {
//	var level_title_element = scribble(sfmt("[wave]LEVEL %", current_level));
//	level_title_element.align(fa_center, fa_top).starting_format(default_font_name, 1).draw(title_position.x, title_position.y);
//}

var debug_override = DEVELOPER_MODE and keyboard_check(vk_space);
if obscure_screen_alpha > 0 and !debug_override {
	draw_set_alpha(obscure_screen_alpha);
	draw_set_color(c_black);
	var w = o_screen.bbox_right - o_screen.bbox_left;
	var h = o_screen.bbox_bottom - o_screen.bbox_top;
	var num_frames = sprite_get_number(spr_glitch_nineslice);
	draw_sprite_part_ext(spr_glitch_nineslice, round(current_time / 100) % num_frames,
							0, 0, w, h, 
							o_screen.bbox_left, o_screen.bbox_top, 1, 1, c_white, obscure_screen_alpha);
	//with (o_screen) {
	//	var spr_prev = sprite_index;
				
	//	draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, false);
	//	draw_sprite_ext(spr_glitch_nineslice,  % spr_glitch_nineslice, bbox_left, bbox_top, image_xscale/3, image_yscale/3, image_angle, image_blend, other.obscure_screen_alpha);
	//}
			
	draw_set_alpha(1);
}

manage_fade();

with (obj_cutscene_textbox_scribble) {
	draw();
}
