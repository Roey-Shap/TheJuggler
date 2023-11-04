var inst_screen = instance_nearest(0, 0, o_screen);
var screen_up_left = get_pos(inst_screen);
var screen_dimensions = new Vector2(inst_screen.sprite_width, inst_screen.sprite_height);
var screen_down_right = screen_up_left.add(screen_dimensions);

var margin_size = round(screen_dimensions.x / 100);

var text_draw_start_pos = screen_down_right.sub(new Vector2(margin_size, screen_dimensions.y/2));

var all_symbols = symbol_manager.get_concat_symbols_string();

var symbols_element = scribble(all_symbols);
symbols_element.align(fa_right, fa_top).draw(text_draw_start_pos.x, text_draw_start_pos.y);

var stats_element = scribble(sfmt("Enemy: % / %\nWave: % / %\n Level: %\nFIRING: %", num_enemies_defeated_this_wave, current_wave_size, current_wave, current_number_of_waves, current_level, current_fire_counter_value));
stats_element.align(fa_center, fa_top).starting_format(default_font_name, 1).draw(screen_up_left.x, screen_up_left.y);