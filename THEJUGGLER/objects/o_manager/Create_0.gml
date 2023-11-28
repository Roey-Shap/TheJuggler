game_initialize();

enum st_game_state {
	main_menu,
	playing,
	paused,
	
	LAST
}

enum eWatchState {
	time,
	game
		// maybe add all of the modes, but whatever for now
}

state_watch = eWatchState.time;

enum fade_type {
	to_black,
	from_black,
	indefinite
}

fade = fade_type.from_black;
fade_timer = new Timer(get_frames(0.65));
fade_timer.start();

state_game = st_game_state.main_menu;

key_accept = mb_left;
key_back = mb_right;
key_fullscreen = ord("F");

enum events {
	killed_symbol,
	start_playing_combo_noises,
	
	LAST
}

function use_event(ev) {
	event_progression[ev] = max(1, event_progression[ev] + 1);
}

function used_event(ev) {
	return event_progression[ev] > 0;
}

event_progression = array_create(events.LAST, 0);

// Progression Tracking Variables
has_done_intro = false;
current_level = 0;				// L levels
current_number_of_waves = -1;	// each level has W waves
reset_player_position = true;

current_wave = 0;				// each wave has a number N of enemies
current_wave_size = -1;
num_enemies_created_this_wave = 0;
num_enemies_defeated_this_wave = 0;

current_score = 0;
score_previous = 0;
 
num_symbols = 0;
symbol_penalty_threshold_default = 7;
symbol_penalty_threshold = symbol_penalty_threshold_default;

between_symbols_timer = new Timer(get_frames(2));
between_symbols_timer.start();
symbol_manager = new SymbolManager();

between_symbols_error_timer = new Timer(1);

current_fire_counter_value = 0;
charge_level = 0;

watch_platforming_growth_perform_transition = false;
watch_growth_transition_timer = new Timer(get_frames(4), false, function() {
	//create_cutscene(o_manager.cs_player_becomes_juggler);
});

watch_growth_final_scale = 1.375;
obscure_screen_alpha = 0;
obscure_screen_alpha_target = 0;

in_screen_draw_surface = -1;
virtual_camera_corner = -1;
title_position = new Vector2(0, 0);
camera_offset = new Vector2(0, 0);
shake_intensity = new Vector2(0, 0);
shake_timer = new Timer(0, false, function() {
	with (o_manager) {
		camera_offset = new Vector2(0, 0);
	}
});

///@param {Struct.Vector2} intensity
///@param Int frames
function start_shake(intensity, frames) {
	if !shake_timer.is_done() {
		// add a factor of the new shake
		shake_intensity = shake_intensity.mult_add(intensity, 0.5);
	} else {		
		shake_intensity = intensity.copy();
	}
	
	shake_timer.set_and_start(max(shake_timer.current_count, frames));
}

global.lcd_shade_offset = new Vector2(6, 6);
global.lcd_alpha = 0.2;
global.lcd_alpha_large = 0.4;
symbol_draw_scale_default = 0.1;
symbol_draw_scale_platforming = 0.08;
symbol_draw_scale = symbol_draw_scale_default;

score_scale = 1;

// Firing and Symbol Tracking
current_values_in_shape = [];
current_buttons_in_shape = [];
correctly_ordered_buttons = [1, 2, 3, 6, 9, 8, 7, 5, 4];	// counter clockwise around and in
enum shape_forming_status {
	invalid,
	partial,
	full
}

function add_value_to_shape(button) {
	array_push(current_values_in_shape, button.button_value);
	array_push(current_buttons_in_shape, button);
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
				[1, 8, 3]
			];
		break;
	}

	return get_arrangement_status(current_values_in_shape, arrangements);
}

draw_flicker = new Timer(get_frames(0.5));
draw_flicker.start();
draw_str = false;
level_title_timer = new Timer(get_frames(2));

face_button_sounds = [snd_watch_beep_1, snd_watch_beep_2, snd_watch_beep_3];
face_button_sounds_shot_success = [snd_watch_beep_special_1];
face_button_sounds_shot_special = [snd_watch_beep_special_2];

consecutive_hit_sound_factor = 1;
consecutive_hit_sound_factor_max = 7;

eyes = [];
eyes_current_index = 0;
eyes_may_open = false;

//consecutive_hit_timer = new Timer(0.85, false, function() {
//	o_manager.consecutive_hit_sound_factor -= 1;
//});

function create_symbol() {
	num_enemies_created_this_wave += 1;
	var symbol = symbol_manager.generate_symbol_from_level_data(level_data[current_level]);
	//var random_symbol_value = irandom_range(0, 9);
	//var symbol = new Symbol(random_symbol_value, symbol_type.number);
	symbol_manager.add_symbol(symbol);
}

