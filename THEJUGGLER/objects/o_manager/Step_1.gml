if keyboard_check_pressed(key_fullscreen) {
	html5_window_toggle_fullscreen();
}


if DEVELOPER_MODE {
	if keyboard_check_pressed(ord("1")) {
		DEBUG = !DEBUG;
		show_debug_overlay(DEBUG);
	}
}

if room == rm_game {
	layer_id_bg = layer_get_id("Background");
	layer_bg_element_id = layer_background_get_id(layer_id_bg);
	bg_color = layer_background_get_blend(layer_bg_element_id);
	//layer_set_visible(layer_id_bg, false);
	layer_distort_id = layer_get_id("DistortWave");
	layer_wave_id = layer_get_id("Wave");
}

INPUT_ACC = mouse_check_button_pressed(key_accept);
INPUT_BACK = mouse_check_button_pressed(key_back);