function game_initialize() {
	scribble_init();
	level_data_init();
	FX_init();
	cutscenes_init();
	
	//window_set_fullscreen(true);
	html5_window_set_fullscreen(true);
	
	#macro DEVELOPER_MODE false
	#macro DEVELOPER:DEVELOPER_MODE true
	#macro DEBUG global.debug
	#macro DELTATIME global.deltatime
	
	#macro CAM_W 1920
	#macro CAM_H 1080
	#macro LAYER_META "Meta"
	#macro LAYER_WATCH_DISPLAY "WatchFaceDisplay"
	
	#macro SND_PRIORITY_FX 5

	#macro INPUT_ACC global.mouse_click_left
	#macro INPUT_BACK global.mouse_click_right
	
	room = rm_game;
	
	#macro LCD_SHADE_OFFSET global.lcd_shade_offset
	global.c_lcd_shade = scribble_rgb_to_bgr($464C35);
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
		single_shape,
		sidescrolling,
		platforming,
	}
		
	enum eWitchMode {
		none,
		at_player,
	}

	var number_symbols = array_fill_range(symbol_type.zero, symbol_type.nine);
	var shape_symbols = array_fill_range(symbol_type.square, symbol_type.column);
	var color_symbols = array_fill_range(symbol_type.white, symbol_type.brown);
	var numbers_and_shapes_symbols = concat_arrays(number_symbols, shape_symbols);
	
	level_data = [
		new LevelData(eLevels.NULL, -1, -1, -1, eLevelType.normal),
		
		//
		(new LevelData(eLevels.numbers, cv_number_of_enemies_level_1, cv_base_time_between_symbol_per_wave_level_1, number_symbols, eLevelType.sidescrolling)),
		//
		
		(new LevelData(eLevels.numbers, cv_number_of_enemies_level_1, cv_base_time_between_symbol_per_wave_level_1, number_symbols, eLevelType.normal)),
			//.set_killed_symbols_become_bullets(),
		(new LevelData(eLevels.fast_numbers, cv_number_of_enemies_level_1, cv_base_time_between_symbol_per_wave_level_2, number_symbols, eLevelType.normal)),
			//.set_killed_symbols_become_bullets(),		
		new LevelData(eLevels.shapes, cv_number_of_enemies_level_1, cv_base_time_between_symbol_per_wave_level_1, shape_symbols, eLevelType.normal),
		new LevelData(eLevels.fast_numbers_and_shapes, cv_number_of_enemies_level_1, cv_base_time_between_symbol_per_wave_level_3, numbers_and_shapes_symbols, eLevelType.normal),
		new LevelData(eLevels.platforming_intro, -1, -1, -1, eLevelType.sidescrolling),
		new LevelData(eLevels.platforming_intro, cv_number_of_enemies_level_1, cv_base_time_between_symbol_per_wave_level_1, numbers_and_shapes_symbols, eLevelType.platforming),
		
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
	witch_mode = eWitchMode.none;
	
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
		
	static set_witch_mode = function(mode) {
		witch_mode = mode;
	}
}