function get_num_symbols() {
	return symbol_manager.get_num_symbols();
}

function place_player_at_anchor(anchor, treat_anchor_as_bottom_right) {
	var player = instance_nearest(x, y, o_player);
	var screen = instance_nearest(x, y, o_screen);
	if treat_anchor_as_bottom_right {
		var top_left = get_pos(anchor).sub(new Vector2(screen.sprite_width, screen.sprite_height));
		player.x = top_left.x + (screen.sprite_width  * 0.5);
		player.y = top_left.y + (screen.sprite_height * 0.1);
	} else {
		player.x = anchor.x;
		player.y = anchor.y;
	}
}

function start_next_level() {
	get_level_data().play_ending_cutscene();
	
	current_level += 1;
	current_wave = 0;
	num_enemies_defeated_this_wave = 0;
	current_number_of_waves = get_level_data().number_of_waves;
	
	get_level_data().play_starting_cutscene();
	
	switch (get_level_data().level_type) {
		case eLevelType.sidescrolling:
			instance_activate_layer("SetCollision");
			var anchor = DEVELOPER_MODE and keyboard_check(ord("C"))? inst_anchor_platforming_debug : inst_anchor_platforming_level_start;
			place_player_at_anchor(anchor, false);
			layer_set_visible(layer_distort_id, true);
			layer_set_visible(layer_wave_id, true);
			
			//if last_save.level_struct.level_type == eLevelType.normal {
			//	last_save = new SavePoint(current_level, current_score);
			//}
			last_save = new SavePoint(current_level, current_score);
			
			o_player.been_take_from_GUI = true;
		break;
		
		case eLevelType.platforming:
			instance_deactivate_layer("SetCollision");
			if reset_player_position {
				reset_player_position = false;
				place_player_at_anchor(inst_anchor_screen_bottom_right, true);
			}
			
			instance_activate_object(inst_thin_plat);
			
			if get_level_data().charging_level {
				instance_deactivate_object(inst_thin_plat);			
				symbol_penalty_threshold = 25;
				between_symbols_timer.set_and_start(get_frames(0.1));
			} else {
				symbol_penalty_threshold = symbol_penalty_threshold_default;
			}
			
			// always save the current level
			last_save = new SavePoint(current_level, current_score);
			
			o_player.been_take_from_GUI = true;
		break;
		
		case eLevelType.normal:
			instance_deactivate_layer("SetCollision");
			place_player_at_anchor(inst_anchor_screen_bottom_right, true);
			
			if get_level_data().force_level_save {
				last_save = new SavePoint(current_level, current_score);
			} else {
				last_save = new SavePoint(0, 0);
			}
			
			symbol_penalty_threshold = symbol_penalty_threshold_default;
			
			o_player.been_take_from_GUI = false;
		break;
	}

	
	if isIn(get_level_data().level_type, [eLevelType.sidescrolling]) {
		//if !watch_platforming_growth_perform_transition {
		//	watch_platforming_growth_perform_transition = true;
		//	watch_growth_transition_timer.start();
		//}
	} else {
		if get_level_data().charging_level {
			symbol_manager.clear_symbols();
			with (o_witch) {
				draw_hp = true;
				hp_shown = 0;
				hp_shown_last = 0;
			}

		} else {	
			start_next_wave();
		}
	}
	
	with (o_witch) {
		reset_for_new_level();
	}
	
	level_title_timer.start();
}

function start_next_wave() {
	symbol_manager.clear_symbols();
	
	if current_wave >= current_number_of_waves {
		play_pitch_range(snd_level_complete, 1, 1);
		start_next_level();
	} else {
		play_pitch_range(snd_wave_complete, 1, 1);
		var wave_completion = current_wave / current_number_of_waves;
		current_wave += 1;
		num_enemies_created_this_wave = 0;
		num_enemies_defeated_this_wave = 0;
		var num_enemies_curve_value = sample_curve(get_num_enemies_per_wave_curve(current_level), wave_completion) + 1;
		var num_enemies_curve_scale = min(25, round(4 + (1.5 * current_level) * random_range(0.9, 1.1)));
		current_wave_size = round(num_enemies_curve_value * num_enemies_curve_scale);
		
		var base_time_between_symbols_for_wave = sample_curve(get_time_between_symbols_curve(current_level), wave_completion);
		//var base_time_curve_scale = 
		between_symbols_timer.set_duration(get_frames(base_time_between_symbols_for_wave));
		between_symbols_timer.start();
		
		if wave_completion >= get_level_data().get_next_cutscene_timing {
			get_level_data().play_next_cutscene();
		}
	}
}

