event_inherited();

hspd = 0;
vspd = 0;

enum e_witch_state {
	none,
	return_to_neutral,
	flying_across,
		flying_to_side,
		flying_back_across,
	flying_across_double,
	turn_to_stone,
}

enum e_witch_flying_across_type {
	at_player,
	radial,
	at_player_difficult,
	
	LAST
}

state_current = e_witch_state.none;
action_timer = new Timer(get_frames(4));
action_timer.start();

target_side_for_flyby = 1;
flyby_type_current = e_witch_flying_across_type.LAST;

default_position = get_pos(id);
var off = CAM_W * 0.3;
flyby_position_right = new Vector2(default_position.x + off, default_position.y);
flyby_position_left = new Vector2(default_position.x - off, default_position.y);

//print(flyby_position_left);
//print(flyby_position_right);

target_position = get_pos(id);
stored_position = get_pos(id);


function begin_return_to_neutral(seconds=2) {
	state_current = e_witch_state.return_to_neutral;
	action_timer.set_and_start(get_frames(seconds));
	store_position();
}

function return_to_waiting() {
	state_current = e_witch_state.none;
	action_timer.set_and_start(get_frames(random_range(3, 6)));
}

function store_position() {
	stored_position = get_pos(id);
}

function begin_random_action() {
	var available_actions = o_manager.get_level_data().witch_modes;
	var random_action = array_pick_random(available_actions);
	
	switch (random_action) {
		case e_witch_state.flying_across:
			// pick a random side to fly to
			target_side_for_flyby = choose(1, -1);
			if target_side_for_flyby == 1 {
				target_position = flyby_position_right;
			} else {
				target_position = flyby_position_left;
			}
			
			state_current = e_witch_state.flying_to_side;
			action_timer.set_and_start(get_frames(3));
			draw_scale.x = abs(draw_scale.x) * target_side_for_flyby;
			
			flyby_type_current = choose(e_witch_flying_across_type.at_player, e_witch_flying_across_type.radial, e_witch_flying_across_type.at_player_difficult);
			store_position();
		break;
	}
}