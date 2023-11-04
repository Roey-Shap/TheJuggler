game_initialize();

enum st_game_state {
	main_menu,
	playing,
	paused,
	
	LAST
}

state_game = st_game_state.main_menu;

key_accept = mb_left;

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

function create_symbol() {
	num_enemies_created_this_wave += 1;
	var random_symbol_value = irandom_range(0, 9);
	var symbol = new Symbol(random_symbol_value, symbol_type.number);
	symbol_manager.add_symbol(symbol);
}

function get_num_symbols() {
	return symbol_manager.get_num_symbols();
}

function start_next_level() {
	current_level += 1;
	current_number_of_waves = round(3 * current_level) + 4;
	start_next_wave();
}

function start_next_wave() {
	if current_wave >= current_number_of_waves {
		start_next_level();
	} else {
		current_wave += 1;
		num_enemies_created_this_wave = 0;
		num_enemies_defeated_this_wave = 0;
		var curve_value = sample_curve(cv_number_of_enemies_level_1, current_wave / current_number_of_waves);
		var curve_scale = 10 + (2 * current_level);
		current_wave_size = round(curve_value * curve_scale);
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

function handle_game_over() {
	state_game = st_game_state.main_menu;
}

function handle_fire() {
	var removed_symbol = symbol_manager.kill_first_symbol_of_value(current_fire_counter_value);
	if removed_symbol != -1 {
		num_enemies_defeated_this_wave += 1;
	}
}

function receive_click_from_face_button(value) {
	if value == 0 {
		handle_fire();
	} else {
		current_fire_counter_value = (current_fire_counter_value + 1) % 10;
	}
}

global.deltatime = 1;