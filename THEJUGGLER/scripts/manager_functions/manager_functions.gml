function game_initialize() {
	global.c_lcd_shade = scribble_rgb_to_bgr($464C35);
	global.c_hurt = merge_color(c_orange, c_red, 0.5);
	global.c_magic_1 = scribble_rgb_to_bgr($FF32DD);
	global.c_magic_2 = scribble_rgb_to_bgr($B631FF);
	global.c_magic_3 = scribble_rgb_to_bgr($E50170);
	global.c_magic_4 = scribble_rgb_to_bgr($5600CC);
	global.c_magic_colors = [
		global.c_magic_1,
		global.c_magic_2,
		global.c_magic_3,
		global.c_magic_4,
	];
	global.c_lcd_dark = scribble_rgb_to_bgr($264C26);
	
	scribble_init();
	cutscenes_init();
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
	#macro LAYER_META "Meta"
	#macro LAYER_WATCH_DISPLAY "WatchFaceDisplay"
	
	#macro SND_PRIORITY_FX 5
	#macro SND_PRIORITY_MUSIC 4

	#macro INPUT_ACC global.mouse_click_left
	#macro INPUT_BACK global.mouse_click_right
	
	room = rm_main_menu;
	
	#macro LCD_SHADE_OFFSET global.lcd_shade_offset
	
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
		
	var number_symbols = array_fill_range(symbol_type.zero, symbol_type.nine);
	var shape_symbols = array_fill_range(symbol_type.square, symbol_type.column);
	var color_symbols = array_fill_range(symbol_type.white, symbol_type.brown);
	var numbers_and_shapes_symbols = concat_arrays(number_symbols, shape_symbols);
	var more_shapes = concat_arrays(numbers_and_shapes_symbols, shape_symbols);
	var even_more_shapes = concat_arrays(more_shapes, shape_symbols);
	var final_level_symbols = [
		symbol_type.zero,
		symbol_type.one,
		symbol_type.two,
		symbol_type.three,
		symbol_type.four,
		symbol_type.five,
		symbol_type.six,
		symbol_type.seven,
		symbol_type.eight,
		symbol_type.nine,
		
		symbol_type.column,
		symbol_type.column,
		symbol_type.column,
		symbol_type.square,
		symbol_type.square,
		symbol_type.square,
		symbol_type.row,
		symbol_type.row,
		symbol_type.row,
		symbol_type.triangle,
		symbol_type.triangle,
		symbol_type.diamond,
		symbol_type.diamond,
	
	];
	
	level_data = [
		new LevelData(eLevels.NULL, -1, -1, 0, -1, eLevelType.normal),
		
		////////
		////////
		////////
		// (new LevelData(eLevels.fast_numbers_and_shapes, cv_number_of_enemies_level_1, cv_base_time_between_symbol_per_wave_level_3, 3, numbers_and_shapes_symbols, eLevelType.normal))
		//  .set_starting_cutscene(cs_butterfly_and_player)
		//  .set_force_level_save(),
		//new LevelData(eLevels.platforming_intro, -1, -1, 0, -1, eLevelType.sidescrolling)
		//.set_starting_cutscene(cs_set_creepy_music),	
		
		//// Witch 1 - introduce Witch
		//(new LevelData(eLevels.bullet_hell, cv_number_of_enemies_witch_1, cv_base_time_between_symbol_per_wave_platforming_with_numbers_1, 2, numbers_and_shapes_symbols, eLevelType.platforming))
		//.set_starting_cutscene(cs_witch_intro)
		//.set_witch_modes([e_witch_state.flying_across]),
		
		//// Witch 2
		//(new LevelData(eLevels.bullet_hell, cv_number_of_enemies_witch_2, cv_base_time_between_symbol_per_wave_platforming_with_numbers_2, 2, numbers_and_shapes_symbols, eLevelType.platforming))
		//.set_starting_cutscene(cs_witch_explains_exploding_symbols)
		//.set_killed_symbols_become_bullets()
		//.set_witch_modes([e_witch_state.flying_across, e_witch_state.dropping_bombs]),
		
		//(new LevelData(eLevels.bullet_hell, cv_number_of_enemies_platforming_with_numbers_1, cv_base_time_between_symbol_per_wave_platforming_with_numbers_1, 2, numbers_and_shapes_symbols, eLevelType.platforming))
		//.set_starting_cutscene(cs_witch_3_intro)
		//.set_charging_level()
		//.set_witch_modes([e_witch_state.flying_across, e_witch_state.dropping_bombs, e_witch_state.across_swoop_attack, e_witch_state.turn_to_stone]),
		
		//(new LevelData(eLevels.bullet_hell, cv_number_of_enemies_platforming_with_numbers_1, cv_base_time_between_symbol_per_wave_platforming_with_numbers_1, 2, numbers_and_shapes_symbols, eLevelType.platforming))
		//.set_starting_cutscene(cs_witch_final_level_intro)
		//.set_charging_level()
		//.set_witch_modes([e_witch_state.flying_across, e_witch_state.dropping_bombs, e_witch_state.across_swoop_attack, e_witch_state.turn_to_stone]),
	
		////////
		////////
		////////
		
/*1*/	  (new LevelData(eLevels.numbers, cv_number_of_enemies_level_1, cv_base_time_between_symbol_per_wave_level_1, 3, number_symbols, eLevelType.normal))
		  	.set_starting_cutscene(cs_start_game),
/*2*/	  (new LevelData(eLevels.fast_numbers, cv_number_of_enemies_level_fast_numbers, cv_base_time_between_symbol_per_wave_level_2, 3, number_symbols, eLevelType.normal))
		  	.set_starting_cutscene(cs_numbers_fast_start),
		  	//.set_cutscenes([cs_numbers_getting_harder], [0.2]),		
/*3*/	  (new LevelData(eLevels.shapes, cv_number_of_enemies_level_shapes_intro, cv_base_time_between_symbol_per_wave_level_shapes_intro, 2, shape_symbols, eLevelType.normal))
		  .set_starting_cutscene(cs_weirded_out_by_shapes),
/*4*/	  (new LevelData(eLevels.fast_numbers_and_shapes, cv_number_of_enemies_level_1, cv_base_time_between_symbol_per_wave_level_3, 3, numbers_and_shapes_symbols, eLevelType.normal))
		  .set_starting_cutscene(cs_butterfly_and_player)
		  .set_force_level_save(),
		  
/*5*/	  new LevelData(eLevels.platforming_intro, -1, -1, 0, -1, eLevelType.sidescrolling)
		  .set_starting_cutscene(cs_set_creepy_music)
		  .set_force_level_save(),		
		  
		  //(new LevelData(eLevels.platforming_intro, cv_number_of_enemies_level_1, cv_base_time_between_symbol_per_wave_level_1, 3, numbers_and_shapes_symbols, eLevelType.platforming))
		  //.set_killed_symbols_become_bullets(),
		  
		  // Witch 1 - introduce Witch
/*6*/	  (new LevelData(eLevels.bullet_hell, cv_number_of_enemies_witch_1, cv_base_time_between_symbol_per_wave_platforming_with_numbers_1, 2, numbers_and_shapes_symbols, eLevelType.platforming))
		  .set_starting_cutscene(cs_witch_intro)
		  .set_witch_modes([e_witch_state.flying_across, e_witch_state.dropping_bombs])
		  .set_force_level_save(),
		  
		  // Witch 2
/*7*/	  (new LevelData(eLevels.bullet_hell, cv_number_of_enemies_witch_2, cv_base_time_between_symbol_per_wave_platforming_with_numbers_2, 2, numbers_and_shapes_symbols, eLevelType.platforming))
		  .set_starting_cutscene(cs_witch_explains_exploding_symbols)
		  .set_killed_symbols_become_bullets()
		  .set_witch_modes([e_witch_state.flying_across, e_witch_state.dropping_bombs, e_witch_state.across_swoop_attack])
		  .set_force_level_save(),
		  
		  // Witch Charging 1
/*8*/	  (new LevelData(eLevels.bullet_hell, cv_number_of_enemies_platforming_with_numbers_1, cv_base_time_between_symbol_per_wave_platforming_with_numbers_1, 2, more_shapes, eLevelType.platforming))
		  .set_starting_cutscene(cs_witch_3_intro)
		  .set_charging_level()
		  .set_witch_modes([e_witch_state.flying_across, e_witch_state.dropping_bombs, e_witch_state.across_swoop_attack])
		  .set_witch_difficulty(2)
		  .set_force_level_save()
		  .set_limit_spiky_in_first_wave(),
		  
/*9*/	  // Witch Charging Hard
		  (new LevelData(eLevels.bullet_hell, cv_number_of_enemies_platforming_with_numbers_1, cv_base_time_between_symbol_per_wave_platforming_with_numbers_1, 2, more_shapes, eLevelType.platforming))
		  .set_starting_cutscene(cs_witch_final_level_intro)
		  .set_charging_level()
		  .set_witch_modes([e_witch_state.flying_across, e_witch_state.dropping_bombs, e_witch_state.across_swoop_attack])
		  .set_witch_difficulty(3)
		  .set_force_level_save()
		  .set_limit_spiky_in_first_wave(),
	];
}

