var level_is_normal = o_manager.get_level_data().level_type == eLevelType.normal;
var over_allowed_symbols_threshold = array_length(o_manager.symbol_manager.active_symbols) >= o_manager.symbol_penalty_threshold-1;
if symbol_manager_index == 0 and !level_is_normal and over_allowed_symbols_threshold {
	var s = map(-2, 2, sin(current_time/100) + sin(current_time/75), 0.9, 1.05);
	draw_scale = new Vector2(s, s);
}