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
	dropping_bombs,
		dropping_bombs_fly_up,
	across_swoop_attack,
		swoop_prepare,
		swoop_wait,
	turn_to_stone,
		turn_to_stone_warning,
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

thin_platform_y = -1;

default_position = get_pos(id);
var off = CAM_W * 0.2;
flyby_position_right = new Vector2(default_position.x + off, default_position.y);
flyby_position_left = new Vector2(default_position.x - off, default_position.y);

effect_timer = new Timer(get_frames(0.1));

x += CAM_W;	// start way off to the right

defaulting_to_neutral = false;

function perform_return_to_neutral() {
	percent_done = action_timer.get_percent_done();
	x = lerp(stored_position.x, default_position.x, percent_done);
	y = lerp(stored_position.y, default_position.y, percent_done);
			
	if action_timer.is_done() {
		defaulting_to_neutral = false;
		return_to_waiting();
	} else {
		image_blend = merge_color(shot_color, c_white, action_timer.get_percent_done());
	}
}

//print(flyby_position_left);
//print(flyby_position_right);

target_position = get_pos(id);
stored_position = get_pos(id);

performed_shot = false;
performed_shot_sound = false;
shots_left = 1;
shot_timer = new Timer(get_frames(1.4));
sound_shot_charge = snd_witch_shot_1_charge;
sound_shot_release = snd_witch_shot_1_release;

shot_color = global.c_magic_1;
hitbox_draw = false;

fight_start_time = current_time / 1000;

draw_custom_prev = draw_custom;
draw_custom = function(offset_pos, draw_shadow=false) {
	if hitbox_draw {
		draw_set_color(global.c_hurt);
		var prec = round_to(map(-1, 1, sin(current_time/30), 4, 32), 4);
		draw_set_circle_precision(prec);
		var rad = map(-1, 1, sin(current_time/20), 32, 48);
		draw_circle(x + offset_pos.x, y + offset_pos.y, rad, false);
		draw_set_color(c_white);
		draw_circle(x + offset_pos.x, y + offset_pos.y, rad+1, true);
		draw_set_color(c_white);
	}
	
	draw_custom_prev(offset_pos, draw_shadow);
}

drop_bombs = function() {
	var num_times = irandom_range(2, 3);
	var upper_left = o_manager.virtual_camera_corner.multiply(-1);
	var screen_dims = new Vector2(o_screen.sprite_width, o_screen.sprite_height);
	var lower_right = upper_left.add(screen_dims);
	var y_limit = thin_platform_y;
	repeat(num_times) {
		var ran_x = irandom_range(upper_left.x + screen_dims.x * 0.1, lower_right.x - screen_dims.x * 0.1);
		var ran_y = upper_left.y - irandom_range(CAM_H * 0.65, screen_dims.y * 1.25);
		var bomb = instance_create_layer(ran_x, ran_y, LAYER_WATCH_DISPLAY, o_witch_bomb);
		bomb.y_limit = y_limit;
	}
}

function begin_return_to_neutral(seconds=2) {
	state_current = e_witch_state.return_to_neutral;
	action_timer.set_and_start(get_frames(seconds));
	turn_to(sign(default_position.x - x));
	store_position();
}

function return_to_waiting() {
	state_current = e_witch_state.none;
	action_timer.set_and_start(get_frames(random_range(3, 6)));
}

function store_position() {
	stored_position = get_pos(id);
}

function turn_to(side) {
	draw_scale.x = abs(draw_scale.x) * side;
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
			
			turn_to(target_side_for_flyby);
			
			state_current = e_witch_state.flying_to_side;
			action_timer.set_and_start(get_frames(4));
			
			flyby_type_current = choose(e_witch_flying_across_type.at_player, e_witch_flying_across_type.radial);
					//omitted:
					//		e_witch_flying_across_type.at_player_difficult
			
			if flyby_type_current == e_witch_flying_across_type.radial {
				shots_left = 1;
				shot_timer.set_and_start(get_frames(1.7));
			} else if flyby_type_current == e_witch_flying_across_type.at_player_difficult {
				shots_left = 2;
				shot_timer.set_and_start(get_frames(0.5));
			} else if flyby_type_current == e_witch_flying_across_type.at_player {
				shots_left = 2;
				shot_timer.set_and_start(get_frames(0.1));
			}
			
			store_position();
		break;
		
		case e_witch_state.dropping_bombs:
			state_current = e_witch_state.dropping_bombs_fly_up;
			action_timer.set_and_start(get_frames(5));
		break;
		
		case e_witch_state.across_swoop_attack:
			state_current = e_witch_state.swoop_prepare;
			action_timer.set_and_start(get_frames(2));
			target_side_for_flyby = choose(1, -1);
			if target_side_for_flyby == 1 {
				target_position = flyby_position_right.add(new Vector2(100, 0));
			} else {
				target_position = flyby_position_left.add(new Vector2(-100, 0));
			}
			
			turn_to(target_side_for_flyby);
			
			store_position();
		break;
		
		case e_witch_state.turn_to_stone:
			print("STONE");
		break;
	}
}