function game_initialize() {
	scribble_init();
	
	//window_set_fullscreen(true);
	html5_window_set_fullscreen(true);
	
	#macro DELTATIME global.deltatime
	
	room = rm_game;
}