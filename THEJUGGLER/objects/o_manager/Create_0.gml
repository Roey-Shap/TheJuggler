game_initialize();

enum st_game_state {
	main_menu,
	playing,
	paused,
	
	LAST
}



state_game = st_game_state.main_menu;

key_accept = mb_left;
key_fullscreen = ord("F");


// Progression Tracking Variables
current_level = 0;				// L levels
current_number_of_waves = -1;	// each level has W waves

current_wave = 0;				// each wave has a number N of enemies
current_wave_size = -1;
num_enemies_created_this_wave = 0;
num_enemies_defeated_this_wave = 0;

num_symbols = 0;
symbol_penalty_threshold = 7;

between_symbols_timer = new Timer(get_frames(2));
between_symbols_timer.start();
symbol_manager = new SymbolManager();

current_fire_counter_value = 0;

// Firing and Symbol Tracking
current_values_in_shape = [];
enum shape_forming_status {
	invalid,
	partial,
	full
}

function add_value_to_shape(value) {
	array_push(current_values_in_shape, value);
}

function get_current_shape_value() {
	var num_values_in_shape = array_length(current_values_in_shape);
	if num_values_in_shape > 4 {
		return symbol_type.LAST;
	}
	
	var square_status = shape_values_form_helper(symbol_type.square);
	var triangle_status = shape_values_form_helper(symbol_type.triangle);
	var row_status = shape_values_form_helper(symbol_type.row);
	var column_status = shape_values_form_helper(symbol_type.column);
	var diamond_status = shape_values_form_helper(symbol_type.diamond);
	
	if diamond_status == shape_forming_status.full {
		return symbol_type.diamond;
	} else if triangle_status == shape_forming_status.full {
		return symbol_type.triangle;
	} else if row_status == shape_forming_status.full {
		return symbol_type.row;
	} else if column_status == shape_forming_status.full {
		return symbol_type.column;
	} else if square_status == shape_forming_status.full {
		return symbol_type.square;
	} else if isIn(shape_forming_status.partial, [square_status, triangle_status, row_status, column_status, diamond_status]) {
		return symbol_type.partially_formed;
	}
	
	return symbol_type.LAST;
}

function get_arrangement_status(arrangement, allowed_arrangements) {
	var num_arrangements = array_length(allowed_arrangements);
	var best_arrangement_status = shape_forming_status.invalid;
	for (var i = 0; i < num_arrangements; i++) {
		var cur_suggested_arrangement = allowed_arrangements[i];
		if array_equals_unordered(arrangement, cur_suggested_arrangement) {
			best_arrangement_status = shape_forming_status.full;
			break;
		} else if array_is_subset(arrangement, cur_suggested_arrangement) {
			best_arrangement_status = shape_forming_status.partial;
		}
	}
	
	return best_arrangement_status;
}

function shape_values_form_helper(_symbol_type) {
	var arrangements;
	switch (_symbol_type) {
		case symbol_type.square:
			arrangements = [
				[1, 3, 7, 9],
				[1, 2, 4, 5],
				[2, 3, 5, 6],
				[4, 5, 7, 8],
				[5, 6, 8, 9]
			];
		break;
		
		case symbol_type.row:
			arrangements = [
				[7, 8, 9],
				[4, 5, 6],
				[1, 2, 3]
			];
		break;
		
		case symbol_type.column:
			arrangements = [
				[7, 4, 1],
				[8, 5, 2],
				[9, 6, 3]
			];
		break;
		
		case symbol_type.diamond:
			arrangements = [
				[2, 4, 6, 8]
			];
		break;
		
		case symbol_type.triangle:
			arrangements = [
				[4, 6, 8],
				[1, 5, 3],
			];
		break;
	}

	return get_arrangement_status(current_values_in_shape, arrangements);
}

level_title_timer = new Timer(get_frames(2));

face_button_sounds = [snd_watch_beep_1, snd_watch_beep_2, snd_watch_beep_3];