function LevelData(_enum_tag, _enemies_per_wave_curve, _time_between_enemies_curve, _num_waves, _symbol_types, _level_type) constructor {
	enum_tag = _enum_tag;
	enemies_per_wave_curve = _enemies_per_wave_curve;
	time_between_enemies_curve = _time_between_enemies_curve;
	number_of_waves = _num_waves;
	allowed_symbols = _symbol_types;
	level_type = _level_type;
	killed_symbols_become_bullets = false;
	witch_modes = [];
	witch_difficulty = 1;
	witch_active = false;
	charging_level = false;
	force_level_save = false;
	limit_spiky_in_first_wave = false;
	
	cutscene_level_start = new CutsceneData(-1, false);
	cutscene_level_end = new CutsceneData(-1, false);
	cutscenes_intermediate = [];
	cutscenes_intermediate_timings = [];
	cutscenes_intermediate_index = 0;
	
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
		
	static set_witch_modes = function(modes) {
		witch_modes = modes;
		witch_active = true;
		return self;
	}

	static set_witch_difficulty = function(difficulty) {
		witch_difficulty = difficulty;
		return self;
	}

	static play_starting_cutscene = function() {
		if cutscene_level_start.been_played() {
			return;
		}
		
		cutscene_level_start.play();
	}
	
	static play_ending_cutscene = function() {
		if cutscene_level_end.been_played() {
			return;
		}
		
		cutscene_level_end.play();
	}
		
	static set_starting_cutscene = function(cs) {
		cutscene_level_start = cs;
		return self;
	}
	
	static set_ending_cutscene = function(cs) {
		cutscene_level_end = cs;
		return self;
	}
	
	static set_cutscenes = function(cs_array, timings) {
		if array_length(cs_array) != array_length(timings) {
			show_error("Some intermediate cutscene array doesn't have a matching wave timing for each scene.", true);
		}
		
		cutscenes_intermediate = cs_array;
		cutscenes_intermediate_timings = timings;
		return self;
	}
	
	static play_next_cutscene = function() {
		if array_length(cutscenes_intermediate) == 0 {
			return;
		}
		
		var cs = cutscenes_intermediate[cutscenes_intermediate_index];
		if !cs.been_played() {
			create_cutscene(cs);
		}
		
		cutscenes_intermediate_index += 1;
	}
	
	static pop_cutscene_timing = function() {
		if array_length(cutscenes_intermediate_timings) == 0 {
			return -1;
		}
		
		return cutscenes_intermediate_timings[cutscenes_intermediate_index];
	}
		
	static set_charging_level = function() {
		charging_level = true;
		return self;
	}
	
	static set_force_level_save = function() {
		force_level_save = true;
		return self;
	}
		
	static set_limit_spiky_in_first_wave = function() {
		limit_spiky_in_first_wave = true;
		return self;
	}
}