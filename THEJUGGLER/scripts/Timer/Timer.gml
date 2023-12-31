
///@param Real countdown duration
///@param Bool looping
///@param Function End Function
function Timer(_countdown_duration, _looping=false, _countdown_function=-1) constructor {
	current_count = 0;
	countdown_duration = _countdown_duration;
	
	looping = _looping;
	countdown_function = _countdown_function;
	done_countdown_function = false;
	
	frames_per_second = game_get_speed(gamespeed_fps);
	have_started = false;
	
	function tick(step_size=1) {
		current_count -= step_size * (current_count > 0) * DELTATIME;
		
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
		have_started = true;
	}
	
	function is_done() {
		return current_count <= 0;
	}
	
	function get_percent_done() {
		return 1 - (current_count/countdown_duration);
	}
	
	function set_duration(frames) {
		countdown_duration = frames;
	}
	
	function get_count_seconds() {
		return current_count / frames_per_second;
	}
	
	function set_and_start(frames) {
		set_duration(frames);
		start();
	}
}

function decrement_timer(timer) {
	return timer - ((timer > 0) * DELTATIME);
}

function get_frames(seconds) {
	return game_get_speed(gamespeed_fps) * seconds;
}