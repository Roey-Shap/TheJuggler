
function Timer(_countdown_duration, _looping=false, _countdown_function=-1) constructor {
	current_count = 0;
	countdown_duration = _countdown_duration;
	
	looping = _looping;
	countdown_function = _countdown_function;
	
	function tick() {
		current_count -= (current_count > 0) * DELTATIME;
		
		if is_done() {
			if countdown_function != -1 {
				countdown_function();
			}
			if looping {
				current_count = countdown_duration;
			}
		}
	}
	
	function start() {
		current_count = countdown_duration;
	}
	
	function is_done() {
		return current_count <= 0;
	}
	
	function get_percent_done() {
		return 1 - (current_count/countdown_duration);
	}
	
	function set_duration(duration) {
		countdown_duration = duration;
	}
}

function decrement_timer(timer) {
	return timer - ((timer > 0) * DELTATIME);
}

function get_frames(seconds) {
	return game_get_speed(gamespeed_fps) * seconds;
}