function hit_player() {
	var player = instance_nearest(0, 0, o_player);
	if player != noone {
		player.hp -= 1;
		player.start_shake(new Vector2(6, 1), get_frames(0.6));
		play_sound(snd_mistake);
		if player.hp <= 0 {
			handle_game_over();
		}
		//player.take_hit();
	}
}

function create_player_platform() {
	var inst_screen = instance_nearest(0, 0, o_screen);
	var screen_dimensions = new Vector2(inst_screen.sprite_width, inst_screen.sprite_height);
	var screen_up_left = new Vector2(inst_screen.bbox_left, inst_screen.bbox_top);
	var pos = screen_up_left.mult_add(screen_dimensions, 0.5);
	pos.y += screen_dimensions.y * 0.1;
	var col = instance_create_layer(pos.x, pos.y, LAYER_WATCH_DISPLAY, o_collision_thin);
	var xscale = screen_dimensions.x / sprite_get_width(col.sprite_index);
	col.image_xscale = xscale;
}

function add_charge() {
	charge_level += 0.01 + (1/6);
	if charge_level >= 1 {
		charge_level = 0;
		symbol_manager.queue_charged_symbol();
	}
}

function handle_charged_breaking() {
	// TODO - VFX hitting witch and depleting her health
	with (o_witch) {
		take_hit();
	}
}

///@returns {Struct.LevelData}
function get_level_data() {
	return level_data[current_level];
}

function playing_normal_platforming_level() {
	return get_level_data().level_type == eLevelType.platforming;
}

function get_num_enemies_per_wave_curve(level_number) {
	//var curves = [
	//	cv_number_of_enemies_level_1,
	//	cv_number_of_enemies_level_2,
	//];
	
	//return curves[wave_number-1];
	return get_level_data().enemies_per_wave_curve;
}

function get_time_between_symbols_curve(level_number) {
	//var curves = [
	//	cv_base_time_between_symbol_per_wave_level_1,
	//	,
	//];
	
	//return curves[wave_number-1];
	return get_level_data().time_between_enemies_curve;
}

function handle_game_over() {
	var level_type = get_level_data().level_type;
	
	reset_player_position = true;
	
	var do_failure_cs = false;
	current_wave = 0;
	charge_level = 0;
	if level_type == eLevelType.normal {	
		state_game = st_game_state.main_menu;
		state_watch = eWatchState.time;
		
		if !o_player.draw_hp_as_text {
			load_level();
			
			if !cs_try_again_reluctant.been_played() {
				cs_try_again_reluctant.play();
			}
		} else {
			if !cs_try_again.been_played() {
				cs_try_again.play();
			}
			
			current_level = 0;
			current_score = 0;
		}
		
		current_fire_counter_value = 0;
	
		symbol_manager.clear_symbols();
		reset_buttons_for_shape();
	} else if level_type == eLevelType.platforming {
		load_level();
		current_fire_counter_value = 0;
		o_player.hp_max = o_player.hp_second_wave;
		symbol_manager.clear_symbols();
		reset_buttons_for_shape();
		
		do_failure_cs = true;
		with (o_witch) {
			x = default_position.x;
			y = default_position.y;
			reset_for_new_level();
			begin_return_to_neutral();
		}
		
		cs_try_again_glitch.play();
	} else if level_type == eLevelType.sidescrolling {
		with (o_player) {
			x = last_checkpoint_pos.x;
			y = last_checkpoint_pos.y;
			hspd = 0;
			vspd = 0;
		}
		
		do_failure_cs = true;
	}
	
	//if do_failure_cs {
	//	array_pick_random([
	//		cs_platforming_failure_1,
	//		//cs_platforming_failure_2,
	//		//cs_platforming_failure_3,
	//	]).play();
	//}
	
	o_player.hp = o_player.hp_max;
	
	//start_next_level();
}

function load_level() {
	
	//print(last_save);
	//print(sfmt("level: %, score: %", current_level, current_score));
	current_level = max(0, last_save.level_index-1);
	current_score = last_save.save_score;
	//if is_undefined(current_score) {
	//	print(sfmt("level: %, score: %", current_level, current_score));
	//	current_score = 0;
	//}
}

