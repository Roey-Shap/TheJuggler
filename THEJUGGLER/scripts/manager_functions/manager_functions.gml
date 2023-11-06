function game_initialize() {
	scribble_init();
	level_data_init();
	
	//window_set_fullscreen(true);
	html5_window_set_fullscreen(true);
	
	#macro DELTATIME global.deltatime
	#macro SND_PRIORITY_FX 5
	
	room = rm_game;
}


function level_data_init() {
	enum eLevels {
		numbers,
		fast_numbers,
		shapes,
		numbers_and_shapes,
		fast_numbers_and_shapes,
		colors,
		fast_numbers_shapes_colors,
		bullet_hell,				// uses all mechanics and slowly introduces it at the very start
		blinking_eye,				// same, uses all prev and slowly introduces
	}

	var number_symbols = array_fill_range(symbol_type.zero, symbol_type.nine);
	var shape_symbols = array_fill_range(symbol_type.square, symbol_type.column);
	var color_symbols = array_fill_range(symbol_type.white, symbol_type.brown);
	
	level_data = [
		new LevelData(eLevels.numbers, cv_number_of_enemies_level_1, cv_base_time_between_symbol_per_wave_level_1, concat_arrays(number_symbols, shape_symbols)),
		new LevelData(eLevels.fast_numbers, cv_number_of_enemies_level_1, cv_base_time_between_symbol_per_wave_level_2, number_symbols),
		new LevelData(eLevels.shapes, cv_number_of_enemies_level_1, cv_base_time_between_symbol_per_wave_level_2, shape_symbols),
	];
}

function LevelData(_enum_tag, _enemies_per_wave_curve, _time_between_enemies_curve, _symbol_types) constructor {
	enum_tag = _enum_tag;
	enemies_per_wave_curve = _enemies_per_wave_curve;
	time_between_enemies_curve = _time_between_enemies_curve;
	allowed_symbols = _symbol_types;
}