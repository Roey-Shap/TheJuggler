if keyboard_check_pressed(key_fullscreen) {
	html5_window_toggle_fullscreen();
}

if DEVELOPER_MODE {
	if keyboard_check_pressed(ord("1")) {
		DEBUG = !DEBUG;
		show_debug_overlay(DEBUG);
	}
}