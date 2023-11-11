if surface_exists(in_screen_draw_surface) and get_level_data().level_type == eLevelType.sidescrolling {
	var screen = instance_nearest(0, 0, o_screen);
	if screen != noone {
		draw_surface(in_screen_draw_surface, screen.bbox_left, screen.bbox_top);
	}
	
}


var inst_screen = instance_nearest(0, 0, o_screen);
var screen_dimensions = new Vector2(inst_screen.sprite_width, inst_screen.sprite_height);
var margin_size = round(screen_dimensions.x / 100);
var margin_vec = new Vector2(margin_size, margin_size);

var screen_up_left = new Vector2(inst_screen.bbox_left, inst_screen.bbox_top);
var screen_down_right = screen_up_left.add(screen_dimensions);
var title_position = new Vector2(screen_up_left.x + screen_dimensions.x/2, screen_up_left.y);
var player_health_position = new Vector2(screen_up_left.x, screen_up_left.y + margin_size * 3);

//if keyboard_check(vk_space) {
//		draw_rectangle(inst_screen.bbox_left, inst_screen.bbox_top, inst_screen.bbox_left + inst_screen.sprite_width, inst_screen.bbox_top + inst_screen.sprite_height, false);
//	}
//var text_draw_start_pos = screen_down_right.sub(new Vector2(margin_size, screen_dimensions.y/2));

//var all_symbols = symbol_manager.get_concat_symbols_string();
symbol_manager.draw_symbols();
//var symbols_element = scribble(all_symbols);
//symbols_element.align(fa_right, fa_bottom).draw(screen_down_right.x, screen_down_right.y);

var fire_number_element = scribble(seven_digit(current_fire_counter_value));
var offset_up_left = screen_up_left.add(margin_vec);
fire_number_element.align(fa_left, fa_top);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(global.c_lcd_shade);
draw_set_alpha(global.lcd_alpha);
draw_text_scribble(offset_up_left.x + LCD_SHADE_OFFSET.x, offset_up_left.y + LCD_SHADE_OFFSET.y, seven_digit(current_fire_counter_value));
draw_set_color(c_white);
draw_set_alpha(1);
fire_number_element.draw(offset_up_left.x, offset_up_left.y);

with (o_player) {
	draw_set_color(global.c_lcd_shade);
	draw_set_alpha(global.lcd_alpha);
	draw_set_halign(fa_middle);
	draw_set_valign(fa_top);
	draw_text_scribble(title_position.x + LCD_SHADE_OFFSET.x, title_position.y + LCD_SHADE_OFFSET.y, seven_digit(hp));
	draw_set_color(c_white);
	draw_set_alpha(1);
	var hp_element = scribble(seven_digit(hp));		//seven_digit(hp)
	hp_element.align(fa_middle, fa_top).draw(title_position.x, title_position.y);
	//draw_set_halign(fa_left);
	//draw_set_valign(fa_top);
	//draw_text(24, 24, sfmt("buffer: %, coyote time: %", buffer_jump_timer.current_count, coyote_time_timer.current_count));
}

with (o_watch_screen_shade) {
	draw_self();
}

if DEBUG {
	var stats_element = scribble(sfmt("Enemy: % / %\nWave: % / %\n Level: %", num_enemies_defeated_this_wave, current_wave_size, current_wave, current_number_of_waves, current_level));
	stats_element.align(fa_center, fa_top).starting_format(default_font_name, 1).draw(screen_up_left.x, screen_up_left.y - screen_dimensions.y/2);
}

//if !level_title_timer.is_done() {
//	var level_title_element = scribble(sfmt("[wave]LEVEL %", current_level));
//	level_title_element.align(fa_center, fa_top).starting_format(default_font_name, 1).draw(title_position.x, title_position.y);
//}

with (obj_cutscene_textbox_scribble) {
	draw();
}

//draw_text(24, 24, instance_number(all))