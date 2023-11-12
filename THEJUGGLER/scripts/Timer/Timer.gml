
function Timer(_countdown_duration, _looping=false, _countdown_function=-1) constructor {
	current_count = 0;
	countdown_duration = _countdown_duration;
	
	looping = _looping;
	countdown_function = _countdown_function;
	done_countdown_function = false;
	
	frames_per_second = game_get_speed(gamespeed_fps);
	
	function tick() {
		current_count -= (current_count > 0) * DELTATIME;
		
		if is_done() {
			if countdown_function != -1 and !done_countdown_function {
				countdown_function();
				done_countdown_function = true;
			}
			
			if looping {
				current_count = countdown_duration;
			}
		}
	}
	
	function start() {
		current_count = countdown_duration;
		done_countdown_function = false;
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
	
	function get_count_seconds() {
		return current_count * frames_per_second;
	}
}

function decrement_timer(timer) {
	return timer - ((timer > 0) * DELTATIME);
}

function get_frames(seconds) {
	return game_get_speed(gamespeed_fps) * seconds;
}