function create_symbol() {
	num_enemies_created_this_wave += 1;
	var symbol = symbol_manager.generate_symbol_from_level_data(level_data[current_level-1]);
	//var random_symbol_value = irandom_range(0, 9);
	//var symbol = new Symbol(random_symbol_value, symbol_type.number);
	symbol_manager.add_symbol(symbol);
}

function get_num_symbols() {
	return symbol_manager.get_num_symbols();
}

function start_next_level() {
	current_level += 1;
	current_wave = 0;
	current_number_of_waves = round(2 * current_level) + 4;
	level_title_timer.start();
	start_next_wave();
}

function start_next_wave() {
	symbol_manager.clear_symbols();
	
	if current_wave >= current_number_of_waves {
		play_pitch_range(snd_level_complete, 1, 1);
		start_next_level();
	} else {
		play_pitch_range(snd_wave_complete, 1, 1);
		current_wave += 1;
		num_enemies_created_this_wave = 0;
		num_enemies_defeated_this_wave = 0;
		var num_enemies_curve_value = sample_curve(get_num_enemies_per_wave_curve(current_level), current_wave / current_number_of_waves);
		var num_enemies_curve_scale = round(6 + (2.5 * current_level) * random_range(0.9, 1.1));
		current_wave_size = round(num_enemies_curve_value * num_enemies_curve_scale);
		
		var base_time_between_symbols_for_wave = sample_curve(get_time_between_symbols_curve(current_level), current_wave / current_number_of_waves);
		//var base_time_curve_scale = 
		between_symbols_timer.set_duration(get_frames(base_time_between_symbols_for_wave));
		between_symbols_timer.start();
	}
}

function hit_player() {
	var player = instance_nearest(0, 0, o_player);
	if player != noone {
		player.hp -= 1;
		if player.hp <= 0 {
			handle_game_over();
		}
	}
}

function get_num_enemies_per_wave_curve(level_number) {
	//var curves = [
	//	cv_number_of_enemies_level_1,
	//	cv_number_of_enemies_level_2,
	//];
	
	//return curves[wave_number-1];
	return level_data[level_number-1].enemies_per_wave_curve;
}

function get_time_between_symbols_curve(level_number) {
	//var curves = [
	//	cv_base_time_between_symbol_per_wave_level_1,
	//	,
	//];
	
	//return curves[wave_number-1];
	return level_data[level_number-1].time_between_enemies_curve;
}

function handle_game_over() {
	state_game = st_game_state.main_menu;
}

function handle_fire() {
	var current_fire_shape_value = get_current_shape_value();
	var removed_number = symbol_manager.kill_first_symbol_of_value(current_fire_counter_value);
	var removed_shape = symbol_manager.kill_first_symbol_of_value(current_fire_shape_value);
	if removed_number != -1 {
		num_enemies_defeated_this_wave += 1;
	}
	
	if removed_shape != -1 {
		num_enemies_defeated_this_wave += 1;
		//reset_buttons_for_shape();
	}
}

function reset_buttons_for_shape() {
	with (o_button_parent) {
		image_blend = c_white;
	}
	
	current_values_in_shape = [];
}

function receive_click_from_face_button(button) {
	var value = button.button_value;
	play_random_sound(face_button_sounds, 0.85, 1.1);
	
	if value == 0 {
		handle_fire();
	} else if value == 10 {
		reset_buttons_for_shape();
	} else {
		if isIn(value, current_values_in_shape) {
			button.image_blend = c_white;
			array_remove(current_values_in_shape, value);
		} else {
			button.image_blend = c_lime;
			add_value_to_shape(value);
		}		
		
		current_fire_counter_value = (current_fire_counter_value + 1) % 10;
		//if get_current_shape_value() == symbol_type.LAST {
		//	reset_buttons_for_shape();
		//}
	}
}

global.deltatime = 1;