function handle_fire(button) {
	var current_fire_shape_value = get_current_shape_value();
	var num_enemies_defeated_with_this_fire = 0;
	if get_level_data().level_type == eLevelType.sidescrolling {
		var visible_numbers = ds_list_create();
		with (o_player) {
			var topleft = o_manager.virtual_camera_corner.multiply(-1);
			var screen = instance_nearest(x, y, o_screen);
			var screen_dims = new Vector2(screen.sprite_width, screen.sprite_height);
			var num_visible_numbers = collision_rectangle_list(topleft.x, topleft.y, topleft.x + screen_dims.x, topleft.y + screen_dims.y, 
															   o_symbol, false, false, visible_numbers, true);
		}
		
		var removed_number = symbol_manager.kill_closest_symbol_of_value(current_fire_counter_value, visible_numbers);
		if removed_number != noone {
			num_enemies_defeated_with_this_fire += 1;
		}
		
		
		ds_list_destroy(visible_numbers);
	} else {
		var removed_number = symbol_manager.kill_first_symbol_of_value(current_fire_counter_value);
		var removed_shape = symbol_manager.kill_first_symbol_of_value(current_fire_shape_value);
		if removed_number != noone {
			num_enemies_defeated_this_wave += 1;
			num_enemies_defeated_with_this_fire += 1;
		}
	
		if removed_shape != noone {
			num_enemies_defeated_this_wave += 1;
			num_enemies_defeated_with_this_fire += 1;
			//reset_buttons_for_shape();
		}
	}
	
	current_score += num_enemies_defeated_with_this_fire;
	if num_enemies_defeated_with_this_fire > 1 {
		current_score += 1;		// bonus for multiple enemies at once!!
	}
	
	if num_enemies_defeated_with_this_fire > 0 {
		current_score += floor(map(0, 1, consecutive_hit_sound_factor/consecutive_hit_sound_factor_max, 0, 3));	// up to +3 for keeping your time low
		//consecutive_hit_sound_factor -= 0.35;
	}
	
	if num_enemies_defeated_with_this_fire > 0 {
		consecutive_hit_sound_factor = min(consecutive_hit_sound_factor + 1, consecutive_hit_sound_factor_max);
		var fx_button = new SpriteFX(button.x, button.y, spr_fx_impact_1, 1);
		var consecutive_factor = consecutive_hit_sound_factor/consecutive_hit_sound_factor_max;
		var fx_button_scale = map(0, 1, consecutive_factor, 1, 1.5);
		fx_button.image_xscale = fx_button_scale;
		fx_button.image_yscale = fx_button_scale;
		fx_button.image_angle = irandom(359);
		fx_button.image_blend = merge_color(c_white, c_red, min(1, map(0, 0.65, consecutive_factor, 0, 1)));
		
		var dev_override = DEVELOPER_MODE and keyboard_check(vk_space);
		if used_event(events.start_playing_combo_noises) or dev_override {
			play_sound(snd_combo_test, 0.8 * consecutive_hit_sound_factor);
		}
	}
	
	if num_enemies_defeated_with_this_fire == 0 {
		play_random_sound(face_button_sounds, 0.7 * consecutive_hit_sound_factor, 0.9 * consecutive_hit_sound_factor);
	} else if num_enemies_defeated_with_this_fire == 1 {
		play_random_sound(face_button_sounds_shot_success, 0.95 * consecutive_hit_sound_factor, 1.05 * consecutive_hit_sound_factor);
	} else if num_enemies_defeated_with_this_fire == 2 {
		play_random_sound(face_button_sounds_shot_special, 0.95 * consecutive_hit_sound_factor, 1.05 * consecutive_hit_sound_factor);
	}
}

function spawn_bullet_towards_player(spawn_pos) {
	var spd = 6;
	var dir = point_direction(spawn_pos.x, spawn_pos.y, o_player.x, o_player.y);
	var bullet = fire_bullet(spawn_pos, spd, dir);
	bullet.image_blend = merge_color(c_lime, global.c_lcd_shade, 0.2);
}

function drop_bombs(num_times) {
	var bombs = array_create(num_times);
	var upper_left = o_manager.virtual_camera_corner.multiply(-1);
	var screen_dims = new Vector2(o_screen.sprite_width, o_screen.sprite_height);
	var lower_right = upper_left.add(screen_dims);
	var thin_platform = instance_nearest(x, y, o_collision_thin);
	var y_limit = thin_platform.y;
	for (var i = 0; i < num_times; i++) {
		var ran_x = irandom_range(upper_left.x + screen_dims.x * 0.1, lower_right.x - screen_dims.x * 0.1);
		var ran_y = upper_left.y - irandom_range(CAM_H * 0.65, screen_dims.y * 1.25);
		var bomb = instance_create_layer(ran_x, ran_y, LAYER_WATCH_DISPLAY, o_witch_bomb);
		bomb.y_limit = y_limit;
		bombs[i] = bomb;
	}
	
	return bombs;
}

