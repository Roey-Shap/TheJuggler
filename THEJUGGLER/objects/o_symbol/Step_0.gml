if symbol_manager_index == 0 and array_length(o_manager.symbol_manager.active_symbols) >= o_manager.symbol_penalty_threshold-1 {
	var s = map(-2, 2, sin(current_time/100) + sin(current_time/75), 0.9, 1.1);
	draw_scale = new Vector2(s, s);
}