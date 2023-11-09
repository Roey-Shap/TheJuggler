if surface_exists(in_screen_draw_surface) {
	var screen = instance_nearest(0, 0, o_screen);
	if screen != noone {
		draw_surface(in_screen_draw_surface, screen.bbox_left, screen.bbox_top);
	}
	//draw_rectangle(screen.bbox_left, screen.bbox_top, screen.bbox_left + screen.sprite_width, screen.bbox_top + screen.sprite_height, false);
}


var inst_screen = instance_nearest(0, 0, o_screen);
var screen_dimensions = new Vector2(inst_screen.sprite_width, inst_screen.sprite_height);
var margin_size = round(screen_dimensions.x / 100);
var margin_vec = new Vector2(margin_size, margin_size);

var screen_up_left = new Vector2(inst_screen.bbox_left, inst_screen.bbox_top);
var screen_down_right = screen_up_left.add(screen_dimensions);
var title_position = new Vector2(screen_up_left.x + screen_dimensions.x/2, screen_up_left.y);
var player_health_position = new Vector2(screen_up_left.x, screen_up_left.y + margin_size * 3);


//var text_draw_start_pos = screen_down_right.sub(new Vector2(margin_size, screen_dimensions.y/2));

//var all_symbols = symbol_manager.get_concat_symbols_string();
symbol_manager.draw_symbols();
//var symbols_element = scribble(all_symbols);
//symbols_element.align(fa_right, fa_bottom).draw(screen_down_right.x, screen_down_right.y);

var fire_number_element = scribble(seven_digit(current_fire_counter_value));
var offset_up_left = screen_up_left.add(margin_vec);
fire_number_element.align(fa_left, fa_top).draw(offset_up_left.x, offset_up_left.y);

with (o_player) {
	//if !platforming_active {
		
	//}
	var hp_element = scribble(seven_digit(hp));
	hp_element.align(fa_middle, fa_top).draw(title_position.x, title_position.y);
}

//var s = "";
//for (var i = 0; i < array_length(current_values_in_shape); i++) {
//	s += string(current_values_in_shape[i]);
//}

if DEBUG {
	var stats_element = scribble(sfmt("Enemy: % / %\nWave: % / %\n Level: %", num_enemies_defeated_this_wave, current_wave_size, current_wave, current_number_of_waves, current_level));
	stats_element.align(fa_center, fa_top).starting_format(default_font_name, 1).draw(screen_up_left.x, screen_up_left.y - screen_dimensions.y/2);
}

if !level_title_timer.is_done() {
	var level_title_element = scribble(sfmt("[wave]LEVEL %", current_level));
	level_title_element.align(fa_center, fa_top).starting_format(default_font_name, 1).draw(title_position.x, title_position.y);
}

with (obj_cutscene_textbox_scribble) {
	draw();
}

draw_text(24, 24, instance_number(all))