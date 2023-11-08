function game_initialize() {
	scribble_init();
	level_data_init();
	FX_init();
	
	//window_set_fullscreen(true);
	html5_window_set_fullscreen(true);
	
	#macro DEVELOPER_MODE false
	#macro DEVELOPER:DEVELOPER_MODE true
	#macro DEBUG global.debug
	#macro DELTATIME global.deltatime
	#macro CAM_W 1920
	#macro CAM_H 1080
	#macro LAYER_WATCH_DISPLAY "WatchFaceDisplay"
	#macro SND_PRIORITY_FX 5
	
	room = rm_game;
}


function level_data_init() {
	enum eLevels {
		NULL,
		numbers,
		fast_numbers,
		shapes,
		numbers_and_shapes,
		fast_numbers_and_shapes,
		platforming_intro,
		fast_numbers_shapes_colors,
		bullet_hell,				// uses all mechanics and slowly introduces it at the very start
		blinking_eye,				// same, uses all prev and slowly introduces
	}
	
	enum eLevelType {
		normal,
		sidescrolling,
		platforming,
	}

	var number_symbols = array_fill_range(symbol_type.zero, symbol_type.nine);
	var shape_symbols = array_fill_range(symbol_type.square, symbol_type.column);
	var color_symbols = array_fill_range(symbol_type.white, symbol_type.brown);
	var numbers_and_shapes_symbols = concat_arrays(number_symbols, shape_symbols);
	
	level_data = [
		new LevelData(eLevels.NULL, -1, -1, -1, eLevelType.normal),
		(new LevelData(eLevels.numbers, cv_number_of_enemies_level_1, cv_base_time_between_symbol_per_wave_level_1, number_symbols, eLevelType.platforming)).set_killed_symbols_become_bullets(),
		
		new LevelData(eLevels.numbers, cv_number_of_enemies_level_1, cv_base_time_between_symbol_per_wave_level_1, number_symbols, eLevelType.normal),
		new LevelData(eLevels.fast_numbers, cv_number_of_enemies_level_1, cv_base_time_between_symbol_per_wave_level_2, number_symbols, eLevelType.normal),
		new LevelData(eLevels.shapes, cv_number_of_enemies_level_1, cv_base_time_between_symbol_per_wave_level_2, shape_symbols, eLevelType.normal),
		new LevelData(eLevels.fast_numbers_and_shapes, cv_number_of_enemies_level_1,cv_base_time_between_symbol_per_wave_level_2, numbers_and_shapes_symbols, eLevelType.normal),
		new LevelData(eLevels.platforming_intro, -1, -1, -1, eLevelType.sidescrolling),
	];
}

function LevelData(_enum_tag, _enemies_per_wave_curve, _time_between_enemies_curve, _symbol_types, _level_type) constructor {
	enum_tag = _enum_tag;
	enemies_per_wave_curve = _enemies_per_wave_curve;
	time_between_enemies_curve = _time_between_enemies_curve;
	allowed_symbols = _symbol_types;
	level_type = _level_type;
	killed_symbols_become_bullets = false;
	
	static set_scrolling_level = function() {
		level_type = eLevelType.sidescrolling;
		return self;
	}
	
	static is_scrolling_level = function() {
		return level_type == eLevelType.sidescrolling;
	}
	
	static set_killed_symbols_become_bullets = function() {
		killed_symbols_become_bullets = true;
		return self;
	}
	
	static get_killed_symbols_become_bullets = function() {
		return killed_symbols_become_bullets;
	}
}