function reset_buttons_for_shape() {
	with (o_button_parent) {
		image_blend = c_white;
	}
	
	reset_current_values_in_shape();
	
}

function reset_current_values_in_shape() {
	current_values_in_shape = [];
	current_buttons_in_shape = [];
}

function remove_value_from_shape(button) {
	var value = button.button_value;
	var index = array_find(current_values_in_shape, value);
	if index != -1 {
		array_delete(current_values_in_shape, index, 1);
		array_delete(current_buttons_in_shape, index, 1);
	}
}

function receive_click_from_face_button(button) {		
	var value = button.button_value;
	var do_normal_sounds = true;
	if value == 0 {
		handle_fire(button);
		do_normal_sounds = false;
	} else if value == 10 {
		reset_buttons_for_shape();
	} else if value <= 9 {
		if !game_is_frozen() {
			if isIn(value, current_values_in_shape) {
				button.image_blend = c_white;
				remove_value_from_shape(button);
			} else {
				button.image_blend = c_lime;
				add_value_to_shape(button);
			}		
		
			current_fire_counter_value = (current_fire_counter_value + 1) % 10;
		}
		//if get_current_shape_value() == symbol_type.LAST {
		//	reset_buttons_for_shape();
		//}
	} else if value == 15 {
		if state_watch == eWatchState.time {
			if room == rm_main_menu {
				room = rm_game;
			} else if game_is_frozen() {
				//append_cutscene([
				//	[cs_text, [
				//		"[speaker,Other]Yes, it's that button. You've got it."
				//	]]
				//], noone, true)
			} else {
				state_watch = eWatchState.game;
				state_game = st_game_state.playing;
				start_next_level();
			}
		}
	}
	
	if do_normal_sounds {
		play_random_sound(face_button_sounds, 0.85, 1.1);
	}
}

function game_is_frozen() {
	var cutscene = instance_nearest(x, y, o_cutscene);
	if cutscene != noone {
		return cutscene.freeze_battle;
	}
	
	return false;
}

function manage_fade() {
	if !fade_timer.is_done() or fade == fade_type.indefinite {
		draw_set_color(c_black);
		var a = fade_timer.get_percent_done();
		if fade == fade_type.from_black {
			a = 1 - a;
		} else if fade == fade_type.indefinite {
			//a = 1;
		}
		
		draw_set_alpha(a);
		draw_rectangle(0, 0, CAM_W, CAM_H, false);
		draw_set_alpha(1);
	}
}

function draw_circles(_x, _y, rad, number) {
	if number == 0 {
		return;
	}
	
	var prec = round_to(map(-1, 1, sin(current_time/30), 4, 32), 4);
	draw_set_circle_precision(prec);
	
	var margin = round(rad/2);
	var total_width = (number * rad * 2) + ((number - 1) * margin);
	var min_x = _x - total_width/2;
	var total_angle = min(180, number * 20);
	var cur_angle = 90 + (total_angle/2);
	var distance_from_center = (margin + rad*4);
	for (var i = 0; i < number; i++) {
		draw_set_color(c_green);
		var bob_amount = map(-1, 1, sin(20*i + (current_time / 300)), -margin/2, margin);
		var d = distance_from_center + bob_amount;
		var cx = _x + lengthdir_x(d, cur_angle);
		var cy = _y + lengthdir_y(d/3, cur_angle);
		draw_circle(cx, cy, rad, false); 
		draw_set_color(c_white);
		draw_circle(cx, cy, rad, true); 
		cur_angle -= total_angle / number;
	}
	
	draw_set_circle_precision(32);
}

active_music_track = -1;
background_music = -1;
function set_music_track(snd_index) {
	var prev_track = active_music_track;
	active_music_track = snd_index;
	
	if !audio_is_playing(active_music_track) {
		audio_stop_sound(active_music_track);
		if audio_is_playing(prev_track) {
			audio_stop_sound(prev_track);
		}
		
		//db_show(sfmt("PLAY % %", prev_track, snd_index));
		if snd_index != -1 {
			audio_play_sound(active_music_track, SND_PRIORITY_MUSIC, true);	
		}
	}
}

function SavePoint(_level_index, _score) constructor {
	level_index = _level_index;
	save_score = _score;
	level_struct = o_manager.level_data[_level_index];
}

last_save = new SavePoint(current_level, current_score);

global.deltatime = 1;
global.debug = DEVELOPER_MODE;

global._draw_sprite_ext_skew_x = array_create(4);
global._draw_sprite_ext_skew_y = array_create(4);